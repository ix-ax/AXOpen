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
using System.Diagnostics.Tracing;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Responsible for observing dialog states and invoking events based on dialog interactions.
    /// </summary>
    public class AxoAlertObserver : IDisposable 
    {
        /// <summary>
        /// Initializes a new instance of the AxoDialogObserver class for a specific dialog.
        /// </summary>
        /// <param name="dialog">The dialog instance to monitor.</param>
        public AxoAlertObserver(AXOpen.Core.AxoAlert dialog)
        {
            ObservedAlert = dialog;
        }

        /// <summary>
        /// The alert toast instance being monitored.
        /// </summary>
        internal AXOpen.Core.AxoAlert ObservedAlert { private set; get; }

        /// <summary>
        /// Event triggered when the dialog is invoked.
        /// </summary>
        internal event EventHandler? EventHandler_Invoke;

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
                    LogMessage($"AxoAlertObserver observing: {ObservedAlert.Symbol}");

                    PrepareReadedPropertyList();

                    ObservedAlert.Initialize(() => HandleInvocation());
                }
                _subscribers.Add(locatorId);
            }
        }

        private void PrepareReadedPropertyList()
        {
            _ReadedProperties.Clear();

            foreach (var item in ObservedAlert.RetrievePrimitives()) // add all primitives
            {
                _ReadedProperties.Add(item);
            }

            foreach (var messanger in ObservedAlert.GetDescendants<AxoMessenger>()) // remove messanger primitives
            {
                foreach (var primitive in messanger.RetrievePrimitives())
                {
                    _ReadedProperties.Remove(primitive);
                }
            }

            // axo object.
            _ReadedProperties.Remove(ObservedAlert.Identity);

            // axo task
            _ReadedProperties.Remove(ObservedAlert.Status);
            _ReadedProperties.Remove(ObservedAlert.IsDisabled);
            _ReadedProperties.Remove(ObservedAlert.RemoteInvoke);
            _ReadedProperties.Remove(ObservedAlert.RemoteRestore);
            _ReadedProperties.Remove(ObservedAlert.RemoteAbort);
            _ReadedProperties.Remove(ObservedAlert.RemoteResume);
            _ReadedProperties.Remove(ObservedAlert.StartSignature);
            _ReadedProperties.Remove(ObservedAlert.Duration);
            _ReadedProperties.Remove(ObservedAlert.StartTimeStamp);
            _ReadedProperties.Remove(ObservedAlert.ErrorDetails);
            _ReadedProperties.Remove(ObservedAlert.StartSignature);

            // axo remote task
            _ReadedProperties.Remove(ObservedAlert.DoneSignature);
            _ReadedProperties.Remove(ObservedAlert.IsInitialized);
            _ReadedProperties.Remove(ObservedAlert.HasRemoteException);
            _ReadedProperties.Remove(ObservedAlert.IsBeingCalledCounter);
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
            LogMessage($"AxoAlertObserver disposing observation handling: {ObservedAlert.Symbol}");
            ObservedAlert.DeInitialize();
        }

        /// <summary>
        /// Handles the invocation event from the dialog.
        /// </summary>
        protected async void HandleInvocation()
        {
            if (_ReadedProperties.Count > 1)
            {
                await ObservedAlert.GetConnector().ReadBatchAsync(_ReadedProperties);
            }
            else
            {
                await ObservedAlert.ReadAsync();
            }

            LogMessage($"AxoAlertObserver invoking: {ObservedAlert.Symbol}");

            EventHandler_Invoke?.Invoke(ObservedAlert, new EventArgs());
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