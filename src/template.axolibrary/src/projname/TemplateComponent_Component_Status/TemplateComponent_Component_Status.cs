using AXOpen.Messaging.Static;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Template.Axolibrary
{

    public partial class TemplateComponent_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    // Stop task
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
                    // Move to home task
                    errorDescriptionDict.Add(510, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(511, "Waiting for the signal `Inputs.Status.WorkSensor` to be reseted!" );                        
                    errorDescriptionDict.Add(512, "Waiting for the signal `Inputs.Status.HomeSensor` to be set!" );                        
                    errorDescriptionDict.Add(513, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(514, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(515, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(516, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(517, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(518, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(519, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    // Move to work task
                    errorDescriptionDict.Add(520, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(521, "Waiting for the signal `Inputs.Status.HomeSensor` to be reseted!" );                        
                    errorDescriptionDict.Add(522, "Waiting for the signal `Inputs.Status.WorkSensor` to be set!" );                        
                    errorDescriptionDict.Add(523, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(524, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(525, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(526, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(527, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(528, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    errorDescriptionDict.Add(529, "Waiting for the signal/variable `<insert name>` to be set/reseted !");                       
                    // TemplateTask_10steps_1
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
                    // TemplateTask_10steps_2
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
                    // TemplateTask_10steps_3
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
                    // TemplateTask_10steps_4
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
                    // TemplateTask_10steps_5
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
                    // TemplateTask_20steps_1
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
                    // TemplateTask_20steps_2
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
                    // TemplateTask_20steps_3
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
                    // TemplateTask_20steps_4
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
                    // TemplateTask_20steps_5
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
                    errorDescriptionDict.Add(702, "Input variable `homeSensor` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(703, "Input variable `workSensor` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(704, "Input variable `moveHomeSignal` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(705, "Input variable `moveWorkSignal` has NULL reference in `Run` method!");
                    // Stop task
                    errorDescriptionDict.Add(800, "Stop task finished with error!");
                    errorDescriptionDict.Add(801, "Stop task was aborted, while not yet completed!");
                    // Move to home task
                    errorDescriptionDict.Add(810, "Move to home task finished with error!");
                    errorDescriptionDict.Add(811, "Move to home task was aborted, while not yet completed!");
                    // Move to work task
                    errorDescriptionDict.Add(820, "Move to work task finished with error!");
                    errorDescriptionDict.Add(821, "Move to work task was aborted, while not yet completed!");
                    // TemplateTask_10steps_1
                    errorDescriptionDict.Add(830, "TemplateTask_10steps_1 finished with error!");
                    errorDescriptionDict.Add(831, "TemplateTask_10steps_1 was aborted, while not yet completed!");
                    // TemplateTask_10steps_2
                    errorDescriptionDict.Add(840, "TemplateTask_10steps_2 finished with error!");
                    errorDescriptionDict.Add(841, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    // TemplateTask_10steps_3
                    errorDescriptionDict.Add(850, "TemplateTask_10steps_3 finished with error!");
                    errorDescriptionDict.Add(851, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    // TemplateTask_10steps_4
                    errorDescriptionDict.Add(860, "TemplateTask_10steps_4 task finished with error!");
                    errorDescriptionDict.Add(861, "TemplateTask_10steps_4 task was aborted, while not yet completed!" );
                    // TemplateTask_10steps_5
                    errorDescriptionDict.Add(870, "TemplateTask_10steps_5 task finished with error!");
                    errorDescriptionDict.Add(871, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_1
                    errorDescriptionDict.Add(880, "TemplateTask_20steps_1 task finished with error!");
                    errorDescriptionDict.Add(881, "TemplateTask_20steps_1 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_2
                    errorDescriptionDict.Add(900, "TemplateTask_20steps_2 task finished with error!");
                    errorDescriptionDict.Add(901, "TemplateTask_20steps_2 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_3
                    errorDescriptionDict.Add(920, "TemplateTask_20steps_3 task finished with error!");
                    errorDescriptionDict.Add(921, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_4
                    errorDescriptionDict.Add(940, "TemplateTask_20steps_4 task finished with error!");
                    errorDescriptionDict.Add(941, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_5
                    errorDescriptionDict.Add(960, "TemplateTask_20steps_5 task finished with error!");
                    errorDescriptionDict.Add(961, "TemplateTask_20steps_5 task was aborted, while not yet completed!");

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
                    // Stop task
                    actionDescriptionDict.Add(100, "Stop task started.");
                    actionDescriptionDict.Add(300, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(301, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(302, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(303, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(304, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(305, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(306, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(307, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(308, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(309, "Stop task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(101, "Stop task finished succesfully.");
                    actionDescriptionDict.Add(102, "Stop task restored.");
                    // Move to home task
                    actionDescriptionDict.Add(110, "Move to home task started.");
                    actionDescriptionDict.Add(310, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(311, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(312, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(313, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(314, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(315, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(316, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(317, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(318, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(319, "Move to home task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(111, "Move to home task finished succesfully.");
                    actionDescriptionDict.Add(112, "Move to home task restored.");
                    // Move to work task
                    actionDescriptionDict.Add(120, "Move to work task started.");
                    actionDescriptionDict.Add(320, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(321, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(322, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(323, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(324, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(325, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(326, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(327, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(328, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(329, "Move to work task running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(121, "Move to work task finished succesfully.");
                    actionDescriptionDict.Add(122, "Move to work task restored.");
                    // TemplateTask_10steps_1
                    actionDescriptionDict.Add(130, "TemplateTask_10steps_1 started.");
                    actionDescriptionDict.Add(330, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(331, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(332, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(333, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(334, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(335, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(336, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(337, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(338, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(339, "TemplateTask_10steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(131, "TemplateTask_10steps_1 finished succesfully.");
                    actionDescriptionDict.Add(132, "TemplateTask_10steps_1 restored.");
                    // TemplateTask_10steps_2
                    actionDescriptionDict.Add(140, "TemplateTask_10steps_2 started.");
                    actionDescriptionDict.Add(340, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(341, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(342, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(343, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(344, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(345, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(346, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(347, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(348, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(349, "TemplateTask_10steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(141, "TemplateTask_10steps_2 finished succesfully.");
                    actionDescriptionDict.Add(142, "TemplateTask_10steps_2 restored.");
                    // TemplateTask_10steps_3
                    actionDescriptionDict.Add(150, "TemplateTask_10steps_3 started.");
                    actionDescriptionDict.Add(350, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(351, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(352, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(353, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(354, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(355, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(356, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(357, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(358, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(359, "TemplateTask_10steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(151, "TemplateTask_10steps_3 finished succesfully.");
                    actionDescriptionDict.Add(152, "TemplateTask_10steps_3 restored.");
                    // TemplateTask_10steps_4
                    actionDescriptionDict.Add(160, "TemplateTask_10steps_4 started.");
                    actionDescriptionDict.Add(360, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(361, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(362, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(363, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(364, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(365, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(366, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(367, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(368, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(369, "TemplateTask_10steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(161, "TemplateTask_10steps_4 finished succesfully.");
                    actionDescriptionDict.Add(162, "TemplateTask_10steps_4 restored.");
                    // TemplateTask_10steps_5
                    actionDescriptionDict.Add(170, "TemplateTask_10steps_5 started.");
                    actionDescriptionDict.Add(370, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(371, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(372, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(373, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(374, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(375, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(376, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(377, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(378, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(379, "TemplateTask_10steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(171, "TemplateTask_10steps_5 finished succesfully.");
                    actionDescriptionDict.Add(172, "TemplateTask_10steps_5 restored.");
                    // TemplateTask_20steps_1
                    actionDescriptionDict.Add(180, "TemplateTask_20steps_1 started.");
                    actionDescriptionDict.Add(380, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(381, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(382, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(383, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(384, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(385, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(386, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(387, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(388, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(389, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(390, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(391, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(392, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(393, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(394, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(395, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(396, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(397, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(398, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(399, "TemplateTask_20steps_1 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(181, "TemplateTask_20steps_1 finished succesfully.");
                    actionDescriptionDict.Add(182, "TemplateTask_20steps_1 restored.");
                    // TemplateTask_20steps_2
                    actionDescriptionDict.Add(200, "TemplateTask_20steps_2 started.");
                    actionDescriptionDict.Add(400, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(401, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(402, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(403, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(404, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(405, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(406, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(407, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(408, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(409, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(410, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(411, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(412, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(413, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(414, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(415, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(416, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(417, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(418, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(419, "TemplateTask_20steps_2 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(201, "TemplateTask_20steps_2 finished succesfully.");
                    actionDescriptionDict.Add(202, "TemplateTask_20steps_2 restored.");
                    // TemplateTask_20steps_3
                    actionDescriptionDict.Add(220, "TemplateTask_20steps_3 started.");
                    actionDescriptionDict.Add(420, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(421, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(422, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(423, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(424, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(425, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(426, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(427, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(428, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(429, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(430, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(431, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(432, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(433, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(434, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(435, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(436, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(437, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(438, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(439, "TemplateTask_20steps_3 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(221, "TemplateTask_20steps_3 finished succesfully.");
                    actionDescriptionDict.Add(222, "TemplateTask_20steps_3 restored.");
                    // TemplateTask_20steps_4
                    actionDescriptionDict.Add(240, "TemplateTask_20steps_4 started.");
                    actionDescriptionDict.Add(440, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(441, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(442, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(443, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(444, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(445, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(446, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(447, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(448, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(449, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(450, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(451, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(452, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(453, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(454, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(455, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(456, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(457, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(458, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(459, "TemplateTask_20steps_4 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(241, "TemplateTask_20steps_4 finished succesfully.");
                    actionDescriptionDict.Add(242, "TemplateTask_20steps_4 restored.");
                    // TemplateTask_20steps_5
                    actionDescriptionDict.Add(260, "TemplateTask_20steps_5 started.");
                    actionDescriptionDict.Add(460, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(461, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(462, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(463, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(464, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(465, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(466, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(467, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(468, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(469, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(470, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(471, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(472, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(473, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(474, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(475, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(476, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(477, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(478, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(479, "TemplateTask_20steps_5 running, add the detailed description of the current action.");
                    actionDescriptionDict.Add(261, "TemplateTask_20steps_5 finished succesfully.");
                    actionDescriptionDict.Add(262, "TemplateTask_20steps_5 restored.");
                    // General alarms
                    actionDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(701, "Input variable `hwId` has invalid value in `Run` method!");
                    actionDescriptionDict.Add(702, "Input variable `homeSensor` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(703, "Input variable `workSensor` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(704, "Input variable `moveHomeSignal` has NULL reference in `Run` method!");
                    actionDescriptionDict.Add(705, "Input variable `moveWorkSignal` has NULL reference in `Run` method!");
                    // Stop task
                    actionDescriptionDict.Add(800, "Stop task finished with error!");
                    actionDescriptionDict.Add(801, "Stop task was aborted, while not yet completed!");
                    // Move to home task
                    actionDescriptionDict.Add(810, "Move to home task finished with error!");
                    actionDescriptionDict.Add(811, "Move to home task was aborted, while not yet completed!");
                    // Move to work task
                    actionDescriptionDict.Add(820, "Move to work task finished with error!");
                    actionDescriptionDict.Add(821, "Move to work task was aborted, while not yet completed!");
                    // TemplateTask_10steps_1
                    actionDescriptionDict.Add(830, "TemplateTask_10steps_1 finished with error!");
                    actionDescriptionDict.Add(831, "TemplateTask_10steps_1 was aborted, while not yet completed!");
                    // TemplateTask_10steps_2
                    actionDescriptionDict.Add(840, "TemplateTask_10steps_2 finished with error!");
                    actionDescriptionDict.Add(841, "TemplateTask_10steps_2 was aborted, while not yet completed!");
                    // TemplateTask_10steps_3
                    actionDescriptionDict.Add(850, "TemplateTask_10steps_3 finished with error!");
                    actionDescriptionDict.Add(851, "TemplateTask_10steps_3 was aborted, while not yet completed!");
                    // TemplateTask_10steps_4
                    actionDescriptionDict.Add(860, "TemplateTask_10steps_4 task finished with error!");
                    actionDescriptionDict.Add(861, "TemplateTask_10steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_10steps_5
                    actionDescriptionDict.Add(870, "TemplateTask_10steps_5 task finished with error!");
                    actionDescriptionDict.Add(871, "TemplateTask_10steps_5 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_1
                    actionDescriptionDict.Add(880, "TemplateTask_20steps_1 task finished with error!");
                    actionDescriptionDict.Add(881, "TemplateTask_20steps_1 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_2
                    actionDescriptionDict.Add(900, "TemplateTask_20steps_2 task finished with error!");
                    actionDescriptionDict.Add(901, "TemplateTask_20steps_2 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_3
                    actionDescriptionDict.Add(920, "TemplateTask_20steps_3 task finished with error!");
                    actionDescriptionDict.Add(921, "TemplateTask_20steps_3 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_4
                    actionDescriptionDict.Add(940, "TemplateTask_20steps_4 task finished with error!");
                    actionDescriptionDict.Add(941, "TemplateTask_20steps_4 task was aborted, while not yet completed!");
                    // TemplateTask_20steps_5
                    actionDescriptionDict.Add(960, "TemplateTask_20steps_5 task finished with error!");
                    actionDescriptionDict.Add(961, "TemplateTask_20steps_5 task was aborted, while not yet completed!");



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

