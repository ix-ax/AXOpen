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
    public partial class AxoDataman : AXOpen.Core.AxoComponent, AXOpen.Components.Abstractions.IAxoCodeReader
    {
        public async Task WriteTaskDurationToConsole()
        {
            foreach (var task in this.GetChildren().OfType<AxoTask>())
            {
                Console.WriteLine($"{task.Symbol} : {await task.Duration.GetAsync()}");
            }
        }
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Clear reasult data started.",                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Clear reasult data finished succesfully.",                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Clear reasult data restored.",                                                 "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Reading started.",                                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Reading finished succesfully.",                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Reading restored.",                                                            "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Continous reading active: New data read.",                                     "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Parent has NULL reference in the Run method!",                                 "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("hwIdAcquisitionControl has invalid value in the Run method!",                  "Check the call of the `Run` method, if the `hwIdAcquisitionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("hwIdAcquisitionStatus has invalid value in the Run method!",                   "Check the call of the `Run` method, if the `hwIdAcquisitionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("hwIdResultsControl has invalid value in the Run method!",                      "Check the call of the `Run` method, if the `hwIdResultsControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("hwIdResultsStatus has invalid value in the Run method!",                       "Check the call of the `Run` method, if the `hwIdResultsStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("hwIdSoftEventControl has invalid value in the Run method!",                    "Check the call of the `Run` method, if the `hwIdSoftEventControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("hwIdResultData has invalid value in the Run method!",                          "Check the call of the `Run` method, if the `hwIdResultData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("hwIdUserData has invalid value in the Run method!",                            "Check the call of the `Run` method, if the `hwIdUserData` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("Error reading the AcquisitionStatus in the UpdateInputs method!",              "Check the value of the hwIdAcquisitionStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("Error reading the ResultsStatus in the UpdateInputs method!",                  "Check the value of the hwIdResultsStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Error reading the SoftEventControl in the UpdateInputs method!",               "Check the value of the hwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Error reading the ResultData in the UpdateInputs method!",                     "Check the value of the hwIdResultData and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("ResultData has invalid size!",                                                 "Check the real size of the `ResultData`, so as the value of the ResultDataSize parameter!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Error writing the AcquisitionControl in the UpdateOutputs method!",            "Check the value of the hwIdAcquisitionControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Error writing the ResultsControl in the UpdateOutputs method!",                "Check the value of the hwIdesultsControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Error writing the SoftEventControl in the UpdateOutputs method!",              "Check the value of the hwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("UserData has invalid size!",                                                   "Check the real size of the `UserData`, so as the value of the UserDataSize parameter!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Error writing the 16bytes of the UserData in the UpdateOutputs method!",       "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Error writing the 32bytes of the UserData in the UpdateOutputs method!",       "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(719, new AxoMessengerTextItem("Error writing the 64bytes of the UserData in the UpdateOutputs method!",       "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Error writing the 1286bytes of the UserData in the UpdateOutputs method!",     "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Error writing the 250bytes of the UserData in the UpdateOutputs method!",      "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Clearing of the result data finished with error!",                             "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Clearing of the result data was aborted, while not yet completed!",            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Reading finished with error!",                                                 "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Reading was aborted, while not yet completed!",                                "Check the details.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Continous reading finished with error!",                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Continous reading was aborted, while not yet completed!",                      "Check the details.")),
        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(600, new AxoMessengerTextItem("Waiting for the signal ResultsAvailable to be reseted!"        ,"Check the status of the `ResultsAvailable` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(610, new AxoMessengerTextItem("Waiting for the signal ResultsAvailable to be reseted!"        ,"Check the status of the `ResultsAvailable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611, new AxoMessengerTextItem("Waiting for the signal TriggerReady to be set!"                ,"Check the status of the `TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612, new AxoMessengerTextItem("Waiting for the signal TriggerAcknowledge to be set!"          ,"Check the status of the `TriggerAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613, new AxoMessengerTextItem("Waiting for the signal ResultsAvailable to be set!"            ,"Check the status of the `ResultsAvailable` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614, new AxoMessengerTextItem("ResultData has invalid size!"                                  ,"Check the real size of the `ResultData`, so as the value of the ResultDataSize parameter!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615, new AxoMessengerTextItem("Waiting for the ResultData to be copied!"                      ,"Check the status of the `ResultData` data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(619, new AxoMessengerTextItem("Waiting for the signal TriggerReady to be reseted!"            ,"Check the status of the `TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(620, new AxoMessengerTextItem("Waiting for the signal ErrorDetected to be reseted!"           ,"Check the status of the `ErrorDetected` signal.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoDataman_Status : AxoComponent_Status
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
                    errorDescriptionDict.Add(610, "Waiting for the signal ResultsAvailable to be reseted!");
                    errorDescriptionDict.Add(611, "Waiting for the signal TriggerReady to be set!");
                    errorDescriptionDict.Add(612, "Waiting for the signal TriggerAcknowledge to be set!");
                    errorDescriptionDict.Add(613, "Waiting for the signal ResultsAvailable to be set!");
                    errorDescriptionDict.Add(614, "ResultData has invalid size!");
                    errorDescriptionDict.Add(615, "Waiting for the ResultData to be copied!");
                    errorDescriptionDict.Add(619, "Waiting for the signal TriggerReady to be reseted!");
                    errorDescriptionDict.Add(620, "Waiting for the signal ErrorDetected to be reseted!");



                    errorDescriptionDict.Add(700, "Parent has NULL reference in the Run method!");
                    errorDescriptionDict.Add(701, "hwIdAcquisitionControl has invalid value in the Run method!");
                    errorDescriptionDict.Add(702, "hwIdAcquisitionStatus has invalid value in the Run method!");
                    errorDescriptionDict.Add(703, "hwIdResultsControl has invalid value in the Run method!");
                    errorDescriptionDict.Add(704, "hwIdResultsStatus has invalid value in the Run method!");
                    errorDescriptionDict.Add(705, "hwIdSoftEventControl has invalid value in the Run method!");
                    errorDescriptionDict.Add(706, "hwIdResultData has invalid value in the Run method!");
                    errorDescriptionDict.Add(707, "hwIdUserData has invalid value in the Run method!");

                    errorDescriptionDict.Add(708, "Error reading the AcquisitionStatus in the UpdateInputs method!");
                    errorDescriptionDict.Add(709, "Error reading the ResultsStatus in the UpdateInputs method!");
                    errorDescriptionDict.Add(710, "Error reading the SoftEventControl in the UpdateInputs method!");
                    errorDescriptionDict.Add(711, "Error reading the ResultData in the UpdateInputs method!");
                    errorDescriptionDict.Add(712, "ResultData has invalid size!");

                    errorDescriptionDict.Add(713, "Error writing the AcquisitionControl in the UpdateOutputs method!");
                    errorDescriptionDict.Add(714, "Error writing the ResultsControl in the UpdateOutputs method!");
                    errorDescriptionDict.Add(715, "Error writing the SoftEventControl in the UpdateOutputs method!");
                    errorDescriptionDict.Add(716, "UserData has invalid size!");
                    errorDescriptionDict.Add(717, "Error writing the 16bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(718, "Error writing the 32bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(719, "Error writing the 64bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(720, "Error writing the 1286bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(721, "Error writing the 250bytes of the UserData in the UpdateOutputs method!");


                    errorDescriptionDict.Add(800, "Clearing of the result data finished with error!");
                    errorDescriptionDict.Add(801, "Clearing of the result data was aborted, while not yet completed!");

                    errorDescriptionDict.Add(810, "Reading finished with error!");
                    errorDescriptionDict.Add(811, "Reading was aborted, while not yet completed!");

                    errorDescriptionDict.Add(820, "Continous reading finished with error!");
                    errorDescriptionDict.Add(821, "Continous reading was aborted, while not yet completed!");

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
                if (actionDescriptionDict == null) { actionDescriptionDict = new Dictionary<ulong, string>(); }
                if (actionDescriptionDict.Count == 0)
                {
                    actionDescriptionDict.Add(0, "   ");


                    actionDescriptionDict.Add(50, "Restore has been executed.");

                    actionDescriptionDict.Add(100,"Clear reasult data started.");
                    actionDescriptionDict.Add(300, "Clear reasult data running.");
                    actionDescriptionDict.Add(301, "Clear reasult data running.");
                    actionDescriptionDict.Add(302, "Clear reasult data running.");
                    actionDescriptionDict.Add(303, "Clear reasult data running.");
                    actionDescriptionDict.Add(304, "Clear reasult data running.");
                    actionDescriptionDict.Add(305, "Clear reasult data running.");
                    actionDescriptionDict.Add(306, "Clear reasult data running.");
                    actionDescriptionDict.Add(307, "Clear reasult data running.");
                    actionDescriptionDict.Add(308, "Clear reasult data running.");
                    actionDescriptionDict.Add(309, "Clear reasult data running.");
                    actionDescriptionDict.Add(101,"Clear reasult data finished succesfully.");
                    actionDescriptionDict.Add(102,"Clear reasult data restored.");

                    actionDescriptionDict.Add(110,"Reading started.");
                    actionDescriptionDict.Add(310, "Clear reasult data running.");
                    actionDescriptionDict.Add(311, "Clear reasult data running.");
                    actionDescriptionDict.Add(312, "Clear reasult data running.");
                    actionDescriptionDict.Add(313, "Clear reasult data running.");
                    actionDescriptionDict.Add(314, "Clear reasult data running.");
                    actionDescriptionDict.Add(315, "Clear reasult data running.");
                    actionDescriptionDict.Add(316, "Clear reasult data running.");
                    actionDescriptionDict.Add(317, "Clear reasult data running.");
                    actionDescriptionDict.Add(318, "Clear reasult data running.");
                    actionDescriptionDict.Add(319, "Clear reasult data running.");
                    actionDescriptionDict.Add(320, "Clear reasult data running.");
                    actionDescriptionDict.Add(321, "Clear reasult data running.");
                    actionDescriptionDict.Add(322, "Clear reasult data running.");
                    actionDescriptionDict.Add(323, "Clear reasult data running.");
                    actionDescriptionDict.Add(324, "Clear reasult data running.");
                    actionDescriptionDict.Add(325, "Clear reasult data running.");
                    actionDescriptionDict.Add(326, "Clear reasult data running.");
                    actionDescriptionDict.Add(327, "Clear reasult data running.");
                    actionDescriptionDict.Add(328, "Clear reasult data running.");
                    actionDescriptionDict.Add(329, "Clear reasult data running.");

                    actionDescriptionDict.Add(111,"Reading finished succesfully.");
                    actionDescriptionDict.Add(112,"Reading restored.");


                    actionDescriptionDict.Add(120, "Continous reading active: New data read.");

                    actionDescriptionDict.Add(800, "Clearing of the result data finished with error!");
                    actionDescriptionDict.Add(801, "Clearing of the result data was aborted, while not yet completed!");

                    actionDescriptionDict.Add(810, "Reading finished with error!");
                    actionDescriptionDict.Add(811, "Reading was aborted, while not yet completed!");

                    actionDescriptionDict.Add(820, "Continous reading finished with error!");
                    actionDescriptionDict.Add(821, "Continous reading was aborted, while not yet completed!");


                }
                string actionDescription = "   ";
                if (Action == null || Action.Id == null)
                {
                    return string.Empty;
                }

                if (actionDescriptionDict.TryGetValue(Action.Id.LastValue, out actionDescription))
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
