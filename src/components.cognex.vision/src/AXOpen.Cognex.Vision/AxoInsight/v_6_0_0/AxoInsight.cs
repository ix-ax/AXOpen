using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;

namespace AXOpen.Components.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoInsight
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            try
            {
                InitializeMessenger();
                InitializeTaskMessenger();
            }
            catch (Exception)
            {

                throw;
            }
        }
        private void InitializeMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Parent has NULL reference!",                   "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("refAcquisitionControl has NULL reference!",    "Check the call of the `Run` method, if the `refAcquisitionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("refAcquisitionStatus has NULL reference!",     "Check the call of the `Run` method, if the `refAcquisitionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("refInspectionControl has NULL reference!",     "Check the call of the `Run` method, if the `refInspectionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("refInspectionStatus has NULL reference!",      "Check the call of the `Run` method, if the `refInspectionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("refCommandControl has NULL reference!",        "Check the call of the `Run` method, if the `refCommandControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("refCommandStatus has NULL reference!",         "Check the call of the `Run` method, if the `refCommandStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("refSoftEventControl has NULL reference!",      "Check the call of the `Run` method, if the `refSoftEventControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("refSoftEventStatus has NULL reference!",       "Check the call of the `Run` method, if the `refSoftEventStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("refResultData has NULL reference!",            "Check the call of the `Run` method, if the `refResultData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("refUserData has NULL reference!",              "Check the call of the `Run` method, if the `refUserData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("refResultData has invalid size!",              "Check the size of the `refResultData`.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("refResultData-lower bound index is not zero!", "Check if the `refResultData` parameter is zero-based.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("refUserData has invalid size!",                "Check the size of the `refUserData`.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("refUserData-lower bound index is not zero!",   "Check if the `refUsertData` parameter is zero-based.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("refUserData has invalid size!",                "Check the size of the `refUserData`.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("refUserData-lower bound index is not zero!",   "Check if the `refUsertData` parameter is zero-based.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Clearing of the inspection results finished with error!",                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Reading finished with error!",                                                 "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(719, new AxoMessengerTextItem("Change job by name finished with error!",                                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Change job by number finished with error!",                                    "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Soft event finished with error!",                                              "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Clearing of the inspection results was aborted, while not yet completed!",     "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Reading was aborted, while not yet completed!",                                "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Change job by name was aborted, while not yet completed!",                     "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Change job by number was aborted, while not yet completed!",                   "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Soft event was aborted, while not yet completed!",                             "Check the details.")),
            };

            _Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(600, new AxoMessengerTextItem("Waiting for the signal ExposureComplete to be reseted!"                  ,"Check the status of the `ExposureComplete` signal.")), 
                new KeyValuePair<ulong, AxoMessengerTextItem>(601, new AxoMessengerTextItem("Waiting for the signal ResultsValid to be reseted!"                      ,"Check the status of the `ResultsValid` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602, new AxoMessengerTextItem("Waiting for the signal Error to be reseted!"                             ,"Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603, new AxoMessengerTextItem("Waiting for the signal TriggerReady to be set!"                          ,"Check the status of the `TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604, new AxoMessengerTextItem("Waiting for the signal TriggerAcknowledge to be set!"                    ,"Check the status of the `TriggerAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(605, new AxoMessengerTextItem("Waiting for the signal InspectionCompleted to be toggled!"               ,"Check the status of the `InspectionCompleted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(606, new AxoMessengerTextItem("Waiting for the signal ResultsValid to be set!"                          ,"Check the status of the `ResultsValid` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(607, new AxoMessengerTextItem("Waiting for the InspectionResults to be copied!"                         ,"Check the status of the `InspectionResults` data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(608, new AxoMessengerTextItem("Waiting for the signal CommandExecuting to be reseted!"                  ,"Check the status of the `CommandExecuting` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(609, new AxoMessengerTextItem("Waiting for the signal Online to be reseted!"                            ,"Check the status of the `Online` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(610, new AxoMessengerTextItem("Waiting for the signal Error to be reseted!"                             ,"Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611, new AxoMessengerTextItem("Waiting for the Job name to be written to User data!"                    ,"Check the status of the `User` data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612, new AxoMessengerTextItem("Waiting for the signal ExtendedUserDataSetAcknowledge to be set!"        ,"Check the status of the `ExtendedUserDataSetAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613, new AxoMessengerTextItem("Waiting for the signal ExtendedUserDataSetAcknowledge to be reseted!"    ,"Check the status of the `ExtendedUserDataSetAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614, new AxoMessengerTextItem("Waiting for the signal CommandComplete to be set!"                       ,"Check the status of the `CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615, new AxoMessengerTextItem("Waiting for the signal CommandComplete to be reseted!"                   ,"Check the status of the `CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(616, new AxoMessengerTextItem("Waiting for the signal Online to be set!"                                ,"Check the status of the `Online` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(617, new AxoMessengerTextItem("Waiting for the signal TriggerSoftEvent to be set!"                      ,"Check the status of the `TriggerSoftEvent` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(618, new AxoMessengerTextItem("Waiting for the signal TriggerSoftEvent to be reseted!"                  ,"Check the status of the `TriggerSoftEvent` signal.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(619, new AxoMessengerTextItem("","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(620, new AxoMessengerTextItem("","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(621, new AxoMessengerTextItem("","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(622, new AxoMessengerTextItem("","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(623, new AxoMessengerTextItem("","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Empty job name inserted!","Check the required job name.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Index of UserData in the method SetUserDataAsString exceeds the size hardware structure mapped!","Check the size and the offset of the data written to the User data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Index of UserData in the method SetUserDataAsString exceeds the defined size!","Check the size and the offset of the data written to the User data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Change job by name failed. Check the value of the InspectionStatus.Error code!","Check the sensor manufacturer documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(719, new AxoMessengerTextItem("Required job number is greater than the maximal value!","Check the sensor manufacturer documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Change job by number failed. Check the value of the InspectionStatus.Error code!","Check the sensor manufacturer documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Required soft event number is greater than the maximal value of 7!","Check the sensor manufacturer documentation.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("","")),

            };

            _TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
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
                    errorDescriptionDict.Add(617, "Waiting for the signal TriggerSoftEvent to be set!");
                    errorDescriptionDict.Add(618, "Waiting for the signal TriggerSoftEvent to be reseted!");
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
                    errorDescriptionDict.Add(719, "Required job number is greater than the maximal value!");
                    errorDescriptionDict.Add(720, "Change job by number failed. Check the value of the InspectionStatus.Error code!");
                    errorDescriptionDict.Add(721, "Required soft event number is greater than the maximal value of 7!");
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
                    actionDescriptionDict.Add(318, "Soft event started.");
                    actionDescriptionDict.Add(319, "Soft event running.");
                    actionDescriptionDict.Add(320, "Soft event was completed successfully.");
                    actionDescriptionDict.Add(321, "Soft event restored.");


                    actionDescriptionDict.Add(600, "Clearing of the inspection results was aborted, while not yet completed!");
                    actionDescriptionDict.Add(601, "Reading was aborted, while not yet completed!");
                    actionDescriptionDict.Add(602, "Change job by name was aborted, while not yet completed!");
                    actionDescriptionDict.Add(603, "Change job by number was aborted, while not yet completed!");
                    actionDescriptionDict.Add(604, "Soft event was aborted, while not yet completed!");
                    //actionDescriptionDict.Add(6, "");
                    //actionDescriptionDict.Add(6, "");
                    //actionDescriptionDict.Add(6, "");
                    //actionDescriptionDict.Add(6, "");
                    //actionDescriptionDict.Add(6, "");
                    //actionDescriptionDict.Add(6, "");


                    actionDescriptionDict.Add(700, "Clearing of the inspection results finished with error!");
                    actionDescriptionDict.Add(701, "Reading finished with error!");
                    actionDescriptionDict.Add(702, "Change job by name finished with error!");
                    actionDescriptionDict.Add(703, "Change job by number finished with error!");
                    actionDescriptionDict.Add(704, "Soft event finished with error!");
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

