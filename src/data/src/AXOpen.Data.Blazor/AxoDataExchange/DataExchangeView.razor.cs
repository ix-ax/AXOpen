// axopen_data_blazor
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/inxton/axsharp/blob/dev/notices.md

using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using AXOpen.Base.Dialogs;
using AXOpen.Core;
using AXOpen.Core;
using AXOpen.Data;
using AXOpen.Data;
using AXOpen.Data;
using AXOpen.Data.Interfaces;
using AXOpen.Data.Interfaces;
using AXOpen.Data.Interfaces;
using AXOpen.Data.Query;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.Templates;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Messaging;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Operon.Components.Toast;
using System.Data.Common;
using System.IO;
using System.Security.Cryptography;
using static AXOpen.Data.DataExchangeViewModel;
using Properties = AXOpen.Data.Blazor.Properties;

namespace AXOpen.Data;

public partial class DataExchangeView : ComponentBase, IDisposable
{
    private readonly List<ColumnData> Columns = new();

    [Parameter] public DataExchangeViewModel Vm { get; set; }

    [Parameter] public string Presentation { get; set; } = "Status";

    [Parameter] public bool EnableCreate { get; set; } = false;
    [Parameter] public bool EnableCopy { get; set; } = false;
    [Parameter] public bool EnableDelete { get; set; } = false;
    [Parameter] public bool EnableSendToPlc { get; set; } = false;
    [Parameter] public bool EnableCreateNewFromPlc { get; set; } = false;

    [Parameter] public bool EnableFiltering { get; set; } = false;
    [Parameter] public bool EnableExport { get; set; } = false; 
    [Parameter] public bool EnableSorting { get; set; } = false;

    //[Parameter] public bool EnableUpdateFromPlc { get; set; } = false;

    [Parameter] public RenderFragment ChildContent { get; set; }

    [Parameter] public List<string> SortElements { get; set; } = new();

    [Parameter] public PredicateContainer ExternalPredicates { get; set; }

    public bool AdvanceFilterConfig { get; set; } = false;

    [Inject]
    private IToastService _toastService { get; set; }

    [Inject]
    private ProtectedLocalStorage ProtectedLocalStore { get; set; }

    private Guid ViewGuid { get; } = Guid.NewGuid();

    private string _inputFileId = Guid.NewGuid().ToString();

    private eOperationStatus _fileLoadingStatus = eOperationStatus.Ready;

    private PredicateContainer _lastPredicates;

    private string _ClientFolder = string.Empty;

    public string ClientFolder
    {
        get
        {
            if (string.IsNullOrEmpty(_ClientFolder)) _ClientFolder = "wwwroot/Temp/" + ViewGuid;
            return _ClientFolder;
        }
    }

    private string _ExportPath = string.Empty;

    public string ExportPath
    {
        get
        {
            if (string.IsNullOrEmpty(_ExportPath)) _ExportPath = ClientFolder + "/exportData.zip";
            return _ExportPath;
        }
    }

    private string _ImportPath = string.Empty;

    public string ImportPath
    {
        get
        {
            if (string.IsNullOrEmpty(_ImportPath)) _ImportPath = ClientFolder + "/importData.zip";
            return _ImportPath;
        }
    }

    private string _ExportDownloadUrl = string.Empty;

    public string ExportDownloadUrl
    {
        get
        {
            if (string.IsNullOrEmpty(_ExportDownloadUrl)) _ExportDownloadUrl = "/Temp/" + ViewGuid + "/exportData.zip";
            return _ExportDownloadUrl;
        }
    }

    private string ButtonOperationName { get; set; } = "";

    private int MaxPage =>
        (int)(Vm.FilteredCount % Vm.Limit == 0 ? Vm.FilteredCount / Vm.Limit - 1 : Vm.FilteredCount / Vm.Limit);

    public void AddLine(ColumnData line)
    {
        if (!Columns.Contains(line))
            Columns.Add(line);

        if (!SortElements.Contains(line.BindingValue))
            SortElements.Add(line.BindingValue);

        StateHasChanged();
    }

    public void RemoveLine(ColumnData line)
    {
        if (Columns.Contains(line))
        {
            Columns.Remove(line);
            StateHasChanged();
        }
    }

    private int mod(int x, int m)
    {
        if (m == 0) return 0; // avoid exception caused by % 0
        var r = x % m;
        return r < 0 ? r + m : r;
    }

    private async Task setSortExpresionAsync(string sortExpresion)
    {
        Vm.DefaulSorting.MemberName = sortExpresion;
        if (sortExpresion == "Default")
        {
            Vm.DefaulSorting.MemberName = ""; // natural
        }

        await Vm.FillObservableRecordsAsync();
    }

    private async Task setSortAscendingAsync()
    {
        Vm.DefaulSorting.IsAscending = !Vm.DefaulSorting.IsAscending;

        await Vm.FillObservableRecordsAsync();
    }

    public int Limit
    {
        set
        {
            Vm.Limit = value;
            Vm.UpdateObservableRecords();
        }
        get
        {
            return Vm.Limit;
        }
    }

    public int Page
    {
        set
        {
            Vm.Page = value;
            Vm.UpdateObservableRecords();
        }
        get
        {
            return Vm.Page;
        }
    }

    private async Task PageSizeAndSelectedChangedAsync(int pageSize, int selected)
    {
        Vm.Limit = pageSize;
        Vm.Page = selected;
        await Vm.FillObservableRecordsAsync();
    }

    protected override async Task OnInitializedAsync()
    {
        Vm.InjectedPredicateContainer = ExternalPredicates;

        await Vm.Filter();

        Vm.StateHasChangedDelegate = StateHasChanged;
    }

    private async Task LoadFile(InputFileChangeEventArgs e)
    {
        _fileLoadingStatus = eOperationStatus.Busy;

        try
        {
            if (!Directory.Exists(ClientFolder))
                Directory.CreateDirectory(ClientFolder);

            Console.WriteLine($"willl be imported to {ImportPath}");
            await using FileStream fs = new(ImportPath, FileMode.Create);

            await e.File.OpenReadStream().CopyToAsync(fs);

            _fileLoadingStatus = eOperationStatus.Done;
        }
        catch (Exception ex)
        {
            _toastService.AddToast(eToastType.Danger, Properties.AxOpenDataResources.Error, ex.Message, 10);
            _fileLoadingStatus = eOperationStatus.Failed;
        }
    }

    private void ClearFiles(string path)
    {
        if (Directory.Exists(path))
            Directory.Delete(path, true);
    }

    private void ClearClientFiles()
    {
        ClearFiles(ClientFolder);
        Vm.exportStatus = eOperationStatus.Ready; // reset export status
        Vm.importStatus = eOperationStatus.Ready;
        this._fileLoadingStatus = eOperationStatus.Ready;
    }

    public async Task SaveCustomExportDataAsync()
    {
        await ProtectedLocalStore.SetAsync(Vm.DataExchange.ToString(), Vm.ExportSet);
    }

    public async Task LoadCustomExportDataAsync()
    {
        try
        {
            var result = await ProtectedLocalStore.GetAsync<ExportSettings>(Vm.DataExchange.ToString());
            if (result.Success)
            {
                Vm.ExportSet = result.Value;
            }
        }
        catch (CryptographicException)
        {
            await ProtectedLocalStore.DeleteAsync(Vm.DataExchange.ToString());
        }

        StateHasChanged();
    }

    public void Dispose()
    {
        if (Vm.IsLockedByMeOrNull())
            Vm.DataExchange.SetLockedBy(null);
    }
}