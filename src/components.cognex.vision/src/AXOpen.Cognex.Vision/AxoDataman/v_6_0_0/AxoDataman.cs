using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;

namespace AXOpen.Components.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoDataman
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Parent has NULL reference!",                                                   "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("refAcquisitionControl has NULL reference!",                                    "Check the call of the `Run` method, if the `refAcquisitionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("refAcquisitionStatus has NULL reference!",                                     "Check the call of the `Run` method, if the `refAcquisitionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("refResultsControl has NULL reference!",                                        "Check the call of the `Run` method, if the `refResultsControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("refResultsStatus has NULL reference!",                                         "Check the call of the `Run` method, if the `refResultsStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("refSoftEventControl has NULL reference!",                                      "Check the call of the `Run` method, if the `refSoftEventControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("refSoftEventStatus has NULL reference!",                                       "Check the call of the `Run` method, if the `refSoftEventStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("refResultData has NULL reference!",                                            "Check the call of the `Run` method, if the `refResultData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("refUserData has NULL reference!",                                              "Check the call of the `Run` method, if the `refUserData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("refResultData has invalid size!",                                              "Check the size of the `refResultData`.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("refResultData-lower bound index is not zero!",                                 "Check if the `refResultData` parameter is zero-based.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("refUserData has invalid size!",                                                "Check the size of the `refUserData`.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("refUserData-lower bound index is not zero!",                                   "Check if the `refUsertData` parameter is zero-based.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("The ResultData length exceeds the configured hardware structure's length!",    "Change the configured hardware structure's length!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Clearing of the result data finished with error!",                             "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Reading finished with error!",                                                 "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Clearing of the result data was aborted, while not yet completed!",            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("eading was aborted, while not yet completed!",                                 "Check the details.")),
        };

            _Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(600, new AxoMessengerTextItem("Waiting for the signal ResultsAvailable to be reseted!"        ,"Check the status of the `ResultsAvailable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601, new AxoMessengerTextItem("Waiting for the signal TriggerReady to be set!"                ,"Check the status of the `TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602, new AxoMessengerTextItem("Waiting for the signal TriggerAcknowledge to be set!"          ,"Check the status of the `TriggerAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603, new AxoMessengerTextItem("Waiting for the signal ResultsAvailable to be set!"            ,"Check the status of the `ResultsAvailable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604, new AxoMessengerTextItem("Waiting for the ResultData to be copied!"                      ,"Check the status of the `ResultData` data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(605, new AxoMessengerTextItem("Waiting for the TriggerReady to be reseted!"                   ,"Check the status of the `TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(606, new AxoMessengerTextItem("Waiting for the ErrorDetected to be reseted!"                  ,"Check the status of the `ErrorDetected` signal.")),

        };

            _TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
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
                    errorDescriptionDict.Add(0, "   ");
                    errorDescriptionDict.Add(600, "Waiting for the signal ResultsAvailable to be reseted!");
                    errorDescriptionDict.Add(601, "Waiting for the signal TriggerReady to be set!");
                    errorDescriptionDict.Add(602, "Waiting for the signal TriggerAcknowledge to be set!");
                    errorDescriptionDict.Add(603, "Waiting for the signal ResultsAvailable to be set!");
                    errorDescriptionDict.Add(604, "Waiting for the ResultData to be copied!");
                    errorDescriptionDict.Add(605, "Waiting for the TriggerReady to be reseted!");
                    errorDescriptionDict.Add(606, "Waiting for the ErrorDetected to be reseted!");


                    errorDescriptionDict.Add(700, "Error: Parent has NULL reference!");
                    errorDescriptionDict.Add(701, "Error: AcquisitionControl has NULL reference!");
                    errorDescriptionDict.Add(702, "Error: AcquisitionStatus has NULL reference!");
                    errorDescriptionDict.Add(703, "Error: ResultsControl has NULL reference!");
                    errorDescriptionDict.Add(704, "Error: ResultsStatus has NULL reference!");
                    errorDescriptionDict.Add(705, "Error: SoftEventControl  has NULL reference!");
                    errorDescriptionDict.Add(706, "Error: SoftEventStatus has NULL reference!");
                    errorDescriptionDict.Add(707, "Error: ResultData has NULL reference!");
                    errorDescriptionDict.Add(708, "Error: UserData has NULL reference!");
                    errorDescriptionDict.Add(709, "Error: ResultData has invalid size!");
                    errorDescriptionDict.Add(710, "Error: ResultData-lower bound index is not zero!");
                    errorDescriptionDict.Add(711, "Error: UserData has invalid size!");
                    errorDescriptionDict.Add(712, "Error: UserData-lower bound index is not zero!");
                    errorDescriptionDict.Add(713, "Error: The ResultData length exceeds the configured hardware structure's length!");

                }
                string errorDescription = "   ";

                if (Error == null || Error.Id == null)
                {
                    return string.Empty;
                }

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
                    actionDescriptionDict.Add(301, "Clearing of the result data started.");
                    actionDescriptionDict.Add(302, "Clearing of the result data running.");
                    actionDescriptionDict.Add(303, "Clearing of the result data was completed successfully.");
                    actionDescriptionDict.Add(304, "Reading started.");
                    actionDescriptionDict.Add(305, "Reading running.");
                    actionDescriptionDict.Add(306, "Reading was completed successfully.");
                    actionDescriptionDict.Add(307, "Continous reading active: New data read.");
                    actionDescriptionDict.Add(308, "Clearing of the result data restored.");
                    actionDescriptionDict.Add(309, "Reading restored.");


                    actionDescriptionDict.Add(600   ,"Clearing of the result data was aborted, while not yet completed!");
                    actionDescriptionDict.Add(601   ,"Reading was aborted, while not yet completed!");

                    actionDescriptionDict.Add(700   ,"Clearing of the result data finished with error!");
                    actionDescriptionDict.Add(701   ,"Reading finished with error!");

                }
                string actionDescription = "   ";
                if (Action == null || Action.Id == null)
                {
                    return string.Empty;
                }
                
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
