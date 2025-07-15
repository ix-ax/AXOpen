using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Components.Kuka.Robotics
{
    public partial class AxoKukaRobotics_Component_Status_v_5_x_x : AXOpen.Components.Robotics.AxoRobot_Status
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
                    errorDescriptionDict.Add(500, "Waiting for the signal Inputs.PpMoved to be set!");
                    errorDescriptionDict.Add(510,  "Waiting for the signal Inputs.UserSafetySwitchClosed to be set!");
                    errorDescriptionDict.Add(511,  "Waiting for the signal Inputs.AlarmStopActive to be set!");
                    errorDescriptionDict.Add(512,  "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(513,  "Waiting for the signal Inputs.StopMess to be reseted!");
                    errorDescriptionDict.Add(514,  "Waiting for the signal Inputs.RcReady to be set!");
                    errorDescriptionDict.Add(515,  "Waiting for the signal Inputs.InterfaceActivated to be set!");
                    errorDescriptionDict.Add(516,  "Waiting for the signal Inputs.ProActive to be set!");
                    errorDescriptionDict.Add(520,  "Waiting for the signal Inputs.UserSafetySwitchClosed to be set!");
                    errorDescriptionDict.Add(521,  "Waiting for the signal Inputs.AlarmStopActive to be set!");
                    errorDescriptionDict.Add(522,  "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(523,  "Waiting for the signal Inputs.StopMess to be reseted!");
                    errorDescriptionDict.Add(524,  "Waiting for the signal Inputs.RcReady to be set!");
                    errorDescriptionDict.Add(525,  "Waiting for the signal Inputs.InterfaceActivated to be set!");
                    errorDescriptionDict.Add(526,  "Waiting for the signal Inputs.ProActive to be set!");
                    errorDescriptionDict.Add(527,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(528,  "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(529,  "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(530,  "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(531,  "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(532,  "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(533,  "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(534,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(535,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(536,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(540,  "Waiting for the signal Inputs.UserSafetySwitchClosed to be set!");
                    errorDescriptionDict.Add(541,  "Waiting for the signal Inputs.AlarmStopActive to be set!");
                    errorDescriptionDict.Add(542,  "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(550,  "Waiting for the signal Inputs.ProActive to be set!");
                    errorDescriptionDict.Add(551,  "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(552,  "Waiting for the signal Inputs.StopMess to be reseted!");
                    errorDescriptionDict.Add(553,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(554,  "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");
                    errorDescriptionDict.Add(555,  "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");
                    errorDescriptionDict.Add(556,  "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");
                    errorDescriptionDict.Add(557,  "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");
                    errorDescriptionDict.Add(558,  "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `.");
                    errorDescriptionDict.Add(559,  "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `.");
                    errorDescriptionDict.Add(560,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(561,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(562,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");
                    errorDescriptionDict.Add(570,  "Waiting for the signal Inputs.UserSafetySwitchClosed to be set!");
                    errorDescriptionDict.Add(571,  "Waiting for the signal Inputs.AlarmStopActive to be set!");
                    errorDescriptionDict.Add(572,  "Waiting for the signal Inputs.DrivesReady to be set!");
                    errorDescriptionDict.Add(573,  "Waiting for the signal Inputs.StopMess to be reseted!");
                    errorDescriptionDict.Add(574,  "Waiting for the signal Inputs.RcReady to be set!");
                    errorDescriptionDict.Add(575,  "Waiting for the signal Inputs.InterfaceActivated to be set!");
                    errorDescriptionDict.Add(576,  "Waiting for the signal Inputs.ProActive to be set!");
                    errorDescriptionDict.Add(580,  "Waiting for the signal Inputs.DrivesReady to be reseted!");
                    errorDescriptionDict.Add(590,  "Waiting for the signal Inputs.RobotStopped to be set!");
                    errorDescriptionDict.Add(591,  "Waiting for the signal Inputs.ProActive to be reseted!");
                    errorDescriptionDict.Add(600,  "Waiting for the signal Inputs.RobotStopped to be set!");
                    errorDescriptionDict.Add(610,  "Waiting for the signal Inputs.ProActive to be reseted!");



                //  General alarms
                errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                   );
                errorDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!"                                                                      );
                errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."        );
                                                                                                                                                                                
                errorDescriptionDict.Add(710, "Hw configuration error. Value of _hwID_in_1 is zero."                                                                          );
                errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."               );
                errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."               );
                errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."               );
                errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."               );
                errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."               );
                errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(720, "Hw configuration error. Value of _hwID_in_2 is zero."                                                                          );
                errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."               );
                errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."               );
                errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."               );
                errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."               );
                errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."               );
                errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(730, "Hw configuration error. Value of _hwID_in_3 is zero."                                                                          );
                errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."               );
                errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."               );
                errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."               );
                errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."               );
                errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."               );
                errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(740, "Hw configuration error. Value of _hwID_in_4 is zero."                                                                          );
                errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."               );
                errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."               );
                errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."               );
                errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."               );
                errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."               );
                errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(750, "Hw configuration error. Value of _hwID_in_5 is zero."                                                                          );
                errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."               );
                errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."               );
                errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."               );
                errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."               );
                errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."               );
                errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(760, "Hw configuration error. Value of _hwID_in_6 is zero."                                                                          );
                errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."               );
                errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."               );
                errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."               );
                errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."               );
                errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."               );
                errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(770, "Hw configuration error. Value of _hwID_in_7 is zero."                                                                          );
                errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."               );
                errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."               );
                errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."               );
                errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."               );
                errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."               );
                errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(780, "Hw configuration error. Value of _hwID_in_8 is zero."                                                                          );
                errorDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."               );
                errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."               );
                errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."               );
                errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."               );
                errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."               );
                errorDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(790, "Hw configuration error. Value of _hwID_in_9 is zero."                                                                          );
                errorDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9."               );
                errorDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9."               );
                errorDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9."               );
                errorDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9."               );
                errorDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9."               );
                errorDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: 'gsd_id_of_req_module'."      );
                                                                                                                                                                                
                errorDescriptionDict.Add(800, "Hw configuration error. Value of _hwID_in_10 is zero."                                                                         );
                errorDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10."              );
                errorDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10."              );
                errorDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10."              );
                errorDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10."              );
                errorDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10."              );
                errorDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(810, "Hw configuration error. Value of _hwID_in_11 is zero."                                                                         );
                errorDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11."              );
                errorDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11."              );
                errorDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11."              );
                errorDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11."              );
                errorDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11."              );
                errorDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(820, "Hw configuration error. Value of _hwID_in_12 is zero."                                                                         );
                errorDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12."              );
                errorDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12."              );
                errorDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12."              );
                errorDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12."              );
                errorDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12."              );
                errorDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(830, "Hw configuration error. Value of _hwID_in_13 is zero."                                                                         );
                errorDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13."              );
                errorDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13."              );
                errorDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13."              );
                errorDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13."              );
                errorDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13."              );
                errorDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(840, "Hw configuration error. Value of _hwID_in_14 is zero."                                                                         );
                errorDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14."              );
                errorDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14."              );
                errorDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14."              );
                errorDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14."              );
                errorDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14."              );
                errorDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 14. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(850, "Hw configuration error. Value of _hwID_in_15 is zero."                                                                         );
                errorDescriptionDict.Add(851, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 15."              );
                errorDescriptionDict.Add(852, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 15."              );
                errorDescriptionDict.Add(853, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 15."              );
                errorDescriptionDict.Add(854, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 15."              );
                errorDescriptionDict.Add(855, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 15."              );
                errorDescriptionDict.Add(856, "Hw configuration error: Module with unexpected size or type detected in Slot 15. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(860, "Hw configuration error. Value of _hwID_in_16 is zero."                                                                         );
                errorDescriptionDict.Add(861, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 16."              );
                errorDescriptionDict.Add(862, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 16."              );
                errorDescriptionDict.Add(863, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 16."              );
                errorDescriptionDict.Add(864, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 16."              );
                errorDescriptionDict.Add(865, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 16."              );
                errorDescriptionDict.Add(866, "Hw configuration error: Module with unexpected size or type detected in Slot 16. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(870, "Hw configuration error. Value of _hwID_in_17 is zero."                                                                         );
                errorDescriptionDict.Add(871, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 17."              );
                errorDescriptionDict.Add(872, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 17."              );
                errorDescriptionDict.Add(873, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 17."              );
                errorDescriptionDict.Add(874, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 17."              );
                errorDescriptionDict.Add(875, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 17."              );
                errorDescriptionDict.Add(876, "Hw configuration error: Module with unexpected size or type detected in Slot 17. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(880, "Hw configuration error. Value of _hwID_in_18 is zero."                                                                         );
                errorDescriptionDict.Add(881, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 18."              );
                errorDescriptionDict.Add(882, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 18."              );
                errorDescriptionDict.Add(883, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 18."              );
                errorDescriptionDict.Add(884, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 18."              );
                errorDescriptionDict.Add(885, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 18."              );
                errorDescriptionDict.Add(886, "Hw configuration error: Module with unexpected size or type detected in Slot 18. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(890, "Hw configuration error. Value of _hwID_in_19 is zero."                                                                         );
                errorDescriptionDict.Add(891, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 19."              );
                errorDescriptionDict.Add(892, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 19."              );
                errorDescriptionDict.Add(893, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 19."              );
                errorDescriptionDict.Add(894, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 19."              );
                errorDescriptionDict.Add(895, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 19."              );
                errorDescriptionDict.Add(896, "Hw configuration error: Module with unexpected size or type detected in Slot 19. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(900, "Hw configuration error. Value of _hwID_in_20 is zero."                                                                         );
                errorDescriptionDict.Add(901, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 20."              );
                errorDescriptionDict.Add(902, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 20."              );
                errorDescriptionDict.Add(903, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 20."              );
                errorDescriptionDict.Add(904, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 20."              );
                errorDescriptionDict.Add(905, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 20."              );
                errorDescriptionDict.Add(906, "Hw configuration error: Module with unexpected size or type detected in Slot 20. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(910, "Hw configuration error. Value of _hwID_out_1 is zero."                                                                         );
                errorDescriptionDict.Add(911, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 21."              );
                errorDescriptionDict.Add(912, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 21."              );
                errorDescriptionDict.Add(913, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 21."              );
                errorDescriptionDict.Add(914, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 21."              );
                errorDescriptionDict.Add(915, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 21."              );
                errorDescriptionDict.Add(916, "Hw configuration error: Module with unexpected size or type detected in Slot 21. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(920, "Hw configuration error. Value of _hwID_out_2 is zero."                                                                         );
                errorDescriptionDict.Add(921, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 22."              );
                errorDescriptionDict.Add(922, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 22."              );
                errorDescriptionDict.Add(923, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 22."              );
                errorDescriptionDict.Add(924, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 22."              );
                errorDescriptionDict.Add(925, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 22."              );
                errorDescriptionDict.Add(926, "Hw configuration error: Module with unexpected size or type detected in Slot 22. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(930, "Hw configuration error. Value of _hwID_out_3 is zero."                                                                         );
                errorDescriptionDict.Add(931, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 23."              );
                errorDescriptionDict.Add(932, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 23."              );
                errorDescriptionDict.Add(933, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 23."              );
                errorDescriptionDict.Add(934, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 23."              );
                errorDescriptionDict.Add(935, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 23."              );
                errorDescriptionDict.Add(936, "Hw configuration error: Module with unexpected size or type detected in Slot 23. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(940, "Hw configuration error. Value of _hwID_out_4 is zero."                                                                         );
                errorDescriptionDict.Add(941, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 24."              );
                errorDescriptionDict.Add(942, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 24."              );
                errorDescriptionDict.Add(943, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 24."              );
                errorDescriptionDict.Add(944, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 24."              );
                errorDescriptionDict.Add(945, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 24."              );
                errorDescriptionDict.Add(946, "Hw configuration error: Module with unexpected size or type detected in Slot 24. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(950, "Hw configuration error. Value of _hwID_out_5 is zero."                                                                         );
                errorDescriptionDict.Add(951, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 25."              );
                errorDescriptionDict.Add(952, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 25."              );
                errorDescriptionDict.Add(953, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 25."              );
                errorDescriptionDict.Add(954, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 25."              );
                errorDescriptionDict.Add(955, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 25."              );
                errorDescriptionDict.Add(956, "Hw configuration error: Module with unexpected size or type detected in Slot 25. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(960, "Hw configuration error. Value of _hwID_out_6 is zero."                                                                         );
                errorDescriptionDict.Add(961, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 26."              );
                errorDescriptionDict.Add(962, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 26."              );
                errorDescriptionDict.Add(963, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 26."              );
                errorDescriptionDict.Add(964, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 26."              );
                errorDescriptionDict.Add(965, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 26."              );
                errorDescriptionDict.Add(966, "Hw configuration error: Module with unexpected size or type detected in Slot 26. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(970, "Hw configuration error. Value of _hwID_out_7 is zero."                                                                         );
                errorDescriptionDict.Add(971, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 27."              );
                errorDescriptionDict.Add(972, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 27."              );
                errorDescriptionDict.Add(973, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 27."              );
                errorDescriptionDict.Add(974, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 27."              );
                errorDescriptionDict.Add(975, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 27."              );
                errorDescriptionDict.Add(976, "Hw configuration error: Module with unexpected size or type detected in Slot 27. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(980, "Hw configuration error. Value of _hwID_out_8 is zero."                                                                         );
                errorDescriptionDict.Add(981, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 28."              );
                errorDescriptionDict.Add(982, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 28."              );
                errorDescriptionDict.Add(983, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 28."              );
                errorDescriptionDict.Add(984, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 28."              );
                errorDescriptionDict.Add(985, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 28."              );
                errorDescriptionDict.Add(986, "Hw configuration error: Module with unexpected size or type detected in Slot 28. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(990, "Hw configuration error. Value of _hwID_out_9 is zero."                                                                         );
                errorDescriptionDict.Add(991, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 29."              );
                errorDescriptionDict.Add(992, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 29."              );
                errorDescriptionDict.Add(993, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 29."              );
                errorDescriptionDict.Add(994, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 29."              );
                errorDescriptionDict.Add(995, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 29."              );
                errorDescriptionDict.Add(996, "Hw configuration error: Module with unexpected size or type detected in Slot 29. Expected module: 'gsd_id_of_req_module'."     );
                                                                                                                                                                                
                errorDescriptionDict.Add(1000, "Hw configuration error. Value of _hwID_out_10 is zero."                                                                       );
                errorDescriptionDict.Add(1001, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 30."             );
                errorDescriptionDict.Add(1002, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 30."             );
                errorDescriptionDict.Add(1003, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 30."             );
                errorDescriptionDict.Add(1004, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 30."             );
                errorDescriptionDict.Add(1005, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 30."             );
                errorDescriptionDict.Add(1006, "Hw configuration error: Module with unexpected size or type detected in Slot 30. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1010, "Hw configuration error. Value of _hwID_out_11 is zero."                                                                       );
                errorDescriptionDict.Add(1011, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 31."             );
                errorDescriptionDict.Add(1012, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 31."             );
                errorDescriptionDict.Add(1013, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 31."             );
                errorDescriptionDict.Add(1014, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 31."             );
                errorDescriptionDict.Add(1015, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 31."             );
                errorDescriptionDict.Add(1016, "Hw configuration error: Module with unexpected size or type detected in Slot 31. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1020, "Hw configuration error. Value of _hwID_out_12 is zero."                                                                       );
                errorDescriptionDict.Add(1021, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 32."             );
                errorDescriptionDict.Add(1022, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 32."             );
                errorDescriptionDict.Add(1023, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 32."             );
                errorDescriptionDict.Add(1024, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 32."             );
                errorDescriptionDict.Add(1025, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 32."             );
                errorDescriptionDict.Add(1026, "Hw configuration error: Module with unexpected size or type detected in Slot 32. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1030, "Hw configuration error. Value of _hwID_out_13 is zero."                                                                       );
                errorDescriptionDict.Add(1031, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 33."             );
                errorDescriptionDict.Add(1032, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 33."             );
                errorDescriptionDict.Add(1033, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 33."             );
                errorDescriptionDict.Add(1034, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 33."             );
                errorDescriptionDict.Add(1035, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 33."             );
                errorDescriptionDict.Add(1036, "Hw configuration error: Module with unexpected size or type detected in Slot 33. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1040, "Hw configuration error. Value of _hwID_out_14 is zero."                                                                       );
                errorDescriptionDict.Add(1041, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 34."             );
                errorDescriptionDict.Add(1042, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 34."             );
                errorDescriptionDict.Add(1043, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 34."             );
                errorDescriptionDict.Add(1044, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 34."             );
                errorDescriptionDict.Add(1045, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 34."             );
                errorDescriptionDict.Add(1046, "Hw configuration error: Module with unexpected size or type detected in Slot 34. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1050, "Hw configuration error. Value of _hwID_out_15 is zero."                                                                       );
                errorDescriptionDict.Add(1051, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 35."             );
                errorDescriptionDict.Add(1052, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 35."             );
                errorDescriptionDict.Add(1053, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 35."             );
                errorDescriptionDict.Add(1054, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 35."             );
                errorDescriptionDict.Add(1055, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 35."             );
                errorDescriptionDict.Add(1056, "Hw configuration error: Module with unexpected size or type detected in Slot 35. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1060, "Hw configuration error. Value of _hwID_out_16 is zero."                                                                       );
                errorDescriptionDict.Add(1061, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 36."             );
                errorDescriptionDict.Add(1062, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 36."             );
                errorDescriptionDict.Add(1063, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 36."             );
                errorDescriptionDict.Add(1064, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 36."             );
                errorDescriptionDict.Add(1065, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 36."             );
                errorDescriptionDict.Add(1066, "Hw configuration error: Module with unexpected size or type detected in Slot 36. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1070, "Hw configuration error. Value of _hwID_out_17 is zero."                                                                       );
                errorDescriptionDict.Add(1071, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 37."             );
                errorDescriptionDict.Add(1072, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 37."             );
                errorDescriptionDict.Add(1073, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 37."             );
                errorDescriptionDict.Add(1074, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 37."             );
                errorDescriptionDict.Add(1075, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 37."             );
                errorDescriptionDict.Add(1076, "Hw configuration error: Module with unexpected size or type detected in Slot 37. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1080, "Hw configuration error. Value of _hwID_out_18 is zero."                                                                       );
                errorDescriptionDict.Add(1081, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 38."             );
                errorDescriptionDict.Add(1082, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 38."             );
                errorDescriptionDict.Add(1083, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 38."             );
                errorDescriptionDict.Add(1084, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 38."             );
                errorDescriptionDict.Add(1085, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 38."             );
                errorDescriptionDict.Add(1086, "Hw configuration error: Module with unexpected size or type detected in Slot 38. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1090, "Hw configuration error. Value of _hwID_out_19 is zero."                                                                       );
                errorDescriptionDict.Add(1091, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 39."             );
                errorDescriptionDict.Add(1092, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 39."             );
                errorDescriptionDict.Add(1093, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 39."             );
                errorDescriptionDict.Add(1094, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 39."             );
                errorDescriptionDict.Add(1095, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 39."             );
                errorDescriptionDict.Add(1096, "Hw configuration error: Module with unexpected size or type detected in Slot 39. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                
                errorDescriptionDict.Add(1100, "Hw configuration error. Value of _hwID_out_20 is zero."                                                                       );
                errorDescriptionDict.Add(1101, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 40."             );
                errorDescriptionDict.Add(1102, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 40."             );
                errorDescriptionDict.Add(1103, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 40."             );
                errorDescriptionDict.Add(1104, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 40."             );
                errorDescriptionDict.Add(1105, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 40."             );
                errorDescriptionDict.Add(1106, "Hw configuration error: Module with unexpected size or type detected in Slot 40. Expected module: 'gsd_id_of_req_module'."    );
                                                                                                                                                                                                                        
                errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!"                                                                  );
                errorDescriptionDict.Add(1131, "Input variable `hwId` has invalid value in `Run` method!"                                                                     );
                errorDescriptionDict.Add(1132, "Input variable `hwID_in_1` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1133, "Input variable `hwID_in_2` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1134, "Input variable `hwID_in_3` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1135, "Input variable `hwID_in_4` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1136, "Input variable `hwID_in_5` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1137, "Input variable `hwID_in_6` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1138, "Input variable `hwID_in_7` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1139, "Input variable `hwID_in_8` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1140, "Input variable `hwID_in_9` has invalid value in `Run` method!"                                                                );
                errorDescriptionDict.Add(1141, "Input variable `hwID_in_10` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1142, "Input variable `hwID_in_11` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1143, "Input variable `hwID_in_12` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1144, "Input variable `hwID_in_13` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1145, "Input variable `hwID_in_14` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1146, "Input variable `hwID_in_15` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1147, "Input variable `hwID_in_16` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1148, "Input variable `hwID_in_17` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1149, "Input variable `hwID_in_18` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1150, "Input variable `hwID_in_19` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1151, "Input variable `hwID_in_20` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1152, "Input variable `hwID_out_1` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1153, "Input variable `hwID_out_2` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1154, "Input variable `hwID_out_3` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1155, "Input variable `hwID_out_4` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1156, "Input variable `hwID_out_5` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1157, "Input variable `hwID_out_6` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1158, "Input variable `hwID_out_7` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1159, "Input variable `hwID_out_8` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1160, "Input variable `hwID_out_9` has invalid value in `Run` method!"                                                               );
                errorDescriptionDict.Add(1161, "Input variable `hwID_out_10` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1162, "Input variable `hwID_out_11` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1163, "Input variable `hwID_out_12` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1164, "Input variable `hwID_out_13` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1165, "Input variable `hwID_out_14` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1166, "Input variable `hwID_out_15` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1167, "Input variable `hwID_out_16` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1168, "Input variable `hwID_out_17` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1169, "Input variable `hwID_out_18` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1170, "Input variable `hwID_out_19` has invalid value in `Run` method!"                                                              );
                errorDescriptionDict.Add(1171, "Input variable `hwID_out_20` has invalid value in `Run` method!"                                                              );
                                                                                                                                                                                                                        
                errorDescriptionDict.Add(1201, "Error reading the TemplateComponentInputStructure_hwID_in_1!"                                                                 );
                errorDescriptionDict.Add(1202, "Error reading the TemplateComponentInputStructure_hwID_in_2!"                                                                 );
                errorDescriptionDict.Add(1203, "Error reading the TemplateComponentInputStructure_hwID_in_3!"                                                                 );
                errorDescriptionDict.Add(1204, "Error reading the TemplateComponentInputStructure_hwID_in_4!"                                                                 );
                errorDescriptionDict.Add(1205, "Error reading the TemplateComponentInputStructure_hwID_in_5!"                                                                 );
                errorDescriptionDict.Add(1206, "Error reading the TemplateComponentInputStructure_hwID_in_6!"                                                                 );
                errorDescriptionDict.Add(1207, "Error reading the TemplateComponentInputStructure_hwID_in_7!"                                                                 );
                errorDescriptionDict.Add(1208, "Error reading the TemplateComponentInputStructure_hwID_in_8!"                                                                 );
                errorDescriptionDict.Add(1209, "Error reading the TemplateComponentInputStructure_hwID_in_9!"                                                                 );
                errorDescriptionDict.Add(1210, "Error reading the TemplateComponentInputStructure_hwID_in_10!"                                                                );
                errorDescriptionDict.Add(1211, "Error reading the TemplateComponentInputStructure_hwID_in_11!"                                                                );
                errorDescriptionDict.Add(1212, "Error reading the TemplateComponentInputStructure_hwID_in_12!"                                                                );
                errorDescriptionDict.Add(1213, "Error reading the TemplateComponentInputStructure_hwID_in_13!"                                                                );
                errorDescriptionDict.Add(1214, "Error reading the TemplateComponentInputStructure_hwID_in_14!"                                                                );
                errorDescriptionDict.Add(1215, "Error reading the TemplateComponentInputStructure_hwID_in_15!"                                                                );
                errorDescriptionDict.Add(1216, "Error reading the TemplateComponentInputStructure_hwID_in_16!"                                                                );
                errorDescriptionDict.Add(1217, "Error reading the TemplateComponentInputStructure_hwID_in_17!"                                                                );
                errorDescriptionDict.Add(1218, "Error reading the TemplateComponentInputStructure_hwID_in_18!"                                                                );
                errorDescriptionDict.Add(1219, "Error reading the TemplateComponentInputStructure_hwID_in_19!"                                                                );
                errorDescriptionDict.Add(1220, "Error reading the TemplateComponentInputStructure_hwID_in_20!"                                                                );
                                                                                                                                                                                
                errorDescriptionDict.Add(1231, "Error writing the TemplateComponentOutputStructure_hwID_out_1!"                                                               );
                errorDescriptionDict.Add(1232, "Error writing the TemplateComponentOutputStructure_hwID_out_2!"                                                               );
                errorDescriptionDict.Add(1233, "Error writing the TemplateComponentOutputStructure_hwID_out_3!"                                                               );
                errorDescriptionDict.Add(1234, "Error writing the TemplateComponentOutputStructure_hwID_out_4!"                                                               );
                errorDescriptionDict.Add(1235, "Error writing the TemplateComponentOutputStructure_hwID_out_5!"                                                               );
                errorDescriptionDict.Add(1236, "Error writing the TemplateComponentOutputStructure_hwID_out_6!"                                                               );
                errorDescriptionDict.Add(1237, "Error writing the TemplateComponentOutputStructure_hwID_out_7!"                                                               );
                errorDescriptionDict.Add(1238, "Error writing the TemplateComponentOutputStructure_hwID_out_8!"                                                               );
                errorDescriptionDict.Add(1239, "Error writing the TemplateComponentOutputStructure_hwID_out_9!"                                                               );
                errorDescriptionDict.Add(1240, "Error writing the TemplateComponentOutputStructure_hwID_out_10!"                                                              );
                errorDescriptionDict.Add(1241, "Error writing the TemplateComponentOutputStructure_hwID_out_11!"                                                              );
                errorDescriptionDict.Add(1242, "Error writing the TemplateComponentOutputStructure_hwID_out_12!"                                                              );
                errorDescriptionDict.Add(1243, "Error writing the TemplateComponentOutputStructure_hwID_out_13!"                                                              );
                errorDescriptionDict.Add(1244, "Error writing the TemplateComponentOutputStructure_hwID_out_14!"                                                              );
                errorDescriptionDict.Add(1245, "Error writing the TemplateComponentOutputStructure_hwID_out_15!"                                                              );
                errorDescriptionDict.Add(1246, "Error writing the TemplateComponentOutputStructure_hwID_out_16!"                                                              );
                errorDescriptionDict.Add(1247, "Error writing the TemplateComponentOutputStructure_hwID_out_17!"                                                              );
                errorDescriptionDict.Add(1248, "Error writing the TemplateComponentOutputStructure_hwID_out_18!"                                                              );
                errorDescriptionDict.Add(1249, "Error writing the TemplateComponentOutputStructure_hwID_out_19!"                                                              );
                errorDescriptionDict.Add(1250, "Error writing the TemplateComponentOutputStructure_hwID_out_20!");


                errorDescriptionDict.Add(10000, "Start at main finished with error!");
                errorDescriptionDict.Add(10001, "Start at main was aborted, while not yet completed!");
                errorDescriptionDict.Add(10010, "Start motors and program finished with error!");
                errorDescriptionDict.Add(10011, "Start motors and program was aborted, while not yet completed!");
                errorDescriptionDict.Add(10020, "Start motors program and movements finished with error!");
                errorDescriptionDict.Add(10021, "Start motors program and movements was aborted, while not yet completed!");
                //errorDescriptionDict.Add(10030, "TemplateTask_10steps_4 task finished with error!");
                //errorDescriptionDict.Add(10031, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                // TemplateTask_10steps_5
                errorDescriptionDict.Add(10040, "Start motors task finished with error!");
                errorDescriptionDict.Add(10041, "Start motors task was aborted, while not yet completed!");
                errorDescriptionDict.Add(10050, "Start movements task finished with error!");
                errorDescriptionDict.Add(10051, "Start movements task was aborted, while not yet completed!");
                errorDescriptionDict.Add(10070, "Start program task finished with error!");
                errorDescriptionDict.Add(10071, "Start program task was aborted, while not yet completed!");
                errorDescriptionDict.Add(10080, "Stop motors task finished with error!");
                errorDescriptionDict.Add(10081, "Stop motors task was aborted, while not yet completed!");
                errorDescriptionDict.Add(10090, "Stop movements and program task finished with error!");
                errorDescriptionDict.Add(10091, "Stop movements and program task was aborted, while not yet completed!");
                errorDescriptionDict.Add(10100, "Stop movements task finished with error!");
                errorDescriptionDict.Add(10101, "Stop movements task was aborted, while not yet completed!");
                errorDescriptionDict.Add(10110, "Stop program task finished with error!");
                errorDescriptionDict.Add(10111, "Stop program task was aborted, while not yet completed!");

                errorDescriptionDict.Add(20001, "Stop program task was aborted, while not yet completed!");
                errorDescriptionDict.Add(20002, "Stop program task was aborted, while not yet completed!");
                errorDescriptionDict.Add(20003, "Stop program task was aborted, while not yet completed!");



                    errorDescriptionDict.Add(20001, "Emergency stop activated!");
                    errorDescriptionDict.Add(20002, "Safety circuit interupted!");
                    errorDescriptionDict.Add(20003, "Program error active!");


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
                    actionDescriptionDict.Add(300, "Start at main running.");
                    actionDescriptionDict.Add(301, "Start at main running.");
                    actionDescriptionDict.Add(302, "Start at main running.");
                    actionDescriptionDict.Add(303, "Start at main running.");
                    actionDescriptionDict.Add(304, "Start at main running.");
                    actionDescriptionDict.Add(305, "Start at main running.");
                    actionDescriptionDict.Add(306, "Start at main running.");
                    actionDescriptionDict.Add(307, "Start at main running.");
                    actionDescriptionDict.Add(308, "Start at main running.");
                    actionDescriptionDict.Add(309, "Start at main running.");
                    actionDescriptionDict.Add(101, "Start at main finished succesfully.");
                    actionDescriptionDict.Add(102, "Start at main restored.");

                    actionDescriptionDict.Add(110, "Start motors and program started.");
                    actionDescriptionDict.Add(310, "Start motors and program running.");
                    actionDescriptionDict.Add(311, "Start motors and program running.");
                    actionDescriptionDict.Add(312, "Start motors and program running.");
                    actionDescriptionDict.Add(313, "Start motors and program running.");
                    actionDescriptionDict.Add(314, "Start motors and program running.");
                    actionDescriptionDict.Add(315, "Start motors and program running.");
                    actionDescriptionDict.Add(316, "Start motors and program running.");
                    actionDescriptionDict.Add(317, "Start motors and program running.");
                    actionDescriptionDict.Add(318, "Start motors and program running.");
                    actionDescriptionDict.Add(319, "Start motors and program running.");
                    actionDescriptionDict.Add(111, "Start motors and program finished succesfully.");
                    actionDescriptionDict.Add(112, "Start motors and program restored.");

                    actionDescriptionDict.Add(120, "Start motors program and movements started.");
                    actionDescriptionDict.Add(320, "Start motors program and movements running.");
                    actionDescriptionDict.Add(321, "Start motors program and movements running.");
                    actionDescriptionDict.Add(322, "Start motors program and movements running.");
                    actionDescriptionDict.Add(323, "Start motors program and movements running.");
                    actionDescriptionDict.Add(324, "Start motors program and movements running.");
                    actionDescriptionDict.Add(325, "Start motors program and movements running.");
                    actionDescriptionDict.Add(326, "Start motors program and movements running.");
                    actionDescriptionDict.Add(327, "Start motors program and movements running.");
                    actionDescriptionDict.Add(328, "Start motors program and movements running.");
                    actionDescriptionDict.Add(329, "Start motors program and movements running.");
                    actionDescriptionDict.Add(330, "Start motors program and movements running.");
                    actionDescriptionDict.Add(331, "Start motors program and movements running.");
                    actionDescriptionDict.Add(332, "Start motors program and movements running.");
                    actionDescriptionDict.Add(333, "Start motors program and movements running.");
                    actionDescriptionDict.Add(334, "Start motors program and movements running.");
                    actionDescriptionDict.Add(335, "Start motors program and movements running.");
                    actionDescriptionDict.Add(336, "Start motors program and movements running.");
                    actionDescriptionDict.Add(337, "Start motors program and movements running.");
                    actionDescriptionDict.Add(338, "Start motors program and movements running.");
                    actionDescriptionDict.Add(339, "Start motors program and movements running.");
                    actionDescriptionDict.Add(121, "Start motors program and movements finished succesfully.");
                    actionDescriptionDict.Add(122, "Start motors program and movements restored.");

                    actionDescriptionDict.Add(140, "Start motors started.");
                    actionDescriptionDict.Add(340, "Start motors running.");
                    actionDescriptionDict.Add(341, "Start motors running.");
                    actionDescriptionDict.Add(342, "Start motors running.");
                    actionDescriptionDict.Add(343, "Start motors running.");
                    actionDescriptionDict.Add(344, "Start motors running.");
                    actionDescriptionDict.Add(345, "Start motors running.");
                    actionDescriptionDict.Add(346, "Start motors running.");
                    actionDescriptionDict.Add(347, "Start motors running.");
                    actionDescriptionDict.Add(348, "Start motors running.");
                    actionDescriptionDict.Add(349, "Start motors running.");
                    actionDescriptionDict.Add(141, "Start motors finished succesfully.");
                    actionDescriptionDict.Add(142, "Start motors restored.");

                    actionDescriptionDict.Add(150, "Start movements started.");
                    actionDescriptionDict.Add(350, "Start movements running.");
                    actionDescriptionDict.Add(351, "Start movements running.");
                    actionDescriptionDict.Add(352, "Start movements running.");
                    actionDescriptionDict.Add(353, "Start movements running.");
                    actionDescriptionDict.Add(354, "Start movements running.");
                    actionDescriptionDict.Add(355, "Start movements running.");
                    actionDescriptionDict.Add(356, "Start movements running.");
                    actionDescriptionDict.Add(357, "Start movements running.");
                    actionDescriptionDict.Add(358, "Start movements running.");
                    actionDescriptionDict.Add(359, "Start movements running.");
                    actionDescriptionDict.Add(360, "Start movements running.");
                    actionDescriptionDict.Add(361, "Start movements running.");
                    actionDescriptionDict.Add(362, "Start movements running.");
                    actionDescriptionDict.Add(363, "Start movements running.");
                    actionDescriptionDict.Add(364, "Start movements running.");
                    actionDescriptionDict.Add(365, "Start movements running.");
                    actionDescriptionDict.Add(366, "Start movements running.");
                    actionDescriptionDict.Add(367, "Start movements running.");
                    actionDescriptionDict.Add(368, "Start movements running.");
                    actionDescriptionDict.Add(369, "Start movements running.");
                    actionDescriptionDict.Add(151, "Start movements finished succesfully.");
                    actionDescriptionDict.Add(152, "Start movements restored.");

                    actionDescriptionDict.Add(170, "Start program started.");
                    actionDescriptionDict.Add(370, "Start program running.");
                    actionDescriptionDict.Add(371, "Start program running.");
                    actionDescriptionDict.Add(372, "Start program running.");
                    actionDescriptionDict.Add(373, "Start program running.");
                    actionDescriptionDict.Add(374, "Start program running.");
                    actionDescriptionDict.Add(375, "Start program running.");
                    actionDescriptionDict.Add(376, "Start program running.");
                    actionDescriptionDict.Add(377, "Start program running.");
                    actionDescriptionDict.Add(378, "Start program running.");
                    actionDescriptionDict.Add(379, "Start program running.");
                    actionDescriptionDict.Add(171, "Start program finished succesfully.");
                    actionDescriptionDict.Add(172, "Start program restored.");

                    actionDescriptionDict.Add(180, "Stop motors started.");
                    actionDescriptionDict.Add(380, "Stop motors running.");
                    actionDescriptionDict.Add(381, "Stop motors running.");
                    actionDescriptionDict.Add(382, "Stop motors running.");
                    actionDescriptionDict.Add(383, "Stop motors running.");
                    actionDescriptionDict.Add(384, "Stop motors running.");
                    actionDescriptionDict.Add(385, "Stop motors running.");
                    actionDescriptionDict.Add(386, "Stop motors running.");
                    actionDescriptionDict.Add(387, "Stop motors running.");
                    actionDescriptionDict.Add(388, "Stop motors running.");
                    actionDescriptionDict.Add(389, "Stop motors running.");
                    actionDescriptionDict.Add(181, "Stop motors finished succesfully.");
                    actionDescriptionDict.Add(182, "Stop motors restored.");

                    actionDescriptionDict.Add(190, "Stop movements and program started.");
                    actionDescriptionDict.Add(390, "Stop movements and program running.");
                    actionDescriptionDict.Add(391, "Stop movements and program running.");
                    actionDescriptionDict.Add(392, "Stop movements and program running.");
                    actionDescriptionDict.Add(393, "Stop movements and program running.");
                    actionDescriptionDict.Add(394, "Stop movements and program running.");
                    actionDescriptionDict.Add(395, "Stop movements and program running.");
                    actionDescriptionDict.Add(396, "Stop movements and program running.");
                    actionDescriptionDict.Add(397, "Stop movements and program running.");
                    actionDescriptionDict.Add(398, "Stop movements and program running.");
                    actionDescriptionDict.Add(399, "Stop movements and program running.");
                    actionDescriptionDict.Add(191, "Stop movements and program finished succesfully.");
                    actionDescriptionDict.Add(192, "Stop movements and program restored.");

                    actionDescriptionDict.Add(200, "Stop movements started.");
                    actionDescriptionDict.Add(400, "Stop movements running.");
                    actionDescriptionDict.Add(401, "Stop movements running.");
                    actionDescriptionDict.Add(402, "Stop movements running.");
                    actionDescriptionDict.Add(403, "Stop movements running.");
                    actionDescriptionDict.Add(404, "Stop movements running.");
                    actionDescriptionDict.Add(405, "Stop movements running.");
                    actionDescriptionDict.Add(406, "Stop movements running.");
                    actionDescriptionDict.Add(407, "Stop movements running.");
                    actionDescriptionDict.Add(408, "Stop movements running.");
                    actionDescriptionDict.Add(409, "Stop movements running.");
                    actionDescriptionDict.Add(201, "Stop movements finished succesfully.");
                    actionDescriptionDict.Add(202, "Stop movements restored.");

                    actionDescriptionDict.Add(210, "Stop program started.");
                    actionDescriptionDict.Add(410, "Stop program running.");
                    actionDescriptionDict.Add(411, "Stop program running.");
                    actionDescriptionDict.Add(412, "Stop program running.");
                    actionDescriptionDict.Add(413, "Stop program running.");
                    actionDescriptionDict.Add(414, "Stop program running.");
                    actionDescriptionDict.Add(415, "Stop program running.");
                    actionDescriptionDict.Add(416, "Stop program running.");
                    actionDescriptionDict.Add(417, "Stop program running.");
                    actionDescriptionDict.Add(418, "Stop program running.");
                    actionDescriptionDict.Add(419, "Stop program running.");
                    actionDescriptionDict.Add(211, "Stop program finished succesfully");
                    actionDescriptionDict.Add(212, "Stop program restored.");

                    actionDescriptionDict.Add(10000, "Start at main finished with error!");
                    actionDescriptionDict.Add(10001, "Start at main was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10010, "Start motors and program finished with error!");
                    actionDescriptionDict.Add(10011, "Start motors and program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10020, "Start motors program and movements finished with error!");
                    actionDescriptionDict.Add(10021, "Start motors program and movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10040, "Start motors finished with error!");
                    actionDescriptionDict.Add(10041, "Start motors was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10050, "Start movements finished with error!");
                    actionDescriptionDict.Add(10051, "Start movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10070, "Start program finished with error!");
                    actionDescriptionDict.Add(10071, "Start program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10080, "Stop motors finished with error!");
                    actionDescriptionDict.Add(10081, "Stop motors was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10090, "Stop movements and program finished with error!");
                    actionDescriptionDict.Add(10091, "Stop movements and program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10100, "Stop movements finished with error!");
                    actionDescriptionDict.Add(10101, "Stop movements was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10110, "Stop program finished with error!");
                    actionDescriptionDict.Add(10111, "Stop program was aborted, while not yet completed!");


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

