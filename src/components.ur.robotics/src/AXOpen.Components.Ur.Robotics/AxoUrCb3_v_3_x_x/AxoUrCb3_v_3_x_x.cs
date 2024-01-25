using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Ur.Robotics
{
    public partial class AxoUrCb3_v_3_x_x : AXOpen.Core.AxoComponent, AXOpen.Components.Abstractions.Robotics.IAxoRobotics
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                                          "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_T2O_State ` has NULL reference in `Run` method!",                                     "Check the call of the `Run` method, if the `refAxoUrRobotics_T2O_State ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_T2O_IO ` has NULL reference in `Run` method!",                                        "Check the call of the `Run` method, if the `refAxoUrRobotics_T2O_IO ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_T2O_Joints ` has NULL reference in `Run` method!",                                    "Check the call of the `Run` method, if the `refAxoUrRobotics_T2O_Joints ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_T2O_TCP ` has NULL reference in `Run` method!",                                       "Check the call of the `Run` method, if the `refAxoUrRobotics_T2O_TCP ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_T2O_General_Purpose_Bit_Registers ` has NULL reference in `Run` method!",             "Check the call of the `Run` method, if the `refAxoUrRobotics_T2O_General_Purpose_Bit_Registers ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_T2O_General_Purpose_Int_Registers ` has NULL reference in `Run` method!",             "Check the call of the `Run` method, if the `refAxoUrRobotics_T2O_General_Purpose_Int_Registers ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_T2O_General_Purpose_Float_Registers ` has NULL reference in `Run` method!",           "Check the call of the `Run` method, if the `refAxoUrRobotics_T2O_General_Purpose_Float_Registers ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_O2T_Robot_IO ` has NULL reference in `Run` method!",                                  "Check the call of the `Run` method, if the `refAxoUrRobotics_O2T_Robot_IO ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_O2T_General_Purpose_Registers_1 ` has NULL reference in `Run` method!",               "Check the call of the `Run` method, if the `refAxoUrRobotics_O2T_General_Purpose_Registers_1 ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Input variable `refAxoUrRobotics_O2T_General_Purpose_Registers_2 ` has NULL reference in `Run` method!",               "Check the call of the `Run` method, if the `refAxoUrRobotics_O2T_General_Purpose_Registers_2 ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Start at main finished with error!",                                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Start motors and program finished with error!",                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Start motors, program and movements finished with error!",                                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Start motors finished with error!",                                                                                    "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Start movement finished with error!",                                                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Start program finished with error!",                                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Stop motors finished with error!",                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Stop movements and program finished with error!",                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(719, new AxoMessengerTextItem("Stop movements finished with error!",                                                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Stop program finished with error!",                                                                                    "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Emergency stop active!",                                                                                               "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Safety Error !",                                                                                                       "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Program execution error!",                                                                                             "See robot panel for details")),


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
    public partial class AxoUrRobotics_Component_Status_v_1_x_x : AXOpen.Components.Robotics.AxoRobot_Status
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
                    errorDescriptionDict.Add(600, "Waiting for the signal `Inputs.Safety.NO_IsNormalMode` to be set!");
                    errorDescriptionDict.Add(601, "Waiting for the signal `Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(602, "Waiting for the signal `Inputs.Robot.PR_IsProgramRunning` to be set!");

                    errorDescriptionDict.Add(605, "Waiting for the signal `Inputs.Safety.NO_IsNormalMode` to be set!");
                    errorDescriptionDict.Add(606, "Waiting for the signal `Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(607, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(608, "Waiting for the signal `Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");
                    errorDescriptionDict.Add(609, "Waiting for the signal `Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");
                    errorDescriptionDict.Add(610, "Waiting for the signal `Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");
                    errorDescriptionDict.Add(611, "Waiting for the signal `Inputs.Safety.RC_IsRecoveryMode` to be reseted!");
                    errorDescriptionDict.Add(612, "Waiting for the signal `Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");
                    errorDescriptionDict.Add(613, "Waiting for the signal `Inputs.Safety.VL_IsViolation` to be reseted!");
                    errorDescriptionDict.Add(614, "Waiting for the signal `Inputs.Robot.PW_IsPowerOn` to be set!");
                    errorDescriptionDict.Add(615, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(616, "Waiting for the signal `Inputs.Robot.PR_IsProgramRunning` to be set!");
                    errorDescriptionDict.Add(617, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");

                    errorDescriptionDict.Add(620, "Waiting for the signal `Inputs.Safety.NO_IsNormalMode` to be set!");
                    errorDescriptionDict.Add(621, "Waiting for the signal `Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(622, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(623, "Waiting for the signal `Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");
                    errorDescriptionDict.Add(624, "Waiting for the signal `Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");
                    errorDescriptionDict.Add(625, "Waiting for the signal `Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");
                    errorDescriptionDict.Add(626, "Waiting for the signal `Inputs.Safety.RC_IsRecoveryMode` to be reseted!");
                    errorDescriptionDict.Add(627, "Waiting for the signal `Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");
                    errorDescriptionDict.Add(628, "Waiting for the signal `Inputs.Safety.VL_IsViolation` to be reseted!");
                    errorDescriptionDict.Add(629, "Waiting for the signal `Inputs.Robot.PW_IsPowerOn` to be set!");
                    errorDescriptionDict.Add(630, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(631, "Waiting for the signal `Inputs.Robot.PR_IsProgramRunning` to be set!");
                    errorDescriptionDict.Add(632, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(633, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(634, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(635, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(636, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(637, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(638, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(639, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(640, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(641, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(642, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");

                    errorDescriptionDict.Add(643, "Waiting for the signal `Inputs.Safety.NO_IsNormalMode` to be set!");
                    errorDescriptionDict.Add(644, "Waiting for the signal `Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(645, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(646, "Waiting for the signal `Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");
                    errorDescriptionDict.Add(647, "Waiting for the signal `Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");
                    errorDescriptionDict.Add(648, "Waiting for the signal `Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");
                    errorDescriptionDict.Add(649, "Waiting for the signal `Inputs.Safety.RC_IsRecoveryMode` to be reseted!");
                    errorDescriptionDict.Add(650, "Waiting for the signal `Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");
                    errorDescriptionDict.Add(651, "Waiting for the signal `Inputs.Safety.VL_IsViolation` to be reseted!");
                    errorDescriptionDict.Add(652, "Waiting for the signal `Inputs.Robot.PW_IsPowerOn` to be set!");
                    errorDescriptionDict.Add(653, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(654, "Waiting for the value of the `Inputs.Joints.JointMode_0` to be equal to 253!");
                    errorDescriptionDict.Add(655, "Waiting for the value of the `Inputs.Joints.JointMode_1` to be equal to 253!");
                    errorDescriptionDict.Add(656, "Waiting for the value of the `Inputs.Joints.JointMode_2` to be equal to 253!");
                    errorDescriptionDict.Add(657, "Waiting for the value of the `Inputs.Joints.JointMode_3` to be equal to 253!");
                    errorDescriptionDict.Add(658, "Waiting for the value of the `Inputs.Joints.JointMode_4` to be equal to 253!");
                    errorDescriptionDict.Add(659, "Waiting for the value of the `Inputs.Joints.JointMode_5` to be equal to 253!");

                    errorDescriptionDict.Add(632, "Waiting for the signal `Inputs.Safety.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(633, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(634, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(635, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(636, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(637, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(638, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(639, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(640, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(641, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(642, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");


                    errorDescriptionDict.Add(650, "Waiting for the signal `Inputs.PR_IsProgramRunning` to be set!");
                    errorDescriptionDict.Add(651, "Waiting for the signal `Inputs.PW_IsPowerOn` to be set!");
                    errorDescriptionDict.Add(652, "Waiting for the signal `Inputs.FT_IsFault` to be reseted!");
                    errorDescriptionDict.Add(654, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(655, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(656, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(657, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(658, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(659, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(660, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(661, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(662, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(663, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");

                    errorDescriptionDict.Add(670, "Waiting for the signal `Inputs.Safety.NO_IsNormalMode` to be set!");
                    errorDescriptionDict.Add(671, "Waiting for the signal `Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(672, "Waiting for the signal `Inputs.Safety.PR_IsProgramRunning` to be set!");

                    //errorDescriptionDict.Add(680, "Waiting for the signal `Inputs.MotorOffState` to be set!");
                    //errorDescriptionDict.Add(681, "Waiting for the signal `Inputs.SystemInputBusy` to be reseted!");

                    errorDescriptionDict.Add(690, "Waiting for the signal `Inputs.Safety.NO_IsNormalMode` to be set!");
                    errorDescriptionDict.Add(691, "Waiting for the signal `Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(692, "Waiting for the signal `Inputs.Safety.PR_IsProgramRunning` to be reseted!");


                    errorDescriptionDict.Add(693, "Waiting for the signal `Inputs.Safety.NO_IsNormalMode` to be set!");
                    errorDescriptionDict.Add(694, "Waiting for the signal `Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(695, "Waiting for the signal `Inputs.Safety.PR_IsProgramRunning` to be reseted!");


                    errorDescriptionDict.Add(696, "Waiting for the signal `Inputs.Safety.NO_IsNormalMode` to be set!");
                    errorDescriptionDict.Add(697, "Waiting for the signal `Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(698, "Waiting for the signal `Inputs.Safety.PR_IsProgramRunning` to be reseted!");

                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `refAxoUrRobotics_T2O_State ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(702, "Input variable `refAxoUrRobotics_T2O_IO ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(703, "Input variable `refAxoUrRobotics_T2O_Joints ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(704, "Input variable `refAxoUrRobotics_T2O_TCP ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(705, "Input variable `refAxoUrRobotics_T2O_General_Purpose_Bit_Registers ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(706, "Input variable `refAxoUrRobotics_T2O_General_Purpose_Int_Registers ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(707, "Input variable `refAxoUrRobotics_T2O_General_Purpose_Float_Registers ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(708, "Input variable `refAxoUrRobotics_O2T_Robot_IO ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(709,"Input variable `refAxoUrRobotics_O2T_General_Purpose_Registers_1 ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(710,"Input variable `refAxoUrRobotics_O2T_General_Purpose_Registers_2 ` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(711, "Start at main finished with error!"); 
                    errorDescriptionDict.Add(712, "Start motors and program finished with error!");
                    errorDescriptionDict.Add(713, "Start motors, program and movements finished with error!");
                    errorDescriptionDict.Add(714, "Start motors finished with error!");
                    errorDescriptionDict.Add(715, "Start movement finished with error!");
                    errorDescriptionDict.Add(716, "Start program finished with error!");
                    errorDescriptionDict.Add(717, "Stop motors finished with error!");
                    errorDescriptionDict.Add(718, "Stop movements and program finished with error!");
                    errorDescriptionDict.Add(719, "Stop movements finished with error!");
                    errorDescriptionDict.Add(720, "Stop program finished with error!");
                    errorDescriptionDict.Add(721,"Emergency stop active!");
                    errorDescriptionDict.Add(722, "Safety Error !");
                    errorDescriptionDict.Add(723,"Program execution error!");


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
                    actionDescriptionDict.Add(300, "Start at main: waiting for normal or reduced mode");
                    actionDescriptionDict.Add(301, "Start at main: starting program.");
                    actionDescriptionDict.Add(302, "Start at main: starting program.");
                    actionDescriptionDict.Add(303, "Start at main: finished succesfully.");

                    actionDescriptionDict.Add(310, "Start motors and program: waiting for normal or reduced mode");
                    actionDescriptionDict.Add(311, "Start motors and program: waiting for reseting the error.");
                    actionDescriptionDict.Add(312, "Start motors and program: waiting for reseting the emergency stop error.");
                    actionDescriptionDict.Add(313, "Start motors and program: starting the motors.");
                    actionDescriptionDict.Add(314, "Start motors and program: starting the program.");
                    actionDescriptionDict.Add(315, "Start motors and program: starting the program.");
                    actionDescriptionDict.Add(316, "Start motors and program: finished succesfully.");

                    actionDescriptionDict.Add(320, "Start motors program and movements: waiting for normal or reduced mode");
                    actionDescriptionDict.Add(321, "Start motors program and movements: waiting for reseting the error.");
                    actionDescriptionDict.Add(322, "Start motors program and movements: waiting for reseting the emergency stop error.");
                    actionDescriptionDict.Add(323, "Start motors program and movements: starting the motors.");
                    actionDescriptionDict.Add(324, "Start motors program and movements: starting the program.");
                    actionDescriptionDict.Add(325, "Start motors program and movements: setting the  movement parameters.");
                    actionDescriptionDict.Add(326, "Start motors program and movements: comparing the movement parameters.");
                    actionDescriptionDict.Add(327, "Start motors program and movements: acknowledging the movement parameters ");
                    actionDescriptionDict.Add(328, "Start motors program and movements: executing required movement.");
                    actionDescriptionDict.Add(329, "Start motors program and movements: acknowledging the finished movement.");
                    actionDescriptionDict.Add(330, "Start motors program and movements: finished succesfully.");

                    actionDescriptionDict.Add(340, "Start motors: waiting for normal or reduced mode");
                    actionDescriptionDict.Add(341, "Start motors: waiting for reseting the error.");
                    actionDescriptionDict.Add(342, "Start motors: waiting for reseting the emergency stop error.");
                    actionDescriptionDict.Add(343, "Start motors: starting the motors.");
                    actionDescriptionDict.Add(344, "Start motors: starting the motors.");
                    actionDescriptionDict.Add(345, "Start motors: finished succesfully.");

                    actionDescriptionDict.Add(350, "Start movements: waiting for started the program and motors.");
                    actionDescriptionDict.Add(351, "Start movements: setting the  movement parameters.");
                    actionDescriptionDict.Add(352, "Start movements: comparing the movement parameters.");
                    actionDescriptionDict.Add(353, "Start movements: acknowledging the movement parameters.");
                    actionDescriptionDict.Add(354, "Start movements: executing required movement.");
                    actionDescriptionDict.Add(355, "Start movements: acknowledging the finished movement.");
                    actionDescriptionDict.Add(356, "Start movements: finished succesfully.");

                    actionDescriptionDict.Add(370, "Start program: waiting for normal or reduced mode.");
                    actionDescriptionDict.Add(371, "Start program: starting the program.");
                    actionDescriptionDict.Add(372, "Start program: starting the program.");
                    actionDescriptionDict.Add(373, "Start program: finished succesfully.");

                    //actionDescriptionDict.Add(380, "Stop motors: stopping the motors.");
                    //actionDescriptionDict.Add(381, "Stop motors: stopping the motors.");
                    //actionDescriptionDict.Add(382, "Stop motors: finished succesfully.");

                    actionDescriptionDict.Add(390, "Stop movements and program: waiting for normal or reduced mode.");
                    actionDescriptionDict.Add(391, "Stop movements and program: stopping the program.");
                    actionDescriptionDict.Add(392, "Stop movements and program: stopping the program.");
                    actionDescriptionDict.Add(393, "Stop movements and program: finished succesfully.");

                    actionDescriptionDict.Add(400, "Stop movements: waiting for normal or reduced mode.");
                    actionDescriptionDict.Add(401, "Stop movements: stopping the movements.");
                    actionDescriptionDict.Add(402, "Stop movements: stopping the movements.");
                    actionDescriptionDict.Add(403, "Stop movements: finished succesfully.");

                    actionDescriptionDict.Add(410, "Stop program: waiting for normal or reduced mode.");
                    actionDescriptionDict.Add(411, "Stop program: stopping the program.");
                    actionDescriptionDict.Add(412, "Stop program: stopping the program.");
                    actionDescriptionDict.Add(413, "Stop program: finished succesfully.");

                    actionDescriptionDict.Add(420, "POWER ON PULSE WAS SEND TO CONTROLER.");

                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `refAxoUrRobotics_T2O_State ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(702, "Input variable `refAxoUrRobotics_T2O_IO ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(703, "Input variable `refAxoUrRobotics_T2O_Joints ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(704, "Input variable `refAxoUrRobotics_T2O_TCP ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(705, "Input variable `refAxoUrRobotics_T2O_General_Purpose_Bit_Registers ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(706, "Input variable `refAxoUrRobotics_T2O_General_Purpose_Int_Registers ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(707, "Input variable `refAxoUrRobotics_T2O_General_Purpose_Float_Registers ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(708, "Input variable `refAxoUrRobotics_O2T_Robot_IO ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(709, "Input variable `refAxoUrRobotics_O2T_General_Purpose_Registers_1 ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(710, "Input variable `refAxoUrRobotics_O2T_General_Purpose_Registers_2 ` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(711, "Start at main finished with error!");
                    actionDescriptionDict.Add(712, "Start motors and program finished with error!");
                    actionDescriptionDict.Add(713, "Start motors, program and movements finished with error!");
                    actionDescriptionDict.Add(714, "Start motors finished with error!");
                    actionDescriptionDict.Add(715, "Start movement finished with error!");
                    actionDescriptionDict.Add(716, "Start program finished with error!");
                    actionDescriptionDict.Add(717, "Stop motors finished with error!");
                    actionDescriptionDict.Add(718, "Stop movements and program finished with error!");
                    actionDescriptionDict.Add(719, "Stop movements finished with error!");
                    actionDescriptionDict.Add(720, "Stop program finished with error!");
                    actionDescriptionDict.Add(721, "Emergency stop active!");
                    actionDescriptionDict.Add(722, "Stopped due to safety issue!");

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

