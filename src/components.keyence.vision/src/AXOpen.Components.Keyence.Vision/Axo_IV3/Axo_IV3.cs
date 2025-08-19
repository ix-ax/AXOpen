using AXOpen.Messaging.Static;
using AXSharp.Connector;
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
                // TemplateTask_10steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("TemplateTask_10steps_1 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("TemplateTask_10steps_1 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("TemplateTask_10steps_1 restored.","")),
                // TemplateTask_10steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("TemplateTask_10steps_2 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("TemplateTask_10steps_2 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("TemplateTask_10steps_2 restored.","")),
                // TemplateTask_10steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("TemplateTask_10steps_3 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("TemplateTask_10steps_3 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("TemplateTask_10steps_3 restored.","")),
                // TemplateTask_10steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(130, new AxoMessengerTextItem("TemplateTask_10steps_4 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(131, new AxoMessengerTextItem("TemplateTask_10steps_4 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(132, new AxoMessengerTextItem("TemplateTask_10steps_4 restored.","")),
                // TemplateTask_10steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("TemplateTask_10steps_5 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("TemplateTask_10steps_5 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("TemplateTask_10steps_5 restored.","")),
                // TemplateTask_10steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("TemplateTask_10steps_6 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("TemplateTask_10steps_6 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("TemplateTask_10steps_6 restored.","")),
                // TemplateTask_20steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(160, new AxoMessengerTextItem("TemplateTask_20steps_1 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(161, new AxoMessengerTextItem("TemplateTask_20steps_1 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(162, new AxoMessengerTextItem("TemplateTask_20steps_1 restored.","")),
                // TemplateTask_20steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(180, new AxoMessengerTextItem("TemplateTask_20steps_2 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(181, new AxoMessengerTextItem("TemplateTask_20steps_2 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(182, new AxoMessengerTextItem("TemplateTask_20steps_2 restored.","")),
                // TemplateTask_20steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(200, new AxoMessengerTextItem("TemplateTask_20steps_3 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(201, new AxoMessengerTextItem("TemplateTask_20steps_3 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(202, new AxoMessengerTextItem("TemplateTask_20steps_3 restored.","")),
                // TemplateTask_20steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(220, new AxoMessengerTextItem("TemplateTask_20steps_4 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(221, new AxoMessengerTextItem("TemplateTask_20steps_4 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(222, new AxoMessengerTextItem("TemplateTask_20steps_4 restored.","")),
                // TemplateTask_20steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(240, new AxoMessengerTextItem("TemplateTask_20steps_5 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(241, new AxoMessengerTextItem("TemplateTask_20steps_5 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(242, new AxoMessengerTextItem("TemplateTask_20steps_5 restored.","")),
                // TemplateTask_20steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(260, new AxoMessengerTextItem("TemplateTask_20steps_6 started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(261, new AxoMessengerTextItem("TemplateTask_20steps_6 finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(262, new AxoMessengerTextItem("TemplateTask_20steps_6 restored.","")),
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
                

                // TemplateTask_10steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("TemplateTask_10steps_1 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("TemplateTask_10steps_1 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("TemplateTask_10steps_2 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("TemplateTask_10steps_2 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("TemplateTask_10steps_3 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("TemplateTask_10steps_3 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(10030, new AxoMessengerTextItem("TemplateTask_10steps_4 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10031, new AxoMessengerTextItem("TemplateTask_10steps_4 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem("TemplateTask_10steps_5 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem("TemplateTask_10steps_5 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(10050, new AxoMessengerTextItem("TemplateTask_10steps_6 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10051, new AxoMessengerTextItem("TemplateTask_10steps_6 task was aborted, while not yet completed!","Check the details.")),

                // TemplateTask_20steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(10060, new AxoMessengerTextItem("TemplateTask_20steps_1 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10061, new AxoMessengerTextItem("TemplateTask_20steps_1 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(10080, new AxoMessengerTextItem("TemplateTask_20steps_2 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10081, new AxoMessengerTextItem("TemplateTask_20steps_2 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(10100, new AxoMessengerTextItem("TemplateTask_20steps_3 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10101, new AxoMessengerTextItem("TemplateTask_20steps_3 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(10120, new AxoMessengerTextItem("TemplateTask_20steps_4 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10121, new AxoMessengerTextItem("TemplateTask_20steps_4 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(10140, new AxoMessengerTextItem("TemplateTask_20steps_5 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10141, new AxoMessengerTextItem("TemplateTask_20steps_5 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(10160, new AxoMessengerTextItem("TemplateTask_20steps_6 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10161, new AxoMessengerTextItem("TemplateTask_20steps_6 task was aborted, while not yet completed!","Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                // TemplateTask_10steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(505,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(506,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(507,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(508,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(509,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                // TemplateTask_10steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(518,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(519,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                // TemplateTask_10steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(525,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(527,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(528,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(529,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_10steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(537,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(538,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(539,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_10steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(547,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_10steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(553,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(554,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(555,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(556,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(557,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(558,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(559,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(561,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(563,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(564,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(565,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(566,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(567,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(568,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(569,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(572,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(573,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(574,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(575,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(576,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(577,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(578,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(579,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(581,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(582,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(583,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(584,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(585,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(586,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(587,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(588,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(589,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(592,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(593,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(594,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(595,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(596,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(597,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(598,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(599,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(605,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(606,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(607,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(608,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(609,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(616,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(617,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(618,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(619,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(623,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(624,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(625,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(626,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(627,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(628,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(629,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(633,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(634,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(635,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(636,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(637,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(638,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(639,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(640,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(641,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(642,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(643,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(644,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(645,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(646,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(647,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(648,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(649,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(650,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(651,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(652,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(653,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(654,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(655,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(656,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(657,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(658,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(659,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //TemplateTask_20steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(660,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(661,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(662,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(663,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(664,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(665,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(666,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(667,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(668,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(669,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(670,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(671,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(672,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(673,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(674,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(675,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(676,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(677,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(678,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(679,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),



        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
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
                    // TemplateTask_10steps_1
                    errorDescriptionDict.Add(500, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(501, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(502, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(503, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(504, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(505, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(506, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(507, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(508, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(509, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_2
                    errorDescriptionDict.Add(510, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(511, "Waiting for the signal `Inputs.Status.WorkSensor` to be reseted!");
                    errorDescriptionDict.Add(512, "Waiting for the signal `Inputs.Status.HomeSensor` to be set!");
                    errorDescriptionDict.Add(513, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(514, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(515, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(516, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(517, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(518, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(519, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_3
                    errorDescriptionDict.Add(520, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(521, "Waiting for the signal `Inputs.Status.HomeSensor` to be reseted!");
                    errorDescriptionDict.Add(522, "Waiting for the signal `Inputs.Status.WorkSensor` to be set!");
                    errorDescriptionDict.Add(523, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(524, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(525, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(526, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(527, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(528, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(529, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_4
                    errorDescriptionDict.Add(530, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(531, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(532, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(533, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(534, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(535, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(536, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(537, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(538, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(539, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_5
                    errorDescriptionDict.Add(540, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(541, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(542, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(543, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(544, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(545, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(546, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(547, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(548, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(549, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_10steps_6
                    errorDescriptionDict.Add(550, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(551, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(552, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(553, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(554, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(555, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(556, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(557, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(558, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(559, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_1
                    errorDescriptionDict.Add(560, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(561, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(562, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(563, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(564, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(565, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(566, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(567, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(568, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(569, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(570, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(571, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(572, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(573, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(574, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(575, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(576, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(577, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(578, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(579, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_2
                    errorDescriptionDict.Add(580, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(581, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(582, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(583, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(584, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(585, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(586, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(587, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(588, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(589, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(590, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(591, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(592, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(593, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(594, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(595, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(596, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(597, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(598, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(599, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_3
                    errorDescriptionDict.Add(600, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(601, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(602, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(603, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(604, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(605, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(606, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(607, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(608, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(609, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(610, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(611, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(612, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(613, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(614, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(615, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(616, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(617, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(618, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(619, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_4
                    errorDescriptionDict.Add(620, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(621, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(622, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(623, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(624, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(625, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(626, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(627, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(628, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(629, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(630, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(631, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(632, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(633, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(634, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(635, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(636, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(637, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(638, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(639, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_5
                    errorDescriptionDict.Add(640, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(641, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(642, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(643, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(644, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(645, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(646, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(647, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(648, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(649, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(650, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(651, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(652, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(653, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(654, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(655, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(656, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(657, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(658, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(659, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_6
                    errorDescriptionDict.Add(660, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(661, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(662, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(663, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(664, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(665, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(666, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(667, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(668, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(669, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(670, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(671, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(672, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(673, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(674, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(675, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(676, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(677, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(678, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(679, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl is zero.");
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwID_CommandStatusBits is zero.");
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceResultBits_1 is zero.");
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3.");
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3.");
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3.");
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3.");
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3.");
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatusWords is zero.");
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4.");
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4.");
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4.");
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4.");
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4.");
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatistics is zero.");
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5.");
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5.");
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5.");
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5.");
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5.");
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDs.HwID_PositionAdjustResult is zero.");
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6.");
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6.");
                    errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6.");
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6.");
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6.");
                    errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_1 is zero.");
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7.");
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7.");
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7.");
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7.");
                    errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7.");
                    errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDs.HwID_in_8 is zero.");
                    errorDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8.");
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8.");
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8.");
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8.");
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8.");
                    errorDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(790, "Hw configuration error. Value of Config.HWIDs.HwID_in_9 is zero.");
                    errorDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9.");
                    errorDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9.");
                    errorDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9.");
                    errorDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9.");
                    errorDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9.");
                    errorDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(800, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl0 is zero.");
                    errorDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10.");
                    errorDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10.");
                    errorDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10.");
                    errorDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10.");
                    errorDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10.");
                    errorDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(810, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl1 is zero.");
                    errorDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11.");
                    errorDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11.");
                    errorDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11.");
                    errorDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11.");
                    errorDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11.");
                    errorDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(820, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl2 is zero.");
                    errorDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12.");
                    errorDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12.");
                    errorDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12.");
                    errorDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12.");
                    errorDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12.");
                    errorDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(830, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl3 is zero.");
                    errorDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13.");
                    errorDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13.");
                    errorDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13.");
                    errorDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13.");
                    errorDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13.");
                    errorDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(840, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl4 is zero.");
                    errorDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14.");
                    errorDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14.");
                    errorDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14.");
                    errorDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14.");
                    errorDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14.");
                    errorDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 14. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(850, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl5 is zero.");
                    errorDescriptionDict.Add(851, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15.");
                    errorDescriptionDict.Add(852, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15.");
                    errorDescriptionDict.Add(853, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15.");
                    errorDescriptionDict.Add(854, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15.");
                    errorDescriptionDict.Add(855, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15.");
                    errorDescriptionDict.Add(856, "Hw configuration error: Module with unexpected size or type detected in Slot 15. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(860, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl6 is zero.");
                    errorDescriptionDict.Add(861, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16.");
                    errorDescriptionDict.Add(862, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16.");
                    errorDescriptionDict.Add(863, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16.");
                    errorDescriptionDict.Add(864, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16.");
                    errorDescriptionDict.Add(865, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16.");
                    errorDescriptionDict.Add(866, "Hw configuration error: Module with unexpected size or type detected in Slot 16. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(870, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl7 is zero.");
                    errorDescriptionDict.Add(871, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17.");
                    errorDescriptionDict.Add(872, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17.");
                    errorDescriptionDict.Add(873, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17.");
                    errorDescriptionDict.Add(874, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17.");
                    errorDescriptionDict.Add(875, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17.");
                    errorDescriptionDict.Add(876, "Hw configuration error: Module with unexpected size or type detected in Slot 17. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(880, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl8 is zero.");
                    errorDescriptionDict.Add(881, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18.");
                    errorDescriptionDict.Add(882, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18.");
                    errorDescriptionDict.Add(883, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18.");
                    errorDescriptionDict.Add(884, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18.");
                    errorDescriptionDict.Add(885, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18.");
                    errorDescriptionDict.Add(886, "Hw configuration error: Module with unexpected size or type detected in Slot 18. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(890, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl9 is zero.");
                    errorDescriptionDict.Add(891, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19.");
                    errorDescriptionDict.Add(892, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19.");
                    errorDescriptionDict.Add(893, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19.");
                    errorDescriptionDict.Add(894, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19.");
                    errorDescriptionDict.Add(895, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19.");
                    errorDescriptionDict.Add(896, "Hw configuration error: Module with unexpected size or type detected in Slot 19. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(900, "Hw configuration error. Value of Config.HWIDs.HwID_CommandStatusBits0 is zero.");
                    errorDescriptionDict.Add(901, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20.");
                    errorDescriptionDict.Add(902, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20.");
                    errorDescriptionDict.Add(903, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20.");
                    errorDescriptionDict.Add(904, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20.");
                    errorDescriptionDict.Add(905, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20.");
                    errorDescriptionDict.Add(906, "Hw configuration error: Module with unexpected size or type detected in Slot 20. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(910, "Hw configuration error. Value of Config.HWIDs.HwID_out_1 is zero.");
                    errorDescriptionDict.Add(911, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 21.");
                    errorDescriptionDict.Add(912, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 21.");
                    errorDescriptionDict.Add(913, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 21.");
                    errorDescriptionDict.Add(914, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 21.");
                    errorDescriptionDict.Add(915, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 21.");
                    errorDescriptionDict.Add(916, "Hw configuration error: Module with unexpected size or type detected in Slot 21. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(920, "Hw configuration error. Value of Config.HWIDs.HwID_out_2 is zero.");
                    errorDescriptionDict.Add(921, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 22.");
                    errorDescriptionDict.Add(922, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 22.");
                    errorDescriptionDict.Add(923, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 22.");
                    errorDescriptionDict.Add(924, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 22.");
                    errorDescriptionDict.Add(925, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 22.");
                    errorDescriptionDict.Add(926, "Hw configuration error: Module with unexpected size or type detected in Slot 22. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(930, "Hw configuration error. Value of Config.HWIDs.HwID_out_3 is zero.");
                    errorDescriptionDict.Add(931, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 23.");
                    errorDescriptionDict.Add(932, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 23.");
                    errorDescriptionDict.Add(933, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 23.");
                    errorDescriptionDict.Add(934, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 23.");
                    errorDescriptionDict.Add(935, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 23.");
                    errorDescriptionDict.Add(936, "Hw configuration error: Module with unexpected size or type detected in Slot 23. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(940, "Hw configuration error. Value of Config.HWIDs.HwID_out_4 is zero.");
                    errorDescriptionDict.Add(941, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 24.");
                    errorDescriptionDict.Add(942, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 24.");
                    errorDescriptionDict.Add(943, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 24.");
                    errorDescriptionDict.Add(944, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 24.");
                    errorDescriptionDict.Add(945, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 24.");
                    errorDescriptionDict.Add(946, "Hw configuration error: Module with unexpected size or type detected in Slot 24. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(950, "Hw configuration error. Value of Config.HWIDs.HwID_out_5 is zero.");
                    errorDescriptionDict.Add(951, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 25.");
                    errorDescriptionDict.Add(952, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 25.");
                    errorDescriptionDict.Add(953, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 25.");
                    errorDescriptionDict.Add(954, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 25.");
                    errorDescriptionDict.Add(955, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 25.");
                    errorDescriptionDict.Add(956, "Hw configuration error: Module with unexpected size or type detected in Slot 25. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(960, "Hw configuration error. Value of Config.HWIDs.HwID_out_6 is zero.");
                    errorDescriptionDict.Add(961, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 26.");
                    errorDescriptionDict.Add(962, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 26.");
                    errorDescriptionDict.Add(963, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 26.");
                    errorDescriptionDict.Add(964, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 26.");
                    errorDescriptionDict.Add(965, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 26.");
                    errorDescriptionDict.Add(966, "Hw configuration error: Module with unexpected size or type detected in Slot 26. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(970, "Hw configuration error. Value of Config.HWIDs.HwID_out_7 is zero.");
                    errorDescriptionDict.Add(971, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 27.");
                    errorDescriptionDict.Add(972, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 27.");
                    errorDescriptionDict.Add(973, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 27.");
                    errorDescriptionDict.Add(974, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 27.");
                    errorDescriptionDict.Add(975, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 27.");
                    errorDescriptionDict.Add(976, "Hw configuration error: Module with unexpected size or type detected in Slot 27. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(980, "Hw configuration error. Value of Config.HWIDs.HwID_out_8 is zero.");
                    errorDescriptionDict.Add(981, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 28.");
                    errorDescriptionDict.Add(982, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 28.");
                    errorDescriptionDict.Add(983, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 28.");
                    errorDescriptionDict.Add(984, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 28.");
                    errorDescriptionDict.Add(985, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 28.");
                    errorDescriptionDict.Add(986, "Hw configuration error: Module with unexpected size or type detected in Slot 28. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(990, "Hw configuration error. Value of Config.HWIDs.HwID_out_9 is zero.");
                    errorDescriptionDict.Add(991, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 29.");
                    errorDescriptionDict.Add(992, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 29.");
                    errorDescriptionDict.Add(993, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 29.");
                    errorDescriptionDict.Add(994, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 29.");
                    errorDescriptionDict.Add(995, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 29.");
                    errorDescriptionDict.Add(996, "Hw configuration error: Module with unexpected size or type detected in Slot 29. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1000, "Hw configuration error. Value of Config.HWIDs.HwID_out_10 is zero.");
                    errorDescriptionDict.Add(1001, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 30.");
                    errorDescriptionDict.Add(1002, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 30.");
                    errorDescriptionDict.Add(1003, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 30.");
                    errorDescriptionDict.Add(1004, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 30.");
                    errorDescriptionDict.Add(1005, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 30.");
                    errorDescriptionDict.Add(1006, "Hw configuration error: Module with unexpected size or type detected in Slot 30. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1010, "Hw configuration error. Value of Config.HWIDs.HwID_out_11 is zero.");
                    errorDescriptionDict.Add(1011, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 31.");
                    errorDescriptionDict.Add(1012, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 31.");
                    errorDescriptionDict.Add(1013, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 31.");
                    errorDescriptionDict.Add(1014, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 31.");
                    errorDescriptionDict.Add(1015, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 31.");
                    errorDescriptionDict.Add(1016, "Hw configuration error: Module with unexpected size or type detected in Slot 31. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1020, "Hw configuration error. Value of Config.HWIDs.HwID_out_12 is zero.");
                    errorDescriptionDict.Add(1021, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 32.");
                    errorDescriptionDict.Add(1022, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 32.");
                    errorDescriptionDict.Add(1023, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 32.");
                    errorDescriptionDict.Add(1024, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 32.");
                    errorDescriptionDict.Add(1025, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 32.");
                    errorDescriptionDict.Add(1026, "Hw configuration error: Module with unexpected size or type detected in Slot 32. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1030, "Hw configuration error. Value of Config.HWIDs.HwID_out_13 is zero.");
                    errorDescriptionDict.Add(1031, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 33.");
                    errorDescriptionDict.Add(1032, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 33.");
                    errorDescriptionDict.Add(1033, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 33.");
                    errorDescriptionDict.Add(1034, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 33.");
                    errorDescriptionDict.Add(1035, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 33.");
                    errorDescriptionDict.Add(1036, "Hw configuration error: Module with unexpected size or type detected in Slot 33. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1040, "Hw configuration error. Value of Config.HWIDs.HwID_out_14 is zero.");
                    errorDescriptionDict.Add(1041, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 34.");
                    errorDescriptionDict.Add(1042, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 34.");
                    errorDescriptionDict.Add(1043, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 34.");
                    errorDescriptionDict.Add(1044, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 34.");
                    errorDescriptionDict.Add(1045, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 34.");
                    errorDescriptionDict.Add(1046, "Hw configuration error: Module with unexpected size or type detected in Slot 34. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1050, "Hw configuration error. Value of Config.HWIDs.HwID_out_15 is zero.");
                    errorDescriptionDict.Add(1051, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 35.");
                    errorDescriptionDict.Add(1052, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 35.");
                    errorDescriptionDict.Add(1053, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 35.");
                    errorDescriptionDict.Add(1054, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 35.");
                    errorDescriptionDict.Add(1055, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 35.");
                    errorDescriptionDict.Add(1056, "Hw configuration error: Module with unexpected size or type detected in Slot 35. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1060, "Hw configuration error. Value of Config.HWIDs.HwID_out_16 is zero.");
                    errorDescriptionDict.Add(1061, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 36.");
                    errorDescriptionDict.Add(1062, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 36.");
                    errorDescriptionDict.Add(1063, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 36.");
                    errorDescriptionDict.Add(1064, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 36.");
                    errorDescriptionDict.Add(1065, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 36.");
                    errorDescriptionDict.Add(1066, "Hw configuration error: Module with unexpected size or type detected in Slot 36. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1070, "Hw configuration error. Value of Config.HWIDs.HwID_out_17 is zero.");
                    errorDescriptionDict.Add(1071, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 37.");
                    errorDescriptionDict.Add(1072, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 37.");
                    errorDescriptionDict.Add(1073, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 37.");
                    errorDescriptionDict.Add(1074, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 37.");
                    errorDescriptionDict.Add(1075, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 37.");
                    errorDescriptionDict.Add(1076, "Hw configuration error: Module with unexpected size or type detected in Slot 37. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1080, "Hw configuration error. Value of Config.HWIDs.HwID_out_18 is zero.");
                    errorDescriptionDict.Add(1081, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 38.");
                    errorDescriptionDict.Add(1082, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 38.");
                    errorDescriptionDict.Add(1083, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 38.");
                    errorDescriptionDict.Add(1084, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 38.");
                    errorDescriptionDict.Add(1085, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 38.");
                    errorDescriptionDict.Add(1086, "Hw configuration error: Module with unexpected size or type detected in Slot 38. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1090, "Hw configuration error. Value of Config.HWIDs.HwID_out_19 is zero.");
                    errorDescriptionDict.Add(1091, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 39.");
                    errorDescriptionDict.Add(1092, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 39.");
                    errorDescriptionDict.Add(1093, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 39.");
                    errorDescriptionDict.Add(1094, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 39.");
                    errorDescriptionDict.Add(1095, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 39.");
                    errorDescriptionDict.Add(1096, "Hw configuration error: Module with unexpected size or type detected in Slot 39. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1100, "Hw configuration error. Value of Config.HWIDs.HwID_out_20 is zero.");
                    errorDescriptionDict.Add(1101, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 40.");
                    errorDescriptionDict.Add(1102, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 40.");
                    errorDescriptionDict.Add(1103, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 40.");
                    errorDescriptionDict.Add(1104, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 40.");
                    errorDescriptionDict.Add(1105, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 40.");
                    errorDescriptionDict.Add(1106, "Hw configuration error: Module with unexpected size or type detected in Slot 40. Expected module: 'gsd_id_of_req_module'.");
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HwID_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1132, "Variable `Config.HWIDs.HwID_CommandControl` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1133, "Variable `Config.HWIDs.HwID_CommandStatusBits` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1134, "Variable `Config.HWIDs.HwID_DeviceResultBits_1` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1135, "Variable `Config.HWIDs.HwID_DeviceStatusWords` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1136, "Variable `Config.HWIDs.HwID_DeviceStatistics` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1137, "Variable `Config.HWIDs.HwID_PositionAdjustResult` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1138, "Variable `Config.HWIDs.HwID_ToolResult_1` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1139, "Variable `Config.HWIDs.HwID_in_8` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1140, "Variable `Config.HWIDs.HwID_in_9` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1141, "Variable `Config.HWIDs.HwID_CommandControl0` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1142, "Variable `Config.HWIDs.HwID_CommandControl1` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1143, "Variable `Config.HWIDs.HwID_CommandControl2` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1144, "Variable `Config.HWIDs.HwID_CommandControl3` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1145, "Variable `Config.HWIDs.HwID_CommandControl4` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1146, "Variable `Config.HWIDs.HwID_CommandControl5` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1147, "Variable `Config.HWIDs.HwID_CommandControl6` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1148, "Variable `Config.HWIDs.HwID_CommandControl7` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1149, "Variable `Config.HWIDs.HwID_CommandControl8` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1150, "Variable `Config.HWIDs.HwID_CommandControl9` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1151, "Variable `Config.HWIDs.HwID_CommandStatusBits0` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1152, "Variable `Config.HWIDs.HwID_out_1` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1153, "Variable `Config.HWIDs.HwID_out_2` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1154, "Variable `Config.HWIDs.HwID_out_3` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1155, "Variable `Config.HWIDs.HwID_out_4` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1156, "Variable `Config.HWIDs.HwID_out_5` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1157, "Variable `Config.HWIDs.HwID_out_6` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1158, "Variable `Config.HWIDs.HwID_out_7` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1159, "Variable `Config.HWIDs.HwID_out_8` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1160, "Variable `Config.HWIDs.HwID_out_9` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1161, "Variable `Config.HWIDs.HwID_out_10` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1162, "Variable `Config.HWIDs.HwID_out_11` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1163, "Variable `Config.HWIDs.HwID_out_12` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1164, "Variable `Config.HWIDs.HwID_out_13` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1165, "Variable `Config.HWIDs.HwID_out_14` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1166, "Variable `Config.HWIDs.HwID_out_15` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1167, "Variable `Config.HWIDs.HwID_out_16` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1168, "Variable `Config.HWIDs.HwID_out_17` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1169, "Variable `Config.HWIDs.HwID_out_18` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1170, "Variable `Config.HWIDs.HwID_out_19` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1171, "Variable `Config.HWIDs.HwID_out_20` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1201, "Error reading the Axo_IV3InputStructure_HwID_CommandControl!");
                    errorDescriptionDict.Add(1202, "Error reading the Axo_IV3InputStructure_HwID_CommandStatusBits!");
                    errorDescriptionDict.Add(1203, "Error reading the Axo_IV3InputStructure_HwID_DeviceResultBits_1!");
                    errorDescriptionDict.Add(1204, "Error reading the Axo_IV3InputStructure_HwID_DeviceStatusWords!");
                    errorDescriptionDict.Add(1205, "Error reading the Axo_IV3InputStructure_HwID_DeviceStatistics!");
                    errorDescriptionDict.Add(1206, "Error reading the Axo_IV3InputStructure_HwID_PositionAdjustResult!");
                    errorDescriptionDict.Add(1207, "Error reading the Axo_IV3InputStructure_HwID_ToolResult_1!");
                    errorDescriptionDict.Add(1208, "Error reading the Axo_IV3InputStructure_HwID_in_8!");
                    errorDescriptionDict.Add(1209, "Error reading the Axo_IV3InputStructure_HwID_in_9!");
                    errorDescriptionDict.Add(1210, "Error reading the Axo_IV3InputStructure_HwID_CommandControl0!");
                    errorDescriptionDict.Add(1211, "Error reading the Axo_IV3InputStructure_HwID_CommandControl1!");
                    errorDescriptionDict.Add(1212, "Error reading the Axo_IV3InputStructure_HwID_CommandControl2!");
                    errorDescriptionDict.Add(1213, "Error reading the Axo_IV3InputStructure_HwID_CommandControl3!");
                    errorDescriptionDict.Add(1214, "Error reading the Axo_IV3InputStructure_HwID_CommandControl4!");
                    errorDescriptionDict.Add(1215, "Error reading the Axo_IV3InputStructure_HwID_CommandControl5!");
                    errorDescriptionDict.Add(1216, "Error reading the Axo_IV3InputStructure_HwID_CommandControl6!");
                    errorDescriptionDict.Add(1217, "Error reading the Axo_IV3InputStructure_HwID_CommandControl7!");
                    errorDescriptionDict.Add(1218, "Error reading the Axo_IV3InputStructure_HwID_CommandControl8!");
                    errorDescriptionDict.Add(1219, "Error reading the Axo_IV3InputStructure_HwID_CommandControl9!");
                    errorDescriptionDict.Add(1220, "Error reading the Axo_IV3InputStructure_HwID_CommandStatusBits0!");
                    errorDescriptionDict.Add(1231, "Error writing the Axo_IV3OutputStructure_HwID_out_1!");
                    errorDescriptionDict.Add(1232, "Error writing the Axo_IV3OutputStructure_HwID_out_2!");
                    errorDescriptionDict.Add(1233, "Error writing the Axo_IV3OutputStructure_HwID_out_3!");
                    errorDescriptionDict.Add(1234, "Error writing the Axo_IV3OutputStructure_HwID_out_4!");
                    errorDescriptionDict.Add(1235, "Error writing the Axo_IV3OutputStructure_HwID_out_5!");
                    errorDescriptionDict.Add(1236, "Error writing the Axo_IV3OutputStructure_HwID_out_6!");
                    errorDescriptionDict.Add(1237, "Error writing the Axo_IV3OutputStructure_HwID_out_7!");
                    errorDescriptionDict.Add(1238, "Error writing the Axo_IV3OutputStructure_HwID_out_8!");
                    errorDescriptionDict.Add(1239, "Error writing the Axo_IV3OutputStructure_HwID_out_9!");
                    errorDescriptionDict.Add(1240, "Error writing the Axo_IV3OutputStructure_HwID_out_10!");
                    errorDescriptionDict.Add(1241, "Error writing the Axo_IV3OutputStructure_HwID_out_11!");
                    errorDescriptionDict.Add(1242, "Error writing the Axo_IV3OutputStructure_HwID_out_12!");
                    errorDescriptionDict.Add(1243, "Error writing the Axo_IV3OutputStructure_HwID_out_13!");
                    errorDescriptionDict.Add(1244, "Error writing the Axo_IV3OutputStructure_HwID_out_14!");
                    errorDescriptionDict.Add(1245, "Error writing the Axo_IV3OutputStructure_HwID_out_15!");
                    errorDescriptionDict.Add(1246, "Error writing the Axo_IV3OutputStructure_HwID_out_16!");
                    errorDescriptionDict.Add(1247, "Error writing the Axo_IV3OutputStructure_HwID_out_17!");
                    errorDescriptionDict.Add(1248, "Error writing the Axo_IV3OutputStructure_HwID_out_18!");
                    errorDescriptionDict.Add(1249, "Error writing the Axo_IV3OutputStructure_HwID_out_19!");
                    errorDescriptionDict.Add(1250, "Error writing the Axo_IV3OutputStructure_HwID_out_20!");
                    // TemplateTask_10steps_1
                    errorDescriptionDict.Add(10000, "TemplateTask_10steps_1 finished with error!");
                    errorDescriptionDict.Add(10001, "TemplateTask_10steps_1 was aborted, while not yet completed!");
                    // TemplateTask_10steps_2
                    errorDescriptionDict.Add(10010, "TemplateTask_10steps_2 finished with error!");
                    errorDescriptionDict.Add(10011, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    // TemplateTask_10steps_3
                    errorDescriptionDict.Add(10020, "TemplateTask_10steps_3 finished with error!");
                    errorDescriptionDict.Add(10021, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    // TemplateTask_10steps_4
                    errorDescriptionDict.Add(10030, "TemplateTask_10steps_4 task finished with error!");
                    errorDescriptionDict.Add(10031, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_5
                    errorDescriptionDict.Add(10040, "TemplateTask_10steps_5 task finished with error!");
                    errorDescriptionDict.Add(10041, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_6
                    errorDescriptionDict.Add(10050, "TemplateTask_10steps_6 task finished with error!");
                    errorDescriptionDict.Add(10051, "TemplateTask_10steps_6 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_1
                    errorDescriptionDict.Add(10060, "TemplateTask_20steps_1 task finished with error!");
                    errorDescriptionDict.Add(10061, "TemplateTask_20steps_1 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_2
                    errorDescriptionDict.Add(10080, "TemplateTask_20steps_2 task finished with error!");
                    errorDescriptionDict.Add(10081, "TemplateTask_20steps_2 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_3
                    errorDescriptionDict.Add(10100, "TemplateTask_20steps_3 task finished with error!");
                    errorDescriptionDict.Add(10101, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_4
                    errorDescriptionDict.Add(10120, "TemplateTask_20steps_4 task finished with error!");
                    errorDescriptionDict.Add(10121, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_5
                    errorDescriptionDict.Add(10140, "TemplateTask_20steps_5 task finished with error!");
                    errorDescriptionDict.Add(10141, "TemplateTask_20steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_6
                    errorDescriptionDict.Add(10160, "TemplateTask_20steps_6 task finished with error!");
                    errorDescriptionDict.Add(10161, "TemplateTask_20steps_6 task was aborted, while not yet completed!");

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
                    // TemplateTask_10steps_1
                    actionDescriptionDict.Add(100, "TemplateTask_10steps_1 started.");
                    actionDescriptionDict.Add(300, "TemplateTask_10steps_1 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(301, "TemplateTask_10steps_1 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(302, "TemplateTask_10steps_1 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(303, "TemplateTask_10steps_1 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(304, "TemplateTask_10steps_1 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(305, "TemplateTask_10steps_1 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(306, "TemplateTask_10steps_1 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(307, "TemplateTask_10steps_1 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(308, "TemplateTask_10steps_1 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(309, "TemplateTask_10steps_1 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(101, "TemplateTask_10steps_1 finished succesfully.");
                    actionDescriptionDict.Add(102, "TemplateTask_10steps_1 restored.");
                    // TemplateTask_10steps_2
                    actionDescriptionDict.Add(110, "TemplateTask_10steps_2 started.");
                    actionDescriptionDict.Add(310, "TemplateTask_10steps_2 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(311, "TemplateTask_10steps_2 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(312, "TemplateTask_10steps_2 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(313, "TemplateTask_10steps_2 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(314, "TemplateTask_10steps_2 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(315, "TemplateTask_10steps_2 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(316, "TemplateTask_10steps_2 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(317, "TemplateTask_10steps_2 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(318, "TemplateTask_10steps_2 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(319, "TemplateTask_10steps_2 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(111, "TemplateTask_10steps_2 finished succesfully.");
                    actionDescriptionDict.Add(112, "TemplateTask_10steps_2 restored.");
                    // TemplateTask_10steps_3
                    actionDescriptionDict.Add(120, "TemplateTask_10steps_3 started.");
                    actionDescriptionDict.Add(320, "TemplateTask_10steps_3 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(321, "TemplateTask_10steps_3 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(322, "TemplateTask_10steps_3 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(323, "TemplateTask_10steps_3 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(324, "TemplateTask_10steps_3 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(325, "TemplateTask_10steps_3 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(326, "TemplateTask_10steps_3 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(327, "TemplateTask_10steps_3 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(328, "TemplateTask_10steps_3 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(329, "TemplateTask_10steps_3 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(121, "TemplateTask_10steps_3 finished succesfully.");
                    actionDescriptionDict.Add(122, "TemplateTask_10steps_3 restored.");
                    // TemplateTask_10steps_4
                    actionDescriptionDict.Add(130, "TemplateTask_10steps_4 started.");
                    actionDescriptionDict.Add(330, "TemplateTask_10steps_4 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(331, "TemplateTask_10steps_4 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(332, "TemplateTask_10steps_4 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(333, "TemplateTask_10steps_4 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(334, "TemplateTask_10steps_4 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(335, "TemplateTask_10steps_4 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(336, "TemplateTask_10steps_4 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(337, "TemplateTask_10steps_4 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(338, "TemplateTask_10steps_4 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(339, "TemplateTask_10steps_4 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(131, "TemplateTask_10steps_4 finished succesfully.");
                    actionDescriptionDict.Add(132, "TemplateTask_10steps_4 restored.");
                    // TemplateTask_10steps_5
                    actionDescriptionDict.Add(140, "TemplateTask_10steps_5 started.");
                    actionDescriptionDict.Add(340, "TemplateTask_10steps_5 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(341, "TemplateTask_10steps_5 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(342, "TemplateTask_10steps_5 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(343, "TemplateTask_10steps_5 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(344, "TemplateTask_10steps_5 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(345, "TemplateTask_10steps_5 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(346, "TemplateTask_10steps_5 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(347, "TemplateTask_10steps_5 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(348, "TemplateTask_10steps_5 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(349, "TemplateTask_10steps_5 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(141, "TemplateTask_10steps_5 finished succesfully.");
                    actionDescriptionDict.Add(142, "TemplateTask_10steps_5 restored.");
                    // TemplateTask_10steps_6
                    actionDescriptionDict.Add(150, "TemplateTask_10steps_6 started.");
                    actionDescriptionDict.Add(350, "TemplateTask_10steps_6 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(351, "TemplateTask_10steps_6 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(352, "TemplateTask_10steps_6 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(353, "TemplateTask_10steps_6 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(354, "TemplateTask_10steps_6 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(355, "TemplateTask_10steps_6 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(356, "TemplateTask_10steps_6 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(357, "TemplateTask_10steps_6 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(358, "TemplateTask_10steps_6 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(359, "TemplateTask_10steps_6 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(151, "TemplateTask_10steps_6 finished succesfully.");
                    actionDescriptionDict.Add(152, "TemplateTask_10steps_6 restored.");

                    // TemplateTask_20steps_1
                    actionDescriptionDict.Add(160, "TemplateTask_20steps_1 started.");
                    actionDescriptionDict.Add(360, "TemplateTask_20steps_1 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(361, "TemplateTask_20steps_1 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(362, "TemplateTask_20steps_1 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(363, "TemplateTask_20steps_1 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(364, "TemplateTask_20steps_1 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(365, "TemplateTask_20steps_1 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(366, "TemplateTask_20steps_1 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(367, "TemplateTask_20steps_1 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(368, "TemplateTask_20steps_1 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(369, "TemplateTask_20steps_1 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(370, "TemplateTask_20steps_1 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(371, "TemplateTask_20steps_1 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(372, "TemplateTask_20steps_1 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(373, "TemplateTask_20steps_1 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(374, "TemplateTask_20steps_1 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(375, "TemplateTask_20steps_1 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(376, "TemplateTask_20steps_1 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(377, "TemplateTask_20steps_1 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(378, "TemplateTask_20steps_1 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(379, "TemplateTask_20steps_1 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(161, "TemplateTask_20steps_1 finished succesfully.");
                    actionDescriptionDict.Add(162, "TemplateTask_20steps_1 restored.");
                    // TemplateTask_20steps_2
                    actionDescriptionDict.Add(180, "TemplateTask_20steps_2 started.");
                    actionDescriptionDict.Add(380, "TemplateTask_20steps_2 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(381, "TemplateTask_20steps_2 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(382, "TemplateTask_20steps_2 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(383, "TemplateTask_20steps_2 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(384, "TemplateTask_20steps_2 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(385, "TemplateTask_20steps_2 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(386, "TemplateTask_20steps_2 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(387, "TemplateTask_20steps_2 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(388, "TemplateTask_20steps_2 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(389, "TemplateTask_20steps_2 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(390, "TemplateTask_20steps_2 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(391, "TemplateTask_20steps_2 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(392, "TemplateTask_20steps_2 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(393, "TemplateTask_20steps_2 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(394, "TemplateTask_20steps_2 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(395, "TemplateTask_20steps_2 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(396, "TemplateTask_20steps_2 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(397, "TemplateTask_20steps_2 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(398, "TemplateTask_20steps_2 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(399, "TemplateTask_20steps_2 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(181, "TemplateTask_20steps_2 finished succesfully.");
                    actionDescriptionDict.Add(182, "TemplateTask_20steps_2 restored.");
                    // TemplateTask_20steps_3
                    actionDescriptionDict.Add(200, "TemplateTask_20steps_3 started.");
                    actionDescriptionDict.Add(400, "TemplateTask_20steps_3 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(401, "TemplateTask_20steps_3 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(402, "TemplateTask_20steps_3 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(403, "TemplateTask_20steps_3 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(404, "TemplateTask_20steps_3 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(405, "TemplateTask_20steps_3 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(406, "TemplateTask_20steps_3 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(407, "TemplateTask_20steps_3 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(408, "TemplateTask_20steps_3 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(409, "TemplateTask_20steps_3 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(410, "TemplateTask_20steps_3 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(411, "TemplateTask_20steps_3 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(412, "TemplateTask_20steps_3 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(413, "TemplateTask_20steps_3 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(414, "TemplateTask_20steps_3 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(415, "TemplateTask_20steps_3 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(416, "TemplateTask_20steps_3 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(417, "TemplateTask_20steps_3 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(418, "TemplateTask_20steps_3 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(419, "TemplateTask_20steps_3 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(201, "TemplateTask_20steps_3 finished succesfully.");
                    actionDescriptionDict.Add(202, "TemplateTask_20steps_3 restored.");
                    // TemplateTask_20steps_4
                    actionDescriptionDict.Add(220, "TemplateTask_20steps_4 started.");
                    actionDescriptionDict.Add(420, "TemplateTask_20steps_4 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(421, "TemplateTask_20steps_4 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(422, "TemplateTask_20steps_4 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(423, "TemplateTask_20steps_4 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(424, "TemplateTask_20steps_4 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(425, "TemplateTask_20steps_4 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(426, "TemplateTask_20steps_4 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(427, "TemplateTask_20steps_4 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(428, "TemplateTask_20steps_4 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(429, "TemplateTask_20steps_4 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(430, "TemplateTask_20steps_4 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(431, "TemplateTask_20steps_4 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(432, "TemplateTask_20steps_4 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(433, "TemplateTask_20steps_4 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(434, "TemplateTask_20steps_4 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(435, "TemplateTask_20steps_4 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(436, "TemplateTask_20steps_4 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(437, "TemplateTask_20steps_4 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(438, "TemplateTask_20steps_4 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(439, "TemplateTask_20steps_4 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(221, "TemplateTask_20steps_4 finished succesfully.");
                    actionDescriptionDict.Add(222, "TemplateTask_20steps_4 restored.");
                    // TemplateTask_20steps_5
                    actionDescriptionDict.Add(240, "TemplateTask_20steps_5 started.");
                    actionDescriptionDict.Add(440, "TemplateTask_20steps_5 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(441, "TemplateTask_20steps_5 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(442, "TemplateTask_20steps_5 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(443, "TemplateTask_20steps_5 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(444, "TemplateTask_20steps_5 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(445, "TemplateTask_20steps_5 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(446, "TemplateTask_20steps_5 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(447, "TemplateTask_20steps_5 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(448, "TemplateTask_20steps_5 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(449, "TemplateTask_20steps_5 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(450, "TemplateTask_20steps_5 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(451, "TemplateTask_20steps_5 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(452, "TemplateTask_20steps_5 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(453, "TemplateTask_20steps_5 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(454, "TemplateTask_20steps_5 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(455, "TemplateTask_20steps_5 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(456, "TemplateTask_20steps_5 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(457, "TemplateTask_20steps_5 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(458, "TemplateTask_20steps_5 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(459, "TemplateTask_20steps_5 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(241, "TemplateTask_20steps_5 finished succesfully.");
                    actionDescriptionDict.Add(242, "TemplateTask_20steps_5 restored.");
                    // TemplateTask_20steps_6
                    actionDescriptionDict.Add(260, "TemplateTask_20steps_6 started.");
                    actionDescriptionDict.Add(460, "TemplateTask_20steps_6 running, <add the detailed description of the current action 1>");
                    actionDescriptionDict.Add(461, "TemplateTask_20steps_6 running, <add the detailed description of the current action 2>");
                    actionDescriptionDict.Add(462, "TemplateTask_20steps_6 running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(463, "TemplateTask_20steps_6 running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(464, "TemplateTask_20steps_6 running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(465, "TemplateTask_20steps_6 running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(466, "TemplateTask_20steps_6 running, <add the detailed description of the current action 7>");
                    actionDescriptionDict.Add(467, "TemplateTask_20steps_6 running, <add the detailed description of the current action 8>");
                    actionDescriptionDict.Add(468, "TemplateTask_20steps_6 running, <add the detailed description of the current action 9>");
                    actionDescriptionDict.Add(469, "TemplateTask_20steps_6 running, <add the detailed description of the current action 10>");
                    actionDescriptionDict.Add(470, "TemplateTask_20steps_6 running, <add the detailed description of the current action 11>");
                    actionDescriptionDict.Add(471, "TemplateTask_20steps_6 running, <add the detailed description of the current action 12>");
                    actionDescriptionDict.Add(472, "TemplateTask_20steps_6 running, <add the detailed description of the current action 13>");
                    actionDescriptionDict.Add(473, "TemplateTask_20steps_6 running, <add the detailed description of the current action 14>");
                    actionDescriptionDict.Add(474, "TemplateTask_20steps_6 running, <add the detailed description of the current action 15>");
                    actionDescriptionDict.Add(475, "TemplateTask_20steps_6 running, <add the detailed description of the current action 16>");
                    actionDescriptionDict.Add(476, "TemplateTask_20steps_6 running, <add the detailed description of the current action 17>");
                    actionDescriptionDict.Add(477, "TemplateTask_20steps_6 running, <add the detailed description of the current action 18>");
                    actionDescriptionDict.Add(478, "TemplateTask_20steps_6 running, <add the detailed description of the current action 19>");
                    actionDescriptionDict.Add(479, "TemplateTask_20steps_6 running, <add the detailed description of the current action 20>");
                    actionDescriptionDict.Add(261, "TemplateTask_20steps_6 finished succesfully.");
                    actionDescriptionDict.Add(262, "TemplateTask_20steps_6 restored.");
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
                    actionDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwID_CommandStatusBits is zero.");
                    actionDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    actionDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    actionDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    actionDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    actionDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    actionDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceResultBits_1 is zero.");
                    actionDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3.");
                    actionDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3.");
                    actionDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3.");
                    actionDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3.");
                    actionDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3.");
                    actionDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatusWords is zero.");
                    actionDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4.");
                    actionDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4.");
                    actionDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4.");
                    actionDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4.");
                    actionDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4.");
                    actionDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwID_DeviceStatistics is zero.");
                    actionDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5.");
                    actionDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5.");
                    actionDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5.");
                    actionDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5.");
                    actionDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5.");
                    actionDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDs.HwID_PositionAdjustResult is zero.");
                    actionDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6.");
                    actionDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6.");
                    actionDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6.");
                    actionDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6.");
                    actionDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6.");
                    actionDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDs.HwID_ToolResult_1 is zero.");
                    actionDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7.");
                    actionDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7.");
                    actionDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7.");
                    actionDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7.");
                    actionDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7.");
                    actionDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDs.HwID_in_8 is zero.");
                    actionDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8.");
                    actionDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8.");
                    actionDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8.");
                    actionDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8.");
                    actionDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8.");
                    actionDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(790, "Hw configuration error. Value of Config.HWIDs.HwID_in_9 is zero.");
                    actionDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9.");
                    actionDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9.");
                    actionDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9.");
                    actionDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9.");
                    actionDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9.");
                    actionDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(800, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl0 is zero.");
                    actionDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10.");
                    actionDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10.");
                    actionDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10.");
                    actionDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10.");
                    actionDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10.");
                    actionDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(810, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl1 is zero.");
                    actionDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11.");
                    actionDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11.");
                    actionDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11.");
                    actionDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11.");
                    actionDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11.");
                    actionDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(820, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl2 is zero.");
                    actionDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12.");
                    actionDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12.");
                    actionDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12.");
                    actionDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12.");
                    actionDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12.");
                    actionDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(830, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl3 is zero.");
                    actionDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13.");
                    actionDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13.");
                    actionDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13.");
                    actionDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13.");
                    actionDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13.");
                    actionDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(840, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl4 is zero.");
                    actionDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14.");
                    actionDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14.");
                    actionDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14.");
                    actionDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14.");
                    actionDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14.");
                    actionDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 14. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(850, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl5 is zero.");
                    actionDescriptionDict.Add(851, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15.");
                    actionDescriptionDict.Add(852, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15.");
                    actionDescriptionDict.Add(853, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15.");
                    actionDescriptionDict.Add(854, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15.");
                    actionDescriptionDict.Add(855, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15.");
                    actionDescriptionDict.Add(856, "Hw configuration error: Module with unexpected size or type detected in Slot 15. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(860, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl6 is zero.");
                    actionDescriptionDict.Add(861, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16.");
                    actionDescriptionDict.Add(862, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16.");
                    actionDescriptionDict.Add(863, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16.");
                    actionDescriptionDict.Add(864, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16.");
                    actionDescriptionDict.Add(865, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16.");
                    actionDescriptionDict.Add(866, "Hw configuration error: Module with unexpected size or type detected in Slot 16. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(870, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl7 is zero.");
                    actionDescriptionDict.Add(871, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17.");
                    actionDescriptionDict.Add(872, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17.");
                    actionDescriptionDict.Add(873, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17.");
                    actionDescriptionDict.Add(874, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17.");
                    actionDescriptionDict.Add(875, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17.");
                    actionDescriptionDict.Add(876, "Hw configuration error: Module with unexpected size or type detected in Slot 17. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(880, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl8 is zero.");
                    actionDescriptionDict.Add(881, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18.");
                    actionDescriptionDict.Add(882, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18.");
                    actionDescriptionDict.Add(883, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18.");
                    actionDescriptionDict.Add(884, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18.");
                    actionDescriptionDict.Add(885, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18.");
                    actionDescriptionDict.Add(886, "Hw configuration error: Module with unexpected size or type detected in Slot 18. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(890, "Hw configuration error. Value of Config.HWIDs.HwID_CommandControl9 is zero.");
                    actionDescriptionDict.Add(891, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19.");
                    actionDescriptionDict.Add(892, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19.");
                    actionDescriptionDict.Add(893, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19.");
                    actionDescriptionDict.Add(894, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19.");
                    actionDescriptionDict.Add(895, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19.");
                    actionDescriptionDict.Add(896, "Hw configuration error: Module with unexpected size or type detected in Slot 19. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(900, "Hw configuration error. Value of Config.HWIDs.HwID_CommandStatusBits0 is zero.");
                    actionDescriptionDict.Add(901, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20.");
                    actionDescriptionDict.Add(902, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20.");
                    actionDescriptionDict.Add(903, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20.");
                    actionDescriptionDict.Add(904, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20.");
                    actionDescriptionDict.Add(905, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20.");
                    actionDescriptionDict.Add(906, "Hw configuration error: Module with unexpected size or type detected in Slot 20. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(910, "Hw configuration error. Value of Config.HWIDs.HwID_out_1 is zero.");
                    actionDescriptionDict.Add(911, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 21.");
                    actionDescriptionDict.Add(912, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 21.");
                    actionDescriptionDict.Add(913, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 21.");
                    actionDescriptionDict.Add(914, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 21.");
                    actionDescriptionDict.Add(915, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 21.");
                    actionDescriptionDict.Add(916, "Hw configuration error: Module with unexpected size or type detected in Slot 21. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(920, "Hw configuration error. Value of Config.HWIDs.HwID_out_2 is zero.");
                    actionDescriptionDict.Add(921, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 22.");
                    actionDescriptionDict.Add(922, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 22.");
                    actionDescriptionDict.Add(923, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 22.");
                    actionDescriptionDict.Add(924, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 22.");
                    actionDescriptionDict.Add(925, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 22.");
                    actionDescriptionDict.Add(926, "Hw configuration error: Module with unexpected size or type detected in Slot 22. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(930, "Hw configuration error. Value of Config.HWIDs.HwID_out_3 is zero.");
                    actionDescriptionDict.Add(931, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 23.");
                    actionDescriptionDict.Add(932, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 23.");
                    actionDescriptionDict.Add(933, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 23.");
                    actionDescriptionDict.Add(934, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 23.");
                    actionDescriptionDict.Add(935, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 23.");
                    actionDescriptionDict.Add(936, "Hw configuration error: Module with unexpected size or type detected in Slot 23. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(940, "Hw configuration error. Value of Config.HWIDs.HwID_out_4 is zero.");
                    actionDescriptionDict.Add(941, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 24.");
                    actionDescriptionDict.Add(942, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 24.");
                    actionDescriptionDict.Add(943, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 24.");
                    actionDescriptionDict.Add(944, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 24.");
                    actionDescriptionDict.Add(945, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 24.");
                    actionDescriptionDict.Add(946, "Hw configuration error: Module with unexpected size or type detected in Slot 24. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(950, "Hw configuration error. Value of Config.HWIDs.HwID_out_5 is zero.");
                    actionDescriptionDict.Add(951, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 25.");
                    actionDescriptionDict.Add(952, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 25.");
                    actionDescriptionDict.Add(953, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 25.");
                    actionDescriptionDict.Add(954, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 25.");
                    actionDescriptionDict.Add(955, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 25.");
                    actionDescriptionDict.Add(956, "Hw configuration error: Module with unexpected size or type detected in Slot 25. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(960, "Hw configuration error. Value of Config.HWIDs.HwID_out_6 is zero.");
                    actionDescriptionDict.Add(961, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 26.");
                    actionDescriptionDict.Add(962, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 26.");
                    actionDescriptionDict.Add(963, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 26.");
                    actionDescriptionDict.Add(964, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 26.");
                    actionDescriptionDict.Add(965, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 26.");
                    actionDescriptionDict.Add(966, "Hw configuration error: Module with unexpected size or type detected in Slot 26. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(970, "Hw configuration error. Value of Config.HWIDs.HwID_out_7 is zero.");
                    actionDescriptionDict.Add(971, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 27.");
                    actionDescriptionDict.Add(972, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 27.");
                    actionDescriptionDict.Add(973, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 27.");
                    actionDescriptionDict.Add(974, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 27.");
                    actionDescriptionDict.Add(975, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 27.");
                    actionDescriptionDict.Add(976, "Hw configuration error: Module with unexpected size or type detected in Slot 27. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(980, "Hw configuration error. Value of Config.HWIDs.HwID_out_8 is zero.");
                    actionDescriptionDict.Add(981, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 28.");
                    actionDescriptionDict.Add(982, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 28.");
                    actionDescriptionDict.Add(983, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 28.");
                    actionDescriptionDict.Add(984, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 28.");
                    actionDescriptionDict.Add(985, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 28.");
                    actionDescriptionDict.Add(986, "Hw configuration error: Module with unexpected size or type detected in Slot 28. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(990, "Hw configuration error. Value of Config.HWIDs.HwID_out_9 is zero.");
                    actionDescriptionDict.Add(991, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 29.");
                    actionDescriptionDict.Add(992, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 29.");
                    actionDescriptionDict.Add(993, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 29.");
                    actionDescriptionDict.Add(994, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 29.");
                    actionDescriptionDict.Add(995, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 29.");
                    actionDescriptionDict.Add(996, "Hw configuration error: Module with unexpected size or type detected in Slot 29. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1000, "Hw configuration error. Value of Config.HWIDs.HwID_out_10 is zero.");
                    actionDescriptionDict.Add(1001, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 30.");
                    actionDescriptionDict.Add(1002, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 30.");
                    actionDescriptionDict.Add(1003, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 30.");
                    actionDescriptionDict.Add(1004, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 30.");
                    actionDescriptionDict.Add(1005, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 30.");
                    actionDescriptionDict.Add(1006, "Hw configuration error: Module with unexpected size or type detected in Slot 30. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1010, "Hw configuration error. Value of Config.HWIDs.HwID_out_11 is zero.");
                    actionDescriptionDict.Add(1011, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 31.");
                    actionDescriptionDict.Add(1012, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 31.");
                    actionDescriptionDict.Add(1013, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 31.");
                    actionDescriptionDict.Add(1014, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 31.");
                    actionDescriptionDict.Add(1015, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 31.");
                    actionDescriptionDict.Add(1016, "Hw configuration error: Module with unexpected size or type detected in Slot 31. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1020, "Hw configuration error. Value of Config.HWIDs.HwID_out_12 is zero.");
                    actionDescriptionDict.Add(1021, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 32.");
                    actionDescriptionDict.Add(1022, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 32.");
                    actionDescriptionDict.Add(1023, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 32.");
                    actionDescriptionDict.Add(1024, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 32.");
                    actionDescriptionDict.Add(1025, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 32.");
                    actionDescriptionDict.Add(1026, "Hw configuration error: Module with unexpected size or type detected in Slot 32. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1030, "Hw configuration error. Value of Config.HWIDs.HwID_out_13 is zero.");
                    actionDescriptionDict.Add(1031, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 33.");
                    actionDescriptionDict.Add(1032, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 33.");
                    actionDescriptionDict.Add(1033, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 33.");
                    actionDescriptionDict.Add(1034, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 33.");
                    actionDescriptionDict.Add(1035, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 33.");
                    actionDescriptionDict.Add(1036, "Hw configuration error: Module with unexpected size or type detected in Slot 33. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1040, "Hw configuration error. Value of Config.HWIDs.HwID_out_14 is zero.");
                    actionDescriptionDict.Add(1041, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 34.");
                    actionDescriptionDict.Add(1042, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 34.");
                    actionDescriptionDict.Add(1043, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 34.");
                    actionDescriptionDict.Add(1044, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 34.");
                    actionDescriptionDict.Add(1045, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 34.");
                    actionDescriptionDict.Add(1046, "Hw configuration error: Module with unexpected size or type detected in Slot 34. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1050, "Hw configuration error. Value of Config.HWIDs.HwID_out_15 is zero.");
                    actionDescriptionDict.Add(1051, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 35.");
                    actionDescriptionDict.Add(1052, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 35.");
                    actionDescriptionDict.Add(1053, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 35.");
                    actionDescriptionDict.Add(1054, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 35.");
                    actionDescriptionDict.Add(1055, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 35.");
                    actionDescriptionDict.Add(1056, "Hw configuration error: Module with unexpected size or type detected in Slot 35. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1060, "Hw configuration error. Value of Config.HWIDs.HwID_out_16 is zero.");
                    actionDescriptionDict.Add(1061, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 36.");
                    actionDescriptionDict.Add(1062, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 36.");
                    actionDescriptionDict.Add(1063, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 36.");
                    actionDescriptionDict.Add(1064, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 36.");
                    actionDescriptionDict.Add(1065, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 36.");
                    actionDescriptionDict.Add(1066, "Hw configuration error: Module with unexpected size or type detected in Slot 36. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1070, "Hw configuration error. Value of Config.HWIDs.HwID_out_17 is zero.");
                    actionDescriptionDict.Add(1071, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 37.");
                    actionDescriptionDict.Add(1072, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 37.");
                    actionDescriptionDict.Add(1073, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 37.");
                    actionDescriptionDict.Add(1074, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 37.");
                    actionDescriptionDict.Add(1075, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 37.");
                    actionDescriptionDict.Add(1076, "Hw configuration error: Module with unexpected size or type detected in Slot 37. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1080, "Hw configuration error. Value of Config.HWIDs.HwID_out_18 is zero.");
                    actionDescriptionDict.Add(1081, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 38.");
                    actionDescriptionDict.Add(1082, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 38.");
                    actionDescriptionDict.Add(1083, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 38.");
                    actionDescriptionDict.Add(1084, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 38.");
                    actionDescriptionDict.Add(1085, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 38.");
                    actionDescriptionDict.Add(1086, "Hw configuration error: Module with unexpected size or type detected in Slot 38. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1090, "Hw configuration error. Value of Config.HWIDs.HwID_out_19 is zero.");
                    actionDescriptionDict.Add(1091, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 39.");
                    actionDescriptionDict.Add(1092, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 39.");
                    actionDescriptionDict.Add(1093, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 39.");
                    actionDescriptionDict.Add(1094, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 39.");
                    actionDescriptionDict.Add(1095, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 39.");
                    actionDescriptionDict.Add(1096, "Hw configuration error: Module with unexpected size or type detected in Slot 39. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1100, "Hw configuration error. Value of Config.HWIDs.HwID_out_20 is zero.");
                    actionDescriptionDict.Add(1101, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 40.");
                    actionDescriptionDict.Add(1102, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 40.");
                    actionDescriptionDict.Add(1103, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 40.");
                    actionDescriptionDict.Add(1104, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 40.");
                    actionDescriptionDict.Add(1105, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 40.");
                    actionDescriptionDict.Add(1106, "Hw configuration error: Module with unexpected size or type detected in Slot 40. Expected module: 'gsd_id_of_req_module'.");
                    actionDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(1131, "Input variable `hwId` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwID_CommandControl` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwID_CommandStatusBits` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1134, "Input variable `Config.HWIDs.HwID_DeviceResultBits_1` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1135, "Input variable `Config.HWIDs.HwID_DeviceStatusWords` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1136, "Input variable `Config.HWIDs.HwID_DeviceStatistics` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1137, "Input variable `Config.HWIDs.HwID_PositionAdjustResult` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1138, "Input variable `Config.HWIDs.HwID_ToolResult_1` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1139, "Input variable `Config.HWIDs.HwID_in_8` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1140, "Input variable `Config.HWIDs.HwID_in_9` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1141, "Input variable `Config.HWIDs.HwID_CommandControl0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1142, "Input variable `Config.HWIDs.HwID_CommandControl1` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1143, "Input variable `Config.HWIDs.HwID_CommandControl2` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1144, "Input variable `Config.HWIDs.HwID_CommandControl3` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1145, "Input variable `Config.HWIDs.HwID_CommandControl4` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1146, "Input variable `Config.HWIDs.HwID_CommandControl5` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1147, "Input variable `Config.HWIDs.HwID_CommandControl6` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1148, "Input variable `Config.HWIDs.HwID_CommandControl7` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1149, "Input variable `Config.HWIDs.HwID_CommandControl8` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1150, "Input variable `Config.HWIDs.HwID_CommandControl9` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1151, "Input variable `Config.HWIDs.HwID_CommandStatusBits0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1152, "Input variable `Config.HWIDs.HwID_out_1` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1153, "Input variable `Config.HWIDs.HwID_out_2` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1154, "Input variable `Config.HWIDs.HwID_out_3` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1155, "Input variable `Config.HWIDs.HwID_out_4` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1156, "Input variable `Config.HWIDs.HwID_out_5` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1157, "Input variable `Config.HWIDs.HwID_out_6` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1158, "Input variable `Config.HWIDs.HwID_out_7` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1159, "Input variable `Config.HWIDs.HwID_out_8` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1160, "Input variable `Config.HWIDs.HwID_out_9` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1161, "Input variable `Config.HWIDs.HwID_out_10` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1162, "Input variable `Config.HWIDs.HwID_out_11` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1163, "Input variable `Config.HWIDs.HwID_out_12` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1164, "Input variable `Config.HWIDs.HwID_out_13` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1165, "Input variable `Config.HWIDs.HwID_out_14` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1166, "Input variable `Config.HWIDs.HwID_out_15` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1167, "Input variable `Config.HWIDs.HwID_out_16` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1168, "Input variable `Config.HWIDs.HwID_out_17` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1169, "Input variable `Config.HWIDs.HwID_out_18` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1170, "Input variable `Config.HWIDs.HwID_out_19` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1171, "Input variable `Config.HWIDs.HwID_out_20` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1201, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl!");
                    actionDescriptionDict.Add(1202, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandStatusBits!");
                    actionDescriptionDict.Add(1203, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_DeviceResultBits_1!");
                    actionDescriptionDict.Add(1204, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_DeviceStatusWords!");
                    actionDescriptionDict.Add(1205, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_DeviceStatistics!");
                    actionDescriptionDict.Add(1206, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_PositionAdjustResult!");
                    actionDescriptionDict.Add(1207, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_ToolResult_1!");
                    actionDescriptionDict.Add(1208, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_in_8!");
                    actionDescriptionDict.Add(1209, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_in_9!");
                    actionDescriptionDict.Add(1210, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl0!");
                    actionDescriptionDict.Add(1211, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl1!");
                    actionDescriptionDict.Add(1212, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl2!");
                    actionDescriptionDict.Add(1213, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl3!");
                    actionDescriptionDict.Add(1214, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl4!");
                    actionDescriptionDict.Add(1215, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl5!");
                    actionDescriptionDict.Add(1216, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl6!");
                    actionDescriptionDict.Add(1217, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl7!");
                    actionDescriptionDict.Add(1218, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl8!");
                    actionDescriptionDict.Add(1219, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandControl9!");
                    actionDescriptionDict.Add(1220, "Error reading the Axo_IV3InputStructureConfig.HWIDs.HwID_CommandStatusBits0!");
                    actionDescriptionDict.Add(1231, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_1!");
                    actionDescriptionDict.Add(1232, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_2!");
                    actionDescriptionDict.Add(1233, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_3!");
                    actionDescriptionDict.Add(1234, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_4!");
                    actionDescriptionDict.Add(1235, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_5!");
                    actionDescriptionDict.Add(1236, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_6!");
                    actionDescriptionDict.Add(1237, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_7!");
                    actionDescriptionDict.Add(1238, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_8!");
                    actionDescriptionDict.Add(1239, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_9!");
                    actionDescriptionDict.Add(1240, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_10!");
                    actionDescriptionDict.Add(1241, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_11!");
                    actionDescriptionDict.Add(1242, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_12!");
                    actionDescriptionDict.Add(1243, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_13!");
                    actionDescriptionDict.Add(1244, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_14!");
                    actionDescriptionDict.Add(1245, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_15!");
                    actionDescriptionDict.Add(1246, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_16!");
                    actionDescriptionDict.Add(1247, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_17!");
                    actionDescriptionDict.Add(1248, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_18!");
                    actionDescriptionDict.Add(1249, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_19!");
                    actionDescriptionDict.Add(1250, "Error writing the Axo_IV3OutputStructureConfig.HWIDs.HwID_out_20!");
                    // TemplateTask_10steps_1
                    actionDescriptionDict.Add(10000, "TemplateTask_10steps_1 finished with error!");
                    actionDescriptionDict.Add(10001, "TemplateTask_10steps_1 was aborted, while not yet completed!");
                    // TemplateTask_10steps_2
                    actionDescriptionDict.Add(10010, "TemplateTask_10steps_2 finished with error!");
                    actionDescriptionDict.Add(10011, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    // TemplateTask_10steps_3
                    actionDescriptionDict.Add(10020, "TemplateTask_10steps_3 finished with error!");
                    actionDescriptionDict.Add(10021, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    // TemplateTask_10steps_4
                    actionDescriptionDict.Add(10030, "TemplateTask_10steps_4 task finished with error!");
                    actionDescriptionDict.Add(10031, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_5
                    actionDescriptionDict.Add(10040, "TemplateTask_10steps_5 task finished with error!");
                    actionDescriptionDict.Add(10041, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_6
                    actionDescriptionDict.Add(10050, "TemplateTask_10steps_6 task finished with error!");
                    actionDescriptionDict.Add(10051, "TemplateTask_10steps_6 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_1
                    actionDescriptionDict.Add(10060, "TemplateTask_20steps_1 task finished with error!");
                    actionDescriptionDict.Add(10061, "TemplateTask_20steps_1 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_2
                    actionDescriptionDict.Add(10080, "TemplateTask_20steps_2 task finished with error!");
                    actionDescriptionDict.Add(10081, "TemplateTask_20steps_2 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_3
                    actionDescriptionDict.Add(10100, "TemplateTask_20steps_3 task finished with error!");
                    actionDescriptionDict.Add(10101, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_4
                    actionDescriptionDict.Add(10120, "TemplateTask_20steps_4 task finished with error!");
                    actionDescriptionDict.Add(10121, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_5
                    actionDescriptionDict.Add(10140, "TemplateTask_20steps_5 task finished with error!");
                    actionDescriptionDict.Add(10141, "TemplateTask_20steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_6
                    actionDescriptionDict.Add(10160, "TemplateTask_20steps_6 task finished with error!");
                    actionDescriptionDict.Add(10161, "TemplateTask_20steps_6 task was aborted, while not yet completed!");

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
