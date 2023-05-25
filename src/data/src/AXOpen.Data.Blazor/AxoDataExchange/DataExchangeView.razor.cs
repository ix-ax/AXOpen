﻿// axopen_data_blazor
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using AXOpen.Base.Data;
using AXOpen.Core;
using AXOpen.Core.blazor.Toaster;
using AXOpen.Data.Interfaces;
using AXOpen.Data;
using CommunityToolkit.Mvvm.Messaging;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;

namespace AXOpen.Data;

public partial class DataExchangeView
{
    private readonly List<ColumnData> Columns = new();

    [Parameter] public DataExchangeViewModel Vm { get; set; }

    [Parameter] public string Presentation { get; set; } = "Status";

    [Parameter] public bool ModalDataView { get; set; } = true;

    [Parameter] public bool CanExport { get; set; } = false;

    [Parameter] public RenderFragment ChildContent { get; set; }

    private Guid ViewGuid { get; } = new();
    private string Create { get; set; } = "";

    private bool isFileLoaded { get; set; } = false;
    private bool isLoadingFile { get; set; }

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
    }

    private async Task LoadFile(InputFileChangeEventArgs e)
    {
        isLoadingFile = true;
        isFileLoaded = false;

        try
        {
            await using FileStream fs = new("importData.csv", FileMode.Create);
            await e.File.OpenReadStream().CopyToAsync(fs);
        }
        catch (Exception ex)
        {
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Danger", "Error!", ex.Message, 10)));
        }

        isLoadingFile = false;
        isFileLoaded = true;
    }
}