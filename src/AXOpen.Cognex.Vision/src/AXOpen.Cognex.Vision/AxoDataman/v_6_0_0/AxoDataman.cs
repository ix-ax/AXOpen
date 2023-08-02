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
                    errorDescriptionDict.Add(0      , "   ");
                    errorDescriptionDict.Add(600,   "<#Waiting for the signal ResultsAvailable to be reseted!#>");
                    errorDescriptionDict.Add(601,   "<#Waiting for the signal TriggerReady to be set!#>");
                    errorDescriptionDict.Add(602,   "<#Waiting for the signal TriggerAcknowledge to be set!#>");
                    errorDescriptionDict.Add(603,   "<#Waiting for the signal ResultsAvailable to be set!#>");


                    errorDescriptionDict.Add(700    ,"<#Error: Parent has NULL reference!#>");
                    errorDescriptionDict.Add(701    ,"<#Error: AcquisitionControl has NULL reference!#>");
                    errorDescriptionDict.Add(702    ,"<#Error: AcquisitionStatus has NULL reference!#>");
                    errorDescriptionDict.Add(703    ,"<#Error: ResultsControl has NULL reference!#>");
                    errorDescriptionDict.Add(704    ,"<#Error: SoftEventControl  has NULL reference!#>");
                    errorDescriptionDict.Add(705    ,"<#Error: SoftEventStatus has NULL reference!#>");
                    errorDescriptionDict.Add(706    ,"<#Error: ResultData has NULL reference!#>");
                    errorDescriptionDict.Add(707    ,"<#Error: UserData has NULL reference!#>");
                    errorDescriptionDict.Add(708    ,"<#Error: ResultData has invalid size!#>");
                    errorDescriptionDict.Add(709    ,"<#Error: ResultData-lower bound index is not zero!#>");
                    errorDescriptionDict.Add(710    ,"<#Error: UserData has invalid size!#>");
                    errorDescriptionDict.Add(711    ,"<#Error: UserData-lower bound index is not zero!#>");

                }
                string errorDescription = "   ";
                if (errorDescriptionDict.TryGetValue(ErrorId.LastValue, out errorDescription))
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
                    actionDescriptionDict.Add(0     ,"   ");
                    actionDescriptionDict.Add(300   ,"<#Restore executed.#>");
                    actionDescriptionDict.Add(301   ,"<#Clearing of the result data started.#>");
                    actionDescriptionDict.Add(302   ,"<#Clearing of the result data running.#>");
                    actionDescriptionDict.Add(303   ,"<#Clearing of the result data was completed successfully.#>");
                    actionDescriptionDict.Add(304   ,"<#Reading started.#>");
                    actionDescriptionDict.Add(305   ,"<#Reading running.#>");
                    actionDescriptionDict.Add(306   ,"<#Reading was completed successfully.#>");


                    actionDescriptionDict.Add(600   ,"<#Clearing of the result data was aborted, while not yet completed!#>");
                    actionDescriptionDict.Add(601   ,"<#Reading was aborted, while not yet completed!#>");

                    actionDescriptionDict.Add(700   ,"<#Clearing of the result data finished with error!#>");
                    actionDescriptionDict.Add(701   ,"<#Reading finished with error!#>");

                }
                string actionDescription = "   ";
                if(actionDescriptionDict.TryGetValue(ActionId.LastValue, out actionDescription))
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
