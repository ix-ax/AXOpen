using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Kuka.Robotics
{
    public partial class AxoKrc4_v_5_x_x : AXOpen.Core.AxoComponent, AXOpen.Components.Abstractions.Robotics.IAxoRobotics
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Start motors program and movements started.",                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Start motors program and movements finished succesfully.",                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Start motors program and movements restored.",                                                 "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("Start motors started.",                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("Start motors finished succesfully.",                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("Start motors restored.",                                                                       "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("Start movements started.",                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("Start movements finished succesfully.",                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("Start movements restored.",                                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(170, new AxoMessengerTextItem("Start program started.",                                                                       "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(171, new AxoMessengerTextItem("Start program finished succesfully.",                                                          "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(172, new AxoMessengerTextItem("Start program restored.",                                                                      "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(180, new AxoMessengerTextItem("Stop motors started.",                                                                         "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(181, new AxoMessengerTextItem("Stop motors finished succesfully.",                                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(182, new AxoMessengerTextItem("Stop motors restored.",                                                                        "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(190, new AxoMessengerTextItem("Stop movements and program started.",                                                          "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(191, new AxoMessengerTextItem("Stop movements and program finished succesfully.",                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(192, new AxoMessengerTextItem("Stop movements and program restored.",                                                         "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(200, new AxoMessengerTextItem("Stop movements started.",                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(201, new AxoMessengerTextItem("Stop movements finished succesfully.",                                                         "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(202, new AxoMessengerTextItem("Stop movements restored.",                                                                     "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(210, new AxoMessengerTextItem("Stop program started.",                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(211, new AxoMessengerTextItem("Stop program finished succesfully.",                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(212, new AxoMessengerTextItem("Stop program restored.",                                                                       "")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                  "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwId_512_DI_DO` has invalid value in `Run` method!",                           "Check the call of the `Run` method, if the `hwId_512_DI_DO` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Error reading the hwId_512_DI_DO in the UpdateInputs method!",                                 "Check the value of the hwId_512_DI_DO and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Error writing the hwId_512_DI_DO in the UpdateOutputs method!",                                "Check the value of the hwId_512_DI_DO and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Start at main finished with error!",                                                           "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Start at main was aborted, while not yet completed!",                                          "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Start motors and program finished with error!",                                                "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Start motors and program was aborted, while not yet completed!",                               "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Start motors program and movements finished with error!",                                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Start motors program and movements was aborted, while not yet completed!",                     "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Start motors finished with error!",                                                            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Start motors was aborted, while not yet completed!",                                           "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("Start movements finished with error!",                                                         "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("Start movements was aborted, while not yet completed!",                                        "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(870, new AxoMessengerTextItem("Start program finished with error!",                                                           "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(871, new AxoMessengerTextItem("Start program was aborted, while not yet completed!",                                          "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(880, new AxoMessengerTextItem("Stop motors finished with error!",                                                             "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(881, new AxoMessengerTextItem("Stop motors was aborted, while not yet completed!",                                            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(890, new AxoMessengerTextItem("Stop movements and program finished with error!",                                              "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(891, new AxoMessengerTextItem("Stop movements and program was aborted, while not yet completed!",                             "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(900, new AxoMessengerTextItem("Stop movements finished with error!",                                                          "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(901, new AxoMessengerTextItem("Stop movements was aborted, while not yet completed!",                                         "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(910, new AxoMessengerTextItem("Stop program finished with error!",                                                            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(911, new AxoMessengerTextItem("Stop program was aborted, while not yet completed!",                                           "Check the details.")),


        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal Inputs.PpMoved to be set!",                                                                                        "Check the status of the `Inputs.PpMoved` signal.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal Inputs.UserSafetySwitchClosed to be set!",                                                                         "Check the status of the `Inputs.UserSafetySwitchClosed` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal Inputs.AlarmStopActive to be set!",                                                                                "Check the status of the `AlarmStopActive` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal Inputs.DrivesReady to be set!",                                                                                    "Check the status of the `DrivesReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal Inputs.StopMess to be reseted!",                                                                                   "Check the status of the `Inputs.StopMess` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal Inputs.RcReady to be set!",                                                                                        "Check the status of the `Inputs.RcReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal Inputs.InterfaceActivated to be set!",                                                                             "Check the status of the `InterfaceActivated` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal Inputs.ProActive to be set!",                                                                                      "Check the status of the `ProActive` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal Inputs.UserSafetySwitchClosed to be set!",                                                                         "Check the status of the `Inputs.UserSafetySwitchClosed` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal Inputs.AlarmStopActive to be set!",                                                                                "Check the status of the `AlarmStopActive` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signal Inputs.DrivesReady to be set!",                                                                                    "Check the status of the `DrivesReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal Inputs.StopMess to be reseted!",                                                                                   "Check the status of the `Inputs.StopMess` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal Inputs.RcReady to be set!",                                                                                        "Check the status of the `Inputs.RcReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(525,  new AxoMessengerTextItem("Waiting for the signal Inputs.InterfaceActivated to be set!",                                                                             "Check the status of the `InterfaceActivated` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the signal Inputs.ProActive to be set!",                                                                                      "Check the status of the `ProActive` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(527,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(528,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(529,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal Inputs.UserSafetySwitchClosed to be set!",                                                                         "Check the status of the `Inputs.UserSafetySwitchClosed` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the signal Inputs.AlarmStopActive to be set!",                                                                                "Check the status of the `AlarmStopActive` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the signal Inputs.DrivesReady to be set!",                                                                                    "Check the status of the `DrivesReady` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the signal Inputs.ProActive to be set!",                                                                                      "Check the status of the `Inputs.ProActive` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the signal Inputs.DrivesReady to be set!",                                                                                    "Check the status of the `Inputs.DrivesReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the signal Inputs.StopMess to be reseted!",                                                                                   "Check the status of the `StopMess` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(553,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(554,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(555,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(556,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(557,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(558,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(559,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(561,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal Inputs.UserSafetySwitchClosed to be set!",                                                                         "Check the status of the `Inputs.UserSafetySwitchClosed` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the signal Inputs.AlarmStopActive to be set!",                                                                                "Check the status of the `AlarmStopActive` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(572,  new AxoMessengerTextItem("Waiting for the signal Inputs.DrivesReady to be set!",                                                                                    "Check the status of the `Inputs.DrivesReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(573,  new AxoMessengerTextItem("Waiting for the signal Inputs.StopMess to be reseted!",                                                                                   "Check the status of the `StopMess` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(574,  new AxoMessengerTextItem("Waiting for the signal Inputs.RcReady to be set!",                                                                                        "Check the status of the `Inputs.RcReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(575,  new AxoMessengerTextItem("Waiting for the signal Inputs.InterfaceActivated to be set!",                                                                             "Check the status of the `Inputs.InterfaceActivated` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(576,  new AxoMessengerTextItem("Waiting for the signal Inputs.ProActive to be set!",                                                                                      "Check the status of the `Inputs.ProActive` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal Inputs.DrivesReady to be reseted!",                                                                                "Check the status of the `DrivesReady` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the signal Inputs.RobotStopped to be set!",                                                                                   "Check the status of the `Inputs.RobotStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the signal Inputs.ProActive to be reseted!",                                                                                  "Check the status of the `ProActive` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal Inputs.RobotStopped to be set!",                                                                                   "Check the status of the `Inputs.RobotStopped` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal Inputs.ProActive to be reseted!",                                                                                  "Check the status of the `ProActive` signal.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
}
