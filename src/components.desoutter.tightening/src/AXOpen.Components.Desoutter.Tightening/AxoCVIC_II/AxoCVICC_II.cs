using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Numerics;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Components.Desoutter.Tightening
{
    public partial class AxoCVIC_II : AXOpen.Core.AxoComponent
    {
        public async Task WriteTaskDurationToConsole()
        {
            foreach (var task in this.GetChildren().OfType<AxoTask>())
            {
                Console.WriteLine($"{task.Symbol} : {await task.Duration.GetAsync()}");
            }
        }

        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            try
            {
                InitializeMessenger();
                InitializeTaskMessenger();
            }
            catch (Exception)
            {

                throw;
            }
        }

        private void InitializeMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,   new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                   "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `refStatus` has NULL reference in `Run` method!",                                "Check the call of the `Run` method, if the `refStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Input variable `refActScrewingProgram` has NULL reference in `Run` method!",                    "Check the call of the `Run` method, if the `refActScrewingProgram` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Input variable `refTorque` has NULL reference in `Run` method!",                                "Check the call of the `Run` method, if the `refTorque` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Input variable `refTorqueTrend` has NULL reference in `Run` method!",                           "Check the call of the `Run` method, if the `refTorqueTrend` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Input variable `refAngle` has NULL reference in `Run` method!",                                 "Check the call of the `Run` method, if the `refAngle` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Input variable `refAngleTrend` has NULL reference in `Run` method!",                            "Check the call of the `Run` method, if the `refAngleTrend` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("Input variable `refControl` has NULL reference in `Run` method!",                               "Check the call of the `Run` method, if the `refControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("Input variable `refReqScrewingProgram` has NULL reference in `Run` method!",                    "Check the call of the `Run` method, if the `refReqScrewingProgram` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("Value of the required screwing program is lower then the minimal value!",                       "Check the value of the required screwing program.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Value of the required screwing program is higher then the maximal value!",                      "Check the value of the required screwing program.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Changing of the screwing program finished with error due to timeout!",                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Screwing program finished with error due to timeout!",                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Reseting the device finished with error due to timeout!",                                           "")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(600, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(605, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(606, new AxoMessengerTextItem("   ", "   ")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
    public partial class AxoCVIC_II_ComponentStatus : AxoComponent_Status
    {
        Dictionary<uint, string> errorDescriptionDict = new Dictionary<uint, string>();
        Dictionary<uint, string> actionDescriptionDict = new Dictionary<uint, string>();

        public string ErrorDescription
        {
            get
            {
                if (errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<uint, string>(); }
                if (errorDescriptionDict.Count == 0)
                {
                    errorDescriptionDict.Add(0, "   ");
                    errorDescriptionDict.Add(600, "Waiting for the value of the `Inputs.ScrewingProgram` to be the same as the value of `Outputs.ScrewingProgram`!");
                    errorDescriptionDict.Add(601, "Waiting for the value of the `Inputs.ScrewingProgram` to be the same as the value of `Outputs.ScrewingProgram`!");
                    errorDescriptionDict.Add(602, "Waiting for the signal `Inputs.Status.Ready` to be set!");
                    errorDescriptionDict.Add(603, "Waiting for the signal `Inputs.Status.InCycle` to be reseted!");
                    errorDescriptionDict.Add(604, "Waiting for the signal `Inputs.Status.InCycle` to be set!");
                    errorDescriptionDict.Add(605, "Waiting for the signal `Inputs.Status.InCycle` to be reseted!");
                    errorDescriptionDict.Add(606, "Waiting for the the result bits: One of the signals 'Inputs.Status.Failed' or 'Inputs.Status.Passed' has to be set!");
                    errorDescriptionDict.Add(607, "Waiting for the InspectionResults to be copied!");
                    errorDescriptionDict.Add(608, "Waiting for the signal CommandExecuting to be reseted!");
                    errorDescriptionDict.Add(609, "Waiting for the signal Online to be reseted!");
                    errorDescriptionDict.Add(610, "Waiting for the signal Error to be reseted!");
                    errorDescriptionDict.Add(611, "Waiting for the Job name to be written to the User data!");
                    errorDescriptionDict.Add(612, "Waiting for the signal ExtendedUserDataSetAcknowledge to be set!");
                    errorDescriptionDict.Add(613, "Waiting for the signal ExtendedUserDataSetAcknowledge to be reseted!");
                    errorDescriptionDict.Add(614, "Waiting for the signal CommandComplete to be set!");
                    errorDescriptionDict.Add(615, "Waiting for the signal CommandComplete to be reseted!");
                    errorDescriptionDict.Add(616, "Waiting for the signal Online to be set!");
                    errorDescriptionDict.Add(617, "Waiting for the signal TriggerSoftEvent to be set!");
                    errorDescriptionDict.Add(618, "Waiting for the signal TriggerSoftEvent to be reseted!");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");



                    errorDescriptionDict.Add(700, "Error: Parent has NULL reference!");
                    errorDescriptionDict.Add(701, "Error: refStatus has NULL reference!");
                    errorDescriptionDict.Add(702, "Error: refActScrewingProgram has NULL reference!");
                    errorDescriptionDict.Add(703, "Error: refTorque has NULL reference!");
                    errorDescriptionDict.Add(704, "Error: refTorqueTrend has NULL reference!");
                    errorDescriptionDict.Add(705, "Error: refAngle has NULL reference!");
                    errorDescriptionDict.Add(706, "Error: refAngleTrend has NULL reference!");
                    errorDescriptionDict.Add(707, "Error: refControl has NULL reference!");
                    errorDescriptionDict.Add(708, "Error: refReqScrewingProgram has NULL reference!");
                    errorDescriptionDict.Add(709, "Value of the required screwing program is lower then the minimal value!");
                    errorDescriptionDict.Add(710, "Value of the required screwing program is higher then the maximal value!");
                    errorDescriptionDict.Add(711, "Changing of the screwing program finished with error due to timeout!");
                    errorDescriptionDict.Add(712, "Screwing program finished with error due to timeout!");
                    errorDescriptionDict.Add(713, "Reseting the device finished with error due to timeout!");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");

                }
                string errorDescription = "   ";

                if (Error == null || Error.Id == null )
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
                if (actionDescriptionDict == null) { actionDescriptionDict = new Dictionary<uint, string>(); }
                if (actionDescriptionDict.Count == 0)
                {
                    actionDescriptionDict.Add(0, "   ");
                    actionDescriptionDict.Add(300, "Changing program started");
                    actionDescriptionDict.Add(302, "Changing program  was completed successfully.");

                    actionDescriptionDict.Add(310, "Screwing cycle started, previous results reseted.");
                    actionDescriptionDict.Add(311, "Check if the program number is already set.");
                    actionDescriptionDict.Add(312, "Changing the required program number.");
                    actionDescriptionDict.Add(313, "Waiting for the screwdriver to be ready.");
                    actionDescriptionDict.Add(314, "Waiting for the screwing cycle running.");
                    actionDescriptionDict.Add(315, "Waiting for the screwing cycle finished.");
                    actionDescriptionDict.Add(316, "Screwing cycle was completed successfully.");
                    actionDescriptionDict.Add(317, "Screwing cycle was completed successfully.");
                    actionDescriptionDict.Add(320, "Device has been reseted successfully.");



                    actionDescriptionDict.Add(711, "Changing of the screwing program finished with error.");
                    actionDescriptionDict.Add(712, "Screwing program finished with error.");
                    actionDescriptionDict.Add(713, "Reseting the device finished with error.");
                    //actionDescriptionDict.Add(714, "");
                    //actionDescriptionDict.Add(715, "");
                    //actionDescriptionDict.Add(716, "");
                    //actionDescriptionDict.Add(717, "");


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

