using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Abb.Robotics
{
    public partial class AxoIrc5_v_1_x_x : AXOpen.Core.AxoComponent, AXOpen.Components.Abstractions.Robotics.IAxoRobotics
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwIdDI_64_bytes` has invalid value in `Run` method!",                          "Check the call of the `Run` method, if the `hwIdDI_64_bytes` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Input variable `hwIdDO_64_bytes` has invalid value in `Run` method!",                          "Check the call of the `Run` method, if the `hwIdDO_64_bytes` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Error reading the hwIdDI_64_bytes in the UpdateInputs method!",                                "Check the value of the hwIdDI_64_bytes and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Error writing the hwIdDO_64_bytes in the UpdateOutputs method!",                               "Check the value of the hwIdDO_64_bytes and reacheability of the device!")),

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

                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal Inputs.PpMoved to be set!",                                                                                        "Check the status of the `Inputs.PpMoved` signal.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoOn to be set!",                                                                                         "Check the status of the `Inputs.PpMoved` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmgStop to be reseted!",                                                                                    "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOnState to be set!",                                                                                   "Check the status of the `Inputs.MotorOnState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be set!",                                                                                        "Check the status of the `Inputs.CycleOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoOn to be set!",                                                                                         "Check the status of the `Inputs.PpMoved` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmgStop to be reseted!",                                                                                    "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(623,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOnState to be set!",                                                                                   "Check the status of the `Inputs.MotorOnState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(624,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be set!",                                                                                        "Check the status of the `Inputs.CycleOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(625,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(626,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(627,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(628,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(629,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(633,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(634,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(635,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(640,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoOn to be set!",                                                                                         "Check the status of the `Inputs.PpMoved` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(641,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(642,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmgStop to be reseted!",                                                                                    "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(643,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOnState to be set!",                                                                                   "Check the status of the `Inputs.MotorOnState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(644,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(650,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be set!",                                                                                        "Check the status of the `Inputs.CycleOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(651,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOnState to be set!",                                                                                   "Check the status of the `Inputs.MotorOnState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(652,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(653,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(654,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(655,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(656,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(657,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(658,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(659,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(660,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(661,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(662,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(670,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be set!",                                                                                        "Check the status of the `Inputs.CycleOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(671,  new AxoMessengerTextItem("Waiting for the signal Inputs.SystemInputBusy to be reseted!",                                                                            "Check the status of the `SystemInputBusy` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(680,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOffState to be set!",                                                                                  "Check the status of the `Inputs.MotorOffState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(681,  new AxoMessengerTextItem("Waiting for the signal Inputs.SystemInputBusy to be reseted!",                                                                            "Check the status of the `SystemInputBusy` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(690,  new AxoMessengerTextItem("Waiting for the signal Inputs.MoveInactive to be set!",                                                                                   "Check the status of the `Inputs.MoveInactive` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(691,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be reseted!",                                                                                    "Check the status of the `CycleOn` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(692,  new AxoMessengerTextItem("Waiting for the signal Inputs.MoveInactive to be set!",                                                                                   "Check the status of the `Inputs.MoveInactive` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(693,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be reseted!",                                                                                    "Check the status of the `CycleOn` signal.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
}

