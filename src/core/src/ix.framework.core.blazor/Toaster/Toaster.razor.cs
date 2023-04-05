using Microsoft.AspNetCore.Components;

namespace AXOpen.Core.blazor.Toaster
{
    public partial class Toaster : ComponentBase, IDisposable
    {
        private void ToastChanged(object? sender, EventArgs e) => InvokeAsync(StateHasChanged);

        protected override void OnInitialized()
        {
            toastService!.ToasterChanged += ToastChanged;
        }

        public void Dispose()
        {
            toastService!.ToasterChanged -= ToastChanged;
        }

        private void ClearToast(Toast toast) => toastService!.RemoveToast(toast);
    }
}
