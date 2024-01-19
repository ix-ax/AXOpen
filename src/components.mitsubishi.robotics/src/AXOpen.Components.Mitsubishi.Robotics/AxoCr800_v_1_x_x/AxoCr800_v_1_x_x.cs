using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;

namespace AXOpen.Components.Mitsubishi.Robotics
{
    public partial class AxoCr800_v_1_x_x : AXOpen.Core.AxoComponent
    {
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `refInputs` has NULL reference in `Run` method!",                                "Check the call of the `Run` method, if the `refInputs` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Input variable `refOutputs` has NULL reference in `Run` method!",                               "Check the call of the `Run` method, if the `refOutputs` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Start at main finished with error!",                                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Start motors and program finished with error!",                                                 "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Stop movement finished with error!",                                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Stop movement and program finished with error!",                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("Start movement finished with error!",                                                           "")),

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
    public partial class AxoMitsubishiRobotics_Component_Status_v_1_x_x : AXOpen.Components.Robotics.AxoRobot_Status
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
                    errorDescriptionDict.Add(600, "Waiting for the signal `Inputs.AutoEnable` to be set!");
                    errorDescriptionDict.Add(601, "Waiting for the signal `Inputs.OperationEnable` to be set!");
                    errorDescriptionDict.Add(602, "Waiting for the signal `Inputs.ErrorReset` to be reseted!");
                    errorDescriptionDict.Add(603, "Waiting for the signal `Inputs.EmergencyError` to be reseted!");
                    errorDescriptionDict.Add(604, "Waiting for the signal `Inputs.ProgramReset` to be set!");

                    errorDescriptionDict.Add(610, "Waiting for the signal `Inputs.AutoEnable` to be set!");
                    errorDescriptionDict.Add(611, "Waiting for the signal `Inputs.OperationEnable` to be set!");
                    errorDescriptionDict.Add(612, "Waiting for the signal `Inputs.ErrorReset` to be reseted!");
                    errorDescriptionDict.Add(613, "Waiting for the signal `Inputs.EmergencyError` to be reseted!");
                    errorDescriptionDict.Add(614, "Waiting for the signal `Inputs.ServoOn` to be set!");
                    errorDescriptionDict.Add(615, "Waiting for the signal `Inputs.ErrorReset` to be reseted!");
                    errorDescriptionDict.Add(616, "Waiting for the signal `Inputs.Start` to be set!");
                    errorDescriptionDict.Add(617, "Waiting for the signal `Inputs.ErrorReset` to be reseted!");

                    errorDescriptionDict.Add(620, "Waiting for the signal `Inputs.AutoEnable` to be set!");
                    errorDescriptionDict.Add(621, "Waiting for the signal `Inputs.OperationEnable` to be set!");
                    errorDescriptionDict.Add(622, "Waiting for the signal `Inputs.Stop` to be set!");

                    errorDescriptionDict.Add(630, "Waiting for the signal `Inputs.AutoEnable` to be set!");
                    errorDescriptionDict.Add(631, "Waiting for the signal `Inputs.OperationEnable` to be set!");
                    errorDescriptionDict.Add(632, "Waiting for the signal `Inputs.Stop` to be set!");

                    errorDescriptionDict.Add(640, "Waiting for the signal `Inputs.AutoEnable` to be set!");
                    errorDescriptionDict.Add(641, "Waiting for the signal `Inputs.OperationEnable` to be set!");
                    errorDescriptionDict.Add(642, "Waiting for the signal `Inputs.ServoOn` to be set!");
                    errorDescriptionDict.Add(643, "Waiting for the signal `Inputs.ErrorReset` to be reseted!");
                    errorDescriptionDict.Add(644, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(645, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(646, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(647, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(648, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(649, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(650, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(651, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(652, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(653, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");


                    errorDescriptionDict.Add(700, "Error: Parent has NULL reference!");
                    errorDescriptionDict.Add(701, "Error: refInputs has NULL reference!");
                    errorDescriptionDict.Add(702, "Error: refOutputs has NULL reference!");
                    errorDescriptionDict.Add(703, "Start at main finished with error!");
                    errorDescriptionDict.Add(704, "Start motors and program finished with error!");
                    errorDescriptionDict.Add(705, "Stop movement finished with error!");
                    errorDescriptionDict.Add(706, "Stop movement and program finished with error!");
                    errorDescriptionDict.Add(707, "Start movement finished with error!");

                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");

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
                if (actionDescriptionDict == null) { actionDescriptionDict = new Dictionary<uint, string>(); }
                if (actionDescriptionDict.Count == 0)
                {
                    actionDescriptionDict.Add(0, "   ");
                    actionDescriptionDict.Add(300, "Start at main: switching to auto mode.");
                    actionDescriptionDict.Add(301, "Start at main: enabling operations.");
                    actionDescriptionDict.Add(302, "Start at main: reseting the error.");
                    actionDescriptionDict.Add(303, "Start at main: reseting the emergency stop error.");
                    actionDescriptionDict.Add(304, "Start at main: reseting the program.");
                    actionDescriptionDict.Add(305, "Start at main: finished succesfully.");

                    actionDescriptionDict.Add(310, "Start motors and program: switching to auto mode.");
                    actionDescriptionDict.Add(311, "Start motors and program: enabling operations.");
                    actionDescriptionDict.Add(312, "Start motors and program: reseting the error.");
                    actionDescriptionDict.Add(313, "Start motors and program: reseting the emergency stop error.");
                    actionDescriptionDict.Add(314, "Start motors and program: starting the motors.");
                    actionDescriptionDict.Add(315, "Start motors and program: starting the program.");
                    actionDescriptionDict.Add(316, "Start motors and program: finished succesfully.");

                    actionDescriptionDict.Add(320, "Stop movements: switching to auto mode.");
                    actionDescriptionDict.Add(321, "Stop movements: enabling operations.");
                    actionDescriptionDict.Add(322, "Stop movements: stopping.");
                    actionDescriptionDict.Add(323, "Stop movements: finished succesfully.");

                    actionDescriptionDict.Add(330, "Stop movements and program: switching to auto mode.");
                    actionDescriptionDict.Add(331, "Stop movements and program: enabling operations.");
                    actionDescriptionDict.Add(332, "Stop movements and program: stopping.");
                    actionDescriptionDict.Add(333, "Stop movements and program: finished succesfully.");

                    actionDescriptionDict.Add(340, "Start movements: waiting for enable.");
                    actionDescriptionDict.Add(341, "Start movements: setting the  movement parameters.");
                    actionDescriptionDict.Add(342, "Start movements: comparing themovement parameters.");
                    actionDescriptionDict.Add(343, "Start movements: acknowledging the movement parameters.");
                    actionDescriptionDict.Add(344, "Start movements: executing required movement.");
                    actionDescriptionDict.Add(345, "Start movements: acknowledging the finished movement.");
                    actionDescriptionDict.Add(346, "Start movements: finished succesfully.");




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

