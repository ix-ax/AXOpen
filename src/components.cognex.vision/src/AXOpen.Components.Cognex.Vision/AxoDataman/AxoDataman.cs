using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;

namespace AXOpen.Components.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoDataman : AXOpen.Core.AxoComponent, AXOpen.Components.Abstractions.IAxoCodeReader
    {
        public async Task WriteTaskDurationToConsole()
        {
            foreach (var task in this.GetChildren().OfType<AxoTask>())
            {
                Console.WriteLine($"{task.Symbol} : {await task.Duration.GetAsync()}");
            }
        }
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Clear reasult data started.",                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Clear reasult data finished succesfully.",                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Clear reasult data restored.",                                                 "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Reading started.",                                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Reading finished succesfully.",                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Reading restored.",                                                            "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Continous reading active: New data read.",                                     "")),

                //  General alarm
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                               ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!"                                                                ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionControl is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'Acquisition_Control' (GsdId=101)."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionStatus is zero."                                                              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'Acquisition_Status' (GsdId=201)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdResultsControl is zero."                                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'Results_Control' (GsdId=102)."           ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdResultsStatus is zero."                                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'Results_Status' (GsdId=202)."            ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(750, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdSoftEventControl is zero."                                                               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(751, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(752, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(753, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(754, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(755, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(756, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: 'Soft_Event_Control' (GsdId=105)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(760, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdUserData is zero."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(761, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(762, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(763, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(764, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(765, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(766, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 6. Allowed modules: 'User_Data-16_bytes,User_Data-32_bytes,User_Data-64_bytes,User_Data-128_bytes,User_Data-250_bytes' (GsdId=301,302,303,304,305)."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(770, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdResultData is zero."                                                                     ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(771, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(772, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(773, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(774, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(775, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(776, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'Result_Data-16_bytes,Result_Data-32_bytes,Result_Data-64_bytes,Result_Data-128_bytes,Result_Data-246_bytes' (GsdId=401,402,403,404,405)."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                              ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!"                                                               ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdAcquisitionControl` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdAcquisitionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdAcquisitionStatus` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdAcquisitionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1134, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdResultsControl` has invalid value in `Run` method!"                                                      ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdResultsControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1135, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdResultsStatus` has invalid value in `Run` method!"                                                       ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdResultsStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1136, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdSoftEventControl` has invalid value in `Run` method!"                                                    ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdSoftEventControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1137, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdUserData` has invalid value in `Run` method!"                                                            ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdUserData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1138, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdResultData` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdResultData` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the AcquisitionStatus!"                                                                                                     ,"Check the value of the _Config.HWIDs.HwIdAcquisitionStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1202, new AxoMessengerTextItem("Error reading the ResultsStatus!"                                                                                                         ,"Check the value of the _Config.HWIDs.HwIdResultsStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1203, new AxoMessengerTextItem("Error reading the SoftEventControl!"                                                                                                      ,"Check the value of the _Config.HWIDs.HwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1204, new AxoMessengerTextItem("Error reading the ResultData!"                                                                                                            ,"Check the value of the _Config.HWIDs.HwIdResultData and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1205, new AxoMessengerTextItem("ResultData has invalid size!"                                                                                                             ,"Check the real size of the `ResultData`, so as the value of the ResultDataSize parameter!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the AcquisitionControl!"                                                                                                    ,"Check the value of the _Config.HWIDs.HwIdAcquisitionControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1232, new AxoMessengerTextItem("Error writing the ResultsControl!"                                                                                                        ,"Check the value of the _Config.HWIDs.HwIdResultsControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1233, new AxoMessengerTextItem("Error writing the SoftEventControl!"                                                                                                      ,"Check the value of the _Config.HWIDs.HwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1234, new AxoMessengerTextItem("UserData has invalid size!"                                                                                                               ,"Check the real size of the `UserData`, so as the value of the UserDataSize parameter!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1235, new AxoMessengerTextItem("Error writing the 16bytes of the UserData!"                                                                                               ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1236, new AxoMessengerTextItem("Error writing the 32bytes of the UserData!"                                                                                               ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1237, new AxoMessengerTextItem("Error writing the 64bytes of the UserData!"                                                                                               ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1238, new AxoMessengerTextItem("Error writing the 128bytes of the UserData!"                                                                                              ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1239, new AxoMessengerTextItem("Error writing the 250bytes of the UserData!"                                                                                              ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("Clearing of the result data finished with error!"                                                                                        ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("Clearing of the result data was aborted, while not yet completed!"                                                                       ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("Reading finished with error!"                                                                                                            ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("Reading was aborted, while not yet completed!"                                                                                           ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("Continous reading finished with error!"                                                                                                  ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("Continous reading was aborted, while not yet completed!"                                                                                 ,"Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(500, new AxoMessengerTextItem("Waiting for the signal ResultsAvailable to be reseted!"                                                                                    ,"Check the status of the `ResultsAvailable` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(510, new AxoMessengerTextItem("Waiting for the signal ResultsAvailable to be reseted!"                                                                                    ,"Check the status of the `ResultsAvailable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511, new AxoMessengerTextItem("Waiting for the signal TriggerReady to be set!"                                                                                            ,"Check the status of the `TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512, new AxoMessengerTextItem("Waiting for the signal TriggerAcknowledge to be set!"                                                                                      ,"Check the status of the `TriggerAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513, new AxoMessengerTextItem("Waiting for the signal ResultsAvailable to be set!"                                                                                        ,"Check the status of the `ResultsAvailable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514, new AxoMessengerTextItem("ResultData has invalid size!"                                                                                                              ,"Check the real size of the `ResultData`, so as the value of the ResultDataSize parameter!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515, new AxoMessengerTextItem("Waiting for the ResultData to be copied!"                                                                                                  ,"Check the status of the `ResultData` data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(519, new AxoMessengerTextItem("Waiting for the signal TriggerReady to be reseted!"                                                                                        ,"Check the status of the `TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(520, new AxoMessengerTextItem("Waiting for the signal ErrorDetected to be reseted!"                                                                                       ,"Check the status of the `ErrorDetected` signal.")),

                //  General alarm
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                               ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!"                                                                ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionControl is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'Acquisition_Control' (GsdId=101)."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionStatus is zero."                                                              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'Acquisition_Status' (GsdId=201)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdResultsControl is zero."                                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'Results_Control' (GsdId=102)."           ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdResultsStatus is zero."                                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'Results_Status' (GsdId=202)."            ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(750, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdSoftEventControl is zero."                                                               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(751, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(752, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(753, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(754, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(755, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(756, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: 'Soft_Event_Control' (GsdId=105)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(760, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdResultData is zero."                                                                     ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(761, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(762, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(763, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(764, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(765, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(766, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 6. Allowed modules: 'User_Data-16_bytes,User_Data-32_bytes,User_Data-64_bytes,User_Data-128_bytes,User_Data-250_bytes' (GsdId=301,302,303,304,305)."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(770, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwIdUserData is zero."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(771, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(772, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(773, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(774, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(775, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(776, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'Result_Data-16_bytes,Result_Data-32_bytes,Result_Data-64_bytes,Result_Data-128_bytes,Result_Data-246_bytes' (GsdId=401,402,403,404,405)."       ,"Check the hardware configuration.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                              ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!"                                                               ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdAcquisitionControl` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdAcquisitionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdAcquisitionStatus` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdAcquisitionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1134, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdResultsControl` has invalid value in `Run` method!"                                                      ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdResultsControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1135, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdResultsStatus` has invalid value in `Run` method!"                                                       ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdResultsStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1136, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdSoftEventControl` has invalid value in `Run` method!"                                                    ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdSoftEventControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1137, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdResultData` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdResultData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1138, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwIdUserData` has invalid value in `Run` method!"                                                            ,"Check the call of the `Run` method, if the `Config.HWIDs.HwIdUserData` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the AcquisitionStatus!"                                                                                                     ,"Check the value of the _Config.HWIDs.HwIdAcquisitionStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1202, new AxoMessengerTextItem("Error reading the ResultsStatus!"                                                                                                         ,"Check the value of the _Config.HWIDs.HwIdResultsStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1203, new AxoMessengerTextItem("Error reading the SoftEventControl!"                                                                                                      ,"Check the value of the _Config.HWIDs.HwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1204, new AxoMessengerTextItem("Error reading the ResultData!"                                                                                                            ,"Check the value of the _Config.HWIDs.HwIdResultData and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1205, new AxoMessengerTextItem("ResultData has invalid size!"                                                                                                             ,"Check the real size of the `ResultData`, so as the value of the ResultDataSize parameter!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the AcquisitionControl!"                                                                                                    ,"Check the value of the _Config.HWIDs.HwIdAcquisitionControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1232, new AxoMessengerTextItem("Error writing the ResultsControl!"                                                                                                        ,"Check the value of the _Config.HWIDs.HwIdResultsControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1233, new AxoMessengerTextItem("Error writing the SoftEventControl!"                                                                                                      ,"Check the value of the _Config.HWIDs.HwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1234, new AxoMessengerTextItem("UserData has invalid size!"                                                                                                               ,"Check the real size of the `UserData`, so as the value of the UserDataSize parameter!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1235, new AxoMessengerTextItem("Error writing the 16bytes of the UserData!"                                                                                               ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1236, new AxoMessengerTextItem("Error writing the 32bytes of the UserData!"                                                                                               ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1237, new AxoMessengerTextItem("Error writing the 64bytes of the UserData!"                                                                                               ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1238, new AxoMessengerTextItem("Error writing the 128bytes of the UserData!"                                                                                              ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1239, new AxoMessengerTextItem("Error writing the 250bytes of the UserData!"                                                                                              ,"Check the value of the Config.HWIDs.HwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoDataman_Status : AxoComponent_Status
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
                    errorDescriptionDict.Add(510, "Waiting for the signal ResultsAvailable to be reseted!");
                    errorDescriptionDict.Add(511, "Waiting for the signal TriggerReady to be set!");
                    errorDescriptionDict.Add(512, "Waiting for the signal TriggerAcknowledge to be set!");
                    errorDescriptionDict.Add(513, "Waiting for the signal ResultsAvailable to be set!");
                    errorDescriptionDict.Add(514, "ResultData has invalid size!");
                    errorDescriptionDict.Add(515, "Waiting for the ResultData to be copied!");
                    errorDescriptionDict.Add(519, "Waiting for the signal TriggerReady to be reseted!");
                    errorDescriptionDict.Add(520, "Waiting for the signal ErrorDetected to be reseted!");

                    //  General alarm
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                            );
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                 );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionControl is zero."                                                                       );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                        );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                        );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                        );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                        );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                        );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'Acquisition_Control' (GsdId=101)."    );
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwIdAcquisitionStatus is zero."                                                                        );
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                        );
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                        );
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                        );
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                        );
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                        );
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'Acquisition_Status' (GsdId=201)."     );
                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwIdResultsControl is zero."                                                                           );
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                        );
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                        );
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                        );
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                        );
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                        );
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'Results_Control' (GsdId=102)."        );
                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwIdResultsStatus is zero."                                                                            );
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                        );
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                        );
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                        );
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                        );
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                        );
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'Results_Status' (GsdId=202)."         );
                    errorDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwIdSoftEventControl is zero."                                                                         );
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."                        );
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."                        );
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."                        );
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."                        );
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."                        );
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: 'Soft_Event_Control' (GsdId=105)."     );
                    errorDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDs.HwIdUserData is zero.");
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6.");
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6.");
                    errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6.");
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6.");
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6.");
                    errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Allowed modules: 'User_Data-16_bytes,User_Data-32_bytes,User_Data-64_bytes,User_Data-128_bytes,User_Data-250_bytes' (GsdId=301,302,303,304,305).");
                    errorDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDs.HwIdResultData is zero."                                                                               );
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."                        );
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."                        );
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."                        );
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."                        );
                    errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."                        );
                    errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'Result_Data-16_bytes,Result_Data-32_bytes,Result_Data-64_bytes,Result_Data-128_bytes,Result_Data-246_bytes' (GsdId=401,402,403,404,405).");
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!"                                                                           );
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwIdAcquisitionControl` has invalid value in `Run` method!"                                                           );
                    errorDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwIdAcquisitionStatus` has invalid value in `Run` method!"                                                            );
                    errorDescriptionDict.Add(1134, "Input variable `Config.HWIDs.HwIdResultsControl` has invalid value in `Run` method!"                                                               );
                    errorDescriptionDict.Add(1135, "Input variable `Config.HWIDs.HwIdResultsStatus` has invalid value in `Run` method!"                                                                );
                    errorDescriptionDict.Add(1136, "Input variable `Config.HWIDs.HwIdSoftEventControl` has invalid value in `Run` method!"                                                             );
                    errorDescriptionDict.Add(1137, "Input variable `Config.HWIDs.HwIdResultData` has invalid value in `Run` method!"                                                                   );
                    errorDescriptionDict.Add(1138, "Input variable `Config.HWIDs.HwIdUserData` has invalid value in `Run` method!"                                                                     );
                    errorDescriptionDict.Add(1201, "Error reading the AcquisitionStatus!"                                                                                                  );
                    errorDescriptionDict.Add(1202, "Error reading the ResultsStatus!"                                                                                                      );
                    errorDescriptionDict.Add(1203, "Error reading the SoftEventControl!"                                                                                                   );
                    errorDescriptionDict.Add(1204, "Error reading the ResultData!"                                                                                                         );
                    errorDescriptionDict.Add(1205, "ResultData has invalid size!"                                                                                                          );
                    errorDescriptionDict.Add(1231, "Error writing the AcquisitionControl!"                                                                                                 );
                    errorDescriptionDict.Add(1232, "Error writing the ResultsControl!"                                                                                                     );
                    errorDescriptionDict.Add(1233, "Error writing the SoftEventControl!"                                                                                                   );
                    errorDescriptionDict.Add(1234, "UserData has invalid size!"                                                                                                            );
                    errorDescriptionDict.Add(1235, "Error writing the 16bytes of the UserData!"                                                                                            );
                    errorDescriptionDict.Add(1236, "Error writing the 32bytes of the UserData!"                                                                                            );
                    errorDescriptionDict.Add(1237, "Error writing the 64bytes of the UserData!"                                                                                            );
                    errorDescriptionDict.Add(1238, "Error writing the 128bytes of the UserData!"                                                                                           );
                    errorDescriptionDict.Add(1239, "Error writing the 250bytes of the UserData!"                                                                                           );
                    errorDescriptionDict.Add(10000, "Clearing of the result data finished with error!"                                                                                     );
                    errorDescriptionDict.Add(10001, "Clearing of the result data was aborted, while not yet completed!"                                                                    );
                    errorDescriptionDict.Add(10010, "Reading finished with error!"                                                                                                         );
                    errorDescriptionDict.Add(10011, "Reading was aborted, while not yet completed!"                                                                                        );
                    errorDescriptionDict.Add(10020, "Continous reading finished with error!"                                                                                               );
                    errorDescriptionDict.Add(10021, "Continous reading was aborted, while not yet completed!"                                                                              );

                }
                string errorDescription = "   ";

                if (Error == null || Error.Id == null)
                {
                    return string.Empty;
                }

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

                    actionDescriptionDict.Add(100,"Clear reasult data started.");
                    actionDescriptionDict.Add(300, "Clear reasult data running.");
                    actionDescriptionDict.Add(301, "Clear reasult data running.");
                    actionDescriptionDict.Add(302, "Clear reasult data running.");
                    actionDescriptionDict.Add(303, "Clear reasult data running.");
                    actionDescriptionDict.Add(304, "Clear reasult data running.");
                    actionDescriptionDict.Add(305, "Clear reasult data running.");
                    actionDescriptionDict.Add(306, "Clear reasult data running.");
                    actionDescriptionDict.Add(307, "Clear reasult data running.");
                    actionDescriptionDict.Add(308, "Clear reasult data running.");
                    actionDescriptionDict.Add(309, "Clear reasult data running.");
                    actionDescriptionDict.Add(101,"Clear reasult data finished succesfully.");
                    actionDescriptionDict.Add(102,"Clear reasult data restored.");

                    actionDescriptionDict.Add(110, "Reading started.");
                    actionDescriptionDict.Add(310, "Reading running.");
                    actionDescriptionDict.Add(311, "Reading running.");
                    actionDescriptionDict.Add(312, "Reading running.");
                    actionDescriptionDict.Add(313, "Reading running.");
                    actionDescriptionDict.Add(314, "Reading running.");
                    actionDescriptionDict.Add(315, "Reading running.");
                    actionDescriptionDict.Add(316, "Reading running.");
                    actionDescriptionDict.Add(317, "Reading running.");
                    actionDescriptionDict.Add(318, "Reading running.");
                    actionDescriptionDict.Add(319, "Reading running.");
                    actionDescriptionDict.Add(320, "Reading running.");
                    actionDescriptionDict.Add(321, "Reading running.");
                    actionDescriptionDict.Add(322, "Reading running.");
                    actionDescriptionDict.Add(323, "Reading running.");
                    actionDescriptionDict.Add(324, "Reading running.");
                    actionDescriptionDict.Add(325, "Reading running.");
                    actionDescriptionDict.Add(326, "Reading running.");
                    actionDescriptionDict.Add(327, "Reading running.");
                    actionDescriptionDict.Add(328, "Reading running.");
                    actionDescriptionDict.Add(329, "Reading running.");

                    actionDescriptionDict.Add(111,"Reading finished succesfully.");
                    actionDescriptionDict.Add(112,"Reading restored.");


                    actionDescriptionDict.Add(120, "Continous reading active: New data read.");

                    actionDescriptionDict.Add(10000, "Clearing of the result data finished with error!");
                    actionDescriptionDict.Add(10001, "Clearing of the result data was aborted, while not yet completed!");

                    actionDescriptionDict.Add(10010, "Reading finished with error!");
                    actionDescriptionDict.Add(10011, "Reading was aborted, while not yet completed!");

                    actionDescriptionDict.Add(10020, "Continous reading finished with error!");
                    actionDescriptionDict.Add(10021, "Continous reading was aborted, while not yet completed!");


                }
                string actionDescription = "   ";
                if (Action == null || Action.Id == null)
                {
                    return string.Empty;
                }

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
