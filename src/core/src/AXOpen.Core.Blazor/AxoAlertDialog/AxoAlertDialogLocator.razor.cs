using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Core.Blazor.AxoAlertDialog;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Core.Blazor.Dialogs
{
    public partial class AxoAlertDialogLocator : ComponentBase, IDisposable
    {
        [Inject]
        public NavigationManager NavigationManager {  get; set; }
        [Inject]    
        public IAlertDialogService AlertDialogService { get; set; }
        [Inject]    
        public AxoDialogContainer DialogContainer { get; set; }


        [Parameter, EditorRequired]
        public IEnumerable<ITwinObject> ObservedObjects { get; set; }

        //[Parameter]
        //public bool IsScoped { get; set; }

        /// <summary>
        /// A unique GUID for the alert dialog locator instance, used for internal management and event subscription.
        /// </summary>
        public Guid LocatorGuid { get; private set; } = Guid.NewGuid();

        /// <summary>
        /// A unique identifier for the dialog locator, typically based on the URL of the page.
        /// This ensures dialogues are synchronized across different instances.
        /// </summary>
        [Parameter]
        public string DialogLocatorPath { get; set; }

        private AxoAlertDialogProxyService _axoDialogProxyService { get; set; }

        public bool IsDialogInvoked { get; set; }
      
        protected override void OnAfterRender(bool firstRender)
        {
            if (firstRender)
            {
                InitializeDialogsHandling();
            }
        }

        private void InitializeDialogsHandling()
        {
            if (string.IsNullOrEmpty(DialogLocatorPath))
            {
                DialogLocatorPath = NavigationManager.Uri;
            }

            //if (IsScoped)
            //{
            //    AlertDialogService = _axoDialogProxyService.ScopedAlertDialogService;
            //}

            //try to acquire existing dialog service instance
            var proxyExists = DialogContainer.AlertDialogProxyServicesDictionary.TryGetValue(DialogLocatorPath, out AxoAlertDialogProxyService proxy);

            if (!proxyExists)
            {
                // if it does not exist, create new instance with observed objects and add it into container
                _axoDialogProxyService = new AxoAlertDialogProxyService(LocatorGuid, DialogContainer, ObservedObjects);
                DialogContainer.AlertDialogProxyServicesDictionary.TryAdd(DialogLocatorPath, _axoDialogProxyService);
            }
            else
            {
                _axoDialogProxyService = proxy;
                _axoDialogProxyService.StartObservingAlertDialogues(LocatorGuid);
            }

            _axoDialogProxyService.AlertDialogInvoked += OnDialogInvoked;

        }

        private async void OnDialogInvoked(object? sender, AxoDialogEventArgs e)
        {
            // if alert dialog is invoked, based on UseScopedAlerts attribute call dialog on UI
            if (_axoDialogProxyService.DialogInstance is AXOpen.Core.AxoAlertDialog)
            {
                IsDialogInvoked = true;
                AXOpen.Core.AxoAlertDialog a = (AXOpen.Core.AxoAlertDialog)_axoDialogProxyService.DialogInstance;

                AlertDialogService.AddAlertDialog((eAlertDialogType)a._dialogType.Cyclic, a._title.Cyclic, a._message.Cyclic, a._timeToBurn.Cyclic);

                await InvokeAsync(StateHasChanged);
                IsDialogInvoked = false;
            }

        }

        public void Dispose()
        {
            if (_axoDialogProxyService != null)
            {
                _axoDialogProxyService.AlertDialogInvoked -= OnDialogInvoked;
                _axoDialogProxyService.TryDispose(LocatorGuid);
            }
        }
    }
}
