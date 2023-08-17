using System;
using System.Collections.Generic;
using AXOpen.Base.Data;
using AXOpen.Data;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Data
{
    public class ValueChangeTracker
    {
        private ITwinObject VortexObject { get; set; }
        private ICrudDataObject DataObject { get; set; }
        private AuthenticationState _as { get; set; }
        public ValueChangeTracker(ICrudDataObject dataObject)
        {
            VortexObject = (ITwinObject)dataObject;
            DataObject = dataObject;
        }

        public void StartObservingChanges(AuthenticationState authenticationState)
        {
            _as = authenticationState;
            Changes = new List<ValueChangeItem>();
            VortexObject.SubscribeShadowValueChange(LogShadowChanges);
        }

        public void StopObservingChanges()
        {
            VortexObject.UnSubscribeShadowValueChange();
        }

        private void LogShadowChanges(ITwinPrimitive valueTag, object original, object newValue)
        {
            var userName = "";
            try
            {
                userName = _as.User.Identity?.Name;
            }
            catch
            {
                userName = "!failed to determine user!";    
            }
            

            Changes.Add(new ValueChangeItem()
            {
                ValueTag = new ValueItemDescriptor(valueTag),
                OldValue = original,
                NewValue = newValue,
                DateTime = DateTime.Now,
                UserName = userName
            });
        }

        public void SaveObservedChanges(IBrowsableDataObject plainObject)
        {
            foreach (var change in Changes)
            {
                AxoApplication.Current.Logger.Information($"Value change {change.ValueTag.Symbol} of {plainObject.DataEntityId} from {change.OldValue} to {change.NewValue} changed by user action.", _as.User.Identity);
            }

            if (DataObject.Changes == null)
            {
                DataObject.Changes = new List<ValueChangeItem>();
            }

            Changes.InsertRange(0, DataObject.Changes);
            ((Pocos.AXOpen.Data.IAxoDataEntity)plainObject).Changes.AddRange(Changes);

            Changes = new List<ValueChangeItem>();
        }

        private string GetUser()
        {
            var userName = "no user";

            return userName;
        }


        public void Import(IBrowsableDataObject plainObject)
        {

            var startImportTag = new ValueChangeItem()
            {
                DateTime = DateTime.Now,
                UserName = GetUser(),
                NewValue = "-Import start-",
                OldValue = "-Import start-"
            };

            var endImportTag = new ValueChangeItem()
            {
                DateTime = DateTime.Now,
                UserName = GetUser(),
                NewValue = "-Import end-",
                OldValue = "-Import end-"
            };

            ((Pocos.AXOpen.Data.IAxoDataEntity)plainObject).Changes.Add(startImportTag);
            SaveObservedChanges(plainObject);
            ((Pocos.AXOpen.Data.IAxoDataEntity)plainObject).Changes.Add(endImportTag);

        }


        private List<ValueChangeItem> Changes = new List<ValueChangeItem>();
    }
}
