using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Abb.Robotics
{
    public partial class AxoAbbRobotics_Component_Status_v_1_x_x : AXOpen.Components.Robotics.AxoRobot_Status
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
                    errorDescriptionDict.Add(501, "Waiting for the signal Inputs.CycleOn to be reseted!");
                    errorDescriptionDict.Add(502, "Waiting for the signal Inputs.PpMoved to be set!");
                    errorDescriptionDict.Add(510,  "Waiting for the signal Inputs.AutoOn to be set!");                                                                                      
                    errorDescriptionDict.Add(511,  "Waiting for the signal Inputs.Error to be reseted!");                                                                                   
                    errorDescriptionDict.Add(512,  "Waiting for the signal Inputs.EmgStop to be reseted!");                                                                                 
                    errorDescriptionDict.Add(513,  "Waiting for the signal Inputs.MotorOnState to be set!");                                                                                
                    errorDescriptionDict.Add(514,  "Waiting for the signal Inputs.CycleOn to be set!");                                                                                     
                    errorDescriptionDict.Add(515,  "Waiting for the signal Inputs.Error to be reseted!");                                                                                   
                    errorDescriptionDict.Add(520,  "Waiting for the signal Inputs.AutoOn to be set!");                                                                                      
                    errorDescriptionDict.Add(521,  "Waiting for the signal Inputs.Error to be reseted!");                                                                                   
                    errorDescriptionDict.Add(522,  "Waiting for the signal Inputs.EmgStop to be reseted!");                                                                                 
                    errorDescriptionDict.Add(523,  "Waiting for the signal Inputs.MotorOnState to be set!");                                                                                
                    errorDescriptionDict.Add(524,  "Waiting for the signal Inputs.CycleOn to be set!");                                                                                     
                    errorDescriptionDict.Add(525,  "Waiting for the signal Inputs.Error to be reseted!");                                                                                   
                    errorDescriptionDict.Add(526,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                
                    errorDescriptionDict.Add(527,  "Waiting for the value of the `Inputs.GlobalSpeed` to be the same as the value of the `CurrentMovementParameters.GlobalSpeed `.");       
                    errorDescriptionDict.Add(528,  "Waiting for the value of the `Inputs.ToolNo` to be the same as the value of the `CurrentMovementParameters.ToolNo `.");                 
                    errorDescriptionDict.Add(529,  "Waiting for the value of the `Inputs.WorkobjectNo` to be the same as the value of the `CurrentMovementParameters.WorkobjectNo `.");     
                    errorDescriptionDict.Add(530,  "Waiting for the value of the `Inputs.PointNo` to be the same as the value of the `CurrentMovementParameters.PointNo `.");               
                    errorDescriptionDict.Add(531,  "Waiting for the value of the `Inputs.UserSpecSpeed1` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed1 `."); 
                    errorDescriptionDict.Add(532,  "Waiting for the value of the `Inputs.UserSpecSpeed2` to be the same as the value of the `CurrentMovementParameters.UserSpecSpeed2 `."); 
                    errorDescriptionDict.Add(533,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                
                    errorDescriptionDict.Add(534,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                
                    errorDescriptionDict.Add(535,  "Waiting for the value of the `Inputs.ActionNo` to be the same as the value of the `Outputs.ActionNo`.");                                
                    errorDescriptionDict.Add(540,  "Waiting for the signal Inputs.AutoOn to be set!");                                                                                      
                    errorDescriptionDict.Add(541,  "Waiting for the signal Inputs.Error to be reseted!");                                                                                   
                    errorDescriptionDict.Add(542,  "Waiting for the signal Inputs.EmgStop to be reseted!");                                                                                 
                    errorDescriptionDict.Add(543,  "Waiting for the signal Inputs.MotorOnState to be set!");                                                                                
                    errorDescriptionDict.Add(544,  "Waiting for the signal Inputs.Error to be reseted!");                                                                                   
                    errorDescriptionDict.Add(550,  "Waiting for the signal Inputs.CycleOn to be set!");                                                                                     
                    errorDescriptionDict.Add(551,  "Waiting for the signal Inputs.MotorOnState to be set!");                                                                                
                    errorDescriptionDict.Add(552,  "Waiting for the signal Inputs.Error to be reseted!");                                                                                   
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
                    errorDescriptionDict.Add(570,  "Waiting for the signal Inputs.CycleOn to be set!");                                                                                     
                    errorDescriptionDict.Add(571,  "Waiting for the signal Inputs.SystemInputBusy to be reseted!");                                                                         
                    errorDescriptionDict.Add(580,  "Waiting for the signal Inputs.MotorOffState to be set!");                                                                               
                    errorDescriptionDict.Add(581,  "Waiting for the signal Inputs.SystemInputBusy to be reseted!");                                                                         
                    errorDescriptionDict.Add(590,  "Waiting for the signal Inputs.MoveInactive to be set!");                                                                                
                    errorDescriptionDict.Add(591,  "Waiting for the signal Inputs.CycleOn to be reseted!");                                                                                 
                    errorDescriptionDict.Add(600,  "Waiting for the signal Inputs.MoveInactive to be set!");                                                                                
                    errorDescriptionDict.Add(610,  "Waiting for the signal Inputs.CycleOn to be reseted!");

                    //  General alarm
                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of _hwIdDI_64_bytes is zero.");
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module with 64 input bytes (GsdId=1).");
                    errorDescriptionDict.Add(720, "Hw configuration error. Value of _hwIdDO_64_bytes is zero.");
                    errorDescriptionDict.Add(721, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 2.");
                    errorDescriptionDict.Add(722, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 2.");
                    errorDescriptionDict.Add(723, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 2.");
                    errorDescriptionDict.Add(724, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 2.");
                    errorDescriptionDict.Add(725, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 2.");
                    errorDescriptionDict.Add(726, "Hw configuration error: Module with unexpected size or type detected in Slot 2. Expected module with 64 output bytes (GsdId=2).");
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwID_DI_64_bytes` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1133, "Input variable `Config.HWIDs.HwID_DO_64_bytes` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1201, "Error reading the hwIdDI_64_bytes!" );
                    errorDescriptionDict.Add(1231, "Error writing the _hwIdDO_64_bytes!");
                    errorDescriptionDict.Add(10000, "Start at main finished with error!");
                    errorDescriptionDict.Add(10001, "Start at main was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10010, "Start motors and program finished with error!");
                    errorDescriptionDict.Add(10011, "Start motors and program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10020, "Start motors program and movements finished with error!");
                    errorDescriptionDict.Add(10021, "Start motors program and movements was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10040, "Start motors finished with error!");
                    errorDescriptionDict.Add(10041, "Start motors was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10050, "Start movements finished with error!");
                    errorDescriptionDict.Add(10051, "Start movements was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10070, "Start program finished with error!");
                    errorDescriptionDict.Add(10071, "Start program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10080, "Stop motors finished with error!");
                    errorDescriptionDict.Add(10081, "Stop motors was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10090, "Stop movements and program finished with error!");
                    errorDescriptionDict.Add(10091, "Stop movements and program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10100, "Stop movements finished with error!");
                    errorDescriptionDict.Add(10101, "Stop movements was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10110, "Stop program finished with error!");
                    errorDescriptionDict.Add(10111, "Stop program was aborted, while not yet completed!");
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
                    actionDescriptionDict.Add(50,  "Restore has been executed.");

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

