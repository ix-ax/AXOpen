using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Threading.Channels;

namespace AXOpen.Components.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoInsight
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Clearing of the inspection results started.",                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Clearing of the inspection results finished succesfully.",                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Clearing of the inspection results restored.",                                 "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Reading started.",                                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Reading finished succesfully.",                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Reading restored.",                                                            "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Change job by name started.",                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Change job by name finished succesfully.",                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Change job by name restored.",                                                 "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("Change job by number started.",                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("Change job by number finished succesfully.",                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("Change job by number restored.",                                               "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("SoftEvent started.",                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("SoftEvent finished succesfully.",                                              "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("SoftEvent restored.",                                                          "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(160, new AxoMessengerTextItem("SendUserData started.",                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(161, new AxoMessengerTextItem("SendUserData finished succesfully.",                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(162, new AxoMessengerTextItem("SendUserData restored.",                                                       "")),

                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!"                                                    ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionControl is zero."                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'Acquisition_Control'."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionStatus is zero."                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2.Expected module: 'Acquisition_Status'."         ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HW_InspectionControl is zero."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 3.Expected module: 'Inspection_Control'."         ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HW_InspectionStatus is zero."                                                    ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 4.Expected module: 'Inspection_Status'."          ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(750, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HW_CommandControl is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(751, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(752, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(753, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(754, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(755, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(756, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 5.Expected module: 'Command_Control'."            ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(760, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdSoftEventControl is zero."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(761, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(762, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(763, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(764, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(765, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(766, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 6.Expected module: 'SoftEvent_Control'."          ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(770, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdUserData is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(771, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(772, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(773, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(774, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(775, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(776, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 7.Allowed modules: 'User_Data-16_bytes,User_Data-32_bytes,User_Data-64_bytes,User_Data-128_bytes,User_Data-250_bytes'.", "Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(780, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdResultData is zero."                                                         ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(781, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(782, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(783, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(784, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(785, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(786, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 8.Allowed modules: 'Result_Data-16_bytes,Result_Data-32_bytes,Result_Data-64_bytes,Result_Data-128_bytes,Result_Data-246_bytes'."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                  ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `hwId` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdAcquisitionControl ` has invalid value in `Run` method!"                                     ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdAcquisitionControl ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdAcquisitionStatus ` has invalid value in `Run` method!"                                      ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdAcquisitionStatus ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1134, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_InspectionControl ` has invalid value in `Run` method!"                                       ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_InspectionControl ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1135, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_InspectionStatus ` has invalid value in `Run` method!"                                        ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_InspectionStatus ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1136, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_CommandControl ` has invalid value in `Run` method!"                                          ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_CommandControl ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1137, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdSoftEventControl ` has invalid value in `Run` method!"                                       ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdSoftEventControl ` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1138, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdUserData` has invalid value in `Run` method!"                                                ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdUserData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1139, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdResultData` has invalid value in `Run` method!"                                              ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdResultData ` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the AcquisitionStatus!"                                                                                         ,"Check the value of the Config.HWIDs.HwIdAcquisitionStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1202, new AxoMessengerTextItem("Error reading the InspectionStatus!"                                                                                          ,"Check the value of the Config.HWIDs.HW_InspectionStatusand reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1203, new AxoMessengerTextItem("Error reading the CommandControl!"                                                                                            ,"Check the value of the Config.HWIDs.HW_CommandControl  and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1204, new AxoMessengerTextItem("Error reading the SoftEventControl!"                                                                                          ,"Check the value of the Config.HWIDs.HwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1205, new AxoMessengerTextItem("Error reading the ResultData!"                                                                                                ,"Check the value of the Config.HWIDs.HwIdResultData and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1206, new AxoMessengerTextItem("ResultData has invalid size!"                                                                                                 ,"Check the real size of the `ResultData`, so as the value of the ResultDataSize parameter!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the AcquisitionControl!"                                                                                        ,"Check the value of the Config.HWIDs.HwIdAcquisitionControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1232, new AxoMessengerTextItem("Error writing the ResultsControl!"                                                                                            ,"Check the value of the hwIdesultsControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1233, new AxoMessengerTextItem("Error writing the CommandControl!"                                                                                            ,"Check the value of the Config.HWIDs.HW_CommandControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1234, new AxoMessengerTextItem("Error writing the SoftEventControl!"                                                                                          ,"Check the value of the Config.HWIDs.HwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1235, new AxoMessengerTextItem("UserData has invalid size!"                                                                                                   ,"Check the real size of the `UserData`, so as the value of the UserDataSize parameter!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1236, new AxoMessengerTextItem("Error writing the 16bytes of the UserData!"                                                                                   ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1237, new AxoMessengerTextItem("Error writing the 32bytes of the UserData!"                                                                                   ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1238, new AxoMessengerTextItem("Error writing the 64bytes of the UserData!"                                                                                   ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1239, new AxoMessengerTextItem("Error writing the 128bytes of the UserData!"                                                                                  ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1240, new AxoMessengerTextItem("Error writing the 254bytes of the UserData!"                                                                                  ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("Clearing of the inspection results finished with error!"                                                                     ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("Clearing of the inspection results was aborted, while not yet completed!"                                                    ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("Reading finished with error!"                                                                                                ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("Reading was aborted, while not yet completed!"                                                                               ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("Change job by name finished with error!"                                                                                     ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("Change job by name was aborted, while not yet completed!"                                                                    ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem("Change job by number finished with error!"                                                                                   ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem("Change job by number was aborted, while not yet completed!"                                                                  ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10050, new AxoMessengerTextItem("SoftEvent finished with error!"                                                                                              ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10051, new AxoMessengerTextItem("SoftEvent was aborted, while not yet completed!"                                                                             ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10060, new AxoMessengerTextItem("SendUserData finished with error!"                                                                                           ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10061, new AxoMessengerTextItem("SendUserData was aborted, while not yet completed!"                                                                          ,"Check the details.")),

            };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(501, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.ResultsValid to be reseted!"                                                           ,"Check the status of the `InspectionStatus.ResultsValid` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(511, new AxoMessengerTextItem("Waiting for the signal AcquisitionStatus.ExposureComplete to be reseted!"                                                      ,"Check the status of the `AcquisitionStatus.ExposureComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.ResultsValid to be reseted!"                                                           ,"Check the status of the `InspectionStatus.ResultsValid` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.Error to be reseted!"                                                                  ,"Check the status of the `InspectionStatus.Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514, new AxoMessengerTextItem("Waiting for the signal AcquisitionStatus.TriggerReady to be set!"                                                              ,"Check the status of the `AcquisitionStatus.TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515, new AxoMessengerTextItem("Waiting for the signal AcquisitionStatus.TriggerAcknowledge to be set!"                                                        ,"Check the status of the `AcquisitionStatus.TriggerAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.InspectionCompleted to be toggled!"                                                    ,"Check the status of the `InspectionStatus.InspectionCompleted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.ResultsValid to be set!"                                                               ,"Check the status of the `InspectionStatus.ResultsValid` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(518, new AxoMessengerTextItem("Waiting for the InspectionResults to be copied!"                                                                               ,"Check the status of the `InspectionResults` data.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(520, new AxoMessengerTextItem("Empty job name inserted!"                                                                                                      ,"Check the required job name.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.CommandExecuting to be reseted!"                                                       ,"Check the status of the `InspectionStatus.CommandExecuting` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522, new AxoMessengerTextItem("Waiting for the signal Online to be reseted!"                                                                                  ,"Check the status of the `Online` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.Error to be reseted!"                                                                  ,"Check the status of the `InspectionStatus.Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524, new AxoMessengerTextItem("Waiting for the Job name to be written to User data!"                                                                          ,"Check the status of the `User` data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(525, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.ExtendedUserDataSetAcknowledge to be set!"                                             ,"Check the status of the `InspectionStatus.ExtendedUserDataSetAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.ExtendedUserDataSetAcknowledge to be reseted!"                                         ,"Check the status of the `InspectionStatus.ExtendedUserDataSetAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(527, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.CommandComplete to be set!"                                                            ,"Check the status of the `InspectionStatus.CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(528, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.CommandComplete to be reseted!"                                                        ,"Check the status of the `InspectionStatus.CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(529, new AxoMessengerTextItem("Waiting for the signal AcquisitionStatus.Online to be set!"                                                                    ,"Check the status of the `AcquisitionStatus.Online` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(540, new AxoMessengerTextItem("Required job number is greater than the maximal value!"                                                                        ,"Check the sensor manufacturer documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.CommandExecuting to be reseted!"                                                       ,"Check the status of the `InspectionStatus.CommandExecuting` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542, new AxoMessengerTextItem("Waiting for the signal AcquisitionStatus.Online to be reseted!"                                                                ,"Check the status of the `AcquisitionStatus.Online` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.Error to be reseted!"                                                                  ,"Check the status of the `InspectionStatus.Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.CommandComplete to be set!"                                                            ,"Check the status of the `InspectionStatus.CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.CommandComplete to be reseted!"                                                        ,"Check the status of the `InspectionStatus.CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546, new AxoMessengerTextItem("Waiting for the signal AcquisitionStatus.Online to be set!"                                                                    ,"Check the status of the `AcquisitionStatus.Online` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(550, new AxoMessengerTextItem("Required soft event number is greater than the maximal value of 7!"                                                            ,"Check the sensor manufacturer documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552, new AxoMessengerTextItem("Waiting for the signal SoftEventStatus.TriggerSoftEventAcknowledge to be set!"                                                 ,"Check the status of the `SoftEventStatus.TriggerSoftEventAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(553, new AxoMessengerTextItem("Waiting for the signal SoftEventStatus.TriggerSoftEventAcknowledge to be reseted!"                                             ,"Check the status of the `SoftEventStatus.TriggerSoftEventAcknowledge` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(561, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.ExtendedUserDataSetAcknowledge to be set!"                                             ,"Check the status of the `InspectionStatus.ExtendedUserDataSetAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562, new AxoMessengerTextItem("Waiting for the signal InspectionStatus.ExtendedUserDataSetAcknowledge to be reseted!"                                         ,"Check the status of the `InspectionStatus.ExtendedUserDataSetAcknowledge` signal.")),
            };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoInsight_Status : AxoComponent_Status
    {
        Dictionary<ulong, string> errorDescriptionDict = new Dictionary<ulong, string>();
        Dictionary<ulong, string> actionDescriptionDict = new Dictionary<ulong, string>();

        public string ErrorDescription 
        {
            get
            {
                if(errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<ulong, string>(); }
                if(errorDescriptionDict.Count == 0)
                {
                    errorDescriptionDict.Add(0      , "   ");

                    errorDescriptionDict.Add(501, "Waiting for the signal InspectionStatus.ResultsValid to be reseted!");

                    errorDescriptionDict.Add(511, "Waiting for the signal AcquisitionStatus.ExposureComplete to be reseted!");
                    errorDescriptionDict.Add(512, "Waiting for the signal InspectionStatus.ResultsValid to be reseted!");
                    errorDescriptionDict.Add(513, "Waiting for the signal InspectionStatus.Error to be reseted!");
                    errorDescriptionDict.Add(514, "Waiting for the signal AcquisitionStatus.TriggerReady to be set!");
                    errorDescriptionDict.Add(515, "Waiting for the signal AcquisitionStatus.TriggerAcknowledge to be set!");
                    errorDescriptionDict.Add(516, "Waiting for the signal InspectionStatus.InspectionCompleted to be toggled!");
                    errorDescriptionDict.Add(517, "Waiting for the signal InspectionStatus.ResultsValid to be set!");
                    errorDescriptionDict.Add(518, "Waiting for the InspectionResults to be copied!");

                    errorDescriptionDict.Add(520, "Empty job name inserted!");
                    errorDescriptionDict.Add(521, "Waiting for the signal InspectionStatus.CommandExecuting to be reseted!");
                    errorDescriptionDict.Add(522, "Waiting for the signal AcquisitionStatus.Online to be reseted!");
                    errorDescriptionDict.Add(523, "Waiting for the signal InspectionStatus.Error to be reseted!");
                    errorDescriptionDict.Add(524, "Waiting for the Job name to be written to the User data!");
                    errorDescriptionDict.Add(525, "Waiting for the signal InspectionStatus.ExtendedUserDataSetAcknowledge to be set!");
                    errorDescriptionDict.Add(526, "Waiting for the signal InspectionStatus.ExtendedUserDataSetAcknowledge to be reseted!");
                    errorDescriptionDict.Add(527, "Waiting for the signal InspectionStatus.CommandComplete to be set!");
                    errorDescriptionDict.Add(528, "Waiting for the signal InspectionStatus.CommandComplete to be reseted!");
                    errorDescriptionDict.Add(529, "Waiting for the signal AcquisitionStatus.Online to be set!");

                    errorDescriptionDict.Add(540, "Required job number is greater than the maximal value!");
                    errorDescriptionDict.Add(541, "Waiting for the signal InspectionStatus.CommandExecuting to be reseted!");
                    errorDescriptionDict.Add(542, "Waiting for the signal AcquisitionStatus.Online to be reseted!");
                    errorDescriptionDict.Add(543, "Waiting for the signal InspectionStatus.Error to be reseted!");
                    errorDescriptionDict.Add(544, "Waiting for the signal InspectionStatus.CommandComplete to be set!");
                    errorDescriptionDict.Add(545, "Waiting for the signal InspectionStatus.CommandComplete to be reseted!");
                    errorDescriptionDict.Add(546, "Waiting for the signal AcquisitionStatus.Online to be set!");

                    errorDescriptionDict.Add(550, "Required soft event number is greater than the maximal value of 7!");
                    errorDescriptionDict.Add(552, "Waiting for the signal SoftEventStatus.TriggerSoftEventAcknowledge to be set!");
                    errorDescriptionDict.Add(553, "Waiting for the signal SoftEventStatus.TriggerSoftEventAcknowledge to be reseted!");

                    errorDescriptionDict.Add(561, "Waiting for the signal InspectionStatus.ExtendedUserDataSetAcknowledge to be set!");
                    errorDescriptionDict.Add(562, "Waiting for the signal InspectionStatus.ExtendedUserDataSetAcknowledge to be reseted!");

                    //  General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                               );
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                    );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionControl is zero."                                                                          );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                           );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                           );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                           );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                           );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                           );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'Acquisition_Control'."                   );
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionStatus is zero."                                                                           );
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                           );
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                           );
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                           );
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                           );
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                           );
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2.Expected module: 'Acquisition_Status'."                     );
                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HW_InspectionControl is zero."                                                                           );
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                           );
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                           );
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                           );
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                           );
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                           );
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3.Expected module: 'Inspection_Control'."                     );
                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HW_InspectionStatus is zero."                                                                            );
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                           );
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                           );
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                           );
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                           );
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                           );
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4.Expected module: 'Inspection_Status'."                      );
                    errorDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HW_CommandControl is zero."                                                                              );
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."                           );
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."                           );
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."                           );
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."                           );
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."                           );
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5.Expected module: 'Command_Control'."                        );
                    errorDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDs.HwIdSoftEventControl is zero."                                                                            );
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."                           );
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."                           );
                    errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."                           );
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."                           );
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."                           );
                    errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6.Expected module: 'SoftEvent_Control'."                      );
                    errorDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDs.HwIdUserData is zero."                                                                                    );
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."                           );
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."                           );
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."                           );
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."                           );
                    errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7.");
                    errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7.Allowed modules: 'User_Data-16_bytes,User_Data-32_bytes,User_Data-64_bytes,User_Data-128_bytes,User_Data-250_bytes'.");
                    errorDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDs.HwIdResultData is zero."                                                                                    );
                    errorDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."                             );
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."                             );
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."                             );
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."                             );
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."                             );
                    errorDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8.Allowed modules: 'Result_Data-16_bytes,Result_Data-32_bytes,Result_Data-64_bytes,Result_Data-128_bytes,Result_Data-246_bytes'.");
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!"); 
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!");   
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwIdAcquisitionControl ` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwIdAcquisitionStatus ` has invalid value in `Run` method!"); 
                    errorDescriptionDict.Add(1134, "Input variable `Config.HWIDs.HW_InspectionControl ` has invalid value in `Run` method!"); 
                    errorDescriptionDict.Add(1135, "Input variable `Config.HWIDs.HW_InspectionStatus ` has invalid value in `Run` method!");  
                    errorDescriptionDict.Add(1136, "Input variable `Config.HWIDs.HW_CommandControl ` has invalid value in `Run` method!");    
                    errorDescriptionDict.Add(1137, "Input variable `Config.HWIDs.HwIdSoftEventControl ` has invalid value in `Run` method!");  
                    errorDescriptionDict.Add(1138, "Input variable `Config.HWIDs.HwIdUserData` has invalid value in `Run` method!");  
                    errorDescriptionDict.Add(1139, "Input variable `Config.HWIDs.HwIdResultData` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1201, "Error reading the AcquisitionStatus!");
                    errorDescriptionDict.Add(1202, "Error reading the InspectionStatus!"); 
                    errorDescriptionDict.Add(1203, "Error reading the CommandControl!");   
                    errorDescriptionDict.Add(1204, "Error reading the SoftEventControl!"); 
                    errorDescriptionDict.Add(1205, "Error reading the ResultData!"); 
                    errorDescriptionDict.Add(1206, "ResultData has invalid size!");
                    errorDescriptionDict.Add(1231, "Error writing the AcquisitionControl!");
                    errorDescriptionDict.Add(1232, "Error writing the ResultsControl!");   
                    errorDescriptionDict.Add(1233, "Error writing the CommandControl!");   
                    errorDescriptionDict.Add(1234, "Error writing the SoftEventControl!"); 
                    errorDescriptionDict.Add(1235, "UserData has invalid size!");  
                    errorDescriptionDict.Add(1236, "Error writing the 16bytes of the UserData!");  
                    errorDescriptionDict.Add(1237, "Error writing the 32bytes of the UserData!");  
                    errorDescriptionDict.Add(1238, "Error writing the 64bytes of the UserData!");  
                    errorDescriptionDict.Add(1239, "Error writing the 128bytes of the UserData!"); 
                    errorDescriptionDict.Add(1240, "Error writing the 254bytes of the UserData!"); 
                    errorDescriptionDict.Add(10000, "Clearing of the inspection results finished with error!");   
                    errorDescriptionDict.Add(10001, "Clearing of the inspection results was aborted, while not yet completed!");   
                    errorDescriptionDict.Add(10010, "Reading finished with error!");   
                    errorDescriptionDict.Add(10011, "Reading was aborted, while not yet completed!");   
                    errorDescriptionDict.Add(10020, "Change job by name finished with error!");   
                    errorDescriptionDict.Add(10021, "Change job by name was aborted, while not yet completed!"); 
                    errorDescriptionDict.Add(10040, "Change job by number finished with error!");   
                    errorDescriptionDict.Add(10041, "Change job by number was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10050, "SoftEvent finished with error!");
                    errorDescriptionDict.Add(10051, "SoftEvent was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10060, "SendUserData finished with error!");
                    errorDescriptionDict.Add(10061, "SendUserData was aborted, while not yet completed!");
                }
                string errorDescription = "   ";

                if(Error == null)
                    return errorDescription;

                if (errorDescriptionDict.TryGetValue(Error.Id.LastValue, out errorDescription))
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

                    actionDescriptionDict.Add(100, "Clearing of the inspection results started.");
                    actionDescriptionDict.Add(300, "Clearing of the inspection results running: reseting the inspection result buffer.");
                    actionDescriptionDict.Add(301, "Clearing of the inspection results running: waiting for the result data is cleared on device side.");
                    actionDescriptionDict.Add(302, "Clearing of the inspection results finished.");
                    actionDescriptionDict.Add(101, "Clearing of the inspection results finished succesfully.");
                    actionDescriptionDict.Add(102, "Clearing of the inspection results restored.");

                    actionDescriptionDict.Add(110, "Trigger started.");
                    actionDescriptionDict.Add(310, "Trigger running: enabling trigger.");
                    actionDescriptionDict.Add(311, "Trigger running: waiting for the device to be ready.");
                    actionDescriptionDict.Add(312, "Trigger running: waiting for the previous data is cleared.");
                    actionDescriptionDict.Add(313, "Trigger running: waiting for the reseting the previous cycle error state.");
                    actionDescriptionDict.Add(314, "Trigger running: waiting for the device to be ready for the new inspection cycle.");
                    actionDescriptionDict.Add(315, "Trigger running: waiting for the trigger to be enabled.");
                    actionDescriptionDict.Add(316, "Trigger running: waiting for the inspection to be completed.");
                    actionDescriptionDict.Add(317, "Trigger running: waiting for the inspection to be valid.");
                    actionDescriptionDict.Add(318, "Trigger running: parsing the inspection results.");
                    actionDescriptionDict.Add(319, "Trigger finished.");
                    actionDescriptionDict.Add(111, "Trigger finished succesfully.");
                    actionDescriptionDict.Add(112, "Trigger restored.");

                    actionDescriptionDict.Add(120, "Change job by name started.");
                    actionDescriptionDict.Add(320, "Change job by name running: checking the job name.");
                    actionDescriptionDict.Add(321, "Change job by name running: waiting for the previous action is finished.");
                    actionDescriptionDict.Add(322, "Change job by name running: waiting for the device to be offline.");
                    actionDescriptionDict.Add(323, "Change job by name running: reseting the error.");
                    actionDescriptionDict.Add(324, "Change job by name running: filling the user data with the job name.");
                    actionDescriptionDict.Add(325, "Change job by name running: waiting for the job name is received.");
                    actionDescriptionDict.Add(326, "Change job by name running: writing the job name waiting the job name received.");
                    actionDescriptionDict.Add(327, "Change job by name running: waiting for the command is completed.");
                    actionDescriptionDict.Add(328, "Change job by name running: waiting for the command complete acknowledged.");
                    actionDescriptionDict.Add(329, "Change job by name running: waiting for the device to be online.");
                    actionDescriptionDict.Add(330, "Change job by name finished.");
                    actionDescriptionDict.Add(330, "Change job by name finished with an error.");
                    actionDescriptionDict.Add(121, "Change job by name finished succesfully.");
                    actionDescriptionDict.Add(122, "Change job by name restored.");

                    actionDescriptionDict.Add(140, "Change job by number started.");
                    actionDescriptionDict.Add(340, "Change job by number running: checking the job number.");
                    actionDescriptionDict.Add(341, "Change job by number running: waiting for the previous action is finished.");
                    actionDescriptionDict.Add(342, "Change job by number running: waiting for the device to be offline.");
                    actionDescriptionDict.Add(343, "Change job by number running: reseting the error.");
                    actionDescriptionDict.Add(344, "Change job by number running: waiting for the command is completed.");
                    actionDescriptionDict.Add(345, "Change job by number running: waiting for the command complete acknowledged.");
                    actionDescriptionDict.Add(346, "Change job by number running: waiting for the device to be online.");
                    actionDescriptionDict.Add(347, "Change job by number finished.");
                    actionDescriptionDict.Add(349, "Change job by number finished with an error.");
                    actionDescriptionDict.Add(141, "Change job by number finished succesfully.");
                    actionDescriptionDict.Add(142, "Change job by number restored.");

                    actionDescriptionDict.Add(150, "SoftEvent started.");
                    actionDescriptionDict.Add(350, "SoftEvent running: checking the soft event number.");
                    actionDescriptionDict.Add(351, "SoftEvent running: checking the soft event number.");
                    actionDescriptionDict.Add(352, "SoftEvent running: waiting for the soft event is finished.");
                    actionDescriptionDict.Add(353, "SoftEvent running: waiting for the soft event is acknowledged.");
                    actionDescriptionDict.Add(354, "SoftEvent finished.");
                    actionDescriptionDict.Add(151, "SoftEvent finished succesfully.");
                    actionDescriptionDict.Add(152, "SoftEvent restored.");

                    actionDescriptionDict.Add(160, "SendData started.");
                    actionDescriptionDict.Add(360, "SendData running: filling the user data buffer.");
                    actionDescriptionDict.Add(361, "SendData running: sending the user data to the device.");
                    actionDescriptionDict.Add(362, "SendData running: waiting for the user is acknowledged.");
                    actionDescriptionDict.Add(363, "SendData finished.");
                    actionDescriptionDict.Add(161, "SendData finished succesfully.");
                    actionDescriptionDict.Add(162, "SendData restored.");

                    actionDescriptionDict.Add(10000, "Clearing of the inspection results finished with error!");
                    actionDescriptionDict.Add(10001, "Clearing of the inspection results was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10010, "Reading finished with error!");
                    actionDescriptionDict.Add(10011, "Reading was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10020, "Change job by name finished with error!");
                    actionDescriptionDict.Add(10021, "Change job by name  was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10040, "Change job by number finished with error!");
                    actionDescriptionDict.Add(10041, "Change job by number  was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10050, "Soft event finished with error!");
                    actionDescriptionDict.Add(10051, "Soft event finished  was aborted, while not yet completed!");
                }
                
                string actionDescription = "   ";

                if (Action == null)
                    return actionDescription;

                if (actionDescriptionDict.TryGetValue(Action.Id.LastValue, out actionDescription))
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

