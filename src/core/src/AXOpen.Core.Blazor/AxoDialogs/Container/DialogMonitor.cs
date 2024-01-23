using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Serilog;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public class DialogMonitor : IDisposable
    {
        public DialogMonitor(IsDialogType dialog)
        {
            Dialog = dialog as AxoDialogBase;
        }

        internal AxoDialogBase Dialog { private set; get; }

        internal event EventHandler<AxoDialogEventArgs>? EventHandler_Invoke;

        internal event EventHandler<AxoDialogEventArgs>? EventHandler_Close;

        private List<string> _subscribers = new();

        

        public void StartDialogMonitoring(string locatorId)
        {
            if (!_subscribers.Any(p => p == locatorId))
            {
                if (_subscribers.Count < 1)
                {
                    Dialog.Initialize(() => HandleInvocation());
                    Dialog._closeSignal.ValueChangeEvent += HandleClose;
                }
                this._subscribers.Add(locatorId);
            }
        }

        public void StopDialogMonitoring(string locatorId)
        {
            if (_subscribers.Any(p => p == locatorId))
            {
                this._subscribers.Remove(locatorId);

                if (_subscribers.Count < 1)
                {
                    Dialog.DeInitialize();
                    Dialog._closeSignal.ValueChangeEvent -= HandleClose;
                }
            }
        }

        protected async void HandleInvocation()
        {
            await Dialog.ReadAsync();

            Log.Logger.Information($"DM->Invoked {Dialog.Symbol}");

            EventHandler_Invoke?.Invoke(this, new AxoDialogEventArgs(Dialog.Symbol));
        }

        private async void HandleClose(object sender, EventArgs e)
        {
            Log.Logger.Information($"DM-> Close --> CloseValue:{Dialog._closeSignal.Cyclic.ToString()}, in {Dialog.Symbol}");

            EventHandler_Close?.Invoke(this, new AxoDialogEventArgs(Dialog.Symbol));
        }

        public void Dispose()
        {
        }
    }
}