using System;
using System.Collections.Generic;
using Ix.Base.Data;
using AXOpen.Data;
using AXSharp.Connector;

namespace AXOpen.Data
{
    public class ValueChangeTracker
    {
        private ITwinObject VortexObject { get; set; }
        private ICrudDataObject DataObject { get; set; }
        public ValueChangeTracker(ICrudDataObject dataObject)
        {
            VortexObject = (ITwinObject)dataObject;
            DataObject = dataObject;
        }

        public void StartObservingChanges()
        {
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
                // TODO: determine current user name
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
                // TODO: Log value change
            }

            if (DataObject.Changes == null)
            {
                DataObject.Changes = new List<ValueChangeItem>();
            }

            Changes.AddRange(DataObject.Changes);
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
