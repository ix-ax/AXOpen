// axopen_data_blazor
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/inxton/axsharp/blob/dev/notices.md

using AXOpen.Base.Data;
using AXOpen.Base.Dialogs;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Data;

public partial class AxoDataPersistentExchangeView : ComponentBase, IDisposable
{
    [Parameter, EditorRequired]
    public AxoDataPersistentExchange Context { set; get; }

    [Inject]
    private IAlertService AlertDialogService { get; set; }

    public AxoDataPersistentExchangeViewModel Vm { get; set; }

    private int MaxPage =>
       (int)(Vm.FilteredCount % Vm.Limit == 0 ? Vm.FilteredCount / Vm.Limit - 1 : Vm.FilteredCount / Vm.Limit);

    protected override void OnInitialized()
    {
        Vm = new AxoDataPersistentExchangeViewModel() { Model = this.Context };
        Vm.AlertDialogService = this.AlertDialogService;

        base.OnInitialized();
    }

    protected override async Task OnInitializedAsync()
    {
        await Vm.EnsureThatAllGroupsExistInDatabase();

        await Vm.FillObservableRecordsAsync();

        Vm.StateHasChangedDelegate = StateHasChanged;
    }

    private async Task setSearchModeAsync(eSearchMode searchMode)
    {
        Vm.SearchMode = searchMode;

        await Vm.FillObservableRecordsAsync();
    }

    public int Limit
    {
        set
        {
            Vm.Limit = value;
            Vm.FillObservableRecordsAsync();
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
            Vm.FillObservableRecordsAsync();
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

    public void Dispose()
    {
    }
}