using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public partial class AxoDialogLocator : ComponentBase, IDisposable
    {
        private AxoDialogProxyService _dialogProxyService { get; set; }

        [Inject]
        public AxoDialogContainer DialogContainer { get; set; }

        [Inject]
        public NavigationManager NavigationManager { get; set; }

        /// <summary>
        /// List of objects, which are observed for dialogs.
        /// Example: ObservedObjects="new[] {Entry.Plc.Context.CU0, Entry.Plc.Context.CU1}"
        /// </summary>
        [Parameter]
        public IEnumerable<ITwinObject> ObservedObjects { get; set; }

        /// <summary>
        /// Unique ID of dialog locator, which is used to synchronize dialogs across clients. Make sure you pass unique value, otherwise inconsistencies may occur.
        /// When no value provided, URI is used as a ID. 
        /// </summary>
        [Parameter]
        public string DialogLocatorId { get; set; }

        /// <summary>
        /// The opening dialog delay (default value is 0 ms).
        /// </summary>
        [Parameter]
        public int DialogOpenDelay { get; set; } = 0;


        protected override async Task OnInitializedAsync()
        {

            //initialize signalR
            DialogContainer.InitializeSignalR(NavigationManager.BaseUri);

            await DialogContainer.DialogClient.StartAsync();

            //if dialog id is null, set it to actual URI
            if (string.IsNullOrEmpty(DialogLocatorId))
            {
                DialogLocatorId = NavigationManager.Uri;
            }

            //try to acquire existing dialog service instance
            var proxyExists = DialogContainer.DialogProxyServicesDictionary.TryGetValue(DialogLocatorId, out AxoDialogProxyService proxy);

            if (!proxyExists)
            {
                // if it does not exist, create new instance with observed objects and add it into container
                _dialogProxyService = new AxoDialogProxyService(DialogLocatorId, DialogContainer,ObservedObjects); 
            }
            else
            {
                _dialogProxyService = proxy;
            }

            _dialogProxyService.DialogInvoked += OnDialogInvoked; // handle reaction on any dialog inside DialoLocator
        }

        private async void OnDialogInvoked(object? sender, AxoDialogEventArgs e)
        {
            await InvokeAsync(StateHasChanged);

            if (DialogOpenDelay > 0)
            {
                await Task.Delay(DialogOpenDelay);
            }

            //todo : what in case of multiple instancess ???
            await DialogContainer.DialogClient.SendDialogOpen(DialogLocatorId);
        }

        /// <summary>
        /// Releases communication and event resources when disposed.
        /// </summary>
        public void Dispose()
        {
            if (_dialogProxyService != null)
            {
                _dialogProxyService.DialogInvoked -= OnDialogInvoked; // unsubscribe current view 
                //_dialogProxyService.Dispose(); // Not call Dispose -> in case when you open view again....
            }
        }
    }
}
