using AXOpen.Base.Dialogs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components;
using System.ComponentModel;
using System.Security.Cryptography.Xml;
using System.Security.Principal;
using Serilog;
using System;

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

        private List<IsDialogType> _observedDialogs = new();

        private string _dialogLocatorId { get; set; }

        /// <summary>
        /// Count how many klient is observing this servise
        /// </summary>
        int ObservationCounter = 0;


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

            StartObservingObjectsForDialogues();
        }

        /// <summary>
        /// Starts observing dialogue of this proxy service.
        /// </summary>
        internal void StartObservingObjectsForDialogues()
        {
            ObservationCounter++;

            if (_observedObject == null || _observedObject.Count() == 0) return;

            if (_observedDialogs.Count() > 0)
            {
                return; // some other client start observation..
            }


            foreach (var item in _observedObject)
            {
                //todo -> it is needed: _dialogContainer.ObservedObjects,  are not used...
                StartObservingDialogs<IsModalDialogType>(item);
            }
            Log.Logger.Information($"Starting observation in proxy service for {_dialogLocatorId}");
        }

        internal event EventHandler<AxoDialogEventArgs>? EventFromPlc_DialogInvoked;
        internal event EventHandler<AxoDialogEventArgs>? EventFromPlc_DialogRemoved;

        /// <summary>
        /// Handles the invocation of the dialogue from the controller.
        /// </summary>
        /// <param name="dialog">Dialogue to be handled.</param>
        protected async void HandleDialogInvocation(IsDialogType dialog)
        {
            await dialog.ReadAsync();

            dialog.DialogLocatorId = _dialogLocatorId;

            lock (_lockObject)
            {
                var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialog.Symbol);
                if (!exist)
                {
                    this.DisplayedDialogs.Add(dialog);
                }
            }


            // just invoke in dialog locator state change....
            EventFromPlc_DialogInvoked?.Invoke(this, new AxoDialogEventArgs(_dialogLocatorId, dialog.Symbol));

            Log.Logger.Information($"PROXY event Invoke {dialog.Symbol}");

        }

        private void StartObservingDialogs<T>(ITwinObject observedObject) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);

            foreach (var dialog in descendants)
            {
                _observedDialogs.Add(dialog);
                dialog.Initialize(() => HandleDialogInvocation(dialog));
            }
        }


        public void RemoveDisplayedDialog(IsDialogType dialog)
        {
            lock (_lockObject)
            {
                var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialog.Symbol);
                if (exist)
                {
                    this.DisplayedDialogs.Remove(dialog);
                    EventFromPlc_DialogRemoved?.Invoke(this, new AxoDialogEventArgs(_dialogLocatorId, dialog.Symbol));
                    Log.Logger.Information($"PROXY event Remove {dialog.Symbol}");
                }
            }
        }

        public void RemoveDisplayedDialog(string dialogSymbol)
        {
            lock (_lockObject)
            {
                Log.Logger.Information($"PROXY try to remove {dialogSymbol}");

                var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialogSymbol);
                if (exist)
                {
                    var first = this.DisplayedDialogs.First((p) => p.Symbol == dialogSymbol);
                    this.DisplayedDialogs.Remove(first);
                    EventFromPlc_DialogRemoved?.Invoke(this, new AxoDialogEventArgs(_dialogLocatorId, dialogSymbol));
                    Log.Logger.Information($"PROXY event Remove {dialogSymbol}");
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

        protected IEnumerable<T> GetDescendants<T>(ITwinObject obj, IList<T> children = null) where T : class
        {
            children = children != null ? children : new List<T>();

            if (obj != null)
            {
                foreach (var child in obj.GetChildren())
                {
                    var ch = child as T;
                    if (ch != null)
                    {
                        children.Add(ch);
                    }

                    GetDescendants<T>(child, children);
                }
            }

            return children;
        }

        /// <summary>
        /// Releases resources related to handling and communication with the controller.
        /// </summary>
        public void Dispose()
        {
            ObservationCounter--;

            if (ObservationCounter < 1) // clear it only int that case when is not observed...
            {
                foreach (var dialog in _observedDialogs)
                {
                    dialog.DeInitialize();
                }
                _observedDialogs.Clear();

                Log.Logger.Information($"PROXY is disposing {_dialogLocatorId}");

            }

        }
    }
}
