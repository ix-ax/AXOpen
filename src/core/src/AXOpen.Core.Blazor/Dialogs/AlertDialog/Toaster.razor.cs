using Microsoft.AspNetCore.Components;
using System;

namespace AXSharp.Presentation.Blazor.Controls.Dialogs.AlertDialog
{
    public partial class Toaster : ComponentBase, IDisposable
    {
        private void ToastChanged(object? sender, EventArgs e) => InvokeAsync(StateHasChanged);

        protected override void OnInitialized()
        {
            _dialogService!.ToasterChanged += ToastChanged;
        }

        public void Dispose()
        {
            _dialogService!.ToasterChanged -= ToastChanged;
        }

        private void ClearToast(Toast toast) => _dialogService!.RemoveToast(toast);
    }
}
