// AXOpen.Data.blazor
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md

using System.Collections.ObjectModel;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Messaging;
using Ix.Base.Data;
using AXSharp.Connector;
using AXOpen.Core.blazor.Toaster;
using AXOpen.Core.Interfaces;
using AXOpen.Data;
using Microsoft.JSInterop;

namespace AXOpen.Core.ViewModels;

public partial class IxDataViewModel<T, O> : ObservableObject, IDataViewModel where T : IBrowsableDataObject, new() where O : class
{

    public IxDataViewModel(IRepository<T> repository, AxoDataExchange dataExchange) : base()
    {

        this.DataExchange = dataExchange;
        DataBrowser = CreateBrowsable(repository);
        Records = new ObservableCollection<IBrowsableDataObject>();
        _onlinerData = DataExchange.GetData<O>();
    }

    private readonly O _onlinerData;

    public ITwinObject OnlineData => (ITwinObject)_onlinerData;

    public ICrudDataObject CrudData { get => (ICrudDataObject)_onlinerData; }

    private DataBrowser<T> CreateBrowsable(IRepository<T> repository)
    {
        return Ix.Base.Data.DataBrowser.Factory(repository);
    }

    public DataBrowser<T> DataBrowser { get; set; }
    public AxoDataExchange DataExchange { get; }

    public List<ValueChangeItem> Changes { get; set; }

    private IBrowsableDataObject _selectedRecord;

    public IBrowsableDataObject SelectedRecord
    {
        get
        {
            return _selectedRecord;
        }

        set
        {
            if (_selectedRecord == value)
            {
                return;
            }

            CrudData.ChangeTracker.StopObservingChanges();
            _selectedRecord = value;
            if (value != null)
            {
                OnlineData.PlainToShadow(value).Wait();
                CrudData.Changes = ((Pocos.AXOpen.Data.IAxoDataEntity)_selectedRecord).Changes;
                Changes = CrudData.Changes;
            }

            CrudData.ChangeTracker.StartObservingChanges();

        }
    }

    public Task FillObservableRecordsAsync()
    {
        //let another thread to load records, we need main thread to show loading symbol in blazor page
        return Task.Run(async () =>
        {
            IsBusy = true;
            FillObservableRecords();
            IsBusy = false;
        });
    }

    public void FillObservableRecords()
    {
        Records.Clear();
        DataBrowser.Filter(FilterById, Limit, Page * Limit, SearchMode);

        foreach (var item in DataBrowser.Records)
        {
            Records.Add(item);
        }
        FilteredCount = DataBrowser.FilteredCount(FilterById, SearchMode);
    }

    public async Task Filter()
    {
        Page = 0;
        await FillObservableRecordsAsync();
    }

    public async Task RefreshFilter()
    {
        Limit = 10;
        FilterById = "";
        SearchMode = eSearchMode.Exact;
        Page = 0;
        await FillObservableRecordsAsync();
    }

    public async Task CreateNew()
    {
        var plainer = OnlineData.CreatePoco() as Pocos.AXOpen.Data.IAxoDataEntity;

        if (plainer == null)
            throw new WrongTypeOfDataObjectException(
                $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.AXOpen.Data.IAxoDataEntity)}");

        if (CreateItemId != null)
            plainer.DataEntityId = CreateItemId;

        try
        {
            DataBrowser.AddRecord((T)plainer);
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Created!", "Item was successfully created!", 10)));
        }
        catch (DuplicateIdException)
        {
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Danger", "Duplicate ID!", "Item with the same ID already exists!", 10)));
        }

        var plain = DataBrowser.FindById(plainer.DataEntityId);
        await OnlineData.PlainToShadow(plain);
        FillObservableRecords();
        CreateItemId = null;
    }

    public void Delete()
    {
        var plainer = OnlineData.CreatePoco() as Pocos.AXOpen.Data.IAxoDataEntity;

        if (plainer == null)
            throw new WrongTypeOfDataObjectException(
                $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.AXOpen.Data.IAxoDataEntity)}");

        plainer.DataEntityId = SelectedRecord.DataEntityId;

        DataBrowser.Delete((T)plainer);
        WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Deleted!", "Item was successfully deleted!", 10)));
        FillObservableRecords();
    }

    public async Task Copy()
    {
        var plainer = await OnlineData.ShadowToPlain<T>();

        if (plainer == null)
            throw new WrongTypeOfDataObjectException(
                $"POCO object of 'DataExchange._data' member must be of {nameof(Pocos.AXOpen.Data.IAxoDataEntity)}");

        if (CreateItemId != null)
        {
            plainer.DataEntityId = CreateItemId;
        }
        else
        {
            plainer.DataEntityId = $"Copy of {SelectedRecord.DataEntityId}";
        }

        try
        {
            DataBrowser.AddRecord((T)plainer);
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Copied!", "Item was successfully copied!", 10)));
        }
        catch (DuplicateIdException)
        {
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Danger", "Duplicate ID!", "Item with the same ID already exists!", 10)));
        }
        var foundPlain = DataBrowser.FindById(plainer.DataEntityId);
        await OnlineData.PlainToShadow(foundPlain);
        FillObservableRecords();
        CreateItemId = null;
    }

    public async Task Edit()
    {
        var plainer = await OnlineData.ShadowToPlain<T>();
        CrudData.ChangeTracker.SaveObservedChanges(plainer);
        DataBrowser.UpdateRecord(plainer);
        WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Edited!", "Item was successfully edited!", 10)));
        FillObservableRecords();
    }

    public async Task SendToPlc()
    {
        await OnlineData.PlainToOnline(SelectedRecord);
        WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Sended to PLC!", "Item was successfully sended to PLC!", 10)));
    }

    public async Task LoadFromPlc()
    {
        var plainer = await OnlineData.OnlineToPlain<T>();

        if (CreateItemId != null)
            plainer.DataEntityId = CreateItemId;

        try
        {
            DataBrowser.AddRecord(plainer);
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Loaded from PLC!", "Item was successfully loaded from PLC!", 10)));
        }
        catch (DuplicateIdException)
        {
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Danger", "Duplicate ID!", "Item with the same ID already exists!", 10)));
        }
        var plain = DataBrowser.FindById(plainer.DataEntityId);
        await OnlineData.PlainToShadow(plain);
        FillObservableRecords();
        CreateItemId = null;
    }

    public void ExportData()
    {
        try
        {
            var exports = this.DataBrowser.Export(p => true);

            using (var sw = new StreamWriter("wwwroot/exportData.csv"))
            {
                foreach (var item in exports)
                {
                    sw.Write(item + "\r");
                }
            }
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Exported!", "Data was successfully exported!", 10)));
        }
        catch (Exception e)
        {
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Danger", "Error!", e.Message, 10)));
        }
    }

    public void ImportData()
    {
        try
        {
            var imports = new List<string>();
            foreach (var item in File.ReadAllLines("importData.csv"))
            {
                imports.Add(item);
            }

            this.DataBrowser.Import(imports);
            this.FillObservableRecords();
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Imported!", "Data was successfully imported!", 10)));
        }
        catch (Exception e)
        {
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Danger", "Error!", e.Message, 10)));
        }
    }

    public ObservableCollection<IBrowsableDataObject> Records { get; set; }

    public int Limit { get; set; } = 10;
    public string FilterById { get; set; } = "";
    public eSearchMode SearchMode { get; set; } = eSearchMode.Exact;
    public long FilteredCount { get; set; }
    public int Page { get; set; } = 0;
    public string CreateItemId { get; set; }
    public bool IsBusy { get; set; }
}