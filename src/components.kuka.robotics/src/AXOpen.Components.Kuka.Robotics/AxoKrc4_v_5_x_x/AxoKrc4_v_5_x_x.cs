using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Kuka.Robotics.v_5_x_x
{
    public partial class AxoKrc4 : AXOpen.Core.AxoComponent, AXOpen.Components.Abstractions.Robotics.IAxoRobotics
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

                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_None is zero."                                                              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'NotAssigned'."               ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_512_DI_DO is zero."                                                         ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'DIO512'."                    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                  ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_None` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_None` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_512_DI_DO` has invalid value in `Run` method!"                                              ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_512_DI_DO` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the input data (Config.HWIDs.HwID_512_DI_DO)!"                                                                  ,"Check the value of the Config.HWIDs.HwID_512_DI_DO and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the output data (Config.HWIDs.HwID_512_DI_DO)!"                                                                 ,"Check the value of the Config.HWIDs.HwID_512_DI_DO and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("Start at main finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("Start at main was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("Start motors and program finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("Start motors and program was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("Start motors program and movements finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("Start motors program and movements was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem("Start motors task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem("Start motors task was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10050, new AxoMessengerTextItem("Start movements task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10051, new AxoMessengerTextItem("Start movements task was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10070, new AxoMessengerTextItem("Start program task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10071, new AxoMessengerTextItem("Start program task was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10080, new AxoMessengerTextItem("Stop motors task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10081, new AxoMessengerTextItem("Stop motors task was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10090, new AxoMessengerTextItem("Stop movements and program task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10091, new AxoMessengerTextItem("Stop movements and program task was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10100, new AxoMessengerTextItem("Stop movements task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10101, new AxoMessengerTextItem("Stop movements task was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10110, new AxoMessengerTextItem("Stop program task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10111, new AxoMessengerTextItem("Stop program task was aborted, while not yet completed!","Check the details.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(20001, new AxoMessengerTextItem("Stop program task was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(20002, new AxoMessengerTextItem("Stop program task was aborted, while not yet completed!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(20003, new AxoMessengerTextItem("Stop program task was aborted, while not yet completed!","Check the details.")),




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
    public partial class AxoKukaRobotics_Component_Status : AXOpen.Components.Robotics.AxoRobot_Status
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
                    errorDescriptionDict.Add(500, "Waiting for the signal Inputs.PpMoved to be set!");
                    errorDescriptionDict.Add(510, "Waiting for the signal Inputs.UserSafetySwitchClosed to be set!");
                    errorDescriptionDict.Add(511, "Waiting for the signal Inputs.AlarmStopActive to be set!");
                    errorDescriptionDict.Add(512, "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(513, "Waiting for the signal Inputs.StopMess to be reseted!");
                    errorDescriptionDict.Add(514, "Waiting for the signal Inputs.RcReady to be set!");
                    errorDescriptionDict.Add(515, "Waiting for the signal Inputs.InterfaceActivated to be set!");
                    errorDescriptionDict.Add(516, "Waiting for the signal Inputs.ProActive to be set!");
                    errorDescriptionDict.Add(520, "Waiting for the signal Inputs.UserSafetySwitchClosed to be set!");
                    errorDescriptionDict.Add(521, "Waiting for the signal Inputs.AlarmStopActive to be set!");
                    errorDescriptionDict.Add(522, "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(523, "Waiting for the signal Inputs.StopMess to be reseted!");
                    errorDescriptionDict.Add(524, "Waiting for the signal Inputs.RcReady to be set!");
                    errorDescriptionDict.Add(525, "Waiting for the signal Inputs.InterfaceActivated to be set!");
                    errorDescriptionDict.Add(526, "Waiting for the signal Inputs.ProActive to be set!");
                    errorDescriptionDict.Add(527, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(528, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(529, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(530, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(531, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(532, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(533, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(534, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(535, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(536, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(540, "Waiting for the signal Inputs.UserSafetySwitchClosed to be set!");
                    errorDescriptionDict.Add(541, "Waiting for the signal Inputs.AlarmStopActive to be set!");
                    errorDescriptionDict.Add(542, "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(550, "Waiting for the signal Inputs.ProActive to be set!");
                    errorDescriptionDict.Add(551, "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(552, "Waiting for the signal Inputs.StopMess to be reseted!");
                    errorDescriptionDict.Add(553, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(554, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(555, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(556, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(557, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(558, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(559, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(560, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(561, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(562, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(570, "Waiting for the signal Inputs.UserSafetySwitchClosed to be set!");
                    errorDescriptionDict.Add(571, "Waiting for the signal Inputs.AlarmStopActive to be set!");
                    errorDescriptionDict.Add(572, "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(573, "Waiting for the signal Inputs.StopMess to be reseted!");
                    errorDescriptionDict.Add(574, "Waiting for the signal Inputs.RcReady to be set!");
                    errorDescriptionDict.Add(575, "Waiting for the signal Inputs.InterfaceActivated to be set!");
                    errorDescriptionDict.Add(576, "Waiting for the signal Inputs.ProActive to be set!");
                    errorDescriptionDict.Add(580, "Waiting for the signal Inputs.DrivesReady to be reseted!");
                    errorDescriptionDict.Add(590, "Waiting for the signal Inputs.RobotStopped to be set!");
                    errorDescriptionDict.Add(591, "Waiting for the signal Inputs.ProActive to be reseted!");
                    errorDescriptionDict.Add(600, "Waiting for the signal Inputs.RobotStopped to be set!");
                    errorDescriptionDict.Add(610, "Waiting for the signal Inputs.ProActive to be reseted!");



                    //  General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");

                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_None is non zero.");
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'NotAssigned'.");

                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwID_512_DI_DO is zero.");
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'DIO512'.");


                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwID_in_1` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwID_512_DI_DO` has invalid value in `Run` method!");

                    errorDescriptionDict.Add(1201, "Error reading the input data (Config.HWIDs.HwID_512_DI_DO)!");

                    errorDescriptionDict.Add(1231, "Error writing the output data (Config.HWIDs.HwID_512_DI_DO)!");

                    errorDescriptionDict.Add(10000, "Start at main finished with error!");
                    errorDescriptionDict.Add(10001, "Start at main was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10010, "Start motors and program finished with error!");
                    errorDescriptionDict.Add(10011, "Start motors and program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10020, "Start motors program and movements finished with error!");
                    errorDescriptionDict.Add(10021, "Start motors program and movements was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10040, "Start motors task finished with error!");
                    errorDescriptionDict.Add(10041, "Start motors task was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10050, "Start movements task finished with error!");
                    errorDescriptionDict.Add(10051, "Start movements task was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10070, "Start program task finished with error!");
                    errorDescriptionDict.Add(10071, "Start program task was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10080, "Stop motors task finished with error!");
                    errorDescriptionDict.Add(10081, "Stop motors task was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10090, "Stop movements and program task finished with error!");
                    errorDescriptionDict.Add(10091, "Stop movements and program task was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10100, "Stop movements task finished with error!");
                    errorDescriptionDict.Add(10101, "Stop movements task was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10110, "Stop program task finished with error!");
                    errorDescriptionDict.Add(10111, "Stop program task was aborted, while not yet completed!");

                    errorDescriptionDict.Add(20001, "Stop program task was aborted, while not yet completed!");
                    errorDescriptionDict.Add(20002, "Stop program task was aborted, while not yet completed!");
                    errorDescriptionDict.Add(20003, "Stop program task was aborted, while not yet completed!");



                    errorDescriptionDict.Add(20001, "Emergency stop activated!");
                    errorDescriptionDict.Add(20002, "Safety circuit interupted!");
                    errorDescriptionDict.Add(20003, "Program error active!");


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
                    actionDescriptionDict.Add(300, "Start at main running: waiting for the program pointer changed.");
                    actionDescriptionDict.Add(301, "Start at main finished.");
                    actionDescriptionDict.Add(101, "Start at main finished succesfully.");
                    actionDescriptionDict.Add(102, "Start at main restored.");

                    actionDescriptionDict.Add(110, "Start motors and program started.");
                    actionDescriptionDict.Add(310, "Start motors and program running: waiting for the 'UserSafetySwitchClosed' is on.");
                    actionDescriptionDict.Add(311, "Start motors and program running: waiting for the 'AlarmStopActive' is on.");
                    actionDescriptionDict.Add(312, "Start motors and program running: waiting for the 'DrivesReady' is on.");
                    actionDescriptionDict.Add(313, "Start motors and program running: waiting for the 'StopMess' is off.");
                    actionDescriptionDict.Add(314, "Start motors and program running: waiting for the 'RcReady' is on.");
                    actionDescriptionDict.Add(315, "Start motors and program running: waiting for the 'InterfaceActivated' is on.");
                    actionDescriptionDict.Add(316, "Start motors and program running: waiting for the 'ProActive' is on.");
                    actionDescriptionDict.Add(317, "Start motors and program finished.");
                    actionDescriptionDict.Add(111, "Start motors and program finished succesfully.");
                    actionDescriptionDict.Add(112, "Start motors and program restored.");

                    actionDescriptionDict.Add(120, "Start motors program and movements started.");
                    actionDescriptionDict.Add(320, "Start motors program and movements running: waiting for the 'UserSafetySwitchClosed' is on.");
                    actionDescriptionDict.Add(321, "Start motors program and movements running: waiting for the 'AlarmStopActive' is on.");
                    actionDescriptionDict.Add(322, "Start motors program and movements running: waiting for the 'DrivesReady' is on.");
                    actionDescriptionDict.Add(323, "Start motors program and movements running: waiting for the 'StopMess' is off.");
                    actionDescriptionDict.Add(324, "Start motors program and movements running: waiting for the 'RcReady' is on.");
                    actionDescriptionDict.Add(325, "Start motors program and movements running: waiting for the 'InterfaceActivated' is on.");
                    actionDescriptionDict.Add(326, "Start motors program and movements running: waiting for the 'ProActive' is on.");
                    actionDescriptionDict.Add(327, "Start motors program and movements running: sending parameters of the movement to the controller.");
                    actionDescriptionDict.Add(328, "Start motors program and movements running: waiting for the movement parameters sent to the controller to be mirrored back.");
                    actionDescriptionDict.Add(334, "Start motors program and movements running: acknowleadging of the movement parameters.");
                    actionDescriptionDict.Add(335, "Start motors program and movements running: waiting for the movement is finished.");
                    actionDescriptionDict.Add(336, "Start motors program and movements running: acknowleadging of the finished movement.");
                    actionDescriptionDict.Add(337, "Start motors program and movements finished.");
                    actionDescriptionDict.Add(121, "Start motors program and movements finished succesfully.");
                    actionDescriptionDict.Add(122, "Start motors program and movements restored.");

                    actionDescriptionDict.Add(140, "Start motors started.");
                    actionDescriptionDict.Add(340, "Start motors running: waiting for the 'UserSafetySwitchClosed' is on.");
                    actionDescriptionDict.Add(341, "Start motors running: waiting for the 'AlarmStopActive' is on.");
                    actionDescriptionDict.Add(342, "Start motors running: waiting for the 'DrivesReady' is on.");
                    actionDescriptionDict.Add(343, "Start motors finished.");
                    actionDescriptionDict.Add(141, "Start motors finished succesfully.");
                    actionDescriptionDict.Add(142, "Start motors restored.");

                    actionDescriptionDict.Add(150, "Start movements started.");
                    actionDescriptionDict.Add(350, "Start movements running: waiting for the 'ProActive' is on.");
                    actionDescriptionDict.Add(351, "Start movements running: waiting for the 'DrivesReady' is on.");
                    actionDescriptionDict.Add(352, "Start movements running: waiting for the 'StopMess' is off.");
                    actionDescriptionDict.Add(353, "Start movements running: sending parameters of the movement to the controller.");
                    actionDescriptionDict.Add(354, "Start movements running: waiting for the movement parameters sent to the controller to be mirrored back.");
                    actionDescriptionDict.Add(360, "Start movements running: acknowleadging of the movement parameters.");
                    actionDescriptionDict.Add(361, "Start movements running: waiting for the movement is finished.");
                    actionDescriptionDict.Add(362, "Start movements running: acknowleadging of the finished movement.");
                    actionDescriptionDict.Add(363, "Start movements finished.");
                    actionDescriptionDict.Add(151, "Start movements finished succesfully.");
                    actionDescriptionDict.Add(152, "Start movements restored.");

                    actionDescriptionDict.Add(170, "Start program started.");
                    actionDescriptionDict.Add(370, "Start program running: waiting for the 'UserSafetySwitchClosed' is on.");
                    actionDescriptionDict.Add(371, "Start program running: waiting for the 'AlarmStopActive' is on.");
                    actionDescriptionDict.Add(372, "Start program running: waiting for the 'DrivesReady' is on.");
                    actionDescriptionDict.Add(373, "Start program running: waiting for the 'StopMess' is off.");
                    actionDescriptionDict.Add(374, "Start program running: waiting for the 'RcReady' is on.");
                    actionDescriptionDict.Add(375, "Start program running: waiting for the 'InterfaceActivated' is on.");
                    actionDescriptionDict.Add(376, "Start program running: waiting for the 'ProActive' is on.");
                    actionDescriptionDict.Add(377, "Start program finished.");
                    actionDescriptionDict.Add(171, "Start program finished succesfully.");
                    actionDescriptionDict.Add(172, "Start program restored.");

                    actionDescriptionDict.Add(180, "Stop motors started.");
                    actionDescriptionDict.Add(380, "Stop motors running: waiting for the 'DrivesReady' is off.");
                    actionDescriptionDict.Add(381, "Stop motors finished.");
                    actionDescriptionDict.Add(181, "Stop motors finished succesfully.");
                    actionDescriptionDict.Add(182, "Stop motors restored.");

                    actionDescriptionDict.Add(190, "Stop movements and program started.");
                    actionDescriptionDict.Add(390, "Stop movements and program running: waiting for the 'RobotStopped' is on.");
                    actionDescriptionDict.Add(391, "Stop movements and program running: waiting for the 'ProActive' is off.");
                    actionDescriptionDict.Add(392, "Stop movements and program finished.");
                    actionDescriptionDict.Add(191, "Stop movements and program finished succesfully.");
                    actionDescriptionDict.Add(192, "Stop movements and program restored.");

                    actionDescriptionDict.Add(200, "Stop movements started.");
                    actionDescriptionDict.Add(400, "Stop movements running: waiting for the 'RobotStopped' is on.");
                    actionDescriptionDict.Add(401, "Stop movements finished.");
                    actionDescriptionDict.Add(201, "Stop movements finished succesfully.");
                    actionDescriptionDict.Add(202, "Stop movements restored.");

                    actionDescriptionDict.Add(210, "Stop program started.");
                    actionDescriptionDict.Add(410, "Stop program running: waiting for the 'ProActive' is off.");
                    actionDescriptionDict.Add(411, "Stop program finished.");
                    actionDescriptionDict.Add(211, "Stop program finished succesfully");
                    actionDescriptionDict.Add(212, "Stop program restored.");

                    actionDescriptionDict.Add(10000, "Start at main finished with error!");
                    actionDescriptionDict.Add(10001, "Start at main was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10010, "Start motors and program finished with error!");
                    actionDescriptionDict.Add(10011, "Start motors and program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10020, "Start motors program and movements finished with error!");
                    actionDescriptionDict.Add(10021, "Start motors program and movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10040, "Start motors finished with error!");
                    actionDescriptionDict.Add(10041, "Start motors was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10050, "Start movements finished with error!");
                    actionDescriptionDict.Add(10051, "Start movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10070, "Start program finished with error!");
                    actionDescriptionDict.Add(10071, "Start program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10080, "Stop motors finished with error!");
                    actionDescriptionDict.Add(10081, "Stop motors was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10090, "Stop movements and program finished with error!");
                    actionDescriptionDict.Add(10091, "Stop movements and program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10100, "Stop movements finished with error!");
                    actionDescriptionDict.Add(10101, "Stop movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10110, "Stop program finished with error!");
                    actionDescriptionDict.Add(10111, "Stop program was aborted, while not yet completed!");


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
