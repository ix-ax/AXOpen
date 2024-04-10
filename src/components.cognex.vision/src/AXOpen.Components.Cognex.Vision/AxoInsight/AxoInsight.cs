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

                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Clearing of the inspection results started.",                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Clearing of the inspection results finished succesfully.",                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Clearing of the inspection results restored.",                                 "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Reading started.",                                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Reading finished succesfully.",                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Reading restored.",                                                            "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Change job by name started.",                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Change job by name finished succesfully.",                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Change job by name restored.",                                                 "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("Change job by number started.",                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("Change job by number finished succesfully.",                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("Change job by number restored.",                                               "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("SoftEvent started.",                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("SoftEvent finished succesfully.",                                              "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("SoftEvent restored.",                                                          "")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Parent has NULL reference in the Run method!",                                 "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("hwIdAcquisitionControl has invalid value in the Run method!",                  "Check the call of the `Run` method, if the `hwIdAcquisitionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("hwIdAcquisitionStatus has invalid value in the Run method!",                   "Check the call of the `Run` method, if the `hwIdAcquisitionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("hwIdInspectionControl has invalid value in the Run method!",                   "Check the call of the `Run` method, if the `hwIdInspectionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("hwIdInspectionStatus has invalid value in the Run method!",                    "Check the call of the `Run` method, if the `hwIdInspectionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("hwIdCommandControl has invalid value in the Run method!",                      "Check the call of the `Run` method, if the `hwIdCommandControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("hwIdSoftEventControl has invalid value in the Run method!",                    "Check the call of the `Run` method, if the `hwIdSoftEventControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("hwIdResultData has invalid value in the Run method!",                          "Check the call of the `Run` method, if the `hwIdResultData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("hwIdUserData has invalid value in the Run method!",                            "Check the call of the `Run` method, if the `hwIdUserData` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("Error reading the AcquisitionStatus in the UpdateInputs method!",              "Check the value of the hwIdAcquisitionStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Error reading the InspectionStatus in the UpdateInputs method!",               "Check the value of the hwIdInspectionStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Error reading the CommandControl in the UpdateInputs method!",                 "Check the value of the hwIdCommandControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Error reading the SoftEventControl in the UpdateInputs method!",               "Check the value of the hwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Error reading the ResultData in the UpdateInputs method!",                     "Check the value of the hwIdResultData and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("ResultData has invalid size!",                                                 "Check the real size of the `ResultData`, so as the value of the ResultDataSize parameter!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Error writing the AcquisitionControl in the UpdateOutputs method!",            "Check the value of the hwIdAcquisitionControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Error writing the ResultsControl in the UpdateOutputs method!",                "Check the value of the hwIdesultsControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Error writing the CommandControl in the UpdateOutputs method!",                "Check the value of the hwIdCommandControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Error writing the SoftEventControl in the UpdateOutputs method!",              "Check the value of the hwIdSoftEventControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(719, new AxoMessengerTextItem("UserData has invalid size!",                                                   "Check the real size of the `UserData`, so as the value of the UserDataSize parameter!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Error writing the 16bytes of the UserData in the UpdateOutputs method!",       "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Error writing the 32bytes of the UserData in the UpdateOutputs method!",       "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Error writing the 64bytes of the UserData in the UpdateOutputs method!",       "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Error writing the 1286bytes of the UserData in the UpdateOutputs method!",     "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Error writing the 254bytes of the UserData in the UpdateOutputs method!",      "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Clearing of the inspection results finished with error!",                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Clearing of the inspection results was aborted, while not yet completed!",     "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Reading finished with error!",                                                 "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Reading was aborted, while not yet completed!",                                "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Change job by name finished with error!",                                      "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Change job by name was aborted, while not yet completed!",                     "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Change job by number finished with error!",                                    "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Change job by number was aborted, while not yet completed!",                   "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("SoftEvent finished with error!",                                               "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("SoftEvent was aborted, while not yet completed!",                              "Check the details.")),

            };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(601, new AxoMessengerTextItem("Waiting for the signal ResultsValid to be reseted!"                      ,"Check the status of the `ResultsValid` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(611, new AxoMessengerTextItem("Waiting for the signal ExposureComplete to be reseted!"                  ,"Check the status of the `ExposureComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612, new AxoMessengerTextItem("Waiting for the signal ResultsValid to be reseted!"                      ,"Check the status of the `ResultsValid` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613, new AxoMessengerTextItem("Waiting for the signal Error to be reseted!"                             ,"Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614, new AxoMessengerTextItem("Waiting for the signal TriggerReady to be set!"                          ,"Check the status of the `TriggerReady` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615, new AxoMessengerTextItem("Waiting for the signal TriggerAcknowledge to be set!"                    ,"Check the status of the `TriggerAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(616, new AxoMessengerTextItem("Waiting for the signal InspectionCompleted to be toggled!"               ,"Check the status of the `InspectionCompleted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(617, new AxoMessengerTextItem("Waiting for the signal ResultsValid to be set!"                          ,"Check the status of the `ResultsValid` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(618, new AxoMessengerTextItem("Waiting for the InspectionResults to be copied!"                         ,"Check the status of the `InspectionResults` data.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(621, new AxoMessengerTextItem("Waiting for the signal CommandExecuting to be reseted!"                  ,"Check the status of the `CommandExecuting` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(622, new AxoMessengerTextItem("Waiting for the signal Online to be reseted!"                            ,"Check the status of the `Online` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(623, new AxoMessengerTextItem("Waiting for the signal Error to be reseted!"                             ,"Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(624, new AxoMessengerTextItem("Waiting for the Job name to be written to User data!"                    ,"Check the status of the `User` data.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(625, new AxoMessengerTextItem("Waiting for the signal ExtendedUserDataSetAcknowledge to be set!"        ,"Check the status of the `ExtendedUserDataSetAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(626, new AxoMessengerTextItem("Waiting for the signal ExtendedUserDataSetAcknowledge to be reseted!"    ,"Check the status of the `ExtendedUserDataSetAcknowledge` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(627, new AxoMessengerTextItem("Waiting for the signal CommandComplete to be set!"                       ,"Check the status of the `CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(628, new AxoMessengerTextItem("Waiting for the signal CommandComplete to be reseted!"                   ,"Check the status of the `CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(629, new AxoMessengerTextItem("Waiting for the signal Online to be set!"                                ,"Check the status of the `Online` signal.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(641, new AxoMessengerTextItem("Waiting for the signal CommandExecuting to be reseted!"                  ,"Check the status of the `CommandExecuting` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(642, new AxoMessengerTextItem("Waiting for the signal Online to be reseted!"                            ,"Check the status of the `Online` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(643, new AxoMessengerTextItem("Waiting for the signal Error to be reseted!"                             ,"Check the status of the `Error` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(644, new AxoMessengerTextItem("Waiting for the signal CommandComplete to be set!"                       ,"Check the status of the `CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(645, new AxoMessengerTextItem("Waiting for the signal CommandComplete to be reseted!"                   ,"Check the status of the `CommandComplete` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(646, new AxoMessengerTextItem("Waiting for the signal Online to be set!"                                ,"Check the status of the `Online` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(652, new AxoMessengerTextItem("Waiting for the signal TriggerSoftEvent to be set!"                      ,"Check the status of the `TriggerSoftEvent` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(653, new AxoMessengerTextItem("Waiting for the signal TriggerSoftEvent to be reseted!"                  ,"Check the status of the `TriggerSoftEvent` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("Empty job name inserted!"                                                ,"Check the required job name.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Required job number is greater than the maximal value!"                  ,"Check the sensor manufacturer documentation.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(727, new AxoMessengerTextItem("Required soft event number is greater than the maximal value of 7!"      ,"Check the sensor manufacturer documentation.")),

            };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }

    public partial class AxoInsight_Status : AxoComponent_Status
    {
        Dictionary<ulong, string> errorDescriptionDict = new Dictionary<ulong, string>();
        Dictionary<ulong, string> actionDescriptionDict = new Dictionary<ulong, string>();

        public string ErrorDescription 
        {
            get
            {
                if(errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<ulong, string>(); }
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


                    errorDescriptionDict.Add(700, "Parent has NULL reference in the Run method!");
                    errorDescriptionDict.Add(701, "hwIdAcquisitionControl has invalid value in the Run method!");
                    errorDescriptionDict.Add(702, "hwIdAcquisitionStatus has invalid value in the Run method!");
                    errorDescriptionDict.Add(703, "hwIdInspectionControl has invalid value in the Run method!");
                    errorDescriptionDict.Add(704, "hwIdInspectionStatus has invalid value in the Run method!");
                    errorDescriptionDict.Add(705, "hwIdCommandControl has invalid value in the Run method!");
                    errorDescriptionDict.Add(706, "hwIdSoftEventControl has invalid value in the Run method!");
                    errorDescriptionDict.Add(707, "hwIdResultData has invalid value in the Run method!");
                    errorDescriptionDict.Add(708, "hwIdUserData has invalid value in the Run method!");
                    errorDescriptionDict.Add(709, "Error reading the AcquisitionStatus in the UpdateInputs method!");
                    errorDescriptionDict.Add(710, "Error reading the InspectionStatus in the UpdateInputs method!");
                    errorDescriptionDict.Add(711, "Error reading the CommandControl in the UpdateInputs method!");
                    errorDescriptionDict.Add(712, "Error reading the SoftEventControl in the UpdateInputs method!");
                    errorDescriptionDict.Add(713, "Error reading the ResultData in the UpdateInputs method!");
                    errorDescriptionDict.Add(714, "ResultData has invalid size!");
                    errorDescriptionDict.Add(715, "Error writing the AcquisitionControl in the UpdateOutputs method!");
                    errorDescriptionDict.Add(716, "Error writing the ResultsControl in the UpdateOutputs method!");
                    errorDescriptionDict.Add(717, "Error writing the CommandControl in the UpdateOutputs method!");
                    errorDescriptionDict.Add(718, "Error writing the SoftEventControl in the UpdateOutputs method!");
                    errorDescriptionDict.Add(719, "UserData has invalid size!");
                    errorDescriptionDict.Add(720, "Error writing the 16bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(721, "Error writing the 32bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(722, "Error writing the 64bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(723, "Error writing the 1286bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(724, "Error writing the 254bytes of the UserData in the UpdateOutputs method!");
                    errorDescriptionDict.Add(725, "Empty job name inserted!");
                    errorDescriptionDict.Add(726, "Required job number is greater than the maximal value!");
                    errorDescriptionDict.Add(727, "Required soft event number is greater than the maximal value of 7!");
                    errorDescriptionDict.Add(800, "Clearing of the inspection results finished with error!");
                    errorDescriptionDict.Add(801, "Clearing of the inspection results was aborted, while not yet completed!");
                    errorDescriptionDict.Add(810, "Reading finished with error!");
                    errorDescriptionDict.Add(811, "Reading was aborted, while not yet completed!");
                    errorDescriptionDict.Add(820, "Change job by name finished with error!");
                    errorDescriptionDict.Add(821, "Change job by name was aborted, while not yet completed!");
                    errorDescriptionDict.Add(840, "Change job by number finished with error!");
                    errorDescriptionDict.Add(841, "Change job by number was aborted, while not yet completed!");
                    errorDescriptionDict.Add(850, "SoftEvent finished with error!");
                    errorDescriptionDict.Add(851, "SoftEvent was aborted, while not yet completed!");
                }
                string errorDescription = "   ";

                if(Error == null)
                    return errorDescription;

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

                    actionDescriptionDict.Add(100, "Clearing of the inspection results started.");
                    actionDescriptionDict.Add(300, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(301, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(302, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(303, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(304, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(305, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(306, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(307, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(308, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(309, "Clearing of the inspection results running.");
                    actionDescriptionDict.Add(101, "Clearing of the inspection results finished succesfully.");
                    actionDescriptionDict.Add(102, "Clearing of the inspection results restored.");

                    actionDescriptionDict.Add(110, "Reading started.");
                    actionDescriptionDict.Add(310, "Reading running.");
                    actionDescriptionDict.Add(311, "Reading running.");
                    actionDescriptionDict.Add(312, "Reading running.");
                    actionDescriptionDict.Add(313, "Reading running.");
                    actionDescriptionDict.Add(314, "Reading running.");
                    actionDescriptionDict.Add(315, "Reading running.");
                    actionDescriptionDict.Add(316, "Reading running.");
                    actionDescriptionDict.Add(317, "Reading running.");
                    actionDescriptionDict.Add(318, "Reading running.");
                    actionDescriptionDict.Add(319, "Reading running.");
                    actionDescriptionDict.Add(111, "Reading finished succesfully.");
                    actionDescriptionDict.Add(112, "Reading restored.");

                    actionDescriptionDict.Add(120, "Change job by name started.");
                    actionDescriptionDict.Add(320, "Change job by name running.");
                    actionDescriptionDict.Add(321, "Change job by name running.");
                    actionDescriptionDict.Add(322, "Change job by name running.");
                    actionDescriptionDict.Add(323, "Change job by name running.");
                    actionDescriptionDict.Add(324, "Change job by name running.");
                    actionDescriptionDict.Add(325, "Change job by name running.");
                    actionDescriptionDict.Add(326, "Change job by name running.");
                    actionDescriptionDict.Add(327, "Change job by name running.");
                    actionDescriptionDict.Add(328, "Change job by name running.");
                    actionDescriptionDict.Add(329, "Change job by name running.");
                    actionDescriptionDict.Add(330, "Change job by name running.");
                    actionDescriptionDict.Add(331, "Change job by name running.");
                    actionDescriptionDict.Add(332, "Change job by name running.");
                    actionDescriptionDict.Add(333, "Change job by name running.");
                    actionDescriptionDict.Add(334, "Change job by name running.");
                    actionDescriptionDict.Add(335, "Change job by name running.");
                    actionDescriptionDict.Add(336, "Change job by name running.");
                    actionDescriptionDict.Add(337, "Change job by name running.");
                    actionDescriptionDict.Add(338, "Change job by name running.");
                    actionDescriptionDict.Add(339, "Change job by name running.");
                    actionDescriptionDict.Add(121, "Change job by name finished succesfully.");
                    actionDescriptionDict.Add(122, "Change job by name restored.");

                    actionDescriptionDict.Add(140, "Change job by number started.");
                    actionDescriptionDict.Add(340, "Change job by number running.");
                    actionDescriptionDict.Add(341, "Change job by number running.");
                    actionDescriptionDict.Add(342, "Change job by number running.");
                    actionDescriptionDict.Add(343, "Change job by number running.");
                    actionDescriptionDict.Add(344, "Change job by number running.");
                    actionDescriptionDict.Add(345, "Change job by number running.");
                    actionDescriptionDict.Add(346, "Change job by number running.");
                    actionDescriptionDict.Add(347, "Change job by number running.");
                    actionDescriptionDict.Add(348, "Change job by number running.");
                    actionDescriptionDict.Add(349, "Change job by number running.");
                    actionDescriptionDict.Add(141, "Change job by number finished succesfully.");
                    actionDescriptionDict.Add(142, "Change job by number restored.");

                    actionDescriptionDict.Add(150, "SoftEvent started.");
                    actionDescriptionDict.Add(350, "SoftEvent running.");
                    actionDescriptionDict.Add(351, "SoftEvent running.");
                    actionDescriptionDict.Add(352, "SoftEvent running.");
                    actionDescriptionDict.Add(353, "SoftEvent running.");
                    actionDescriptionDict.Add(354, "SoftEvent running.");
                    actionDescriptionDict.Add(355, "SoftEvent running.");
                    actionDescriptionDict.Add(356, "SoftEvent running.");
                    actionDescriptionDict.Add(357, "SoftEvent running.");
                    actionDescriptionDict.Add(358, "SoftEvent running.");
                    actionDescriptionDict.Add(359, "SoftEvent running.");
                    actionDescriptionDict.Add(151, "SoftEvent finished succesfully.");
                    actionDescriptionDict.Add(152, "SoftEvent restored.");


                    actionDescriptionDict.Add(800, "Clearing of the inspection results finished with error!");
                    actionDescriptionDict.Add(801, "Clearing of the inspection results was aborted, while not yet completed!");
                    actionDescriptionDict.Add(810, "Reading finished with error!");
                    actionDescriptionDict.Add(811, "Reading was aborted, while not yet completed!");
                    actionDescriptionDict.Add(820, "Change job by name finished with error!");
                    actionDescriptionDict.Add(821, "Change job by name  was aborted, while not yet completed!");
                    actionDescriptionDict.Add(840, "Change job by number finished with error!");
                    actionDescriptionDict.Add(841, "Change job by number  was aborted, while not yet completed!");
                    actionDescriptionDict.Add(850, "Soft event finished with error!");
                    actionDescriptionDict.Add(851, "Soft event finished  was aborted, while not yet completed!");
                }
                
                string actionDescription = "   ";

                if (Action == null)
                    return actionDescription;

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

