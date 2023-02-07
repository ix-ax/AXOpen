using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace ix_draft_blazor
{
    public class ToastManager
    {
        private readonly Lazy<Task<IJSObjectReference>> moduleTask;

        public ToastManager(IJSRuntime jsRuntime)
        {
            moduleTask = new(() => jsRuntime.InvokeAsync<IJSObjectReference>(
               "import", "./js/Toast.js").AsTask());
        }

        public async void addToast(string type, string message)
        {
            var module = await moduleTask.Value;

            await module.InvokeAsync<string>("addToast", new string[] { message, type });
        }
    }
}
