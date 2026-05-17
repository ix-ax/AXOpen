using AXOpen.Messaging.Static;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using Renci.SshNet;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Ur.Robotics.v_3_x_x
{
    public partial class AxoUrCb3 : AXOpen.Core.AxoComponent, AXOpen.Components.Abstractions.Robotics.IAxoRobotics
    {

        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            try
            {
                InitializeMessenger();
                InitializeTaskMessenger();
                this.RebootControllerTask.Initialize(async ()=>await RebootController());
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                                                                                "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Start at main started.",                                                                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Start at main finished succesfully.",                                                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Start at main restored.",                                                                                                                  "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Start motors and program started.",                                                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Start motors and program finished succesfully.",                                                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Start motors and program restored.",                                                                                                       "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(180, new AxoMessengerTextItem("Start movements started.",                                                                                                                 "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(181, new AxoMessengerTextItem("Start movements finished succesfully.",                                                                                                    "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(182, new AxoMessengerTextItem("Start movements restored.",                                                                                                                "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(210, new AxoMessengerTextItem("Stop movements and program started.",                                                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(211, new AxoMessengerTextItem("Stop movements and program finished succesfully.",                                                                                         "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(212, new AxoMessengerTextItem("Stop movements and program restored.",                                                                                                     "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(220, new AxoMessengerTextItem("Stop movements started.",                                                                                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(221, new AxoMessengerTextItem("Stop movements finished succesfully.",                                                                                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(222, new AxoMessengerTextItem("Stop movements restored.",                                                                                                                 "")),


                //  General alarms
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                                                       ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_Device` has invalid value in `Run` method!"                                                                                                          ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                            ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_State is zero."                                                                                             ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: '1_T2O_State' (GsdId=ID_Mod_11)."                                 ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_IO is zero."                                                                                                ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: '2_T2O_IO' (GsdId=ID_Mod_12)."                                    ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints is zero."                                                                                            ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(736, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: '3_T2O_Joints' (GsdId=ID_Mod_13)."                                ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(740, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP is zero."                                                                                               ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(741, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(742, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(743, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(744, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(745, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(746, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: '4_T2O_TCP' (GsdId=ID_Mod_14)."                                   ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(750, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers is zero."                                                                     ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(751, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(752, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(753, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(754, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(755, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(756, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: '5_T2O_General_Purpose_Bit_Registers' (GsdId=ID_Mod_15)."         ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(760, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers is zero."                                                                     ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(761, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(762, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(763, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(764, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(765, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(766, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: '6_T2O_General_Purpose_Int_Registers' (GsdId=ID_Mod_16)."         ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(770, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers is zero."                                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(771, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(772, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(773, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(774, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(775, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(776, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: '7_T2O_General_Purpose_Float_Registers' (GsdId=ID_Mod_17)."       ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(780, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO is zero."                                                                                          ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(781, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(782, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(783, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(784, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(785, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(786, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: '8_O2T_Robot_IO' (GsdId=ID_Mod_18)."                              ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(790, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1 is zero."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(791, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(792, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(793, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(794, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(795, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9."                                                   ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(796, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: '9_O2T_General_Purpose_Registers_1' (GsdId=ID_Mod_19)."           ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2 is zero."                                                                       ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10."                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(802, new AxoMessengerTextItem("Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10."                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(803, new AxoMessengerTextItem("Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10."                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(804, new AxoMessengerTextItem("Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10."                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(805, new AxoMessengerTextItem("Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10."                                                  ,"Check the hardware configuration.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(806, new AxoMessengerTextItem("Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: '10_O2T_General_Purpose_Registers_2' (GsdId=ID_Mod_20)."         ,"Check the hardware configuration.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1130, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!"                                                                                                      ,"Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1131, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_Device` has invalid value in `Run` method!"                                                                                                         ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_Device` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1132, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_State` has invalid value in `Run` method!"                                                                                  ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_T2O_State` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1133, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_IO` has invalid value in `Run` method!"                                                                                     ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_T2O_IO` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1134, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints` has invalid value in `Run` method!"                                                                                 ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1135, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP` has invalid value in `Run` method!"                                                                                    ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1136, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1137, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers` has invalid value in `Run` method!"                                                          ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1138, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers` has invalid value in `Run` method!"                                                        ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1139, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO` has invalid value in `Run` method!"                                                                               ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1140, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1` has invalid value in `Run` method!"                                                            ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1141, new AxoMessengerTextItem("Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2` has invalid value in `Run` method!"                                                            ,"Check the call of the `Run` method, if the `Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1201, new AxoMessengerTextItem("Error reading the AxoUrRobotics_T2O_State!"                                                                                                                       ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_T2O_State and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1202, new AxoMessengerTextItem("Error reading the AxoUrRobotics_T2O_IO!"                                                                                                                          ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_T2O_IO and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1203, new AxoMessengerTextItem("Error reading the AxoUrRobotics_T2O_Joints!"                                                                                                                      ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1204, new AxoMessengerTextItem("Error reading the AxoUrRobotics_T2O_TCP!"                                                                                                                         ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1205, new AxoMessengerTextItem("Error reading the AxoUrRobotics_T2O_General_Purpose_Bit_Registers!"                                                                                               ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1206, new AxoMessengerTextItem("Error reading the AxoUrRobotics_T2O_General_Purpose_Int_Registers!"                                                                                               ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1207, new AxoMessengerTextItem("Error reading the AxoUrRobotics_T2O_General_Purpose_Float_Registers!"                                                                                             ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1208, new AxoMessengerTextItem("Error reading the AxoUrRobotics_O2T_Robot_IO!"                                                                                                                    ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1209, new AxoMessengerTextItem("Error reading the AxoUrRobotics_O2T_General_Purpose_Registers_1!"                                                                                                 ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1210, new AxoMessengerTextItem("Error reading the AxoUrRobotics_O2T_General_Purpose_Registers_2!"                                                                                                 ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2 and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(1231, new AxoMessengerTextItem("Error writing the AxoUrRobotics_O2T_Robot_IO!"                                                                                                                    ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1232, new AxoMessengerTextItem("Error writing the AxoUrRobotics_O2T_General_Purpose_Registers_1!"                                                                                                 ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1233, new AxoMessengerTextItem("Error writing the AxoUrRobotics_O2T_General_Purpose_Registers_2!"                                                                                                 ,"Check the value of the Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2 and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(2000, new AxoMessengerTextItem("Emergency stop active!"                                                                                                                                           ,"")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2001, new AxoMessengerTextItem("Safety Error !"                                                                                                                                                   ,"")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("Start at main finished with error!"                                                                                                                              ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("Start at main was aborted, while not yet completed!"                                                                                                             ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("Start motors and program finished with error!"                                                                                                                   ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("Start motors and program was aborted, while not yet completed!"                                                                                                  ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10030, new AxoMessengerTextItem("Start motors program and movements finished with error!"                                                                                                         ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10031, new AxoMessengerTextItem("Start motors program and movements was aborted, while not yet completed!"                                                                                        ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10060, new AxoMessengerTextItem("Start motors finished with error!"                                                                                                                               ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10061, new AxoMessengerTextItem("Start motors was aborted, while not yet completed!"                                                                                                              ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10080, new AxoMessengerTextItem("Start movements finished with error!"                                                                                                                            ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10081, new AxoMessengerTextItem("Start movements was aborted, while not yet completed!"                                                                                                           ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10100, new AxoMessengerTextItem("Start program finished with error!"                                                                                                                              ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10101, new AxoMessengerTextItem("Start program was aborted, while not yet completed!"                                                                                                             ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10110, new AxoMessengerTextItem("Stop movements and program finished with error!"                                                                                                                 ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10111, new AxoMessengerTextItem("Stop movements and program was aborted, while not yet completed!"                                                                                                ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10120, new AxoMessengerTextItem("Stop movements finished with error!"                                                                                                                             ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10121, new AxoMessengerTextItem("Stop movements was aborted, while not yet completed!"                                                                                                            ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10130, new AxoMessengerTextItem("Stop program finished with error!"                                                                                                                               ,"Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10131, new AxoMessengerTextItem("Stop program was aborted, while not yet completed!"                                                                                                              ,"Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(518,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(519,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(537,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(538,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(539,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(547,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(561,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(563,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ES_IsEmergencyStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(564,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!",                                                     "Check the status of the `Inputs.Inputs.Safety.PS_IsProtectiveStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(565,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.SS_IsSafeguardStopped` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(566,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!",                                                          "Check the status of the `Inputs.Inputs.Safety.RC_IsRecoveryMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(567,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!",                                                      "Check the status of the `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(568,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!",                                                             "Check the status of the `Inputs.Inputs.Safety.VL_IsViolation` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(569,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_0` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_0`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(572,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_1` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_1`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(573,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_2` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_2`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(574,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_3` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_3`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(575,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_4` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_4`")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(576,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.Inputs.Joints.JointMode_5` to be eqaul to 253",                                                      "Check the value of the `Inputs.Inputs.Joints.JointMode_5`")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!",                                                             "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(581,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(582,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!",                                                                 "Check the status of the `Inputs.Inputs.Safety.FT_IsFault` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(583,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(584,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.",          "Check the value of the Inputs.GlobalSpeedsignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(585,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.",                    "Check the value of the Inputs.ToolNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(586,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.",        "Check the value of the Inputs.WorkobjectNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(587,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.",                  "Check the value of the Inputs.PointNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(588,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.",    "Check the value of the Inputs.UserSpecSpeed1signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(589,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.",    "Check the value of the Inputs.UserSpecSpeed2signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNosignal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(592,  new AxoMessengerTextItem("Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.",                                   "Check the value of the Inputs.ActionNo signal")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!",                                                                    "Check the status of the `Inputs.Inputs.Robot.PW_IsPowerOn` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!",                                                                "Check the status of the `Inputs.Inputs.Safety.NO_IsNormalMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!",                                                               "Check the status of the `Inputs.Inputs.Safety.RD_IsReducedMode` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!",                                                         "Check the status of the `Inputs.Inputs.Robot.PR_IsProgramRunning` signal.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
        
        private async Task RebootController()
        {
            try
            {
                string ipAddress = await Config.IpAddress.GetAsync();
                if (!string.IsNullOrEmpty(ipAddress))
                {
                    using (var client = new SshClient(ipAddress, "root", "easybot"))
                    {
                        client.Connect();
                        client.RunCommand("reboot");
                        client.Disconnect();
                    }
                }

            }
            catch (Exception e)
            {

                throw;
            }

        }
    }
    public partial class AxoUrRobotics_Component_Status : AXOpen.Components.Robotics.AxoRobot_Status
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
                    errorDescriptionDict.Add(500, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(501, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(502, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                             

                    errorDescriptionDict.Add(510, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(511, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(512, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(513, "Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(514, "Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");                                                     
                    errorDescriptionDict.Add(515, "Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(516, "Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!");                                                          
                    errorDescriptionDict.Add(517, "Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");                                                      
                    errorDescriptionDict.Add(518, "Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!");                                                             
                    errorDescriptionDict.Add(519, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    
                    errorDescriptionDict.Add(520, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");
                    errorDescriptionDict.Add(521, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                             

                    errorDescriptionDict.Add(530, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(531, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(532, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(533, "Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(534, "Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");                                                     
                    errorDescriptionDict.Add(535, "Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(536, "Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!");                                                          
                    errorDescriptionDict.Add(537, "Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");                                                      
                    errorDescriptionDict.Add(538, "Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!");                                                             
                    errorDescriptionDict.Add(539, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    
                    errorDescriptionDict.Add(540, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                             
                    errorDescriptionDict.Add(541, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   
                    errorDescriptionDict.Add(542, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");          
                    errorDescriptionDict.Add(543, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");                    
                    errorDescriptionDict.Add(544, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");        
                    errorDescriptionDict.Add(545, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");                  
                    errorDescriptionDict.Add(546, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");    
                    errorDescriptionDict.Add(547, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");    
                    errorDescriptionDict.Add(548, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   
                    errorDescriptionDict.Add(549, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(550, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   

                    errorDescriptionDict.Add(560, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(561, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(562, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(563, "Waiting for the signal `Inputs.Inputs.Safety.ES_IsEmergencyStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(564, "Waiting for the signal `Inputs.Inputs.Safety.PS_IsProtectiveStopped` to be reseted!");                                                     
                    errorDescriptionDict.Add(565, "Waiting for the signal `Inputs.Inputs.Safety.SS_IsSafeguardStopped` to be reseted!");                                                      
                    errorDescriptionDict.Add(566, "Waiting for the signal `Inputs.Inputs.Safety.RC_IsRecoveryMode` to be reseted!");                                                          
                    errorDescriptionDict.Add(567, "Waiting for the signal `Inputs.Inputs.Safety.ST_IsStoppedDueSafety` to be reseted!");                                                      
                    errorDescriptionDict.Add(568, "Waiting for the signal `Inputs.Inputs.Safety.VL_IsViolation` to be reseted!");                                                             
                    errorDescriptionDict.Add(569, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    
                    errorDescriptionDict.Add(570, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(571, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_0` to be eqaul to 253");                                                      
                    errorDescriptionDict.Add(572, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_1` to be eqaul to 253");                                                      
                    errorDescriptionDict.Add(573, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_2` to be eqaul to 253");                                                      
                    errorDescriptionDict.Add(574, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_3` to be eqaul to 253");                                                      
                    errorDescriptionDict.Add(575, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_4` to be eqaul to 253");
                    errorDescriptionDict.Add(576, "Waiting for the value of the `Inputs.Inputs.Joints.JointMode_5` to be eqaul to 253");                                                      

                    errorDescriptionDict.Add(580, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                             
                    errorDescriptionDict.Add(581, "Waiting for the signal `Inputs.Inputs.Robot.PW_IsPowerOn` to be set!");                                                                    
                    errorDescriptionDict.Add(582, "Waiting for the signal `Inputs.Inputs.Safety.FT_IsFault` to be reseted!");                                                                 
                    errorDescriptionDict.Add(583, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   
                    errorDescriptionDict.Add(584, "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");          
                    errorDescriptionDict.Add(585, "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");                    
                    errorDescriptionDict.Add(586, "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");        
                    errorDescriptionDict.Add(587, "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");                  
                    errorDescriptionDict.Add(588, "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");    
                    errorDescriptionDict.Add(589, "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");    
                    errorDescriptionDict.Add(590, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   
                    errorDescriptionDict.Add(591, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(592, "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                   

                    errorDescriptionDict.Add(600, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(601, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(602, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be set!");                                                                    

                    errorDescriptionDict.Add(610, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(611, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(612, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!");                                                         

                    errorDescriptionDict.Add(620, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(621, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");                                                               
                    errorDescriptionDict.Add(622, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!");                                                         

                    errorDescriptionDict.Add(630, "Waiting for the signal `Inputs.Inputs.Safety.NO_IsNormalMode` to be set!");                                                                
                    errorDescriptionDict.Add(631, "Waiting for the signal `Inputs.Inputs.Safety.RD_IsReducedMode` to be set!");
                    errorDescriptionDict.Add(632, "Waiting for the signal `Inputs.Inputs.Robot.PR_IsProgramRunning` to be reseted!");

                    //  General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                                                       );
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwId_Device` has invalid value in `Run` method!"                                                                                                        );
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                          );
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_State is zero."                                                                                           );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                                 );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                                 );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                                 );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                                 );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                                 );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: '1_T2O_State' (GsdId=ID_Mod_11)."                               );
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_IO is zero."                                                                                              );
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                                                 );
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                                                 );
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                                                 );
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                                                 );
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                                                 );
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: '2_T2O_IO' (GsdId=ID_Mod_12)."                                  );
                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints is zero."                                                                                          );
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                                                 );
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                                                 );
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                                                 );
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                                                 );
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                                                 );
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: '3_T2O_Joints' (GsdId=ID_Mod_13)."                              );
                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP is zero."                                                                                             );
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                                                 );
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                                                 );
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                                                 );
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                                                 );
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                                                 );
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: '4_T2O_TCP' (GsdId=ID_Mod_14)."                                 );
                    errorDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers is zero."                                                                   );
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."                                                 );
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."                                                 );
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."                                                 );
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."                                                 );
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."                                                 );
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: '5_T2O_General_Purpose_Bit_Registers' (GsdId=ID_Mod_15)."       );
                    errorDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers is zero."                                                                   );
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."                                                 );
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."                                                 );
                    errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."                                                 );
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."                                                 );
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."                                                 );
                    errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: '6_T2O_General_Purpose_Int_Registers' (GsdId=ID_Mod_16)."       );
                    errorDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers is zero."                                                                 );
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."                                                 );
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."                                                 );
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."                                                 );
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."                                                 );
                    errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."                                                 );
                    errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: '7_T2O_General_Purpose_Float_Registers' (GsdId=ID_Mod_17)."     );
                    errorDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO is zero."                                                                                        );
                    errorDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."                                                 );
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."                                                 );
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."                                                 );
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."                                                 );
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."                                                 );
                    errorDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: '8_O2T_Robot_IO' (GsdId=ID_Mod_18)."                            );
                    errorDescriptionDict.Add(790, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1 is zero."                                                                     );
                    errorDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9."                                                 );
                    errorDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9."                                                 );
                    errorDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9."                                                 );
                    errorDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9."                                                 );
                    errorDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9."                                                 );
                    errorDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: '9_O2T_General_Purpose_Registers_1' (GsdId=ID_Mod_19)."         );
                    errorDescriptionDict.Add(800, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2 is zero."                                                                     );
                    errorDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10."                                                );
                    errorDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10."                                                );
                    errorDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10."                                                );
                    errorDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10."                                                );
                    errorDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10."                                                );
                    errorDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: '10_O2T_General_Purpose_Registers_2' (GsdId=ID_Mod_20)."       );
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!"                                                                                                    );
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HwId_` has invalid value in `Run` method!"                                                                                                       );
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_State` has invalid value in `Run` method!"                                                                                );
                    errorDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_IO` has invalid value in `Run` method!"                                                                                   );
                    errorDescriptionDict.Add(1134, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints` has invalid value in `Run` method!"                                                                               );
                    errorDescriptionDict.Add(1135, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP` has invalid value in `Run` method!"                                                                                  );
                    errorDescriptionDict.Add(1136, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1137, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers` has invalid value in `Run` method!"                                                        );
                    errorDescriptionDict.Add(1138, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers` has invalid value in `Run` method!"                                                      );
                    errorDescriptionDict.Add(1139, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO` has invalid value in `Run` method!"                                                                             );
                    errorDescriptionDict.Add(1140, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1` has invalid value in `Run` method!"                                                          );
                    errorDescriptionDict.Add(1141, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2` has invalid value in `Run` method!"                                                          );
                    errorDescriptionDict.Add(1201, "Error reading the AxoUrRobotics_T2O_State!"                                                                                                                     );
                    errorDescriptionDict.Add(1202, "Error reading the AxoUrRobotics_T2O_IO!"                                                                                                                        );
                    errorDescriptionDict.Add(1203, "Error reading the AxoUrRobotics_T2O_Joints!"                                                                                                                    );
                    errorDescriptionDict.Add(1204, "Error reading the AxoUrRobotics_T2O_TCP!"                                                                                                                       );
                    errorDescriptionDict.Add(1205, "Error reading the AxoUrRobotics_T2O_General_Purpose_Bit_Registers!"                                                                                             );
                    errorDescriptionDict.Add(1206, "Error reading the AxoUrRobotics_T2O_General_Purpose_Int_Registers!"                                                                                             );
                    errorDescriptionDict.Add(1207, "Error reading the AxoUrRobotics_T2O_General_Purpose_Float_Registers!"                                                                                           );
                    errorDescriptionDict.Add(1208, "Error reading the AxoUrRobotics_O2T_Robot_IO!"                                                                                                                  );
                    errorDescriptionDict.Add(1209, "Error reading the AxoUrRobotics_O2T_General_Purpose_Registers_1!"                                                                                               );
                    errorDescriptionDict.Add(1210, "Error reading the AxoUrRobotics_O2T_General_Purpose_Registers_2!"                                                                                               );
                    errorDescriptionDict.Add(1231, "Error writing the AxoUrRobotics_O2T_Robot_IO!"                                                                                                                  );
                    errorDescriptionDict.Add(1232, "Error writing the AxoUrRobotics_O2T_General_Purpose_Registers_1!"                                                                                               );
                    errorDescriptionDict.Add(1233, "Error writing the AxoUrRobotics_O2T_General_Purpose_Registers_2!"                                                                                               );
                    errorDescriptionDict.Add(2000, "Emergency stop active!"                                                                                                                                         );
                    errorDescriptionDict.Add(2001, "Safety Error !"                                                                                                                                                 );
                    errorDescriptionDict.Add(10000, "Start at main finished with error!"                                                                                                                            );
                    errorDescriptionDict.Add(10001, "Start at main was aborted, while not yet completed!"                                                                                                           );
                    errorDescriptionDict.Add(10010, "Start motors and program finished with error!"                                                                                                                 );
                    errorDescriptionDict.Add(10011, "Start motors and program was aborted, while not yet completed!"                                                                                                );
                    errorDescriptionDict.Add(10080, "Start movements finished with error!"                                                                                                                          );
                    errorDescriptionDict.Add(10081, "Start movements was aborted, while not yet completed!"                                                                                                         );
                    errorDescriptionDict.Add(10110, "Stop movements and program finished with error!"                                                                                                               );
                    errorDescriptionDict.Add(10111, "Stop movements and program was aborted, while not yet completed!"                                                                                              );
                    errorDescriptionDict.Add(10120, "Stop movements finished with error!"                                                                                                                           );
                    errorDescriptionDict.Add(10121, "Stop movements was aborted, while not yet completed!"                                                                                                          );

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
                    actionDescriptionDict.Add(50,  "Restore has been executed.");                                                                 
                    actionDescriptionDict.Add(100, "Start at main started.");
                    actionDescriptionDict.Add(300, "Start at main running: waiting for 'NORMAL' or 'REDUCED' mode is choosen.");
                    actionDescriptionDict.Add(302, "Start at main running: waiting for the program to start running.");
                    actionDescriptionDict.Add(303, "Start at main finished.");
                    actionDescriptionDict.Add(101, "Start at main finished succesfully.");                                                       
                    actionDescriptionDict.Add(102, "Start at main restored.");      
                    
                    actionDescriptionDict.Add(110, "Start motors and program started.");
                    actionDescriptionDict.Add(310, "Start motors and program running: waiting for 'NORMAL' or 'REDUCED' mode is choosen.");
                    actionDescriptionDict.Add(312, "Start motors and program running: waiting for the error to be reset (on the robot teach pendant).");
                    actionDescriptionDict.Add(313, "Start motors and program running: waiting for the emergency stop error to be reset (on the robot teach pendant).");
                    actionDescriptionDict.Add(319, "Start motors and program running: waiting for the motors to be powered on.");
                    actionDescriptionDict.Add(320, "Start motors and program running: waiting for the motors to be powered on.");
                    actionDescriptionDict.Add(321, "Start motors and program running: waiting for the program to start running.");
                    actionDescriptionDict.Add(322, "Start motors and program finished.");
                    actionDescriptionDict.Add(111, "Start motors and program finished succesfully.");                                            
                    actionDescriptionDict.Add(112, "Start motors and program restored.");                                                        

                    
                    actionDescriptionDict.Add(180, "Start movements started.");
                    actionDescriptionDict.Add(380, "Start movements running: waiting for the program to start running.");
                    actionDescriptionDict.Add(381, "Start movements running: waiting for the motors to be powered on.");
                    actionDescriptionDict.Add(382, "Start movements running: waiting for the error to be reset (on the robot teach pendant).");
                    actionDescriptionDict.Add(383, "Start movements running: sending parameters of the movement to the controller.");
                    actionDescriptionDict.Add(384, "Start movements running: waiting for the movement parameters sent to the controller to be mirrored back.");
                    actionDescriptionDict.Add(390, "Start movements running: acknowleadging of the movement parameters.");
                    actionDescriptionDict.Add(391, "Start movements running: waiting for the movement is finished.");
                    actionDescriptionDict.Add(392, "Start movements running: acknowleadging of the finished movement.");
                    actionDescriptionDict.Add(181, "Start movements finished succesfully.");                                                     
                    actionDescriptionDict.Add(182, "Start movements restored.");                                                                 

                    actionDescriptionDict.Add(210, "Stop movements and program started.");
                    actionDescriptionDict.Add(410, "Stop movements and program running: waiting for 'NORMAL' or 'REDUCED' mode is choosen.");
                    actionDescriptionDict.Add(412, "Stop movements and program running: waiting for the program to be stopped.");
                    actionDescriptionDict.Add(413, "Stop movements and program finished.");
                    actionDescriptionDict.Add(211, "Stop movements and program finished succesfully.");                                          
                    actionDescriptionDict.Add(212, "Stop movements and program restored.");                                                      

                    actionDescriptionDict.Add(220, "Stop movements started.");
                    actionDescriptionDict.Add(420, "Stop movements running: waiting for 'NORMAL' or 'REDUCED' mode is choosen.");
                    actionDescriptionDict.Add(421, "Stop movements running: waiting for the program to be stopped.");
                    actionDescriptionDict.Add(422, "Stop movements finished.");
                    actionDescriptionDict.Add(221, "Stop movements finished succesfully.");                                                      
                    actionDescriptionDict.Add(222, "Stop movements restored.");                                                                  


                    //  General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `Config.HWIDs.HwId_Device` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    actionDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_State is zero.");
                    actionDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    actionDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    actionDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    actionDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    actionDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    actionDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: '1_T2O_State' (GsdId=ID_Mod_11).");
                    actionDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_IO is zero.");
                    actionDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    actionDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    actionDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    actionDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    actionDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    actionDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: '2_T2O_IO' (GsdId=ID_Mod_12).");
                    actionDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints is zero.");
                    actionDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3.");
                    actionDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3.");
                    actionDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3.");
                    actionDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3.");
                    actionDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3.");
                    actionDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: '3_T2O_Joints' (GsdId=ID_Mod_13).");
                    actionDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP is zero.");
                    actionDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4.");
                    actionDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4.");
                    actionDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4.");
                    actionDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4.");
                    actionDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4.");
                    actionDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: '4_T2O_TCP' (GsdId=ID_Mod_14).");
                    actionDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers is zero.");
                    actionDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5.");
                    actionDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5.");
                    actionDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5.");
                    actionDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5.");
                    actionDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5.");
                    actionDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: '5_T2O_General_Purpose_Bit_Registers' (GsdId=ID_Mod_15).");
                    actionDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers is zero.");
                    actionDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6.");
                    actionDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6.");
                    actionDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6.");
                    actionDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6.");
                    actionDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6.");
                    actionDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: '6_T2O_General_Purpose_Int_Registers' (GsdId=ID_Mod_16).");
                    actionDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers is zero.");
                    actionDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7.");
                    actionDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7.");
                    actionDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7.");
                    actionDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7.");
                    actionDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7.");
                    actionDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: '7_T2O_General_Purpose_Float_Registers' (GsdId=ID_Mod_17).");
                    actionDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO is zero.");
                    actionDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8.");
                    actionDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8.");
                    actionDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8.");
                    actionDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8.");
                    actionDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8.");
                    actionDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: '8_O2T_Robot_IO' (GsdId=ID_Mod_18).");
                    actionDescriptionDict.Add(790, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1 is zero.");
                    actionDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9.");
                    actionDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9.");
                    actionDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9.");
                    actionDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9.");
                    actionDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9.");
                    actionDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: '9_O2T_General_Purpose_Registers_1' (GsdId=ID_Mod_19).");
                    actionDescriptionDict.Add(800, "Hw configuration error. Value of Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2 is zero.");
                    actionDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10.");
                    actionDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10.");
                    actionDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10.");
                    actionDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10.");
                    actionDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10.");
                    actionDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: '10_O2T_General_Purpose_Registers_2' (GsdId=ID_Mod_20).");
                    actionDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HwId_` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_State` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_IO` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1134, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1135, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1136, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1137, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1138, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1139, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1140, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1141, "Input variable `Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(1201, "Error reading the AxoUrRobotics_T2O_State!");
                    actionDescriptionDict.Add(1202, "Error reading the AxoUrRobotics_T2O_IO!");
                    actionDescriptionDict.Add(1203, "Error reading the AxoUrRobotics_T2O_Joints!");
                    actionDescriptionDict.Add(1204, "Error reading the AxoUrRobotics_T2O_TCP!");
                    actionDescriptionDict.Add(1205, "Error reading the AxoUrRobotics_T2O_General_Purpose_Bit_Registers!");
                    actionDescriptionDict.Add(1206, "Error reading the AxoUrRobotics_T2O_General_Purpose_Int_Registers!");
                    actionDescriptionDict.Add(1207, "Error reading the AxoUrRobotics_T2O_General_Purpose_Float_Registers!");
                    actionDescriptionDict.Add(1208, "Error reading the AxoUrRobotics_O2T_Robot_IO!");
                    actionDescriptionDict.Add(1209, "Error reading the AxoUrRobotics_O2T_General_Purpose_Registers_1!");
                    actionDescriptionDict.Add(1210, "Error reading the AxoUrRobotics_O2T_General_Purpose_Registers_2!");
                    actionDescriptionDict.Add(1231, "Error writing the AxoUrRobotics_O2T_Robot_IO!");
                    actionDescriptionDict.Add(1232, "Error writing the AxoUrRobotics_O2T_General_Purpose_Registers_1!");
                    actionDescriptionDict.Add(1233, "Error writing the AxoUrRobotics_O2T_General_Purpose_Registers_2!");
                    actionDescriptionDict.Add(2000, "Emergency stop active!");
                    actionDescriptionDict.Add(2001, "Safety Error !");
                    actionDescriptionDict.Add(10000, "Start at main finished with error!");
                    actionDescriptionDict.Add(10001, "Start at main was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10010, "Start motors and program finished with error!");
                    actionDescriptionDict.Add(10011, "Start motors and program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10030, "Start motors program and movements finished with error!");
                    actionDescriptionDict.Add(10031, "Start motors program and movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10060, "Start motors finished with error!");
                    actionDescriptionDict.Add(10061, "Start motors was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10080, "Start movements finished with error!");
                    actionDescriptionDict.Add(10081, "Start movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10100, "Start program finished with error!");
                    actionDescriptionDict.Add(10101, "Start program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10110, "Stop movements and program finished with error!");
                    actionDescriptionDict.Add(10111, "Stop movements and program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10120, "Stop movements finished with error!");
                    actionDescriptionDict.Add(10121, "Stop movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10130, "Stop program finished with error!");
                    actionDescriptionDict.Add(10131, "Stop program was aborted, while not yet completed!");
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

