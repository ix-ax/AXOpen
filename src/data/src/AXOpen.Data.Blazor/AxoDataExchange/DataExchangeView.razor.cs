// axopen_data_blazor
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using AXOpen.Base.Data;
using AXOpen.Core;
using AXOpen.Data.Interfaces;
using AXOpen.Data;
using CommunityToolkit.Mvvm.Messaging;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using AXSharp.Abstractions.Dialogs.AlertDialog;
using System.IO;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using static AXOpen.Data.DataExchangeViewModel;

namespace AXOpen.Data;

public partial class DataExchangeView
{
    private readonly List<ColumnData> Columns = new();

    [Parameter] public DataExchangeViewModel Vm { get; set; }

    [Parameter] public string Presentation { get; set; } = "Status";

    [Parameter] public bool ModalDataView { get; set; } = true;

    [Parameter] public bool CanExport { get; set; } = false;

    [Parameter] public RenderFragment ChildContent { get; set; }

    [Inject]
    private IAlertDialogService _alertDialogService { get; set; }

    [Inject]
    private ProtectedLocalStorage ProtectedLocalStore { get; set; }

    private Guid ViewGuid { get; } = Guid.NewGuid();
    private string Create { get; set; } = "";

    private bool isFileImported { get; set; } = false;
    private bool isFileImporting { get; set; } = false;

    private int MaxPage =>
        (int)(Vm.FilteredCount % Vm.Limit == 0 ? Vm.FilteredCount / Vm.Limit - 1 : Vm.FilteredCount / Vm.Limit);

    public void AddLine(ColumnData line)
    {
        if (!Columns.Contains(line))
        {
            Columns.Add(line);
            StateHasChanged();
        }
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
        var r = x % m;
        return r < 0 ? r + m : r;
    }

    private async Task setSearchModeAsync(eSearchMode searchMode)
    {
        Vm.SearchMode = searchMode;

        await Vm.FillObservableRecordsAsync();
    }

    private async Task setLimitAsync(int limit)
    {
        var oldLimit = Vm.Limit;
        Vm.Limit = limit;

        Vm.Page = Vm.Page * oldLimit / Vm.Limit;

        await Vm.FillObservableRecordsAsync();
    }

    private async Task setPageAsync(int page)
    {
        Vm.Page = page;

        await Vm.FillObservableRecordsAsync();
    }

    protected override async Task OnInitializedAsync()
    {
        await Vm.FillObservableRecordsAsync();
        Vm.StateHasChangedDelegate = StateHasChanged;

    }

    private string _inputFileId = Guid.NewGuid().ToString();

    private async Task LoadFile(InputFileChangeEventArgs e)
    {
        isFileImported = false;
        isFileImporting = true;

        try
        {
            Directory.CreateDirectory("wwwroot/Temp/" + ViewGuid);

            await using FileStream fs = new("wwwroot/Temp/" + ViewGuid + "/importData.zip", FileMode.Create);
            await e.File.OpenReadStream().CopyToAsync(fs);

            isFileImported = true;
        }
        catch (Exception ex)
        {
            _alertDialogService.AddAlertDialog("Danger", "Error!", ex.Message, 10);
        }

        isFileImporting = false;
    }

    private void ClearFiles(string path)
    {
        if (Directory.Exists(path))
            Directory.Delete(path, true);
    }

    public async Task SaveCustomExportDataAsync()
    {
        await ProtectedLocalStore.SetAsync(Vm.DataExchange.ToString(), Vm.ExportSet);
    }

    public async Task LoadCustomExportDataAsync()
    {
        var result = await ProtectedLocalStore.GetAsync<ExportSettings>(Vm.DataExchange.ToString());
        if (result.Success)
        {
            Vm.ExportSet = result.Value;
        }
        StateHasChanged();
    }
}