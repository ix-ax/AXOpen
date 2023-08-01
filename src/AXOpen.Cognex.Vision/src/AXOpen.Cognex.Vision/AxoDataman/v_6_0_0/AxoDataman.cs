using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using AXOpen.Components.Abstractions;
namespace AXOpen.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoDataman
    {
    }

    public partial class AxoDataman_Status : AxoComponent_Status
    {
        Dictionary<uint, string> errorDescriptionDict = new Dictionary<uint, string>();
        Dictionary<uint, string> actionDescriptionDict = new Dictionary<uint, string>();

        public string ErrorDescription 
        {
            get
            {
                if(errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<uint, string>(); }
                if(errorDescriptionDict.Count == 0)
                {
                    errorDescriptionDict.Add(10     ,"<#Error: Parent has NULL reference#>.");
                    errorDescriptionDict.Add(11     ,"<#Error: AcquisitionControl has NULL reference#>.");
                    errorDescriptionDict.Add(12     ,"<#Error: AcquisitionStatus has NULL reference#>.");
                    errorDescriptionDict.Add(13     ,"<#Error: ResultsControl has NULL reference#>.");
                    errorDescriptionDict.Add(14     ,"<#Error: SoftEventControl  has NULL reference#>.");
                    errorDescriptionDict.Add(15     ,"<#Error: SoftEventStatus has NULL reference#>.");
                    errorDescriptionDict.Add(16     ,"<#Error: ResultData has NULL reference#>.");
                    errorDescriptionDict.Add(17     ,"<#Error: UserData has NULL reference#>.");
                    errorDescriptionDict.Add(20     ,"<#Error: ResultData has invalid size#>.");
                    errorDescriptionDict.Add(21     ,"<#Error: ResultData-lower bound index is not zero.#>.");
                    errorDescriptionDict.Add(22     ,"<#Error: UserData has invalid size#>.");
                    errorDescriptionDict.Add(23     ,"<#Error: UserData-lower bound index is not zero.#>.");
                    errorDescriptionDict.Add(1001   ,"<#Waiting for the signal ResultsAvailable to be reseted!#>");
                    errorDescriptionDict.Add(1002   ,"<#Waiting for the signal TriggerReady to be set!#>");
                    errorDescriptionDict.Add(1003   ,"<#Waiting for the signal TriggerAcknowledge to be set!#>");
                    errorDescriptionDict.Add(1004   ,"<#Waiting for the signal ResultsAvailable to be set!#>");

                }
                string errorDescription = "";
                errorDescriptionDict.TryGetValue(ErrorId.LastValue, out errorDescription);
                return errorDescription;
            }
        }

        public string ActionDescription
        {
            get
            {
                if (actionDescriptionDict == null) { actionDescriptionDict = new Dictionary<uint, string>(); }
                if (actionDescriptionDict.Count == 0)
                {
                    actionDescriptionDict.Add(10, "<#Restore executed.#>");
                    actionDescriptionDict.Add(11, "<#Clearing of the result data running.#>");
                    actionDescriptionDict.Add(12, "<#Clearing of the result data was aborted, while not yet completed!#>");
                    actionDescriptionDict.Add(13, "<#Clearing of the result data was completed successfully.#>");
                    actionDescriptionDict.Add(14, "<#Clearing of the result data finished with error!#>");
                    actionDescriptionDict.Add(15, "<#Clearing of the result data started.#>");
                    actionDescriptionDict.Add(16, "<#Reading running.#>");
                    actionDescriptionDict.Add(17, "<#Reading was aborted, while not yet completed!#>");
                    actionDescriptionDict.Add(18, "<#Reading was completed successfully.#>");
                    actionDescriptionDict.Add(19, "<#Reading finished with error!#>");
                    actionDescriptionDict.Add(20, "<#Reading started.#>");

                }
                string actionDescription = "";
                actionDescriptionDict.TryGetValue(ErrorId.LastValue, out actionDescription);
                return actionDescription;
            }
        }
    }
}
