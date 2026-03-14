using AXOpen.Messaging.Static;
using AXSharp.Connector;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Keyence.Vision
{
    public partial class Axo_IV3
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.","")),
                // TriggerTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("TriggerTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("TriggerTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("TriggerTask restored.","")),
                // ChangeProgramTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("ChangeProgramTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("ChangeProgramTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("ChangeProgramTask restored.","")),
                //  General warnings
                new KeyValuePair<ulong, AxoMessengerTextItem>(454, new AxoMessengerTextItem("Expansion program setting mismatch error (normal)"                                                                             ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(458, new AxoMessengerTextItem("External master registration error (OCR)"                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(460, new AxoMessengerTextItem("Field Network Error, Invalid request (OCR/threshold)"                                                                          ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(461, new AxoMessengerTextItem("Field network bad request error (FTP/SD)"                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(462, new AxoMessengerTextItem("Field network overrun error"                                                                                                   ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(463, new AxoMessengerTextItem("Field Network Error, Invalid request (Save Master)"                                                                            ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(464, new AxoMessengerTextItem("Field Network Error, Invalid request (Change Program)"                                                                         ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(465, new AxoMessengerTextItem("Trigger error"                                                                                                                 ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(466, new AxoMessengerTextItem("External master registration error (Insufficient outline)"                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(467, new AxoMessengerTextItem("External master registration error (Insufficient area)"                                                                        ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(468, new AxoMessengerTextItem("External master registration error (Brightness correction failed)"                                                             ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(469, new AxoMessengerTextItem("External master registration error (Insufficient edge failed)"                                                                 ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(470, new AxoMessengerTextItem("FTP Transfer Error (Insufficient Data Buffer)"                                                                                 ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(471, new AxoMessengerTextItem("FTP Transfer Error (Transfer Failed)"                                                                                          ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(472, new AxoMessengerTextItem("FTP Connection Error"                                                                                                          ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(473, new AxoMessengerTextItem("External master registration error (Insufficient work memory)"                                                                 ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(474, new AxoMessengerTextItem("External master registration error (No images)"                                                                                ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(475, new AxoMessengerTextItem("SD Card Transfer Error (Insufficient Transfer Buffer)"                                                                         ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(476, new AxoMessengerTextItem("SD Card Transfer Error (Transfer Failed)"                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(477, new AxoMessengerTextItem("External master registration error (learning tool/sorting mode)"                                                               ,"Check the product documentation.")),
                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_CommandControl is zero."                                                    ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: '101'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_CommandStatusBits is zero."                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: '201'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_DeviceResultBits_1 is zero."                                                ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: '202'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatusWords is zero."                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: '203'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(750, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatistics is zero."                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(751, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(752, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(753, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(754, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(755, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(756, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: '204'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(760, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_PositionAdjustResult is zero."                                              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(761, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(762, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(763, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(764, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(765, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(766, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: '301'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(770, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_1 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(771, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(772, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(773, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(774, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(775, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(776, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(780, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_2 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(781, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(782, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(783, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(784, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(785, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(786, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(790, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_3 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(791, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(792, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(793, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(794, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(795, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(796, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_4 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(802, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(803, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(804, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(805, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(806, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_5 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(812, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(813, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(814, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(815, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(816, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_6 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(822, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(823, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(824, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(825, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(826, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(830, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_7 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(831, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(832, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(833, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(834, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(835, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(836, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_8 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(842, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(843, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(844, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(845, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(846, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 14. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_9 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(852, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(853, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(854, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(855, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(856, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 15. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(860, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_10 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(861, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(862, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(863, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(864, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(865, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(866, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 16. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(870, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_11 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(871, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(872, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(873, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(874, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(875, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(876, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 17. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(880, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_12 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(881, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(882, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(883, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(884, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(885, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(886, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 18. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(890, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_13 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(891, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(892, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(893, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(894, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(895, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(896, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 19. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(900, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_14 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(901, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(902, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(903, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(904, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(905, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(906, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 20. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(910, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_15 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(911, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 21."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(912, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 21."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(913, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 21."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(914, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 21."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(915, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 21."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(916, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 21. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(920, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_16 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(921, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 22."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(922, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 22."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(923, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 22."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(924, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 22."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(925, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 22."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(926, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 22. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(930, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_17 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(931, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 23."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(932, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 23."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(933, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 23."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(934, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 23."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(935, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 23."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(936, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 23. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(940, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_18 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(941, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 24."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(942, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 24."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(943, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 24."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(944, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 24."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(945, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 24."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(946, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 24. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(950, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_19 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(951, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 25."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(952, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 25."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(953, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 25."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(954, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 25."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(955, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 25."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(956, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 25. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(960, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_20 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(961, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 26."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(962, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 26."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(963, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 26."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(964, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 26."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(965, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 26."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(966, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 26. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(970, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_21 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(971, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 27."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(972, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 27."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(973, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 27."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(974, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 27."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(975, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 27."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(976, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 27. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(980, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_22 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(981, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 28."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(982, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 28."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(983, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 28."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(984, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 28."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(985, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 28."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(986, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 28. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(990, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_23 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(991, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 29."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(992, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 29."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(993, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 29."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(994, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 29."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(995, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 29."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(996, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 29. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1000, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_24 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1001, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 30."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1002, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 30."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1003, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 30."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1004, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 30."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1005, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 30."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1006, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 30. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1010, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_25 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1011, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 31."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1012, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 31."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1013, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 31."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1014, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 31."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1015, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 31."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1016, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 31. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1020, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_26 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1021, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 32."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1022, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 32."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1023, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 32."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1024, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 32."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1025, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 32."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1026, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 32. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1030, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_27 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1031, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 33."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1032, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 33."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1033, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 33."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1034, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 33."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1035, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 33."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1036, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 33. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1040, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_28 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1041, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 34."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1042, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 34."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1043, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 34."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1044, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 34."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1045, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 34."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1046, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 34. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1050, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_29 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1051, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 35."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1052, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 35."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1053, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 35."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1054, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 35."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1055, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 35."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1056, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 35. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1060, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_30 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1061, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 36."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1062, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 36."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1063, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 36."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1064, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 36."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1065, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 36."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1066, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 36. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1070, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_31 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1071, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 37."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1072, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 37."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1073, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 37."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1074, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 37."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1075, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 37."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1076, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 37. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1080, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_32 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1081, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 38."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1082, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 38."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1083, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 38."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1084, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 38."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1085, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 38."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1086, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 38. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1090, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_33 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1091, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 39."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1092, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 39."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1093, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 39."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1094, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 39."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1095, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 39."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1096, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 39. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1100, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_34 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1101, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 40."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1102, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 40."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1103, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 40."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1104, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 40."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1105, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 40."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1106, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 40. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1110, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_35 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1111, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 41."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1112, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 41."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1113, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 41."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1114, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 41."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1115, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 41."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1116, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 41. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1120, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_36 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1121, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 42."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1122, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 42."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1123, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 42."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1124, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 42."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1125, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 42."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1126, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 42. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_37 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 43."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 43."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 43."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1134, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 43."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1135, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 43."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1136, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 43. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1140, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_38 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1141, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 44."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1142, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 44."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1143, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 44."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1144, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 44."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1145, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 44."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1146, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 44. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1150, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_39 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1151, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 45."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1152, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 45."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1153, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 45."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1154, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 45."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1155, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 45."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1156, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 45. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1160, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_40 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1161, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 46."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1162, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 46."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1163, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 46."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1164, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 46."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1165, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 46."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1166, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 46. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1170, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_41 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1171, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 47."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1172, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 47."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1173, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 47."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1174, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 47."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1175, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 47."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1176, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 47. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1180, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_42 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1181, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 48."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1182, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 48."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1183, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 48."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1184, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 48."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1185, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 48."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1186, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 48. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1190, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_43 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1191, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 49."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1192, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 49."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1193, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 49."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1194, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 49."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1195, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 49."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1196, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 49. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1200, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_44 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 50."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1202, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 50."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1203, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 50."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1204, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 50."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1205, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 50."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1206, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 50. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1210, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_45 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1211, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 51."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1212, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 51."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1213, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 51."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1214, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 51."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1215, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 51."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1216, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 51. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1220, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_46 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1221, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 52."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1222, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 52."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1223, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 52."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1224, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 52."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1225, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 52."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1226, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 52. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1230, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_47 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 53."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1232, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 53."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1233, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 53."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1234, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 53."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1235, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 53."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1236, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 53. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1240, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_48 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1241, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 54."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1242, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 54."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1243, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 54."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1244, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 54."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1245, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 54."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1246, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 54. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1250, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_49 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1251, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 55."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1252, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 55."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1253, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 55."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1254, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 55."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1255, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 55."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1256, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 55. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1260, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_50 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1261, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 56."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1262, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 56."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1263, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 56."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1264, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 56."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1265, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 56."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1266, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 56. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1270, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_51 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1271, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 57."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1272, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 57."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1273, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 57."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1274, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 57."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1275, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 57."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1276, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 57. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1280, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_52 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1281, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 58."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1282, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 58."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1283, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 58."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1284, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 58."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1285, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 58."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1286, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 58. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1290, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_53 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1291, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 59."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1292, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 59."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1293, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 59."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1294, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 59."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1295, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 59."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1296, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 59. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1300, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_54 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1301, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 60."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1302, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 60."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1303, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 60."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1304, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 60."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1305, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 60."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1306, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 60. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1310, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_55 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1311, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 61."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1312, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 61."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1313, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 61."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1314, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 61."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1315, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 61."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1316, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 61. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1320, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_56 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1321, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 62."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1322, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 62."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1323, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 62."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1324, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 62."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1325, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 62."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1326, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 62. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1330, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_57 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1331, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 63."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1332, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 63."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1333, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 63."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1334, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 63."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1335, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 63."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1336, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 63. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1340, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_58 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1341, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 64."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1342, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 64."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1343, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 64."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1344, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 64."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1345, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 64."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1346, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 64. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1350, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_59 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1351, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 65."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1352, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 65."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1353, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 65."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1354, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 65."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1355, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 65."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1356, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 65. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1360, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_60 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1361, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 66."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1362, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 66."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1363, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 66."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1364, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 66."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1365, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 66."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1366, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 66. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1370, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_61 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1371, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 67."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1372, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 67."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1373, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 67."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1374, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 67."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1375, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 67."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1376, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 67. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1380, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_62 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1381, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 68."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1382, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 68."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1383, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 68."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1384, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 68."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1385, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 68."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1386, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 68. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1390, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_63 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1391, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 69."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1392, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 69."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1393, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 69."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1394, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 69."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1395, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 69."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1396, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 69. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1400, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_64 is zero."                                                      ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1401, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 70."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1402, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 70."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1403, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 70."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1404, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 70."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1405, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 70."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1406, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 70. Expected module: '302'."                       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1410, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_DeviceResultBits_2 is zero."                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1411, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 71."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1412, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 71."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1413, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 71."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1414, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 71."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1415, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 71."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1416, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 71. Expected module: '401'."                       ,"Check the hardware configuration.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(1500, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1501, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1502, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_CommandControl` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_CommandControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1503, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_CommandStatusBits` has invalid value in `Run` method!"                                              ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_CommandStatusBits` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1504, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_DeviceResultBits_1` has invalid value in `Run` method!"                                             ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_DeviceResultBits_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1505, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_DeviceStatusWords` has invalid value in `Run` method!"                                              ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_DeviceStatusWords` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1506, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_DeviceStatistics` has invalid value in `Run` method!"                                               ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_DeviceStatistics` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1507, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_PositionAdjustResult` has invalid value in `Run` method!"                                           ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_PositionAdjustResult` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1508, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_1` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1509, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_2` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_2` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1510, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_3` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_3` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1511, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_4` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_4` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1512, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_5` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_5` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1513, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_6` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_6` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1514, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_7` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_7` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1515, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_8` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_8` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1516, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_9` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_9` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1517, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_10` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_10` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1518, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_11` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_11` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1519, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_12` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_12` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1520, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_13` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_13` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1521, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_14` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_14` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1522, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_15` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_15` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1523, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_16` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_16` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1524, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_17` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_17` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1525, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_18` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_18` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1526, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_19` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_19` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1527, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_20` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_20` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1528, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_21` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_21` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1529, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_22` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_22` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1530, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_23` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_23` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1531, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_24` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_24` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1532, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_25` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_25` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1533, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_26` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_26` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1534, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_27` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_27` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1535, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_28` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_28` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1536, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_29` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_29` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1537, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_30` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_30` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1538, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_31` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_31` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1539, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_32` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_32` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1540, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_33` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_33` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1541, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_34` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_34` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1542, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_35` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_35` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1543, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_36` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_36` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1544, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_37` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_37` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1545, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_38` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_38` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1546, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_39` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_39` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1547, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_40` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_40` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1548, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_41` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_41` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1549, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_42` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_42` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1550, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_43` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_43` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1551, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_44` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_44` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1552, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_45` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_45` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1553, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_46` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_46` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1554, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_47` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_47` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1555, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_48` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_48` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1556, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_49` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_49` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1557, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_50` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_50` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1558, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_51` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_51` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1559, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_52` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_52` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1560, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_53` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_53` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1561, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_54` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_54` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1562, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_55` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_55` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1563, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_56` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_56` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1564, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_57` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_57` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1565, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_58` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_58` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1566, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_59` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_59` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1567, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_60` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_60` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1568, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_61` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_61` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1569, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_62` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_62` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1570, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_63` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_63` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1571, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_ToolResult_64` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_ToolResult_64` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1572, new AxoMessengerTextItem("Variable `Config.HWIDs.HwID_DeviceResultBits_2` has invalid value in `Run` method!"                                              ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_DeviceResultBits_2` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1601, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_CommandStatusBits'!"                                               ,"Check the value of the Config.HWIDs.HwID_CommandStatusBits and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1602, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_DeviceResultBits_1'!"                                              ,"Check the value of the Config.HWIDs.HwID_DeviceResultBits_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1603, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_DeviceStatusWords'!"                                               ,"Check the value of the Config.HWIDs.HwID_DeviceStatusWords and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1604, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_DeviceStatistics'!"                                                ,"Check the value of the Config.HWIDs.HwID_DeviceStatistics and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1605, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_PositionAdjustResult'!"                                            ,"Check the value of the Config.HWIDs.HwID_PositionAdjustResult and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1606, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_1'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1607, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_2'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_2 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1608, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_3'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_3 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1609, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_4'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_4 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1610, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_5'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_5 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1611, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_6'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_6 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1612, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_7'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_7 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1613, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_8'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_8 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1614, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_9'!"                                                    ,"Check the value of the Config.HWIDs.HwID_ToolResult_9 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1615, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_10'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_10 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1616, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_11'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_11 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1617, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_12'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_12 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1618, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_13'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_13 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1619, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_14'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_14 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1620, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_15'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_15 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1621, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_16'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_16 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1622, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_17'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_17 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1623, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_18'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_18 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1624, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_19'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_19 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1625, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_20'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_20 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1626, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_21'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_21 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1627, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_22'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_22 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1628, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_23'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_23 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1629, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_24'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_24 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1630, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_25'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_25 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1631, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_26'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_26 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1632, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_27'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_27 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1633, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_28'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_28 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1634, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_29'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_29 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1635, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_30'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_30 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1636, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_31'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_31 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1637, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_32'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_32 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1638, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_33'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_33 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1639, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_34'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_34 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1640, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_35'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_35 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1641, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_36'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_36 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1642, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_37'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_37 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1643, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_38'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_38 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1644, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_39'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_39 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1645, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_40'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_40 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1646, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_41'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_41 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1647, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_42'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_42 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1648, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_43'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_43 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1649, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_44'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_44 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1650, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_45'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_45 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1651, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_46'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_46 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1652, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_47'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_47 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1653, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_48'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_48 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1654, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_49'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_49 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1655, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_50'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_50 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1656, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_51'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_51 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1657, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_52'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_52 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1658, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_53'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_53 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1659, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_54'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_54 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1660, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_55'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_55 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1661, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_56'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_56 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1662, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_57'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_57 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1663, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_58'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_58 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1664, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_59'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_59 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1665, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_60'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_60 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1666, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_61'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_61 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1667, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_62'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_62 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1668, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_63'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_63 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1669, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_ToolResult_64'!"                                                   ,"Check the value of the Config.HWIDs.HwID_ToolResult_64 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1670, new AxoMessengerTextItem("Error reading the input data from the module with HWID: 'HwID_DeviceResultBits_2'!"                                              ,"Check the value of the Config.HWIDs.HwID_ToolResult_65 and reacheability of the device!")),
                                                                                                                                                                                                                               
                new KeyValuePair<ulong, AxoMessengerTextItem>(1701, new AxoMessengerTextItem("Error writing the output data to the module with HWID: 'HwID_CommandControl'!"                                                   ,"Check the value of the Config.HWIDs.HwID_CommandControl and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1801, new AxoMessengerTextItem("Program 1 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1802, new AxoMessengerTextItem("Program 2 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1803, new AxoMessengerTextItem("Program 3 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1804, new AxoMessengerTextItem("Program 4 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1805, new AxoMessengerTextItem("Program 5 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1806, new AxoMessengerTextItem("Program 6 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1807, new AxoMessengerTextItem("Program 7 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1808, new AxoMessengerTextItem("Program 8 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1809, new AxoMessengerTextItem("Program 9 corruption error"                                                                                                       ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1810, new AxoMessengerTextItem("Program 10 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1811, new AxoMessengerTextItem("Program 11 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1812, new AxoMessengerTextItem("Program 12 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1813, new AxoMessengerTextItem("Program 13 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1814, new AxoMessengerTextItem("Program 14 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1815, new AxoMessengerTextItem("Program 15 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1816, new AxoMessengerTextItem("Program 16 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1817, new AxoMessengerTextItem("Program 17 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1818, new AxoMessengerTextItem("Program 18 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1819, new AxoMessengerTextItem("Program 19 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1820, new AxoMessengerTextItem("Program 20 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1821, new AxoMessengerTextItem("Program 21 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1822, new AxoMessengerTextItem("Program 22 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1823, new AxoMessengerTextItem("Program 23 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1824, new AxoMessengerTextItem("Program 24 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1825, new AxoMessengerTextItem("Program 25 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1826, new AxoMessengerTextItem("Program 26 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1827, new AxoMessengerTextItem("Program 27 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1828, new AxoMessengerTextItem("Program 28 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1829, new AxoMessengerTextItem("Program 29 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1830, new AxoMessengerTextItem("Program 30 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1831, new AxoMessengerTextItem("Program 31 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1832, new AxoMessengerTextItem("Program 32 corruption error"                                                                                                      ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1852, new AxoMessengerTextItem("Program switching error (on startup;external input)"                                                                              ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1853, new AxoMessengerTextItem("Program switching error (on startup;Panel/PC/Network/Automatic Switching)"                                                        ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1855, new AxoMessengerTextItem("Program switching error (in [RUN] status)"                                                                                        ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1879, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1895, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1896, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1897, new AxoMessengerTextItem("Non-volatile memory error"                                                                                                        ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1898, new AxoMessengerTextItem("Non-volatile memory error"                                                                                                        ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1899, new AxoMessengerTextItem("Non-volatile memory error"                                                                                                        ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1900, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1901, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1902, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1903, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1904, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1905, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1906, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1907, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1908, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1909, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1910, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1911, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1912, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1913, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1914, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1915, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1916, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1917, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1918, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1919, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1920, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1921, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1922, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1923, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1924, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1925, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1926, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1927, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1928, new AxoMessengerTextItem("System error"                                                                                                                     ,"Check the product documentation.")),

                // TriggerTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("TriggerTask finished with error!"                                                                                                ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("TriggerTask was aborted, while not yet completed!"                                                                               ,"Check the details.")),
                // ChangeProgramTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("ChangeProgramTask finished with error!"                                                                                          ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("ChangeProgramTask was aborted, while not yet completed!"                                                                         ,"Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                // TriggerTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.TriggerReady` to be set!"                                               ,"Check the status of the `Inputs.CommandStatusBits.TriggerReady`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.TriggerResponse` to be set!"                                            ,"Check the status of the `Inputs.CommandStatusBits.TriggerResponse`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.BUSY` to be set!"                                                       ,"Check the status of the `Inputs.CommandStatusBits.BUSY`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.ImagingStatus` to be se!"                                               ,"Check the status of the `Inputs.CommandStatusBits.ImagingStatus`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.BUSY` to be reseted!"                                                   ,"Check the status of the `Inputs.CommandStatusBits.BUSY`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(505,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.ResultUpdateComplete` to be inverted!"                                  ,"Check the status of the `Inputs.CommandStatusBits.ResultUpdateComplete`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(506,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.ResultAvailable` to be set!"                                            ,"Check the status of the `Inputs.CommandStatusBits.ResultAvailable`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(507,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.DeviceStatusWords.ResultNo` to be incremented!"                                           ,"Check the status of the `_insert_naInputs.DeviceStatusWords.ResultNome_`  signal/variable.")),
                // ChangeProgramTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Required program number is greather than the maximal program number of the device."                                               ,"Check the value of the program number")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.DeviceStatusWords.CurrentProgramNo` to be equal to `Outputs.CommandControl.ProgramNo`"    ,"Check the status of the `Inputs.DeviceStatusWords.CurrentProgramNo`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.ProgramSwitchingResponse` to be set!"                                   ,"Check the status of the `Inputs.CommandStatusBits.ProgramSwitchingResponse`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.CommandStatusBits.ProgramSwitchingResponse` to be reseted!"                               ,"Check the status of the `Inputs.CommandStatusBits.ProgramSwitchingResponse`  signal/variable.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }


        /// <summary>
        /// Configures proxying requests to the camera's internal web server.
        /// This method intercepts HTTP requests starting with the specified proxy path
        /// and forwards them to the camera's internal IP address. Settings are provided by pragmas in the PLC code
        /// (Proxy, DeviceIpAddress).
        /// </summary>
        public async Task ConfigureProxy(HttpContext httpContext, Func<Task> func)
        {
            try
            {
                if (httpContext.Request.Path.StartsWithSegments($"/{Proxy}"))
                {
                    // Internal IP of the camera
                    var cameraUrl = $"http://{DeviceIpAddress}" + httpContext.Request.Path.Value.Replace($"/{Proxy}", "");

                    using var httpClient = new HttpClient();
                    var response = await httpClient.GetAsync(cameraUrl, HttpCompletionOption.ResponseHeadersRead);

                    if (response.IsSuccessStatusCode)
                    {
                        httpContext.Response.ContentType = response.Content.Headers.ContentType?.ToString() ?? "application/octet-stream";
                        await response.Content.CopyToAsync(httpContext.Response.Body);
                        return;
                    }
                }

                await func(); // Continue to Blazor handling
            }
            catch (Exception)
            {
                AxoApplication.Current.Logger?.Error($"Error proxying request to camera at IP {DeviceIpAddress}.", null);
            }
            
        }
    }

    public partial class Axo_IV3_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    //  General warnings
                    errorDescriptionDict.Add(454, "Expansion program setting mismatch error (normal)"                                                                             );
                    errorDescriptionDict.Add(458, "External master registration error (OCR)"                                                                                      );
                    errorDescriptionDict.Add(460, "Field Network Error, Invalid request (OCR/threshold)"                                                                          );
                    errorDescriptionDict.Add(461, "Field network bad request error (FTP/SD)"                                                                                      );
                    errorDescriptionDict.Add(462, "Field network overrun error"                                                                                                   );
                    errorDescriptionDict.Add(463, "Field Network Error, Invalid request (Save Master)"                                                                            );
                    errorDescriptionDict.Add(464, "Field Network Error, Invalid request (Change Program)"                                                                         );
                    errorDescriptionDict.Add(465, "Trigger error"                                                                                                                 );
                    errorDescriptionDict.Add(466, "External master registration error (Insufficient outline)"                                                                     );
                    errorDescriptionDict.Add(467, "External master registration error (Insufficient area)"                                                                        );
                    errorDescriptionDict.Add(468, "External master registration error (Brightness correction failed)"                                                             );
                    errorDescriptionDict.Add(469, "External master registration error (Insufficient edge failed)"                                                                 );
                    errorDescriptionDict.Add(470, "FTP Transfer Error (Insufficient Data Buffer)"                                                                                 );
                    errorDescriptionDict.Add(471, "FTP Transfer Error (Transfer Failed)"                                                                                          );
                    errorDescriptionDict.Add(472, "FTP Connection Error"                                                                                                          );
                    errorDescriptionDict.Add(473, "External master registration error (Insufficient work memory)"                                                                 );
                    errorDescriptionDict.Add(474, "External master registration error (No images)"                                                                                );
                    errorDescriptionDict.Add(475, "SD Card Transfer Error (Insufficient Transfer Buffer)"                                                                         );
                    errorDescriptionDict.Add(476, "SD Card Transfer Error (Transfer Failed)"                                                                                      );
                    errorDescriptionDict.Add(477, "External master registration error (learning tool/sorting mode)"                                                               );
                    // TriggerTask
                    errorDescriptionDict.Add(500,  "Waiting for the signal/variable `Inputs.CommandStatusBits.TriggerReady` to be set!"                                               );
                    errorDescriptionDict.Add(501,  "Waiting for the signal/variable `Inputs.CommandStatusBits.TriggerResponse` to be set!"                                            );
                    errorDescriptionDict.Add(502,  "Waiting for the signal/variable `Inputs.CommandStatusBits.BUSY` to be set!"                                                       );
                    errorDescriptionDict.Add(503,  "Waiting for the signal/variable `Inputs.CommandStatusBits.ImagingStatus` to be set!"                                              );
                    errorDescriptionDict.Add(504,  "Waiting for the signal/variable `Inputs.CommandStatusBits.BUSY` to be reseted!"                                                   );
                    errorDescriptionDict.Add(505,  "Waiting for the signal/variable `Inputs.CommandStatusBits.ResultUpdateComplete` to be inverted!"                                  );
                    errorDescriptionDict.Add(506,  "Waiting for the signal/variable `Inputs.CommandStatusBits.ResultAvailable` to be set!"                                            );
                    errorDescriptionDict.Add(507,  "Waiting for the signal/variable `Inputs.DeviceStatusWords.ResultNo` to be incremented!"                                           );
                    // ChangeProgramTask
                    errorDescriptionDict.Add(510,  "Required program number is greather than the maximal program number of the device."                                               );
                    errorDescriptionDict.Add(511, "Waiting for the signal/variable `Inputs.DeviceStatusWords.CurrentProgramNo` to be equal to `Outputs.CommandControl.ProgramNo`"     );
                    errorDescriptionDict.Add(512,  "Waiting for the signal/variable `Inputs.CommandStatusBits.ProgramSwitchingResponse` to be set!"                                   );
                    errorDescriptionDict.Add(513,  "Waiting for the signal/variable `Inputs.CommandStatusBits.ProgramSwitchingResponse` to be reseted!"                               );
                    //  General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                              );
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                                             );
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."   );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl is zero."                                               );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."          );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."          );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."          );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."          );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."          );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: '101'."                  );
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwID_CommandStatusBits is zero."                                            );
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."          );
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."          );
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."          );
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."          );
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."          );
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: '201'."                  );
                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceResultBits_1 is zero."                                           );
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."          );
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."          );
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."          );
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."          );
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."          );
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: '202'."                  );
                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatusWords is zero."                                            );
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."          );
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."          );
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."          );
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."          );
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."          );
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: '203'."                  );
                    errorDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatistics is zero."                                             );
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."          );
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."          );
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."          );
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."          );
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."          );
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: '204'."                  );
                    errorDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDs.HwID_PositionAdjustResult is zero."                                         );
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."          );
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."          );
                    errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."          );
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."          );
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."          );
                    errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: '301'."                  );
                    errorDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_1 is zero."                                                 );
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."          );
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."          );
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."          );
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."          );
                    errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."          );
                    errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: '302'."                  );
                    errorDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_2 is zero."                                                 );
                    errorDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."          );
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."          );
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."          );
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."          );
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."          );
                    errorDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: '302'."                  );
                    errorDescriptionDict.Add(790, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_3 is zero."                                                 );
                    errorDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9."          );
                    errorDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9."          );
                    errorDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9."          );
                    errorDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9."          );
                    errorDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9."          );
                    errorDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: '302'."                  );
                    errorDescriptionDict.Add(800, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_4 is zero."                                                 );
                    errorDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10."         );
                    errorDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10."         );
                    errorDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10."         );
                    errorDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10."         );
                    errorDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10."         );
                    errorDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: '302'."                 );
                    errorDescriptionDict.Add(810, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_5 is zero."                                                 );
                    errorDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11."         );
                    errorDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11."         );
                    errorDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11."         );
                    errorDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11."         );
                    errorDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11."         );
                    errorDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: '302'."                 );
                    errorDescriptionDict.Add(820, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_6 is zero."                                                 );
                    errorDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12."         );
                    errorDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12."         );
                    errorDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12."         );
                    errorDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12."         );
                    errorDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12."         );
                    errorDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: '302'."                 );
                    errorDescriptionDict.Add(830, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_7 is zero."                                                 );
                    errorDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13."         );
                    errorDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13."         );
                    errorDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13."         );
                    errorDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13."         );
                    errorDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13."         );
                    errorDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: '302'."                 );
                    errorDescriptionDict.Add(840, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_8 is zero."                                                 );
                    errorDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14."         );
                    errorDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14."         );
                    errorDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14."         );
                    errorDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14."         );
                    errorDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14."         );
                    errorDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 14. Expected module: '302'."                 );
                    errorDescriptionDict.Add(850, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_9 is zero."                                                 );
                    errorDescriptionDict.Add(851, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15."         );
                    errorDescriptionDict.Add(852, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15."         );
                    errorDescriptionDict.Add(853, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15."         );
                    errorDescriptionDict.Add(854, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15."         );
                    errorDescriptionDict.Add(855, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15."         );
                    errorDescriptionDict.Add(856, "Hw configuration error: Module with unexpected size or type detected in Slot 15. Expected module: '302'."                 );
                    errorDescriptionDict.Add(860, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_10 is zero."                                                );
                    errorDescriptionDict.Add(861, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16."         );
                    errorDescriptionDict.Add(862, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16."         );
                    errorDescriptionDict.Add(863, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16."         );
                    errorDescriptionDict.Add(864, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16."         );
                    errorDescriptionDict.Add(865, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16."         );
                    errorDescriptionDict.Add(866, "Hw configuration error: Module with unexpected size or type detected in Slot 16. Expected module: '302'."                 );
                    errorDescriptionDict.Add(870, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_11 is zero."                                                );
                    errorDescriptionDict.Add(871, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17."         );
                    errorDescriptionDict.Add(872, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17."         );
                    errorDescriptionDict.Add(873, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17."         );
                    errorDescriptionDict.Add(874, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17."         );
                    errorDescriptionDict.Add(875, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17."         );
                    errorDescriptionDict.Add(876, "Hw configuration error: Module with unexpected size or type detected in Slot 17. Expected module: '302'."                 );
                    errorDescriptionDict.Add(880, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_12 is zero."                                                );
                    errorDescriptionDict.Add(881, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18."         );
                    errorDescriptionDict.Add(882, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18."         );
                    errorDescriptionDict.Add(883, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18."         );
                    errorDescriptionDict.Add(884, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18."         );
                    errorDescriptionDict.Add(885, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18."         );
                    errorDescriptionDict.Add(886, "Hw configuration error: Module with unexpected size or type detected in Slot 18. Expected module: '302'."                 );
                    errorDescriptionDict.Add(890, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_13 is zero."                                                );
                    errorDescriptionDict.Add(891, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19."         );
                    errorDescriptionDict.Add(892, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19."         );
                    errorDescriptionDict.Add(893, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19."         );
                    errorDescriptionDict.Add(894, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19."         );
                    errorDescriptionDict.Add(895, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19."         );
                    errorDescriptionDict.Add(896, "Hw configuration error: Module with unexpected size or type detected in Slot 19. Expected module: '302'."                 );
                    errorDescriptionDict.Add(900, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_14 is zero."                                                );
                    errorDescriptionDict.Add(901, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20."         );
                    errorDescriptionDict.Add(902, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20."         );
                    errorDescriptionDict.Add(903, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20."         );
                    errorDescriptionDict.Add(904, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20."         );
                    errorDescriptionDict.Add(905, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20."         );
                    errorDescriptionDict.Add(906, "Hw configuration error: Module with unexpected size or type detected in Slot 20. Expected module: '302'."                 );
                    errorDescriptionDict.Add(910, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_15 is zero."                                                );
                    errorDescriptionDict.Add(911, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 21."         );
                    errorDescriptionDict.Add(912, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 21."         );
                    errorDescriptionDict.Add(913, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 21."         );
                    errorDescriptionDict.Add(914, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 21."         );
                    errorDescriptionDict.Add(915, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 21."         );
                    errorDescriptionDict.Add(916, "Hw configuration error: Module with unexpected size or type detected in Slot 21. Expected module: '302'."                 );
                    errorDescriptionDict.Add(920, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_16 is zero."                                                );
                    errorDescriptionDict.Add(921, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 22."         );
                    errorDescriptionDict.Add(922, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 22."         );
                    errorDescriptionDict.Add(923, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 22."         );
                    errorDescriptionDict.Add(924, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 22."         );
                    errorDescriptionDict.Add(925, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 22."         );
                    errorDescriptionDict.Add(926, "Hw configuration error: Module with unexpected size or type detected in Slot 22. Expected module: '302'."                 );
                    errorDescriptionDict.Add(930, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_17 is zero."                                                );
                    errorDescriptionDict.Add(931, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 23."         );
                    errorDescriptionDict.Add(932, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 23."         );
                    errorDescriptionDict.Add(933, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 23."         );
                    errorDescriptionDict.Add(934, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 23."         );
                    errorDescriptionDict.Add(935, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 23."         );
                    errorDescriptionDict.Add(936, "Hw configuration error: Module with unexpected size or type detected in Slot 23. Expected module: '302'."                 );
                    errorDescriptionDict.Add(940, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_18 is zero."                                                );
                    errorDescriptionDict.Add(941, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 24."         );
                    errorDescriptionDict.Add(942, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 24."         );
                    errorDescriptionDict.Add(943, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 24."         );
                    errorDescriptionDict.Add(944, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 24."         );
                    errorDescriptionDict.Add(945, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 24."         );
                    errorDescriptionDict.Add(946, "Hw configuration error: Module with unexpected size or type detected in Slot 24. Expected module: '302'."                 );
                    errorDescriptionDict.Add(950, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_19 is zero."                                                );
                    errorDescriptionDict.Add(951, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 25."         );
                    errorDescriptionDict.Add(952, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 25."         );
                    errorDescriptionDict.Add(953, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 25."         );
                    errorDescriptionDict.Add(954, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 25."         );
                    errorDescriptionDict.Add(955, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 25."         );
                    errorDescriptionDict.Add(956, "Hw configuration error: Module with unexpected size or type detected in Slot 25. Expected module: '302'."                 );
                    errorDescriptionDict.Add(960, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_20 is zero."                                                );
                    errorDescriptionDict.Add(961, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 26."         );
                    errorDescriptionDict.Add(962, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 26."         );
                    errorDescriptionDict.Add(963, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 26."         );
                    errorDescriptionDict.Add(964, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 26."         );
                    errorDescriptionDict.Add(965, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 26."         );
                    errorDescriptionDict.Add(966, "Hw configuration error: Module with unexpected size or type detected in Slot 26. Expected module: '302'."                 );
                    errorDescriptionDict.Add(970, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_21 is zero."                                                );
                    errorDescriptionDict.Add(971, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 27."         );
                    errorDescriptionDict.Add(972, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 27."         );
                    errorDescriptionDict.Add(973, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 27."         );
                    errorDescriptionDict.Add(974, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 27."         );
                    errorDescriptionDict.Add(975, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 27."         );
                    errorDescriptionDict.Add(976, "Hw configuration error: Module with unexpected size or type detected in Slot 27. Expected module: '302'."                 );
                    errorDescriptionDict.Add(980, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_22 is zero."                                                );
                    errorDescriptionDict.Add(981, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 28."         );
                    errorDescriptionDict.Add(982, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 28."         );
                    errorDescriptionDict.Add(983, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 28."         );
                    errorDescriptionDict.Add(984, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 28."         );
                    errorDescriptionDict.Add(985, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 28."         );
                    errorDescriptionDict.Add(986, "Hw configuration error: Module with unexpected size or type detected in Slot 28. Expected module: '302'."                 );
                    errorDescriptionDict.Add(990, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_23 is zero."                                                );
                    errorDescriptionDict.Add(991, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 29."         );
                    errorDescriptionDict.Add(992, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 29."         );
                    errorDescriptionDict.Add(993, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 29."         );
                    errorDescriptionDict.Add(994, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 29."         );
                    errorDescriptionDict.Add(995, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 29."         );
                    errorDescriptionDict.Add(996, "Hw configuration error: Module with unexpected size or type detected in Slot 29. Expected module: '302'."                 );
                    errorDescriptionDict.Add(1000, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_24 is zero."                                               );
                    errorDescriptionDict.Add(1001, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 30."        );
                    errorDescriptionDict.Add(1002, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 30."        );
                    errorDescriptionDict.Add(1003, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 30."        );
                    errorDescriptionDict.Add(1004, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 30."        );
                    errorDescriptionDict.Add(1005, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 30."        );
                    errorDescriptionDict.Add(1006, "Hw configuration error: Module with unexpected size or type detected in Slot 30. Expected module: '302'."                );
                    errorDescriptionDict.Add(1010, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_25 is zero."                                               );
                    errorDescriptionDict.Add(1011, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 31."        );
                    errorDescriptionDict.Add(1012, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 31."        );
                    errorDescriptionDict.Add(1013, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 31."        );
                    errorDescriptionDict.Add(1014, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 31."        );
                    errorDescriptionDict.Add(1015, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 31."        );
                    errorDescriptionDict.Add(1016, "Hw configuration error: Module with unexpected size or type detected in Slot 31. Expected module: '302'."                );
                    errorDescriptionDict.Add(1020, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_26 is zero."                                               );
                    errorDescriptionDict.Add(1021, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 32."        );
                    errorDescriptionDict.Add(1022, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 32."        );
                    errorDescriptionDict.Add(1023, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 32."        );
                    errorDescriptionDict.Add(1024, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 32."        );
                    errorDescriptionDict.Add(1025, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 32."        );
                    errorDescriptionDict.Add(1026, "Hw configuration error: Module with unexpected size or type detected in Slot 32. Expected module: '302'."                );
                    errorDescriptionDict.Add(1030, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_27 is zero."                                               );
                    errorDescriptionDict.Add(1031, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 33."        );
                    errorDescriptionDict.Add(1032, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 33."        );
                    errorDescriptionDict.Add(1033, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 33."        );
                    errorDescriptionDict.Add(1034, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 33."        );
                    errorDescriptionDict.Add(1035, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 33."        );
                    errorDescriptionDict.Add(1036, "Hw configuration error: Module with unexpected size or type detected in Slot 33. Expected module: '302'."                );
                    errorDescriptionDict.Add(1040, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_28 is zero."                                               );
                    errorDescriptionDict.Add(1041, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 34."        );
                    errorDescriptionDict.Add(1042, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 34."        );
                    errorDescriptionDict.Add(1043, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 34."        );
                    errorDescriptionDict.Add(1044, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 34."        );
                    errorDescriptionDict.Add(1045, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 34."        );
                    errorDescriptionDict.Add(1046, "Hw configuration error: Module with unexpected size or type detected in Slot 34. Expected module: '302'."                );
                    errorDescriptionDict.Add(1050, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_29 is zero."                                               );
                    errorDescriptionDict.Add(1051, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 35."        );
                    errorDescriptionDict.Add(1052, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 35."        );
                    errorDescriptionDict.Add(1053, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 35."        );
                    errorDescriptionDict.Add(1054, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 35."        );
                    errorDescriptionDict.Add(1055, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 35."        );
                    errorDescriptionDict.Add(1056, "Hw configuration error: Module with unexpected size or type detected in Slot 35. Expected module: '302'."                );
                    errorDescriptionDict.Add(1060, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_30 is zero."                                               );
                    errorDescriptionDict.Add(1061, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 36."        );
                    errorDescriptionDict.Add(1062, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 36."        );
                    errorDescriptionDict.Add(1063, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 36."        );
                    errorDescriptionDict.Add(1064, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 36."        );
                    errorDescriptionDict.Add(1065, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 36."        );
                    errorDescriptionDict.Add(1066, "Hw configuration error: Module with unexpected size or type detected in Slot 36. Expected module: '302'."                );
                    errorDescriptionDict.Add(1070, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_31 is zero."                                               );
                    errorDescriptionDict.Add(1071, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 37."        );
                    errorDescriptionDict.Add(1072, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 37."        );
                    errorDescriptionDict.Add(1073, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 37."        );
                    errorDescriptionDict.Add(1074, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 37."        );
                    errorDescriptionDict.Add(1075, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 37."        );
                    errorDescriptionDict.Add(1076, "Hw configuration error: Module with unexpected size or type detected in Slot 37. Expected module: '302'."                );
                    errorDescriptionDict.Add(1080, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_32 is zero."                                               );
                    errorDescriptionDict.Add(1081, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 38."        );
                    errorDescriptionDict.Add(1082, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 38."        );
                    errorDescriptionDict.Add(1083, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 38."        );
                    errorDescriptionDict.Add(1084, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 38."        );
                    errorDescriptionDict.Add(1085, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 38."        );
                    errorDescriptionDict.Add(1086, "Hw configuration error: Module with unexpected size or type detected in Slot 38. Expected module: '302'."                );
                    errorDescriptionDict.Add(1090, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_33 is zero."                                               );
                    errorDescriptionDict.Add(1091, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 39."        );
                    errorDescriptionDict.Add(1092, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 39."        );
                    errorDescriptionDict.Add(1093, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 39."        );
                    errorDescriptionDict.Add(1094, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 39."        );
                    errorDescriptionDict.Add(1095, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 39."        );
                    errorDescriptionDict.Add(1096, "Hw configuration error: Module with unexpected size or type detected in Slot 39. Expected module: '302'."                );
                    errorDescriptionDict.Add(1100, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_34 is zero."                                               );
                    errorDescriptionDict.Add(1101, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 40."        );
                    errorDescriptionDict.Add(1102, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 40."        );
                    errorDescriptionDict.Add(1103, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 40."        );
                    errorDescriptionDict.Add(1104, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 40."        );
                    errorDescriptionDict.Add(1105, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 40."        );
                    errorDescriptionDict.Add(1106, "Hw configuration error: Module with unexpected size or type detected in Slot 40. Expected module: '302'."                );
                    errorDescriptionDict.Add(1110, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_35 is zero."                                               );
                    errorDescriptionDict.Add(1111, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 41."        );
                    errorDescriptionDict.Add(1112, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 41."        );
                    errorDescriptionDict.Add(1113, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 41."        );
                    errorDescriptionDict.Add(1114, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 41."        );
                    errorDescriptionDict.Add(1115, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 41."        );
                    errorDescriptionDict.Add(1116, "Hw configuration error: Module with unexpected size or type detected in Slot 41. Expected module: '302'."                );
                    errorDescriptionDict.Add(1120, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_36 is zero."                                               );
                    errorDescriptionDict.Add(1121, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 42."        );
                    errorDescriptionDict.Add(1122, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 42."        );
                    errorDescriptionDict.Add(1123, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 42."        );
                    errorDescriptionDict.Add(1124, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 42."        );
                    errorDescriptionDict.Add(1125, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 42."        );
                    errorDescriptionDict.Add(1126, "Hw configuration error: Module with unexpected size or type detected in Slot 42. Expected module: '302'."                );
                    errorDescriptionDict.Add(1130, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_37 is zero."                                               );
                    errorDescriptionDict.Add(1131, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 43."        );
                    errorDescriptionDict.Add(1132, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 43."        );
                    errorDescriptionDict.Add(1133, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 43."        );
                    errorDescriptionDict.Add(1134, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 43."        );
                    errorDescriptionDict.Add(1135, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 43."        );
                    errorDescriptionDict.Add(1136, "Hw configuration error: Module with unexpected size or type detected in Slot 43. Expected module: '302'."                );
                    errorDescriptionDict.Add(1140, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_38 is zero."                                               );
                    errorDescriptionDict.Add(1141, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 44."        );
                    errorDescriptionDict.Add(1142, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 44."        );
                    errorDescriptionDict.Add(1143, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 44."        );
                    errorDescriptionDict.Add(1144, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 44."        );
                    errorDescriptionDict.Add(1145, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 44."        );
                    errorDescriptionDict.Add(1146, "Hw configuration error: Module with unexpected size or type detected in Slot 44. Expected module: '302'."                );
                    errorDescriptionDict.Add(1150, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_39 is zero."                                               );
                    errorDescriptionDict.Add(1151, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 45."        );
                    errorDescriptionDict.Add(1152, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 45."        );
                    errorDescriptionDict.Add(1153, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 45."        );
                    errorDescriptionDict.Add(1154, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 45."        );
                    errorDescriptionDict.Add(1155, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 45."        );
                    errorDescriptionDict.Add(1156, "Hw configuration error: Module with unexpected size or type detected in Slot 45. Expected module: '302'."                );
                    errorDescriptionDict.Add(1160, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_40 is zero."                                               );
                    errorDescriptionDict.Add(1161, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 46."        );
                    errorDescriptionDict.Add(1162, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 46."        );
                    errorDescriptionDict.Add(1163, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 46."        );
                    errorDescriptionDict.Add(1164, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 46."        );
                    errorDescriptionDict.Add(1165, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 46."        );
                    errorDescriptionDict.Add(1166, "Hw configuration error: Module with unexpected size or type detected in Slot 46. Expected module: '302'."                );
                    errorDescriptionDict.Add(1170, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_41 is zero."                                               );
                    errorDescriptionDict.Add(1171, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 47."        );
                    errorDescriptionDict.Add(1172, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 47."        );
                    errorDescriptionDict.Add(1173, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 47."        );
                    errorDescriptionDict.Add(1174, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 47."        );
                    errorDescriptionDict.Add(1175, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 47."        );
                    errorDescriptionDict.Add(1176, "Hw configuration error: Module with unexpected size or type detected in Slot 47. Expected module: '302'."                );
                    errorDescriptionDict.Add(1180, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_42 is zero."                                               );
                    errorDescriptionDict.Add(1181, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 48."        );
                    errorDescriptionDict.Add(1182, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 48."        );
                    errorDescriptionDict.Add(1183, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 48."        );
                    errorDescriptionDict.Add(1184, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 48."        );
                    errorDescriptionDict.Add(1185, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 48."        );
                    errorDescriptionDict.Add(1186, "Hw configuration error: Module with unexpected size or type detected in Slot 48. Expected module: '302'."                );
                    errorDescriptionDict.Add(1190, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_43 is zero."                                               );
                    errorDescriptionDict.Add(1191, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 49."        );
                    errorDescriptionDict.Add(1192, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 49."        );
                    errorDescriptionDict.Add(1193, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 49."        );
                    errorDescriptionDict.Add(1194, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 49."        );
                    errorDescriptionDict.Add(1195, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 49."        );
                    errorDescriptionDict.Add(1196, "Hw configuration error: Module with unexpected size or type detected in Slot 49. Expected module: '302'."                );
                    errorDescriptionDict.Add(1200, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_44 is zero."                                               );
                    errorDescriptionDict.Add(1201, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 50."        );
                    errorDescriptionDict.Add(1202, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 50."        );
                    errorDescriptionDict.Add(1203, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 50."        );
                    errorDescriptionDict.Add(1204, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 50."        );
                    errorDescriptionDict.Add(1205, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 50."        );
                    errorDescriptionDict.Add(1206, "Hw configuration error: Module with unexpected size or type detected in Slot 50. Expected module: '302'."                );
                    errorDescriptionDict.Add(1210, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_45 is zero."                                               );
                    errorDescriptionDict.Add(1211, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 51."        );
                    errorDescriptionDict.Add(1212, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 51."        );
                    errorDescriptionDict.Add(1213, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 51."        );
                    errorDescriptionDict.Add(1214, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 51."        );
                    errorDescriptionDict.Add(1215, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 51."        );
                    errorDescriptionDict.Add(1216, "Hw configuration error: Module with unexpected size or type detected in Slot 51. Expected module: '302'."                );
                    errorDescriptionDict.Add(1220, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_46 is zero."                                               );
                    errorDescriptionDict.Add(1221, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 52."        );
                    errorDescriptionDict.Add(1222, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 52."        );
                    errorDescriptionDict.Add(1223, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 52."        );
                    errorDescriptionDict.Add(1224, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 52."        );
                    errorDescriptionDict.Add(1225, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 52."        );
                    errorDescriptionDict.Add(1226, "Hw configuration error: Module with unexpected size or type detected in Slot 52. Expected module: '302'."                );
                    errorDescriptionDict.Add(1230, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_47 is zero."                                               );
                    errorDescriptionDict.Add(1231, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 53."        );
                    errorDescriptionDict.Add(1232, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 53."        );
                    errorDescriptionDict.Add(1233, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 53."        );
                    errorDescriptionDict.Add(1234, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 53."        );
                    errorDescriptionDict.Add(1235, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 53."        );
                    errorDescriptionDict.Add(1236, "Hw configuration error: Module with unexpected size or type detected in Slot 53. Expected module: '302'."                );
                    errorDescriptionDict.Add(1240, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_48 is zero."                                               );
                    errorDescriptionDict.Add(1241, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 54."        );
                    errorDescriptionDict.Add(1242, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 54."        );
                    errorDescriptionDict.Add(1243, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 54."        );
                    errorDescriptionDict.Add(1244, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 54."        );
                    errorDescriptionDict.Add(1245, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 54."        );
                    errorDescriptionDict.Add(1246, "Hw configuration error: Module with unexpected size or type detected in Slot 54. Expected module: '302'."                );
                    errorDescriptionDict.Add(1250, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_49 is zero."                                               );
                    errorDescriptionDict.Add(1251, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 55."        );
                    errorDescriptionDict.Add(1252, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 55."        );
                    errorDescriptionDict.Add(1253, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 55."        );
                    errorDescriptionDict.Add(1254, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 55."        );
                    errorDescriptionDict.Add(1255, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 55."        );
                    errorDescriptionDict.Add(1256, "Hw configuration error: Module with unexpected size or type detected in Slot 55. Expected module: '302'."                );
                    errorDescriptionDict.Add(1260, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_50 is zero."                                               );
                    errorDescriptionDict.Add(1261, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 56."        );
                    errorDescriptionDict.Add(1262, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 56."        );
                    errorDescriptionDict.Add(1263, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 56."        );
                    errorDescriptionDict.Add(1264, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 56."        );
                    errorDescriptionDict.Add(1265, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 56."        );
                    errorDescriptionDict.Add(1266, "Hw configuration error: Module with unexpected size or type detected in Slot 56. Expected module: '302'."                );
                    errorDescriptionDict.Add(1270, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_51 is zero."                                               );
                    errorDescriptionDict.Add(1271, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 57."        );
                    errorDescriptionDict.Add(1272, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 57."        );
                    errorDescriptionDict.Add(1273, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 57."        );
                    errorDescriptionDict.Add(1274, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 57."        );
                    errorDescriptionDict.Add(1275, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 57."        );
                    errorDescriptionDict.Add(1276, "Hw configuration error: Module with unexpected size or type detected in Slot 57. Expected module: '302'."                );
                    errorDescriptionDict.Add(1280, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_52 is zero."                                               );
                    errorDescriptionDict.Add(1281, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 58."        );
                    errorDescriptionDict.Add(1282, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 58."        );
                    errorDescriptionDict.Add(1283, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 58."        );
                    errorDescriptionDict.Add(1284, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 58."        );
                    errorDescriptionDict.Add(1285, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 58."        );
                    errorDescriptionDict.Add(1286, "Hw configuration error: Module with unexpected size or type detected in Slot 58. Expected module: '302'."                );
                    errorDescriptionDict.Add(1290, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_53 is zero."                                               );
                    errorDescriptionDict.Add(1291, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 59."        );
                    errorDescriptionDict.Add(1292, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 59."        );
                    errorDescriptionDict.Add(1293, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 59."        );
                    errorDescriptionDict.Add(1294, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 59."        );
                    errorDescriptionDict.Add(1295, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 59."        );
                    errorDescriptionDict.Add(1296, "Hw configuration error: Module with unexpected size or type detected in Slot 59. Expected module: '302'."                );
                    errorDescriptionDict.Add(1300, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_54 is zero."                                               );
                    errorDescriptionDict.Add(1301, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 60."        );
                    errorDescriptionDict.Add(1302, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 60."        );
                    errorDescriptionDict.Add(1303, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 60."        );
                    errorDescriptionDict.Add(1304, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 60."        );
                    errorDescriptionDict.Add(1305, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 60."        );
                    errorDescriptionDict.Add(1306, "Hw configuration error: Module with unexpected size or type detected in Slot 60. Expected module: '302'."                );
                    errorDescriptionDict.Add(1310, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_55 is zero."                                               );
                    errorDescriptionDict.Add(1311, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 61."        );
                    errorDescriptionDict.Add(1312, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 61."        );
                    errorDescriptionDict.Add(1313, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 61."        );
                    errorDescriptionDict.Add(1314, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 61."        );
                    errorDescriptionDict.Add(1315, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 61."        );
                    errorDescriptionDict.Add(1316, "Hw configuration error: Module with unexpected size or type detected in Slot 61. Expected module: '302'."                );
                    errorDescriptionDict.Add(1320, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_56 is zero."                                               );
                    errorDescriptionDict.Add(1321, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 62."        );
                    errorDescriptionDict.Add(1322, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 62."        );
                    errorDescriptionDict.Add(1323, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 62."        );
                    errorDescriptionDict.Add(1324, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 62."        );
                    errorDescriptionDict.Add(1325, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 62."        );
                    errorDescriptionDict.Add(1326, "Hw configuration error: Module with unexpected size or type detected in Slot 62. Expected module: '302'."                );
                    errorDescriptionDict.Add(1330, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_57 is zero."                                               );
                    errorDescriptionDict.Add(1331, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 63."        );
                    errorDescriptionDict.Add(1332, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 63."        );
                    errorDescriptionDict.Add(1333, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 63."        );
                    errorDescriptionDict.Add(1334, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 63."        );
                    errorDescriptionDict.Add(1335, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 63."        );
                    errorDescriptionDict.Add(1336, "Hw configuration error: Module with unexpected size or type detected in Slot 63. Expected module: '302'."                );
                    errorDescriptionDict.Add(1340, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_58 is zero."                                               );
                    errorDescriptionDict.Add(1341, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 64."        );
                    errorDescriptionDict.Add(1342, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 64."        );
                    errorDescriptionDict.Add(1343, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 64."        );
                    errorDescriptionDict.Add(1344, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 64."        );
                    errorDescriptionDict.Add(1345, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 64."        );
                    errorDescriptionDict.Add(1346, "Hw configuration error: Module with unexpected size or type detected in Slot 64. Expected module: '302'."                );
                    errorDescriptionDict.Add(1350, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_59 is zero."                                               );
                    errorDescriptionDict.Add(1351, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 65."        );
                    errorDescriptionDict.Add(1352, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 65."        );
                    errorDescriptionDict.Add(1353, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 65."        );
                    errorDescriptionDict.Add(1354, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 65."        );
                    errorDescriptionDict.Add(1355, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 65."        );
                    errorDescriptionDict.Add(1356, "Hw configuration error: Module with unexpected size or type detected in Slot 65. Expected module: '302'."                );
                    errorDescriptionDict.Add(1360, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_60 is zero."                                               );
                    errorDescriptionDict.Add(1361, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 66."        );
                    errorDescriptionDict.Add(1362, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 66."        );
                    errorDescriptionDict.Add(1363, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 66."        );
                    errorDescriptionDict.Add(1364, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 66."        );
                    errorDescriptionDict.Add(1365, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 66."        );
                    errorDescriptionDict.Add(1366, "Hw configuration error: Module with unexpected size or type detected in Slot 66. Expected module: '302'."                );
                    errorDescriptionDict.Add(1370, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_61 is zero."                                               );
                    errorDescriptionDict.Add(1371, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 67."        );
                    errorDescriptionDict.Add(1372, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 67."        );
                    errorDescriptionDict.Add(1373, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 67."        );
                    errorDescriptionDict.Add(1374, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 67."        );
                    errorDescriptionDict.Add(1375, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 67."        );
                    errorDescriptionDict.Add(1376, "Hw configuration error: Module with unexpected size or type detected in Slot 67. Expected module: '302'."                );
                    errorDescriptionDict.Add(1380, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_62 is zero."                                               );
                    errorDescriptionDict.Add(1381, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 68."        );
                    errorDescriptionDict.Add(1382, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 68."        );
                    errorDescriptionDict.Add(1383, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 68."        );
                    errorDescriptionDict.Add(1384, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 68."        );
                    errorDescriptionDict.Add(1385, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 68."        );
                    errorDescriptionDict.Add(1386, "Hw configuration error: Module with unexpected size or type detected in Slot 68. Expected module: '302'."                );
                    errorDescriptionDict.Add(1390, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_63 is zero."                                               );
                    errorDescriptionDict.Add(1391, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 69."        );
                    errorDescriptionDict.Add(1392, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 69."        );
                    errorDescriptionDict.Add(1393, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 69."        );
                    errorDescriptionDict.Add(1394, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 69."        );
                    errorDescriptionDict.Add(1395, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 69."        );
                    errorDescriptionDict.Add(1396, "Hw configuration error: Module with unexpected size or type detected in Slot 69. Expected module: '302'."                );
                    errorDescriptionDict.Add(1400, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_64 is zero."                                               );
                    errorDescriptionDict.Add(1401, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 70."        );
                    errorDescriptionDict.Add(1402, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 70."        );
                    errorDescriptionDict.Add(1403, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 70."        );
                    errorDescriptionDict.Add(1404, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 70."        );
                    errorDescriptionDict.Add(1405, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 70."        );
                    errorDescriptionDict.Add(1406, "Hw configuration error: Module with unexpected size or type detected in Slot 70. Expected module: '302'."                );
                    errorDescriptionDict.Add(1410, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceResultBits_2 is zero."                                          );
                    errorDescriptionDict.Add(1411, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 71."        );
                    errorDescriptionDict.Add(1412, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 71."        );
                    errorDescriptionDict.Add(1413, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 71."        );
                    errorDescriptionDict.Add(1414, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 71."        );
                    errorDescriptionDict.Add(1415, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 71."        );
                    errorDescriptionDict.Add(1416, "Hw configuration error: Module with unexpected size or type detected in Slot 71. Expected module: '401'."                );
                    errorDescriptionDict.Add(1500, "Input variable `parent` has NULL reference in `Run` method!"                                    );
                    errorDescriptionDict.Add(1501, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1502, "Variable `Config.HWIDs.HwID_CommandControl` has invalid value in `Run` method!"                 );
                    errorDescriptionDict.Add(1503, "Variable `Config.HWIDs.HwID_CommandStatusBits` has invalid value in `Run` method!"              );
                    errorDescriptionDict.Add(1504, "Variable `Config.HWIDs.HwID_DeviceResultBits_1` has invalid value in `Run` method!"             );
                    errorDescriptionDict.Add(1505, "Variable `Config.HWIDs.HwID_DeviceStatusWords` has invalid value in `Run` method!"              );
                    errorDescriptionDict.Add(1506, "Variable `Config.HWIDs.HwID_DeviceStatistics` has invalid value in `Run` method!"               );
                    errorDescriptionDict.Add(1507, "Variable `Config.HWIDs.HwID_PositionAdjustResult` has invalid value in `Run` method!"           );
                    errorDescriptionDict.Add(1508, "Variable `Config.HWIDs.HwID_ToolResult_1` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1509, "Variable `Config.HWIDs.HwID_ToolResult_2` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1510, "Variable `Config.HWIDs.HwID_ToolResult_3` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1511, "Variable `Config.HWIDs.HwID_ToolResult_4` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1512, "Variable `Config.HWIDs.HwID_ToolResult_5` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1513, "Variable `Config.HWIDs.HwID_ToolResult_6` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1514, "Variable `Config.HWIDs.HwID_ToolResult_7` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1515, "Variable `Config.HWIDs.HwID_ToolResult_8` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1516, "Variable `Config.HWIDs.HwID_ToolResult_9` has invalid value in `Run` method!"                   );
                    errorDescriptionDict.Add(1517, "Variable `Config.HWIDs.HwID_ToolResult_10` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1518, "Variable `Config.HWIDs.HwID_ToolResult_11` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1519, "Variable `Config.HWIDs.HwID_ToolResult_12` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1520, "Variable `Config.HWIDs.HwID_ToolResult_13` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1521, "Variable `Config.HWIDs.HwID_ToolResult_14` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1522, "Variable `Config.HWIDs.HwID_ToolResult_15` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1523, "Variable `Config.HWIDs.HwID_ToolResult_16` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1524, "Variable `Config.HWIDs.HwID_ToolResult_17` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1525, "Variable `Config.HWIDs.HwID_ToolResult_18` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1526, "Variable `Config.HWIDs.HwID_ToolResult_19` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1527, "Variable `Config.HWIDs.HwID_ToolResult_20` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1528, "Variable `Config.HWIDs.HwID_ToolResult_21` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1529, "Variable `Config.HWIDs.HwID_ToolResult_22` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1530, "Variable `Config.HWIDs.HwID_ToolResult_23` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1531, "Variable `Config.HWIDs.HwID_ToolResult_24` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1532, "Variable `Config.HWIDs.HwID_ToolResult_25` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1533, "Variable `Config.HWIDs.HwID_ToolResult_26` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1534, "Variable `Config.HWIDs.HwID_ToolResult_27` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1535, "Variable `Config.HWIDs.HwID_ToolResult_28` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1536, "Variable `Config.HWIDs.HwID_ToolResult_29` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1537, "Variable `Config.HWIDs.HwID_ToolResult_30` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1538, "Variable `Config.HWIDs.HwID_ToolResult_31` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1539, "Variable `Config.HWIDs.HwID_ToolResult_32` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1540, "Variable `Config.HWIDs.HwID_ToolResult_33` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1541, "Variable `Config.HWIDs.HwID_ToolResult_34` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1542, "Variable `Config.HWIDs.HwID_ToolResult_35` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1543, "Variable `Config.HWIDs.HwID_ToolResult_36` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1544, "Variable `Config.HWIDs.HwID_ToolResult_37` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1545, "Variable `Config.HWIDs.HwID_ToolResult_38` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1546, "Variable `Config.HWIDs.HwID_ToolResult_39` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1547, "Variable `Config.HWIDs.HwID_ToolResult_40` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1548, "Variable `Config.HWIDs.HwID_ToolResult_41` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1549, "Variable `Config.HWIDs.HwID_ToolResult_42` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1550, "Variable `Config.HWIDs.HwID_ToolResult_43` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1551, "Variable `Config.HWIDs.HwID_ToolResult_44` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1552, "Variable `Config.HWIDs.HwID_ToolResult_45` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1553, "Variable `Config.HWIDs.HwID_ToolResult_46` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1554, "Variable `Config.HWIDs.HwID_ToolResult_47` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1555, "Variable `Config.HWIDs.HwID_ToolResult_48` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1556, "Variable `Config.HWIDs.HwID_ToolResult_49` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1557, "Variable `Config.HWIDs.HwID_ToolResult_50` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1558, "Variable `Config.HWIDs.HwID_ToolResult_51` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1559, "Variable `Config.HWIDs.HwID_ToolResult_52` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1560, "Variable `Config.HWIDs.HwID_ToolResult_53` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1561, "Variable `Config.HWIDs.HwID_ToolResult_54` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1562, "Variable `Config.HWIDs.HwID_ToolResult_55` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1563, "Variable `Config.HWIDs.HwID_ToolResult_56` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1564, "Variable `Config.HWIDs.HwID_ToolResult_57` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1565, "Variable `Config.HWIDs.HwID_ToolResult_58` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1566, "Variable `Config.HWIDs.HwID_ToolResult_59` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1567, "Variable `Config.HWIDs.HwID_ToolResult_60` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1568, "Variable `Config.HWIDs.HwID_ToolResult_61` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1569, "Variable `Config.HWIDs.HwID_ToolResult_62` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1570, "Variable `Config.HWIDs.HwID_ToolResult_63` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1571, "Variable `Config.HWIDs.HwID_ToolResult_64` has invalid value in `Run` method!"                  );
                    errorDescriptionDict.Add(1572, "Variable `Config.HWIDs.HwID_DeviceResultBits_2` has invalid value in `Run` method!"             );
                    errorDescriptionDict.Add(1601, "Error reading the input data from the module with HWID: 'HwID_CommandStatusBits'!"              );
                    errorDescriptionDict.Add(1602, "Error reading the input data from the module with HWID: 'HwID_DeviceResultBits_1'!"             );
                    errorDescriptionDict.Add(1603, "Error reading the input data from the module with HWID: 'HwID_DeviceStatusWords'!"              );
                    errorDescriptionDict.Add(1604, "Error reading the input data from the module with HWID: 'HwID_DeviceStatistics'!"               );
                    errorDescriptionDict.Add(1605, "Error reading the input data from the module with HWID: 'HwID_PositionAdjustResult'!"           );
                    errorDescriptionDict.Add(1606, "Error reading the input data from the module with HWID: 'HwID_ToolResult_1'!"                   );
                    errorDescriptionDict.Add(1607, "Error reading the input data from the module with HWID: 'HwID_ToolResult_2'!"                   );
                    errorDescriptionDict.Add(1608, "Error reading the input data from the module with HWID: 'HwID_ToolResult_3'!"                   );
                    errorDescriptionDict.Add(1609, "Error reading the input data from the module with HWID: 'HwID_ToolResult_4'!"                   );
                    errorDescriptionDict.Add(1610, "Error reading the input data from the module with HWID: 'HwID_ToolResult_5'!"                   );
                    errorDescriptionDict.Add(1611, "Error reading the input data from the module with HWID: 'HwID_ToolResult_6'!"                   );
                    errorDescriptionDict.Add(1612, "Error reading the input data from the module with HWID: 'HwID_ToolResult_7'!"                   );
                    errorDescriptionDict.Add(1613, "Error reading the input data from the module with HWID: 'HwID_ToolResult_8'!"                   );
                    errorDescriptionDict.Add(1614, "Error reading the input data from the module with HWID: 'HwID_ToolResult_9'!"                   );
                    errorDescriptionDict.Add(1615, "Error reading the input data from the module with HWID: 'HwID_ToolResult_10'!"                  );
                    errorDescriptionDict.Add(1616, "Error reading the input data from the module with HWID: 'HwID_ToolResult_11'!"                  );
                    errorDescriptionDict.Add(1617, "Error reading the input data from the module with HWID: 'HwID_ToolResult_12'!"                  );
                    errorDescriptionDict.Add(1618, "Error reading the input data from the module with HWID: 'HwID_ToolResult_13'!"                  );
                    errorDescriptionDict.Add(1619, "Error reading the input data from the module with HWID: 'HwID_ToolResult_14'!"                  );
                    errorDescriptionDict.Add(1620, "Error reading the input data from the module with HWID: 'HwID_ToolResult_15'!"                  );
                    errorDescriptionDict.Add(1621, "Error reading the input data from the module with HWID: 'HwID_ToolResult_16'!"                  );
                    errorDescriptionDict.Add(1622, "Error reading the input data from the module with HWID: 'HwID_ToolResult_17'!"                  );
                    errorDescriptionDict.Add(1623, "Error reading the input data from the module with HWID: 'HwID_ToolResult_18'!"                  );
                    errorDescriptionDict.Add(1624, "Error reading the input data from the module with HWID: 'HwID_ToolResult_19'!"                  );
                    errorDescriptionDict.Add(1625, "Error reading the input data from the module with HWID: 'HwID_ToolResult_20'!"                  );
                    errorDescriptionDict.Add(1626, "Error reading the input data from the module with HWID: 'HwID_ToolResult_21'!"                  );
                    errorDescriptionDict.Add(1627, "Error reading the input data from the module with HWID: 'HwID_ToolResult_22'!"                  );
                    errorDescriptionDict.Add(1628, "Error reading the input data from the module with HWID: 'HwID_ToolResult_23'!"                  );
                    errorDescriptionDict.Add(1629, "Error reading the input data from the module with HWID: 'HwID_ToolResult_24'!"                  );
                    errorDescriptionDict.Add(1630, "Error reading the input data from the module with HWID: 'HwID_ToolResult_25'!"                  );
                    errorDescriptionDict.Add(1631, "Error reading the input data from the module with HWID: 'HwID_ToolResult_26'!"                  );
                    errorDescriptionDict.Add(1632, "Error reading the input data from the module with HWID: 'HwID_ToolResult_27'!"                  );
                    errorDescriptionDict.Add(1633, "Error reading the input data from the module with HWID: 'HwID_ToolResult_28'!"                  );
                    errorDescriptionDict.Add(1634, "Error reading the input data from the module with HWID: 'HwID_ToolResult_29'!"                  );
                    errorDescriptionDict.Add(1635, "Error reading the input data from the module with HWID: 'HwID_ToolResult_30'!"                  );
                    errorDescriptionDict.Add(1636, "Error reading the input data from the module with HWID: 'HwID_ToolResult_31'!"                  );
                    errorDescriptionDict.Add(1637, "Error reading the input data from the module with HWID: 'HwID_ToolResult_32'!"                  );
                    errorDescriptionDict.Add(1638, "Error reading the input data from the module with HWID: 'HwID_ToolResult_33'!"                  );
                    errorDescriptionDict.Add(1639, "Error reading the input data from the module with HWID: 'HwID_ToolResult_34'!"                  );
                    errorDescriptionDict.Add(1640, "Error reading the input data from the module with HWID: 'HwID_ToolResult_35'!"                  );
                    errorDescriptionDict.Add(1641, "Error reading the input data from the module with HWID: 'HwID_ToolResult_36'!"                  );
                    errorDescriptionDict.Add(1642, "Error reading the input data from the module with HWID: 'HwID_ToolResult_37'!"                  );
                    errorDescriptionDict.Add(1643, "Error reading the input data from the module with HWID: 'HwID_ToolResult_38'!"                  );
                    errorDescriptionDict.Add(1644, "Error reading the input data from the module with HWID: 'HwID_ToolResult_39'!"                  );
                    errorDescriptionDict.Add(1645, "Error reading the input data from the module with HWID: 'HwID_ToolResult_40'!"                  );
                    errorDescriptionDict.Add(1646, "Error reading the input data from the module with HWID: 'HwID_ToolResult_41'!"                  );
                    errorDescriptionDict.Add(1647, "Error reading the input data from the module with HWID: 'HwID_ToolResult_42'!"                  );
                    errorDescriptionDict.Add(1648, "Error reading the input data from the module with HWID: 'HwID_ToolResult_43'!"                  );
                    errorDescriptionDict.Add(1649, "Error reading the input data from the module with HWID: 'HwID_ToolResult_44'!"                  );
                    errorDescriptionDict.Add(1650, "Error reading the input data from the module with HWID: 'HwID_ToolResult_45'!"                  );
                    errorDescriptionDict.Add(1651, "Error reading the input data from the module with HWID: 'HwID_ToolResult_46'!"                  );
                    errorDescriptionDict.Add(1652, "Error reading the input data from the module with HWID: 'HwID_ToolResult_47'!"                  );
                    errorDescriptionDict.Add(1653, "Error reading the input data from the module with HWID: 'HwID_ToolResult_48'!"                  );
                    errorDescriptionDict.Add(1654, "Error reading the input data from the module with HWID: 'HwID_ToolResult_49'!"                  );
                    errorDescriptionDict.Add(1655, "Error reading the input data from the module with HWID: 'HwID_ToolResult_50'!"                  );
                    errorDescriptionDict.Add(1656, "Error reading the input data from the module with HWID: 'HwID_ToolResult_51'!"                  );
                    errorDescriptionDict.Add(1657, "Error reading the input data from the module with HWID: 'HwID_ToolResult_52'!"                  );
                    errorDescriptionDict.Add(1658, "Error reading the input data from the module with HWID: 'HwID_ToolResult_53'!"                  );
                    errorDescriptionDict.Add(1659, "Error reading the input data from the module with HWID: 'HwID_ToolResult_54'!"                  );
                    errorDescriptionDict.Add(1660, "Error reading the input data from the module with HWID: 'HwID_ToolResult_55'!"                  );
                    errorDescriptionDict.Add(1661, "Error reading the input data from the module with HWID: 'HwID_ToolResult_56'!"                  );
                    errorDescriptionDict.Add(1662, "Error reading the input data from the module with HWID: 'HwID_ToolResult_57'!"                  );
                    errorDescriptionDict.Add(1663, "Error reading the input data from the module with HWID: 'HwID_ToolResult_58'!"                  );
                    errorDescriptionDict.Add(1664, "Error reading the input data from the module with HWID: 'HwID_ToolResult_59'!"                  );
                    errorDescriptionDict.Add(1665, "Error reading the input data from the module with HWID: 'HwID_ToolResult_60'!"                  );
                    errorDescriptionDict.Add(1666, "Error reading the input data from the module with HWID: 'HwID_ToolResult_61'!"                  );
                    errorDescriptionDict.Add(1667, "Error reading the input data from the module with HWID: 'HwID_ToolResult_62'!"                  );
                    errorDescriptionDict.Add(1668, "Error reading the input data from the module with HWID: 'HwID_ToolResult_63'!"                  );
                    errorDescriptionDict.Add(1669, "Error reading the input data from the module with HWID: 'HwID_ToolResult_64'!"                  );
                    errorDescriptionDict.Add(1670, "Error reading the input data from the module with HWID: 'HwID_DeviceResultBits_2'!"             );
                    errorDescriptionDict.Add(1701, "Error writing the output data to the module with HWID: 'HwID_CommandControl'!"                  );
                    errorDescriptionDict.Add(1801, "Program 1 corruption error"                                                                     );
                    errorDescriptionDict.Add(1802, "Program 2 corruption error"                                                                     );
                    errorDescriptionDict.Add(1803, "Program 3 corruption error"                                                                     );
                    errorDescriptionDict.Add(1804, "Program 4 corruption error"                                                                     );
                    errorDescriptionDict.Add(1805, "Program 5 corruption error"                                                                     );
                    errorDescriptionDict.Add(1806, "Program 6 corruption error"                                                                     );
                    errorDescriptionDict.Add(1807, "Program 7 corruption error"                                                                     );
                    errorDescriptionDict.Add(1808, "Program 8 corruption error"                                                                     );
                    errorDescriptionDict.Add(1809, "Program 9 corruption error"                                                                     );
                    errorDescriptionDict.Add(1810, "Program 10 corruption error"                                                                    );
                    errorDescriptionDict.Add(1811, "Program 11 corruption error"                                                                    );
                    errorDescriptionDict.Add(1812, "Program 12 corruption error"                                                                    );
                    errorDescriptionDict.Add(1813, "Program 13 corruption error"                                                                    );
                    errorDescriptionDict.Add(1814, "Program 14 corruption error"                                                                    );
                    errorDescriptionDict.Add(1815, "Program 15 corruption error"                                                                    );
                    errorDescriptionDict.Add(1816, "Program 16 corruption error"                                                                    );
                    errorDescriptionDict.Add(1817, "Program 17 corruption error"                                                                    );
                    errorDescriptionDict.Add(1818, "Program 18 corruption error"                                                                    );
                    errorDescriptionDict.Add(1819, "Program 19 corruption error"                                                                    );
                    errorDescriptionDict.Add(1820, "Program 20 corruption error"                                                                    );
                    errorDescriptionDict.Add(1821, "Program 21 corruption error"                                                                    );
                    errorDescriptionDict.Add(1822, "Program 22 corruption error"                                                                    );
                    errorDescriptionDict.Add(1823, "Program 23 corruption error"                                                                    );
                    errorDescriptionDict.Add(1824, "Program 24 corruption error"                                                                    );
                    errorDescriptionDict.Add(1825, "Program 25 corruption error"                                                                    );
                    errorDescriptionDict.Add(1826, "Program 26 corruption error"                                                                    );
                    errorDescriptionDict.Add(1827, "Program 27 corruption error"                                                                    );
                    errorDescriptionDict.Add(1828, "Program 28 corruption error"                                                                    );
                    errorDescriptionDict.Add(1829, "Program 29 corruption error"                                                                    );
                    errorDescriptionDict.Add(1830, "Program 30 corruption error"                                                                    );
                    errorDescriptionDict.Add(1831, "Program 31 corruption error"                                                                    );
                    errorDescriptionDict.Add(1832, "Program 32 corruption error"                                                                    );
                    errorDescriptionDict.Add(1852, "Program switching error (on startup;external input)"                                            );
                    errorDescriptionDict.Add(1853, "Program switching error (on startup;Panel/PC/Network/Automatic Switching)"                      );
                    errorDescriptionDict.Add(1855, "Program switching error (in [RUN] status)"                                                      );
                    errorDescriptionDict.Add(1879, "System error"                                                                                   );
                    errorDescriptionDict.Add(1895, "System error"                                                                                   );
                    errorDescriptionDict.Add(1896, "System error"                                                                                   );
                    errorDescriptionDict.Add(1897, "Non-volatile memory error"                                                                      );
                    errorDescriptionDict.Add(1898, "Non-volatile memory error"                                                                      );
                    errorDescriptionDict.Add(1899, "Non-volatile memory error"                                                                      );
                    errorDescriptionDict.Add(1900, "System error"                                                                                   );
                    errorDescriptionDict.Add(1901, "System error"                                                                                   );
                    errorDescriptionDict.Add(1902, "System error"                                                                                   );
                    errorDescriptionDict.Add(1903, "System error"                                                                                   );
                    errorDescriptionDict.Add(1904, "System error"                                                                                   );
                    errorDescriptionDict.Add(1905, "System error"                                                                                   );
                    errorDescriptionDict.Add(1906, "System error"                                                                                   );
                    errorDescriptionDict.Add(1907, "System error"                                                                                   );
                    errorDescriptionDict.Add(1908, "System error"                                                                                   );
                    errorDescriptionDict.Add(1909, "System error"                                                                                   );
                    errorDescriptionDict.Add(1910, "System error"                                                                                   );
                    errorDescriptionDict.Add(1911, "System error"                                                                                   );
                    errorDescriptionDict.Add(1912, "System error"                                                                                   );
                    errorDescriptionDict.Add(1913, "System error"                                                                                   );
                    errorDescriptionDict.Add(1914, "System error"                                                                                   );
                    errorDescriptionDict.Add(1915, "System error"                                                                                   );
                    errorDescriptionDict.Add(1916, "System error"                                                                                   );
                    errorDescriptionDict.Add(1917, "System error"                                                                                   );
                    errorDescriptionDict.Add(1918, "System error"                                                                                   );
                    errorDescriptionDict.Add(1919, "System error"                                                                                   );
                    errorDescriptionDict.Add(1920, "System error"                                                                                   );
                    errorDescriptionDict.Add(1921, "System error"                                                                                   );
                    errorDescriptionDict.Add(1922, "System error"                                                                                   );
                    errorDescriptionDict.Add(1923, "System error"                                                                                   );
                    errorDescriptionDict.Add(1924, "System error"                                                                                   );
                    errorDescriptionDict.Add(1925, "System error"                                                                                   );
                    errorDescriptionDict.Add(1926, "System error"                                                                                   );
                    errorDescriptionDict.Add(1927, "System error"                                                                                   );
                    errorDescriptionDict.Add(1928, "System error"                                                                                   );
                    // TriggerTask                                                                                                                                           );
                    errorDescriptionDict.Add(10000, "TriggerTask finished with error!");
                    errorDescriptionDict.Add(10001, "TriggerTask was aborted, while not yet completed!");
                    // ChangeProgramTask
                    errorDescriptionDict.Add(10010, "ChangeProgramTask finished with error!");
                    errorDescriptionDict.Add(10011, "ChangeProgramTask was aborted, while not yet completed!");
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
                    // TriggerTask
                    actionDescriptionDict.Add(100, "TriggerTask started.");
                    actionDescriptionDict.Add(300, "TriggerTask running, waiting for the raising of the 'TriggerReady' signal.");
                    actionDescriptionDict.Add(301, "TriggerTask running, waiting for the raising of the 'TriggerResponse' signal.");
                    actionDescriptionDict.Add(302, "TriggerTask running, waiting for the raising of the 'BUSY' signal.");
                    actionDescriptionDict.Add(303, "TriggerTask running, waiting for the raising of the 'ImagingStatus' signal.");
                    actionDescriptionDict.Add(304, "TriggerTask running, waiting for the falling of the 'BUSY' signal.");
                    actionDescriptionDict.Add(305, "TriggerTask running, waiting for the change of the 'ResultUpdateComplete' signal.");
                    actionDescriptionDict.Add(306, "TriggerTask running, waiting for the raising of the 'ResultAvailable' signal.");
                    actionDescriptionDict.Add(307, "TriggerTask running, waiting for the incrementation of the 'ResultNo' signal.");
                    actionDescriptionDict.Add(308, "TriggerTask finished.");
                    actionDescriptionDict.Add(101, "TriggerTask finished succesfully.");
                    actionDescriptionDict.Add(102, "TriggerTask restored.");
                    // ChangeProgramTask
                    actionDescriptionDict.Add(110, "ChangeProgramTask started.");
                    actionDescriptionDict.Add(310, "ChangeProgramTask running: checking the program number.");
                    actionDescriptionDict.Add(311, "ChangeProgramTask running: setting the program number.");
                    actionDescriptionDict.Add(312, "ChangeProgramTask running: waiting for the raising of the 'ProgramSwitchingResponse' signal.");
                    actionDescriptionDict.Add(313, "ChangeProgramTask running: waiting for the falling of the 'ProgramSwitchingResponse' signal.");
                    actionDescriptionDict.Add(314, "ChangeProgramTask finished.");
                    actionDescriptionDict.Add(111, "ChangeProgramTask finished succesfully.");
                    actionDescriptionDict.Add(112, "ChangeProgramTask restored.");
                    // General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    actionDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl is zero.");
                    actionDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    actionDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    actionDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    actionDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    actionDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    actionDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: '101'.");
                    actionDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwID_CommandStatusBits is zero.");
                    actionDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    actionDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    actionDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    actionDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    actionDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    actionDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: '201'.");
                    actionDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceResultBits_1 is zero.");
                    actionDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3.");
                    actionDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3.");
                    actionDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3.");
                    actionDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3.");
                    actionDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3.");
                    actionDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: '202'.");
                    actionDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatusWords is zero.");
                    actionDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4.");
                    actionDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4.");
                    actionDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4.");
                    actionDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4.");
                    actionDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4.");
                    actionDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: '203'.");
                    actionDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatistics is zero.");
                    actionDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5.");
                    actionDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5.");
                    actionDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5.");
                    actionDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5.");
                    actionDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5.");
                    actionDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: '204'.");
                    actionDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDs.HwID_PositionAdjustResult is zero.");
                    actionDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6.");
                    actionDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6.");
                    actionDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6.");
                    actionDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6.");
                    actionDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6.");
                    actionDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: '301'.");
                    actionDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_1 is zero.");
                    actionDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7.");
                    actionDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7.");
                    actionDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7.");
                    actionDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7.");
                    actionDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7.");
                    actionDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: '302'.");
                    actionDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_2 is zero.");
                    actionDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8.");
                    actionDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8.");
                    actionDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8.");
                    actionDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8.");
                    actionDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8.");
                    actionDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: '302'.");
                    actionDescriptionDict.Add(790, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_3 is zero.");
                    actionDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9.");
                    actionDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9.");
                    actionDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9.");
                    actionDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9.");
                    actionDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9.");
                    actionDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: '302'.");
                    actionDescriptionDict.Add(800, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_4 is zero.");
                    actionDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10.");
                    actionDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10.");
                    actionDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10.");
                    actionDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10.");
                    actionDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10.");
                    actionDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: '302'.");
                    actionDescriptionDict.Add(810, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_5 is zero.");
                    actionDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11.");
                    actionDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11.");
                    actionDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11.");
                    actionDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11.");
                    actionDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11.");
                    actionDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: '302'.");
                    actionDescriptionDict.Add(820, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_6 is zero.");
                    actionDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12.");
                    actionDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12.");
                    actionDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12.");
                    actionDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12.");
                    actionDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12.");
                    actionDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: '302'.");
                    actionDescriptionDict.Add(830, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_7 is zero.");
                    actionDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13.");
                    actionDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13.");
                    actionDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13.");
                    actionDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13.");
                    actionDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13.");
                    actionDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: '302'.");
                    actionDescriptionDict.Add(840, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_8 is zero.");
                    actionDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14.");
                    actionDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14.");
                    actionDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14.");
                    actionDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14.");
                    actionDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14.");
                    actionDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 14. Expected module: '302'.");
                    actionDescriptionDict.Add(850, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_9 is zero.");
                    actionDescriptionDict.Add(851, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15.");
                    actionDescriptionDict.Add(852, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15.");
                    actionDescriptionDict.Add(853, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15.");
                    actionDescriptionDict.Add(854, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15.");
                    actionDescriptionDict.Add(855, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15.");
                    actionDescriptionDict.Add(856, "Hw configuration error: Module with unexpected size or type detected in Slot 15. Expected module: '302'.");
                    actionDescriptionDict.Add(860, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_10 is zero.");
                    actionDescriptionDict.Add(861, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16.");
                    actionDescriptionDict.Add(862, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16.");
                    actionDescriptionDict.Add(863, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16.");
                    actionDescriptionDict.Add(864, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16.");
                    actionDescriptionDict.Add(865, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16.");
                    actionDescriptionDict.Add(866, "Hw configuration error: Module with unexpected size or type detected in Slot 16. Expected module: '302'.");
                    actionDescriptionDict.Add(870, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_11 is zero.");
                    actionDescriptionDict.Add(871, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17.");
                    actionDescriptionDict.Add(872, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17.");
                    actionDescriptionDict.Add(873, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17.");
                    actionDescriptionDict.Add(874, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17.");
                    actionDescriptionDict.Add(875, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17.");
                    actionDescriptionDict.Add(876, "Hw configuration error: Module with unexpected size or type detected in Slot 17. Expected module: '302'.");
                    actionDescriptionDict.Add(880, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_12 is zero.");
                    actionDescriptionDict.Add(881, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18.");
                    actionDescriptionDict.Add(882, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18.");
                    actionDescriptionDict.Add(883, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18.");
                    actionDescriptionDict.Add(884, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18.");
                    actionDescriptionDict.Add(885, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18.");
                    actionDescriptionDict.Add(886, "Hw configuration error: Module with unexpected size or type detected in Slot 18. Expected module: '302'.");
                    actionDescriptionDict.Add(890, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_13 is zero.");
                    actionDescriptionDict.Add(891, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19.");
                    actionDescriptionDict.Add(892, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19.");
                    actionDescriptionDict.Add(893, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19.");
                    actionDescriptionDict.Add(894, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19.");
                    actionDescriptionDict.Add(895, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19.");
                    actionDescriptionDict.Add(896, "Hw configuration error: Module with unexpected size or type detected in Slot 19. Expected module: '302'.");
                    actionDescriptionDict.Add(900, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_14 is zero.");
                    actionDescriptionDict.Add(901, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20.");
                    actionDescriptionDict.Add(902, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20.");
                    actionDescriptionDict.Add(903, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20.");
                    actionDescriptionDict.Add(904, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20.");
                    actionDescriptionDict.Add(905, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20.");
                    actionDescriptionDict.Add(906, "Hw configuration error: Module with unexpected size or type detected in Slot 20. Expected module: '302'.");
                    actionDescriptionDict.Add(910, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_15 is zero.");
                    actionDescriptionDict.Add(911, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 21.");
                    actionDescriptionDict.Add(912, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 21.");
                    actionDescriptionDict.Add(913, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 21.");
                    actionDescriptionDict.Add(914, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 21.");
                    actionDescriptionDict.Add(915, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 21.");
                    actionDescriptionDict.Add(916, "Hw configuration error: Module with unexpected size or type detected in Slot 21. Expected module: '302'.");
                    actionDescriptionDict.Add(920, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_16 is zero.");
                    actionDescriptionDict.Add(921, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 22.");
                    actionDescriptionDict.Add(922, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 22.");
                    actionDescriptionDict.Add(923, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 22.");
                    actionDescriptionDict.Add(924, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 22.");
                    actionDescriptionDict.Add(925, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 22.");
                    actionDescriptionDict.Add(926, "Hw configuration error: Module with unexpected size or type detected in Slot 22. Expected module: '302'.");
                    actionDescriptionDict.Add(930, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_17 is zero.");
                    actionDescriptionDict.Add(931, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 23.");
                    actionDescriptionDict.Add(932, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 23.");
                    actionDescriptionDict.Add(933, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 23.");
                    actionDescriptionDict.Add(934, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 23.");
                    actionDescriptionDict.Add(935, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 23.");
                    actionDescriptionDict.Add(936, "Hw configuration error: Module with unexpected size or type detected in Slot 23. Expected module: '302'.");
                    actionDescriptionDict.Add(940, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_18 is zero.");
                    actionDescriptionDict.Add(941, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 24.");
                    actionDescriptionDict.Add(942, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 24.");
                    actionDescriptionDict.Add(943, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 24.");
                    actionDescriptionDict.Add(944, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 24.");
                    actionDescriptionDict.Add(945, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 24.");
                    actionDescriptionDict.Add(946, "Hw configuration error: Module with unexpected size or type detected in Slot 24. Expected module: '302'.");
                    actionDescriptionDict.Add(950, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_19 is zero.");
                    actionDescriptionDict.Add(951, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 25.");
                    actionDescriptionDict.Add(952, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 25.");
                    actionDescriptionDict.Add(953, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 25.");
                    actionDescriptionDict.Add(954, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 25.");
                    actionDescriptionDict.Add(955, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 25.");
                    actionDescriptionDict.Add(956, "Hw configuration error: Module with unexpected size or type detected in Slot 25. Expected module: '302'.");
                    actionDescriptionDict.Add(960, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_20 is zero.");
                    actionDescriptionDict.Add(961, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 26.");
                    actionDescriptionDict.Add(962, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 26.");
                    actionDescriptionDict.Add(963, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 26.");
                    actionDescriptionDict.Add(964, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 26.");
                    actionDescriptionDict.Add(965, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 26.");
                    actionDescriptionDict.Add(966, "Hw configuration error: Module with unexpected size or type detected in Slot 26. Expected module: '302'.");
                    actionDescriptionDict.Add(970, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_21 is zero.");
                    actionDescriptionDict.Add(971, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 27.");
                    actionDescriptionDict.Add(972, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 27.");
                    actionDescriptionDict.Add(973, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 27.");
                    actionDescriptionDict.Add(974, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 27.");
                    actionDescriptionDict.Add(975, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 27.");
                    actionDescriptionDict.Add(976, "Hw configuration error: Module with unexpected size or type detected in Slot 27. Expected module: '302'.");
                    actionDescriptionDict.Add(980, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_22 is zero.");
                    actionDescriptionDict.Add(981, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 28.");
                    actionDescriptionDict.Add(982, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 28.");
                    actionDescriptionDict.Add(983, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 28.");
                    actionDescriptionDict.Add(984, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 28.");
                    actionDescriptionDict.Add(985, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 28.");
                    actionDescriptionDict.Add(986, "Hw configuration error: Module with unexpected size or type detected in Slot 28. Expected module: '302'.");
                    actionDescriptionDict.Add(990, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_23 is zero.");
                    actionDescriptionDict.Add(991, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 29.");
                    actionDescriptionDict.Add(992, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 29.");
                    actionDescriptionDict.Add(993, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 29.");
                    actionDescriptionDict.Add(994, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 29.");
                    actionDescriptionDict.Add(995, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 29.");
                    actionDescriptionDict.Add(996, "Hw configuration error: Module with unexpected size or type detected in Slot 29. Expected module: '302'.");
                    actionDescriptionDict.Add(1000, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_24 is zero.");
                    actionDescriptionDict.Add(1001, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 30.");
                    actionDescriptionDict.Add(1002, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 30.");
                    actionDescriptionDict.Add(1003, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 30.");
                    actionDescriptionDict.Add(1004, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 30.");
                    actionDescriptionDict.Add(1005, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 30.");
                    actionDescriptionDict.Add(1006, "Hw configuration error: Module with unexpected size or type detected in Slot 30. Expected module: '302'.");
                    actionDescriptionDict.Add(1010, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_25 is zero.");
                    actionDescriptionDict.Add(1011, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 31.");
                    actionDescriptionDict.Add(1012, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 31.");
                    actionDescriptionDict.Add(1013, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 31.");
                    actionDescriptionDict.Add(1014, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 31.");
                    actionDescriptionDict.Add(1015, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 31.");
                    actionDescriptionDict.Add(1016, "Hw configuration error: Module with unexpected size or type detected in Slot 31. Expected module: '302'.");
                    actionDescriptionDict.Add(1020, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_26 is zero.");
                    actionDescriptionDict.Add(1021, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 32.");
                    actionDescriptionDict.Add(1022, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 32.");
                    actionDescriptionDict.Add(1023, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 32.");
                    actionDescriptionDict.Add(1024, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 32.");
                    actionDescriptionDict.Add(1025, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 32.");
                    actionDescriptionDict.Add(1026, "Hw configuration error: Module with unexpected size or type detected in Slot 32. Expected module: '302'.");
                    actionDescriptionDict.Add(1030, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_27 is zero.");
                    actionDescriptionDict.Add(1031, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 33.");
                    actionDescriptionDict.Add(1032, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 33.");
                    actionDescriptionDict.Add(1033, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 33.");
                    actionDescriptionDict.Add(1034, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 33.");
                    actionDescriptionDict.Add(1035, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 33.");
                    actionDescriptionDict.Add(1036, "Hw configuration error: Module with unexpected size or type detected in Slot 33. Expected module: '302'.");
                    actionDescriptionDict.Add(1040, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_28 is zero.");
                    actionDescriptionDict.Add(1041, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 34.");
                    actionDescriptionDict.Add(1042, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 34.");
                    actionDescriptionDict.Add(1043, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 34.");
                    actionDescriptionDict.Add(1044, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 34.");
                    actionDescriptionDict.Add(1045, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 34.");
                    actionDescriptionDict.Add(1046, "Hw configuration error: Module with unexpected size or type detected in Slot 34. Expected module: '302'.");
                    actionDescriptionDict.Add(1050, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_29 is zero.");
                    actionDescriptionDict.Add(1051, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 35.");
                    actionDescriptionDict.Add(1052, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 35.");
                    actionDescriptionDict.Add(1053, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 35.");
                    actionDescriptionDict.Add(1054, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 35.");
                    actionDescriptionDict.Add(1055, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 35.");
                    actionDescriptionDict.Add(1056, "Hw configuration error: Module with unexpected size or type detected in Slot 35. Expected module: '302'.");
                    actionDescriptionDict.Add(1060, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_30 is zero.");
                    actionDescriptionDict.Add(1061, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 36.");
                    actionDescriptionDict.Add(1062, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 36.");
                    actionDescriptionDict.Add(1063, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 36.");
                    actionDescriptionDict.Add(1064, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 36.");
                    actionDescriptionDict.Add(1065, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 36.");
                    actionDescriptionDict.Add(1066, "Hw configuration error: Module with unexpected size or type detected in Slot 36. Expected module: '302'.");
                    actionDescriptionDict.Add(1070, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_31 is zero.");
                    actionDescriptionDict.Add(1071, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 37.");
                    actionDescriptionDict.Add(1072, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 37.");
                    actionDescriptionDict.Add(1073, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 37.");
                    actionDescriptionDict.Add(1074, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 37.");
                    actionDescriptionDict.Add(1075, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 37.");
                    actionDescriptionDict.Add(1076, "Hw configuration error: Module with unexpected size or type detected in Slot 37. Expected module: '302'.");
                    actionDescriptionDict.Add(1080, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_32 is zero.");
                    actionDescriptionDict.Add(1081, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 38.");
                    actionDescriptionDict.Add(1082, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 38.");
                    actionDescriptionDict.Add(1083, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 38.");
                    actionDescriptionDict.Add(1084, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 38.");
                    actionDescriptionDict.Add(1085, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 38.");
                    actionDescriptionDict.Add(1086, "Hw configuration error: Module with unexpected size or type detected in Slot 38. Expected module: '302'.");
                    actionDescriptionDict.Add(1090, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_33 is zero.");
                    actionDescriptionDict.Add(1091, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 39.");
                    actionDescriptionDict.Add(1092, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 39.");
                    actionDescriptionDict.Add(1093, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 39.");
                    actionDescriptionDict.Add(1094, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 39.");
                    actionDescriptionDict.Add(1095, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 39.");
                    actionDescriptionDict.Add(1096, "Hw configuration error: Module with unexpected size or type detected in Slot 39. Expected module: '302'.");
                    actionDescriptionDict.Add(1100, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_34 is zero.");
                    actionDescriptionDict.Add(1101, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 40.");
                    actionDescriptionDict.Add(1102, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 40.");
                    actionDescriptionDict.Add(1103, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 40.");
                    actionDescriptionDict.Add(1104, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 40.");
                    actionDescriptionDict.Add(1105, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 40.");
                    actionDescriptionDict.Add(1106, "Hw configuration error: Module with unexpected size or type detected in Slot 40. Expected module: '302'.");
                    actionDescriptionDict.Add(1110, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_35 is zero.");
                    actionDescriptionDict.Add(1111, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 41.");
                    actionDescriptionDict.Add(1112, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 41.");
                    actionDescriptionDict.Add(1113, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 41.");
                    actionDescriptionDict.Add(1114, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 41.");
                    actionDescriptionDict.Add(1115, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 41.");
                    actionDescriptionDict.Add(1116, "Hw configuration error: Module with unexpected size or type detected in Slot 41. Expected module: '302'.");
                    actionDescriptionDict.Add(1120, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_36 is zero.");
                    actionDescriptionDict.Add(1121, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 42.");
                    actionDescriptionDict.Add(1122, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 42.");
                    actionDescriptionDict.Add(1123, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 42.");
                    actionDescriptionDict.Add(1124, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 42.");
                    actionDescriptionDict.Add(1125, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 42.");
                    actionDescriptionDict.Add(1126, "Hw configuration error: Module with unexpected size or type detected in Slot 42. Expected module: '302'.");
                    actionDescriptionDict.Add(1130, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_37 is zero.");
                    actionDescriptionDict.Add(1131, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 43.");
                    actionDescriptionDict.Add(1132, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 43.");
                    actionDescriptionDict.Add(1133, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 43.");
                    actionDescriptionDict.Add(1134, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 43.");
                    actionDescriptionDict.Add(1135, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 43.");
                    actionDescriptionDict.Add(1136, "Hw configuration error: Module with unexpected size or type detected in Slot 43. Expected module: '302'.");
                    actionDescriptionDict.Add(1140, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_38 is zero.");
                    actionDescriptionDict.Add(1141, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 44.");
                    actionDescriptionDict.Add(1142, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 44.");
                    actionDescriptionDict.Add(1143, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 44.");
                    actionDescriptionDict.Add(1144, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 44.");
                    actionDescriptionDict.Add(1145, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 44.");
                    actionDescriptionDict.Add(1146, "Hw configuration error: Module with unexpected size or type detected in Slot 44. Expected module: '302'.");
                    actionDescriptionDict.Add(1150, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_39 is zero.");
                    actionDescriptionDict.Add(1151, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 45.");
                    actionDescriptionDict.Add(1152, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 45.");
                    actionDescriptionDict.Add(1153, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 45.");
                    actionDescriptionDict.Add(1154, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 45.");
                    actionDescriptionDict.Add(1155, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 45.");
                    actionDescriptionDict.Add(1156, "Hw configuration error: Module with unexpected size or type detected in Slot 45. Expected module: '302'.");
                    actionDescriptionDict.Add(1160, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_40 is zero.");
                    actionDescriptionDict.Add(1161, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 46.");
                    actionDescriptionDict.Add(1162, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 46.");
                    actionDescriptionDict.Add(1163, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 46.");
                    actionDescriptionDict.Add(1164, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 46.");
                    actionDescriptionDict.Add(1165, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 46.");
                    actionDescriptionDict.Add(1166, "Hw configuration error: Module with unexpected size or type detected in Slot 46. Expected module: '302'.");
                    actionDescriptionDict.Add(1170, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_41 is zero.");
                    actionDescriptionDict.Add(1171, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 47.");
                    actionDescriptionDict.Add(1172, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 47.");
                    actionDescriptionDict.Add(1173, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 47.");
                    actionDescriptionDict.Add(1174, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 47.");
                    actionDescriptionDict.Add(1175, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 47.");
                    actionDescriptionDict.Add(1176, "Hw configuration error: Module with unexpected size or type detected in Slot 47. Expected module: '302'.");
                    actionDescriptionDict.Add(1180, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_42 is zero.");
                    actionDescriptionDict.Add(1181, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 48.");
                    actionDescriptionDict.Add(1182, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 48.");
                    actionDescriptionDict.Add(1183, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 48.");
                    actionDescriptionDict.Add(1184, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 48.");
                    actionDescriptionDict.Add(1185, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 48.");
                    actionDescriptionDict.Add(1186, "Hw configuration error: Module with unexpected size or type detected in Slot 48. Expected module: '302'.");
                    actionDescriptionDict.Add(1190, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_43 is zero.");
                    actionDescriptionDict.Add(1191, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 49.");
                    actionDescriptionDict.Add(1192, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 49.");
                    actionDescriptionDict.Add(1193, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 49.");
                    actionDescriptionDict.Add(1194, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 49.");
                    actionDescriptionDict.Add(1195, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 49.");
                    actionDescriptionDict.Add(1196, "Hw configuration error: Module with unexpected size or type detected in Slot 49. Expected module: '302'.");
                    actionDescriptionDict.Add(1200, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_44 is zero.");
                    actionDescriptionDict.Add(1201, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 50.");
                    actionDescriptionDict.Add(1202, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 50.");
                    actionDescriptionDict.Add(1203, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 50.");
                    actionDescriptionDict.Add(1204, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 50.");
                    actionDescriptionDict.Add(1205, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 50.");
                    actionDescriptionDict.Add(1206, "Hw configuration error: Module with unexpected size or type detected in Slot 50. Expected module: '302'.");
                    actionDescriptionDict.Add(1210, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_45 is zero.");
                    actionDescriptionDict.Add(1211, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 51.");
                    actionDescriptionDict.Add(1212, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 51.");
                    actionDescriptionDict.Add(1213, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 51.");
                    actionDescriptionDict.Add(1214, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 51.");
                    actionDescriptionDict.Add(1215, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 51.");
                    actionDescriptionDict.Add(1216, "Hw configuration error: Module with unexpected size or type detected in Slot 51. Expected module: '302'.");
                    actionDescriptionDict.Add(1220, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_46 is zero.");
                    actionDescriptionDict.Add(1221, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 52.");
                    actionDescriptionDict.Add(1222, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 52.");
                    actionDescriptionDict.Add(1223, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 52.");
                    actionDescriptionDict.Add(1224, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 52.");
                    actionDescriptionDict.Add(1225, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 52.");
                    actionDescriptionDict.Add(1226, "Hw configuration error: Module with unexpected size or type detected in Slot 52. Expected module: '302'.");
                    actionDescriptionDict.Add(1230, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_47 is zero.");
                    actionDescriptionDict.Add(1231, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 53.");
                    actionDescriptionDict.Add(1232, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 53.");
                    actionDescriptionDict.Add(1233, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 53.");
                    actionDescriptionDict.Add(1234, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 53.");
                    actionDescriptionDict.Add(1235, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 53.");
                    actionDescriptionDict.Add(1236, "Hw configuration error: Module with unexpected size or type detected in Slot 53. Expected module: '302'.");
                    actionDescriptionDict.Add(1240, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_48 is zero.");
                    actionDescriptionDict.Add(1241, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 54.");
                    actionDescriptionDict.Add(1242, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 54.");
                    actionDescriptionDict.Add(1243, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 54.");
                    actionDescriptionDict.Add(1244, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 54.");
                    actionDescriptionDict.Add(1245, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 54.");
                    actionDescriptionDict.Add(1246, "Hw configuration error: Module with unexpected size or type detected in Slot 54. Expected module: '302'.");
                    actionDescriptionDict.Add(1250, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_49 is zero.");
                    actionDescriptionDict.Add(1251, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 55.");
                    actionDescriptionDict.Add(1252, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 55.");
                    actionDescriptionDict.Add(1253, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 55.");
                    actionDescriptionDict.Add(1254, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 55.");
                    actionDescriptionDict.Add(1255, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 55.");
                    actionDescriptionDict.Add(1256, "Hw configuration error: Module with unexpected size or type detected in Slot 55. Expected module: '302'.");
                    actionDescriptionDict.Add(1260, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_50 is zero.");
                    actionDescriptionDict.Add(1261, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 56.");
                    actionDescriptionDict.Add(1262, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 56.");
                    actionDescriptionDict.Add(1263, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 56.");
                    actionDescriptionDict.Add(1264, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 56.");
                    actionDescriptionDict.Add(1265, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 56.");
                    actionDescriptionDict.Add(1266, "Hw configuration error: Module with unexpected size or type detected in Slot 56. Expected module: '302'.");
                    actionDescriptionDict.Add(1270, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_51 is zero.");
                    actionDescriptionDict.Add(1271, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 57.");
                    actionDescriptionDict.Add(1272, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 57.");
                    actionDescriptionDict.Add(1273, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 57.");
                    actionDescriptionDict.Add(1274, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 57.");
                    actionDescriptionDict.Add(1275, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 57.");
                    actionDescriptionDict.Add(1276, "Hw configuration error: Module with unexpected size or type detected in Slot 57. Expected module: '302'.");
                    actionDescriptionDict.Add(1280, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_52 is zero.");
                    actionDescriptionDict.Add(1281, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 58.");
                    actionDescriptionDict.Add(1282, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 58.");
                    actionDescriptionDict.Add(1283, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 58.");
                    actionDescriptionDict.Add(1284, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 58.");
                    actionDescriptionDict.Add(1285, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 58.");
                    actionDescriptionDict.Add(1286, "Hw configuration error: Module with unexpected size or type detected in Slot 58. Expected module: '302'.");
                    actionDescriptionDict.Add(1290, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_53 is zero.");
                    actionDescriptionDict.Add(1291, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 59.");
                    actionDescriptionDict.Add(1292, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 59.");
                    actionDescriptionDict.Add(1293, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 59.");
                    actionDescriptionDict.Add(1294, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 59.");
                    actionDescriptionDict.Add(1295, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 59.");
                    actionDescriptionDict.Add(1296, "Hw configuration error: Module with unexpected size or type detected in Slot 59. Expected module: '302'.");
                    actionDescriptionDict.Add(1300, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_54 is zero.");
                    actionDescriptionDict.Add(1301, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 60.");
                    actionDescriptionDict.Add(1302, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 60.");
                    actionDescriptionDict.Add(1303, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 60.");
                    actionDescriptionDict.Add(1304, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 60.");
                    actionDescriptionDict.Add(1305, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 60.");
                    actionDescriptionDict.Add(1306, "Hw configuration error: Module with unexpected size or type detected in Slot 60. Expected module: '302'.");
                    actionDescriptionDict.Add(1310, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_55 is zero.");
                    actionDescriptionDict.Add(1311, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 61.");
                    actionDescriptionDict.Add(1312, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 61.");
                    actionDescriptionDict.Add(1313, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 61.");
                    actionDescriptionDict.Add(1314, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 61.");
                    actionDescriptionDict.Add(1315, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 61.");
                    actionDescriptionDict.Add(1316, "Hw configuration error: Module with unexpected size or type detected in Slot 61. Expected module: '302'.");
                    actionDescriptionDict.Add(1320, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_56 is zero.");
                    actionDescriptionDict.Add(1321, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 62.");
                    actionDescriptionDict.Add(1322, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 62.");
                    actionDescriptionDict.Add(1323, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 62.");
                    actionDescriptionDict.Add(1324, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 62.");
                    actionDescriptionDict.Add(1325, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 62.");
                    actionDescriptionDict.Add(1326, "Hw configuration error: Module with unexpected size or type detected in Slot 62. Expected module: '302'.");
                    actionDescriptionDict.Add(1330, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_57 is zero.");
                    actionDescriptionDict.Add(1331, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 63.");
                    actionDescriptionDict.Add(1332, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 63.");
                    actionDescriptionDict.Add(1333, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 63.");
                    actionDescriptionDict.Add(1334, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 63.");
                    actionDescriptionDict.Add(1335, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 63.");
                    actionDescriptionDict.Add(1336, "Hw configuration error: Module with unexpected size or type detected in Slot 63. Expected module: '302'.");
                    actionDescriptionDict.Add(1340, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_58 is zero.");
                    actionDescriptionDict.Add(1341, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 64.");
                    actionDescriptionDict.Add(1342, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 64.");
                    actionDescriptionDict.Add(1343, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 64.");
                    actionDescriptionDict.Add(1344, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 64.");
                    actionDescriptionDict.Add(1345, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 64.");
                    actionDescriptionDict.Add(1346, "Hw configuration error: Module with unexpected size or type detected in Slot 64. Expected module: '302'.");
                    actionDescriptionDict.Add(1350, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_59 is zero.");
                    actionDescriptionDict.Add(1351, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 65.");
                    actionDescriptionDict.Add(1352, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 65.");
                    actionDescriptionDict.Add(1353, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 65.");
                    actionDescriptionDict.Add(1354, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 65.");
                    actionDescriptionDict.Add(1355, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 65.");
                    actionDescriptionDict.Add(1356, "Hw configuration error: Module with unexpected size or type detected in Slot 65. Expected module: '302'.");
                    actionDescriptionDict.Add(1360, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_60 is zero.");
                    actionDescriptionDict.Add(1361, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 66.");
                    actionDescriptionDict.Add(1362, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 66.");
                    actionDescriptionDict.Add(1363, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 66.");
                    actionDescriptionDict.Add(1364, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 66.");
                    actionDescriptionDict.Add(1365, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 66.");
                    actionDescriptionDict.Add(1366, "Hw configuration error: Module with unexpected size or type detected in Slot 66. Expected module: '302'.");
                    actionDescriptionDict.Add(1370, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_61 is zero.");
                    actionDescriptionDict.Add(1371, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 67.");
                    actionDescriptionDict.Add(1372, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 67.");
                    actionDescriptionDict.Add(1373, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 67.");
                    actionDescriptionDict.Add(1374, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 67.");
                    actionDescriptionDict.Add(1375, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 67.");
                    actionDescriptionDict.Add(1376, "Hw configuration error: Module with unexpected size or type detected in Slot 67. Expected module: '302'.");
                    actionDescriptionDict.Add(1380, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_62 is zero.");
                    actionDescriptionDict.Add(1381, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 68.");
                    actionDescriptionDict.Add(1382, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 68.");
                    actionDescriptionDict.Add(1383, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 68.");
                    actionDescriptionDict.Add(1384, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 68.");
                    actionDescriptionDict.Add(1385, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 68.");
                    actionDescriptionDict.Add(1386, "Hw configuration error: Module with unexpected size or type detected in Slot 68. Expected module: '302'.");
                    actionDescriptionDict.Add(1390, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_63 is zero.");
                    actionDescriptionDict.Add(1391, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 69.");
                    actionDescriptionDict.Add(1392, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 69.");
                    actionDescriptionDict.Add(1393, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 69.");
                    actionDescriptionDict.Add(1394, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 69.");
                    actionDescriptionDict.Add(1395, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 69.");
                    actionDescriptionDict.Add(1396, "Hw configuration error: Module with unexpected size or type detected in Slot 69. Expected module: '302'.");
                    actionDescriptionDict.Add(1400, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_64 is zero.");
                    actionDescriptionDict.Add(1401, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 70.");
                    actionDescriptionDict.Add(1402, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 70.");
                    actionDescriptionDict.Add(1403, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 70.");
                    actionDescriptionDict.Add(1404, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 70.");
                    actionDescriptionDict.Add(1405, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 70.");
                    actionDescriptionDict.Add(1406, "Hw configuration error: Module with unexpected size or type detected in Slot 70. Expected module: '302'.");
                    actionDescriptionDict.Add(1410, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceResultBits_2 is zero.");
                    actionDescriptionDict.Add(1411, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 71.");
                    actionDescriptionDict.Add(1412, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 71.");
                    actionDescriptionDict.Add(1413, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 71.");
                    actionDescriptionDict.Add(1414, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 71.");
                    actionDescriptionDict.Add(1415, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 71.");
                    actionDescriptionDict.Add(1416, "Hw configuration error: Module with unexpected size or type detected in Slot 71. Expected module: '401'.");
                    actionDescriptionDict.Add(1500, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(1501, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1502, "Variable `Config.HWIDs.HwID_CommandControl` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1503, "Variable `Config.HWIDs.HwID_CommandStatusBits` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1504, "Variable `Config.HWIDs.HwID_DeviceResultBits_1` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1505, "Variable `Config.HWIDs.HwID_DeviceStatusWords` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1506, "Variable `Config.HWIDs.HwID_DeviceStatistics` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1507, "Variable `Config.HWIDs.HwID_PositionAdjustResult` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1508, "Variable `Config.HWIDs.HwID_ToolResult_1` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1509, "Variable `Config.HWIDs.HwID_ToolResult_2` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1510, "Variable `Config.HWIDs.HwID_ToolResult_3` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1511, "Variable `Config.HWIDs.HwID_ToolResult_4` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1512, "Variable `Config.HWIDs.HwID_ToolResult_5` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1513, "Variable `Config.HWIDs.HwID_ToolResult_6` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1514, "Variable `Config.HWIDs.HwID_ToolResult_7` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1515, "Variable `Config.HWIDs.HwID_ToolResult_8` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1516, "Variable `Config.HWIDs.HwID_ToolResult_9` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1517, "Variable `Config.HWIDs.HwID_ToolResult_10` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1518, "Variable `Config.HWIDs.HwID_ToolResult_11` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1519, "Variable `Config.HWIDs.HwID_ToolResult_12` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1520, "Variable `Config.HWIDs.HwID_ToolResult_13` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1521, "Variable `Config.HWIDs.HwID_ToolResult_14` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1522, "Variable `Config.HWIDs.HwID_ToolResult_15` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1523, "Variable `Config.HWIDs.HwID_ToolResult_16` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1524, "Variable `Config.HWIDs.HwID_ToolResult_17` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1525, "Variable `Config.HWIDs.HwID_ToolResult_18` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1526, "Variable `Config.HWIDs.HwID_ToolResult_19` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1527, "Variable `Config.HWIDs.HwID_ToolResult_20` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1528, "Variable `Config.HWIDs.HwID_ToolResult_21` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1529, "Variable `Config.HWIDs.HwID_ToolResult_22` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1530, "Variable `Config.HWIDs.HwID_ToolResult_23` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1531, "Variable `Config.HWIDs.HwID_ToolResult_24` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1532, "Variable `Config.HWIDs.HwID_ToolResult_25` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1533, "Variable `Config.HWIDs.HwID_ToolResult_26` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1534, "Variable `Config.HWIDs.HwID_ToolResult_27` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1535, "Variable `Config.HWIDs.HwID_ToolResult_28` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1536, "Variable `Config.HWIDs.HwID_ToolResult_29` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1537, "Variable `Config.HWIDs.HwID_ToolResult_30` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1538, "Variable `Config.HWIDs.HwID_ToolResult_31` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1539, "Variable `Config.HWIDs.HwID_ToolResult_32` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1540, "Variable `Config.HWIDs.HwID_ToolResult_33` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1541, "Variable `Config.HWIDs.HwID_ToolResult_34` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1542, "Variable `Config.HWIDs.HwID_ToolResult_35` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1543, "Variable `Config.HWIDs.HwID_ToolResult_36` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1544, "Variable `Config.HWIDs.HwID_ToolResult_37` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1545, "Variable `Config.HWIDs.HwID_ToolResult_38` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1546, "Variable `Config.HWIDs.HwID_ToolResult_39` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1547, "Variable `Config.HWIDs.HwID_ToolResult_40` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1548, "Variable `Config.HWIDs.HwID_ToolResult_41` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1549, "Variable `Config.HWIDs.HwID_ToolResult_42` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1550, "Variable `Config.HWIDs.HwID_ToolResult_43` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1551, "Variable `Config.HWIDs.HwID_ToolResult_44` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1552, "Variable `Config.HWIDs.HwID_ToolResult_45` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1553, "Variable `Config.HWIDs.HwID_ToolResult_46` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1554, "Variable `Config.HWIDs.HwID_ToolResult_47` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1555, "Variable `Config.HWIDs.HwID_ToolResult_48` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1556, "Variable `Config.HWIDs.HwID_ToolResult_49` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1557, "Variable `Config.HWIDs.HwID_ToolResult_50` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1558, "Variable `Config.HWIDs.HwID_ToolResult_51` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1559, "Variable `Config.HWIDs.HwID_ToolResult_52` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1560, "Variable `Config.HWIDs.HwID_ToolResult_53` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1561, "Variable `Config.HWIDs.HwID_ToolResult_54` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1562, "Variable `Config.HWIDs.HwID_ToolResult_55` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1563, "Variable `Config.HWIDs.HwID_ToolResult_56` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1564, "Variable `Config.HWIDs.HwID_ToolResult_57` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1565, "Variable `Config.HWIDs.HwID_ToolResult_58` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1566, "Variable `Config.HWIDs.HwID_ToolResult_59` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1567, "Variable `Config.HWIDs.HwID_ToolResult_60` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1568, "Variable `Config.HWIDs.HwID_ToolResult_61` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1569, "Variable `Config.HWIDs.HwID_ToolResult_62` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1570, "Variable `Config.HWIDs.HwID_ToolResult_63` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1571, "Variable `Config.HWIDs.HwID_ToolResult_64` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1572, "Variable `Config.HWIDs.HwID_DeviceResultBits_2` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1601, "Error reading the input data from the module with HWID: 'HwID_CommandStatusBits'!");
                    actionDescriptionDict.Add(1602, "Error reading the input data from the module with HWID: 'HwID_DeviceResultBits_1'!");
                    actionDescriptionDict.Add(1603, "Error reading the input data from the module with HWID: 'HwID_DeviceStatusWords'!");
                    actionDescriptionDict.Add(1604, "Error reading the input data from the module with HWID: 'HwID_DeviceStatistics'!");
                    actionDescriptionDict.Add(1605, "Error reading the input data from the module with HWID: 'HwID_PositionAdjustResult'!");
                    actionDescriptionDict.Add(1606, "Error reading the input data from the module with HWID: 'HwID_ToolResult_1'!");
                    actionDescriptionDict.Add(1607, "Error reading the input data from the module with HWID: 'HwID_ToolResult_2'!");
                    actionDescriptionDict.Add(1608, "Error reading the input data from the module with HWID: 'HwID_ToolResult_3'!");
                    actionDescriptionDict.Add(1609, "Error reading the input data from the module with HWID: 'HwID_ToolResult_4'!");
                    actionDescriptionDict.Add(1610, "Error reading the input data from the module with HWID: 'HwID_ToolResult_5'!");
                    actionDescriptionDict.Add(1611, "Error reading the input data from the module with HWID: 'HwID_ToolResult_6'!");
                    actionDescriptionDict.Add(1612, "Error reading the input data from the module with HWID: 'HwID_ToolResult_7'!");
                    actionDescriptionDict.Add(1613, "Error reading the input data from the module with HWID: 'HwID_ToolResult_8'!");
                    actionDescriptionDict.Add(1614, "Error reading the input data from the module with HWID: 'HwID_ToolResult_9'!");
                    actionDescriptionDict.Add(1615, "Error reading the input data from the module with HWID: 'HwID_ToolResult_10'!");
                    actionDescriptionDict.Add(1616, "Error reading the input data from the module with HWID: 'HwID_ToolResult_11'!");
                    actionDescriptionDict.Add(1617, "Error reading the input data from the module with HWID: 'HwID_ToolResult_12'!");
                    actionDescriptionDict.Add(1618, "Error reading the input data from the module with HWID: 'HwID_ToolResult_13'!");
                    actionDescriptionDict.Add(1619, "Error reading the input data from the module with HWID: 'HwID_ToolResult_14'!");
                    actionDescriptionDict.Add(1620, "Error reading the input data from the module with HWID: 'HwID_ToolResult_15'!");
                    actionDescriptionDict.Add(1621, "Error reading the input data from the module with HWID: 'HwID_ToolResult_16'!");
                    actionDescriptionDict.Add(1622, "Error reading the input data from the module with HWID: 'HwID_ToolResult_17'!");
                    actionDescriptionDict.Add(1623, "Error reading the input data from the module with HWID: 'HwID_ToolResult_18'!");
                    actionDescriptionDict.Add(1624, "Error reading the input data from the module with HWID: 'HwID_ToolResult_19'!");
                    actionDescriptionDict.Add(1625, "Error reading the input data from the module with HWID: 'HwID_ToolResult_20'!");
                    actionDescriptionDict.Add(1626, "Error reading the input data from the module with HWID: 'HwID_ToolResult_21'!");
                    actionDescriptionDict.Add(1627, "Error reading the input data from the module with HWID: 'HwID_ToolResult_22'!");
                    actionDescriptionDict.Add(1628, "Error reading the input data from the module with HWID: 'HwID_ToolResult_23'!");
                    actionDescriptionDict.Add(1629, "Error reading the input data from the module with HWID: 'HwID_ToolResult_24'!");
                    actionDescriptionDict.Add(1630, "Error reading the input data from the module with HWID: 'HwID_ToolResult_25'!");
                    actionDescriptionDict.Add(1631, "Error reading the input data from the module with HWID: 'HwID_ToolResult_26'!");
                    actionDescriptionDict.Add(1632, "Error reading the input data from the module with HWID: 'HwID_ToolResult_27'!");
                    actionDescriptionDict.Add(1633, "Error reading the input data from the module with HWID: 'HwID_ToolResult_28'!");
                    actionDescriptionDict.Add(1634, "Error reading the input data from the module with HWID: 'HwID_ToolResult_29'!");
                    actionDescriptionDict.Add(1635, "Error reading the input data from the module with HWID: 'HwID_ToolResult_30'!");
                    actionDescriptionDict.Add(1636, "Error reading the input data from the module with HWID: 'HwID_ToolResult_31'!");
                    actionDescriptionDict.Add(1637, "Error reading the input data from the module with HWID: 'HwID_ToolResult_32'!");
                    actionDescriptionDict.Add(1638, "Error reading the input data from the module with HWID: 'HwID_ToolResult_33'!");
                    actionDescriptionDict.Add(1639, "Error reading the input data from the module with HWID: 'HwID_ToolResult_34'!");
                    actionDescriptionDict.Add(1640, "Error reading the input data from the module with HWID: 'HwID_ToolResult_35'!");
                    actionDescriptionDict.Add(1641, "Error reading the input data from the module with HWID: 'HwID_ToolResult_36'!");
                    actionDescriptionDict.Add(1642, "Error reading the input data from the module with HWID: 'HwID_ToolResult_37'!");
                    actionDescriptionDict.Add(1643, "Error reading the input data from the module with HWID: 'HwID_ToolResult_38'!");
                    actionDescriptionDict.Add(1644, "Error reading the input data from the module with HWID: 'HwID_ToolResult_39'!");
                    actionDescriptionDict.Add(1645, "Error reading the input data from the module with HWID: 'HwID_ToolResult_40'!");
                    actionDescriptionDict.Add(1646, "Error reading the input data from the module with HWID: 'HwID_ToolResult_41'!");
                    actionDescriptionDict.Add(1647, "Error reading the input data from the module with HWID: 'HwID_ToolResult_42'!");
                    actionDescriptionDict.Add(1648, "Error reading the input data from the module with HWID: 'HwID_ToolResult_43'!");
                    actionDescriptionDict.Add(1649, "Error reading the input data from the module with HWID: 'HwID_ToolResult_44'!");
                    actionDescriptionDict.Add(1650, "Error reading the input data from the module with HWID: 'HwID_ToolResult_45'!");
                    actionDescriptionDict.Add(1651, "Error reading the input data from the module with HWID: 'HwID_ToolResult_46'!");
                    actionDescriptionDict.Add(1652, "Error reading the input data from the module with HWID: 'HwID_ToolResult_47'!");
                    actionDescriptionDict.Add(1653, "Error reading the input data from the module with HWID: 'HwID_ToolResult_48'!");
                    actionDescriptionDict.Add(1654, "Error reading the input data from the module with HWID: 'HwID_ToolResult_49'!");
                    actionDescriptionDict.Add(1655, "Error reading the input data from the module with HWID: 'HwID_ToolResult_50'!");
                    actionDescriptionDict.Add(1656, "Error reading the input data from the module with HWID: 'HwID_ToolResult_51'!");
                    actionDescriptionDict.Add(1657, "Error reading the input data from the module with HWID: 'HwID_ToolResult_52'!");
                    actionDescriptionDict.Add(1658, "Error reading the input data from the module with HWID: 'HwID_ToolResult_53'!");
                    actionDescriptionDict.Add(1659, "Error reading the input data from the module with HWID: 'HwID_ToolResult_54'!");
                    actionDescriptionDict.Add(1660, "Error reading the input data from the module with HWID: 'HwID_ToolResult_55'!");
                    actionDescriptionDict.Add(1661, "Error reading the input data from the module with HWID: 'HwID_ToolResult_56'!");
                    actionDescriptionDict.Add(1662, "Error reading the input data from the module with HWID: 'HwID_ToolResult_57'!");
                    actionDescriptionDict.Add(1663, "Error reading the input data from the module with HWID: 'HwID_ToolResult_58'!");
                    actionDescriptionDict.Add(1664, "Error reading the input data from the module with HWID: 'HwID_ToolResult_59'!");
                    actionDescriptionDict.Add(1665, "Error reading the input data from the module with HWID: 'HwID_ToolResult_60'!");
                    actionDescriptionDict.Add(1666, "Error reading the input data from the module with HWID: 'HwID_ToolResult_61'!");
                    actionDescriptionDict.Add(1667, "Error reading the input data from the module with HWID: 'HwID_ToolResult_62'!");
                    actionDescriptionDict.Add(1668, "Error reading the input data from the module with HWID: 'HwID_ToolResult_63'!");
                    actionDescriptionDict.Add(1669, "Error reading the input data from the module with HWID: 'HwID_ToolResult_64'!");
                    actionDescriptionDict.Add(1670, "Error reading the input data from the module with HWID: 'HwID_DeviceResultBits_2'!");
                    actionDescriptionDict.Add(1701, "Error writing the output data to the module with HWID: 'HwID_CommandControl'!");
                    actionDescriptionDict.Add(1801, "Program 1 corruption error");
                    actionDescriptionDict.Add(1802, "Program 2 corruption error");
                    actionDescriptionDict.Add(1803, "Program 3 corruption error");
                    actionDescriptionDict.Add(1804, "Program 4 corruption error");
                    actionDescriptionDict.Add(1805, "Program 5 corruption error");
                    actionDescriptionDict.Add(1806, "Program 6 corruption error");
                    actionDescriptionDict.Add(1807, "Program 7 corruption error");
                    actionDescriptionDict.Add(1808, "Program 8 corruption error");
                    actionDescriptionDict.Add(1809, "Program 9 corruption error");
                    actionDescriptionDict.Add(1810, "Program 10 corruption error");
                    actionDescriptionDict.Add(1811, "Program 11 corruption error");
                    actionDescriptionDict.Add(1812, "Program 12 corruption error");
                    actionDescriptionDict.Add(1813, "Program 13 corruption error");
                    actionDescriptionDict.Add(1814, "Program 14 corruption error");
                    actionDescriptionDict.Add(1815, "Program 15 corruption error");
                    actionDescriptionDict.Add(1816, "Program 16 corruption error");
                    actionDescriptionDict.Add(1817, "Program 17 corruption error");
                    actionDescriptionDict.Add(1818, "Program 18 corruption error");
                    actionDescriptionDict.Add(1819, "Program 19 corruption error");
                    actionDescriptionDict.Add(1820, "Program 20 corruption error");
                    actionDescriptionDict.Add(1821, "Program 21 corruption error");
                    actionDescriptionDict.Add(1822, "Program 22 corruption error");
                    actionDescriptionDict.Add(1823, "Program 23 corruption error");
                    actionDescriptionDict.Add(1824, "Program 24 corruption error");
                    actionDescriptionDict.Add(1825, "Program 25 corruption error");
                    actionDescriptionDict.Add(1826, "Program 26 corruption error");
                    actionDescriptionDict.Add(1827, "Program 27 corruption error");
                    actionDescriptionDict.Add(1828, "Program 28 corruption error");
                    actionDescriptionDict.Add(1829, "Program 29 corruption error");
                    actionDescriptionDict.Add(1830, "Program 30 corruption error");
                    actionDescriptionDict.Add(1831, "Program 31 corruption error");
                    actionDescriptionDict.Add(1832, "Program 32 corruption error");
                    actionDescriptionDict.Add(1852, "Program switching error (on startup;external input)");
                    actionDescriptionDict.Add(1853, "Program switching error (on startup;Panel/PC/Network/Automatic Switching)");
                    actionDescriptionDict.Add(1855, "Program switching error (in [RUN] status)");
                    actionDescriptionDict.Add(1879, "System error");
                    actionDescriptionDict.Add(1895, "System error");
                    actionDescriptionDict.Add(1896, "System error");
                    actionDescriptionDict.Add(1897, "Non-volatile memory error");
                    actionDescriptionDict.Add(1898, "Non-volatile memory error");
                    actionDescriptionDict.Add(1899, "Non-volatile memory error");
                    actionDescriptionDict.Add(1900, "System error");
                    actionDescriptionDict.Add(1901, "System error");
                    actionDescriptionDict.Add(1902, "System error");
                    actionDescriptionDict.Add(1903, "System error");
                    actionDescriptionDict.Add(1904, "System error");
                    actionDescriptionDict.Add(1905, "System error");
                    actionDescriptionDict.Add(1906, "System error");
                    actionDescriptionDict.Add(1907, "System error");
                    actionDescriptionDict.Add(1908, "System error");
                    actionDescriptionDict.Add(1909, "System error");
                    actionDescriptionDict.Add(1910, "System error");
                    actionDescriptionDict.Add(1911, "System error");
                    actionDescriptionDict.Add(1912, "System error");
                    actionDescriptionDict.Add(1913, "System error");
                    actionDescriptionDict.Add(1914, "System error");
                    actionDescriptionDict.Add(1915, "System error");
                    actionDescriptionDict.Add(1916, "System error");
                    actionDescriptionDict.Add(1917, "System error");
                    actionDescriptionDict.Add(1918, "System error");
                    actionDescriptionDict.Add(1919, "System error");
                    actionDescriptionDict.Add(1920, "System error");
                    actionDescriptionDict.Add(1921, "System error");
                    actionDescriptionDict.Add(1922, "System error");
                    actionDescriptionDict.Add(1923, "System error");
                    actionDescriptionDict.Add(1924, "System error");
                    actionDescriptionDict.Add(1925, "System error");
                    actionDescriptionDict.Add(1926, "System error");
                    actionDescriptionDict.Add(1927, "System error");
                    actionDescriptionDict.Add(1928, "System error");
                    // TriggerTask
                    actionDescriptionDict.Add(10000, "TriggerTask finished with error!");
                    actionDescriptionDict.Add(10001, "TriggerTask was aborted, while not yet completed!");
                    // ChangeProgramTask
                    actionDescriptionDict.Add(10010, "ChangeProgramTask finished with error!");
                    actionDescriptionDict.Add(10011, "ChangeProgramTask was aborted, while not yet completed!");

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
