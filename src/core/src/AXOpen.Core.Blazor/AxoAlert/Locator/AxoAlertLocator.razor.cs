using Microsoft.AspNetCore.Components;
using AXSharp.Connector;
using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Core.Blazor.AxoAlertDialog;
using Serilog;

namespace AXOpen.Core.Blazor.Dialogs
{
    public partial class AxoAlertLocator : AxoLocator
    {
        //[Parameter]
        //public bool IsScoped { get; set; }

        private AxoAlertProxyService _axoDialogProxyService { get; set; }


        protected override Task InitializeObservationHandling()
        {
            
            //if (IsScoped)
            //{
            //    AlertDialogService = _axoDialogProxyService.ScopedAlertDialogService;
            //}

            //try to acquire existing dialog service instance
            var proxyExists = DialogContainer.AlertDialogProxyServicesDictionary.TryGetValue(LocatorPath, out AxoAlertProxyService proxy);

            if (!proxyExists)
            {
                // if it does not exist, create new instance with observed objects and add it into container
                _axoDialogProxyService = new AxoAlertProxyService(LocatorPath, DialogContainer, ObservedObjects);
                DialogContainer.AlertDialogProxyServicesDictionary.TryAdd(LocatorPath, _axoDialogProxyService);
            }
            else
            {
                _axoDialogProxyService = proxy;
            }

            _axoDialogProxyService!.StartObservingAlertDialogues(LocatorGuid);

            _axoDialogProxyService.AlertDialogInvoked += OnAlertInvoked;

            return Task.CompletedTask;
        }

        private async void OnAlertInvoked(object? sender, EventArgs e)
        {
            // if alert dialog is invoked, based on UseScopedAlerts attribute call dialog on UI
            if (sender is AXOpen.Core.AxoAlert)
            {
                AXOpen.Core.AxoAlert a = (AXOpen.Core.AxoAlert)sender;

                Log.Logger.Information($"AxoAlertLocator invoking dialog: {(eAlertType)a._alertType.Cyclic} {a._title.Cyclic} {a._message.Cyclic} {a._timeToBurn.Cyclic}");

                AlertDialogService.AddAlertDialog((eAlertType)a._alertType.Cyclic, a._title.Cyclic, a._message.Cyclic, a._timeToBurn.Cyclic);

                await InvokeAsync(StateHasChanged);
            }
        }

        public override void Dispose()
        {
            if (_axoDialogProxyService != null)
            {
                _axoDialogProxyService.AlertDialogInvoked -= OnAlertInvoked;
                _axoDialogProxyService.TryDispose(LocatorGuid);
            }
        }
    }
}