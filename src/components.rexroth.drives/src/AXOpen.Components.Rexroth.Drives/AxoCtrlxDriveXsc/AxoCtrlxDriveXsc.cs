using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Rexroth.Drives
{
    public partial class AxoCtrlxDriveXsc
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(300, new AxoMessengerTextItem("Movement to the positive direction disabled!"                                                                                                                                          ,"Check the safety conditions.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(301, new AxoMessengerTextItem("Movement to the negative direction disabled!"                                                                                                                                          ,"Check the safety conditions.")),
                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                                                                           ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwId` has invalid value in `Run` method!"                                                                                                                              ,"Check the call of the `Run` method, if the `hwId` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                                                ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of _HW_Outputs is zero."                                                                                                                                 ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'Outputs' (GsdId=ID_M_XCS_INI_0_cons)."                                               ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of _HW_Inputs is zero."                                                                                                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'Inputs' (GsdId=ID_M_XCS_INI_0_prod)."                                                ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0134_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 1. Expected GsdId of the submodule: 'ID_SM_Master_control_word_S_0_0134_0_0_cons'."            ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0145_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 2. Expected GsdId of the submodule: 'ID_SM_Signal_control_word_S_0_0145_0_0_cons'."            ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(750, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0282_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(751, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(752, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(753, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(754, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(755, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(756, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 3. Expected GsdId of the submodule: 'ID_SM_Positioning_command_value_S_0_0282_0_0_cons'."      ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(760, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0259_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(761, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(762, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(763, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(764, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(765, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(766, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 4. Expected GsdId of the submodule: 'ID_SM_Positioning_velocity_S_0_0259_0_0_cons'."           ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(770, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0260_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(771, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(772, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(773, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(774, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(775, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(776, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 5. Expected GsdId of the submodule: 'ID_SM_Positioning_acceleration_S_0_0260_0_0_cons'."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(780, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0359_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(781, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(782, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(783, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(784, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(785, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(786, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 6. Expected GsdId of the submodule: 'ID_SM_Positioning_deceleration_S_0_0359_0_0_cons'."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(790, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_1720_0_1 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(791, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(792, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(793, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(794, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(795, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(796, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 7. Expected GsdId of the submodule: 'ID_SM_Power_supply_control_word_S_0_1720_0_1_cons'."      ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0092_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(802, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(803, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(804, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(805, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(806, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 8. Expected GsdId of the submodule:'ID_SM_Bipolar_torque_force_limit_value_S_0_0092_0_0_cons'.","Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0080_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 9."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(812, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 9."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(813, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 9."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(814, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 9."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(815, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 9."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(816, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 9. Expected GsdId of the submodule: 'ID_SM_Torque_force_command_value_S_0_0080_0_0_cons'."     ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0193_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 10."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(822, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 10."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(823, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 10."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(824, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 10."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(825, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 10."                                                           ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(826, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 10. Expected GsdId of the submodule: 'ID_SM_Positioning_jerk_S_0_0193_0_0_cons'."              ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(830, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0135_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(831, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(832, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(833, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(834, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(835, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 1."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(836, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 1. Expected GsdId of the submodule: 'ID_SM_Drive_status_word_S_0_0135_0_0_prod'."              ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0144_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(842, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(843, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(844, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(845, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 2."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(846, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 2. Expected GsdId of the submodule: 'ID_SM_Signal_status_word_S_0_0144_0_0_prod'."             ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0386_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(852, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(853, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(854, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(855, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 3."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(856, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 3. Expected GsdId of the submodule: 'ID_SM_Active_position_feedback_value_S_0_0386_0_0_prod'." ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(860, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0535_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(861, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(862, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(863, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(864, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(865, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 4."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(866, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 4. Expected GsdId of the submodule: 'ID_SM_Active_velocity_feedback_value_S_0_0535_0_0_prod'." ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(870, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0390_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(871, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(872, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(873, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(874, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(875, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 5."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(876, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 5. Expected GsdId of the submodule: 'ID_SM_Diagnostic_message_number_S_0_0390_0_0_prod'."      ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(880, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_1720_0_2 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(881, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(882, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(883, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(884, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(885, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 6."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(886, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 6. Expected GsdId of the submodule: 'ID_SM_Power_supply_status_word_S_0_1720_0_2_prod'."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(890, new AxoMessengerTextItem("Hw configuration error. Value of _HW_S_0_0084_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(891, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(892, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(893, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(894, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(895, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 7."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(896, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 7. Expected GsdId of the submodule: 'ID_SM_Torque_force_feedback_value_S_0_0084_0_0_prod'."    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(900, new AxoMessengerTextItem("Hw configuration error. Value of _HW_P_0_0106_0_0 is zero."                                                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(901, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(902, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(903, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(904, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(905, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 8."                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(906, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 8. Expected GsdId of the submodule: 'ID_SM_Operating_status_STO_P_0_0106_0_0_prod'."             ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `hwId` has invalid value in `Run` method!"                                                                      ,"Check the call of the `Run` method, if the `hwId` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `_HW_Outputs` has invalid value in `Run` method!"                                                               ,"Check the call of the `Run` method, if the `_HW_Outputs` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Input variable `_HW_Inputs` has invalid value in `Run` method!"                                                                ,"Check the call of the `Run` method, if the `_HW_Inputs` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1134, new AxoMessengerTextItem("Input variable `_HW_S_0_0134_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0134_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1135, new AxoMessengerTextItem("Input variable `_HW_S_0_0145_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0145_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1136, new AxoMessengerTextItem("Input variable `_HW_S_0_0282_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0282_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1137, new AxoMessengerTextItem("Input variable `_HW_S_0_0259_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0259_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1138, new AxoMessengerTextItem("Input variable `_HW_S_0_0260_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0260_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1139, new AxoMessengerTextItem("Input variable `_HW_S_0_0359_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0359_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1140, new AxoMessengerTextItem("Input variable `_HW_S_0_1720_0_1' has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_1720_0_1' parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1141, new AxoMessengerTextItem("Input variable `_HW_S_0_0092_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0092_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1142, new AxoMessengerTextItem("Input variable `_HW_S_0_0080_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0080_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1143, new AxoMessengerTextItem("Input variable `_HW_S_0_0193_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0193_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1144, new AxoMessengerTextItem("Input variable `_HW_S_0_0135_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0135_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1145, new AxoMessengerTextItem("Input variable `_HW_S_0_0144_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0144_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1146, new AxoMessengerTextItem("Input variable `_HW_S_0_0386_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0386_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1147, new AxoMessengerTextItem("Input variable `_HW_S_0_0535_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0535_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1148, new AxoMessengerTextItem("Input variable `_HW_S_0_0390_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0390_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1149, new AxoMessengerTextItem("Input variable `_HW_S_0_1720_0_2` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_1720_0_2` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1150, new AxoMessengerTextItem("Input variable `_HW_S_0_0084_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_S_0_0084_0_0` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1151, new AxoMessengerTextItem("Input variable `_HW_P_0_0106_0_0` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `_HW_P_0_0106_0_0` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the DriveStatusWord_S_0_0135_0_0!"                                                                              ,"Check the value of the _HW_S_0_0135_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1202, new AxoMessengerTextItem("Error reading the SignalStatusWord_S_0_0144_0_0!"                                                                             ,"Check the value of the _HW_S_0_0144_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1203, new AxoMessengerTextItem("Error reading the ActualPosition_S_0_0386_0_0!"                                                                               ,"Check the value of the _HW_S_0_0386_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1204, new AxoMessengerTextItem("Error reading the ActualVelocity_S_0_0535_0_0!"                                                                               ,"Check the value of the _HW_S_0_0535_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1205, new AxoMessengerTextItem("Error reading the DiagnosticMessage_S_0_0390_0_0!"                                                                            ,"Check the value of the _HW_S_0_0390_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1206, new AxoMessengerTextItem("Error reading the SupplyUnitStatusWord_S_0_1720_0_2!"                                                                         ,"Check the value of the _HW_S_0_1720_0_2 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1207, new AxoMessengerTextItem("Error reading the ActualTorque_S_0_0084_0_0!"                                                                                 ,"Check the value of the _HW_S_0_0084_0_0 and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the DriveControlWord_S_0_0134_0_0!"                                                                             ,"Check the value of the _HW_S_0_0134_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1232, new AxoMessengerTextItem("Error writing the SignalControlWord_S_0_0145_0_0!"                                                                            ,"Check the value of the _HW_S_0_0145_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1233, new AxoMessengerTextItem("Error writing the CommandPosition_S_0_0282_0_0!"                                                                              ,"Check the value of the _HW_S_0_0282_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1234, new AxoMessengerTextItem("Error writing the CommandVelocity_S_0_0259_0_0!"                                                                              ,"Check the value of the _HW_S_0_0259_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1235, new AxoMessengerTextItem("Error writing the CommandAcceleration_S_0_0260_0_0!"                                                                          ,"Check the value of the _HW_S_0_0260_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1236, new AxoMessengerTextItem("Error writing the CommandDecceleration_S_0_0359_0_0!"                                                                         ,"Check the value of the _HW_S_0_0359_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1237, new AxoMessengerTextItem("Error writing the SupplyUnitControlWord_S_0_1720_0_1!"                                                                        ,"Check the value of the _HW_S_0_1720_0_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1238, new AxoMessengerTextItem("Error writing the BipolarTorqueLimitation_S_0_0092_0_0!"                                                                      ,"Check the value of the _HW_S_0_0092_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1239, new AxoMessengerTextItem("Error writing the CommandTorque_S_0_0080_0_0!"                                                                                ,"Check the value of the _HW_S_0_0080_0_0 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1240, new AxoMessengerTextItem("Error writing the CommandJerk_S_0_0193_0_0!"                                                                                  ,"Check the value of the _HW_S_0_0193_0_0 and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1430, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_Power method!"                                                                    ,"Check the value of the AxisRef at the input of the MC_Power method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1440, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_Home method!"                                                                     ,"Check the value of the AxisRef at the input of the MC_Home method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1441, new AxoMessengerTextItem("Negative or zero value of the Acceleration in the MC_Home method!"                                                            ,"Check the value of the required Acceleration at the input of the MC_Home method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1442, new AxoMessengerTextItem("Negative or zero value of the Deceleration in the MC_Home method!"                                                            ,"Check the value of the required Deceleration at the input of the MC_Home method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1470, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_Stop method!"                                                                     ,"Check the value of the AxisRef at the input of the MC_Stop method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1471, new AxoMessengerTextItem("Negative or zero value of the Deceleration in the MC_Stop method!"                                                            ,"Check the value of the required Deceleration at the input of the MC_Stop method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1472, new AxoMessengerTextItem("Negative or zero value of the Jerk in the MC_Stop method!"                                                                    ,"Check the value of the required Jerk at the input of the MC_Stop method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1490, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_MoveAbsolute method!"                                                             ,"Check the value of the AxisRef at the input of the MC_MoveAbsolute method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1491, new AxoMessengerTextItem("Negative or zero value of the Velocity in the MC_MoveAbsolute method!"                                                        ,"Check the value of the required Velocity at the input of the MC_MoveAbsolute method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1492, new AxoMessengerTextItem("Negative or zero value of the Acceleration in the MC_MoveAbsolute method!"                                                    ,"Check the value of the required Acceleration at the input of the MC_MoveAbsolute method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1493, new AxoMessengerTextItem("Negative or zero value of the Deceleration in the MC_MoveAbsolute method!"                                                    ,"Check the value of the required Deceleration at the input of the MC_MoveAbsolute method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1494, new AxoMessengerTextItem("Negative or zero value of the Jerk in the MC_MoveAbsolute method!"                                                            ,"Check the value of the required Jerk at the input of the MC_MoveAbsolute method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1500, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_MoveRelative method!"                                                             ,"Check the value of the AxisRef at the input of the MC_MoveRelative method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1501, new AxoMessengerTextItem("Negative or zero value of the Velocity in the MC_MoveRelative method!"                                                        ,"Check the value of the required Velocity at the input of the MC_MoveRelative method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1502, new AxoMessengerTextItem("Negative or zero value of the Acceleration in the MC_MoveRelative method!"                                                    ,"Check the value of the required Acceleration at the input of the MC_MoveRelative method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1503, new AxoMessengerTextItem("Negative or zero value of the Deceleration in the MC_MoveRelative method!"                                                    ,"Check the value of the required Deceleration at the input of the MC_MoveRelative method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1504, new AxoMessengerTextItem("Negative or zero value of the Jerk in the MC_MoveRelative method!"                                                            ,"Check the value of the required Jerk at the input of the MC_MoveRelative method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1510, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_MoveAdditive method!"                                                             ,"Check the value of the AxisRef at the input of the MC_MoveAdditive method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1511, new AxoMessengerTextItem("Negative or zero value of the Velocity in the MC_MoveAdditive method!"                                                        ,"Check the value of the required Velocity at the input of the MC_MoveAdditive method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1512, new AxoMessengerTextItem("Negative or zero value of the Acceleration in the MC_MoveAdditive method!"                                                    ,"Check the value of the required Acceleration at the input of the MC_MoveAdditive method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1513, new AxoMessengerTextItem("Negative or zero value of the Deceleration in the MC_MoveAdditive method!"                                                    ,"Check the value of the required Deceleration at the input of the MC_MoveAdditive method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1514, new AxoMessengerTextItem("Negative or zero value of the Jerk in the MC_MoveAdditive method!"                                                            ,"Check the value of the required Jerk at the input of the MC_MoveAdditive method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1520, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_MoveVelocity method!"                                                             ,"Check the value of the AxisRef at the input of the MC_MoveVelocity method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1521, new AxoMessengerTextItem("Invalid value of the Direction in the MC_MoveVelocity method!"                                                                ,"Check the value of the required Direction at the input of the MC_MoveVelocity method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1522, new AxoMessengerTextItem("Zero value of the Velocity in the MC_MoveVelocity method!"                                                                    ,"Check the value of the required Velocity at the input of the MC_MoveVelocity method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1523, new AxoMessengerTextItem("Negative or zero value of the Acceleration in the MC_MoveVelocity method!"                                                    ,"Check the value of the required Acceleration at the input of the MC_MoveVelocity method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1524, new AxoMessengerTextItem("Negative or zero value of the Deceleration in the MC_MoveVelocity method!"                                                    ,"Check the value of the required Deceleration at the input of the MC_MoveVelocity method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1525, new AxoMessengerTextItem("Negative or zero value of the Jerk in the MC_MoveVelocity method!"                                                            ,"Check the value of the required Jerk at the input of the MC_MoveVelocity method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1530, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_TorqueControl method!"                                                            ,"Check the value of the AxisRef at the input of the MC_TorqueControl method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1531, new AxoMessengerTextItem("Invalid value of the Direction in the MC_TorqueControl method!"                                                               ,"Check the value of the required Direction at the input of the MC_TorqueControl method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1532, new AxoMessengerTextItem("Negative or zero value of the Velocity in the MC_TorqueControl method!"                                                       ,"Check the value of the required Velocity at the input of the MC_TorqueControl method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1533, new AxoMessengerTextItem("Negative or zero value of the Acceleration in the MC_TorqueControl method!"                                                   ,"Check the value of the required Acceleration at the input of the MC_TorqueControl method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1534, new AxoMessengerTextItem("Negative or zero value of the Deceleration in the MC_TorqueControl method!"                                                   ,"Check the value of the required Deceleration at the input of the MC_TorqueControl method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1535, new AxoMessengerTextItem("Negative or zero value of the Jerk in the MC_TorqueControl method!"                                                           ,"Check the value of the required Jerk at the input of the MC_TorqueControl method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1536, new AxoMessengerTextItem("Zero value of the Torque in the MC_TorqueControl method!"                                                                     ,"Check the value of the required Torque at the input of the MC_TorqueControl method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1537, new AxoMessengerTextItem("Negative or zero value of the TorqueRamp in the MC_TorqueControl method!"                                                     ,"Check the value of the required TorqueRamp at the input of the MC_TorqueControl method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1540, new AxoMessengerTextItem("Error writing Torque/force control: Ramp value (0x2838:01 / S-0-0822 / --) in the MC_TorqueControl method!"                   ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1541, new AxoMessengerTextItem("Error writing Torque/force control: Ramp time (0x2838:02 / S-0-0823 / --) in the MC_TorqueControl method!"                    ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1542, new AxoMessengerTextItem("Error writing Torque/force control: High velocity limit value (P-0-0421.0.3 / P-0-2249) in the MC_TorqueControl method!"      ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1543, new AxoMessengerTextItem("Error writing Torque/force control: Low velocity limit value (P-0-0421.0.4 / P-0-2250) in the MC_TorqueControl method!"       ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1550, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_SetPosition method!"                                                              ,"Check the value of the AxisRef at the input of the MC_SetPosition method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1551, new AxoMessengerTextItem("Error writing Homing configuration ENC_1: Home offset (0x607C:00 / S-0-0052 / --) in the MC_SetPosition method!"              ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1570, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_SetOverride method!"                                                              ,"Check the value of the AxisRef at the input of the MC_SetOverride method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1571, new AxoMessengerTextItem("Invalid value of the VelocityFactor in the MC_SetOverride method!"                                                            ,"Check the value of the required VelocityFactor at the input of the MC_SetOverride method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1572, new AxoMessengerTextItem("Invalid value of the AccelerationFactor in the MC_SetOverride method!"                                                        ,"Check the value of the required AccelerationFactor at the input of the MC_SetOverride method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1573, new AxoMessengerTextItem("Invalid value of the JerkFactor in the MC_MoveRelative method!"                                                               ,"Check the value of the required JerkFactor at the input of the MC_SetOverride method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1580, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_ReadParameter method!"                                                            ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1581, new AxoMessengerTextItem("Error reading parameter  in the MC_ReadParameter method!"                                                                     ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1590, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_ReadRealParameter method!"                                                        ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1591, new AxoMessengerTextItem("Error reading parameter  in the MC_ReadRealParameter method!"                                                                 ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1600, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_ReadBoolParameter method!"                                                        ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1601, new AxoMessengerTextItem("Error reading parameter  in the MC_ReadBoolParameter method!"                                                                 ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1610, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_WriteParameter method!"                                                           ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1611, new AxoMessengerTextItem("Error writing parameter  in the MC_WriteParameter method!"                                                                    ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1620, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_WriteRealParameter method!"                                                       ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1621, new AxoMessengerTextItem("Error writing parameter  in the MC_WriteRealParameter method!"                                                                ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1630, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_WriteBoolParameter method!"                                                       ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1631, new AxoMessengerTextItem("Error writing parameter  in the MC_WriteBoolParameter method!"                                                                ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1640, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_ReadDigitalInput method!"                                                         ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1641, new AxoMessengerTextItem("Invalid InputNumber  in the MC_ReadDigitalInput method!"                                                                      ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1642, new AxoMessengerTextItem("Error reading parameter  in the MC_ReadDigitalInput method!"                                                                  ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1650, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_ReadDigitalOutput method!"                                                        ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1651, new AxoMessengerTextItem("Invalid OutputNumber  in the MC_ReadDigitalOutput method!"                                                                    ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1652, new AxoMessengerTextItem("Error reading parameter  in the MC_ReadDigitalOutput method!"                                                                 ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1660, new AxoMessengerTextItem("Null reference of the AxisRef inside the MC_WriteDigitalOutput method!"                                                       ,"Check the value of the AxisRef at the input of the MC_ReadParameter method!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1661, new AxoMessengerTextItem("Invalid OutputNumber  in the MC_WriteDigitalOutput method!"                                                                   ,"Check the device manual!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1662, new AxoMessengerTextItem("Error writing parameter  in the MC_WriteDigitalOutput method!"                                                                ,"Check the device manual!")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(1800, new AxoMessengerTextItem("Scaling parameters not yet read out of the drive"                                                                             ,"Check proper value of the device Hardware ID")),

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
                // MC_Home
                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be reseted !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be reseted !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be reseted !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(518,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be reseted !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(519,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signals '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill` to be set !","Check the status of the '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(525,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(527,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(528,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(529,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                // MC_Stop
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(537,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(538,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(539,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_Halt
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(547,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_MoveAbsolute
                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(553,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(554,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(555,  new AxoMessengerTextItem("Waiting for the signal '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck` to match the value of the '_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue' signal !","Check the values of the '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck' and `_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(556,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` to be set !","Check the status of the `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(557,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(558,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(559,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_MoveRelative
                new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(561,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(563,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(564,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(565,  new AxoMessengerTextItem("Waiting for the signal '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck` to match the value of the '_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue' signal !","Check the values of the '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck' and `_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(566,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` to be set !","Check the status of the `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(567,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(568,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(569,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_MoveAdditive
                new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(572,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(573,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(574,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(575,  new AxoMessengerTextItem("Waiting for the signal '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck` to match the value of the '_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue' signal !","Check the values of the '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck' and `_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(576,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` to be set !","Check the status of the `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(577,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(578,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(579,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_MoveVelocity
                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(581,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(582,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(583,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(584,  new AxoMessengerTextItem("Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(585,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(586,  new AxoMessengerTextItem("Waiting for the drive to reach the target velocity !","Check the values of the required and actual velocity.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(587,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(588,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(589,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_TorqueControl
                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(592,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(593,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(594,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(595,  new AxoMessengerTextItem("Waiting for the signal `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0' to be set, and signals '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2`  signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(596,  new AxoMessengerTextItem("Waiting for the drive to reach the target torque !","Check the values of the required and actual torque.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(597,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(598,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(599,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_SetPosition
                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601,  new AxoMessengerTextItem("Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference` to be reseted !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be set !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done` to be reseted !","Check the status of the `_WriteRecord.done`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604,  new AxoMessengerTextItem("Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(605,  new AxoMessengerTextItem("Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !","Check the status of the `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` signals.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(606,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(607,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(608,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(609,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_ReadParameter
                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be set !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be reseted !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(616,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(617,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(618,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(619,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_ReadRealParameter
                new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be set !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be reseted !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(623,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(624,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(625,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(626,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(627,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(628,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(629,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_ReadBoolParameter
                new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be set !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be reseted !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(633,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(634,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(635,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(636,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(637,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(638,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(639,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_WriteParameter
                new KeyValuePair<ulong, AxoMessengerTextItem>(640,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done ` to be set !","Check the status of the `_WriteRecord.done `  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(641,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done ` to be reseted !","Check the status of the `_WriteRecord.done `  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(642,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(643,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(644,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(645,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(646,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(647,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(648,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(649,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_WriteRealParameter
                new KeyValuePair<ulong, AxoMessengerTextItem>(650,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done ` to be set !","Check the status of the `_WriteRecord.done `  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(651,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done ` to be reseted !","Check the status of the `_WriteRecord.done `  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(652,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(653,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(654,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(655,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(656,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(657,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(658,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(659,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_WriteBoolParameter
                new KeyValuePair<ulong, AxoMessengerTextItem>(660,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done ` to be set !","Check the status of the `_WriteRecord.done `  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(661,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done ` to be reseted !","Check the status of the `_WriteRecord.done `  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(662,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(663,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(664,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(665,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(666,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(667,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(668,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(669,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_ReadDigitalInput
                new KeyValuePair<ulong, AxoMessengerTextItem>(670,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be set !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(671,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be reseted !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(672,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(673,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(674,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(675,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(676,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(677,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(678,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(679,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_ReadDigitalOutput
                new KeyValuePair<ulong, AxoMessengerTextItem>(680,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be set !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(681,  new AxoMessengerTextItem("Waiting for the signal/variable `_ReadRecord.valid` to be reseted !","Check the status of the `_ReadRecord.valid`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(682,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(683,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(684,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(685,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(686,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(687,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(688,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(689,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                //MC_WriteDigitalOutput
                new KeyValuePair<ulong, AxoMessengerTextItem>(690,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done ` to be set !","Check the status of the `_WriteRecord.done `  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(691,  new AxoMessengerTextItem("Waiting for the signal/variable `_WriteRecord.done ` to be reseted !","Check the status of the `_WriteRecord.done `  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(692,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(693,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(694,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(695,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(696,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(697,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(698,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(699,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>`  signal/variable.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoCtrlxDriveXsc_Component_Status : AXOpen.Components.Drives.AxoDrive_Status
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
                    errorDescriptionDict.Add(510, "Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference` to be reseted !");
                    errorDescriptionDict.Add(511, "Waiting for the signal/variable `_WriteRecord.done` to be set !");
                    errorDescriptionDict.Add(512, "Waiting for the signal/variable `_WriteRecord.done` to be reseted !" );
                    errorDescriptionDict.Add(513, "Waiting for the signal/variable `_WriteRecord.done` to be set !"     );
                    errorDescriptionDict.Add(514, "Waiting for the signal/variable `_WriteRecord.done` to be reseted !" );
                    errorDescriptionDict.Add(515, "Waiting for the signal/variable `_WriteRecord.done` to be set !"     );
                    errorDescriptionDict.Add(516, "Waiting for the signal/variable `_WriteRecord.done` to be reseted !" );
                    errorDescriptionDict.Add(517, "Waiting for the signal/variable `_WriteRecord.done` to be set !"     );
                    errorDescriptionDict.Add(518, "Waiting for the signal/variable `_WriteRecord.done` to be reseted !" );
                    errorDescriptionDict.Add(519, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !");
                    errorDescriptionDict.Add(520, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !");
                    errorDescriptionDict.Add(521, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(522, "Waiting for the signals '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill` to be set !");
                    errorDescriptionDict.Add(523, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(524, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(525, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(526, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(527, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(528, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(529, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(530, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(531, "Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill` to be set !");
                    errorDescriptionDict.Add(532, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(533, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(534, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(535, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(536, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(537, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(538, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(539, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(540, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(541, "Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill` to be set !");
                    errorDescriptionDict.Add(542, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(543, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(544, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(545, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(546, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(547, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(548, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(549, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(550, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(551, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !");
                    errorDescriptionDict.Add(552, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !");
                    errorDescriptionDict.Add(553, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(554, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(555, "Waiting for the signal '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck` to match the value of the '_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue' signal !");
                    errorDescriptionDict.Add(556, "Waiting for the signals `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` to be set !");
                    errorDescriptionDict.Add(557, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(558, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(559, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(560, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(561, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !");
                    errorDescriptionDict.Add(562, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !");
                    errorDescriptionDict.Add(563, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(564, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(565, "Waiting for the signal '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck` to match the value of the '_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue' signal !");
                    errorDescriptionDict.Add(566, "Waiting for the signals `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` to be set !");
                    errorDescriptionDict.Add(567, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(568, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(569, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(570, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(571, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !");
                    errorDescriptionDict.Add(572, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !");
                    errorDescriptionDict.Add(573, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(574, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(575, "Waiting for the signal '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck` to match the value of the '_AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue' signal !");
                    errorDescriptionDict.Add(576, "Waiting for the signals `_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill' and '_AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition` to be set !");
                    errorDescriptionDict.Add(577, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(578, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(579, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(580, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(581, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0', '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !");
                    errorDescriptionDict.Add(582, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !");
                    errorDescriptionDict.Add(583, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(584, "Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill` to be reseted !");
                    errorDescriptionDict.Add(585, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(586, "Waiting for the drive to reach the target velocity !");
                    errorDescriptionDict.Add(587, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(588, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(589, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(590, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(591, "Waiting for the signal/variable `_WriteRecord.done` to be set !");
                    errorDescriptionDict.Add(592, "Waiting for the signal/variable `_WriteRecord.done` to be set !");
                    errorDescriptionDict.Add(593, "Waiting for the signal/variable `_WriteRecord.done` to be set !");
                    errorDescriptionDict.Add(594, "Waiting for the signal/variable `_WriteRecord.done` to be set !");
                    errorDescriptionDict.Add(595, "Waiting for the signal `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0' to be set, and signals '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2` to be reseted !");
                    errorDescriptionDict.Add(596, "Waiting for the drive to reach the target torque !");
                    errorDescriptionDict.Add(597, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(598, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(599, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(600, "Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0` to be reseted !");
                    errorDescriptionDict.Add(601, "Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference` to be reseted !");
                    errorDescriptionDict.Add(602, "Waiting for the signal/variable `_WriteRecord.done` to be set !");
                    errorDescriptionDict.Add(603, "Waiting for the signal/variable `_WriteRecord.done` to be reseted !");
                    errorDescriptionDict.Add(604, "Waiting for the signal/variable `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference` to be set !");
                    errorDescriptionDict.Add(605, "Waiting for the signals `_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0' and '_AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1` to be set !");
                    errorDescriptionDict.Add(606, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(607, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(608, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(609, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(610, "Waiting for the signal/variable `_ReadRecord.valid` to be set !");
                    errorDescriptionDict.Add(611, "Waiting for the signal/variable `_ReadRecord.valid` to be reseted !"); 
                    errorDescriptionDict.Add(612, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(613, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(614, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(615, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(616, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(617, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(618, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(619, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(620, "Waiting for the signal/variable `_ReadRecord.valid` to be set !");
                    errorDescriptionDict.Add(621, "Waiting for the signal/variable `_ReadRecord.valid` to be reseted !");
                    errorDescriptionDict.Add(622, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(623, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(624, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(625, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(626, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(627, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(628, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(629, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(630, "Waiting for the signal/variable `_ReadRecord.valid` to be set !");
                    errorDescriptionDict.Add(631, "Waiting for the signal/variable `_ReadRecord.valid` to be reseted !");
                    errorDescriptionDict.Add(632, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(633, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(634, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(635, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(636, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(637, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(638, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(639, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(640, "Waiting for the signal/variable `_WriteRecord.done ` to be set !");
                    errorDescriptionDict.Add(641, "Waiting for the signal/variable `_WriteRecord.done ` to be reseted !");
                    errorDescriptionDict.Add(642, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(643, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(644, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(645, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(646, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(647, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(648, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(649, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(650, "Waiting for the signal/variable `_WriteRecord.done ` to be set !");
                    errorDescriptionDict.Add(651, "Waiting for the signal/variable `_WriteRecord.done ` to be reseted !");
                    errorDescriptionDict.Add(652, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(653, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(654, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(655, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(656, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(657, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(658, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(659, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(660, "Waiting for the signal/variable `_WriteRecord.done ` to be set !");
                    errorDescriptionDict.Add(661, "Waiting for the signal/variable `_WriteRecord.done ` to be reseted !");
                    errorDescriptionDict.Add(662, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(663, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(664, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(665, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(666, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(667, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(668, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(669, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(670, "Waiting for the signal/variable `_ReadRecord.valid` to be set !");
                    errorDescriptionDict.Add(671, "Waiting for the signal/variable `_ReadRecord.valid` to be reseted !");
                    errorDescriptionDict.Add(672, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(673, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(674, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(675, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(676, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(677, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(678, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(679, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(680, "Waiting for the signal/variable `_ReadRecord.valid` to be set !");
                    errorDescriptionDict.Add(681, "Waiting for the signal/variable `_ReadRecord.valid` to be reseted !");
                    errorDescriptionDict.Add(682, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(683, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(684, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(685, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(686, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(687, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(688, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(689, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(690, "Waiting for the signal/variable `_WriteRecord.done ` to be set !");
                    errorDescriptionDict.Add(691, "Waiting for the signal/variable `_WriteRecord.done ` to be reseted !");
                    errorDescriptionDict.Add(692, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(693, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(694, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(695, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(696, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(697, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(698, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(699, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // General alarms
                    errorDescriptionDict.Add(300, "Movement to the positive direction disabled!"                                                                                                                                          );
                    errorDescriptionDict.Add(301, "Movement to the negative direction disabled!"                                                                                                                                          );
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                                                                           );
                    errorDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!"                                                                                                                              );
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                                                );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of _HW_Outputs is zero."                                                                                                                                 );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                                                       );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                                                       );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                                                       );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                                                       );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                                                       );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'Outputs' (GsdId=ID_M_XCS_INI_0_cons)."                                               );
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of _HW_Inputs is zero."                                                                                                                                  );
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                                                                       );
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                                                                       );
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                                                                       );
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                                                                       );
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                                                                       );
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'Inputs' (GsdId=ID_M_XCS_INI_0_prod)."                                                );
                    errorDescriptionDict.Add(730, "Hw configuration error. Value of _HW_S_0_0134_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 1."                                                            );
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 1."                                                            );
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 1."                                                            );
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 1."                                                            );
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 1."                                                            );
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 1. Expected GsdId of the submodule: 'ID_SM_Master_control_word_S_0_0134_0_0_cons'."            );
                    errorDescriptionDict.Add(740, "Hw configuration error. Value of _HW_S_0_0145_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 2."                                                            );
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 2."                                                            );
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 2."                                                            );
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 2."                                                            );
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 2."                                                            );
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 2. Expected GsdId of the submodule: 'ID_SM_Signal_control_word_S_0_0145_0_0_cons'."            );
                    errorDescriptionDict.Add(750, "Hw configuration error. Value of _HW_S_0_0282_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 3."                                                            );
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 3."                                                            );
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 3."                                                            );
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 3."                                                            );
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 3."                                                            );
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 3. Expected GsdId of the submodule: 'ID_SM_Positioning_command_value_S_0_0282_0_0_cons'."      );
                    errorDescriptionDict.Add(760, "Hw configuration error. Value of _HW_S_0_0259_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 4."                                                            );
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 4."                                                            );
                    errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 4."                                                            );
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 4."                                                            );
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 4."                                                            );
                    errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 4. Expected GsdId of the submodule: 'ID_SM_Positioning_velocity_S_0_0259_0_0_cons'."           );
                    errorDescriptionDict.Add(770, "Hw configuration error. Value of _HW_S_0_0260_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 5."                                                            );
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 5."                                                            );
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 5."                                                            );
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 5."                                                            );
                    errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 5."                                                            );
                    errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 5. Expected GsdId of the submodule: 'ID_SM_Positioning_acceleration_S_0_0260_0_0_cons'."       );
                    errorDescriptionDict.Add(780, "Hw configuration error. Value of _HW_S_0_0359_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 6."                                                            );
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 6."                                                            );
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 6."                                                            );
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 6."                                                            );
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 6."                                                            );
                    errorDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 6. Expected GsdId of the submodule: 'ID_SM_Positioning_deceleration_S_0_0359_0_0_cons'."       );
                    errorDescriptionDict.Add(790, "Hw configuration error. Value of _HW_S_0_1720_0_1 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 7."                                                            );
                    errorDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 7."                                                            );
                    errorDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 7."                                                            );
                    errorDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 7."                                                            );
                    errorDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 7."                                                            );
                    errorDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 7. Expected GsdId of the submodule: 'ID_SM_Power_supply_control_word_S_0_1720_0_1_cons'."      );
                    errorDescriptionDict.Add(800, "Hw configuration error. Value of _HW_S_0_0092_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 8."                                                            );
                    errorDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 8."                                                            );
                    errorDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 8."                                                            );
                    errorDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 8."                                                            );
                    errorDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 8."                                                            );
                    errorDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 8. Expected GsdId of the submodule:'ID_SM_Bipolar_torque_force_limit_value_S_0_0092_0_0_cons'.");
                    errorDescriptionDict.Add(810, "Hw configuration error. Value of _HW_S_0_0080_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 9."                                                            );
                    errorDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 9."                                                            );
                    errorDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 9."                                                            );
                    errorDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 9."                                                            );
                    errorDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 9."                                                            );
                    errorDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 9. Expected GsdId of the submodule: 'ID_SM_Torque_force_command_value_S_0_0080_0_0_cons'."     );
                    errorDescriptionDict.Add(820, "Hw configuration error. Value of _HW_S_0_0193_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 10."                                                           );
                    errorDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 10."                                                           );
                    errorDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 10."                                                           );
                    errorDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 10."                                                           );
                    errorDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 10."                                                           );
                    errorDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 10. Expected GsdId of the submodule: 'ID_SM_Positioning_jerk_S_0_0193_0_0_cons'."              );
                    errorDescriptionDict.Add(830, "Hw configuration error. Value of _HW_S_0_0135_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 1."                                                            );
                    errorDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 1."                                                            );
                    errorDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 1."                                                            );
                    errorDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 1."                                                            );
                    errorDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 1."                                                            );
                    errorDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 1. Expected GsdId of the submodule: 'ID_SM_Drive_status_word_S_0_0135_0_0_prod'."              );
                    errorDescriptionDict.Add(840, "Hw configuration error. Value of _HW_S_0_0144_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 2."                                                            );
                    errorDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 2."                                                            );
                    errorDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 2."                                                            );
                    errorDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 2."                                                            );
                    errorDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 2."                                                            );
                    errorDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 2. Expected GsdId of the submodule: 'ID_SM_Signal_status_word_S_0_0144_0_0_prod'."             );
                    errorDescriptionDict.Add(850, "Hw configuration error. Value of _HW_S_0_0386_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(851, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 3."                                                            );
                    errorDescriptionDict.Add(852, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 3."                                                            );
                    errorDescriptionDict.Add(853, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 3."                                                            );
                    errorDescriptionDict.Add(854, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 3."                                                            );
                    errorDescriptionDict.Add(855, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 3."                                                            );
                    errorDescriptionDict.Add(856, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 3. Expected GsdId of the submodule: 'ID_SM_Active_position_feedback_value_S_0_0386_0_0_prod'." );
                    errorDescriptionDict.Add(860, "Hw configuration error. Value of _HW_S_0_0535_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(861, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 4."                                                            );
                    errorDescriptionDict.Add(862, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 4."                                                            );
                    errorDescriptionDict.Add(863, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 4."                                                            );
                    errorDescriptionDict.Add(864, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 4."                                                            );
                    errorDescriptionDict.Add(865, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 4."                                                            );
                    errorDescriptionDict.Add(866, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 4. Expected GsdId of the submodule: 'ID_SM_Active_velocity_feedback_value_S_0_0535_0_0_prod'." );
                    errorDescriptionDict.Add(870, "Hw configuration error. Value of _HW_S_0_0390_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(871, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 5."                                                            );
                    errorDescriptionDict.Add(872, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 5."                                                            );
                    errorDescriptionDict.Add(873, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 5."                                                            );
                    errorDescriptionDict.Add(874, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 5."                                                            );
                    errorDescriptionDict.Add(875, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 5."                                                            );
                    errorDescriptionDict.Add(876, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 5. Expected GsdId of the submodule: 'ID_SM_Diagnostic_message_number_S_0_0390_0_0_prod'."      );
                    errorDescriptionDict.Add(880, "Hw configuration error. Value of _HW_S_0_1720_0_2 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(881, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 6."                                                            );
                    errorDescriptionDict.Add(882, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 6."                                                            );
                    errorDescriptionDict.Add(883, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 6."                                                            );
                    errorDescriptionDict.Add(884, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 6."                                                            );
                    errorDescriptionDict.Add(885, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 6."                                                            );
                    errorDescriptionDict.Add(886, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 6. Expected GsdId of the submodule: 'ID_SM_Power_supply_status_word_S_0_1720_0_2_prod'."       );
                    errorDescriptionDict.Add(890, "Hw configuration error. Value of _HW_S_0_0084_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(891, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 7."                                                            );
                    errorDescriptionDict.Add(892, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 7."                                                            );
                    errorDescriptionDict.Add(893, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 7."                                                            );
                    errorDescriptionDict.Add(894, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 7."                                                            );
                    errorDescriptionDict.Add(895, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 7."                                                            );
                    errorDescriptionDict.Add(896, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 7. Expected GsdId of the submodule: 'ID_SM_Torque_force_feedback_value_S_0_0084_0_0_prod'."    );
                    errorDescriptionDict.Add(900, "Hw configuration error. Value of _HW_P_0_0106_0_0 is zero."                                                                                                                            );
                    errorDescriptionDict.Add(901, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 8."                                                            );
                    errorDescriptionDict.Add(902, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 8."                                                            );
                    errorDescriptionDict.Add(903, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 8."                                                            );
                    errorDescriptionDict.Add(904, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 8."                                                            );
                    errorDescriptionDict.Add(905, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 8."                                                            );
                    errorDescriptionDict.Add(906, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 8. Expected GsdId of the submodule: 'ID_SM_Operating_status_STO_P_0_0106_0_0_prod'.");
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!"                                                                 );
                    errorDescriptionDict.Add(1131, "Input variable `hwId` has invalid value in `Run` method!"                                                                    );
                    errorDescriptionDict.Add(1132, "Input variable `_HW_Outputs` has invalid value in `Run` method!"                                                             );
                    errorDescriptionDict.Add(1133, "Input variable `_HW_Inputs` has invalid value in `Run` method!"                                                              );
                    errorDescriptionDict.Add(1134, "Input variable `_HW_S_0_0134_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1135, "Input variable `_HW_S_0_0145_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1136, "Input variable `_HW_S_0_0282_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1137, "Input variable `_HW_S_0_0259_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1138, "Input variable `_HW_S_0_0260_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1139, "Input variable `_HW_S_0_0359_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1140, "Input variable `_HW_S_0_1720_0_1' has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1141, "Input variable `_HW_S_0_0092_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1142, "Input variable `_HW_S_0_0080_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1143, "Input variable `_HW_S_0_0193_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1144, "Input variable `_HW_S_0_0135_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1145, "Input variable `_HW_S_0_0144_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1146, "Input variable `_HW_S_0_0386_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1147, "Input variable `_HW_S_0_0535_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1148, "Input variable `_HW_S_0_0390_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1149, "Input variable `_HW_S_0_1720_0_2` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1150, "Input variable `_HW_S_0_0084_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1151, "Input variable `_HW_P_0_0106_0_0` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1201, "Error reading the DriveStatusWord_S_0_0135_0_0!"                                                                             );
                    errorDescriptionDict.Add(1202, "Error reading the SignalStatusWord_S_0_0144_0_0!"                                                                            );
                    errorDescriptionDict.Add(1203, "Error reading the ActualPosition_S_0_0386_0_0!"                                                                              );
                    errorDescriptionDict.Add(1204, "Error reading the ActualVelocity_S_0_0535_0_0!"                                                                              );
                    errorDescriptionDict.Add(1205, "Error reading the DiagnosticMessage_S_0_0390_0_0!"                                                                           );
                    errorDescriptionDict.Add(1206, "Error reading the SupplyUnitStatusWord_S_0_1720_0_2!"                                                                        );
                    errorDescriptionDict.Add(1207, "Error reading the ActualTorque_S_0_0084_0_0!"                                                                                );
                    errorDescriptionDict.Add(1231, "Error writing the DriveControlWord_S_0_0134_0_0!"                                                                            );
                    errorDescriptionDict.Add(1232, "Error writing the SignalControlWord_S_0_0145_0_0!"                                                                           );
                    errorDescriptionDict.Add(1233, "Error writing the CommandPosition_S_0_0282_0_0!"                                                                             );
                    errorDescriptionDict.Add(1234, "Error writing the CommandVelocity_S_0_0259_0_0!"                                                                             );
                    errorDescriptionDict.Add(1235, "Error writing the CommandAcceleration_S_0_0260_0_0!"                                                                         );
                    errorDescriptionDict.Add(1236, "Error writing the CommandDecceleration_S_0_0359_0_0!"                                                                        );
                    errorDescriptionDict.Add(1237, "Error writing the SupplyUnitControlWord_S_0_1720_0_1!"                                                                       );
                    errorDescriptionDict.Add(1238, "Error writing the BipolarTorqueLimitation_S_0_0092_0_0!"                                                                     );
                    errorDescriptionDict.Add(1239, "Error writing the CommandTorque_S_0_0080_0_0!"                                                                               );
                    errorDescriptionDict.Add(1240, "Error writing the CommandJerk_S_0_0193_0_0!"                                                                                 );
                    errorDescriptionDict.Add(1430, "Null reference of the AxisRef inside the MC_Power method!"                                                                   );
                    errorDescriptionDict.Add(1440, "Null reference of the AxisRef inside the MC_Home method!"                                                                    );
                    errorDescriptionDict.Add(1441, "Negative or zero value of the Acceleration in the MC_Home method!"                                                           );
                    errorDescriptionDict.Add(1442, "Negative or zero value of the Deceleration in the MC_Home method!"                                                           );
                    errorDescriptionDict.Add(1470, "Null reference of the AxisRef inside the MC_Stop method!"                                                                    );
                    errorDescriptionDict.Add(1471, "Negative or zero value of the Deceleration in the MC_Stop method!"                                                           );
                    errorDescriptionDict.Add(1472, "Negative or zero value of the Jerk in the MC_Stop method!"                                                                   );
                    errorDescriptionDict.Add(1490, "Null reference of the AxisRef inside the MC_MoveAbsolute method!"                                                            );
                    errorDescriptionDict.Add(1491, "Negative or zero value of the Velocity in the MC_MoveAbsolute method!"                                                       );
                    errorDescriptionDict.Add(1492, "Negative or zero value of the Acceleration in the MC_MoveAbsolute method!"                                                   );
                    errorDescriptionDict.Add(1493, "Negative or zero value of the Deceleration in the MC_MoveAbsolute method!"                                                   );
                    errorDescriptionDict.Add(1494, "Negative or zero value of the Jerk in the MC_MoveAbsolute method!"                                                           );
                    errorDescriptionDict.Add(1500, "Null reference of the AxisRef inside the MC_MoveRelative method!"                                                            );
                    errorDescriptionDict.Add(1501, "Negative or zero value of the Velocity in the MC_MoveRelative method!"                                                       );
                    errorDescriptionDict.Add(1502, "Negative or zero value of the Acceleration in the MC_MoveRelative method!"                                                   );
                    errorDescriptionDict.Add(1503, "Negative or zero value of the Deceleration in the MC_MoveRelative method!"                                                   );
                    errorDescriptionDict.Add(1504, "Negative or zero value of the Jerk in the MC_MoveRelative method!"                                                           );
                    errorDescriptionDict.Add(1510, "Null reference of the AxisRef inside the MC_MoveAdditive method!"                                                            );
                    errorDescriptionDict.Add(1511, "Negative or zero value of the Velocity in the MC_MoveAdditive method!"                                                       );
                    errorDescriptionDict.Add(1512, "Negative or zero value of the Acceleration in the MC_MoveAdditive method!"                                                   );
                    errorDescriptionDict.Add(1513, "Negative or zero value of the Deceleration in the MC_MoveAdditive method!"                                                   );
                    errorDescriptionDict.Add(1514, "Negative or zero value of the Jerk in the MC_MoveAdditive method!"                                                           );
                    errorDescriptionDict.Add(1520, "Null reference of the AxisRef inside the MC_MoveVelocity method!"                                                            );
                    errorDescriptionDict.Add(1521, "Invalid value of the Direction in the MC_MoveVelocity method!"                                                               );
                    errorDescriptionDict.Add(1522, "Zero value of the Velocity in the MC_MoveVelocity method!"                                                                   );
                    errorDescriptionDict.Add(1523, "Negative or zero value of the Acceleration in the MC_MoveVelocity method!"                                                   );
                    errorDescriptionDict.Add(1524, "Negative or zero value of the Deceleration in the MC_MoveVelocity method!"                                                   );
                    errorDescriptionDict.Add(1525, "Negative or zero value of the Jerk in the MC_MoveVelocity method!"                                                           );
                    errorDescriptionDict.Add(1530, "Null reference of the AxisRef inside the MC_TorqueControl method!"                                                           );
                    errorDescriptionDict.Add(1531, "Invalid value of the Direction in the MC_TorqueControl method!"                                                              );
                    errorDescriptionDict.Add(1532, "Negative or zero value of the Velocity in the MC_TorqueControl method!"                                                      );
                    errorDescriptionDict.Add(1533, "Negative or zero value of the Acceleration in the MC_TorqueControl method!"                                                  );
                    errorDescriptionDict.Add(1534, "Negative or zero value of the Deceleration in the MC_TorqueControl method!"                                                  );
                    errorDescriptionDict.Add(1535, "Negative or zero value of the Jerk in the MC_TorqueControl method!"                                                          );
                    errorDescriptionDict.Add(1536, "Zero value of the Torque in the MC_TorqueControl method!"                                                                    );
                    errorDescriptionDict.Add(1537, "Negative or zero value of the TorqueRamp in the MC_TorqueControl method!"                                                    );
                    errorDescriptionDict.Add(1540, "Error writing Torque/force control: Ramp value (0x2838:01 / S-0-0822 / --) in the MC_TorqueControl method!"                  );
                    errorDescriptionDict.Add(1541, "Error writing Torque/force control: Ramp time (0x2838:02 / S-0-0823 / --) in the MC_TorqueControl method!"                   );
                    errorDescriptionDict.Add(1542, "Error writing Torque/force control: High velocity limit value (P-0-0421.0.3 / P-0-2249) in the MC_TorqueControl method!"     );
                    errorDescriptionDict.Add(1543, "Error writing Torque/force control: Low velocity limit value (P-0-0421.0.4 / P-0-2250) in the MC_TorqueControl method!"      );
                    errorDescriptionDict.Add(1550, "Null reference of the AxisRef inside the MC_SetPosition method!"                                                             );
                    errorDescriptionDict.Add(1551, "Error writing Homing configuration ENC_1: Home offset (0x607C:00 / S-0-0052 / --) in the MC_SetPosition method!"             );
                    errorDescriptionDict.Add(1570, "Null reference of the AxisRef inside the MC_SetOverride method!"                                                             );
                    errorDescriptionDict.Add(1571, "Invalid value of the VelocityFactor in the MC_SetOverride method!"                                                           );
                    errorDescriptionDict.Add(1572, "Invalid value of the AccelerationFactor in the MC_SetOverride method!"                                                       );
                    errorDescriptionDict.Add(1573, "Invalid value of the JerkFactor in the MC_MoveRelative method!"                                                              );
                    errorDescriptionDict.Add(1580, "Null reference of the AxisRef inside the MC_ReadParameter method!"                                                           );
                    errorDescriptionDict.Add(1581, "Error reading parameter  in the MC_ReadParameter method!"                                                                    );
                    errorDescriptionDict.Add(1590, "Null reference of the AxisRef inside the MC_ReadRealParameter method!"                                                       );
                    errorDescriptionDict.Add(1591, "Error reading parameter  in the MC_ReadRealParameter method!"                                                                );
                    errorDescriptionDict.Add(1600, "Null reference of the AxisRef inside the MC_ReadBoolParameter method!"                                                       );
                    errorDescriptionDict.Add(1601, "Error reading parameter  in the MC_ReadBoolParameter method!"                                                                );
                    errorDescriptionDict.Add(1610, "Null reference of the AxisRef inside the MC_WriteParameter method!"                                                          );
                    errorDescriptionDict.Add(1611, "Error writing parameter  in the MC_WriteParameter method!"                                                                   );
                    errorDescriptionDict.Add(1620, "Null reference of the AxisRef inside the MC_WriteRealParameter method!"                                                      );
                    errorDescriptionDict.Add(1621, "Error writing parameter  in the MC_WriteRealParameter method!"                                                               );
                    errorDescriptionDict.Add(1630, "Null reference of the AxisRef inside the MC_WriteBoolParameter method!"                                                      );
                    errorDescriptionDict.Add(1631, "Error writing parameter  in the MC_WriteBoolParameter method!"                                                               );
                    errorDescriptionDict.Add(1640, "Null reference of the AxisRef inside the MC_ReadDigitalInput method!"                                                        );
                    errorDescriptionDict.Add(1641, "Invalid InputNumber  in the MC_ReadDigitalInput method!"                                                                     );
                    errorDescriptionDict.Add(1642, "Error reading parameter  in the MC_ReadDigitalInput method!"                                                                 );
                    errorDescriptionDict.Add(1650, "Null reference of the AxisRef inside the MC_ReadDigitalOutput method!"                                                       );
                    errorDescriptionDict.Add(1651, "Invalid OutputNumber  in the MC_ReadDigitalOutput method!"                                                                   );
                    errorDescriptionDict.Add(1652, "Error reading parameter  in the MC_ReadDigitalOutput method!"                                                                );
                    errorDescriptionDict.Add(1660, "Null reference of the AxisRef inside the MC_WriteDigitalOutput method!"                                                      );
                    errorDescriptionDict.Add(1661, "Invalid OutputNumber  in the MC_WriteDigitalOutput method!"                                                                  );
                    errorDescriptionDict.Add(1662, "Error writing parameter  in the MC_WriteDigitalOutput method!"                                                               );
                    errorDescriptionDict.Add(1800, "Scaling parameters not yet read out of the drive"                                                                            );
                                                                                                                                                                                                                           
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
                    // MC_Home
                    actionDescriptionDict.Add(310, "MC_Home running, Reseting InReference flag");
                    actionDescriptionDict.Add(311, "MC_Home running, Writing Homing configuration ENC_1: Home offset (0x607C:00 / S-0-0052 / --)");
                    actionDescriptionDict.Add(312, "MC_Home running, Canceling write record proces.");
                    actionDescriptionDict.Add(313, "MC_Home running, Writing Homing function: Configuration (0x2500:02 / S-0-0147 / --)");
                    actionDescriptionDict.Add(314, "MC_Home running, Canceling write record proces.");
                    actionDescriptionDict.Add(315, "MC_Home running, Writing Homing speeds: Speed during search for switch (0x6099:01 / S-0-0041 / --)");
                    actionDescriptionDict.Add(316, "MC_Home running, Canceling write record proces.");
                    actionDescriptionDict.Add(317, "MC_Home running, Writing Homing acceleration (0x609A:00 / S-0-0042 / --)");
                    actionDescriptionDict.Add(318, "MC_Home running, Canceling write record proces.");
                    actionDescriptionDict.Add(319, "MC_Home running, Setting the primary operation mode. (Drive-controlled positioning).");
                    actionDescriptionDict.Add(320, "MC_Home running, Waiting for the drive to be enabled.");
                    actionDescriptionDict.Add(321, "MC_Home running, Triggering motion.");
                    actionDescriptionDict.Add(322, "MC_Home running, Waiting for drive to finish the motion.");
                    actionDescriptionDict.Add(323, "MC_Home finished");
                    actionDescriptionDict.Add(327, "MC_Home finished succesfully");
                    actionDescriptionDict.Add(328, "MC_Home has been interupted");
                    actionDescriptionDict.Add(329, "MC_Home finished with an error.");
                    // MC_Stop
                    actionDescriptionDict.Add(330, "MC_Stop started");
                    actionDescriptionDict.Add(331, "MC_Stop running, Breaking");
                    actionDescriptionDict.Add(332, "MC_Stop running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(333, "MC_Stop running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(334, "MC_Stop running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(335, "MC_Stop running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(336, "MC_Stop finished");
                    actionDescriptionDict.Add(337, "MC_Stop finished succesfully");
                    actionDescriptionDict.Add(338, "MC_Stop has been interupted");
                    actionDescriptionDict.Add(339, "MC_Stop finished with an error.");
                    // MC_Halt
                    actionDescriptionDict.Add(340, "MC_Halt started");
                    actionDescriptionDict.Add(341, "MC_Halt running, Breaking");
                    actionDescriptionDict.Add(342, "MC_Halt running, <add the detailed description of the current action 3>");
                    actionDescriptionDict.Add(343, "MC_Halt running, <add the detailed description of the current action 4>");
                    actionDescriptionDict.Add(344, "MC_Halt running, <add the detailed description of the current action 5>");
                    actionDescriptionDict.Add(345, "MC_Halt running, <add the detailed description of the current action 6>");
                    actionDescriptionDict.Add(346, "MC_Halt finished");
                    actionDescriptionDict.Add(347, "MC_Halt finished succesfully");
                    actionDescriptionDict.Add(348, "MC_Halt has been interupted");
                    actionDescriptionDict.Add(349, "MC_Halt finished with an error.");
                    // MC_MoveAbsolute
                    actionDescriptionDict.Add(350, "MC_MoveAbsolute started, Checking input parameters.");
                    actionDescriptionDict.Add(351, "MC_MoveAbsolute running, Setting the primary operation mode. (Drive - controlled positioning).");
                    actionDescriptionDict.Add(352, "MC_MoveAbsolute running, Waiting for the drive to be enabled.");
                    actionDescriptionDict.Add(353, "MC_MoveAbsolute running, Enabling motion.");
                    actionDescriptionDict.Add(354, "MC_MoveAbsolute running, Triggering motion.");
                    actionDescriptionDict.Add(355, "MC_MoveAbsolute running, Waiting for drive to acknowledge the motion parameters.");
                    actionDescriptionDict.Add(356, "MC_MoveAbsolute running, Waiting for drive to finish the motion.");
                    actionDescriptionDict.Add(357, "MC_MoveAbsolute finished succesfully");
                    actionDescriptionDict.Add(358, "MC_MoveAbsolute has been interupted");
                    actionDescriptionDict.Add(359, "MC_MoveAbsolute finished with an error.");
                    // MC_MoveRelative
                    actionDescriptionDict.Add(360, "MC_MoveRelative started, Checking input parameters.");
                    actionDescriptionDict.Add(361, "MC_MoveRelative running, Setting the primary operation mode. (Drive - controlled positioning).");
                    actionDescriptionDict.Add(362, "MC_MoveRelative running, Waiting for the drive to be enabled.");
                    actionDescriptionDict.Add(363, "MC_MoveRelative running, Enabling motion.");
                    actionDescriptionDict.Add(364, "MC_MoveRelative running, Triggering motion.");
                    actionDescriptionDict.Add(365, "MC_MoveRelative running, Waiting for drive to acknowledge the motion parameters.");
                    actionDescriptionDict.Add(366, "MC_MoveRelative running, Waiting for drive to finish the motion.");
                    actionDescriptionDict.Add(367, "MC_MoveRelative finished succesfully");
                    actionDescriptionDict.Add(368, "MC_MoveRelative has been interupted");
                    actionDescriptionDict.Add(369, "MC_MoveRelative finished with an error.");
                    // MC_MoveAdditive
                    actionDescriptionDict.Add(370, "MC_MoveAdditive started, Checking input parameters.");
                    actionDescriptionDict.Add(371, "MC_MoveAdditive running, Setting the primary operation mode. (Drive - controlled positioning).");
                    actionDescriptionDict.Add(372, "MC_MoveAdditive running, Waiting for the drive to be enabled.");
                    actionDescriptionDict.Add(373, "MC_MoveAdditive running, Enabling motion.");
                    actionDescriptionDict.Add(374, "MC_MoveAdditive running, Triggering motion.");
                    actionDescriptionDict.Add(375, "MC_MoveAdditive running, Waiting for drive to acknowledge the motion parameters.");
                    actionDescriptionDict.Add(376, "MC_MoveAdditive running, Waiting for drive to finish the motion.");
                    actionDescriptionDict.Add(377, "MC_MoveAdditive finished succesfully");
                    actionDescriptionDict.Add(378, "MC_MoveAdditive has been interupted");
                    actionDescriptionDict.Add(379, "MC_MoveAdditive finished with an error.");
                    // MC_MoveVelocity
                    actionDescriptionDict.Add(380, "MC_MoveVelocity started, Checking input parameters.");
                    actionDescriptionDict.Add(381, "MC_MoveVelocity running, Setting the primary operation mode. (Drive - controlled positioning).");
                    actionDescriptionDict.Add(382, "MC_MoveVelocity running, Waiting for the drive to be enabled.");
                    actionDescriptionDict.Add(383, "MC_MoveVelocity running, Enabling motion.");
                    actionDescriptionDict.Add(384, "MC_MoveVelocity running, Triggering motion.");
                    actionDescriptionDict.Add(385, "MC_MoveVelocity running, Waiting for drive to reach the required velocity.");
                    actionDescriptionDict.Add(386, "MC_MoveVelocity finished");
                    actionDescriptionDict.Add(387, "MC_MoveVelocity finished succesfully");
                    actionDescriptionDict.Add(388, "MC_MoveVelocity has been interupted");
                    actionDescriptionDict.Add(389, "MC_MoveVelocity finished with an error.");
                    // MC_TorqueControl
                    actionDescriptionDict.Add(390, "MC_TorqueControl started, Checking input parameters.");
                    actionDescriptionDict.Add(391, "MC_TorqueControl running, Setting the secondary operation mode. (Torque/force control).");
                    actionDescriptionDict.Add(392, "MC_TorqueControl running, Waiting for the drive to be enabled.");
                    actionDescriptionDict.Add(393, "MC_TorqueControl running, Enabling motion.");
                    actionDescriptionDict.Add(394, "MC_TorqueControl running, Triggering motion.");
                    actionDescriptionDict.Add(395, "MC_TorqueControl running, Waiting for drive to reach the required torque.");
                    actionDescriptionDict.Add(396, "MC_TorqueControl finished");
                    actionDescriptionDict.Add(397, "MC_TorqueControl finished succesfully");
                    actionDescriptionDict.Add(398, "MC_TorqueControl has been interupted");
                    actionDescriptionDict.Add(399, "MC_TorqueControl finished with an error.");
                    // MC_SetPosition
                    actionDescriptionDict.Add(400, "MC_SetPosition started, Powering off.");
                    actionDescriptionDict.Add(401, "MC_SetPosition running, Reseting InReference flag");
                    actionDescriptionDict.Add(402, "MC_SetPosition running, Writing Homing configuration ENC_1: Home offset (0x607C:00 / S-0-0052 / --)");
                    actionDescriptionDict.Add(403, "MC_SetPosition running, Canceling write record proces.");
                    actionDescriptionDict.Add(404, "MC_SetPosition running, Triggering set position function.");
                    actionDescriptionDict.Add(405, "MC_SetPosition running, Waiting for drive to be in reference.");
                    actionDescriptionDict.Add(406, "MC_SetPosition finished");
                    actionDescriptionDict.Add(407, "MC_SetPosition finished succesfully");
                    actionDescriptionDict.Add(408, "MC_SetPosition has been interupted");
                    actionDescriptionDict.Add(409, "MC_SetPosition finished with an error.");
                    // MC_ReadParameter
                    actionDescriptionDict.Add(410, "MC_ReadParameter running, Reading record.");
                    actionDescriptionDict.Add(411, "MC_ReadParameter running, Canceling read record proces.");
                    actionDescriptionDict.Add(412, "MC_ReadParameter running, ");
                    actionDescriptionDict.Add(413, "MC_ReadParameter running, ");
                    actionDescriptionDict.Add(414, "MC_ReadParameter running, ");
                    actionDescriptionDict.Add(415, "MC_ReadParameter running, ");
                    actionDescriptionDict.Add(416, "MC_ReadParameter finished");
                    actionDescriptionDict.Add(417, "MC_ReadParameter finished succesfully");
                    actionDescriptionDict.Add(418, "MC_ReadParameter has been interupted");
                    actionDescriptionDict.Add(419, "MC_ReadParameter finished with an error.");
                    // MC_ReadRealParameter
                    actionDescriptionDict.Add(420, "MC_ReadRealParameter running, Reading record.");
                    actionDescriptionDict.Add(421, "MC_ReadRealParameter running, Canceling read record proces.");
                    actionDescriptionDict.Add(422, "MC_ReadRealParameter running, ");
                    actionDescriptionDict.Add(423, "MC_ReadRealParameter running, ");
                    actionDescriptionDict.Add(424, "MC_ReadRealParameter running, ");
                    actionDescriptionDict.Add(425, "MC_ReadRealParameter running, ");
                    actionDescriptionDict.Add(426, "MC_ReadRealParameter finished");
                    actionDescriptionDict.Add(427, "MC_ReadRealParameter finished succesfully");
                    actionDescriptionDict.Add(428, "MC_ReadRealParameter has been interupted");
                    actionDescriptionDict.Add(429, "MC_ReadRealParameter finished with an error.");
                    // MC_ReadBoolParameter
                    actionDescriptionDict.Add(430, "MC_ReadBoolParameter running, Reading record.");
                    actionDescriptionDict.Add(431, "MC_ReadBoolParameter running, Canceling read record proces.");
                    actionDescriptionDict.Add(432, "MC_ReadBoolParameter running, ");
                    actionDescriptionDict.Add(433, "MC_ReadBoolParameter running, ");
                    actionDescriptionDict.Add(434, "MC_ReadBoolParameter running, ");
                    actionDescriptionDict.Add(435, "MC_ReadBoolParameter running, ");
                    actionDescriptionDict.Add(436, "MC_ReadBoolParameter finished");
                    actionDescriptionDict.Add(437, "MC_ReadBoolParameter finished succesfully");
                    actionDescriptionDict.Add(438, "MC_ReadBoolParameter has been interupted");
                    actionDescriptionDict.Add(439, "MC_ReadBoolParameter finished with an error.");
                    // MC_WriteParameter
                    actionDescriptionDict.Add(440, "MC_WriteParameter running, Writing record.");
                    actionDescriptionDict.Add(441, "MC_WriteParameter running, Canceling write record proces.");
                    actionDescriptionDict.Add(442, "MC_WriteParameter running, ");
                    actionDescriptionDict.Add(443, "MC_WriteParameter running, ");
                    actionDescriptionDict.Add(444, "MC_WriteParameter running, ");
                    actionDescriptionDict.Add(445, "MC_WriteParameter running, ");
                    actionDescriptionDict.Add(446, "MC_WriteParameter finished");
                    actionDescriptionDict.Add(447, "MC_WriteParameter finished succesfully");
                    actionDescriptionDict.Add(448, "MC_WriteParameter has been interupted");
                    actionDescriptionDict.Add(449, "MC_WriteParameter finished with an error.");
                    // MC_WriteRealParameter
                    actionDescriptionDict.Add(450, "MC_WriteRealParameter running, Writing record.");
                    actionDescriptionDict.Add(451, "MC_WriteRealParameter running, Canceling write record proces.");
                    actionDescriptionDict.Add(452, "MC_WriteRealParameter running, ");
                    actionDescriptionDict.Add(453, "MC_WriteRealParameter running, ");
                    actionDescriptionDict.Add(454, "MC_WriteRealParameter running, ");
                    actionDescriptionDict.Add(455, "MC_WriteRealParameter running, ");
                    actionDescriptionDict.Add(456, "MC_WriteRealParameter finished");
                    actionDescriptionDict.Add(457, "MC_WriteRealParameter finished succesfully");
                    actionDescriptionDict.Add(458, "MC_WriteRealParameter has been interupted");
                    actionDescriptionDict.Add(459, "MC_WriteRealParameter finished with an error.");
                    // MC_WriteBoolParameter
                    actionDescriptionDict.Add(460, "MC_WriteBoolParameter running, Writing record.");
                    actionDescriptionDict.Add(461, "MC_WriteBoolParameter running, Canceling write record proces.");
                    actionDescriptionDict.Add(462, "MC_WriteBoolParameter running, ");
                    actionDescriptionDict.Add(463, "MC_WriteBoolParameter running, ");
                    actionDescriptionDict.Add(464, "MC_WriteBoolParameter running, ");
                    actionDescriptionDict.Add(465, "MC_WriteBoolParameter running, ");
                    actionDescriptionDict.Add(466, "MC_WriteBoolParameter finished");
                    actionDescriptionDict.Add(467, "MC_WriteBoolParameter finished succesfully");
                    actionDescriptionDict.Add(468, "MC_WriteBoolParameter has been interupted");
                    actionDescriptionDict.Add(469, "MC_WriteBoolParameter finished with an error.");
                    // MC_ReadDigitalInput
                    actionDescriptionDict.Add(470, "MC_ReadDigitalInput running, Reading record.");
                    actionDescriptionDict.Add(471, "MC_ReadDigitalInput running, Canceling read record proces.");
                    actionDescriptionDict.Add(472, "MC_ReadDigitalInput running, ");
                    actionDescriptionDict.Add(473, "MC_ReadDigitalInput running, ");
                    actionDescriptionDict.Add(474, "MC_ReadDigitalInput running, ");
                    actionDescriptionDict.Add(475, "MC_ReadDigitalInput running, ");
                    actionDescriptionDict.Add(476, "MC_ReadDigitalInput finished");
                    actionDescriptionDict.Add(477, "MC_ReadDigitalInput finished succesfully");
                    actionDescriptionDict.Add(478, "MC_ReadDigitalInput has been interupted");
                    actionDescriptionDict.Add(479, "MC_ReadDigitalInput finished with an error.");
                    // MC_ReadDigitalOutput
                    actionDescriptionDict.Add(480, "MC_ReadDigitalOutput running, Reading record.");
                    actionDescriptionDict.Add(481, "MC_ReadDigitalOutput running, Canceling read record proces.");
                    actionDescriptionDict.Add(482, "MC_ReadDigitalOutput running, ");
                    actionDescriptionDict.Add(483, "MC_ReadDigitalOutput running, ");
                    actionDescriptionDict.Add(484, "MC_ReadDigitalOutput running, ");
                    actionDescriptionDict.Add(485, "MC_ReadDigitalOutput running, ");
                    actionDescriptionDict.Add(486, "MC_ReadDigitalOutput finished");
                    actionDescriptionDict.Add(487, "MC_ReadDigitalOutput finished succesfully");
                    actionDescriptionDict.Add(488, "MC_ReadDigitalOutput has been interupted");
                    actionDescriptionDict.Add(489, "MC_ReadDigitalOutput finished with an error.");
                    // MC_WriteDigitalOutput
                    actionDescriptionDict.Add(490, "MC_WriteDigitalOutput running, Writing record.");
                    actionDescriptionDict.Add(491, "MC_WriteDigitalOutput running, Canceling write record proces.");
                    actionDescriptionDict.Add(492, "MC_WriteDigitalOutput running, ");
                    actionDescriptionDict.Add(493, "MC_WriteDigitalOutput running, ");
                    actionDescriptionDict.Add(494, "MC_WriteDigitalOutput running, ");
                    actionDescriptionDict.Add(495, "MC_WriteDigitalOutput running, ");
                    actionDescriptionDict.Add(496, "MC_WriteDigitalOutput finished");
                    actionDescriptionDict.Add(497, "MC_WriteDigitalOutput finished succesfully");
                    actionDescriptionDict.Add(498, "MC_WriteDigitalOutput has been interupted");
                    actionDescriptionDict.Add(499, "MC_WriteDigitalOutput finished with an error.");


                    // General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    actionDescriptionDict.Add(710, "Hw configuration error. Value of _HW_Outputs is zero.");
                    actionDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    actionDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    actionDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    actionDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    actionDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    actionDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'Outputs' (GsdId=ID_M_XCS_INI_0_cons).");
                    actionDescriptionDict.Add(720, "Hw configuration error. Value of _HW_Inputs is zero.");
                    actionDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    actionDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    actionDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    actionDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    actionDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    actionDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'Inputs' (GsdId=ID_M_XCS_INI_0_prod).");
                    actionDescriptionDict.Add(730, "Hw configuration error. Value of _HW_S_0_0134_0_0 is zero.");
                    actionDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 1.");
                    actionDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 1.");
                    actionDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 1.");
                    actionDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 1.");
                    actionDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 1.");
                    actionDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 1. Expected GsdId of the submodule: 'ID_SM_Master_control_word_S_0_0134_0_0_cons'.");
                    actionDescriptionDict.Add(740, "Hw configuration error. Value of _HW_S_0_0145_0_0 is zero.");
                    actionDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 2.");
                    actionDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 2.");
                    actionDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 2.");
                    actionDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 2.");
                    actionDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 2.");
                    actionDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 2. Expected GsdId of the submodule: 'ID_SM_Signal_control_word_S_0_0145_0_0_cons'.");
                    actionDescriptionDict.Add(750, "Hw configuration error. Value of _HW_S_0_0282_0_0 is zero.");
                    actionDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 3.");
                    actionDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 3.");
                    actionDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 3.");
                    actionDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 3.");
                    actionDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 3.");
                    actionDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 3. Expected GsdId of the submodule: 'ID_SM_Positioning_command_value_S_0_0282_0_0_cons'.");
                    actionDescriptionDict.Add(760, "Hw configuration error. Value of _HW_S_0_0259_0_0 is zero.");
                    actionDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 4.");
                    actionDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 4.");
                    actionDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 4.");
                    actionDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 4.");
                    actionDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 4.");
                    actionDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 4. Expected GsdId of the submodule: 'ID_SM_Positioning_velocity_S_0_0259_0_0_cons'.");
                    actionDescriptionDict.Add(770, "Hw configuration error. Value of _HW_S_0_0260_0_0 is zero.");
                    actionDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 5.");
                    actionDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 5.");
                    actionDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 5.");
                    actionDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 5.");
                    actionDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 5.");
                    actionDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 5. Expected GsdId of the submodule: 'ID_SM_Positioning_acceleration_S_0_0260_0_0_cons'.");
                    actionDescriptionDict.Add(780, "Hw configuration error. Value of _HW_S_0_0359_0_0 is zero.");
                    actionDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 6.");
                    actionDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 6.");
                    actionDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 6.");
                    actionDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 6.");
                    actionDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 6.");
                    actionDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 6. Expected GsdId of the submodule: 'ID_SM_Positioning_deceleration_S_0_0359_0_0_cons'.");
                    actionDescriptionDict.Add(790, "Hw configuration error. Value of _HW_S_0_1720_0_1 is zero.");
                    actionDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 7.");
                    actionDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 7.");
                    actionDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 7.");
                    actionDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 7.");
                    actionDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 7.");
                    actionDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 7. Expected GsdId of the submodule: 'ID_SM_Power_supply_control_word_S_0_1720_0_1_cons'.");
                    actionDescriptionDict.Add(800, "Hw configuration error. Value of _HW_S_0_0092_0_0 is zero.");
                    actionDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 8.");
                    actionDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 8.");
                    actionDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 8.");
                    actionDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 8.");
                    actionDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 8.");
                    actionDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 8. Expected GsdId of the submodule:'ID_SM_Bipolar_torque_force_limit_value_S_0_0092_0_0_cons'.");
                    actionDescriptionDict.Add(810, "Hw configuration error. Value of _HW_S_0_0080_0_0 is zero.");
                    actionDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 9.");
                    actionDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 9.");
                    actionDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 9.");
                    actionDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 9.");
                    actionDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 9.");
                    actionDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 9. Expected GsdId of the submodule: 'ID_SM_Torque_force_command_value_S_0_0080_0_0_cons'.");
                    actionDescriptionDict.Add(820, "Hw configuration error. Value of _HW_S_0_0193_0_0 is zero.");
                    actionDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1, subslot 10.");
                    actionDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1, subslot 10.");
                    actionDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1, subslot 10.");
                    actionDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1, subslot 10.");
                    actionDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1, subslot 10.");
                    actionDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 1, Subslot 10. Expected GsdId of the submodule: 'ID_SM_Positioning_jerk_S_0_0193_0_0_cons'.");
                    actionDescriptionDict.Add(830, "Hw configuration error. Value of _HW_S_0_0135_0_0 is zero.");
                    actionDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 1.");
                    actionDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 1.");
                    actionDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 1.");
                    actionDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 1.");
                    actionDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 1.");
                    actionDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 1. Expected GsdId of the submodule: 'ID_SM_Drive_status_word_S_0_0135_0_0_prod'.");
                    actionDescriptionDict.Add(840, "Hw configuration error. Value of _HW_S_0_0144_0_0 is zero.");
                    actionDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 2.");
                    actionDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 2.");
                    actionDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 2.");
                    actionDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 2.");
                    actionDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 2.");
                    actionDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 2. Expected GsdId of the submodule: 'ID_SM_Signal_status_word_S_0_0144_0_0_prod'.");
                    actionDescriptionDict.Add(850, "Hw configuration error. Value of _HW_S_0_0386_0_0 is zero.");
                    actionDescriptionDict.Add(851, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 3.");
                    actionDescriptionDict.Add(852, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 3.");
                    actionDescriptionDict.Add(853, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 3.");
                    actionDescriptionDict.Add(854, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 3.");
                    actionDescriptionDict.Add(855, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 3.");
                    actionDescriptionDict.Add(856, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 3. Expected GsdId of the submodule: 'ID_SM_Active_position_feedback_value_S_0_0386_0_0_prod'.");
                    actionDescriptionDict.Add(860, "Hw configuration error. Value of _HW_S_0_0535_0_0 is zero.");
                    actionDescriptionDict.Add(861, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 4.");
                    actionDescriptionDict.Add(862, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 4.");
                    actionDescriptionDict.Add(863, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 4.");
                    actionDescriptionDict.Add(864, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 4.");
                    actionDescriptionDict.Add(865, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 4.");
                    actionDescriptionDict.Add(866, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 4. Expected GsdId of the submodule: 'ID_SM_Active_velocity_feedback_value_S_0_0535_0_0_prod'.");
                    actionDescriptionDict.Add(870, "Hw configuration error. Value of _HW_S_0_0390_0_0 is zero.");
                    actionDescriptionDict.Add(871, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 5.");
                    actionDescriptionDict.Add(872, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 5.");
                    actionDescriptionDict.Add(873, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 5.");
                    actionDescriptionDict.Add(874, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 5.");
                    actionDescriptionDict.Add(875, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 5.");
                    actionDescriptionDict.Add(876, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 5. Expected GsdId of the submodule: 'ID_SM_Diagnostic_message_number_S_0_0390_0_0_prod'.");
                    actionDescriptionDict.Add(880, "Hw configuration error. Value of _HW_S_0_1720_0_2 is zero.");
                    actionDescriptionDict.Add(881, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 6.");
                    actionDescriptionDict.Add(882, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 6.");
                    actionDescriptionDict.Add(883, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 6.");
                    actionDescriptionDict.Add(884, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 6.");
                    actionDescriptionDict.Add(885, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 6.");
                    actionDescriptionDict.Add(886, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 6. Expected GsdId of the submodule: 'ID_SM_Power_supply_status_word_S_0_1720_0_2_prod'.");
                    actionDescriptionDict.Add(890, "Hw configuration error. Value of _HW_S_0_0084_0_0 is zero.");
                    actionDescriptionDict.Add(891, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 7.");
                    actionDescriptionDict.Add(892, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 7.");
                    actionDescriptionDict.Add(893, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 7.");
                    actionDescriptionDict.Add(894, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 7.");
                    actionDescriptionDict.Add(895, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 7.");
                    actionDescriptionDict.Add(896, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 7. Expected GsdId of the submodule: 'ID_SM_Torque_force_feedback_value_S_0_0084_0_0_prod'.");
                    actionDescriptionDict.Add(900, "Hw configuration error. Value of _HW_P_0_0106_0_0 is zero.");
                    actionDescriptionDict.Add(901, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2, subslot 8.");
                    actionDescriptionDict.Add(902, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2, subslot 8.");
                    actionDescriptionDict.Add(903, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2, subslot 8.");
                    actionDescriptionDict.Add(904, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2, subslot 8.");
                    actionDescriptionDict.Add(905, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2, subslot 8.");
                    actionDescriptionDict.Add(906, "Hw configuration error: Module with unexpected size or type detected in Slot 2, Subslot 8. Expected GsdId of the submodule: 'ID_SM_Operating_status_STO_P_0_0106_0_0_prod'.");
                    actionDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(1131, "Input variable `hwId` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1132, "Input variable `_HW_Outputs` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1133, "Input variable `_HW_Inputs` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1134, "Input variable `_HW_S_0_0134_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1135, "Input variable `_HW_S_0_0145_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1136, "Input variable `_HW_S_0_0282_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1137, "Input variable `_HW_S_0_0259_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1138, "Input variable `_HW_S_0_0260_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1139, "Input variable `_HW_S_0_0359_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1140, "Input variable `_HW_S_0_1720_0_1' has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1141, "Input variable `_HW_S_0_0092_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1142, "Input variable `_HW_S_0_0080_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1143, "Input variable `_HW_S_0_0193_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1144, "Input variable `_HW_S_0_0135_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1145, "Input variable `_HW_S_0_0144_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1146, "Input variable `_HW_S_0_0386_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1147, "Input variable `_HW_S_0_0535_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1148, "Input variable `_HW_S_0_0390_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1149, "Input variable `_HW_S_0_1720_0_2` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1150, "Input variable `_HW_S_0_0084_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1151, "Input variable `_HW_P_0_0106_0_0` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1201, "Error reading the DriveStatusWord_S_0_0135_0_0!");
                    actionDescriptionDict.Add(1202, "Error reading the SignalStatusWord_S_0_0144_0_0!");
                    actionDescriptionDict.Add(1203, "Error reading the ActualPosition_S_0_0386_0_0!");
                    actionDescriptionDict.Add(1204, "Error reading the ActualVelocity_S_0_0535_0_0!");
                    actionDescriptionDict.Add(1205, "Error reading the DiagnosticMessage_S_0_0390_0_0!");
                    actionDescriptionDict.Add(1206, "Error reading the SupplyUnitStatusWord_S_0_1720_0_2!");
                    actionDescriptionDict.Add(1207, "Error reading the ActualTorque_S_0_0084_0_0!");
                    actionDescriptionDict.Add(1231, "Error writing the DriveControlWord_S_0_0134_0_0!");
                    actionDescriptionDict.Add(1232, "Error writing the SignalControlWord_S_0_0145_0_0!");
                    actionDescriptionDict.Add(1233, "Error writing the CommandPosition_S_0_0282_0_0!");
                    actionDescriptionDict.Add(1234, "Error writing the CommandVelocity_S_0_0259_0_0!");
                    actionDescriptionDict.Add(1235, "Error writing the CommandAcceleration_S_0_0260_0_0!");
                    actionDescriptionDict.Add(1236, "Error writing the CommandDecceleration_S_0_0359_0_0!");
                    actionDescriptionDict.Add(1237, "Error writing the SupplyUnitControlWord_S_0_1720_0_1!");
                    actionDescriptionDict.Add(1238, "Error writing the BipolarTorqueLimitation_S_0_0092_0_0!");
                    actionDescriptionDict.Add(1239, "Error writing the CommandTorque_S_0_0080_0_0!");
                    actionDescriptionDict.Add(1240, "Error writing the CommandJerk_S_0_0193_0_0!");
                    actionDescriptionDict.Add(1430, "Null reference of the AxisRef inside the MC_Power method!");
                    actionDescriptionDict.Add(1440, "Null reference of the AxisRef inside the MC_Home method!");
                    actionDescriptionDict.Add(1441, "Negative or zero value of the Acceleration in the MC_Home method!");
                    actionDescriptionDict.Add(1442, "Negative or zero value of the Deceleration in the MC_Home method!");
                    actionDescriptionDict.Add(1470, "Null reference of the AxisRef inside the MC_Stop method!");
                    actionDescriptionDict.Add(1471, "Negative or zero value of the Deceleration in the MC_Stop method!");
                    actionDescriptionDict.Add(1472, "Negative or zero value of the Jerk in the MC_Stop method!");
                    actionDescriptionDict.Add(1490, "Null reference of the AxisRef inside the MC_MoveAbsolute method!");
                    actionDescriptionDict.Add(1491, "Negative or zero value of the Velocity in the MC_MoveAbsolute method!");
                    actionDescriptionDict.Add(1492, "Negative or zero value of the Acceleration in the MC_MoveAbsolute method!");
                    actionDescriptionDict.Add(1493, "Negative or zero value of the Deceleration in the MC_MoveAbsolute method!");
                    actionDescriptionDict.Add(1494, "Negative or zero value of the Jerk in the MC_MoveAbsolute method!");
                    actionDescriptionDict.Add(1500, "Null reference of the AxisRef inside the MC_MoveRelative method!");
                    actionDescriptionDict.Add(1501, "Negative or zero value of the Velocity in the MC_MoveRelative method!");
                    actionDescriptionDict.Add(1502, "Negative or zero value of the Acceleration in the MC_MoveRelative method!");
                    actionDescriptionDict.Add(1503, "Negative or zero value of the Deceleration in the MC_MoveRelative method!");
                    actionDescriptionDict.Add(1504, "Negative or zero value of the Jerk in the MC_MoveRelative method!");
                    actionDescriptionDict.Add(1510, "Null reference of the AxisRef inside the MC_MoveAdditive method!");
                    actionDescriptionDict.Add(1511, "Negative or zero value of the Velocity in the MC_MoveAdditive method!");
                    actionDescriptionDict.Add(1512, "Negative or zero value of the Acceleration in the MC_MoveAdditive method!");
                    actionDescriptionDict.Add(1513, "Negative or zero value of the Deceleration in the MC_MoveAdditive method!");
                    actionDescriptionDict.Add(1514, "Negative or zero value of the Jerk in the MC_MoveAdditive method!");
                    actionDescriptionDict.Add(1520, "Null reference of the AxisRef inside the MC_MoveVelocity method!");
                    actionDescriptionDict.Add(1521, "Invalid value of the Direction in the MC_MoveVelocity method!");
                    actionDescriptionDict.Add(1522, "Zero value of the Velocity in the MC_MoveVelocity method!");
                    actionDescriptionDict.Add(1523, "Negative or zero value of the Acceleration in the MC_MoveVelocity method!");
                    actionDescriptionDict.Add(1524, "Negative or zero value of the Deceleration in the MC_MoveVelocity method!");
                    actionDescriptionDict.Add(1525, "Negative or zero value of the Jerk in the MC_MoveVelocity method!");
                    actionDescriptionDict.Add(1530, "Null reference of the AxisRef inside the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1531, "Invalid value of the Direction in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1532, "Negative or zero value of the Velocity in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1533, "Negative or zero value of the Acceleration in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1534, "Negative or zero value of the Deceleration in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1535, "Negative or zero value of the Jerk in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1536, "Zero value of the Torque in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1537, "Negative or zero value of the TorqueRamp in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1540, "Error writing Torque/force control: Ramp value (0x2838:01 / S-0-0822 / --) in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1541, "Error writing Torque/force control: Ramp time (0x2838:02 / S-0-0823 / --) in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1542, "Error writing Torque/force control: High velocity limit value (P-0-0421.0.3 / P-0-2249) in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1543, "Error writing Torque/force control: Low velocity limit value (P-0-0421.0.4 / P-0-2250) in the MC_TorqueControl method!");
                    actionDescriptionDict.Add(1550, "Null reference of the AxisRef inside the MC_SetPosition method!");
                    actionDescriptionDict.Add(1551, "Error writing Homing configuration ENC_1: Home offset (0x607C:00 / S-0-0052 / --) in the MC_SetPosition method!");
                    actionDescriptionDict.Add(1570, "Null reference of the AxisRef inside the MC_SetOverride method!");
                    actionDescriptionDict.Add(1571, "Invalid value of the VelocityFactor in the MC_SetOverride method!");
                    actionDescriptionDict.Add(1572, "Invalid value of the AccelerationFactor in the MC_SetOverride method!");
                    actionDescriptionDict.Add(1573, "Invalid value of the JerkFactor in the MC_MoveRelative method!");
                    actionDescriptionDict.Add(1580, "Null reference of the AxisRef inside the MC_ReadParameter method!");
                    actionDescriptionDict.Add(1581, "Error reading parameter  in the MC_ReadParameter method!");
                    actionDescriptionDict.Add(1590, "Null reference of the AxisRef inside the MC_ReadRealParameter method!");
                    actionDescriptionDict.Add(1591, "Error reading parameter  in the MC_ReadRealParameter method!");
                    actionDescriptionDict.Add(1600, "Null reference of the AxisRef inside the MC_ReadBoolParameter method!");
                    actionDescriptionDict.Add(1601, "Error reading parameter  in the MC_ReadBoolParameter method!");
                    actionDescriptionDict.Add(1610, "Null reference of the AxisRef inside the MC_WriteParameter method!");
                    actionDescriptionDict.Add(1611, "Error writing parameter  in the MC_WriteParameter method!");
                    actionDescriptionDict.Add(1620, "Null reference of the AxisRef inside the MC_WriteRealParameter method!");
                    actionDescriptionDict.Add(1621, "Error writing parameter  in the MC_WriteRealParameter method!");
                    actionDescriptionDict.Add(1630, "Null reference of the AxisRef inside the MC_WriteBoolParameter method!");
                    actionDescriptionDict.Add(1631, "Error writing parameter  in the MC_WriteBoolParameter method!");
                    actionDescriptionDict.Add(1640, "Null reference of the AxisRef inside the MC_ReadDigitalInput method!");
                    actionDescriptionDict.Add(1641, "Invalid InputNumber  in the MC_ReadDigitalInput method!");
                    actionDescriptionDict.Add(1642, "Error reading parameter  in the MC_ReadDigitalInput method!");
                    actionDescriptionDict.Add(1650, "Null reference of the AxisRef inside the MC_ReadDigitalOutput method!");
                    actionDescriptionDict.Add(1651, "Invalid OutputNumber  in the MC_ReadDigitalOutput method!");
                    actionDescriptionDict.Add(1652, "Error reading parameter  in the MC_ReadDigitalOutput method!");
                    actionDescriptionDict.Add(1660, "Null reference of the AxisRef inside the MC_WriteDigitalOutput method!");
                    actionDescriptionDict.Add(1661, "Invalid OutputNumber  in the MC_WriteDigitalOutput method!");
                    actionDescriptionDict.Add(1662, "Error writing parameter  in the MC_WriteDigitalOutput method!");
                    actionDescriptionDict.Add(1800, "Scaling parameters not yet read out of the drive");
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
