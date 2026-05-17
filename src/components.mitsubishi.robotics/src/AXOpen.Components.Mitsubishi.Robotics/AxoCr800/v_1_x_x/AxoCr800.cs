using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;

namespace AXOpen.Components.Mitsubishi.Robotics.v_1_x_x
{
    public partial class AxoCr800 : AXOpen.Core.AxoComponent
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

                //  General alarm
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                                               ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                                              ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_InOut_64_byte is zero."                                                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'In_Out_64_byte' (GsdId=ID_MODULE_IN_OUT64B)."            ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                                              ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                                             ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_InOut_64_byte` has invalid value in `Run` method!"                                                                      ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_InOut_64_byte` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the InOut_64_byte!"                                                                                                                         ,"Check the value of the Config.HWIDs.HwID_InOut_64_byte and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the InOut_64_byte!"                                                                                                                         ,"Check the value of the Config.HWIDs.HwID_InOut_64_byte and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("Start at main finished with error!"                                                                                                                      ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("Start at main was aborted, while not yet completed!"                                                                                                     ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("Start motors and program finished with error!"                                                                                                           ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("Start motors and program was aborted, while not yet completed!"                                                                                          ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("Stop movements finished with error!"                                                                                                                     ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("Stop movements was aborted, while not yet completed!"                                                                                                    ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10030, new AxoMessengerTextItem("Stop movements and program finished with error!"                                                                                                         ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10031, new AxoMessengerTextItem("Stop movements and program was aborted, while not yet completed!"                                                                                        ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem("Start movements finished with error!"                                                                                                                    ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem("Start movements was aborted, while not yet completed!"                                                                                                   ,"Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmergencyError to be reseted!",                                                                             "Check the status of the `EmergencyError` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the signal Inputs.ProgramReset to be set!",                                                                                   "Check the status of the `Inputs.ProgramReset` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal Inputs.EmergencyError to be reseted!",                                                                             "Check the status of the `EmergencyError` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal Inputs.ServoOn to be set!",                                                                                        "Check the status of the `Inputs.ServoOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal Inputs.Start to be set!",                                                                                          "Check the status of the `Inputs.Start` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signal Inputs.Stop to be set!",                                                                                           "Check the status of the `Inputs.Stop` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal Inputs.Stop to be set!",                                                                                           "Check the status of the `Inputs.Stop` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal Inputs.AutoEnable to be set!",                                                                                     "Check the status of the `Inputs.AutoEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the signal Inputs.OperationEnable to be set!",                                                                                "Check the status of the `Inputs.OperationEnable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the signal Inputs.ServoOn to be set!",                                                                                        "Check the status of the `Inputs.ServoOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the signal Inputs.ErrorReset to be reseted!",                                                                                 "Check the status of the `Inputs.ErrorReset` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(547,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(553,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
    public partial class AxoCr800_Component_Status : AXOpen.Components.Robotics.AxoRobot_Status
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
                    errorDescriptionDict.Add(500, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(501, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(502, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(503, "Waiting for the signal Inputs.EmergencyError to be reseted!");
                    errorDescriptionDict.Add(504, "Waiting for the signal Inputs.ProgramReset to be set!");
                    errorDescriptionDict.Add(510, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(511, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(512, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(513, "Waiting for the signal Inputs.EmergencyError to be reseted!");
                    errorDescriptionDict.Add(514, "Waiting for the signal Inputs.ServoOn to be set!");
                    errorDescriptionDict.Add(515, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(516, "Waiting for the signal Inputs.Start to be set!");
                    errorDescriptionDict.Add(517, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(520, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(521, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(522, "Waiting for the signal Inputs.Stop to be set!");
                    errorDescriptionDict.Add(530, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(531, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(532, "Waiting for the signal Inputs.Stop to be set!");
                    errorDescriptionDict.Add(540, "Waiting for the signal Inputs.AutoEnable to be set!");
                    errorDescriptionDict.Add(541, "Waiting for the signal Inputs.OperationEnable to be set!");
                    errorDescriptionDict.Add(542, "Waiting for the signal Inputs.ServoOn to be set!");
                    errorDescriptionDict.Add(543, "Waiting for the signal Inputs.ErrorReset to be reseted!");
                    errorDescriptionDict.Add(544, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(545, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(546, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(547, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(548, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(549, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(550, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(551, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(552, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(553, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    //  General alarm
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                                              );
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                                                                 );
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                   );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_InOut_64_byte is zero."                                                                                              );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                          );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                          );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                          );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                          );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                          );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'In_Out_64_byte' (GsdId=ID_MODULE_IN_OUT64B)."           );
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!"                                                                                             );
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                                                                );
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwID_InOut_64_byte` has invalid value in `Run` method!"                                                                                   );
                    errorDescriptionDict.Add(1201, "Error reading the InOut_64_byte!"                                                                                                                        );
                    errorDescriptionDict.Add(1231, "Error writing the InOut_64_byte!"                                                                                                                        );
                    errorDescriptionDict.Add(10000, "Start at main finished with error!"                                                                                                                     );
                    errorDescriptionDict.Add(10001, "Start at main was aborted, while not yet completed!"                                                                                                    );
                    errorDescriptionDict.Add(10010, "Start motors and program finished with error!"                                                                                                          );
                    errorDescriptionDict.Add(10011, "Start motors and program was aborted, while not yet completed!"                                                                                         );
                    errorDescriptionDict.Add(10020, "Stop movements finished with error!"                                                                                                                    );
                    errorDescriptionDict.Add(10021, "Stop movements was aborted, while not yet completed!"                                                                                                   );
                    errorDescriptionDict.Add(10030, "Stop movements and program finished with error!"                                                                                                        );
                    errorDescriptionDict.Add(10031, "Stop movements and program was aborted, while not yet completed!"                                                                                       );
                    errorDescriptionDict.Add(10040, "Start movements finished with error!"                                                                                                                   );
                    errorDescriptionDict.Add(10041, "Start movements was aborted, while not yet completed!");

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
                    actionDescriptionDict.Add(300, "Start at main running: switching to auto mode.");
                    actionDescriptionDict.Add(301, "Start at main running: enabling the operations.");
                    actionDescriptionDict.Add(302, "Start at main running: reseting the error.");
                    actionDescriptionDict.Add(303, "Start at main running: reseting the emergency stop.");
                    actionDescriptionDict.Add(304, "Start at main running: reseting the program.");
                    actionDescriptionDict.Add(305, "Start at main finished.");
                    actionDescriptionDict.Add(101, "Start at main finished succesfully.");
                    actionDescriptionDict.Add(102, "Start at main restored.");

                    actionDescriptionDict.Add(110, "Start motors and program started.");
                    actionDescriptionDict.Add(310, "Start motors and program running: switching to auto mode.");
                    actionDescriptionDict.Add(311, "Start motors and program running: enabling the operations.");
                    actionDescriptionDict.Add(312, "Start motors and program running: reseting the error.");
                    actionDescriptionDict.Add(313, "Start motors and program running: reseting the emergency stop.");
                    actionDescriptionDict.Add(314, "Start motors and program running: starting the servomotors.");
                    actionDescriptionDict.Add(315, "Start motors and program running: starting the servomotors.");
                    actionDescriptionDict.Add(316, "Start motors and program running: starting the program.");
                    actionDescriptionDict.Add(317, "Start motors and program running: starting the program.");
                    actionDescriptionDict.Add(318, "Start motors and program finished.");
                    actionDescriptionDict.Add(111, "Start motors and program finished succesfully.");
                    actionDescriptionDict.Add(112, "Start motors and program restored.");

                    actionDescriptionDict.Add(120, "Stop movements started.");
                    actionDescriptionDict.Add(320, "Stop movements running: switching to auto mode.");
                    actionDescriptionDict.Add(321, "Stop movements running: enabling the operations.");
                    actionDescriptionDict.Add(322, "Stop movements running: stopping the movement.");
                    actionDescriptionDict.Add(323, "Stop movements finished.");
                    actionDescriptionDict.Add(121, "Stop movements finished succesfully.");
                    actionDescriptionDict.Add(122, "Stop movements restored.");

                    actionDescriptionDict.Add(130, "Stop movements and program started.");
                    actionDescriptionDict.Add(330, "Stop movements and program running: switching to auto mode.");
                    actionDescriptionDict.Add(331, "Stop movements and program running: enabling the operations.");
                    actionDescriptionDict.Add(332, "Stop movements and program running: stopping the movement.");
                    actionDescriptionDict.Add(333, "Stop movements and program finished.");
                    actionDescriptionDict.Add(131, "Stop movements and program finished succesfully.");
                    actionDescriptionDict.Add(132, "Stop movements and program restored.");

                    actionDescriptionDict.Add(140, "Start movements started.");
                    actionDescriptionDict.Add(340, "Start movements running: waiting for all movement conditions to be fulfilled.");
                    actionDescriptionDict.Add(344, "Start movements running: sending parameters of the movement to the controller.");
                    actionDescriptionDict.Add(345, "Start movements running: waiting for the movement parameters sent to the controller to be mirrored back.");
                    actionDescriptionDict.Add(351, "Start movements running: acknowleadging of the movement parameters.");
                    actionDescriptionDict.Add(352, "Start movements running: waiting for the movement is finished.");
                    actionDescriptionDict.Add(353, "Start movements running: acknowleadging of the finished movement.");
                    actionDescriptionDict.Add(354, "Start movements finished.");
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

