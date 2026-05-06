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
                
                this.TriggerTask.InitializeExclusively(() => RunWithLifecycleAsync(TaskLifecycleCodes.TriggerInvoked,    TaskLifecycleCodes.TriggerFinished,    TaskLifecycleCodes.TriggerFailed,    Trigger));
                this.SetRecipeTask.InitializeExclusively(() => RunWithLifecycleAsync(TaskLifecycleCodes.SetRecipeInvoked, TaskLifecycleCodes.SetRecipeFinished, TaskLifecycleCodes.SetRecipeFailed, SetRecipe));
                this.InspectionResultTask.InitializeExclusively(() => RunWithLifecycleAsync(TaskLifecycleCodes.InspectionResultInvoked, TaskLifecycleCodes.InspectionResultFinished, TaskLifecycleCodes.InspectionResultFailed, InspectionResult));
                this.SendSpecificDataTask.InitializeExclusively(() => RunWithLifecycleAsync(TaskLifecycleCodes.SendSpecificDataInvoked, TaskLifecycleCodes.SendSpecificDataFinished, TaskLifecycleCodes.SendSpecificDataFailed, SendSpecificData));
                this.ReceiveSpecificDataTask.InitializeExclusively(() => RunWithLifecycleAsync(TaskLifecycleCodes.ReceiveSpecificDataInvoked, TaskLifecycleCodes.ReceiveSpecificDataFinished, TaskLifecycleCodes.ReceiveSpecificDataFailed, ReceiveSpecificData));
                this.SendSpecificDataAndTypesTask.InitializeExclusively(() => RunWithLifecycleAsync(TaskLifecycleCodes.SendSpecificDataAndTypesInvoked, TaskLifecycleCodes.SendSpecificDataAndTypesFinished, TaskLifecycleCodes.SendSpecificDataAndTypesFailed, SendSpecificDataTypes));
                this.TriggerWithSpecificDataTask.InitializeExclusively(() => RunWithLifecycleAsync(TaskLifecycleCodes.TriggerWithSpecificDataInvoked, TaskLifecycleCodes.TriggerWithSpecificDataFinished, TaskLifecycleCodes.TriggerWithSpecificDataFailed, TriggerWithSpecificData));
     

            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        /// Lifecycle message codes written to <c>Status.Action.Id</c> (invoked / finished)
        /// and <c>Status.Error.Id</c> (failed) by <see cref="RunWithLifecycleAsync"/>.
        /// </summary>
        internal static class TaskLifecycleCodes
        {
            public const ulong TriggerInvoked  = 1000;
            public const ulong TriggerFinished = 1001;
            public const ulong TriggerFailed   = 10000;

            public const ulong InspectionResultInvoked  = 1010;
            public const ulong InspectionResultFinished = 1011;
            public const ulong InspectionResultFailed   = 10010;

            public const ulong SetRecipeInvoked  = 1020;
            public const ulong SetRecipeFinished = 1021;
            public const ulong SetRecipeFailed   = 10020;

            public const ulong SendSpecificDataInvoked  = 1030;
            public const ulong SendSpecificDataFinished = 1031;
            public const ulong SendSpecificDataFailed   = 10030;

            public const ulong ReceiveSpecificDataInvoked  = 1040;
            public const ulong ReceiveSpecificDataFinished = 1041;
            public const ulong ReceiveSpecificDataFailed   = 10040;

            public const ulong TriggerWithSpecificDataInvoked  = 1050;
            public const ulong TriggerWithSpecificDataFinished = 1051;
            public const ulong TriggerWithSpecificDataFailed   = 10050;

            public const ulong SendSpecificDataAndTypesInvoked  = 1060;
            public const ulong SendSpecificDataAndTypesFinished = 1061;
            public const ulong SendSpecificDataAndTypesFailed   = 10060;
        }

        /// <summary>
        /// Wraps a remote-task body so the lifecycle (invoked / finished / failed)
        /// is written to the component's <c>Status.Action.Id</c> and <c>Status.Error.Id</c>.
        /// On exception the failed code is published and the original exception is rethrown.
        /// </summary>
        private async Task RunWithLifecycleAsync(ulong invokedCode, ulong finishedCode, ulong failedCode, Func<Task> body)
        {
            await Status.ActionDescription.SetAsync(GetTaskActionMessage(invokedCode));
            try
            {
                await body();
                await Status.ActionDescription.SetAsync(GetTaskActionMessage(invokedCode));
            }
            catch
            {
                await Status.ActionDescription.SetAsync(GetDefaultErrorMessage(failedCode));
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


      

        /// <summary>
        /// Resolves the text shown for an <c>Error.Id</c> failure code. Prefers
        /// the runtime details published by the failing remote task; falls back to
        /// the static error message.
        /// </summary>
        internal string GetTaskErrorMessage(ulong messageCode)
        {
            var task = GetTaskByMessageCode(messageCode);
            var runtimeMessage = task?.RemoteExceptionDetails;

            if (string.IsNullOrWhiteSpace(runtimeMessage))
            {
                runtimeMessage = task?.ErrorDetails?.LastValue;
            }

            return string.IsNullOrWhiteSpace(runtimeMessage)
                ? GetDefaultErrorMessage(messageCode)
                : runtimeMessage;
        }

        /// <summary>
        /// Resolves the text shown for an <c>Action.Id</c> lifecycle code. Pure
        /// static lookup &mdash; never reads runtime error details, so action and
        /// error descriptions stay independent.
        /// </summary>
        internal string GetTaskActionMessage(ulong messageCode)
            => GetDefaultActionMessage(messageCode);

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

        /// <summary>
        /// Returns the static text describing an <c>Action.Id</c> lifecycle code
        /// (task invoked / finished, restore, etc.). Does NOT consult error details.
        /// </summary>
        internal static string GetDefaultActionMessage(ulong messageCode)
        {
            return messageCode switch
            {
              
                TaskLifecycleCodes.TriggerInvoked                      => "TriggerTask invoked.",
                TaskLifecycleCodes.TriggerFinished                     => "TriggerTask finished.",
                TaskLifecycleCodes.InspectionResultInvoked             => "InspectionResultTask invoked.",
                TaskLifecycleCodes.InspectionResultFinished            => "InspectionResultTask finished.",
                TaskLifecycleCodes.SetRecipeInvoked                    => "SetRecipeTask invoked.",
                TaskLifecycleCodes.SetRecipeFinished                   => "SetRecipeTask finished.",
                TaskLifecycleCodes.SendSpecificDataInvoked             => "SendSpecificDataTask invoked.",
                TaskLifecycleCodes.SendSpecificDataFinished            => "SendSpecificDataTask finished.",
                TaskLifecycleCodes.ReceiveSpecificDataInvoked          => "ReceiveSpecificDataTask invoked.",
                TaskLifecycleCodes.ReceiveSpecificDataFinished         => "ReceiveSpecificDataTask finished.",
                TaskLifecycleCodes.TriggerWithSpecificDataInvoked      => "TriggerWithSpecificDataTask invoked.",
                TaskLifecycleCodes.TriggerWithSpecificDataFinished     => "TriggerWithSpecificDataTask finished.",
                TaskLifecycleCodes.SendSpecificDataAndTypesInvoked     => "SendSpecificDataAndTypesTask invoked.",
                TaskLifecycleCodes.SendSpecificDataAndTypesFinished    => "SendSpecificDataAndTypesTask finished.",
                _ => "   ",
            };
        }

        /// <summary>
        /// Returns the static text describing an <c>Error.Id</c> failure code.
        /// </summary>
        internal static string GetDefaultErrorMessage(ulong messageCode)
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

        /// <summary>
        /// Backwards-compatible alias kept for callers that still ask for a generic
        /// task-message lookup. Prefer <see cref="GetDefaultActionMessage"/> or
        /// <see cref="GetDefaultErrorMessage"/>.
        /// </summary>
        internal static string GetDefaultTaskMessage(ulong messageCode)
        {
            var action = GetDefaultActionMessage(messageCode);
            if (!string.IsNullOrWhiteSpace(action) && action != "   ")
                return action;
            return GetDefaultErrorMessage(messageCode);
        }

      
    }

    
    
}
