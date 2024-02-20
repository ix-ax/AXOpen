using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Messaging.Static;
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
    /// Responsible for observing dialog states and invoking events based on dialog interactions.
    /// </summary>
    public class AxoDialogObserver : IDisposable
    {
        /// <summary>
        /// Initializes a new instance of the AxoDialogObserver class for a specific dialog.
        /// </summary>
        /// <param name="dialog">The dialog instance to monitor.</param>
        public AxoDialogObserver(AxoDialogBase dialog)
        {
            Dialog = dialog;
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
        /// A list of subscribers (locator IDs) observing the dialog.
        /// </summary>
        private List<string> _subscribers = new();

        /// <summary>
        /// A list of primitives
        /// </summary>
        private List<ITwinPrimitive> _ReadedProperties = new();

        public bool EnableLoging { set; get; }


        /// <summary>
        /// Starts observing the dialog for the specified locator ID.
        /// </summary>
        /// <param name="locatorId">The identifier for the dialog locator initiating the observing.</param>
        public void StartObservation(string locatorId)
        {
            // Add the locator ID to subscribers if not already present
            if (!_subscribers.Any(p => p == locatorId))
            {
                // Initialize dialog observing if this is the first subscriber
                if (_subscribers.Count < 1)
                {
                    LogMessage($"AxoDialogObserver starting dialog observing: {Dialog.Symbol}");

                    PropertyReadedList();

                    Dialog.Initialize(() => HandleInvocation());
                    Dialog._closeSignal.ValueChangeEvent += HandleClose;
                }
                _subscribers.Add(locatorId);
            }

        }

        private void PropertyReadedList()
        {
            if (_ReadedProperties.Count < 1)
            {

                foreach (var item in Dialog.RetrievePrimitives()) // add all primitives
                {
                    _ReadedProperties.Add(item);
                }

                foreach (var messanger in Dialog.GetDescendants<AxoMessenger>()) // remove messanger primitives
                {
                    foreach (var primitive in messanger.RetrievePrimitives())
                    {
                        _ReadedProperties.Remove(primitive);
                    }
                }

                // axo object.
                _ReadedProperties.Remove(Dialog.Identity);

                // axo task
                _ReadedProperties.Remove(Dialog.Status);
                _ReadedProperties.Remove(Dialog.IsDisabled);
                _ReadedProperties.Remove(Dialog.RemoteInvoke);
                _ReadedProperties.Remove(Dialog.RemoteRestore);
                _ReadedProperties.Remove(Dialog.RemoteAbort);
                _ReadedProperties.Remove(Dialog.RemoteResume);
                _ReadedProperties.Remove(Dialog.StartSignature);
                _ReadedProperties.Remove(Dialog.Duration);
                _ReadedProperties.Remove(Dialog.StartTimeStamp);
                _ReadedProperties.Remove(Dialog.ErrorDetails);
                _ReadedProperties.Remove(Dialog.StartSignature);

                // axo remote task       
                _ReadedProperties.Remove(Dialog.DoneSignature);
                _ReadedProperties.Remove(Dialog.IsInitialized);
                _ReadedProperties.Remove(Dialog.HasRemoteException);
                _ReadedProperties.Remove(Dialog.IsBeingCalledCounter);
            }
        }

        /// <summary>
        /// Stops observing the dialog for the specified locator ID.
        /// </summary>
        /// <param name="locatorId">The identifier for the dialog locator stopping the observing.</param>
        public void StopObservation(string locatorId)
        {
            // Remove the locator ID from subscribers
            if (_subscribers.Any(p => p == locatorId))
            {
                _subscribers.Remove(locatorId);

                // Deinitialize dialog observing if there are no more subscribers
                if (_subscribers.Count < 1)
                {
                    DisposeDialogHandling();
                }
            }
        }

        private void DisposeDialogHandling()
        {
            LogMessage($"AxoDialogObserver disposing dialog handling: {Dialog.Symbol}");
            Dialog.DeInitialize();
            Dialog._closeSignal.ValueChangeEvent -= HandleClose;
        }

        /// <summary>
        /// Handles the invocation event from the dialog.
        /// </summary>
        protected async void HandleInvocation()
        {

            if (_ReadedProperties.Count > 1)
            {
                await Dialog.GetConnector().ReadBatchAsync(_ReadedProperties);
            }
            else
            {
                await Dialog.ReadAsync();
            }

            LogMessage($"AxoDialogObserver invoke Open: {Dialog.Symbol}");

            EventHandler_Invoke?.Invoke(this, new AxoDialogEventArgs(Dialog.Symbol));
        }

        /// <summary>
        /// Handles the close event from the dialog.
        /// </summary>
        private void HandleClose(object sender, EventArgs e)
        {
            LogMessage($"AxoDialogObserver invoke Close: {Dialog._closeSignal.Cyclic.ToString()}, in {Dialog.Symbol}");

            EventHandler_Close?.Invoke(this, new AxoDialogEventArgs(Dialog.Symbol));
        }


        protected void LogMessage(string msg)
        {
            if (EnableLoging)
            {
                Log.Logger.Debug(msg);
            }
        }

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            // Implementation of IDisposable.Dispose to clean up any resources.
            DisposeDialogHandling();
        }
    }
}