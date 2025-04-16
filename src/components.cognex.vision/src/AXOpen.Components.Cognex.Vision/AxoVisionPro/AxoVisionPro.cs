using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Cognex.Vision
{
    public partial class AxoVisionPro
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
                //  General alarm
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwId` has invalid value in `Run` method!"                                                                      ,"Check the call of the `Run` method, if the `hwId` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_1 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_2 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_3 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(719, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_4 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(727, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_5 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(728, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(729, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_6 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(737, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(738, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(739, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_7 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_8 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(747, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(748, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(749, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(750, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(751, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_9 is zero."                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(752, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(753, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(754, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(755, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(756, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9."               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(757, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_10 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(758, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(759, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(760, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(761, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(762, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(763, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_11 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(764, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(765, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(766, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(767, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(768, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(769, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_12 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(770, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(771, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(772, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(773, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(774, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(775, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_13 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(776, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(777, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(778, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(779, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(780, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(781, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_14 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(782, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(783, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(784, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(785, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(786, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(787, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_15 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(788, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(789, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(790, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(791, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(792, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(793, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_16 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(794, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(795, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(796, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(797, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(798, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(799, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_17 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(802, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(803, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(804, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(805, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_18 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(806, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(807, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(808, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(809, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_19 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(812, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(813, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(814, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(815, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(816, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(817, new AxoMessengerTextItem("Hw configuration error. Value of _hwID_20 is zero."                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(818, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(819, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20."              ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(822, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20."              ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(830, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(831, new AxoMessengerTextItem("Input variable `hwId` has invalid value in `Run` method!"                                                                      ,"Check the call of the `Run` method, if the `hwId` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(832, new AxoMessengerTextItem("Input variable `hwId_1` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(833, new AxoMessengerTextItem("Input variable `hwId_2` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_2` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(834, new AxoMessengerTextItem("Input variable `hwId_3` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_3` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(835, new AxoMessengerTextItem("Input variable `hwId_4` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_4` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(836, new AxoMessengerTextItem("Input variable `hwId_5` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_5` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(837, new AxoMessengerTextItem("Input variable `hwId_6` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_6` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(838, new AxoMessengerTextItem("Input variable `hwId_7` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_7` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(839, new AxoMessengerTextItem("Input variable `hwId_8` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_8` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Input variable `hwId_9` has invalid value in `Run` method!"                                                                    ,"Check the call of the `Run` method, if the `hwId_9` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Input variable `hwId_10` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_10` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(842, new AxoMessengerTextItem("Input variable `hwId_11` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_11` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(843, new AxoMessengerTextItem("Input variable `hwId_12` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_12` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(844, new AxoMessengerTextItem("Input variable `hwId_13` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_13` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(845, new AxoMessengerTextItem("Input variable `hwId_14` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_14` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(846, new AxoMessengerTextItem("Input variable `hwId_15` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_15` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(847, new AxoMessengerTextItem("Input variable `hwId_16` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_16` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(848, new AxoMessengerTextItem("Input variable `hwId_17` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_17` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(849, new AxoMessengerTextItem("Input variable `hwId_18` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_18` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("Input variable `hwId_19` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_19` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("Input variable `hwId_20` has invalid value in `Run` method!"                                                                   ,"Check the call of the `Run` method, if the `hwId_20` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(861, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_1!"                                                                     ,"Check the value of the hwID_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(862, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_2!"                                                                     ,"Check the value of the hwID_2 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(863, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_3!"                                                                     ,"Check the value of the hwID_3 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(864, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_4!"                                                                     ,"Check the value of the hwID_4 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(865, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_5!"                                                                     ,"Check the value of the hwID_5 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(866, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_6!"                                                                     ,"Check the value of the hwID_6 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(867, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_7!"                                                                     ,"Check the value of the hwID_7 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(868, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_8!"                                                                     ,"Check the value of the hwID_8 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(869, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_9!"                                                                     ,"Check the value of the hwID_9 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(870, new AxoMessengerTextItem("Error reading the AxoVisionProInputStructure_hwID_10!"                                                                    ,"Check the value of the hwID_10 and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(871, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_11!"                                                                   ,"Check the value of the hwID_11 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(872, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_12!"                                                                   ,"Check the value of the hwID_12 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(873, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_13!"                                                                   ,"Check the value of the hwID_13 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(874, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_14!"                                                                   ,"Check the value of the hwID_14 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(875, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_15!"                                                                   ,"Check the value of the hwID_15 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(876, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_16!"                                                                   ,"Check the value of the hwID_16 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(877, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_17!"                                                                   ,"Check the value of the hwID_17 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(878, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_18!"                                                                   ,"Check the value of the hwID_18 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(879, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_19!"                                                                   ,"Check the value of the hwID_19 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(880, new AxoMessengerTextItem("Error writing the AxoVisionProOutputStructure_hwID_20!"                                                                   ,"Check the value of the hwID_20 and reacheability of the device!")),


                // TemplateTask_10steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(900, new AxoMessengerTextItem("TemplateTask_10steps_1 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(901, new AxoMessengerTextItem("TemplateTask_10steps_1 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(910, new AxoMessengerTextItem("TemplateTask_10steps_2 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(911, new AxoMessengerTextItem("TemplateTask_10steps_2 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(920, new AxoMessengerTextItem("TemplateTask_10steps_3 finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(921, new AxoMessengerTextItem("TemplateTask_10steps_3 was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(930, new AxoMessengerTextItem("TemplateTask_10steps_4 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(931, new AxoMessengerTextItem("TemplateTask_10steps_4 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(940, new AxoMessengerTextItem("TemplateTask_10steps_5 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(941, new AxoMessengerTextItem("TemplateTask_10steps_5 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_10steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(950, new AxoMessengerTextItem("TemplateTask_10steps_6 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(951, new AxoMessengerTextItem("TemplateTask_10steps_6 task was aborted, while not yet completed!","Check the details.")),

                // TemplateTask_20steps_1
                new KeyValuePair<ulong, AxoMessengerTextItem>(960, new AxoMessengerTextItem("TemplateTask_20steps_1 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(961, new AxoMessengerTextItem("TemplateTask_20steps_1 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(980, new AxoMessengerTextItem("TemplateTask_20steps_2 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(981, new AxoMessengerTextItem("TemplateTask_20steps_2 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_3
                new KeyValuePair<ulong, AxoMessengerTextItem>(1000, new AxoMessengerTextItem("TemplateTask_20steps_3 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1001, new AxoMessengerTextItem("TemplateTask_20steps_3 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_4
                new KeyValuePair<ulong, AxoMessengerTextItem>(1020, new AxoMessengerTextItem("TemplateTask_20steps_4 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1021, new AxoMessengerTextItem("TemplateTask_20steps_4 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_5
                new KeyValuePair<ulong, AxoMessengerTextItem>(1040, new AxoMessengerTextItem("TemplateTask_20steps_5 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1041, new AxoMessengerTextItem("TemplateTask_20steps_5 task was aborted, while not yet completed!","Check the details.")),
                // TemplateTask_20steps_6
                new KeyValuePair<ulong, AxoMessengerTextItem>(1060, new AxoMessengerTextItem("TemplateTask_20steps_6 task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1061, new AxoMessengerTextItem("TemplateTask_20steps_6 task was aborted, while not yet completed!","Check the details.")),

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

    public partial class AxoVisionPro_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    errorDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    errorDescriptionDict.Add(703, "Hw configuration error. Value of _hwID_1 is zero.");
                    errorDescriptionDict.Add(704, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    errorDescriptionDict.Add(705, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    errorDescriptionDict.Add(706, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    errorDescriptionDict.Add(707, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    errorDescriptionDict.Add(708, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    errorDescriptionDict.Add(709, "Hw configuration error. Value of _hwID_2 is zero.");
                    errorDescriptionDict.Add(710, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    errorDescriptionDict.Add(715, "Hw configuration error. Value of _hwID_3 is zero.");
                    errorDescriptionDict.Add(716, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3.");
                    errorDescriptionDict.Add(717, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3.");
                    errorDescriptionDict.Add(718, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3.");
                    errorDescriptionDict.Add(719, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3.");
                    errorDescriptionDict.Add(720, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3.");
                    errorDescriptionDict.Add(721, "Hw configuration error. Value of _hwID_4 is zero.");
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4.");
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4.");
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4.");
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4.");
                    errorDescriptionDict.Add(726, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4.");
                    errorDescriptionDict.Add(727, "Hw configuration error. Value of _hwID_5 is zero.");
                    errorDescriptionDict.Add(728, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5.");
                    errorDescriptionDict.Add(729, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5.");
                    errorDescriptionDict.Add(730, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5.");
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5.");
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5.");
                    errorDescriptionDict.Add(733, "Hw configuration error. Value of _hwID_6 is zero.");
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6.");
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6.");
                    errorDescriptionDict.Add(736, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6.");
                    errorDescriptionDict.Add(737, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6.");
                    errorDescriptionDict.Add(738, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6.");
                    errorDescriptionDict.Add(739, "Hw configuration error. Value of _hwID_7 is zero.");
                    errorDescriptionDict.Add(740, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7.");
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7.");
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7.");
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7.");
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7.");
                    errorDescriptionDict.Add(745, "Hw configuration error. Value of _hwID_8 is zero.");
                    errorDescriptionDict.Add(746, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8.");
                    errorDescriptionDict.Add(747, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8.");
                    errorDescriptionDict.Add(748, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8.");
                    errorDescriptionDict.Add(749, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8.");
                    errorDescriptionDict.Add(750, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8.");
                    errorDescriptionDict.Add(751, "Hw configuration error. Value of _hwID_9 is zero.");
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9.");
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9.");
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9.");
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9.");
                    errorDescriptionDict.Add(756, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9.");
                    errorDescriptionDict.Add(757, "Hw configuration error. Value of _hwID_10 is zero.");
                    errorDescriptionDict.Add(758, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10.");
                    errorDescriptionDict.Add(759, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10.");
                    errorDescriptionDict.Add(760, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10.");
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10.");
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10.");
                    errorDescriptionDict.Add(763, "Hw configuration error. Value of _hwID_11 is zero.");
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11.");
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11.");
                    errorDescriptionDict.Add(766, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11.");
                    errorDescriptionDict.Add(767, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11.");
                    errorDescriptionDict.Add(768, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11.");
                    errorDescriptionDict.Add(769, "Hw configuration error. Value of _hwID_12 is zero.");
                    errorDescriptionDict.Add(770, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12.");
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12.");
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12.");
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12.");
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12.");
                    errorDescriptionDict.Add(775, "Hw configuration error. Value of _hwID_13 is zero.");
                    errorDescriptionDict.Add(776, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13.");
                    errorDescriptionDict.Add(777, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13.");
                    errorDescriptionDict.Add(778, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13.");
                    errorDescriptionDict.Add(779, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13.");
                    errorDescriptionDict.Add(780, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13.");
                    errorDescriptionDict.Add(781, "Hw configuration error. Value of _hwID_14 is zero.");
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14.");
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14.");
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14.");
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14.");
                    errorDescriptionDict.Add(786, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14.");
                    errorDescriptionDict.Add(787, "Hw configuration error. Value of _hwID_15 is zero.");
                    errorDescriptionDict.Add(788, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15.");
                    errorDescriptionDict.Add(789, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15.");
                    errorDescriptionDict.Add(790, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15.");
                    errorDescriptionDict.Add(791, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15.");
                    errorDescriptionDict.Add(792, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15.");
                    errorDescriptionDict.Add(793, "Hw configuration error. Value of _hwID_16 is zero.");
                    errorDescriptionDict.Add(794, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16.");
                    errorDescriptionDict.Add(795, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16.");
                    errorDescriptionDict.Add(796, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16.");
                    errorDescriptionDict.Add(797, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16.");
                    errorDescriptionDict.Add(798, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16.");
                    errorDescriptionDict.Add(799, "Hw configuration error. Value of _hwID_17 is zero.");
                    errorDescriptionDict.Add(800, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17.");
                    errorDescriptionDict.Add(801, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17.");
                    errorDescriptionDict.Add(802, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17.");
                    errorDescriptionDict.Add(803, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17.");
                    errorDescriptionDict.Add(804, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17.");
                    errorDescriptionDict.Add(805, "Hw configuration error. Value of _hwID_18 is zero.");
                    errorDescriptionDict.Add(806, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18.");
                    errorDescriptionDict.Add(807, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18.");
                    errorDescriptionDict.Add(808, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18.");
                    errorDescriptionDict.Add(809, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18.");
                    errorDescriptionDict.Add(810, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18.");
                    errorDescriptionDict.Add(811, "Hw configuration error. Value of _hwID_19 is zero.");
                    errorDescriptionDict.Add(812, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19.");
                    errorDescriptionDict.Add(813, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19.");
                    errorDescriptionDict.Add(814, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19.");
                    errorDescriptionDict.Add(815, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19.");
                    errorDescriptionDict.Add(816, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19.");
                    errorDescriptionDict.Add(817, "Hw configuration error. Value of _hwID_20 is zero.");
                    errorDescriptionDict.Add(818, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20.");
                    errorDescriptionDict.Add(819, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20.");
                    errorDescriptionDict.Add(820, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20.");
                    errorDescriptionDict.Add(821, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20.");
                    errorDescriptionDict.Add(822, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20.");

                    errorDescriptionDict.Add(830, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(831, "Input variable `hwId` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(832, "Input variable `hwId_1` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(833, "Input variable `hwId_2` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(834, "Input variable `hwId_3` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(835, "Input variable `hwId_4` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(836, "Input variable `hwId_5` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(837, "Input variable `hwId_6` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(838, "Input variable `hwId_7` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(839, "Input variable `hwId_8` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(840, "Input variable `hwId_9` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(841, "Input variable `hwId_10` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(842, "Input variable `hwId_11` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(843, "Input variable `hwId_12` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(844, "Input variable `hwId_13` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(845, "Input variable `hwId_14` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(846, "Input variable `hwId_15` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(847, "Input variable `hwId_16` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(848, "Input variable `hwId_17` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(849, "Input variable `hwId_18` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(850, "Input variable `hwId_19` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(851, "Input variable `hwId_20` has invalid value in `Run` method!");

                    errorDescriptionDict.Add(861, "Error reading the AxoVisionProInputStructure_hwID_1!");
                    errorDescriptionDict.Add(862, "Error reading the AxoVisionProInputStructure_hwID_2!");
                    errorDescriptionDict.Add(863, "Error reading the AxoVisionProInputStructure_hwID_3!");
                    errorDescriptionDict.Add(864, "Error reading the AxoVisionProInputStructure_hwID_4!");
                    errorDescriptionDict.Add(865, "Error reading the AxoVisionProInputStructure_hwID_5!");
                    errorDescriptionDict.Add(866, "Error reading the AxoVisionProInputStructure_hwID_6!");
                    errorDescriptionDict.Add(867, "Error reading the AxoVisionProInputStructure_hwID_7!");
                    errorDescriptionDict.Add(868, "Error reading the AxoVisionProInputStructure_hwID_8!");
                    errorDescriptionDict.Add(869, "Error reading the AxoVisionProInputStructure_hwID_9!");
                    errorDescriptionDict.Add(870, "Error reading the AxoVisionProInputStructure_hwID_10!");

                    errorDescriptionDict.Add(871, "Error writing the AxoVisionProOutputStructure_hwID_11!");
                    errorDescriptionDict.Add(872, "Error writing the AxoVisionProOutputStructure_hwID_12!");
                    errorDescriptionDict.Add(873, "Error writing the AxoVisionProOutputStructure_hwID_13!");
                    errorDescriptionDict.Add(874, "Error writing the AxoVisionProOutputStructure_hwID_14!");
                    errorDescriptionDict.Add(875, "Error writing the AxoVisionProOutputStructure_hwID_15!");
                    errorDescriptionDict.Add(876, "Error writing the AxoVisionProOutputStructure_hwID_16!");
                    errorDescriptionDict.Add(877, "Error writing the AxoVisionProOutputStructure_hwID_17!");
                    errorDescriptionDict.Add(878, "Error writing the AxoVisionProOutputStructure_hwID_18!");
                    errorDescriptionDict.Add(879, "Error writing the AxoVisionProOutputStructure_hwID_19!");
                    errorDescriptionDict.Add(880, "Error writing the AxoVisionProOutputStructure_hwID_20!");


                    // TemplateTask_10steps_1
                    errorDescriptionDict.Add(900, "TemplateTask_10steps_1 finished with error!");
                    errorDescriptionDict.Add(901, "TemplateTask_10steps_1 was aborted, while not yet completed!");
                    // TemplateTask_10steps_2
                    errorDescriptionDict.Add(910, "TemplateTask_10steps_2 finished with error!");
                    errorDescriptionDict.Add(911, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    // TemplateTask_10steps_3
                    errorDescriptionDict.Add(920, "TemplateTask_10steps_3 finished with error!");
                    errorDescriptionDict.Add(921, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    // TemplateTask_10steps_4
                    errorDescriptionDict.Add(930, "TemplateTask_10steps_4 task finished with error!");
                    errorDescriptionDict.Add(931, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_5
                    errorDescriptionDict.Add(940, "TemplateTask_10steps_5 task finished with error!");
                    errorDescriptionDict.Add(941, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_6
                    errorDescriptionDict.Add(950, "TemplateTask_10steps_6 task finished with error!");
                    errorDescriptionDict.Add(951, "TemplateTask_10steps_6 task was aborted, while not yet completed!");

                    // TemplateTask_20steps_1
                    errorDescriptionDict.Add(960, "TemplateTask_20steps_1 task finished with error!");
                    errorDescriptionDict.Add(961, "TemplateTask_20steps_1 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_2
                    errorDescriptionDict.Add(980, "TemplateTask_20steps_2 task finished with error!");
                    errorDescriptionDict.Add(981, "TemplateTask_20steps_2 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_3       
                    errorDescriptionDict.Add(1000, "TemplateTask_20steps_3 task finished with error!");
                    errorDescriptionDict.Add(1001, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_4
                    errorDescriptionDict.Add(1020, "TemplateTask_20steps_4 task finished with error!");
                    errorDescriptionDict.Add(1021, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_5
                    errorDescriptionDict.Add(1040, "TemplateTask_20steps_5 task finished with error!");
                    errorDescriptionDict.Add(1041, "TemplateTask_20steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_6
                    errorDescriptionDict.Add(1060, "TemplateTask_20steps_6 task finished with error!");
                    errorDescriptionDict.Add(1061, "TemplateTask_20steps_6 task was aborted, while not yet completed!");


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
                    actionDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Input variable `hwId_1` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(703, "Input variable `hwId_2` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(704, "Input variable `hwId_3` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(705, "Input variable `hwId_4` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(706, "Input variable `hwId_5` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(707, "Input variable `hwId_6` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(708, "Input variable `hwId_7` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(709, "Input variable `hwId_8` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(710, "Input variable `hwId_9` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(711, "Input variable `hwId_10` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(712, "Input variable `hwId_11` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(713, "Input variable `hwId_12` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(714, "Input variable `hwId_13` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(715, "Input variable `hwId_14` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(716, "Input variable `hwId_15` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(717, "Input variable `hwId_16` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(718, "Input variable `hwId_17` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(719, "Input variable `hwId_18` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(720, "Input variable `hwId_19` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(721, "Input variable `hwId_20` has invalid value in `Run` method!");

                    actionDescriptionDict.Add(722, "Error reading the AxoVisionProInputStructure_hwID_1!");
                    actionDescriptionDict.Add(723, "Error reading the AxoVisionProInputStructure_hwID_2!");
                    actionDescriptionDict.Add(724, "Error reading the AxoVisionProInputStructure_hwID_3!");
                    actionDescriptionDict.Add(725, "Error reading the AxoVisionProInputStructure_hwID_4!");
                    actionDescriptionDict.Add(726, "Error reading the AxoVisionProInputStructure_hwID_5!");
                    actionDescriptionDict.Add(727, "Error reading the AxoVisionProInputStructure_hwID_6!");
                    actionDescriptionDict.Add(728, "Error reading the AxoVisionProInputStructure_hwID_7!");
                    actionDescriptionDict.Add(729, "Error reading the AxoVisionProInputStructure_hwID_8!");
                    actionDescriptionDict.Add(730, "Error reading the AxoVisionProInputStructure_hwID_9!");
                    actionDescriptionDict.Add(731, "Error reading the AxoVisionProInputStructure_hwID_10!");

                    actionDescriptionDict.Add(733, "Error writing the AxoVisionProOutputStructure_hwID_11!");
                    actionDescriptionDict.Add(734, "Error writing the AxoVisionProOutputStructure_hwID_12!");
                    actionDescriptionDict.Add(735, "Error writing the AxoVisionProOutputStructure_hwID_13!");
                    actionDescriptionDict.Add(736, "Error writing the AxoVisionProOutputStructure_hwID_14!");
                    actionDescriptionDict.Add(737, "Error writing the AxoVisionProOutputStructure_hwID_15!");
                    actionDescriptionDict.Add(738, "Error writing the AxoVisionProOutputStructure_hwID_16!");
                    actionDescriptionDict.Add(739, "Error writing the AxoVisionProOutputStructure_hwID_17!");
                    actionDescriptionDict.Add(740, "Error writing the AxoVisionProOutputStructure_hwID_18!");
                    actionDescriptionDict.Add(741, "Error writing the AxoVisionProOutputStructure_hwID_19!");
                    actionDescriptionDict.Add(742, "Error writing the AxoVisionProOutputStructure_hwID_20!");


                    // TemplateTask_10steps_1
                    actionDescriptionDict.Add(800, "TemplateTask_10steps_1 finished with error!");
                    actionDescriptionDict.Add(801, "TemplateTask_10steps_1 was aborted, while not yet completed!");
                    // TemplateTask_10steps_2
                    actionDescriptionDict.Add(810, "TemplateTask_10steps_2 finished with error!");
                    actionDescriptionDict.Add(811, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    // TemplateTask_10steps_3
                    actionDescriptionDict.Add(820, "TemplateTask_10steps_3 finished with error!");
                    actionDescriptionDict.Add(821, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    // TemplateTask_10steps_4
                    actionDescriptionDict.Add(830, "TemplateTask_10steps_4 task finished with error!");
                    actionDescriptionDict.Add(831, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_5
                    actionDescriptionDict.Add(840, "TemplateTask_10steps_5 task finished with error!");
                    actionDescriptionDict.Add(841, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_6
                    actionDescriptionDict.Add(850, "TemplateTask_10steps_6 task finished with error!");
                    actionDescriptionDict.Add(851, "TemplateTask_10steps_6 task was aborted, while not yet completed!");

                    // TemplateTask_20steps_1
                    actionDescriptionDict.Add(860, "TemplateTask_20steps_1 task finished with error!");
                    actionDescriptionDict.Add(861, "TemplateTask_20steps_1 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_2
                    actionDescriptionDict.Add(880, "TemplateTask_20steps_2 task finished with error!");
                    actionDescriptionDict.Add(881, "TemplateTask_20steps_2 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_3       
                    actionDescriptionDict.Add(900, "TemplateTask_20steps_3 task finished with error!");
                    actionDescriptionDict.Add(901, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_4
                    actionDescriptionDict.Add(920, "TemplateTask_20steps_4 task finished with error!");
                    actionDescriptionDict.Add(921, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_5
                    actionDescriptionDict.Add(940, "TemplateTask_20steps_5 task finished with error!");
                    actionDescriptionDict.Add(941, "TemplateTask_20steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_6
                    actionDescriptionDict.Add(960, "TemplateTask_20steps_6 task finished with error!");
                    actionDescriptionDict.Add(961, "TemplateTask_20steps_6 task was aborted, while not yet completed!");

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
