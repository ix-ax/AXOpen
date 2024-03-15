// using AXOpen.Core;
// using axosimple.server.Units;
// using AXSharp.Connector;
//
// namespace axosimple.server
// {
//     public class StandardUnit
//     {
//
//         public StandardUnit(IUnit component)
//         {
//             Component = component;
//         }
//
//         public IUnit Component { get; }
//
//         public AxoTask Automat
//         {
//             get { return this.Component.GetType().GetProperty("AutomatSequence").GetValue(this?.Component) as AxoTask; }
//         }
//
//         public AxoTask Ground
//         {
//             get { return this.Component.GetType().GetProperty("GroundSequence").GetValue(this?.Component) as AxoTask; }
//         }
//
//         public AxoTask Service
//         {
//             get { return this.Component.GetType().GetProperty("ServiceMode").GetValue(this?.Component) as AxoTask; }
//         }
//
//         public eAxoTaskState GroundStatus
//         {
//             get
//             {
//                 try
//                 {
//                     return (AXOpen.Core.eAxoTaskState)Ground?.Status.LastValue;
//                 }
//                 catch
//                 {
//                     return eAxoTaskState.Disabled;
//                 }
//             }
//         }
//
//         public eAxoTaskState AutomatStatus
//         {
//             get
//             {
//                 try
//                 {
//                     return (AXOpen.Core.eAxoTaskState)Automat?.Status.LastValue;
//                 }
//                 catch
//                 {
//                     return eAxoTaskState.Disabled;
//                 }
//             }
//         }
//
//         public eAxoTaskState ServiceStatus
//         {
//             get
//             {
//                 try
//                 {
//                     return (AXOpen.Core.eAxoTaskState)Service?.Status.LastValue;
//                 }
//                 catch
//                 {
//                     return eAxoTaskState.Disabled;
//                 }
//             }
//         }
//     }
// }
