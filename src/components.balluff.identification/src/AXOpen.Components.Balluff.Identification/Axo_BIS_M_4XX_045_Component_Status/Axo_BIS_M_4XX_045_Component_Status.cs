using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Balluff.Identification
{
    public partial class Axo_BIS_M_4XX_045_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
    {
        Dictionary<uint, string> errorDescriptionDict = new Dictionary<uint, string>();
        Dictionary<uint, string> actionDescriptionDict = new Dictionary<uint, string>();

        public string ErrorDescription
        {
            get
            {
                if (errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<uint, string>(); }
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
                    errorDescriptionDict.Add(701, "Input variable `hwId_BISM` has invalid value in `Run` method!");                              

                    errorDescriptionDict.Add(703, "Error reading the hwId_BISM in the UpdateInputs method!");                                    
                    errorDescriptionDict.Add(704, "Error writing the hwId_BISM in the UpdateOutputs method!");                                   

                    errorDescriptionDict.Add(800, "Read finished with error!");                                                                  
                    errorDescriptionDict.Add(801, "Read was aborted, while not yet completed!");                                                 
                    errorDescriptionDict.Add(820, "Write finished with error!");                                                                 
                    errorDescriptionDict.Add(821, "Write was aborted, while not yet completed!");                                                
                    errorDescriptionDict.Add(840, "Reset communication finished with error!");                                                   
                    errorDescriptionDict.Add(841, "Reset communication was aborted, while not yet completed!");                                  
                    errorDescriptionDict.Add(850, "Reset reader finished with error!");                                                          
                    errorDescriptionDict.Add(851, "Reset reader was aborted, while not yet completed!");                                         
                    errorDescriptionDict.Add(860, "Write char to memory finished with error!");
                    errorDescriptionDict.Add(861, "Write char to memory was aborted, while not yet completed!");                                 


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
                if (actionDescriptionDict == null) { actionDescriptionDict = new Dictionary<uint, string>(); }
                if (actionDescriptionDict.Count == 0)
                {
                    actionDescriptionDict.Add(0, "   ");
                    actionDescriptionDict.Add(50, "Restore has been executed.");

                    actionDescriptionDict.Add(100, "Read started.");
                    actionDescriptionDict.Add(300, "Read running.");
                    actionDescriptionDict.Add(301, "Read running.");
                    actionDescriptionDict.Add(302, "Read running.");
                    actionDescriptionDict.Add(303, "Read running.");
                    actionDescriptionDict.Add(304, "Read running.");
                    actionDescriptionDict.Add(305, "Read running.");
                    actionDescriptionDict.Add(306, "Read running.");
                    actionDescriptionDict.Add(307, "Read running.");
                    actionDescriptionDict.Add(308, "Read running.");
                    actionDescriptionDict.Add(309, "Read running.");
                    actionDescriptionDict.Add(310, "Read running.");
                    actionDescriptionDict.Add(311, "Read running.");
                    actionDescriptionDict.Add(312, "Read running.");
                    actionDescriptionDict.Add(313, "Read running.");
                    actionDescriptionDict.Add(314, "Read running.");
                    actionDescriptionDict.Add(315, "Read running.");
                    actionDescriptionDict.Add(316, "Read running.");
                    actionDescriptionDict.Add(317, "Read running.");
                    actionDescriptionDict.Add(318, "Read running.");
                    actionDescriptionDict.Add(319, "Read running.");
                    actionDescriptionDict.Add(101, "Read finished succesfully.");
                    actionDescriptionDict.Add(102, "Read restored.");

                    actionDescriptionDict.Add(120, "Write started.");
                    actionDescriptionDict.Add(320, "Write running.");
                    actionDescriptionDict.Add(321, "Write running.");
                    actionDescriptionDict.Add(322, "Write running.");
                    actionDescriptionDict.Add(323, "Write running.");
                    actionDescriptionDict.Add(324, "Write running.");
                    actionDescriptionDict.Add(325, "Write running.");
                    actionDescriptionDict.Add(326, "Write running.");
                    actionDescriptionDict.Add(327, "Write running.");
                    actionDescriptionDict.Add(328, "Write running.");
                    actionDescriptionDict.Add(329, "Write running.");
                    actionDescriptionDict.Add(330, "Write running.");
                    actionDescriptionDict.Add(331, "Write running.");
                    actionDescriptionDict.Add(332, "Write running.");
                    actionDescriptionDict.Add(333, "Write running.");
                    actionDescriptionDict.Add(334, "Write running.");
                    actionDescriptionDict.Add(335, "Write running.");
                    actionDescriptionDict.Add(336, "Write running.");
                    actionDescriptionDict.Add(337, "Write running.");
                    actionDescriptionDict.Add(338, "Write running.");
                    actionDescriptionDict.Add(339, "Write running.");
                    actionDescriptionDict.Add(121, "Write finished succesfully.");
                    actionDescriptionDict.Add(122, "Write restored.");

                    actionDescriptionDict.Add(140, "Reset communication started.");
                    actionDescriptionDict.Add(340, "Reset communication running.");
                    actionDescriptionDict.Add(341, "Reset communication running.");
                    actionDescriptionDict.Add(342, "Reset communication running.");
                    actionDescriptionDict.Add(343, "Reset communication running.");
                    actionDescriptionDict.Add(344, "Reset communication running.");
                    actionDescriptionDict.Add(345, "Reset communication running.");
                    actionDescriptionDict.Add(346, "Reset communication running.");
                    actionDescriptionDict.Add(347, "Reset communication running.");
                    actionDescriptionDict.Add(348, "Reset communication running.");
                    actionDescriptionDict.Add(349, "Reset communication running.");
                    actionDescriptionDict.Add(141, "Reset communication finished succesfully.");
                    actionDescriptionDict.Add(142, "Reset communication restored.");

                    actionDescriptionDict.Add(150, "Reset reader started.");
                    actionDescriptionDict.Add(350, "Reset reader running.");
                    actionDescriptionDict.Add(351, "Reset reader running.");
                    actionDescriptionDict.Add(352, "Reset reader running.");
                    actionDescriptionDict.Add(353, "Reset reader running.");
                    actionDescriptionDict.Add(354, "Reset reader running.");
                    actionDescriptionDict.Add(355, "Reset reader running.");
                    actionDescriptionDict.Add(356, "Reset reader running.");
                    actionDescriptionDict.Add(357, "Reset reader running.");
                    actionDescriptionDict.Add(358, "Reset reader running.");
                    actionDescriptionDict.Add(359, "Reset reader running.");
                    actionDescriptionDict.Add(151, "Reset reader finished succesfully.");
                    actionDescriptionDict.Add(152, "Reset reader restored.");

                    actionDescriptionDict.Add(160, "Write char to memory started.");
                    actionDescriptionDict.Add(360, "Write char to memory running.");
                    actionDescriptionDict.Add(361, "Write char to memory running.");
                    actionDescriptionDict.Add(362, "Write char to memory running.");
                    actionDescriptionDict.Add(363, "Write char to memory running.");
                    actionDescriptionDict.Add(364, "Write char to memory running.");
                    actionDescriptionDict.Add(365, "Write char to memory running.");
                    actionDescriptionDict.Add(366, "Write char to memory running.");
                    actionDescriptionDict.Add(367, "Write char to memory running.");
                    actionDescriptionDict.Add(368, "Write char to memory running.");
                    actionDescriptionDict.Add(369, "Write char to memory running.");
                    actionDescriptionDict.Add(161, "Write char to memory finished succesfully.");
                    actionDescriptionDict.Add(162, "Write char to memory restored.");


                    actionDescriptionDict.Add(800, "Read finished with error!");
                    actionDescriptionDict.Add(801, "Read was aborted, while not yet completed!");
                    actionDescriptionDict.Add(820, "Write finished with error!");
                    actionDescriptionDict.Add(821, "Write was aborted, while not yet completed!");
                    actionDescriptionDict.Add(840, "Reset communication finished with error!");
                    actionDescriptionDict.Add(841, "Reset communication was aborted, while not yet completed!");
                    actionDescriptionDict.Add(850, "Reset reader finished with error!");
                    actionDescriptionDict.Add(851, "Reset reader was aborted, while not yet completed!");
                    actionDescriptionDict.Add(860, "Write char to memory finished with error!");
                    actionDescriptionDict.Add(861, "Write char to memory was aborted, while not yet completed!");

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

