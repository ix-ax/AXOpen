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
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                                                                                "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Start at main started.",                                                                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Start at main finished succesfully.",                                                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Start at main restored.",                                                                                                                  "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Start motors and program started.",                                                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Start motors and program finished succesfully.",                                                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Start motors and program restored.",                                                                                                       "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(130, new AxoMessengerTextItem("Start motors program and movements started.",                                                                                              "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(131, new AxoMessengerTextItem("Start motors program and movements finished succesfully.",                                                                                 "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(132, new AxoMessengerTextItem("Start motors program and movements restored.",                                                                                             "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(160, new AxoMessengerTextItem("Start motors started.",                                                                                                                    "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(161, new AxoMessengerTextItem("Start motors finished succesfully.",                                                                                                       "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(162, new AxoMessengerTextItem("Start motors restored.",                                                                                                                   "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(180, new AxoMessengerTextItem("Start movements started.",                                                                                                                 "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(181, new AxoMessengerTextItem("Start movements finished succesfully.",                                                                                                    "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(182, new AxoMessengerTextItem("Start movements restored.",                                                                                                                "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(200, new AxoMessengerTextItem("Start program started.",                                                                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(201, new AxoMessengerTextItem("Start program finished succesfully.",                                                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(202, new AxoMessengerTextItem("Start program restored.",                                                                                                                  "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(210, new AxoMessengerTextItem("Stop movements and program started.",                                                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(211, new AxoMessengerTextItem("Stop movements and program finished succesfully.",                                                                                         "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(212, new AxoMessengerTextItem("Stop movements and program restored.",                                                                                                     "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(220, new AxoMessengerTextItem("Stop movements started.",                                                                                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(221, new AxoMessengerTextItem("Stop movements finished succesfully.",                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(222, new AxoMessengerTextItem("Stop movements restored.",                                                                                                                 "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(230, new AxoMessengerTextItem("Stop program started.",                                                                                                                    "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(231, new AxoMessengerTextItem("Stop program finished succesfully.",                                                                                                       "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(232, new AxoMessengerTextItem("Stop program restored.",                                                                                                                   "")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                                                              "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_T2O_State` has invalid valuein `Run` method!",                                                           "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_T2O_State` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_T2O_IO` has invalid valuein `Run` method!",                                                              "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_T2O_IO` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_T2O_Joints` has invalid valuein `Run` method!",                                                          "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_T2O_Joints` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_T2O_TCP` has invalid valuein `Run` method!",                                                             "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_T2O_TCP` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers` has invalid valuein `Run` method!",                                   "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers` has invalid valuein `Run` method!",                                   "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers` has invalid valuein `Run` method!",                                 "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_O2T_Robot_IO` has invalid valuein `Run` method!",                                                        "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_O2T_Robot_IO` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1` has invalid valuein `Run` method!",                                     "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Input variable `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2` has invalid valuein `Run` method!",                                     "Check the call of the `Run` method, if the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Input variable `refPowerOnPulse` has NULL reference in `Run` method!",                                                                     "Check the call of the `Run` method, if the `refPowerOnPulse` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Error reading the `hwIdAxoUrRobotics_T2O_State` in the Run method!",                                                                       "Check the value of the `hwIdAxoUrRobotics_T2O_State` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Error reading the `hwIdAxoUrRobotics_T2O_IO` in the Run method!",                                                                          "Check the value of the `hwIdAxoUrRobotics_T2O_IO` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Error reading the `hwIdAxoUrRobotics_T2O_Joints` in the Run method!",                                                                      "Check the value of the `hwIdAxoUrRobotics_T2O_Joints` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Error reading the `hwIdAxoUrRobotics_T2O_TCP` in the Run method!",                                                                         "Check the value of the `hwIdAxoUrRobotics_T2O_TCP` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers` in the Run method!",                                               "Check the value of the `hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers` in the Run method!",                                               "Check the value of the `hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers` in the Run method!",                                             "Check the value of the `hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(719, new AxoMessengerTextItem("Emergency stop active!",                                                                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Safety Error !",                                                                                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Error writing the `hwIdAxoUrRobotics_O2T_Robot_IO` in the Run method!",                                                                    "Check the value of the `hwIdAxoUrRobotics_O2T_Robot_IO` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Error writing the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1` in the Run method!",                                                 "Check the value of the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1` and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Error writing the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2` in the Run method!",                                                 "Check the value of the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2` and reacheability of the device!")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Start at main finished with error!",                                                                                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Start at main was aborted, while not yet completed!",                                                                                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Start motors and program finished with error!",                                                                                            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Start motors and program was aborted, while not yet completed!",                                                                           "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(830, new AxoMessengerTextItem("Start motors program and movements finished with error!",                                                                                  "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(831, new AxoMessengerTextItem("Start motors program and movements was aborted, while not yet completed!",                                                                 "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(860, new AxoMessengerTextItem("Start motors finished with error!",                                                                                                        "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(861, new AxoMessengerTextItem("Start motors was aborted, while not yet completed!",                                                                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(880, new AxoMessengerTextItem("Start movements finished with error!",                                                                                                     "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(881, new AxoMessengerTextItem("Start movements was aborted, while not yet completed!",                                                                                    "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(900, new AxoMessengerTextItem("Start program finished with error!",                                                                                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(901, new AxoMessengerTextItem("Start program was aborted, while not yet completed!",                                                                                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(910, new AxoMessengerTextItem("Stop movements and program finished with error!",                                                                                          "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(911, new AxoMessengerTextItem("Stop movements and program was aborted, while not yet completed!",                                                                         "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(920, new AxoMessengerTextItem("Stop movements finished with error!",                                                                                                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(921, new AxoMessengerTextItem("Stop movements was aborted, while not yet completed!",                                                                                     "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(930, new AxoMessengerTextItem("Stop program finished with error!",                                                                                                        "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(931, new AxoMessengerTextItem("Stop program was aborted, while not yet completed!",                                                                                       "Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(518,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(519,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(537,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(538,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(539,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(547,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(561,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(563,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(564,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(565,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(566,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(567,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(568,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(569,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_0` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_0`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(572,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_1` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_1`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(573,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_2` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_2`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(574,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_3` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_3`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(575,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_4` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_4`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(576,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_5` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_5`")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(581,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(582,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(583,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(584,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(585,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(586,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(587,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(588,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(589,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(592,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

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
                    errorDescriptionDict.Add(500, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(501, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(502, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                             

                    errorDescriptionDict.Add(510, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(511, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(512, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(513, "Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(514, "Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");                                                     
                    errorDescriptionDict.Add(515, "Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(516, "Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!");                                                          
                    errorDescriptionDict.Add(517, "Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");                                                      
                    errorDescriptionDict.Add(518, "Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!");                                                             
                    errorDescriptionDict.Add(519, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    
                    errorDescriptionDict.Add(520, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");
                    errorDescriptionDict.Add(521, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                             

                    errorDescriptionDict.Add(530, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(531, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(532, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(533, "Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(534, "Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");                                                     
                    errorDescriptionDict.Add(535, "Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(536, "Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!");                                                          
                    errorDescriptionDict.Add(537, "Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");                                                      
                    errorDescriptionDict.Add(538, "Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!");                                                             
                    errorDescriptionDict.Add(539, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    
                    errorDescriptionDict.Add(540, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                             
                    errorDescriptionDict.Add(541, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   
                    errorDescriptionDict.Add(542, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");          
                    errorDescriptionDict.Add(543, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");                    
                    errorDescriptionDict.Add(544, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");        
                    errorDescriptionDict.Add(545, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");                  
                    errorDescriptionDict.Add(546, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");    
                    errorDescriptionDict.Add(547, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");    
                    errorDescriptionDict.Add(548, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   
                    errorDescriptionDict.Add(549, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(550, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   

                    errorDescriptionDict.Add(560, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(561, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(562, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(563, "Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(564, "Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");                                                     
                    errorDescriptionDict.Add(565, "Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(566, "Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!");                                                          
                    errorDescriptionDict.Add(567, "Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");                                                      
                    errorDescriptionDict.Add(568, "Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!");                                                             
                    errorDescriptionDict.Add(569, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    
                    errorDescriptionDict.Add(570, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(571, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_0` to be eqaul to 253");                                                      
                    errorDescriptionDict.Add(572, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_1` to be eqaul to 253");                                                      
                    errorDescriptionDict.Add(573, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_2` to be eqaul to 253");                                                      
                    errorDescriptionDict.Add(574, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_3` to be eqaul to 253");                                                      
                    errorDescriptionDict.Add(575, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_4` to be eqaul to 253");
                    errorDescriptionDict.Add(576, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_5` to be eqaul to 253");                                                      

                    errorDescriptionDict.Add(580, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                             
                    errorDescriptionDict.Add(581, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    
                    errorDescriptionDict.Add(582, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(583, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   
                    errorDescriptionDict.Add(584, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");          
                    errorDescriptionDict.Add(585, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");                    
                    errorDescriptionDict.Add(586, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");        
                    errorDescriptionDict.Add(587, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");                  
                    errorDescriptionDict.Add(588, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");    
                    errorDescriptionDict.Add(589, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");    
                    errorDescriptionDict.Add(590, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   
                    errorDescriptionDict.Add(591, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(592, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   

                    errorDescriptionDict.Add(600, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(601, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(602, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    

                    errorDescriptionDict.Add(610, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(611, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(612, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!");                                                         

                    errorDescriptionDict.Add(620, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(621, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(622, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!");                                                         

                    errorDescriptionDict.Add(630, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(631, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(632, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!");                                                         

                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `hwIdAxoUrRobotics_T2O_State` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(702, "Input variable `hwIdAxoUrRobotics_T2O_IO` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(703, "Input variable `hwIdAxoUrRobotics_T2O_Joints` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(704, "Input variable `hwIdAxoUrRobotics_T2O_TCP` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(705, "Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(706, "Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(707, "Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(708, "Input variable `hwIdAxoUrRobotics_O2T_Robot_IO` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(709, "Input variable `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(710, "Input variable `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2` has invalid valuein `Run` method!");
                    errorDescriptionDict.Add(711, "Input variable `refPowerOnPulse` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(712, "Error reading the `hwIdAxoUrRobotics_T2O_State` in the Run method!");
                    errorDescriptionDict.Add(713, "Error reading the `hwIdAxoUrRobotics_T2O_IO` in the Run method!");
                    errorDescriptionDict.Add(714, "Error reading the `hwIdAxoUrRobotics_T2O_Joints` in the Run method!");
                    errorDescriptionDict.Add(715, "Error reading the `hwIdAxoUrRobotics_T2O_TCP` in the Run method!");
                    errorDescriptionDict.Add(716, "Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers` in the Run method!");
                    errorDescriptionDict.Add(717, "Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers` in the Run method!");
                    errorDescriptionDict.Add(718, "Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers` in the Run method!");
                    errorDescriptionDict.Add(719, "Emergency stop active!");
                    errorDescriptionDict.Add(720, "Safety Error !");
                    errorDescriptionDict.Add(721, "Error writing the `hwIdAxoUrRobotics_O2T_Robot_IO` in the Run method!");
                    errorDescriptionDict.Add(722, "Error writing the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1` in the Run method!");
                    errorDescriptionDict.Add(723, "Error writing the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2` in the Run method!");
                    errorDescriptionDict.Add(800, "Start at main finished with error!");
                    errorDescriptionDict.Add(801, "Start at main was aborted, while not yet completed!");
                    errorDescriptionDict.Add(810, "Start motors and program finished with error!");
                    errorDescriptionDict.Add(811, "Start motors and program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(830, "Start motors program and movements finished with error!");
                    errorDescriptionDict.Add(831, "Start motors program and movements was aborted, while not yet completed!");
                    errorDescriptionDict.Add(860, "Start motors finished with error!");
                    errorDescriptionDict.Add(861, "Start motors was aborted, while not yet completed!");
                    errorDescriptionDict.Add(880, "Start movements finished with error!");
                    errorDescriptionDict.Add(881, "Start movements was aborted, while not yet completed!");
                    errorDescriptionDict.Add(900, "Start program finished with error!");
                    errorDescriptionDict.Add(901, "Start program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(910, "Stop movements and program finished with error!");
                    errorDescriptionDict.Add(911, "Stop movements and program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(920, "Stop movements finished with error!");
                    errorDescriptionDict.Add(921, "Stop movements was aborted, while not yet completed!");
                    errorDescriptionDict.Add(930, "Stop program finished with error!");
                    errorDescriptionDict.Add(931, "Stop program was aborted, while not yet completed!");

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
                    actionDescriptionDict.Add(50,  "Restore has been executed.");                                                                 
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
                    actionDescriptionDict.Add(320, "Start motors and program running.");
                    actionDescriptionDict.Add(321, "Start motors and program running.");
                    actionDescriptionDict.Add(322, "Start motors and program running.");
                    actionDescriptionDict.Add(323, "Start motors and program running.");
                    actionDescriptionDict.Add(324, "Start motors and program running.");
                    actionDescriptionDict.Add(325, "Start motors and program running.");
                    actionDescriptionDict.Add(326, "Start motors and program running.");
                    actionDescriptionDict.Add(327, "Start motors and program running.");
                    actionDescriptionDict.Add(328, "Start motors and program running.");
                    actionDescriptionDict.Add(329, "Start motors and program running.");
                    actionDescriptionDict.Add(111, "Start motors and program finished succesfully.");                                            
                    actionDescriptionDict.Add(112, "Start motors and program restored.");                                                        

                    actionDescriptionDict.Add(130, "Start motors program and movements started.");
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
                    actionDescriptionDict.Add(340, "Start motors program and movements running.");
                    actionDescriptionDict.Add(341, "Start motors program and movements running.");
                    actionDescriptionDict.Add(342, "Start motors program and movements running.");
                    actionDescriptionDict.Add(343, "Start motors program and movements running.");
                    actionDescriptionDict.Add(344, "Start motors program and movements running.");
                    actionDescriptionDict.Add(345, "Start motors program and movements running.");
                    actionDescriptionDict.Add(346, "Start motors program and movements running.");
                    actionDescriptionDict.Add(347, "Start motors program and movements running.");
                    actionDescriptionDict.Add(348, "Start motors program and movements running.");
                    actionDescriptionDict.Add(349, "Start motors program and movements running.");
                    actionDescriptionDict.Add(350, "Start motors program and movements running.");
                    actionDescriptionDict.Add(351, "Start motors program and movements running.");
                    actionDescriptionDict.Add(352, "Start motors program and movements running.");
                    actionDescriptionDict.Add(353, "Start motors program and movements running.");
                    actionDescriptionDict.Add(354, "Start motors program and movements running.");
                    actionDescriptionDict.Add(355, "Start motors program and movements running.");
                    actionDescriptionDict.Add(356, "Start motors program and movements running.");
                    actionDescriptionDict.Add(357, "Start motors program and movements running.");
                    actionDescriptionDict.Add(358, "Start motors program and movements running.");
                    actionDescriptionDict.Add(359, "Start motors program and movements running.");
                    actionDescriptionDict.Add(131, "Start motors program and movements finished succesfully.");                                  
                    actionDescriptionDict.Add(132, "Start motors program and movements restored."); 
                    
                    actionDescriptionDict.Add(160, "Start motors started.");
                    actionDescriptionDict.Add(360, "Start motors running.");
                    actionDescriptionDict.Add(361, "Start motors running.");
                    actionDescriptionDict.Add(362, "Start motors running.");
                    actionDescriptionDict.Add(363, "Start motors running.");
                    actionDescriptionDict.Add(364, "Start motors running.");
                    actionDescriptionDict.Add(365, "Start motors running.");
                    actionDescriptionDict.Add(366, "Start motors running.");
                    actionDescriptionDict.Add(367, "Start motors running.");
                    actionDescriptionDict.Add(368, "Start motors running.");
                    actionDescriptionDict.Add(369, "Start motors running.");
                    actionDescriptionDict.Add(370, "Start motors running.");
                    actionDescriptionDict.Add(371, "Start motors running.");
                    actionDescriptionDict.Add(372, "Start motors running.");
                    actionDescriptionDict.Add(373, "Start motors running.");
                    actionDescriptionDict.Add(374, "Start motors running.");
                    actionDescriptionDict.Add(375, "Start motors running.");
                    actionDescriptionDict.Add(376, "Start motors running.");
                    actionDescriptionDict.Add(377, "Start motors running.");
                    actionDescriptionDict.Add(378, "Start motors running.");
                    actionDescriptionDict.Add(379, "Start motors running.");
                    actionDescriptionDict.Add(161, "Start motors finished succesfully.");                                                        
                    actionDescriptionDict.Add(162, "Start motors restored.");       
                    
                    actionDescriptionDict.Add(180, "Start movements started.");
                    actionDescriptionDict.Add(380, "Start movements running.");
                    actionDescriptionDict.Add(381, "Start movements running.");
                    actionDescriptionDict.Add(382, "Start movements running.");
                    actionDescriptionDict.Add(383, "Start movements running.");
                    actionDescriptionDict.Add(384, "Start movements running.");
                    actionDescriptionDict.Add(385, "Start movements running.");
                    actionDescriptionDict.Add(386, "Start movements running.");
                    actionDescriptionDict.Add(387, "Start movements running.");
                    actionDescriptionDict.Add(388, "Start movements running.");
                    actionDescriptionDict.Add(389, "Start movements running.");
                    actionDescriptionDict.Add(390, "Start movements running.");
                    actionDescriptionDict.Add(391, "Start movements running.");
                    actionDescriptionDict.Add(392, "Start movements running.");
                    actionDescriptionDict.Add(393, "Start movements running.");
                    actionDescriptionDict.Add(394, "Start movements running.");
                    actionDescriptionDict.Add(395, "Start movements running.");
                    actionDescriptionDict.Add(396, "Start movements running.");
                    actionDescriptionDict.Add(397, "Start movements running.");
                    actionDescriptionDict.Add(398, "Start movements running.");
                    actionDescriptionDict.Add(399, "Start movements running.");
                    actionDescriptionDict.Add(181, "Start movements finished succesfully.");                                                     
                    actionDescriptionDict.Add(182, "Start movements restored.");                                                                 

                    actionDescriptionDict.Add(200, "Start program started.");
                    actionDescriptionDict.Add(400, "Start program running.");
                    actionDescriptionDict.Add(401, "Start program running.");
                    actionDescriptionDict.Add(402, "Start program running.");
                    actionDescriptionDict.Add(403, "Start program running.");
                    actionDescriptionDict.Add(404, "Start program running.");
                    actionDescriptionDict.Add(405, "Start program running.");
                    actionDescriptionDict.Add(406, "Start program running.");
                    actionDescriptionDict.Add(407, "Start program running.");
                    actionDescriptionDict.Add(408, "Start program running.");
                    actionDescriptionDict.Add(409, "Start program running.");
                    actionDescriptionDict.Add(201, "Start program finished succesfully.");                                                       
                    actionDescriptionDict.Add(202, "Start program restored.");                                                                   

                    actionDescriptionDict.Add(210, "Stop movements and program started.");
                    actionDescriptionDict.Add(410, "Stop movements and program running.");
                    actionDescriptionDict.Add(411, "Stop movements and program running.");
                    actionDescriptionDict.Add(412, "Stop movements and program running.");
                    actionDescriptionDict.Add(413, "Stop movements and program running.");
                    actionDescriptionDict.Add(414, "Stop movements and program running.");
                    actionDescriptionDict.Add(415, "Stop movements and program running.");
                    actionDescriptionDict.Add(416, "Stop movements and program running.");
                    actionDescriptionDict.Add(417, "Stop movements and program running.");
                    actionDescriptionDict.Add(418, "Stop movements and program running.");
                    actionDescriptionDict.Add(419, "Stop movements and program running.");
                    actionDescriptionDict.Add(211, "Stop movements and program finished succesfully.");                                          
                    actionDescriptionDict.Add(212, "Stop movements and program restored.");                                                      

                    actionDescriptionDict.Add(220, "Stop movements started.");
                    actionDescriptionDict.Add(420, "Stop movements running.");
                    actionDescriptionDict.Add(421, "Stop movements running.");
                    actionDescriptionDict.Add(422, "Stop movements running.");
                    actionDescriptionDict.Add(423, "Stop movements running.");
                    actionDescriptionDict.Add(424, "Stop movements running.");
                    actionDescriptionDict.Add(425, "Stop movements running.");
                    actionDescriptionDict.Add(426, "Stop movements running.");
                    actionDescriptionDict.Add(427, "Stop movements running.");
                    actionDescriptionDict.Add(428, "Stop movements running.");
                    actionDescriptionDict.Add(429, "Stop movements running.");
                    actionDescriptionDict.Add(221, "Stop movements finished succesfully.");                                                      
                    actionDescriptionDict.Add(222, "Stop movements restored.");                                                                  

                    actionDescriptionDict.Add(230, "Stop program started.");
                    actionDescriptionDict.Add(430, "Stop program running.");
                    actionDescriptionDict.Add(431, "Stop program running.");
                    actionDescriptionDict.Add(432, "Stop program running.");
                    actionDescriptionDict.Add(433, "Stop program running.");
                    actionDescriptionDict.Add(434, "Stop program running.");
                    actionDescriptionDict.Add(435, "Stop program running.");
                    actionDescriptionDict.Add(436, "Stop program running.");
                    actionDescriptionDict.Add(437, "Stop program running.");
                    actionDescriptionDict.Add(438, "Stop program running.");
                    actionDescriptionDict.Add(439, "Stop program running.");
                    actionDescriptionDict.Add(231, "Stop program finished succesfully.");
                    actionDescriptionDict.Add(232, "Stop program restored.");                                                                    
                    
  

                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `hwIdAxoUrRobotics_T2O_State` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(702, "Input variable `hwIdAxoUrRobotics_T2O_IO` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(703, "Input variable `hwIdAxoUrRobotics_T2O_Joints` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(704, "Input variable `hwIdAxoUrRobotics_T2O_TCP` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(705, "Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(706, "Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(707, "Input variable `hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(708, "Input variable `hwIdAxoUrRobotics_O2T_Robot_IO` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(709, "Input variable `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(710, "Input variable `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2` has invalid valuein `Run` method!");
                    actionDescriptionDict.Add(711, "Input variable `refPowerOnPulse` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(712, "Error reading the `hwIdAxoUrRobotics_T2O_State` in the Run method!");
                    actionDescriptionDict.Add(713, "Error reading the `hwIdAxoUrRobotics_T2O_IO` in the Run method!");
                    actionDescriptionDict.Add(714, "Error reading the `hwIdAxoUrRobotics_T2O_Joints` in the Run method!");
                    actionDescriptionDict.Add(715, "Error reading the `hwIdAxoUrRobotics_T2O_TCP` in the Run method!");
                    actionDescriptionDict.Add(716, "Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers` in the Run method!");
                    actionDescriptionDict.Add(717, "Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers` in the Run method!");
                    actionDescriptionDict.Add(718, "Error reading the `hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers` in the Run method!");
                    actionDescriptionDict.Add(719, "Emergency stop active!");
                    actionDescriptionDict.Add(720, "Safety Error !");
                    actionDescriptionDict.Add(721, "Error writing the `hwIdAxoUrRobotics_O2T_Robot_IO` in the Run method!");
                    actionDescriptionDict.Add(722, "Error writing the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1` in the Run method!");
                    actionDescriptionDict.Add(723, "Error writing the `hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2` in the Run method!");
                    actionDescriptionDict.Add(800, "Start at main finished with error!");
                    actionDescriptionDict.Add(801, "Start at main was aborted, while not yet completed!");
                    actionDescriptionDict.Add(810, "Start motors and program finished with error!");
                    actionDescriptionDict.Add(811, "Start motors and program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(830, "Start motors program and movements finished with error!");
                    actionDescriptionDict.Add(831, "Start motors program and movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(860, "Start motors finished with error!");
                    actionDescriptionDict.Add(861, "Start motors was aborted, while not yet completed!");
                    actionDescriptionDict.Add(880, "Start movements finished with error!");
                    actionDescriptionDict.Add(881, "Start movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(900, "Start program finished with error!");
                    actionDescriptionDict.Add(901, "Start program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(910, "Stop movements and program finished with error!");
                    actionDescriptionDict.Add(911, "Stop movements and program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(920, "Stop movements finished with error!");
                    actionDescriptionDict.Add(921, "Stop movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(930, "Stop program finished with error!");
                    actionDescriptionDict.Add(931, "Stop program was aborted, while not yet completed!");


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

