using AXOpen.Messaging.Static;
using AXSharp.Connector;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
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

                //  General alarm
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwId` has invalid value in `Run` method!"                                                                      ,"Check the call of the `Run` method, if the `hwId` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of _hwIdDI_64_bytes is zero."                                                                    ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module with 64 input bytes (GsdId=1).","Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of _hwIdDO_64_bytes is zero."                                                                    ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module with 64 output bytes (GsdId=2).","Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                  ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `hwId` has invalid value in `Run` method!"                                                                     ,"Check the call of the `Run` method, if the `hwId` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `hwIdDI_64_bytes` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `hwIdDI_64_bytes` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Input variable `hwIdDO_64_bytes` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `hwIdDO_64_bytes` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the hwIdDI_64_bytes!"                                                                                           ,"Check the value of the _hwIdDI_64_bytes and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the _hwIdDO_64_bytes!"                                                                                          ,"Check the value of the _hwIdDO_64_bytes and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("Start at main finished with error!"                                                                                          ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("Start at main was aborted, while not yet completed!"                                                                         ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("Start motors and program finished with error!"                                                                               ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("Start motors and program was aborted, while not yet completed!"                                                              ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("Start motors program and movements finished with error!"                                                                     ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("Start motors program and movements was aborted, while not yet completed!"                                                    ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem("Start motors finished with error!"                                                                                           ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem("Start motors was aborted, while not yet completed!"                                                                          ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10050, new AxoMessengerTextItem("Start movements finished with error!"                                                                                        ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10051, new AxoMessengerTextItem("Start movements was aborted, while not yet completed!"                                                                       ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10070, new AxoMessengerTextItem("Start program finished with error!"                                                                                          ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10071, new AxoMessengerTextItem("Start program was aborted, while not yet completed!"                                                                         ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10080, new AxoMessengerTextItem("Stop motors finished with error!"                                                                                            ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10081, new AxoMessengerTextItem("Stop motors was aborted, while not yet completed!"                                                                           ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10090, new AxoMessengerTextItem("Stop movements and program finished with error!"                                                                             ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10091, new AxoMessengerTextItem("Stop movements and program was aborted, while not yet completed!"                                                            ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10100, new AxoMessengerTextItem("Stop movements finished with error!"                                                                                         ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10101, new AxoMessengerTextItem("Stop movements was aborted, while not yet completed!"                                                                        ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10110, new AxoMessengerTextItem("Stop program finished with error!"                                                                                           ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10111, new AxoMessengerTextItem("Stop program was aborted, while not yet completed!"                                                                          ,"Check the details.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(20001, new AxoMessengerTextItem("Emergency stop activated!"                                                                                                   ,"Check the status of the `Inputs.EmgStop` signal. Required value is 'FALSE'")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(20002, new AxoMessengerTextItem("Safety circuit interupted!"                                                                                                  ,"Check the status of the `Inputs.SafetyOk` signal.Required value is 'TRUE'")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(20003, new AxoMessengerTextItem("Program error active!"                                                                                                       ,"Check the status of the `Inputs.ProgExecError` signal. Required value is 'FALSE'")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal Inputs.PpMoved to be set!",                                                                                        "Check the status of the `Inputs.PpMoved` signal.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoOn to be set!",                                                                                         "Check the status of the `Inputs.PpMoved` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmgStop to be reseted!",                                                                                    "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOnState to be set!",                                                                                   "Check the status of the `Inputs.MotorOnState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be set!",                                                                                        "Check the status of the `Inputs.CycleOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoOn to be set!",                                                                                         "Check the status of the `Inputs.PpMoved` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmgStop to be reseted!",                                                                                    "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOnState to be set!",                                                                                   "Check the status of the `Inputs.MotorOnState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be set!",                                                                                        "Check the status of the `Inputs.CycleOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(525,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(527,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(528,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(529,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoOn to be set!",                                                                                         "Check the status of the `Inputs.PpMoved` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmgStop to be reseted!",                                                                                    "Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOnState to be set!",                                                                                   "Check the status of the `Inputs.MotorOnState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be set!",                                                                                        "Check the status of the `Inputs.CycleOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOnState to be set!",                                                                                   "Check the status of the `Inputs.MotorOnState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the signal Inputs.Error to be reseted!",                                                                                      "Check the status of the `Error` signal.")),
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be set!",                                                                                        "Check the status of the `Inputs.CycleOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the signal Inputs.SystemInputBusy to be reseted!",                                                                            "Check the status of the `SystemInputBusy` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal Inputs.MotorOffState to be set!",                                                                                  "Check the status of the `Inputs.MotorOffState` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(581,  new AxoMessengerTextItem("Waiting for the signal Inputs.SystemInputBusy to be reseted!",                                                                            "Check the status of the `SystemInputBusy` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the signal Inputs.MoveInactive to be set!",                                                                                   "Check the status of the `Inputs.MoveInactive` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be reseted!",                                                                                    "Check the status of the `CycleOn` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal Inputs.MoveInactive to be set!",                                                                                   "Check the status of the `Inputs.MoveInactive` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal Inputs.CycleOn to be reseted!",                                                                                    "Check the status of the `CycleOn` signal.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
}

