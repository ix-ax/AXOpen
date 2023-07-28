﻿using AXOpen.Base.Abstractions.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Dialogs;
using AXSharp.Connector;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Proxy service for modal dialogs, where remote tasks responsible for dialogues handling are initilized. 
    /// </summary>
    public class AxoDialogProxyService : AxoDialogProxyServiceBase
    {
        public AxoDialogProxyService()
        {
             
        }
        private AxoDialogContainer _axoDialogContainer;
        public AxoDialogProxyService(AxoDialogContainer dialogContainer,string id, IEnumerable<ITwinObject> observedObjects)
        {
            _axoDialogContainer = dialogContainer;
            DialogServiceId = id;
            SetObservedObjects(observedObjects);
        }

        public string DialogServiceId { get; set; }

        public void SetObservedObjects(IEnumerable<ITwinObject> observedObjects)
        {
            if (observedObjects == null || observedObjects.Count() == 0) return;
            foreach (var item in observedObjects)
            {
                //check if we observing symbol, if yes, we do not have to initialize new remote tasks
                if (!_axoDialogContainer.ObservedObjects.Contains(item.Symbol))
                {
                    //create observer for this object
                    _axoDialogContainer.ObservedObjects.Add(item.Symbol);
                    UpdateDialogs<IsModalDialogType>(item);
                }
            }
          
        }
        public event EventHandler<AxoDialogEventArgs> DialogInvoked;

        protected async void Queue(IsDialogType dialog)
        {
            DialogInstance = dialog;
            DialogInstance.DialogId = DialogServiceId;
            await DialogInstance.ReadAsync();
            DialogInvoked?.Invoke(this, new AxoDialogEventArgs(DialogServiceId));
        }

        public List<string> ObservedObjects{ get; set; } = new List<string>();
        void UpdateDialogs<T>(ITwinObject observedObject) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);
            foreach (var dialog in descendants)
            {
                dialog.Initialize(() => Queue(dialog));
            }
            
        }

        

  
    }
}