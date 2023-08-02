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

namespace AXOpen.Core.Blazor.Dialogs
{
    public partial class AxoAlertDialogLocator
    {
        [Parameter]
        public IEnumerable<ITwinObject> ObservedObjects { get; set; }

        [Parameter]
        public bool IsScoped { get; set; }

        private AxoAlertDialogProxyService _axoDialogProxyService { get; set; }

        public bool IsDialogInvoked { get; set; }

        protected override void OnInitialized()
        {
            var dialogId = NavigationManager.Uri;
            if (IsScoped)
            {
                AlertDialogService = _axoDialogProxyService.ScopedAlertDialogService;
            }
            //try to acquire existing dialog service instance
            var proxyExists = DialogContainer.AlertDialogProxyServicesDictionary.TryGetValue(dialogId, out AxoAlertDialogProxyService proxy);

            if (!proxyExists)
            {
                // if it does not exist, create new instance with observed objects and add it into container
                _axoDialogProxyService = new AxoAlertDialogProxyService(DialogContainer, ObservedObjects);
                DialogContainer.AlertDialogProxyServicesDictionary.TryAdd(dialogId, _axoDialogProxyService);
            }
            else
            {
                _axoDialogProxyService = proxy;
            }
        }
        protected override void OnAfterRender(bool firstRender)
        {
            // on first initialization, set objects for observation and subscribe to AlertDialog invoked event
            if (firstRender)
            {
                if (ObservedObjects != null)
                    _axoDialogProxyService.StartObserveObjects(ObservedObjects);

                _axoDialogProxyService.AlertDialogInvoked += OnDialogInvoked;

            }

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
            _axoDialogProxyService.AlertDialogInvoked -= OnDialogInvoked;
            _axoDialogProxyService.Dispose();
        }
    }
}
