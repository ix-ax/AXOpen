using Microsoft.AspNetCore.Components;

namespace ix_draft_blazor.Shared
{
    public partial class Toaster : ComponentBase, IDisposable
    {
        private void ToastChanged(object? sender, EventArgs e) => InvokeAsync(StateHasChanged);

        protected override void OnInitialized()
        {
            ToastService!.ToasterChanged += ToastChanged;
        }

        public void Dispose()
        {
            ToastService!.ToasterChanged -= ToastChanged;
        }

        private void ClearToast(Toast toast) => ToastService!.RemoveToast(toast);

    }
}
