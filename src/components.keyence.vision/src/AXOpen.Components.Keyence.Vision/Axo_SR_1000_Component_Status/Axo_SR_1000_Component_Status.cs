using AXOpen.Messaging.Static;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Keyence.Vision
{

    public partial class Axo_SR_1000_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    // ClearResultDataTask
                    errorDescriptionDict.Add(531, "Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.Error` to be reseted !");
                    errorDescriptionDict.Add(532, "Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !");
                    errorDescriptionDict.Add(533, "Waiting for the signal/variable `CompletionStatus.PresetComplete` to be reseted !");
                    errorDescriptionDict.Add(534, "Waiting for the signal/variable `CompletionStatus.RegisterPresetDataComplete` to be reseted !");
                    errorDescriptionDict.Add(535, "Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !");
                    errorDescriptionDict.Add(536, "Waiting for the signal/variable `CompletionStatus.EXT_RequestComplete` to be reseted !");
                    errorDescriptionDict.Add(537, "Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.GeneralError` to be reseted !");
                    // ReadTask
                    errorDescriptionDict.Add(581, "Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.Error` to be reseted !");
                    errorDescriptionDict.Add(582, "Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !");
                    errorDescriptionDict.Add(583, "Waiting for the signal/variable `CompletionStatus.PresetComplete` to be reseted !");
                    errorDescriptionDict.Add(584, "Waiting for the signal/variable `CompletionStatus.RegisterPresetDataComplete` to be reseted !");
                    errorDescriptionDict.Add(585, "Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !");
                    errorDescriptionDict.Add(586, "Waiting for the signal/variable `CompletionStatus.EXT_RequestComplete` to be reseted !");
                    errorDescriptionDict.Add(587, "Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.GeneralError` to be reseted !");
                    errorDescriptionDict.Add(588, "Waiting for the signal/variable `ParameterBankNumber.BankNumberRegister` to be set to value from 0 to 10 !");
                    errorDescriptionDict.Add(589, "Waiting for the signal/variable `CompletionStatus.ReadComplete` to be set !");
                    errorDescriptionDict.Add(590, "Waiting for the signal/variable `ReadData.ResultDataReadyCount` to be incremented !");
                    errorDescriptionDict.Add(591, "Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !");
                    // TuneTask
                    errorDescriptionDict.Add(601, "Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.Error` to be reseted !");
                    errorDescriptionDict.Add(602, "Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !");
                    errorDescriptionDict.Add(603, "Waiting for the signal/variable `CompletionStatus.PresetComplete` to be reseted !");
                    errorDescriptionDict.Add(604, "Waiting for the signal/variable `CompletionStatus.RegisterPresetDataComplete` to be reseted !");
                    errorDescriptionDict.Add(605, "Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !");
                    errorDescriptionDict.Add(606, "Waiting for the signal/variable `CompletionStatus.EXT_RequestComplete` to be reseted !");
                    errorDescriptionDict.Add(607, "Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.GeneralError` to be reseted !");
                    errorDescriptionDict.Add(608, "Waiting for the signal/variable `ParameterBankNumber.BankNumberRegister` to be set to value from 0 to 10 !");
                    errorDescriptionDict.Add(609, "Waiting for the signal/variable `CompletionStatus.TuneComplete` to be set !");
                    errorDescriptionDict.Add(610, "Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !");
                    //  General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDS.HwID_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");

                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDS.HwID_HandshakeAndGeneralErrorStatus is zero.");
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'HandshakeAndGeneralErrorStatus' (GsdId=101).");

                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDS.HwID_BUSY_Status is zero.");
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'BUSY_Status' (GsdId=102).");

                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDS.HwID_CompletionStatus is zero.");
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3.");
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3.");
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3.");
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3.");
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3.");
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'CompletionStatus '(GsdId=103).");

                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDS.HwID_ErrorStatus is zero.");
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4.");
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4.");
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4.");
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4.");
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4.");
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'ErrorStatus' (GsdId=104).");

                    errorDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDS.HwID_TerminalStatus is zero.");
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5.");
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5.");
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5.");
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5.");
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5.");
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: 'TerminalStatus' (GsdId=105).");

                    errorDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDS.HwID_UnstableReadStatus is zero.");
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6.");
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6.");
                    errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6.");
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6.");
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6.");
                    errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: 'UnstableReadStatus' (GsdId=106).");

                    errorDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDS.HwID_MatchingLevelAndTotalEvaluationGradeStatus is zero.");
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7.");
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7.");
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7.");
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7.");
                    errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7.");
                    errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'MatchingLevelAndTotalEvaluationGradeStatus' (GsdId=107).");

                    errorDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDS.HwID_OperationalResultStatus is zero.");
                    errorDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8.");
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8.");
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8.");
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8.");
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8.");
                    errorDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: 'OperationalResultStatus' (GsdId=108).");
                    errorDescriptionDict.Add(790, "Hw configuration error. Value of Config.HWIDS.HwID_ReadData is zero.");
                    errorDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9.");
                    errorDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9.");
                    errorDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9.");
                    errorDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9.");
                    errorDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9.");
                    errorDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: 'Result_Data-32_bytes,Result_Data-64_bytes,Result_Data-128_bytes,Result_Data-246_bytes' (GsdId=109,110,111,112).");

                    errorDescriptionDict.Add(800, "Hw configuration error. Value of Config.HWIDS.HwID_LatchAndErrorClearControlBitReg is zero.");
                    errorDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10.");
                    errorDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10.");
                    errorDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10.");
                    errorDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10.");
                    errorDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10.");
                    errorDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: 'LatchAndErrorClearControlBitReg' (GsdId=201).");

                    errorDescriptionDict.Add(810, "Hw configuration error. Value of Config.HWIDS.HwID_OperationInstructionControl is zero.");
                    errorDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11.");
                    errorDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11.");
                    errorDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11.");
                    errorDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11.");
                    errorDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11.");
                    errorDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: 'OperationInstructionControl' (GsdId=202).");

                    errorDescriptionDict.Add(820, "Hw configuration error. Value of Config.HWIDS.HwID_CompletionClearControl is zero.");
                    errorDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12.");
                    errorDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12.");
                    errorDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12.");
                    errorDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12.");
                    errorDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12.");
                    errorDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: 'CompletionClearControl' (GsdId=203).");

                    errorDescriptionDict.Add(830, "Hw configuration error. Value of Config.HWIDS.HwID_ParameterBankNumber is zero.");
                    errorDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13.");
                    errorDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13.");
                    errorDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13.");
                    errorDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13.");
                    errorDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13.");
                    errorDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: 'ParameterBankNumber' (GsdId=204).");

                    errorDescriptionDict.Add(840, "Hw configuration error. Value of Config.HWIDS.HwID_UserData is zero.");
                    errorDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14.");
                    errorDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14.");
                    errorDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14.");
                    errorDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14.");
                    errorDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14.");
                    errorDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 14. Allowed modules: 'User_Data-32_bytes,User_Data-64_bytes,User_Data-128_bytes,User_Data-250_bytes' (GsdId=205,206,207,208).");

                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDS.HwID_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDS.HwID_HandshakeAndGeneralErrorStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1133, "Input variable `Config.HWIDS.HwID_BUSY_Status` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1134, "Input variable `Config.HWIDS.HwID_CompletionStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1135, "Input variable `Config.HWIDS.HwID_ErrorStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1136, "Input variable `Config.HWIDS.HwID_TerminalStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1137, "Input variable `Config.HWIDS.HwID_UnstableReadStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1138, "Input variable `Config.HWIDS.HwID_MatchingLevelAndTotalEvaluationGradeStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1139, "Input variable `Config.HWIDS.HwID_OperationalResultStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1140, "Input variable `Config.HWIDS.HwID_ReadData` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1141, "Input variable `Config.HWIDS.HwID_LatchAndErrorClearControl` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1142, "Input variable `Config.HWIDS.HwID_OperationInstructionControl` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1143, "Input variable `Config.HWIDS.HwID_CompletionClearControl` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1144, "Input variable `Config.HWIDS.HwID_ParameterBankNumber` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1145, "Input variable `Config.HWIDS.HwID_UserData` has invalid value in `Run` method!");

                    errorDescriptionDict.Add(1201, "Error reading the HandshakeAndGeneralErrorStatus!");
                    errorDescriptionDict.Add(1202, "Error reading the BUSY_Status!");
                    errorDescriptionDict.Add(1203, "Error reading the CompletionStatus!");
                    errorDescriptionDict.Add(1204, "Error reading the ErrorStatus!");
                    errorDescriptionDict.Add(1205, "Error reading the TerminalStatus!");
                    errorDescriptionDict.Add(1206, "Error reading the UnstableReadStatus!");
                    errorDescriptionDict.Add(1207, "Error reading the MatchingLevelAndTotalEvaluationGradeStatus!");
                    errorDescriptionDict.Add(1208, "Error reading the OperationalResultStatus!");
                    errorDescriptionDict.Add(1209, "Error reading the ReadData!");
                    errorDescriptionDict.Add(1210, "ResultData has invalid size!");

                    errorDescriptionDict.Add(1231, "Error writing the LatchAndErrorClearControl!");
                    errorDescriptionDict.Add(1232, "Error writing the OperationInstructionControl!");
                    errorDescriptionDict.Add(1233, "Error writing the CompletionClearControl!");
                    errorDescriptionDict.Add(1234, "Error writing the ParameterBankNumber!");
                    errorDescriptionDict.Add(1235, "UserData has invalid size!");
                    errorDescriptionDict.Add(1236, "Error writing the 32bytes of the UserData!");
                    errorDescriptionDict.Add(1237, "Error writing the 64bytes of the UserData!");
                    errorDescriptionDict.Add(1238, "Error writing the 128bytes of the UserData!");
                    errorDescriptionDict.Add(1239, "Error writing the 250bytes of the UserData!");

                    // ClearResultDataTask;
                    errorDescriptionDict.Add(10030, "ClearResultDataTask finished with error!");
                    errorDescriptionDict.Add(10031, "ClearResultDataTask was aborted, while not yet completed!");
                    // ReadTask;
                    errorDescriptionDict.Add(10080, "ReadTask finished with error!");
                    errorDescriptionDict.Add(10081, "ReadTask was aborted, while not yet completed!");
                    // TuneTask;
                    errorDescriptionDict.Add(10100, "TuneTask task finished with error!");
                    errorDescriptionDict.Add(10101, "TuneTask task was aborted, while not yet completed!");

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

                    // ClearResultDataTask
                    actionDescriptionDict.Add(130, "ClearResultDataTask started.");
                    actionDescriptionDict.Add(330, "ClearResultDataTask running: reseting the outputs.");
                    actionDescriptionDict.Add(331, "ClearResultDataTask running: reseting the error flag.");
                    actionDescriptionDict.Add(332, "ClearResultDataTask running: reseting the read complete flag.");
                    actionDescriptionDict.Add(333, "ClearResultDataTask running: reseting the preset complete flag.");
                    actionDescriptionDict.Add(334, "ClearResultDataTask running: reseting the register preset data complete flag.");
                    actionDescriptionDict.Add(335, "ClearResultDataTask running: reseting the tune complete flag.");
                    actionDescriptionDict.Add(336, "ClearResultDataTask running: reseting the external request complete flag.");
                    actionDescriptionDict.Add(337, "ClearResultDataTask running: waiting for the general error flag is reseted.");
                    actionDescriptionDict.Add(338, "ClearResultDataTask finished.");
                    actionDescriptionDict.Add(131, "ClearResultDataTask finished succesfully.");
                    actionDescriptionDict.Add(132, "ClearResultDataTask restored.");
                    // ReadTask
                    actionDescriptionDict.Add(180, "ReadTask started.");
                    actionDescriptionDict.Add(380, "ReadTask running: reseting the outputs.");
                    actionDescriptionDict.Add(381, "ReadTask running: reseting the error flag.");
                    actionDescriptionDict.Add(382, "ReadTask running: reseting the read complete flag.");
                    actionDescriptionDict.Add(383, "ReadTask running: reseting the preset complete flag.");
                    actionDescriptionDict.Add(384, "ReadTask running: reseting the register preset data complete flag.");
                    actionDescriptionDict.Add(385, "ReadTask running: reseting the tune complete flag.");
                    actionDescriptionDict.Add(386, "ReadTask running: reseting the external request complete flag.");
                    actionDescriptionDict.Add(387, "ReadTask running: waiting for the general error flag is reseted.");
                    actionDescriptionDict.Add(388, "ReadTask running: setting bank number.");
                    actionDescriptionDict.Add(389, "ReadTask running: starting trigger.");
                    actionDescriptionDict.Add(390, "ReadTask running: waiting for the result data.");
                    actionDescriptionDict.Add(391, "ReadTask running: acknowledging results.");
                    actionDescriptionDict.Add(392, "ReadTask finished.");
                    actionDescriptionDict.Add(181, "ReadTask finished succesfully.");
                    actionDescriptionDict.Add(182, "ReadTask restored.");
                    // TuneTask
                    actionDescriptionDict.Add(200, "TuneTask started.");
                    actionDescriptionDict.Add(400, "TuneTask running: reseting the outputs.");
                    actionDescriptionDict.Add(401, "TuneTask running: reseting the error flag.");
                    actionDescriptionDict.Add(402, "TuneTask running: reseting the read complete flag.");
                    actionDescriptionDict.Add(403, "TuneTask running: reseting the preset complete flag.");
                    actionDescriptionDict.Add(404, "TuneTask running: reseting the register preset data complete flag.");
                    actionDescriptionDict.Add(405, "TuneTask running: reseting the tune complete flag.");
                    actionDescriptionDict.Add(406, "TuneTask running: reseting the external request complete flag.");
                    actionDescriptionDict.Add(407, "TuneTask running: waiting for the general error flag is reseted.");
                    actionDescriptionDict.Add(408, "TuneTask running: setting bank number.");
                    actionDescriptionDict.Add(409, "TuneTask running: starting the tunning process.");
                    actionDescriptionDict.Add(410, "TuneTask running: acknowledging the tunning process.");
                    actionDescriptionDict.Add(411, "TuneTask finished.");
                    actionDescriptionDict.Add(201, "TuneTask finished succesfully.");
                    actionDescriptionDict.Add(202, "TuneTask restored.");
                    // ClearResultDataTask
                    actionDescriptionDict.Add(10030, "ClearResultDataTask finished with error!");
                    actionDescriptionDict.Add(10031, "ClearResultDataTask was aborted, while not yet completed!");
                    // ReadTask
                    actionDescriptionDict.Add(10080, "ReadTask task finished with error!");
                    actionDescriptionDict.Add(10081, "ReadTask task was aborted, while not yet completed!");
                    // TuneTask
                    actionDescriptionDict.Add(10100, "TuneTask task finished with error!");
                    actionDescriptionDict.Add(10101, "TuneTask task was aborted, while not yet completed!");
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

