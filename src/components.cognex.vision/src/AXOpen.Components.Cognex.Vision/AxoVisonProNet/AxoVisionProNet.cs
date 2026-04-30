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


          
                this.TriggerTask.InitializeExclusively(() => Trigger());
                this.SetRecipeTask.InitializeExclusively(() => SetRecipe());
                this.InspectionResultTask.InitializeExclusively(() => InspectionResult());
                this.SendSpecificDataTask.InitializeExclusively(() => SendSpecificData());
                this.ReceiveSpecificDataTask.InitializeExclusively(() => ReceiveSpecificData());
                this.SendSpecificDataAndTypesTask.InitializeExclusively(() => SendSpecificDataTypes());
                this.TriggerWithSpecificDataTask.InitializeExclusively(() => TriggerWithSpecificData());
                AttachTaskErrorMessageRefreshes();


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

            var method = container
                .GetType()
                .GetMethods(BindingFlags.Instance | BindingFlags.Public)
                .Where(m => m.Name == "PlainToOnlineAsync")
                .Select(m => new { Method = m, Params = m.GetParameters() })
                .Where(x => x.Params.Length == 2
                            && x.Params[1].ParameterType == typeof(eAccessPriority)
                            && x.Params[0].ParameterType.IsAssignableFrom(plain.GetType()))
                .Select(x => x.Method)
                .FirstOrDefault();

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
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem(GetTaskErrorMessage(10000),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem(GetTaskErrorMessage(10001),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem(GetTaskErrorMessage(10010),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem(GetTaskErrorMessage(10011),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem(GetTaskErrorMessage(10020),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem(GetTaskErrorMessage(10021),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10030, new AxoMessengerTextItem(GetTaskErrorMessage(10030),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10031, new AxoMessengerTextItem(GetTaskErrorMessage(10031),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem(GetTaskErrorMessage(10040),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem(GetTaskErrorMessage(10041),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10050, new AxoMessengerTextItem(GetTaskErrorMessage(10050),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10051, new AxoMessengerTextItem(GetTaskErrorMessage(10051),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10060, new AxoMessengerTextItem(GetTaskErrorMessage(10060),"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10061, new AxoMessengerTextItem(GetTaskErrorMessage(10061),"Check the details.")),
              

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void AttachTaskErrorMessageRefreshes()
        {
            TriggerTask.PropertyChanged += HandleTaskPropertyChanged;
            InspectionResultTask.PropertyChanged += HandleTaskPropertyChanged;
            SetRecipeTask.PropertyChanged += HandleTaskPropertyChanged;
            SendSpecificDataTask.PropertyChanged += HandleTaskPropertyChanged;
            ReceiveSpecificDataTask.PropertyChanged += HandleTaskPropertyChanged;
            TriggerWithSpecificDataTask.PropertyChanged += HandleTaskPropertyChanged;
            SendSpecificDataAndTypesTask.PropertyChanged += HandleTaskPropertyChanged;
        }

        private void HandleTaskPropertyChanged(object? sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == nameof(AXOpen.Core.AxoRemoteTask.RemoteExceptionDetails) ||
                e.PropertyName == nameof(AXOpen.Core.AxoRemoteTask.RemoteExecutionException))
            {
                InitializeMessenger();
            }
        }

        internal string GetTaskErrorMessage(ulong messageCode)
        {
            var task = GetTaskByMessageCode(messageCode);
            var runtimeMessage = task?.RemoteExceptionDetails;

            if (string.IsNullOrWhiteSpace(runtimeMessage))
            {
                runtimeMessage = task?.ErrorDetails?.LastValue;
            }

            return string.IsNullOrWhiteSpace(runtimeMessage)
                ? GetDefaultTaskMessage(messageCode)
                : runtimeMessage;
        }

        private AXOpen.Core.AxoRemoteTask? GetTaskByMessageCode(ulong messageCode)
        {
            return messageCode switch
            {
                10000 or 10001 => TriggerTask,
                10010 or 10011 => InspectionResultTask,
                10020 or 10021 => SetRecipeTask,
                10030 or 10031 => SendSpecificDataTask,
                10040 or 10041 => ReceiveSpecificDataTask,
                10050 or 10051 => TriggerWithSpecificDataTask,
                10060 or 10061 => SendSpecificDataAndTypesTask,
                _ => null,
            };
        }

        internal static string GetDefaultTaskMessage(ulong messageCode)
        {
            return messageCode switch
            {
                10000 => "TriggerTask finished with error!",
                10001 => "TriggerTask was aborted, while not yet completed!",
                10010 => "InspectionResultTask finished with error!",
                10011 => "InspectionResultTask was aborted, while not yet completed!",
                10020 => "SetRecipeTask finished with error!",
                10021 => "SetRecipeTask was aborted, while not yet completed!",
                10030 => "SendSpecificDataTask finished with error!",
                10031 => "SendSpecificDataTask was aborted, while not yet completed!",
                10040 => "ReceiveSpecificDataTask finished with error!",
                10041 => "ReceiveSpecificDataTask was aborted, while not yet completed!",
                10050 => "TriggerWithSpecificDataTask finished with error!",
                10051 => "TriggerWithSpecificDataTask was aborted, while not yet completed!",
                10060 => "SendSpecificDataAndTypesTask finished with error!",
                10061 => "SendSpecificDataAndTypesTask was aborted, while not yet completed!",
                _ => "   ",
            };
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
        public string ErrorDescription
        {
            get
            {
                if (Error == null || Error.Id == null)
                    return "   ";

                ulong messageCode = Error.Id.LastValue;

                var component = GetParent() as AxoVisionProNet;
                if (component != null)
                {
                    var taskErrorMessage = component.GetTaskErrorMessage(messageCode);
                    if (!string.IsNullOrWhiteSpace(taskErrorMessage) && taskErrorMessage != "   ")
                    {
                        return taskErrorMessage;
                    }
                }

                return AxoVisionProNet.GetDefaultTaskMessage(messageCode);
            }
        }

        public string ActionDescription
        {
            get
            {
                if (Action == null || Action.Id == null)
                    return "   ";

                ulong messageCode = Action.Id.LastValue;

                if (messageCode == 50)
                {
                    return "Restore has been executed.";
                }

                var component = GetParent() as AxoVisionProNet;
                if (component != null)
                {
                    var taskErrorMessage = component.GetTaskErrorMessage(messageCode);
                    if (!string.IsNullOrWhiteSpace(taskErrorMessage) && taskErrorMessage != "   ")
                    {
                        return taskErrorMessage;
                    }
                }

                return AxoVisionProNet.GetDefaultTaskMessage(messageCode);
            }
        }
    }
}
