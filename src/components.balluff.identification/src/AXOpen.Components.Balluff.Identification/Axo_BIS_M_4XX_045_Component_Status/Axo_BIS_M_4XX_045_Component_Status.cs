using AXOpen.Messaging.Static;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection.PortableExecutable;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Balluff.Identification
{
    public partial class Axo_BIS_M_4XX_045_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
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
                    errorDescriptionDict.Add(500,"Waiting for the signal Inputs.BitHeader1_CodeTagPresent to be set!");                                                                     
                    errorDescriptionDict.Add(501,"Waiting for the signal Inputs.BitHeader1_JobAccepted to be reseted!");                                                                    
                    errorDescriptionDict.Add(502,"Waiting for the signal Inputs.BitHeader1_JobEnd to be reseted!");                                                                         
                    errorDescriptionDict.Add(503,"Waiting for the signal Inputs.BitHeader1_ToggleBit to be reseted!");                                                                      
                    errorDescriptionDict.Add(504,"Waiting for the signal Inputs.BitHeader1_JobEnd to be set!");                                                                             
                    errorDescriptionDict.Add(505,"Waiting for the signal Inputs.BitHeader1_JobAccepted to be set!");                                                                        
                    errorDescriptionDict.Add(520,"Waiting for the signal Inputs.BitHeader1_CodeTagPresent to be set!");                                                                     
                    errorDescriptionDict.Add(522,"Waiting for the signal Inputs.BitHeader1_JobAccepted to be reseted!");                                                                    
                    errorDescriptionDict.Add(523,"Waiting for the signal Inputs.BitHeader1_JobEnd to be reseted!");                                                                         
                    errorDescriptionDict.Add(524,"Waiting for the signal Inputs.BitHeader1_ToggleBit to be reseted!");                                                                      
                    errorDescriptionDict.Add(526,"Waiting for the signal Inputs.BitHeader1_JobAccepted to be set!");                                                                        
                    errorDescriptionDict.Add(529,"Waiting for the signal Inputs.BitHeader1_JobEnd to be set!");                                                                             
                    errorDescriptionDict.Add(530,"Waiting for the signal Inputs.BitHeader1_JobAccepted to be reseted!");                                                                    
                    errorDescriptionDict.Add(531,"Waiting for the signal Inputs.BitHeader1_JobError to be reseted!");                                                                       
                    errorDescriptionDict.Add(551,"Waiting for the signal Inputs.BitHeader1_Power to be reseted!");                                                                          
                    errorDescriptionDict.Add(552,"Waiting for the signal Inputs.BitHeader1_Power to be set!");                                                                              
                    errorDescriptionDict.Add(560,"Waiting for the signal Inputs.BitHeader1_CodeTagPresent to be set!");                                                                     
                    errorDescriptionDict.Add(562,"Waiting for the signal Inputs.BitHeader1_JobAccepted to be set!");                                                                        
                    errorDescriptionDict.Add(567,"Waiting for the signal Inputs.BitHeader1_JobAccepted to be reseted!");
                    errorDescriptionDict.Add(568,"Waiting for the signal Inputs.BitHeader1_JobError to be reseted!");                                                                       

                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(702, "Hw configuration error. The address specified at the hardwareID parameter is invalid in ReadSlotFromHardwareID (8090).");
                    errorDescriptionDict.Add(710, "Hw configuration error. Value of Config.HWIDs.HwId_BISM is zero.");
                    errorDescriptionDict.Add(711, "Hw configuration error. Invalid value for HardwareType in GeoAddr in ReadHardwareIDFromSlot  (8091) for slot 1.");
                    errorDescriptionDict.Add(712, "Hw configuration error. Invalid value for IOSystem in GeoAddr in ReadHardwareIDFromSlot      (8094) for slot 1.");
                    errorDescriptionDict.Add(713, "Hw configuration error. Invalid value for Station in GeoAddr in ReadHardwareIDFromSlot       (8095) for slot 1.");
                    errorDescriptionDict.Add(714, "Hw configuration error. Invalid value for Slot in GeoAddr in ReadHardwareIDFromSlot          (8096) for slot 1.");
                    errorDescriptionDict.Add(715, "Hw configuration error. Invalid value for Subslot in GeoAddr in ReadHardwareIDFromSlot       (8097) for slot 1.");
                    errorDescriptionDict.Add(716, "Hw configuration error: Module with unexpected size or type detected in Slot 1. Expected module: 'ID_Mod_BIS_M_4XX_045'.");
                    errorDescriptionDict.Add(1130, "Input variable `parent` has NULL reference in `Run` method!");
                    errorDescriptionDict.Add(1131, "Input variable `Config.HWIDs.HW_Device` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1132, "Input variable `Config.HWIDs.HwId_BISM` has invalid value in `Run` method!");
                    errorDescriptionDict.Add(1201, "Error reading the data from module with HWID: Config.HWIDs.HwId_BISM!");
                    errorDescriptionDict.Add(1231, "Error writing the data to module with HWID: Config.HWIDs.HwId_BISM!");
                    errorDescriptionDict.Add(10000, "Read finished with error!");
                    errorDescriptionDict.Add(10001, "Read was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10020, "Write finished with error!");
                    errorDescriptionDict.Add(10021, "Write was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10040, "Reset communication finished with error!");
                    errorDescriptionDict.Add(10041, "Reset communication was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10050, "Reset reader finished with error!");
                    errorDescriptionDict.Add(10051, "Reset reader was aborted, while not yet completed!");
                    errorDescriptionDict.Add(10060, "Write char to memory finished with error!");
                    errorDescriptionDict.Add(10061, "Write char to memory was aborted, while not yet completed!");

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

                    actionDescriptionDict.Add(100, "Read started.");
                    actionDescriptionDict.Add(300, "Read running: waiting for the presention of the tag.");
                    actionDescriptionDict.Add(301, "Read running: waiting for the job header to be cleared.");
                    actionDescriptionDict.Add(304, "Read running: waiting for the job header to be set.");
                    actionDescriptionDict.Add(305, "Read running: waiting for the job to be accepted.");
                    actionDescriptionDict.Add(306, "Read running: processing partial segment of the data.");
                    actionDescriptionDict.Add(307, "Read running: trigger processing the following segment of the data.");
                    actionDescriptionDict.Add(308, "Read running: waiting for the data of the following data segment.");
                    actionDescriptionDict.Add(309, "Read running: processing the last segment of the data.");
                    actionDescriptionDict.Add(310, "Read finished.");
                    actionDescriptionDict.Add(101, "Read finished succesfully.");
                    actionDescriptionDict.Add(102, "Read restored.");

                    actionDescriptionDict.Add(120, "Write started.");
                    actionDescriptionDict.Add(320, "Write running: waiting for the presention of the tag.");
                    actionDescriptionDict.Add(321, "Write running: processing the data to send.");
                    actionDescriptionDict.Add(322, "Write running: waiting for the job header to be cleared.");
                    actionDescriptionDict.Add(325, "Write running: trigger sending the job header.");
                    actionDescriptionDict.Add(326, "Write running: waiting for the job to be accepted.");
                    actionDescriptionDict.Add(327, "Write running: processing partial segment of the data.");
                    actionDescriptionDict.Add(328, "Write running: trigger sending the current segment of the data.");
                    actionDescriptionDict.Add(329, "Write running: processing the last segment of the data.");
                    actionDescriptionDict.Add(330, "Write running: waiting for the job to be accepted.");
                    actionDescriptionDict.Add(332, "Write finished.");
                    actionDescriptionDict.Add(121, "Write finished succesfully.");
                    actionDescriptionDict.Add(122, "Write restored.");

                    actionDescriptionDict.Add(140, "Reset communication started.");
                    actionDescriptionDict.Add(340, "Reset communication running: restoring tasks.");
                    actionDescriptionDict.Add(341, "Reset communication running: clearing data and flags.");
                    actionDescriptionDict.Add(141, "Reset communication finished succesfully.");
                    actionDescriptionDict.Add(142, "Reset communication restored.");

                    actionDescriptionDict.Add(150, "Reset reader started.");
                    actionDescriptionDict.Add(350, "Reset reader running: clearing of the data and flags.");
                    actionDescriptionDict.Add(351, "Reset reader running: waiting for the device to be powered off.");
                    actionDescriptionDict.Add(352, "Reset reader running: waiting for the device to be powered on.");
                    actionDescriptionDict.Add(353, "Reset reader finished.");
                    actionDescriptionDict.Add(151, "Reset reader finished succesfully.");
                    actionDescriptionDict.Add(152, "Reset reader restored.");

                    actionDescriptionDict.Add(160, "Write char to memory started.");
                    actionDescriptionDict.Add(360, "Write char to memory running: waiting for the presention of the tag.");
                    actionDescriptionDict.Add(361, "Write char to memory running: processing the data to be sent.");
                    actionDescriptionDict.Add(362, "Write char to memory: waiting for the job to be accepted.");
                    actionDescriptionDict.Add(363, "Write char to memory: waiting for the job to be finished.");
                    actionDescriptionDict.Add(364, "Write char to memory finished.");
                    actionDescriptionDict.Add(366, "Write char to memory running: cleaning the header data.");
                    actionDescriptionDict.Add(367, "Write char to memory running: cleaning the header data.");
                    actionDescriptionDict.Add(368, "Write char to memory running: cleaning the header data.");
                    actionDescriptionDict.Add(369, "Write char to memory finished with an error.");
                    actionDescriptionDict.Add(161, "Write char to memory finished succesfully.");
                    actionDescriptionDict.Add(162, "Write char to memory restored.");


                    actionDescriptionDict.Add(10000, "Read finished with error!");
                    actionDescriptionDict.Add(10001, "Read was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10020, "Write finished with error!");
                    actionDescriptionDict.Add(10021, "Write was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10040, "Reset communication finished with error!");
                    actionDescriptionDict.Add(10041, "Reset communication was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10050, "Reset reader finished with error!");
                    actionDescriptionDict.Add(10051, "Reset reader was aborted, while not yet completed!");
                    actionDescriptionDict.Add(10060, "Write char to memory finished with error!");
                    actionDescriptionDict.Add(10061, "Write char to memory was aborted, while not yet completed!");

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

