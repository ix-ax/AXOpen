using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using AXOpen.Components.Abstractions;
namespace AXOpen.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoInsight
    {
    }

    public partial class AxoInsight_Status : AxoComponent_Status
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
                    errorDescriptionDict.Add(600, "Waiting for the signal ExposureComplete to be reseted!");
                    errorDescriptionDict.Add(601, "Waiting for the signal ResultsValid to be reseted!");
                    errorDescriptionDict.Add(602, "Waiting for the signal Error to be reseted!");
                    errorDescriptionDict.Add(603, "Waiting for the signal TriggerReady to be set!");
                    errorDescriptionDict.Add(604, "Waiting for the signal TriggerAcknowledge to be set!");
                    errorDescriptionDict.Add(605, "Waiting for the signal InspectionCompleted to be toggled!");
                    errorDescriptionDict.Add(606, "Waiting for the signal ResultsValid to be set!");
                    errorDescriptionDict.Add(607, "Waiting for the InspectionResults to be copied!");
                    errorDescriptionDict.Add(608, "Waiting for the signal CommandExecuting to be reseted!");
                    errorDescriptionDict.Add(609, "Waiting for the signal Online to be reseted!");
                    errorDescriptionDict.Add(610, "Waiting for the signal Error to be reseted!");
                    errorDescriptionDict.Add(611, "Waiting for the Job name to be written to the User data!");
                    errorDescriptionDict.Add(612, "Waiting for the signal ExtendedUserDataSetAcknowledge to be set!");
                    errorDescriptionDict.Add(613, "Waiting for the signal ExtendedUserDataSetAcknowledge to be reseted!");
                    errorDescriptionDict.Add(614, "Waiting for the signal CommandComplete to be set!");
                    errorDescriptionDict.Add(615, "Waiting for the signal CommandComplete to be reseted!");
                    errorDescriptionDict.Add(616, "Waiting for the signal Online to be set!");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");
                    //errorDescriptionDict.Add(6, "");



                    errorDescriptionDict.Add(700, "Error: Parent has NULL reference!");
                    errorDescriptionDict.Add(701, "Error: AcquisitionControl has NULL reference!");
                    errorDescriptionDict.Add(702, "Error: AcquisitionStatus has NULL reference!");
                    errorDescriptionDict.Add(703, "Error: InspectionControl has NULL reference!");
                    errorDescriptionDict.Add(704, "Error: InspectionStatus has NULL reference!");
                    errorDescriptionDict.Add(705, "Error: CommandControl has NULL reference!");
                    errorDescriptionDict.Add(706, "Error: CommandStatus has NULL reference!");
                    errorDescriptionDict.Add(707, "Error: SoftEventControl has NULL reference!");
                    errorDescriptionDict.Add(708, "Error: SoftEventStatus has NULL reference!");
                    errorDescriptionDict.Add(709, "Error: ResultData has NULL reference!");
                    errorDescriptionDict.Add(710, "Error: UserData has NULL reference!");
                    errorDescriptionDict.Add(711, "Error: ResultData has invalid size!");
                    errorDescriptionDict.Add(712, "Error: ResultData-lower bound index is not zero!");
                    errorDescriptionDict.Add(713, "Error: UserData has invalid size!");
                    errorDescriptionDict.Add(714, "Error: UserData-lower bound index is not zero!");
                    errorDescriptionDict.Add(715, "Empty job name inserted!");
                    errorDescriptionDict.Add(716, "Index of UserData in method SetUserDataAsString exceeds the size hardware structure mapped!");
                    errorDescriptionDict.Add(717, "Index of UserData in method SetUserDataAsString exceeds the defined size!");
                    errorDescriptionDict.Add(718, "Change job by name failed. Check the value of the InspectionStatus.Error code!");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");
                    //errorDescriptionDict.Add(7, "");



                }
                string errorDescription = "   ";
                if (errorDescriptionDict.TryGetValue(Error.Id.LastValue, out errorDescription))
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
                    actionDescriptionDict.Add(300, "Restore executed.");
                    actionDescriptionDict.Add(301, "Clearing of the inspection results started.");
                    actionDescriptionDict.Add(302, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(303, "Clearing of the inspection results was completed successfully.");
                    actionDescriptionDict.Add(304, "Trigger started.");
                    actionDescriptionDict.Add(305, "Trigger running.");
                    actionDescriptionDict.Add(306, "Trigger was completed successfully.");
                    actionDescriptionDict.Add(307, "Continous reading active: New data read.");
                    actionDescriptionDict.Add(308, "Clearing of the inspection results restored.");
                    actionDescriptionDict.Add(309, "Reading restored.");
                    actionDescriptionDict.Add(310, "Change job by name started.");
                    actionDescriptionDict.Add(311, "Change job by name running.");
                    actionDescriptionDict.Add(312, "Change job by name was completed successfully.");
                    actionDescriptionDict.Add(313, "Change job by name restored.");
                    actionDescriptionDict.Add(314, "Change job by number started.");
                    actionDescriptionDict.Add(315, "Change job by number running.");
                    actionDescriptionDict.Add(316, "Change job by number was completed successfully.");
                    actionDescriptionDict.Add(317, "Change job by number restored.");


                    actionDescriptionDict.Add(600, "Clearing of the inspection results was aborted, while not yet completed!");
                    actionDescriptionDict.Add(601, "Reading was aborted, while not yet completed!");
                    actionDescriptionDict.Add(602, "Change job by name was aborted, while not yet completed!");
                    actionDescriptionDict.Add(603, "Change job by number was aborted, while not yet completed!");
                    //actionDescriptionDict.Add(604, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(606, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");
                    //actionDescriptionDict.Add(605, "");

                    actionDescriptionDict.Add(700, "Clearing of the inspection results finished with error!");
                    actionDescriptionDict.Add(701, "Reading finished with error!");
                    actionDescriptionDict.Add(702, "Change job by name finished with error!");
                    actionDescriptionDict.Add(703, "Change job by number finished with error!");
                    //actionDescriptionDict.Add(704, "");
                    //actionDescriptionDict.Add(705, "");
                    //actionDescriptionDict.Add(706, "");
                    //actionDescriptionDict.Add(706, "");
                    //actionDescriptionDict.Add(706, "");


                }
                string actionDescription = "   ";
                if(actionDescriptionDict.TryGetValue(Action.Id.LastValue, out actionDescription))
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
