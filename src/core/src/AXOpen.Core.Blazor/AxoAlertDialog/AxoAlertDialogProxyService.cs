﻿using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoAlertDialog
{
    /// <summary>
    /// Proxy service for alert dialogs, where remote tasks responsible for dialogues handling are initilized 
    /// </summary>
    public class AxoAlertDialogProxyService : IDisposable
    {
        private List<IsDialogType> _observedDialogs = new();

        private AxoDialogContainer _axoDialogContainer;
        public AxoAlertDialogProxyService(AxoDialogContainer dialogContainer, IEnumerable<ITwinObject> observedOjects)
        {
            _axoDialogContainer = dialogContainer;
            StartObserveObjects(observedOjects);
        }
        public IAlertDialogService ScopedAlertDialogService = new AxoAlertDialogService();
        private IEnumerable<ITwinObject> _observedObject;

        public void StartObserveObjects(IEnumerable<ITwinObject> observedObjects)
        {
            _observedObject = observedObjects;
            if (observedObjects == null || observedObjects.Count() == 0) return;
            foreach (var item in observedObjects)
            {
                _axoDialogContainer.ObservedObjectsAlerts.Add(item.Symbol);
                UpdateDialogs<IsAlertDialogType>(item);
            }

        }
        public event EventHandler<AxoDialogEventArgs> AlertDialogInvoked;

        /// <summary>
        ///  Invoked dialogues are handled within this method and subseqeuntly event is raised in application, which is then handled in UI.
        /// </summary>
        /// <param name="dialog"></param>
        protected async void Queue(IsDialogType dialog)
        {
            //DialogInstance = dialog;
            //await DialogInstance.ReadAsync();
            //AlertDialogInvoked?.Invoke(this, new AxoDialogEventArgs(string.Empty));
        }

        public List<string> ObservedObjects { get; set; } = new List<string>();
        void UpdateDialogs<T>(ITwinObject observedObject) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);
            foreach (var dialog in descendants)
            {
                dialog.Initialize(() => Queue(dialog));
                _observedDialogs.Add(dialog);
            }

        }

        public void Dispose()
        {
            foreach (var dialog in _observedDialogs)
            {
                dialog.DeInitialize();
            }
            _observedDialogs.Clear();
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
    }
}
