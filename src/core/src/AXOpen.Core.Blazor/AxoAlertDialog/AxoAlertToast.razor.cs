using Microsoft.AspNetCore.Components;
using System;

namespace AXOpen.Core.Blazor.AxoAlertDialog
{
    public partial class AxoAlertToast : ComponentBase, IDisposable
    {
        private void AlertDialogChanged(object? sender, EventArgs e) => InvokeAsync(StateHasChanged);

        protected override void OnInitialized()
        {
            if(_parameterDialogService != null)
            {
                _dialogService = _parameterDialogService;
            }
            _dialogService!.AlertDialogChanged += AlertDialogChanged;
        }

        public void Dispose()
        {
            _dialogService!.AlertDialogChanged -= AlertDialogChanged;
        }

    }
}
