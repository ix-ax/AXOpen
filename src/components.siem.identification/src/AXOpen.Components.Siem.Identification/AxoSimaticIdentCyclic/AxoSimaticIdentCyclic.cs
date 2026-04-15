using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;
using AXOpen.Core;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXOpen.Components.Abstractions;

namespace AXOpen.Components.Siem.Identification
{
    public partial class AxoSimaticIdentCyclic 
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
                // ReadUID_Task
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("ReadUID_Task started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("ReadUID_Task finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("ReadUID_Task restored.","")),
                // ReadTagFieldTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("ReadTagFieldTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("ReadTagFieldTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("ReadTagFieldTask restored.","")),
                // WriteTagFieldTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("WriteTagFieldTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("WriteTagFieldTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("WriteTagFieldTask restored.","")),
                // ReadTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(130, new AxoMessengerTextItem("ReadTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(131, new AxoMessengerTextItem("ReadTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(132, new AxoMessengerTextItem("ReadTask restored.","")),
                // WriteTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("WriteTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("WriteTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("WriteTask restored.","")),
                // ResetTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("ResetTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("ResetTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("ResetTask restored.","")),
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwId` has invalid value in `Run` method!"                                                                      ,"Check the call of the `Run` method, if the `hwId` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_CM is zero."                                                                ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ID_1WCFG'."                  ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'."  ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'."  ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'."  ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(750, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(751, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(752, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(753, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(754, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(755, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(756, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'."  ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(760, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_6 is zero."                                                              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(761, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(762, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(763, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(764, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(765, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(766, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: 'gsd_id_of_req_module'."      ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(770, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_7 is zero."                                                              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(771, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(772, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(773, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(774, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(775, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(776, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'gsd_id_of_req_module'."      ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(780, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_8 is zero."                                                              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(781, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(782, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(783, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(784, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(785, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(786, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: 'gsd_id_of_req_module'."      ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(790, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_9 is zero."                                                              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(791, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(792, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(793, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(794, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(795, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(796, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: 'gsd_id_of_req_module'."      ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_10 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(802, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(803, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(804, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(805, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(806, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_11 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(812, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(813, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(814, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(815, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(816, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_12 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(822, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(823, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(824, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(825, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(826, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(830, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_13 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(831, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(832, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(833, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(834, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(835, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(836, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_14 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(842, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(843, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(844, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(845, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(846, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 14. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_15 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(852, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(853, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(854, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(855, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(856, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 15. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(860, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_16 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(861, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(862, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(863, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(864, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(865, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(866, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 16. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(870, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_17 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(871, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(872, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(873, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(874, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(875, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(876, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 17. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(880, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_18 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(881, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(882, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(883, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(884, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(885, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(886, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 18. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(890, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_19 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(891, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(892, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(893, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(894, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(895, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(896, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 19. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(900, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_in_20 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(901, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(902, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(903, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(904, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(905, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(906, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 20. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(910, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_1 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(911, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 21."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(912, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 21."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(913, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 21."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(914, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 21."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(915, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 21."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(916, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 21. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(920, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_2 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(921, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 22."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(922, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 22."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(923, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 22."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(924, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 22."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(925, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 22."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(926, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 22. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(930, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_3 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(931, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 23."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(932, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 23."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(933, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 23."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(934, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 23."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(935, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 23."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(936, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 23. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(940, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_4 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(941, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 24."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(942, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 24."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(943, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 24."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(944, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 24."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(945, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 24."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(946, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 24. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(950, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_5 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(951, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 25."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(952, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 25."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(953, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 25."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(954, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 25."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(955, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 25."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(956, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 25. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(960, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_6 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(961, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 26."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(962, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 26."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(963, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 26."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(964, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 26."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(965, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 26."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(966, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 26. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(970, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_7 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(971, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 27."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(972, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 27."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(973, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 27."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(974, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 27."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(975, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 27."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(976, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 27. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(980, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_8 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(981, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 28."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(982, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 28."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(983, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 28."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(984, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 28."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(985, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 28."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(986, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 28. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(990, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_9 is zero."                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(991, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 29."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(992, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 29."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(993, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 29."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(994, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 29."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(995, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 29."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(996, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 29. Expected module: 'gsd_id_of_req_module'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1000, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_10 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1001, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 30."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1002, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 30."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1003, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 30."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1004, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 30."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1005, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 30."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1006, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 30. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1010, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_11 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1011, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 31."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1012, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 31."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1013, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 31."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1014, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 31."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1015, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 31."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1016, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 31. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1020, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_12 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1021, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 32."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1022, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 32."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1023, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 32."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1024, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 32."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1025, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 32."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1026, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 32. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1030, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_13 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1031, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 33."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1032, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 33."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1033, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 33."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1034, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 33."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1035, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 33."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1036, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 33. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1040, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_14 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1041, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 34."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1042, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 34."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1043, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 34."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1044, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 34."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1045, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 34."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1046, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 34. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1050, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_15 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1051, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 35."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1052, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 35."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1053, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 35."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1054, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 35."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1055, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 35."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1056, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 35. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1060, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_16 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1061, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 36."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1062, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 36."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1063, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 36."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1064, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 36."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1065, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 36."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1066, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 36. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1070, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_17 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1071, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 37."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1072, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 37."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1073, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 37."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1074, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 37."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1075, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 37."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1076, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 37. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1080, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_18 is zero."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1081, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 38."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1082, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 38."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1083, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 38."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1084, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 38."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1085, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 38."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1086, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 38. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1090, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_19 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1091, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 39."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1092, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 39."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1093, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 39."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1094, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 39."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1095, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 39."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1096, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 39. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1100, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwID_out_20 is zero."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1101, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 40."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1102, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 40."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1103, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 40."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1104, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 40."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1105, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 40."             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1106, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 40. Expected module: 'gsd_id_of_req_module'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                  ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `Config.HWIDs.HW_Head` has invalid value in `Run` method!"                                                     ,"Check the call of the `Run` method, if the `Config.HWIDs.HW_Head` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Reader` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Reader` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1134, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Reader` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1135, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_Reader` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1136, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_5` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_5` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1137, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_6` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_6` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1138, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_7` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_7` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1139, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_8` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_8` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1140, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_9` has invalid value in `Run` method!"                                                   ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_9` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1141, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_10` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_10` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1142, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_11` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_11` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1143, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_12` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_12` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1144, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_13` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_13` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1145, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_14` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_14` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1146, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_15` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_15` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1147, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_16` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_16` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1148, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_17` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_17` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1149, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_18` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_18` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1150, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_19` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_19` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1151, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_in_20` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_in_20` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1152, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_1` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1153, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_2` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_2` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1154, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_3` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_3` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1155, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_4` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_4` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1156, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_5` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_5` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1157, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_6` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_6` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1158, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_7` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_7` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1159, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_8` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_8` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1160, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_9` has invalid value in `Run` method!"                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_9` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1161, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_10` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_10` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1162, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_11` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_11` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1163, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_12` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_12` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1164, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_13` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_13` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1165, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_14` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_14` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1166, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_15` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_15` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1167, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_16` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_16` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1168, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_17` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_17` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1169, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_18` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_18` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1170, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_19` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_19` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1171, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwID_out_20` has invalid value in `Run` method!"                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwID_out_20` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the input data from module of Config.HWIDs.HwID_CM!"                                                            ,"Check the value of the Config.HWIDs.HwID_CM and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1202, new AxoMessengerTextItem("Error reading the input data from module of Config.HWIDs.HwID_Reader!"                                                        ,"Check the value of the Config.HWIDs.HwID_Reader and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1203, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_3!"                                                                 ,"Check the value of the Config.HWIDs.HwID_in_3 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1204, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_4!"                                                                 ,"Check the value of the Config.HWIDs.HwID_in_4 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1205, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_5!"                                                                 ,"Check the value of the Config.HWIDs.HwID_in_5 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1206, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_6!"                                                                 ,"Check the value of the Config.HWIDs.HwID_in_6 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1207, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_7!"                                                                 ,"Check the value of the Config.HWIDs.HwID_in_7 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1208, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_8!"                                                                 ,"Check the value of the Config.HWIDs.HwID_in_8 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1209, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_9!"                                                                 ,"Check the value of the Config.HWIDs.HwID_in_9 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1210, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_10!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_10 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1211, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_11!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_11 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1212, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_12!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_12 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1213, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_13!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_13 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1214, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_14!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_14 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1215, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_15!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_15 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1216, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_16!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_16 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1217, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_17!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_17 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1218, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_18!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_18 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1219, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_19!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_19 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1220, new AxoMessengerTextItem("Error reading the TemplateComponentInputStructure_HwID_in_20!"                                                                ,"Check the value of the Config.HWIDs.HwID_in_20 and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the output data to module of Config.HWIDs.HwID_CM!"                                                             ,"Check the value of the Config.HWIDs.HwID_CM and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1232, new AxoMessengerTextItem("Error writing the 32 bytes of output data to module of Config.HWIDs.HwID_Reader!"                                             ,"Check the value of the Config.HWIDs.HwID_Reader and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1233, new AxoMessengerTextItem("Error writing the 116 bytes of output data to module of Config.HWIDs.HwID_Reader!"                                            ,"Check the value of the Config.HWIDs.HwID_Reader and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1234, new AxoMessengerTextItem("Error writing the 128 bytes of output data to module of Config.HWIDs.HwID_Reader!"                                            ,"Check the value of the Config.HWIDs.HwID_Reader and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1235, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_5!"                                                               ,"Check the value of the Config.HWIDs.HwID_out_5 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1236, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_6!"                                                               ,"Check the value of the Config.HWIDs.HwID_out_6 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1237, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_7!"                                                               ,"Check the value of the Config.HWIDs.HwID_out_7 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1238, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_8!"                                                               ,"Check the value of the Config.HWIDs.HwID_out_8 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1239, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_9!"                                                               ,"Check the value of the Config.HWIDs.HwID_out_9 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1240, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_10!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_10 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1241, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_11!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_11 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1242, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_12!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_12 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1243, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_13!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_13 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1244, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_14!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_14 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1245, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_15!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_15 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1246, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_16!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_16 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1247, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_17!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_17 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1248, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_18!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_18 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1249, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_19!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_19 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1250, new AxoMessengerTextItem("Error writing the TemplateComponentOutputStructure_HwID_out_20!"                                                              ,"Check the value of the Config.HWIDs.HwID_out_20 and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1301, new AxoMessengerTextItem("Length of the incomming data frame, oversizes the length of the data buffer in ReadUID_Task!"                                 ,"Increase the size of the data buffer used with this instance!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1302, new AxoMessengerTextItem("Length of the incomming data frame, oversizes the length of the data buffer in ReadTagFieldTask!"                             ,"Increase the size of the data buffer used with this instance!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1303, new AxoMessengerTextItem("Length of the incomming data frame, oversizes the length of the data buffer in ReadTask!"                                     ,"Increase the size of the data buffer used with this instance!")),

                // ReadUID_Task
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("ReadUID_Task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("ReadUID_Task was aborted, while not yet completed!","Check the details.")),
                // ReadTagFieldTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("ReadTagFieldTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("ReadTagFieldTask was aborted, while not yet completed!","Check the details.")),
                // WriteTagFieldTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10020, new AxoMessengerTextItem("WriteTagFieldTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10021, new AxoMessengerTextItem("WriteTagFieldTask was aborted, while not yet completed!","Check the details.")),
                // ReadTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10030, new AxoMessengerTextItem("ReadTask task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10031, new AxoMessengerTextItem("ReadTask task was aborted, while not yet completed!","Check the details.")),
                // WriteTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10040, new AxoMessengerTextItem("WriteTask task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10041, new AxoMessengerTextItem("WriteTask task was aborted, while not yet completed!","Check the details.")),
                // ResetTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10050, new AxoMessengerTextItem("ResetTask task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10051, new AxoMessengerTextItem("ResetTask task was aborted, while not yet completed!","Check the details.")),

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
                // ReadUID_Task
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!","Check the status of the `Inputs.Status.PRESENCE`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to `Outputs.Control.CMD` (1-ReadUID) !","Check the status of the `Inputs.Status.ACTIVECMD`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !","Check the status of the `Inputs.Status.NDR`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.BLOCK` to be set!","Check the status of the `Inputs.Status.BLOCK`  signal/variable.")),
                // ReadTagFieldTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!","Check the status of the `Inputs.Status.PRESENCE`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to `Outputs.Control.CMD`  (2-ReadTagField)!","Check the status of the `Inputs.Status.ACTIVECMD`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !","Check the status of the `Inputs.Status.NDR`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.BLOCK` to be set!","Check the status of the `Inputs.Status.BLOCK`  signal/variable.")),
                // WriteTagFieldTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!","Check the status of the `Inputs.Status.PRESENCE`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to `Outputs.Control.CMD` (3-WriteTagField)!","Check the status of the `Inputs.Status.ACTIVECMD`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !","Check the status of the `Inputs.Status.NDR`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to `Outputs.Control.CMD` (3-WriteTagField)!","Check the status of the `Inputs.Status.ACTIVECMD`  signal/variable.")),
                //ReadTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!","Check the status of the `Inputs.Status.PRESENCE`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to `Outputs.Control.CMD` (4-Read)!","Check the status of the `Inputs.Status.ACTIVECMD`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !","Check the status of the `Inputs.Status.NDR`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.BLOCK` to be set!","Check the status of the `Inputs.Status.BLOCK`  signal/variable.")),
                //WriteTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!","Check the status of the `Inputs.Status.PRESENCE`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to `Outputs.Control.CMD` 5-Write)!","Check the status of the `Inputs.Status.ACTIVECMD`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !","Check the status of the `Inputs.Status.NDR`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to `Outputs.Control.CMD` 5-Write)!","Check the status of the `Inputs.Status.ACTIVECMD`  signal/variable.")),
                //ResetTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.RESETCONF` to be set!","Check the status of the `Inputs.Status.RESETCONF`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the signal/variable `Inputs.Status.RESETCONF` to be reseted !","Check the status of the `Inputs.Status.RESETCONF`  signal/variable.")),
                
        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
    public partial class AxoSimaticIdentCyclic_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    // ReadUID_Task
                    errorDescriptionDict.Add(500, "Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!");
                    errorDescriptionDict.Add(502, "Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to Outputs.Control.CMD (1-ReadUID) !");
                    errorDescriptionDict.Add(503, "Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !");
                    errorDescriptionDict.Add(504, "Waiting for the signal/variable `Inputs.Status.BLOCK` to be set !");
                    // ReadTagFieldTask
                    errorDescriptionDict.Add(510, "Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!");
                    errorDescriptionDict.Add(512, "Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to Outputs.Control.CMD (2-ReadTagField) !");
                    errorDescriptionDict.Add(513, "Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !");
                    errorDescriptionDict.Add(514, "Waiting for the signal/variable `Inputs.Status.BLOCK` to be set !");
                    // WriteTagFieldTask
                    errorDescriptionDict.Add(520, "Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!");
                    errorDescriptionDict.Add(523, "Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to Outputs.Control.CMD (3-WriteTagField) !");
                    errorDescriptionDict.Add(524, "Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !");
                    errorDescriptionDict.Add(526, "Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to Outputs.Control.CMD (3-WriteTagField) !");
                    // ReadTask
                    errorDescriptionDict.Add(530, "Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!");
                    errorDescriptionDict.Add(532, "Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to Outputs.Control.CMD (4-Read) !");
                    errorDescriptionDict.Add(533, "Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !");
                    errorDescriptionDict.Add(534, "Waiting for the signal/variable `Inputs.Status.BLOCK` to be set !");
                    // WriteTask
                    errorDescriptionDict.Add(540, "Waiting for the signal/variable `Inputs.Status.PRESENCE` to be set!");
                    errorDescriptionDict.Add(543, "Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to Outputs.Control.CMD (5-Write) !");
                    errorDescriptionDict.Add(544, "Waiting for the signal/variable `Inputs.Status.NDR` to be inverted !");
                    errorDescriptionDict.Add(546, "Waiting for the signal/variable `Inputs.Status.ACTIVECMD` to be equal to Outputs.Control.CMD (5-Write) !");
                    // ResetTask
                    errorDescriptionDict.Add(550, "Waiting for the signal/variable `Inputs.Status.RESETCONF` to be set!");
                    errorDescriptionDict.Add(551, "Waiting for the signal/variable `Inputs.Status.RESETCONF` to be reseted !");
                    // General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                   );
                    errorDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!"                                                                      );
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_CM is zero."                                                                );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ID_1WCFG'."                  );
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero."                                                            );
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               );
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               );
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               );
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               );
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               );
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'."  );
                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero."                                                            );
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."               );
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."               );
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."               );
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."               );
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."               );
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'."  );
                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero."                                                            );
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."               );
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."               );
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."               );
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."               );
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."               );
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'."  );
                    errorDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero."                                                            );
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."               );
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."               );
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."               );
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."               );
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."               );
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'."  );
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!"                                                                  );
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HW_Head` has invalid value in `Run` method!"                                                     );
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!"                                                 );
                    errorDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!"                                                 );
                    errorDescriptionDict.Add(1134, "Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!"                                                 );
                    errorDescriptionDict.Add(1135, "Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!"                                                 );
                    errorDescriptionDict.Add(1201, "Error reading the input data from module of Config.HWIDs.HwID_CM!"                                                            );
                    errorDescriptionDict.Add(1202, "Error reading the input data from module of Config.HWIDs.HwID_Reader!"                                                        );
                    errorDescriptionDict.Add(1231, "Error writing the output data to module of Config.HWIDs.HwID_CM!"                                                             );
                    errorDescriptionDict.Add(1232, "Error writing the 32 bytes of output data to module of Config.HWIDs.HwID_Reader!"                                             );
                    errorDescriptionDict.Add(1233, "Error writing the 116 bytes of output data to module of Config.HWIDs.HwID_Reader!"                                            );
                    errorDescriptionDict.Add(1234, "Error writing the 128 bytes of output data to module of Config.HWIDs.HwID_Reader!"                                            );
                    errorDescriptionDict.Add(1301, "Length of the incomming data frame, oversizes the length of the data buffer in ReadUID_Task!"                                 );
                    errorDescriptionDict.Add(1302, "Length of the incomming data frame, oversizes the length of the data buffer in ReadTagFieldTask!"                             );
                    errorDescriptionDict.Add(1303, "Length of the incomming data frame, oversizes the length of the data buffer in ReadTask!");

                    // ReadUID_Task
                    errorDescriptionDict.Add(10000, "ReadUID_Task finished with error!");
                    errorDescriptionDict.Add(10001, "ReadUID_Task was aborted, while not yet completed!");
                    // ReadTagFieldTask
                    errorDescriptionDict.Add(10010, "ReadTagFieldTask finished with error!");
                    errorDescriptionDict.Add(10011, "ReadTagFieldTask was aborted, while not yet completed!");
                    // WriteTagFieldTask
                    errorDescriptionDict.Add(10020, "WriteTagFieldTask finished with error!");
                    errorDescriptionDict.Add(10021, "WriteTagFieldTask was aborted, while not yet completed!");
                    // ReadTask
                    errorDescriptionDict.Add(10030, "ReadTask task finished with error!");
                    errorDescriptionDict.Add(10031, "ReadTask task was aborted, while not yet completed!");
                    // WriteTask
                    errorDescriptionDict.Add(10040, "WriteTask task finished with error!");
                    errorDescriptionDict.Add(10041, "WriteTask task was aborted, while not yet completed!");
                    // ResetTask
                    errorDescriptionDict.Add(10050, "ResetTask task finished with error!");
                    errorDescriptionDict.Add(10051, "ResetTask task was aborted, while not yet completed!");
                    
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
                    // ReadUID_Task
                    actionDescriptionDict.Add(100, "ReadUID_Task started.");
                    actionDescriptionDict.Add(300, "ReadUID_Task running: waiting for the tag presence.");
                    actionDescriptionDict.Add(301, "ReadUID_Task running: command triggered.");
                    actionDescriptionDict.Add(302, "ReadUID_Task running: waiting for active command to be equal 1 (ReadUID).");
                    actionDescriptionDict.Add(303, "ReadUID_Task running: waiting for the new data.");
                    actionDescriptionDict.Add(304, "ReadUID_Task running: reading the data.");
                    actionDescriptionDict.Add(305, "ReadUID_Task running: cleaning the tail of the data buffer.");
                    actionDescriptionDict.Add(306, "ReadUID_Task finished.");
                    actionDescriptionDict.Add(101, "ReadUID_Task finished succesfully.");
                    actionDescriptionDict.Add(102, "ReadUID_Task restored.");
                    // ReadTagFieldTask
                    actionDescriptionDict.Add(110, "ReadTagFieldTask started.");
                    actionDescriptionDict.Add(310, "ReadTagFieldTask running: waiting for the tag presence.");
                    actionDescriptionDict.Add(311, "ReadTagFieldTask running: command triggered.");
                    actionDescriptionDict.Add(312, "ReadTagFieldTask running: waiting for active command to be equal 2 (ReadTagField).");
                    actionDescriptionDict.Add(313, "ReadTagFieldTask running: waiting for the new data.");
                    actionDescriptionDict.Add(314, "ReadTagFieldTask running: reading the data.");
                    actionDescriptionDict.Add(315, "ReadTagFieldTask running: cleaning the tail of the data buffer.");
                    actionDescriptionDict.Add(316, "ReadTagFieldTask finished.");
                    actionDescriptionDict.Add(111, "ReadTagFieldTask finished succesfully.");
                    actionDescriptionDict.Add(112, "ReadTagFieldTask restored.");
                    // WriteTagFieldTask
                    actionDescriptionDict.Add(120, "WriteTagFieldTask started.");
                    actionDescriptionDict.Add(320, "WriteTagFieldTask running: waiting for the tag presence.");
                    actionDescriptionDict.Add(321, "WriteTagFieldTask running: writing data header and first frame.");
                    actionDescriptionDict.Add(322, "WriteTagFieldTask running: command triggered.");
                    actionDescriptionDict.Add(323, "WriteTagFieldTask running: waiting for active command to be equal 3 (WriteTagField).");
                    actionDescriptionDict.Add(324, "WriteTagFieldTask running: waiting for the new data accepted.");
                    actionDescriptionDict.Add(325, "WriteTagFieldTask running: writing additional data frame.");
                    actionDescriptionDict.Add(326, "WriteTagFieldTask running: waiting for active command to be equal 3 (WriteTagField).");
                    actionDescriptionDict.Add(327, "WriteTagFieldTask finished.");
                    actionDescriptionDict.Add(121, "WriteTagFieldTask finished succesfully.");
                    actionDescriptionDict.Add(122, "WriteTagFieldTask restored.");
                    // ReadTask
                    actionDescriptionDict.Add(130, "ReadTask started.");
                    actionDescriptionDict.Add(330, "ReadTask running: waiting for the tag presence.");
                    actionDescriptionDict.Add(331, "ReadTask running: command triggered.");
                    actionDescriptionDict.Add(332, "ReadTask running: waiting for active command to be equal 4 (Read).");
                    actionDescriptionDict.Add(333, "ReadTask running: waiting for the new data.");
                    actionDescriptionDict.Add(334, "ReadTask running: reading the data.");
                    actionDescriptionDict.Add(335, "ReadTask running: cleaning the tail of the data buffer.");
                    actionDescriptionDict.Add(336, "ReadTask finished.");
                    actionDescriptionDict.Add(131, "ReadTask finished succesfully.");
                    actionDescriptionDict.Add(132, "ReadTask restored.");
                    // WriteTask
                    actionDescriptionDict.Add(140, "WriteTask started.");
                    actionDescriptionDict.Add(340, "WriteTask running, waiting for the tag presence.");
                    actionDescriptionDict.Add(341, "WriteTask running, writing data header and first frame.");
                    actionDescriptionDict.Add(342, "WriteTask running, command triggered.");
                    actionDescriptionDict.Add(343, "WriteTask running, waiting for active command to be equal 5 (Write).");
                    actionDescriptionDict.Add(344, "WriteTask running, waiting for the new data accepted.");
                    actionDescriptionDict.Add(345, "WriteTask running, writing additional data frame.");
                    actionDescriptionDict.Add(346, "WriteTask running, waiting for active command to be equal 5 (Write).");
                    actionDescriptionDict.Add(347, "WriteTask finished.");
                    actionDescriptionDict.Add(141, "WriteTask finished succesfully.");
                    actionDescriptionDict.Add(142, "WriteTask restored.");
                    // ResetTask
                    actionDescriptionDict.Add(150, "ResetTask started.");
                    actionDescriptionDict.Add(350, "ResetTask running: waiting for 'Inputs.Status.RESETCONF' to be on.");
                    actionDescriptionDict.Add(351, "ResetTask running: waiting for 'Inputs.Status.RESETCONF' to be off.");
                    actionDescriptionDict.Add(352, "ResetTask finished.");
                    actionDescriptionDict.Add(151, "ResetTask finished succesfully.");
                    actionDescriptionDict.Add(152, "ResetTask restored.");

                    // General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    actionDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwID_CM is zero.");
                    actionDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    actionDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    actionDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    actionDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    actionDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    actionDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ID_1WCFG'.");
                    actionDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero.");
                    actionDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    actionDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    actionDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    actionDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    actionDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    actionDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'.");
                    actionDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero.");
                    actionDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3.");
                    actionDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3.");
                    actionDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3.");
                    actionDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3.");
                    actionDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3.");
                    actionDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'.");
                    actionDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero.");
                    actionDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4.");
                    actionDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4.");
                    actionDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4.");
                    actionDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4.");
                    actionDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4.");
                    actionDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'.");
                    actionDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwID_Reader is zero.");
                    actionDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5.");
                    actionDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5.");
                    actionDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5.");
                    actionDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5.");
                    actionDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5.");
                    actionDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected modules:'ID_UNI_IO32,ID_UNI_IO128'.");
                    actionDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HW_Head` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1134, "Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1135, "Input variable `Config.HWIDs.HwID_Reader` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1201, "Error reading the input data from module of Config.HWIDs.HwID_CM!");
                    actionDescriptionDict.Add(1202, "Error reading the input data from module of Config.HWIDs.HwID_Reader!");
                    actionDescriptionDict.Add(1231, "Error writing the output data to module of Config.HWIDs.HwID_CM!");
                    actionDescriptionDict.Add(1232, "Error writing the 32 bytes of output data to module of Config.HWIDs.HwID_Reader!");
                    actionDescriptionDict.Add(1233, "Error writing the 116 bytes of output data to module of Config.HWIDs.HwID_Reader!");
                    actionDescriptionDict.Add(1234, "Error writing the 128 bytes of output data to module of Config.HWIDs.HwID_Reader!");
                    actionDescriptionDict.Add(1301, "Length of the incomming data frame, oversizes the length of the data buffer in ReadUID_Task!");
                    actionDescriptionDict.Add(1302, "Length of the incomming data frame, oversizes the length of the data buffer in ReadTagFieldTask!");
                    actionDescriptionDict.Add(1303, "Length of the incomming data frame, oversizes the length of the data buffer in ReadTask!");
                    // ReadUID_Task
                    actionDescriptionDict.Add(10000, "ReadUID_Task finished with error!");
                    actionDescriptionDict.Add(10001, "ReadUID_Task was aborted, while not yet completed!");
                    // ReadTagFieldTask
                    actionDescriptionDict.Add(10010, "ReadTagFieldTask finished with error!");
                    actionDescriptionDict.Add(10011, "ReadTagFieldTask was aborted, while not yet completed!");
                    // WriteTagFieldTask
                    actionDescriptionDict.Add(10020, "WriteTagFieldTask finished with error!");
                    actionDescriptionDict.Add(10021, "WriteTagFieldTask was aborted, while not yet completed!");
                    // ReadTask
                    actionDescriptionDict.Add(10030, "ReadTask task finished with error!");
                    actionDescriptionDict.Add(10031, "ReadTask task was aborted, while not yet completed!");
                    // WriteTask
                    actionDescriptionDict.Add(10040, "WriteTask task finished with error!");
                    actionDescriptionDict.Add(10041, "WriteTask task was aborted, while not yet completed!");
                    // ResetTask
                    actionDescriptionDict.Add(10050, "ResetTask task finished with error!");
                    actionDescriptionDict.Add(10051, "ResetTask task was aborted, while not yet completed!");

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
