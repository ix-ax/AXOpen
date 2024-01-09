using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public partial class AxoDialogLocator : ComponentBase, IDisposable
    {
        /// <summary>
        /// List of objects, which are observed for dialogs.
        /// Example: ObservedObjects="new[] {Entry.Plc.Context.CU0, Entry.Plc.Context.CU1}"
        /// </summary>
        [Parameter]
        public IEnumerable<ITwinObject> ObservedObjects { get; set; }

        /// <summary>
        /// Unique ID of dialog, which is used to synchronize dialogs across clients. Make sure you pass unique value, otherwise inconsistencies may occur.
        /// When no value provided, URI is used as a ID. 
        /// </summary>
        [Parameter]
        public string DialogId { get; set; }

        /// <summary>
        /// The opening dialog delay (default value is 0 ms).
        /// </summary>
        [Parameter]
        public int DialogOpenDelay { get; set; } = 0;

        private AxoDialogProxyService _axoDialogProxyService { get; set; }

        protected override async Task OnInitializedAsync()
        {
            //if dialog id is null, set it to actual URI
            if (string.IsNullOrEmpty(DialogId))
            {
                DialogId = _navigationManager.Uri;
            }

            //initialize signalR
            _dialogContainer.InitializeSignalR(_navigationManager.BaseUri);
            await _dialogContainer.DialogClient.StartAsync();

            //try to acquire existing dialog service instance
            var proxyExists = _dialogContainer.DialogProxyServicesDictionary.TryGetValue(DialogId, out AxoDialogProxyService proxy);

            if (!proxyExists)
            {
                // if it does not exist, create new instance with observed objects and add it into container
                _axoDialogProxyService = new AxoDialogProxyService(_dialogContainer, DialogId, ObservedObjects);
                _dialogContainer.DialogProxyServicesDictionary.TryAdd(DialogId, _axoDialogProxyService);
            }
            else
            {
                _axoDialogProxyService = proxy;
                _axoDialogProxyService?.StartObservingObjectsForDialogues();
            }

            _axoDialogProxyService.DialogInvoked += OnDialogInvoked;
        }

        private async void OnDialogInvoked(object? sender, AxoDialogEventArgs e)
        {
            await InvokeAsync(StateHasChanged);

            if (DialogOpenDelay > 0)
            {
                await Task.Delay(DialogOpenDelay);
            }

            await _dialogContainer.DialogClient.SendDialogOpen(DialogId);
        }

        /// <summary>
        /// Releases communication and event resources when disposed.
        /// </summary>
        public void Dispose()
        {
            if (_axoDialogProxyService != null)
            {
                _axoDialogProxyService.DialogInvoked -= OnDialogInvoked;
                _axoDialogProxyService.Dispose();
            }
        }
    }
}
