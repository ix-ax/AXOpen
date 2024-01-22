using AXOpen.Base.Dialogs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components;
using System.ComponentModel;
using System.Security.Cryptography.Xml;
using System.Security.Principal;
using Serilog;
using System;
using Microsoft.AspNetCore.Identity.UI.Services;
using AXSharp.Connector.ValueTypes.Shadows;
using System.Reflection;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Proxy service for modal dialogs, where remote tasks responsible for dialogues handling are initialized.
    /// </summary>
    public class AxoDialogProxyService : IDisposable
    {
        private readonly AxoDialogContainer _dialogContainer;

        private readonly IEnumerable<ITwinObject> _observedObject;

        private volatile object _lockObject = new object();

        private Dictionary<string, DialogMonitor> _observedDialogs = new();

        private string _dialogLocatorId { get; set; }

        public List<IsDialogType> DisplayedDialogs { get; set; } = new();

        /// <summary>
        /// Creates new instance of <see cref="AxoDialogProxyService"/>, in standard case is this constructor called only once.
        /// </summary>
        /// <param name="dialogLocatorId">Id of DialogLocator. Use for identification of the service in the dailogContainer. (typical the URL of the page where the dialogue is handled)..</param>
        /// <param name="dialogContainer">Container of proxy services handled by the application over SignalR.</param>
        /// <param name="observedObjects">Twin objects that may contain invokable dialogs from the controller that are to be handled by this proxy service.</param>
        public AxoDialogProxyService(string dialogLocatorId, AxoDialogContainer dialogContainer, IEnumerable<ITwinObject> observedObjects)
        {
            _dialogLocatorId = dialogLocatorId;
            _dialogContainer = dialogContainer;
            _observedObject = observedObjects;

            _dialogContainer.DialogProxyServicesDictionary.TryAdd(_dialogLocatorId, this);
            _observedDialogs = _dialogContainer.CollectDialogsOnObjects(_observedObject);

            StartObservingDialogues();
        }

        /// <summary>
        /// Starts observing dialogue of this proxy service.
        /// </summary>
        internal void StartObservingDialogues()
        {
            foreach (var dialog in _observedDialogs)
            {
                dialog.Value.StartDialogMonitoring(_dialogLocatorId);

                dialog.Value.EventHandler_Invoke += HandleDialogInvocation_FromPlc;
                dialog.Value.EventHandler_Close += HandleDialogClosing_FromPlc;
            }
        }

        internal void StopObservingDialogues()
        {
            foreach (var dialog in _observedDialogs)
            {
                dialog.Value.StopDialogMonitoring(_dialogLocatorId);

                dialog.Value.EventHandler_Invoke -= HandleDialogInvocation_FromPlc;
                dialog.Value.EventHandler_Close -= HandleDialogClosing_FromPlc;
            }
        }

        internal event EventHandler<AxoDialogEventArgs>? EventFromPlc_DialogInvoked;

        internal event EventHandler<AxoDialogEventArgs>? EventFromPlc_DialogRemoved;

        /// <summary>
        /// Handles the invocation of the dialogue from the controller.
        /// </summary>
        /// <param name="dialog">Dialogue to be handled.</param>
        protected async void HandleDialogInvocation_FromPlc(object? sender, AxoDialogEventArgs e)
        {
            var senderAsDialogMonitor = sender as DialogMonitor;

            if (senderAsDialogMonitor != null)
            {
                lock (_lockObject)

                {
                    Log.Logger.Information($"Proxy->Plc Invoke of : {senderAsDialogMonitor.Dialog.Symbol}");

                    var exist = this.DisplayedDialogs.Any((p) => p.Symbol == e.SymbolOfDialogInstance);
                    if (!exist)
                    {
                        this.DisplayedDialogs.Add(senderAsDialogMonitor.Dialog);
                    }
                }

                EventFromPlc_DialogInvoked?.Invoke(senderAsDialogMonitor.Dialog, e);
            }
        }

        public void HandleDialogClosing_FromPlc(object? sender, AxoDialogEventArgs e)
        {
            var senderAsDialogMonitor = sender as DialogMonitor;

            if (senderAsDialogMonitor != null)
            {
                lock (_lockObject)
                {
                    Log.Logger.Information($"Proxy->Plc Closing of : {senderAsDialogMonitor.Dialog.Symbol}");

                    var exist = this.DisplayedDialogs.Any((p) => p.Symbol == senderAsDialogMonitor.Dialog.Symbol);
                    if (exist)
                    {
                        this.DisplayedDialogs.Remove(senderAsDialogMonitor.Dialog);

                        EventFromPlc_DialogRemoved?.Invoke(this, e);
                    }
                }
            }
        }

        public void RemoveDisplayedDialog(string dialogSymbol)
        {
            if (!string.IsNullOrEmpty(dialogSymbol))
            {
                lock (_lockObject)
                {
                    Log.Logger.Information($"Proxy->Plc Closing of : {dialogSymbol}");

                    var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialogSymbol);

                    if (exist)
                    {
                        var first = this.DisplayedDialogs.First((p) => p.Symbol == dialogSymbol);
                        this.DisplayedDialogs.Remove(first);

                        EventFromPlc_DialogRemoved?.Invoke(this, new AxoDialogEventArgs(dialogSymbol));
                    }
                }
            }
        }

        public bool IsDisplayedDialogWithSymbol(string dialogSymbol)
        {
            lock (_lockObject)
            {
                return this.DisplayedDialogs.Any((p) => p.Symbol == dialogSymbol);
            }
        }

        /// <summary>
        /// Releases resources related to handling and communication with the controller.
        /// </summary>
        public void Dispose()
        {
            StopObservingDialogues();

            _observedDialogs.Clear();

            Log.Logger.Information($"Proxy->Dislose {_dialogLocatorId}");
        }
    }
}
