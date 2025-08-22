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
                //  General alarms
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!"                                                                                                   );
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDS.HwID_Device` has invalid value in `Run` method!"                                                                                                      );
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090)."                                        );

                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDS.HwID_HandshakeAndGeneralErrorStatus is zero."                                                                                  );
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1."                                               );
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1."                                               );
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1."                                               );
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1."                                               );
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1."                                               );
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'HandshakeAndGeneralErrorStatus' (GsdId=101)."                );

                    errorDescriptionDict.Add(720, "Hw configuration error. Value of Config.HWIDS.HwID_BUSY_Status is zero."                                                                                                     );
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2."                                               );
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2."                                               );
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2."                                               );
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2."                                               );
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2."                                               );
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module: 'BUSY_Status' (GsdId=102)."                                   );

                    errorDescriptionDict.Add(730, "Hw configuration error. Value of Config.HWIDS.HwID_CompletionStatus is zero."                                                                                                );
                    errorDescriptionDict.Add(731, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 3."                                               );
                    errorDescriptionDict.Add(732, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 3."                                               );
                    errorDescriptionDict.Add(733, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 3."                                               );
                    errorDescriptionDict.Add(734, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 3."                                               );
                    errorDescriptionDict.Add(735, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 3."                                               );
                    errorDescriptionDict.Add(736, "Hw configuration error: Module with unexpected size or type detected in Slot 3. Expected module: 'CompletionStatus '(GsdId=103)."                              );

                    errorDescriptionDict.Add(740, "Hw configuration error. Value of Config.HWIDS.HwID_ErrorStatus is zero."                                                                                                     );
                    errorDescriptionDict.Add(741, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 4."                                               );
                    errorDescriptionDict.Add(742, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 4."                                               );
                    errorDescriptionDict.Add(743, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 4."                                               );
                    errorDescriptionDict.Add(744, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 4."                                               );
                    errorDescriptionDict.Add(745, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 4."                                               );
                    errorDescriptionDict.Add(746, "Hw configuration error: Module with unexpected size or type detected in Slot 4. Expected module: 'ErrorStatus' (GsdId=104).");

                    errorDescriptionDict.Add(750, "Hw configuration error. Value of Config.HWIDS.HwID_TerminalStatus is zero."                                                                                                  );
                    errorDescriptionDict.Add(751, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 5."                                               );
                    errorDescriptionDict.Add(752, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 5."                                               );
                    errorDescriptionDict.Add(753, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 5."                                               );
                    errorDescriptionDict.Add(754, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 5."                                               );
                    errorDescriptionDict.Add(755, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 5."                                               );
                    errorDescriptionDict.Add(756, "Hw configuration error: Module with unexpected size or type detected in Slot 5. Expected module: 'TerminalStatus' (GsdId=105)."                                );

                    errorDescriptionDict.Add(760, "Hw configuration error. Value of Config.HWIDS.HwID_UnstableReadStatus is zero."                                                                                              );
                    errorDescriptionDict.Add(761, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 6."                                               );
                    errorDescriptionDict.Add(762, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 6."                                               );
                    errorDescriptionDict.Add(763, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 6."                                               );
                    errorDescriptionDict.Add(764, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 6."                                               );
                    errorDescriptionDict.Add(765, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 6."                                               );
                    errorDescriptionDict.Add(766, "Hw configuration error: Module with unexpected size or type detected in Slot 6. Expected module: 'UnstableReadStatus' (GsdId=106)."                            );

                    errorDescriptionDict.Add(770, "Hw configuration error. Value of Config.HWIDS.HwID_MatchingLevelAndTotalEvaluationGradeStatus is zero."                                                                      );
                    errorDescriptionDict.Add(771, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 7."                                               );
                    errorDescriptionDict.Add(772, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 7."                                               );
                    errorDescriptionDict.Add(773, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 7."                                               );       
                    errorDescriptionDict.Add(774, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 7."                                               );
                    errorDescriptionDict.Add(775, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 7."                                               );
                    errorDescriptionDict.Add(776, "Hw configuration error: Module with unexpected size or type detected in Slot 7. Expected module: 'MatchingLevelAndTotalEvaluationGradeStatus' (GsdId=107)."    );

                    errorDescriptionDict.Add(780, "Hw configuration error. Value of Config.HWIDS.HwID_OperationalResultStatus is zero."                                                                                         );
                    errorDescriptionDict.Add(781, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 8."                                               );
                    errorDescriptionDict.Add(782, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 8."                                               );
                    errorDescriptionDict.Add(783, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 8."                                               );
                    errorDescriptionDict.Add(784, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 8."                                               );
                    errorDescriptionDict.Add(785, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 8."                                               );
                    errorDescriptionDict.Add(786, "Hw configuration error: Module with unexpected size or type detected in Slot 8. Expected module: 'OperationalResultStatus' (GsdId=108)."                       );
                    errorDescriptionDict.Add(790, "Hw configuration error. Value of Config.HWIDS.HwID_ReadData is zero."                                                                                                        );
                    errorDescriptionDict.Add(791, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 9."                                               );
                    errorDescriptionDict.Add(792, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 9."                                               );
                    errorDescriptionDict.Add(793, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 9."                                               );
                    errorDescriptionDict.Add(794, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 9."                                               );
                    errorDescriptionDict.Add(795, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 9."                                               );
                    errorDescriptionDict.Add(796, "Hw configuration error: Module with unexpected size or type detected in Slot 9. Expected module: 'Result_Data-32_bytes,Result_Data-64_bytes,Result_Data-128_bytes,Result_Data-246_bytes' (GsdId=109,110,111,112)." );

                    errorDescriptionDict.Add(800, "Hw configuration error. Value of Config.HWIDS.HwID_LatchAndErrorClearControlBitReg is zero."                                                                                 );
                    errorDescriptionDict.Add(801, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 10."                                              );
                    errorDescriptionDict.Add(802, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 10."                                              );
                    errorDescriptionDict.Add(803, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 10."                                              );
                    errorDescriptionDict.Add(804, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 10."                                              );
                    errorDescriptionDict.Add(805, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 10."                                              );
                    errorDescriptionDict.Add(806, "Hw configuration error: Module with unexpected size or type detected in Slot 10. Expected module: 'LatchAndErrorClearControlBitReg' (GsdId=201)."              );

                    errorDescriptionDict.Add(810, "Hw configuration error. Value of Config.HWIDS.HwID_OperationInstructionControl is zero."                                                                                     );
                    errorDescriptionDict.Add(811, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 11."                                              );
                    errorDescriptionDict.Add(812, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 11."                                              );
                    errorDescriptionDict.Add(813, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 11."                                              );
                    errorDescriptionDict.Add(814, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 11."                                              );
                    errorDescriptionDict.Add(815, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 11."                                              );
                    errorDescriptionDict.Add(816, "Hw configuration error: Module with unexpected size or type detected in Slot 11. Expected module: 'OperationInstructionControl' (GsdId=202)."                  );

                    errorDescriptionDict.Add(820, "Hw configuration error. Value of Config.HWIDS.HwID_CompletionClearControl is zero."                                                                                          );
                    errorDescriptionDict.Add(821, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 12."                                              );
                    errorDescriptionDict.Add(822, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 12."                                              );
                    errorDescriptionDict.Add(823, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 12."                                              );
                    errorDescriptionDict.Add(824, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 12."                                              );
                    errorDescriptionDict.Add(825, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 12."                                              );
                    errorDescriptionDict.Add(826, "Hw configuration error: Module with unexpected size or type detected in Slot 12. Expected module: 'CompletionClearControl' (GsdId=203)."                       );

                    errorDescriptionDict.Add(830, "Hw configuration error. Value of Config.HWIDS.HwID_ParameterBankNumber is zero."                                                                                             );
                    errorDescriptionDict.Add(831, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 13."                                              );
                    errorDescriptionDict.Add(832, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 13."                                              );
                    errorDescriptionDict.Add(833, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 13."                                              );
                    errorDescriptionDict.Add(834, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 13."                                              );
                    errorDescriptionDict.Add(835, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 13."                                              );
                    errorDescriptionDict.Add(836, "Hw configuration error: Module with unexpected size or type detected in Slot 13. Expected module: 'ParameterBankNumber' (GsdId=204)."                          );

                    errorDescriptionDict.Add(840, "Hw configuration error. Value of Config.HWIDS.HwID_UserData is zero."                                                                                                        );
                    errorDescriptionDict.Add(841, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 14."                                              );
                    errorDescriptionDict.Add(842, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 14."                                              );
                    errorDescriptionDict.Add(843, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 14."                                              );
                    errorDescriptionDict.Add(844, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 14."                                              );
                    errorDescriptionDict.Add(845, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 14."                                              );
                    errorDescriptionDict.Add(846, "Hw configuration error: Module with unexpected size or type detected in Slot 14. Allowed modules: 'User_Data-32_bytes,User_Data-64_bytes,User_Data-128_bytes,User_Data-250_bytes' (GsdId=205,206,207,208)."  );

                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!"                                                                                                 );
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDS.HwID_` has invalid value in `Run` method!"                                                                                                    );
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDS.HwID_HandshakeAndGeneralErrorStatus` has invalid value in `Run` method!"                                                                      );
                    errorDescriptionDict.Add(1133, "Input variable `Config.HWIDS.HwID_BUSY_Status` has invalid value in `Run` method!"                                                                                         );
                    errorDescriptionDict.Add(1134, "Input variable `Config.HWIDS.HwID_CompletionStatus` has invalid value in `Run` method!"                                                                                    );
                    errorDescriptionDict.Add(1135, "Input variable `Config.HWIDS.HwID_ErrorStatus` has invalid value in `Run` method!"                                                                                         );
                    errorDescriptionDict.Add(1136, "Input variable `Config.HWIDS.HwID_TerminalStatus` has invalid value in `Run` method!"                                                                                      );
                    errorDescriptionDict.Add(1137, "Input variable `Config.HWIDS.HwID_UnstableReadStatus` has invalid value in `Run` method!"                                                                                  );
                    errorDescriptionDict.Add(1138, "Input variable `Config.HWIDS.HwID_MatchingLevelAndTotalEvaluationGradeStatus` has invalid value in `Run` method!"                                                          );
                    errorDescriptionDict.Add(1139, "Input variable `Config.HWIDS.HwID_OperationalResultStatus` has invalid value in `Run` method!"                                                                             );
                    errorDescriptionDict.Add(1140, "Input variable `Config.HWIDS.HwID_ReadData` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1141, "Input variable `Config.HWIDS.HwID_LatchAndErrorClearControl` has invalid value in `Run` method!"                                                                           );
                    errorDescriptionDict.Add(1142, "Input variable `Config.HWIDS.HwID_OperationInstructionControl` has invalid value in `Run` method!"                                                                         );
                    errorDescriptionDict.Add(1143, "Input variable `Config.HWIDS.HwID_CompletionClearControl` has invalid value in `Run` method!"                                                                              );
                    errorDescriptionDict.Add(1144, "Input variable `Config.HWIDS.HwID_ParameterBankNumber` has invalid value in `Run` method!"                                                                                 );
                    errorDescriptionDict.Add(1145, "Input variable `Config.HWIDS.HwID_UserData` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1146, "Input variable `Config.HWIDS.HwID_in_15` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1147, "Input variable `Config.HWIDS.HwID_in_16` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1148, "Input variable `Config.HWIDS.HwID_in_17` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1149, "Input variable `Config.HWIDS.HwID_in_18` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1150, "Input variable `Config.HWIDS.HwID_in_19` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1151, "Input variable `Config.HWIDS.HwID_in_20` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1152, "Input variable `Config.HWIDS.HwID_out_1` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1153, "Input variable `Config.HWIDS.HwID_out_2` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1154, "Input variable `Config.HWIDS.HwID_out_3` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1155, "Input variable `Config.HWIDS.HwID_out_4` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1156, "Input variable `Config.HWIDS.HwID_out_5` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1157, "Input variable `Config.HWIDS.HwID_out_6` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1158, "Input variable `Config.HWIDS.HwID_out_7` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1159, "Input variable `Config.HWIDS.HwID_out_8` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1160, "Input variable `Config.HWIDS.HwID_out_9` has invalid value in `Run` method!"                                                                                            );
                    errorDescriptionDict.Add(1161, "Input variable `Config.HWIDS.HwID_out_10` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1162, "Input variable `Config.HWIDS.HwID_out_11` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1163, "Input variable `Config.HWIDS.HwID_out_12` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1164, "Input variable `Config.HWIDS.HwID_out_13` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1165, "Input variable `Config.HWIDS.HwID_out_14` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1166, "Input variable `Config.HWIDS.HwID_out_15` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1167, "Input variable `Config.HWIDS.HwID_out_16` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1168, "Input variable `Config.HWIDS.HwID_out_17` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1169, "Input variable `Config.HWIDS.HwID_out_18` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1170, "Input variable `Config.HWIDS.HwID_out_19` has invalid value in `Run` method!"                                                                                           );
                    errorDescriptionDict.Add(1171, "Input variable `Config.HWIDS.HwID_out_20` has invalid value in `Run` method!"                                                                                           );

                    errorDescriptionDict.Add(1201, "Error reading the HandshakeAndGeneralErrorStatus!"                                                                                                           );
                    errorDescriptionDict.Add(1202, "Error reading the BUSY_Status!"                                                                                                                              );
                    errorDescriptionDict.Add(1203, "Error reading the CompletionStatus!"                                                                                                                         );
                    errorDescriptionDict.Add(1204, "Error reading the ErrorStatus!"                                                                                                                              );
                    errorDescriptionDict.Add(1205, "Error reading the TerminalStatus!"                                                                                                                           );
                    errorDescriptionDict.Add(1206, "Error reading the UnstableReadStatus!"                                                                                                                       );
                    errorDescriptionDict.Add(1207, "Error reading the MatchingLevelAndTotalEvaluationGradeStatus!"                                                                                               );
                    errorDescriptionDict.Add(1208, "Error reading the OperationalResultStatus!"                                                                                                                  );
                    errorDescriptionDict.Add(1209, "Error reading the ReadData!"                                                                                                                                 );
                    errorDescriptionDict.Add(1210, "ResultData has invalid size!"                                                                                                                                );
                    errorDescriptionDict.Add(1211, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_11!"                                                                                             );
                    errorDescriptionDict.Add(1212, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_12!"                                                                                             );
                    errorDescriptionDict.Add(1213, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_13!"                                                                                             );
                    errorDescriptionDict.Add(1214, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_14!"                                                                                             );
                    errorDescriptionDict.Add(1215, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_15!"                                                                                             );
                    errorDescriptionDict.Add(1216, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_16!"                                                                                             );
                    errorDescriptionDict.Add(1217, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_17!"                                                                                             );
                    errorDescriptionDict.Add(1218, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_18!"                                                                                             );
                    errorDescriptionDict.Add(1219, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwID_in_19!"                                                                                             );
                    errorDescriptionDict.Add(1220, "Error reading the Axo_IV3InputStructure_Config.HWIDS.HwI__in_20!"                                                                                             );

                    errorDescriptionDict.Add(1231, "Error writing the LatchAndErrorClearControl!"                                                                                                                );
                    errorDescriptionDict.Add(1232, "Error writing the OperationInstructionControl!"                                                                                                              );
                    errorDescriptionDict.Add(1233, "Error writing the CompletionClearControl!"                                                                                                                   );
                    errorDescriptionDict.Add(1234, "Error writing the ParameterBankNumber!"                                                                                                                      );
                    errorDescriptionDict.Add(1235, "UserData has invalid size!"                                                                                                                                  );
                    errorDescriptionDict.Add(1236, "Error writing the 32bytes of the UserData!"                                                                                                                  );
                    errorDescriptionDict.Add(1237, "Error writing the 64bytes of the UserData!"                                                                                                                  );
                    errorDescriptionDict.Add(1238, "Error writing the 128bytes of the UserData!"                                                                                                                 );
                    errorDescriptionDict.Add(1239, "Error writing the 250bytes of the UserData!"                                                                                                                 );
                    errorDescriptionDict.Add(1240, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_10!"                                                                                           );
                    errorDescriptionDict.Add(1241, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_11!"                                                                                           );
                    errorDescriptionDict.Add(1242, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_12!"                                                                                           );
                    errorDescriptionDict.Add(1243, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_13!"                                                                                           );
                    errorDescriptionDict.Add(1244, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_14!"                                                                                           );
                    errorDescriptionDict.Add(1245, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_15!"                                                                                           );
                    errorDescriptionDict.Add(1246, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_16!"                                                                                           );
                    errorDescriptionDict.Add(1247, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_17!"                                                                                           );
                    errorDescriptionDict.Add(1248, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_18!"                                                                                           );
                    errorDescriptionDict.Add(1249, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_19!"                                                                                           );
                    errorDescriptionDict.Add(1250, "Error writing the Axo_IV3OutputStructure_Config.HWIDS.HwID_out_20!"                                                                                           );

                //// Clear task);
                //errorDescriptionDict.Add(10000, "Clearing of the result data finished with error!"                                                                                                          );
                //errorDescriptionDict.Add(10001, "Clearing of the result data was aborted, while not yet completed!"                                                                                         );
                //// Read Task);
                //errorDescriptionDict.Add(10010, "Reading finished with error!"                                                                                                                              );
                //errorDescriptionDict.Add(10011, "Reading was aborted, while not yet completed!"                                                                                                             );
                //// Continous reading);
                //errorDescriptionDict.Add(10020, "Continous reading finished with error!"                                                                                                                    );
                //errorDescriptionDict.Add(10021, "Continous reading was aborted, while not yet completed!"                                                                                                   );
                // ClearResultDataTask);
                    errorDescriptionDict.Add(10030, "ClearResultDataTask finished with error!"                                                                                                                    );
                    errorDescriptionDict.Add(10031, "ClearResultDataTask was aborted, while not yet completed!"                                                                                                   );
                //// TemplateTask_10steps_2);
                //errorDescriptionDict.Add(10040, "TemplateTask_10steps_2 finished with error!"                                                                                                               );
                //errorDescriptionDict.Add(10041, "TemplateTask_10steps_2 was aborted, while not yet completed!"                                                                                              );
                //// TemplateTask_10steps_3);
                //errorDescriptionDict.Add(10050, "TemplateTask_10steps_3 finished with error!"                                                                                                               );
                //errorDescriptionDict.Add(10051, "TemplateTask_10steps_3 was aborted, while not yet completed!"                                                                                              );
                //// TemplateTask_10steps_4);
                //errorDescriptionDict.Add(10060, "TemplateTask_10steps_4 task finished with error!"                                                                                                          );
                //errorDescriptionDict.Add(10061, "TemplateTask_10steps_4 task was aborted, while not yet completed!"                                                                                         );
                //// TemplateTask_10steps_5);
                //errorDescriptionDict.Add(10070, "TemplateTask_10steps_5 task finished with error!"                                                                                                          );
                //errorDescriptionDict.Add(10071, "TemplateTask_10steps_5 task was aborted, while not yet completed!"                                                                                         );
                // ReadTask);
                    errorDescriptionDict.Add(10080, "ReadTask finished with error!"                                                                                                                               );
                    errorDescriptionDict.Add(10081, "ReadTask was aborted, while not yet completed!"                                                                                                              );
                // TuneTask);
                    errorDescriptionDict.Add(10100, "TuneTask task finished with error!"                                                                                                                          );
                    errorDescriptionDict.Add(10101, "TuneTask task was aborted, while not yet completed!"                                                                                                         );
                //// TemplateTask_20steps_3);
                //errorDescriptionDict.Add(10120, "TemplateTask_20steps_3 task finished with error!"                                                                                                          );
                //errorDescriptionDict.Add(10121, "TemplateTask_20steps_3 task was aborted, while not yet completed!"                                                                                         );
                //// TemplateTask_20steps_4);
                //errorDescriptionDict.Add(10140, "TemplateTask_20steps_4 task finished with error!"                                                                                                          );
                //errorDescriptionDict.Add(10141, "TemplateTask_20steps_4 task was aborted, while not yet completed!"                                                                                         );
                //// TemplateTask_20steps_5);
                //errorDescriptionDict.Add(10160, "TemplateTask_20steps_5 task finished with error!"                                                                                                          );
                //errorDescriptionDict.Add(10161, "TemplateTask_20steps_5 task was aborted, while not yet completed!"                                                                                         );

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
                    //// Stop task
                    //actionDescriptionDict.Add(10000, "Stop task finished with error!");
                    //actionDescriptionDict.Add(10001, "Stop task was aborted, while not yet completed!");
                    //// Move to home task
                    //actionDescriptionDict.Add(10010, "Move to home task finished with error!");
                    //actionDescriptionDict.Add(10011, "Move to home task was aborted, while not yet completed!");
                    //// Move to work task
                    //actionDescriptionDict.Add(10020, "Move to work task finished with error!");
                    //actionDescriptionDict.Add(10021, "Move to work task was aborted, while not yet completed!");
                    // ClearResultDataTask
                    actionDescriptionDict.Add(10030, "ClearResultDataTask finished with error!");
                    actionDescriptionDict.Add(10031, "ClearResultDataTask was aborted, while not yet completed!");
                    //// TemplateTask_10steps_2
                    //actionDescriptionDict.Add(10040, "TemplateTask_10steps_2 finished with error!");
                    //actionDescriptionDict.Add(10041, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    //// TemplateTask_10steps_3
                    //actionDescriptionDict.Add(10050, "TemplateTask_10steps_3 finished with error!");
                    //actionDescriptionDict.Add(10051, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    //// TemplateTask_10steps_4
                    //actionDescriptionDict.Add(10060, "TemplateTask_10steps_4 task finished with error!");
                    //actionDescriptionDict.Add(10061, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    //// TemplateTask_10steps_5
                    //actionDescriptionDict.Add(10070, "TemplateTask_10steps_5 task finished with error!");
                    //actionDescriptionDict.Add(10071, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // ReadTask
                    actionDescriptionDict.Add(10080, "ReadTask task finished with error!");
                    actionDescriptionDict.Add(10081, "ReadTask task was aborted, while not yet completed!");
                    // TuneTask
                    actionDescriptionDict.Add(10100, "TuneTask task finished with error!");
                    actionDescriptionDict.Add(10101, "TuneTask task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_3
                    //actionDescriptionDict.Add(10120, "TemplateTask_20steps_3 task finished with error!");
                    //actionDescriptionDict.Add(10121, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_4
                    //actionDescriptionDict.Add(10140, "TemplateTask_20steps_4 task finished with error!");
                    //actionDescriptionDict.Add(10141, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    //// TemplateTask_20steps_5
                    //actionDescriptionDict.Add(10160, "TemplateTask_20steps_5 task finished with error!");
                    //actionDescriptionDict.Add(10161, "TemplateTask_20steps_5 task was aborted, while not yet completed!");

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

