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
    /// <summary>
    /// Responsible for monitoring dialog states and invoking events based on dialog interactions.
    /// </summary>
    public class AxoDialogMonitoring : IDisposable
    {
        /// <summary>
        /// Initializes a new instance of the AxoDialogMonitoring class for a specific dialog.
        /// </summary>
        /// <param name="dialog">The dialog instance to monitor.</param>
        public AxoDialogMonitoring(IsDialogType dialog)
        {
            Dialog = dialog as AxoDialogBase;
        }

        /// <summary>
        /// The dialog instance being monitored.
        /// </summary>
        internal AxoDialogBase Dialog { private set; get; }

        /// <summary>
        /// Event triggered when the dialog is invoked.
        /// </summary>
        internal event EventHandler<AxoDialogEventArgs>? EventHandler_Invoke;

        /// <summary>
        /// Event triggered when the dialog is closed.
        /// </summary>
        internal event EventHandler<AxoDialogEventArgs>? EventHandler_Close;

        /// <summary>
        /// A list of subscribers (locator IDs) monitoring the dialog.
        /// </summary>
        private List<string> _subscribers = new();

        /// <summary>
        /// Starts monitoring the dialog for the specified locator ID.
        /// </summary>
        /// <param name="locatorId">The identifier for the dialog locator initiating the monitoring.</param>
        public void StartDialogMonitoring(string locatorId)
        {
            // Add the locator ID to subscribers if not already present
            if (!_subscribers.Any(p => p == locatorId))
            {
                // Initialize dialog monitoring if this is the first subscriber
                if (_subscribers.Count < 1)
                {
                    Dialog.Initialize(() => HandleInvocation());
                    Dialog._closeSignal.ValueChangeEvent += HandleClose;
                }
                _subscribers.Add(locatorId);
            }
        }

        /// <summary>
        /// Stops monitoring the dialog for the specified locator ID.
        /// </summary>
        /// <param name="locatorId">The identifier for the dialog locator stopping the monitoring.</param>
        public void StopDialogMonitoring(string locatorId)
        {
            // Remove the locator ID from subscribers
            if (_subscribers.Any(p => p == locatorId))
            {
                _subscribers.Remove(locatorId);

                // Deinitialize dialog monitoring if there are no more subscribers
                if (_subscribers.Count < 1)
                {
                    Dialog.DeInitialize();
                    Dialog._closeSignal.ValueChangeEvent -= HandleClose;
                }
            }
        }

        /// <summary>
        /// Handles the invocation event from the dialog.
        /// </summary>
        protected async void HandleInvocation()
        {
            await Dialog.ReadAsync();

            Log.Logger.Information($"DM->Invoked {Dialog.Symbol}");

            EventHandler_Invoke?.Invoke(this, new AxoDialogEventArgs(Dialog.Symbol));
        }

        /// <summary>
        /// Handles the close event from the dialog.
        /// </summary>
        private async void HandleClose(object sender, EventArgs e)
        {
            Log.Logger.Information($"DM-> Close --> CloseValue:{Dialog._closeSignal.Cyclic.ToString()}, in {Dialog.Symbol}");

            EventHandler_Close?.Invoke(this, new AxoDialogEventArgs(Dialog.Symbol));
        }

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            // Implementation of IDisposable.Dispose to clean up any resources.
        }
    }
}
