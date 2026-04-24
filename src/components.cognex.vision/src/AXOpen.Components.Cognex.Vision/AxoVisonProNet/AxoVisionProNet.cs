using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace AXOpen.Components.Cognex.Vision
{
    public partial class AxoVisionProNet
    {
        private ITwinObject? _specificDataContainer;
        private bool _specificDataContainerResolved;

        public ITwinObject? SpecificDataContainer
        {
            get
            {
                if (!_specificDataContainerResolved)
                {
                    _specificDataContainer = FindChildDerivedFrom(typeof(AxoVisionProNetSpecificDataContainer<,>));
                    _specificDataContainerResolved = true;
                }

                return _specificDataContainer;
            }
        }

        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            try
            {
                InitializeMessenger();
                InitializeTaskMessenger();


          
                this.TriggerTask.Initialize(() => Trigger());
                this.InspectionResultTask.Initialize(() => InspectionResult());
                this.SendSpecificDataTask.Initialize(() => SendSpecificData());
                this.SetRecipeTask.Initialize(() => SetRecipe());
                
            }
            catch (Exception)
            {
                throw;
            }
        }
        


     

        private static void CollectAllPrimitives(ITwinObject current, List<ITwinPrimitive> result)
        {
            // Collect primitive value tags at this level
            foreach (var tag in current.GetValueTags())
            {
                result.Add(tag);
            }

            // Recurse into child ITwinObjects
            foreach (var child in current.GetChildren())
            {
                CollectAllPrimitives(child, result);
            }
        }
        /// <summary>
        /// Gets the <see cref="AxoVisionProNetSpecificData"/> from the container's DataEntity property.
        /// </summary>
        public AxoVisionProNetSpecificData? DataEntity
        {
            get
            {
                var container = SpecificDataContainer;
                if (container == null) return null;

                var prop = container.GetType().GetProperty("DataEntity");
                return prop?.GetValue(container) as AxoVisionProNetSpecificData;
            }
        }

        /// <summary>
        /// Gets the data entity with both online and plain representations from the container.
        /// </summary>
        public async Task<(AxoVisionProNetSpecificData Online,Pocos.AXOpen.Components.Cognex.Vision.AxoVisionProNetSpecificData Plain)?> GetDataAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            var container = SpecificDataContainer;
            if (container == null) return null;

            var method = container.GetType().GetMethod("GetDataAsync");
            if (method == null) return null;

            var taskObj = method.Invoke(container, new object[] { priority });
            if (taskObj is not Task task) return null;

            await task.ConfigureAwait(false);

            var resultProp = task.GetType().GetProperty("Result");
            var result = resultProp?.GetValue(task);
            if (result == null) return null;

            var tupleType = result.GetType();
            var online = tupleType.GetField("Item1")?.GetValue(result) as AxoVisionProNetSpecificData;
            var plain = tupleType.GetField("Item2")?.GetValue(result) as Pocos.AXOpen.Components.Cognex.Vision.AxoVisionProNetSpecificData;

            if (online == null) return null;
            return (online, plain!);
        }

        /// <summary>
        /// Gets the plain data from the specific data container by reading from the PLC.
        /// </summary>
        public async Task<object?> GetPlainDataAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            var container = SpecificDataContainer;
            if (container == null) return null;

            var method = container.GetType().GetMethod("GetPlainDataAsync");
            if (method == null) return null;

            var taskObj = method.Invoke(container, new object[] { priority });
            if (taskObj is not Task task) return null;

            await task.ConfigureAwait(false);

            var resultProp = task.GetType().GetProperty("Result");
            return resultProp?.GetValue(task);
        }

        /// <summary>
        /// Writes plain data back to the PLC via the specific data container.
        /// </summary>
        public async Task PlainToOnlineAsync(object plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            var container = SpecificDataContainer;
            if (container == null) return;

            var method = container.GetType().GetMethod("PlainToOnlineAsync");
            if (method == null) return;

            var taskObj = method.Invoke(container, new object[] { plain, priority });
            if (taskObj is Task task)
                await task.ConfigureAwait(false);
        }

        private ITwinObject? FindChildDerivedFrom(Type openGenericBase)
        {
            for (var type = GetType(); type != null; type = type.BaseType)
            {
                var properties = type.GetProperties(
                    BindingFlags.Public | BindingFlags.NonPublic |
                    BindingFlags.Instance | BindingFlags.DeclaredOnly);

                foreach (var prop in properties)
                {
                    if (!prop.CanRead || prop.GetIndexParameters().Length > 0)
                        continue;

                    if (DerivesFromOpenGeneric(prop.PropertyType, openGenericBase))
                        return prop.GetValue(this) as ITwinObject;
                }
            }

            return null;
        }

        private static bool DerivesFromOpenGeneric(Type type, Type openGenericBase)
        {
            // Walk base types
            for (var t = type; t != null; t = t.BaseType)
            {
                if (t.IsGenericType && t.GetGenericTypeDefinition() == openGenericBase)
                    return true;
            }

            // Walk interfaces
            foreach (var iface in type.GetInterfaces())
            {
                if (iface.IsGenericType && iface.GetGenericTypeDefinition() == openGenericBase)
                    return true;
            }

            return false;
        }

        private void InitializeMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,   new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.","")),
              

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
              


        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoVisionProNet_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
    {
        Dictionary<ulong, string> errorDescriptionDict = new Dictionary<ulong, string>();
        Dictionary<ulong, string> actionDescriptionDict = new Dictionary<ulong, string>();

        public string ErrorDescription
        {
            get
            {
                if (errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<ulong, string>(); }
                if (errorDescriptionDict.Count == 0)
                {
                    errorDescriptionDict.Add(0, "   ");
                                                                                     
                }
                string errorDescription = "   ";

                if (Error == null || Error.Id == null)
                    return errorDescription;

                if (errorDescriptionDict.TryGetValue(Error.Id.Cyclic, out errorDescription))
                {
                    return errorDescription;
                }
                else

                {
                    return "   ";
                }
            }
        }

        public string ActionDescription
        {
            get
            {
                if (actionDescriptionDict == null) { actionDescriptionDict = new Dictionary<ulong, string>(); }
                if (actionDescriptionDict.Count == 0)
                {
                    actionDescriptionDict.Add(0, "   ");
                    actionDescriptionDict.Add(50, "Restore has been executed.");
                 
                }

                string actionDescription = "   ";

                if (Action == null || Action.Id == null)
                    return actionDescription;

                if (actionDescriptionDict.TryGetValue(Action.Id.Cyclic, out actionDescription))
                {
                    return actionDescription;
                }
                else
                {
                    return "   ";
                }
            }
        }
    }
}
