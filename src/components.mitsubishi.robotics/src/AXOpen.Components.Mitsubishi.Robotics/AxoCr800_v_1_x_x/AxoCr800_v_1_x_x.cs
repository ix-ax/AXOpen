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
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Start at main started.",                                                                       "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Start at main finished succesfully.",                                                          "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Start at main restored.",                                                                      "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Start motors and program started.",                                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Start motors and program finished succesfully.",                                               "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Start motors and program restored.",                                                           "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Stop movements started.",                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Stop movements finished succesfully.",                                                         "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Stop movements restored.",                                                                     "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(130, new AxoMessengerTextItem("Stop movements and program started.",                                                          "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(131, new AxoMessengerTextItem("Stop movements and program finished succesfully.",                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(132, new AxoMessengerTextItem("Stop movements and program restored.",                                                         "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("Start movements started.",                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("Start movements finished succesfully.",                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("Start movements restored.",                                                                    "")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                  "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwIdInOut_64_byte` has invalid value in `Run` method!",                        "Check the call of the `Run` method, if the `hwIdInOut_64_byte` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Error reading the hwIdInOut_64_byte in the UpdateInputs method!",                              "Check the value of the `hwIdInOut_64_byte` and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Error writting the hwIdInOut_64_byte in the UpdateInputs method!",                             "Check the value of the `hwIdInOut_64_byte` and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Start at main finished with error!",                                                           "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Start at main was aborted, while not yet completed!",                                          "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Start motors and program finished with error!",                                                "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Start motors and program was aborted, while not yet completed!",                               "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Stop movements finished with error!",                                                          "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Stop movements was aborted, while not yet completed!",                                         "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(830, new AxoMessengerTextItem("Stop movements and program finished with error!",                                              "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(831, new AxoMessengerTextItem("Stop movements and program was aborted, while not yet completed!",                             "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Start movements finished with error!",                                                         "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Start movements was aborted, while not yet completed!",                                        "Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmergencyError to be reseted!",                                                                             "Check the status of the `EmergencyError` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604,  new AxoMessengerTextItem("Waiting for the signal Inputs.ProgramReset to be set!",                                                                                   "Check the status of the `Inputs.ProgramReset` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmergencyError to be reseted!",                                                                             "Check the status of the `EmergencyError` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614,  new AxoMessengerTextItem("Waiting for the signal Inputs.ServoOn to be set!",                                                                                        "Check the status of the `Inputs.ServoOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(616,  new AxoMessengerTextItem("Waiting for the signal Inputs.Start to be set!",                                                                                          "Check the status of the `Inputs.Start` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(617,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal Inputs.Stop to be set!",                                                                                           "Check the status of the `Inputs.Stop` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the signal Inputs.Stop to be set!",                                                                                           "Check the status of the `Inputs.Stop` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(640,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(641,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(642,  new AxoMessengerTextItem("Waiting for the signal Inputs.ServoOn to be set!",                                                                                        "Check the status of the `Inputs.ServoOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(643,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(644,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(645,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(646,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(647,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(648,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(649,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(650,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(651,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(652,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(653,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
    public partial class AxoMitsubishiRobotics_Component_Status_v_1_x_x : AXOpen.Components.Robotics.AxoRobot_Status
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
                    errorDescriptionDict.Add(600, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(601, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(602, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(603, "Waiting for the signal Inputs.EmergencyError to be reseted!");
                    errorDescriptionDict.Add(604, "Waiting for the signal Inputs.ProgramReset to be set!");
                    errorDescriptionDict.Add(610, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(611, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(612, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(613, "Waiting for the signal Inputs.EmergencyError to be reseted!");
                    errorDescriptionDict.Add(614, "Waiting for the signal Inputs.ServoOn to be set!");
                    errorDescriptionDict.Add(615, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(616, "Waiting for the signal Inputs.Start to be set!");
                    errorDescriptionDict.Add(617, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(620, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(621, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(622, "Waiting for the signal Inputs.Stop to be set!");
                    errorDescriptionDict.Add(630, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(631, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(632, "Waiting for the signal Inputs.Stop to be set!");
                    errorDescriptionDict.Add(640, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(641, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(642, "Waiting for the signal Inputs.ServoOn to be set!");
                    errorDescriptionDict.Add(643, "Waiting for the signal Inputs.ErrorReset to be reseted!");
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


                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `hwIdInOut_64_byte` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Error reading the hwIdInOut_64_byte in the UpdateInputs method!");
                    errorDescriptionDict.Add(703, "Error writting the hwIdInOut_64_byte in the UpdateInputs method!");
                    errorDescriptionDict.Add(800, "Start at main finished with error!");
                    errorDescriptionDict.Add(801, "Start at main was aborted, while not yet completed!");
                    errorDescriptionDict.Add(810, "Start motors and program finished with error!");
                    errorDescriptionDict.Add(811, "Start motors and program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(820, "Stop movements finished with error!");
                    errorDescriptionDict.Add(821, "Stop movements was aborted, while not yet completed!");
                    errorDescriptionDict.Add(830, "Stop movements and program finished with error!");
                    errorDescriptionDict.Add(831, "Stop movements and program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(840, "Start movements finished with error!");
                    errorDescriptionDict.Add(841, "Start movements was aborted, while not yet completed!");

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

                    actionDescriptionDict.Add(100, "Start at main started.");
                    actionDescriptionDict.Add(300, "Start at main running.");
                    actionDescriptionDict.Add(301, "Start at main running.");
                    actionDescriptionDict.Add(302, "Start at main running.");
                    actionDescriptionDict.Add(303, "Start at main running.");
                    actionDescriptionDict.Add(304, "Start at main running.");
                    actionDescriptionDict.Add(305, "Start at main running.");
                    actionDescriptionDict.Add(306, "Start at main running.");
                    actionDescriptionDict.Add(307, "Start at main running.");
                    actionDescriptionDict.Add(308, "Start at main running.");
                    actionDescriptionDict.Add(309, "Start at main running.");
                    actionDescriptionDict.Add(101, "Start at main finished succesfully.");
                    actionDescriptionDict.Add(102, "Start at main restored.");

                    actionDescriptionDict.Add(110, "Start motors and program started.");
                    actionDescriptionDict.Add(310, "Start motors and program running.");
                    actionDescriptionDict.Add(311, "Start motors and program running.");
                    actionDescriptionDict.Add(312, "Start motors and program running.");
                    actionDescriptionDict.Add(313, "Start motors and program running.");
                    actionDescriptionDict.Add(314, "Start motors and program running.");
                    actionDescriptionDict.Add(315, "Start motors and program running.");
                    actionDescriptionDict.Add(316, "Start motors and program running.");
                    actionDescriptionDict.Add(317, "Start motors and program running.");
                    actionDescriptionDict.Add(318, "Start motors and program running.");
                    actionDescriptionDict.Add(319, "Start motors and program running.");
                    actionDescriptionDict.Add(111, "Start motors and program finished succesfully.");
                    actionDescriptionDict.Add(112, "Start motors and program restored.");

                    actionDescriptionDict.Add(120, "Stop movements started.");
                    actionDescriptionDict.Add(320, "Stop movements running.");
                    actionDescriptionDict.Add(321, "Stop movements running.");
                    actionDescriptionDict.Add(322, "Stop movements running.");
                    actionDescriptionDict.Add(323, "Stop movements running.");
                    actionDescriptionDict.Add(324, "Stop movements running.");
                    actionDescriptionDict.Add(325, "Stop movements running.");
                    actionDescriptionDict.Add(326, "Stop movements running.");
                    actionDescriptionDict.Add(327, "Stop movements running.");
                    actionDescriptionDict.Add(328, "Stop movements running.");
                    actionDescriptionDict.Add(329, "Stop movements running.");
                    actionDescriptionDict.Add(121, "Stop movements finished succesfully.");
                    actionDescriptionDict.Add(122, "Stop movements restored.");

                    
                    actionDescriptionDict.Add(120, "Start motors program and movements started.");
                    actionDescriptionDict.Add(320, "Start motors program and movements running.");
                    actionDescriptionDict.Add(321, "Start motors program and movements running.");
                    actionDescriptionDict.Add(322, "Start motors program and movements running.");
                    actionDescriptionDict.Add(323, "Start motors program and movements running.");
                    actionDescriptionDict.Add(324, "Start motors program and movements running.");
                    actionDescriptionDict.Add(325, "Start motors program and movements running.");
                    actionDescriptionDict.Add(326, "Start motors program and movements running.");
                    actionDescriptionDict.Add(327, "Start motors program and movements running.");
                    actionDescriptionDict.Add(328, "Start motors program and movements running.");
                    actionDescriptionDict.Add(329, "Start motors program and movements running.");
                    actionDescriptionDict.Add(330, "Start motors program and movements running.");
                    actionDescriptionDict.Add(331, "Start motors program and movements running.");
                    actionDescriptionDict.Add(332, "Start motors program and movements running.");
                    actionDescriptionDict.Add(333, "Start motors program and movements running.");
                    actionDescriptionDict.Add(334, "Start motors program and movements running.");
                    actionDescriptionDict.Add(335, "Start motors program and movements running.");
                    actionDescriptionDict.Add(336, "Start motors program and movements running.");
                    actionDescriptionDict.Add(337, "Start motors program and movements running.");
                    actionDescriptionDict.Add(338, "Start motors program and movements running.");
                    actionDescriptionDict.Add(339, "Start motors program and movements running.");
                    actionDescriptionDict.Add(121, "Start motors program and movements finished succesfully.");
                    actionDescriptionDict.Add(122, "Start motors program and movements restored.");

                    actionDescriptionDict.Add(130, "Stop movements and program started.");
                    actionDescriptionDict.Add(330, "Stop movements and program running.");
                    actionDescriptionDict.Add(331, "Stop movements and program running.");
                    actionDescriptionDict.Add(332, "Stop movements and program running.");
                    actionDescriptionDict.Add(333, "Stop movements and program running.");
                    actionDescriptionDict.Add(334, "Stop movements and program running.");
                    actionDescriptionDict.Add(335, "Stop movements and program running.");
                    actionDescriptionDict.Add(336, "Stop movements and program running.");
                    actionDescriptionDict.Add(337, "Stop movements and program running.");
                    actionDescriptionDict.Add(338, "Stop movements and program running.");
                    actionDescriptionDict.Add(339, "Stop movements and program running.");
                    actionDescriptionDict.Add(131, "Stop movements and program finished succesfully.");
                    actionDescriptionDict.Add(132, "Stop movements and program restored.");

                    actionDescriptionDict.Add(140, "Start movements started.");
                    actionDescriptionDict.Add(340, "Start movements running.");
                    actionDescriptionDict.Add(341, "Start movements running.");
                    actionDescriptionDict.Add(342, "Start movements running.");
                    actionDescriptionDict.Add(343, "Start movements running.");
                    actionDescriptionDict.Add(344, "Start movements running.");
                    actionDescriptionDict.Add(345, "Start movements running.");
                    actionDescriptionDict.Add(346, "Start movements running.");
                    actionDescriptionDict.Add(347, "Start movements running.");
                    actionDescriptionDict.Add(348, "Start movements running.");
                    actionDescriptionDict.Add(349, "Start movements running.");
                    actionDescriptionDict.Add(350, "Start movements running.");
                    actionDescriptionDict.Add(351, "Start movements running.");
                    actionDescriptionDict.Add(352, "Start movements running.");
                    actionDescriptionDict.Add(353, "Start movements running.");
                    actionDescriptionDict.Add(354, "Start movements running.");
                    actionDescriptionDict.Add(355, "Start movements running.");
                    actionDescriptionDict.Add(356, "Start movements running.");
                    actionDescriptionDict.Add(357, "Start movements running.");
                    actionDescriptionDict.Add(358, "Start movements running.");
                    actionDescriptionDict.Add(359, "Start movements running.");
                    actionDescriptionDict.Add(141, "Start movements finished succesfully.");
                    actionDescriptionDict.Add(142, "Start movements restored.");

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

