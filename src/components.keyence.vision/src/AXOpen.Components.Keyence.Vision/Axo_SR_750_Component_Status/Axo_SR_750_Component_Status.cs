using AXOpen.Messaging.Static;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Keyence.Vision
{

    public partial class Axo_SR_750_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    //// Stop task
                    //errorDescriptionDict.Add(500, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(501, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(502, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(503, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(504, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(505, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(506, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(507, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(508, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(509, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //// Move to home task
                    //errorDescriptionDict.Add(510, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(511, "Waiting for the signal `Inputs.Status.WorkSensor` to be reseted!" );                        
                    //errorDescriptionDict.Add(512, "Waiting for the signal `Inputs.Status.HomeSensor` to be set!" );                        
                    //errorDescriptionDict.Add(513, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(514, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(515, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(516, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(517, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(518, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(519, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //// Move to work task
                    //errorDescriptionDict.Add(520, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(521, "Waiting for the signal `Inputs.Status.HomeSensor` to be reseted!" );                        
                    //errorDescriptionDict.Add(522, "Waiting for the signal `Inputs.Status.WorkSensor` to be set!" );                        
                    //errorDescriptionDict.Add(523, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(524, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(525, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(526, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(527, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(528, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(529, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    // ClearResultDataTask
                    errorDescriptionDict.Add(530, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(531, "Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.Error` to be reseted !");                       
                    errorDescriptionDict.Add(532, "Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !");                       
                    errorDescriptionDict.Add(533, "Waiting for the signal/variable `CompletionStatus.PresetComplete` to be reseted !");                       
                    errorDescriptionDict.Add(534, "Waiting for the signal/variable `CompletionStatus.RegisterPresetDataComplete` to be reseted !");                       
                    errorDescriptionDict.Add(535, "Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !");                       
                    errorDescriptionDict.Add(536, "Waiting for the signal/variable `CompletionStatus.EXT_RequestComplete` to be reseted !");                       
                    errorDescriptionDict.Add(537, "Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.GeneralError` to be reseted !");                       
                    errorDescriptionDict.Add(538, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(539, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //// TemplateTask_10steps_2
                    //errorDescriptionDict.Add(540, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(541, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(542, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(543, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(544, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(545, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(546, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(547, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(548, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(549, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //// TemplateTask_10steps_3
                    //errorDescriptionDict.Add(550, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(551, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(552, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(553, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(554, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(555, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(556, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(557, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(558, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(559, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //// TemplateTask_10steps_4
                    //errorDescriptionDict.Add(560, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(561, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(562, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(563, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(564, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(565, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(566, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(567, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(568, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(569, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //// TemplateTask_10steps_5
                    //errorDescriptionDict.Add(570, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(571, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(572, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(573, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(574, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(575, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(576, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(577, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(578, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(579, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    // ReadTask
                    errorDescriptionDict.Add(580, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
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
                    errorDescriptionDict.Add(592, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(593, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(594, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(595, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(596, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(597, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(598, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(599, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    // TemplateTask_20steps_2
                    errorDescriptionDict.Add(600, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
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
                    errorDescriptionDict.Add(611, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(612, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(613, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(614, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(615, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(616, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(617, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(618, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    errorDescriptionDict.Add(619, "Waiting for the signal/variable `<insert name>` to be set/reseted !");
                    //// TuneTask
                    //errorDescriptionDict.Add(620, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(621, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(622, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(623, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(624, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(625, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(626, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(627, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(628, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(629, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(630, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(631, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(632, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(633, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(634, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(635, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(636, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(637, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(638, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(639, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //// TemplateTask_20steps_4
                    //errorDescriptionDict.Add(640, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(641, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(642, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(643, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(644, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(645, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(646, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(647, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(648, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(649, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(650, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(651, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(652, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(653, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(654, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(655, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(656, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(657, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(658, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(659, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //// TemplateTask_20steps_5
                    //errorDescriptionDict.Add(660, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(661, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(662, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(663, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(664, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(665, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(666, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(667, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(668, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(669, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(670, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(671, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(672, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(673, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(674, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(675, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(676, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(677, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(678, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    //errorDescriptionDict.Add(679, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    // General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    errorDescriptionDict.Add(703, "Hw configuration error. Value of _hwIdHandshakeAndGeneralErrorStatus is zero.");
                    errorDescriptionDict.Add(704, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    errorDescriptionDict.Add(705, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    errorDescriptionDict.Add(706, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    errorDescriptionDict.Add(707, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    errorDescriptionDict.Add(708, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    errorDescriptionDict.Add(709, "Hw configuration error. Value of _hwIdBUSY_Status is zero.");
                    errorDescriptionDict.Add(710, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    errorDescriptionDict.Add(715, "Hw configuration error. Value of _hwIdCompletionStatus is zero.");
                    errorDescriptionDict.Add(716, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3.");
                    errorDescriptionDict.Add(717, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3.");
                    errorDescriptionDict.Add(718, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3.");
                    errorDescriptionDict.Add(719, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3.");
                    errorDescriptionDict.Add(720, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3.");
                    errorDescriptionDict.Add(721, "Hw configuration error. Value of _hwIdErrorStatus is zero.");
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4.");
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4.");
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4.");
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4.");
                    errorDescriptionDict.Add(726, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4.");
                    errorDescriptionDict.Add(727, "Hw configuration error. Value of _hwIdTerminalStatus is zero.");
                    errorDescriptionDict.Add(728, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5.");
                    errorDescriptionDict.Add(729, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5.");
                    errorDescriptionDict.Add(730, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5.");
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5.");
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5.");
                    errorDescriptionDict.Add(733, "Hw configuration error. Value of _hwIdUnstableReadStatus is zero.");
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6.");
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6.");
                    errorDescriptionDict.Add(736, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6.");
                    errorDescriptionDict.Add(737, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6.");
                    errorDescriptionDict.Add(738, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6.");
                    errorDescriptionDict.Add(739, "Hw configuration error. Value of _hwIdMatchingLevelAndTotalEvaluationGradeStatus is zero.");
                    errorDescriptionDict.Add(740, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7.");
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7.");
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7.");
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7.");
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7.");
                    errorDescriptionDict.Add(745, "Hw configuration error. Value of _hwIdOperationalResultStatus is zero.");
                    errorDescriptionDict.Add(746, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8.");
                    errorDescriptionDict.Add(747, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8.");
                    errorDescriptionDict.Add(748, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8.");
                    errorDescriptionDict.Add(749, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8.");
                    errorDescriptionDict.Add(750, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8.");
                    errorDescriptionDict.Add(751, "Hw configuration error. Value of _hwIdReadData is zero.");
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9.");
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9.");
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9.");
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9.");
                    errorDescriptionDict.Add(756, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9.");
                    errorDescriptionDict.Add(757, "Hw configuration error. Value of _hwIdLatchAndErrorClearControl is zero.");
                    errorDescriptionDict.Add(758, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10.");
                    errorDescriptionDict.Add(759, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10.");
                    errorDescriptionDict.Add(760, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10.");
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10.");
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10.");
                    errorDescriptionDict.Add(763, "Hw configuration error. Value of _hwIdOperationInstructionControl is zero.");
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11.");
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11.");
                    errorDescriptionDict.Add(766, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11.");
                    errorDescriptionDict.Add(767, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11.");
                    errorDescriptionDict.Add(768, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11.");
                    errorDescriptionDict.Add(769, "Hw configuration error. Value of _hwIdCompletionClearControl is zero.");
                    errorDescriptionDict.Add(770, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12.");
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12.");
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12.");
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12.");
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12.");
                    errorDescriptionDict.Add(775, "Hw configuration error. Value of _hwIdParameterBankNumber is zero.");
                    errorDescriptionDict.Add(776, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13.");
                    errorDescriptionDict.Add(777, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13.");
                    errorDescriptionDict.Add(778, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13.");
                    errorDescriptionDict.Add(779, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13.");
                    errorDescriptionDict.Add(780, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13.");
                    errorDescriptionDict.Add(781, "Hw configuration error. Value of _hwIdUserData is zero.");
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14.");
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14.");
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14.");
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14.");
                    errorDescriptionDict.Add(786, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14.");

                    errorDescriptionDict.Add(860, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(861, "Input variable `_hwID` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(862, "Input variable `_hwIdHandshakeAndGeneralErrorStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(863, "Input variable `_hwIdBUSY_Status` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(864, "Input variable `_hwIdCompletionStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(865, "Input variable `_hwIdErrorStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(866, "Input variable `_hwIdTerminalStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(867, "Input variable `_hwIdUnstableReadStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(868, "Input variable `_hwIdMatchingLevelAndTotalEvaluationGradeStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(869, "Input variable `_hwIdOperationalResultStatus` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(870, "Input variable `_hwIdReadData` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(871, "Input variable `_hwIdLatchAndErrorClearControl` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(872, "Input variable `_hwIdOperationInstructionControl` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(873, "Input variable `_hwIdCompletionClearControl` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(874, "Input variable `_hwIdParameterBankNumber` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(875, "Input variable `_hwIdUserData` has invalid value in `Run` method!");


                    //// Stop task
                    //errorDescriptionDict.Add(900, "Stop task finished with error!");
                    //errorDescriptionDict.Add(901, "Stop task was aborted, while not yet completed!");
                    //// Move to home task
                    //errorDescriptionDict.Add(910, "Move to home task finished with error!");
                    //errorDescriptionDict.Add(911, "Move to home task was aborted, while not yet completed!");
                    //// Move to work task
                    //errorDescriptionDict.Add(920, "Move to work task finished with error!");
                    //errorDescriptionDict.Add(921, "Move to work task was aborted, while not yet completed!");
                    // ClearResultDataTask
                    errorDescriptionDict.Add(930, "ClearResultDataTask finished with error!");
                    errorDescriptionDict.Add(931, "ClearResultDataTask was aborted, while not yet completed!");
                    //// TemplateTask_10steps_2
                    //errorDescriptionDict.Add(940, "TemplateTask_10steps_2 finished with error!");
                    //errorDescriptionDict.Add(941, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    //// TemplateTask_10steps_3
                    //errorDescriptionDict.Add(950, "TemplateTask_10steps_3 finished with error!");
                    //errorDescriptionDict.Add(951, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    //// TemplateTask_10steps_4
                    //errorDescriptionDict.Add(960, "TemplateTask_10steps_4 task finished with error!");
                    //errorDescriptionDict.Add(961, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    //// TemplateTask_10steps_5
                    //errorDescriptionDict.Add(970, "TemplateTask_10steps_5 task finished with error!");
                    //errorDescriptionDict.Add(971, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // ReadTask
                    errorDescriptionDict.Add(980, "ReadTask task finished with error!");
                    errorDescriptionDict.Add(981, "ReadTask task was aborted, while not yet completed!");
                    // TuneTask
                    errorDescriptionDict.Add(1000, "TuneTask task finished with error!");
                    errorDescriptionDict.Add(1001, "TuneTask task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_3
                    //errorDescriptionDict.Add(1020, "TemplateTask_20steps_3 task finished with error!");
                    //errorDescriptionDict.Add(1021, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_4
                    //errorDescriptionDict.Add(1040, "TemplateTask_20steps_4 task finished with error!");
                    //errorDescriptionDict.Add(1041, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_5
                    //errorDescriptionDict.Add(1060, "TemplateTask_20steps_5 task finished with error!");
                    //errorDescriptionDict.Add(1061, "TemplateTask_20steps_5 task was aborted, while not yet completed!");

                    errorDescriptionDict.Add(1201, "Error reading the HandshakeAndGeneralErrorStatus!");
                    errorDescriptionDict.Add(1202, "Error reading the BUSY_Status!");
                    errorDescriptionDict.Add(1203, "Error reading the CompletionStatus!");
                    errorDescriptionDict.Add(1204, "Error reading the ErrorStatus!");
                    errorDescriptionDict.Add(1205, "Error reading the TerminalStatus!");
                    errorDescriptionDict.Add(1206, "Error reading the UnstableReadStatus!");
                    errorDescriptionDict.Add(1207, "Error reading the MatchingLevelAndTotalEvaluationGradeStatus!");
                    errorDescriptionDict.Add(1208, "Error reading the OperationalResultStatus!");
                    errorDescriptionDict.Add(1209, "Invalid hw configuration, result data size must be: 32b,64b,128b or 246b!");

                    errorDescriptionDict.Add(1221, "Error writing the LatchAndErrorClearControl!");
                    errorDescriptionDict.Add(1222, "Error writing the OperationInstructionControl!");
                    errorDescriptionDict.Add(1223, "Error writing the CompletionClearControl!");
                    errorDescriptionDict.Add(1224, "Error writing the ParameterBankNumber!");
                    errorDescriptionDict.Add(1225, "Invalid hw configuration, user data size must be: 32b,64b,128b or 252b!");
                    errorDescriptionDict.Add(1226, "Error writing the 32 bytes of UserData!");
                    errorDescriptionDict.Add(1227, "Error writing the 64 bytes of UserData!");
                    errorDescriptionDict.Add(1228, "Error writing the 128 bytes of UserData!");
                    errorDescriptionDict.Add(1229, "Error writing the 252 bytes of UserData!");


                    errorDescriptionDict.Add(1301, "Hardware configuration error: Unexpected module detected in Slot 1. Expected module: 'ID_MODULE_OUTPUT4W'.");
                    errorDescriptionDict.Add(1302, "Hardware configuration error: Unexpected module detected in Slot 2. Expected module: 'ID_MODULE_OUTPUT4W'.");
                    errorDescriptionDict.Add(1303, "Hardware configuration error: Unexpected module detected in Slot 3. Expected module: 'ID_MODULE_OUTPUT4W'.");
                    errorDescriptionDict.Add(1304, "Hardware configuration error: Unexpected module detected in Slot 4. Expected module: 'ID_MODULE_OUTPUT4W'.");
                    errorDescriptionDict.Add(1305, "Hardware configuration error: Unexpected module detected in Slot 5. Expected module: 'ID_MODULE_OUTPUT4W'.");
                    errorDescriptionDict.Add(1306, "Hardware configuration error: Unexpected module detected in Slot 6. Expected module: 'ID_MODULE_OUTPUT4W'.");
                    errorDescriptionDict.Add(1307, "Hardware configuration error: Unexpected module detected in Slot 7. Expected module: 'ID_MODULE_OUTPUT4W'.");
                    errorDescriptionDict.Add(1308, "Hardware configuration error: Unexpected module detected in Slot 8. Expected module: 'ID_MODULE_OUTPUT4W'.");
                    errorDescriptionDict.Add(1309, "Hardware configuration error: Unexpected module detected in Slot 9. Expected module: 'ID_MODULE_OUTPUT2W'.");
                    errorDescriptionDict.Add(1310, "Hardware configuration error: Unexpected module detected in Slot 10. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1311, "Hardware configuration error: Unexpected module detected in Slot 11. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1312, "Hardware configuration error: Unexpected module detected in Slot 12. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1313, "Hardware configuration error: Unexpected module detected in Slot 13. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1314, "Hardware configuration error: Unexpected module detected in Slot 14. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1315, "Hardware configuration error: Unexpected module detected in Slot 15. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1316, "Hardware configuration error: Unexpected module detected in Slot 16. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1317, "Hardware configuration error: Unexpected module detected in Slot 17. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1318, "Hardware configuration error: Unexpected module detected in Slot 18. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1319, "Hardware configuration error: Unexpected module detected in Slot 19. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1320, "Hardware configuration error: Unexpected module detected in Slot 10. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1321, "Hardware configuration error: Unexpected module detected in Slot 21. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1322, "Hardware configuration error: Unexpected module detected in Slot 22. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1323, "Hardware configuration error: Unexpected module detected in Slot 23. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1324, "Hardware configuration error: Unexpected module detected in Slot 24. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1325, "Hardware configuration error: Unexpected module detected in Slot 25. Expected module: 'ID_MODULE_INPUT4W'.");
                    errorDescriptionDict.Add(1326, "Hardware configuration error: Unexpected module detected in Slot 26. Expected module: 'ID_MODULE_INPUT2W'.");

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
                    //// Stop task
                    //actionDescriptionDict.Add(100, "Stop task started.");
                    //actionDescriptionDict.Add(300, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(301, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(302, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(303, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(304, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(305, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(306, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(307, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(308, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(309, "Stop task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(101, "Stop task finished succesfully.");
                    //actionDescriptionDict.Add(102, "Stop task restored.");
                    //// Read task
                    //actionDescriptionDict.Add(110, "Reading started.");
                    //actionDescriptionDict.Add(310, "Reading running.");
                    //actionDescriptionDict.Add(311, "Reading running.");
                    //actionDescriptionDict.Add(312, "Reading running.");
                    //actionDescriptionDict.Add(313, "Reading running.");
                    //actionDescriptionDict.Add(314, "Reading running.");
                    //actionDescriptionDict.Add(315, "Reading running.");
                    //actionDescriptionDict.Add(316, "Reading running.");
                    //actionDescriptionDict.Add(317, "Reading running.");
                    //actionDescriptionDict.Add(318, "Reading running.");
                    //actionDescriptionDict.Add(319, "Reading running.");
                    //actionDescriptionDict.Add(111, "Reading finished succesfully.");
                    //actionDescriptionDict.Add(112, "Reading restored.");
                    //// Move to work task
                    //actionDescriptionDict.Add(120, "Move to work task started.");
                    //actionDescriptionDict.Add(320, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(321, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(322, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(323, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(324, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(325, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(326, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(327, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(328, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(329, "Move to work task running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(121, "Move to work task finished succesfully.");
                    //actionDescriptionDict.Add(122, "Move to work task restored.");
                    // ClearResultDataTask
                    actionDescriptionDict.Add(130, "ClearResultDataTask started.");
                    actionDescriptionDict.Add(330, "ClearResultDataTask running, reset outputs.");
                    actionDescriptionDict.Add(331, "ClearResultDataTask running, clear error flag.");
                    actionDescriptionDict.Add(332, "ClearResultDataTask running, clear read complete flag.");
                    actionDescriptionDict.Add(333, "ClearResultDataTask running, clear preset complete flagn.");
                    actionDescriptionDict.Add(334, "ClearResultDataTask running, clear register preset data complete flag.");
                    actionDescriptionDict.Add(335, "ClearResultDataTask running, clear tune complete flag.");
                    actionDescriptionDict.Add(336, "ClearResultDataTask running, clear external request complete flag.");
                    actionDescriptionDict.Add(337, "ClearResultDataTask running, waiting for general error flag is reseted.");
                    actionDescriptionDict.Add(338, "ClearResultDataTask running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(339, "ClearResultDataTask running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(131, "ClearResultDataTask finished succesfully.");
                    actionDescriptionDict.Add(132, "ClearResultDataTask restored.");
                    //// TemplateTask_10steps_2
                    //actionDescriptionDict.Add(140, "TemplateTask_10steps_2 started.");
                    //actionDescriptionDict.Add(340, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(341, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(342, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(343, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(344, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(345, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(346, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(347, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(348, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(349, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(141, "TemplateTask_10steps_2 finished succesfully.");
                    //actionDescriptionDict.Add(142, "TemplateTask_10steps_2 restored.");
                    //// TemplateTask_10steps_3
                    //actionDescriptionDict.Add(150, "TemplateTask_10steps_3 started.");
                    //actionDescriptionDict.Add(350, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(351, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(352, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(353, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(354, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(355, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(356, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(357, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(358, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(359, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(151, "TemplateTask_10steps_3 finished succesfully.");
                    //actionDescriptionDict.Add(152, "TemplateTask_10steps_3 restored.");
                    //// TemplateTask_10steps_4
                    //actionDescriptionDict.Add(160, "TemplateTask_10steps_4 started.");
                    //actionDescriptionDict.Add(360, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(361, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(362, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(363, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(364, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(365, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(366, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(367, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(368, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(369, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(161, "TemplateTask_10steps_4 finished succesfully.");
                    //actionDescriptionDict.Add(162, "TemplateTask_10steps_4 restored.");
                    //// TemplateTask_10steps_5
                    //actionDescriptionDict.Add(170, "TemplateTask_10steps_5 started.");
                    //actionDescriptionDict.Add(370, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(371, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(372, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(373, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(374, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(375, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(376, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(377, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(378, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(379, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(171, "TemplateTask_10steps_5 finished succesfully.");
                    //actionDescriptionDict.Add(172, "TemplateTask_10steps_5 restored.");
                    // ReadTask
                    actionDescriptionDict.Add(180, "ReadTask started.");
                    actionDescriptionDict.Add(380, "ReadTask running, reset outputs.");
                    actionDescriptionDict.Add(381, "ReadTask running, clear error flag.");
                    actionDescriptionDict.Add(382, "ReadTask running, clear read complete flag.");
                    actionDescriptionDict.Add(383, "ReadTask running, clear preset complete flag.");
                    actionDescriptionDict.Add(384, "ReadTask running, clear register preset data complete flag.");
                    actionDescriptionDict.Add(385, "ReadTask running, clear tune complete flag.");
                    actionDescriptionDict.Add(386, "ReadTask running, clear external request complete flag.");
                    actionDescriptionDict.Add(387, "ReadTask running, waiting for general error flag is reseted.");
                    actionDescriptionDict.Add(388, "ReadTask running, setting bank number.");
                    actionDescriptionDict.Add(389, "ReadTask running, starting trigger.");
                    actionDescriptionDict.Add(390, "ReadTask running, waiting for data.");
                    actionDescriptionDict.Add(391, "ReadTask running, acknowledging results.");
                    actionDescriptionDict.Add(392, "ReadTask running, .");
                    actionDescriptionDict.Add(393, "ReadTask running, .");
                    actionDescriptionDict.Add(394, "ReadTask running, .");
                    actionDescriptionDict.Add(395, "ReadTask running, .");
                    actionDescriptionDict.Add(396, "ReadTask running, .");
                    actionDescriptionDict.Add(397, "ReadTask running, .");
                    actionDescriptionDict.Add(398, "ReadTask running, .");
                    actionDescriptionDict.Add(399, "ReadTask running, .");
                    actionDescriptionDict.Add(181, "ReadTask finished succesfully.");
                    actionDescriptionDict.Add(182, "ReadTask restored.");
                    // TuneTask
                    actionDescriptionDict.Add(200, "TuneTask started.");
                    actionDescriptionDict.Add(400, "TuneTask running, reset outputs.");
                    actionDescriptionDict.Add(401, "TuneTask running, clear error flag.");
                    actionDescriptionDict.Add(402, "TuneTask running, clear read complete flag.");
                    actionDescriptionDict.Add(403, "TuneTask running, clear preset complete flag.");
                    actionDescriptionDict.Add(404, "TuneTask running, clear register preset data complete flag.");
                    actionDescriptionDict.Add(405, "TuneTask running, clear tune complete flag.");
                    actionDescriptionDict.Add(406, "TuneTask running, clear external request complete flag.");
                    actionDescriptionDict.Add(407, "TuneTask running, waiting for general error flag is reseted.");
                    actionDescriptionDict.Add(408, "TuneTask running, setting bank number.");
                    actionDescriptionDict.Add(409, "TuneTask running, starting tune process.");
                    actionDescriptionDict.Add(410, "TuneTask running, acknowledging tunning process.");
                    actionDescriptionDict.Add(411, "TuneTask running, .");
                    actionDescriptionDict.Add(412, "TuneTask running, .");
                    actionDescriptionDict.Add(413, "TuneTask running, .");
                    actionDescriptionDict.Add(414, "TuneTask running, .");
                    actionDescriptionDict.Add(415, "TuneTask running, .");
                    actionDescriptionDict.Add(416, "TuneTask running, .");
                    actionDescriptionDict.Add(417, "TuneTask running, .");
                    actionDescriptionDict.Add(418, "TuneTask running, .");
                    actionDescriptionDict.Add(419, "TuneTask running, .");
                    actionDescriptionDict.Add(201, "TuneTask finished succesfully.");
                    actionDescriptionDict.Add(202, "TuneTask restored.");
                    //// TemplateTask_20steps_3
                    //actionDescriptionDict.Add(220, "TemplateTask_20steps_3 started.");
                    //actionDescriptionDict.Add(420, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(421, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(422, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(423, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(424, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(425, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(426, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(427, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(428, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(429, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(430, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(431, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(432, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(433, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(434, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(435, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(436, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(437, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(438, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(439, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(221, "TemplateTask_20steps_3 finished succesfully.");
                    //actionDescriptionDict.Add(222, "TemplateTask_20steps_3 restored.");
                    //// TemplateTask_20steps_4
                    //actionDescriptionDict.Add(240, "TemplateTask_20steps_4 started.");
                    //actionDescriptionDict.Add(440, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(441, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(442, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(443, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(444, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(445, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(446, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(447, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(448, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(449, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(450, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(451, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(452, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(453, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(454, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(455, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(456, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(457, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(458, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(459, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(241, "TemplateTask_20steps_4 finished succesfully.");
                    //actionDescriptionDict.Add(242, "TemplateTask_20steps_4 restored.");
                    //// TemplateTask_20steps_5
                    //actionDescriptionDict.Add(260, "TemplateTask_20steps_5 started.");
                    //actionDescriptionDict.Add(460, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(461, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(462, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(463, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(464, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(465, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(466, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(467, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(468, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(469, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(470, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(471, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(472, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(473, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(474, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(475, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(476, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(477, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(478, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(479, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    //actionDescriptionDict.Add(261, "TemplateTask_20steps_5 finished succesfully.");
                    //actionDescriptionDict.Add(262, "TemplateTask_20steps_5 restored.");
                    //// General alarms
                    //actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    //actionDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!");
                    //actionDescriptionDict.Add(702, "Input variable `homeSensor` has NULL reference in `Run` method!");
                    //actionDescriptionDict.Add(703, "Input variable `workSensor` has NULL reference in `Run` method!");
                    //actionDescriptionDict.Add(704, "Input variable `moveHomeSignal` has NULL reference in `Run` method!");
                    //actionDescriptionDict.Add(705, "Input variable `moveWorkSignal` has NULL reference in `Run` method!");
                    //// Stop task
                    //actionDescriptionDict.Add(800, "Stop task finished with error!");
                    //actionDescriptionDict.Add(801, "Stop task was aborted, while not yet completed!");
                    //// Move to home task
                    //actionDescriptionDict.Add(810, "Move to home task finished with error!");
                    //actionDescriptionDict.Add(811, "Move to home task was aborted, while not yet completed!");
                    //// Move to work task
                    //actionDescriptionDict.Add(820, "Move to work task finished with error!");
                    //actionDescriptionDict.Add(821, "Move to work task was aborted, while not yet completed!");
                    // ClearResultDataTask
                    actionDescriptionDict.Add(830, "ClearResultDataTask finished with error!");
                    actionDescriptionDict.Add(831, "ClearResultDataTask was aborted, while not yet completed!");
                    //// TemplateTask_10steps_2
                    //actionDescriptionDict.Add(840, "TemplateTask_10steps_2 finished with error!");
                    //actionDescriptionDict.Add(841, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    //// TemplateTask_10steps_3
                    //actionDescriptionDict.Add(850, "TemplateTask_10steps_3 finished with error!");
                    //actionDescriptionDict.Add(851, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    //// TemplateTask_10steps_4
                    //actionDescriptionDict.Add(860, "TemplateTask_10steps_4 task finished with error!");
                    //actionDescriptionDict.Add(861, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    //// TemplateTask_10steps_5
                    //actionDescriptionDict.Add(870, "TemplateTask_10steps_5 task finished with error!");
                    //actionDescriptionDict.Add(871, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // ReadTask
                    actionDescriptionDict.Add(880, "ReadTask task finished with error!");
                    actionDescriptionDict.Add(881, "ReadTask task was aborted, while not yet completed!");
                    // TuneTask
                    actionDescriptionDict.Add(900, "TuneTask task finished with error!");
                    actionDescriptionDict.Add(901, "TuneTask task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_3
                    //actionDescriptionDict.Add(920, "TemplateTask_20steps_3 task finished with error!");
                    //actionDescriptionDict.Add(921, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_4
                    //actionDescriptionDict.Add(940, "TemplateTask_20steps_4 task finished with error!");
                    //actionDescriptionDict.Add(941, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_5
                    //actionDescriptionDict.Add(960, "TemplateTask_20steps_5 task finished with error!");
                    //actionDescriptionDict.Add(961, "TemplateTask_20steps_5 task was aborted, while not yet completed!");

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

