using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace AXOpen.Components.Keyence.Vision
{
    public partial class Axo_SR_1000
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,   new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.","")),
                //// ClearResultDataTask
                //new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Clear reasult data started.",                                                  "")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Clear reasult data finished succesfully.",                                     "")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Clear reasult data restored.",                                                 "")),
                //// Read Task
                //new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Reading started.",                                                             "")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Reading finished succesfully.",                                                "")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Reading restored.",                                                            "")),
                //// Move to work task
                //new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Move to work task started.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Move to work task finished succesfully.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Move to work task restored.","")),
                // ClearResultDataTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(130, new AxoMessengerTextItem("ClearResultDataTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(131, new AxoMessengerTextItem("ClearResultDataTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(132, new AxoMessengerTextItem("ClearResultDataTask restored.","")),
                //// TemplateTask_10steps_2
                //new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("TemplateTask_10steps_2 started.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("TemplateTask_10steps_2 finished succesfully.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("TemplateTask_10steps_2 restored.","")),
                //// TemplateTask_10steps_3
                //new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("TemplateTask_10steps_3 started.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("TemplateTask_10steps_3 finished succesfully.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("TemplateTask_10steps_3 restored.","")),
                //// TemplateTask_10steps_4
                //new KeyValuePair<ulong, AxoMessengerTextItem>(160, new AxoMessengerTextItem("TemplateTask_10steps_4 started.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(161, new AxoMessengerTextItem("TemplateTask_10steps_4 finished succesfully.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(162, new AxoMessengerTextItem("TemplateTask_10steps_4 restored.","")),
                //// TemplateTask_10steps_5
                //new KeyValuePair<ulong, AxoMessengerTextItem>(170, new AxoMessengerTextItem("TemplateTask_10steps_5 started.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(171, new AxoMessengerTextItem("TemplateTask_10steps_5 finished succesfully.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(172, new AxoMessengerTextItem("TemplateTask_10steps_5 restored.","")),
                // ReadTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(180, new AxoMessengerTextItem("ReadTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(181, new AxoMessengerTextItem("ReadTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(182, new AxoMessengerTextItem("ReadTask restored.","")),
                // TuneTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(200, new AxoMessengerTextItem("TuneTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(201, new AxoMessengerTextItem("TuneTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(202, new AxoMessengerTextItem("TuneTask restored.","")),
                //// TemplateTask_20steps_3
                //new KeyValuePair<ulong, AxoMessengerTextItem>(220, new AxoMessengerTextItem("TemplateTask_20steps_3 started.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(221, new AxoMessengerTextItem("TemplateTask_20steps_3 finished succesfully.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(222, new AxoMessengerTextItem("TemplateTask_20steps_3 restored.","")),
                //// TemplateTask_20steps_4
                //new KeyValuePair<ulong, AxoMessengerTextItem>(240, new AxoMessengerTextItem("TemplateTask_20steps_4 started.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(241, new AxoMessengerTextItem("TemplateTask_20steps_4 finished succesfully.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(242, new AxoMessengerTextItem("TemplateTask_20steps_4 restored.","")),
                //// TemplateTask_20steps_5
                //new KeyValuePair<ulong, AxoMessengerTextItem>(260, new AxoMessengerTextItem("TemplateTask_20steps_5 started.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(261, new AxoMessengerTextItem("TemplateTask_20steps_5 finished succesfully.","")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(262, new AxoMessengerTextItem("TemplateTask_20steps_5 restored.","")),
                //  General alarm
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                          "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwID` has invalid value in `Run` method!",                                             "Check the call of the `Run` method, if the `hwID` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Input variable `hwIdHandshakeAndGeneralErrorStatus` has invalid value in `Run` method!",               "Check the call of the `Run` method, if the `hwIdHandshakeAndGeneralErrorStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Input variable `hwIdBUSY_Status` has invalid value in `Run` method!",                                  "Check the call of the `Run` method, if the `hwIdBUSY_Status` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Input variable `hwIdCompletionStatus` has invalid value in `Run` method!",                             "Check the call of the `Run` method, if the `hwIdCompletionStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Input variable `hwIdErrorStatus` has invalid value in `Run` method!",                                  "Check the call of the `Run` method, if the `hwIdErrorStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Input variable `hwIdTerminalStatus` has invalid value in `Run` method!",                               "Check the call of the `Run` method, if the `hwIdTerminalStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("Input variable `hwIdUnstableReadStatus` has invalid value in `Run` method!",                           "Check the call of the `Run` method, if the `hwIdUnstableReadStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("Input variable `hwIdMatchingLevelAndTotalEvaluationGradeStatus` has invalid value in `Run` method!",   "Check the call of the `Run` method, if the `hwIdMatchingLevelAndTotalEvaluationGradeStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("Input variable `hwIdOperationalResultStatus` has invalid value in `Run` method!",                      "Check the call of the `Run` method, if the `hwIdOperationalResultStatus` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Input variable `hwIdReadData` has invalid value in `Run` method!",                                     "Check the call of the `Run` method, if the `hwIdReadData` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Input variable `hwIdLatchAndErrorClearControlBitReg` has invalid value in `Run` method!",              "Check the call of the `Run` method, if the `hwIdLatchAndErrorClearControlBitReg` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Input variable `hwIdOperationInstructionControl` has invalid value in `Run` method!",                  "Check the call of the `Run` method, if the `hwIdOperationInstructionControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Input variable `hwIdCompletionClearControl` has invalid value in `Run` method!",                       "Check the call of the `Run` method, if the `hwIdCompletionClearControl` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Input variable `hwIdParameterBankNumber` has invalid value in `Run` method!",                          "Check the call of the `Run` method, if the `hwIdParameterBankNumber` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Input variable `hwIdUserData` has invalid value in `Run` method!",                                     "Check the call of the `Run` method, if the `hwIdUserData` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Error reading the HandshakeAndGeneralErrorStatus!",                                                    "Check the value of the hwIdHandshakeAndGeneralErrorStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Error reading the BUSY_Status!",                                                                       "Check the value of the hwIdBUSY_Status and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Error reading the CompletionStatus!",                                                                  "Check the value of the hwIdCompletionStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(719, new AxoMessengerTextItem("Error reading the ErrorStatus!",                                                                       "Check the value of the hwIdErrorStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(720, new AxoMessengerTextItem("Error reading the TerminalStatus!",                                                                    "Check the value of the hwIdTerminalStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(721, new AxoMessengerTextItem("Error reading the UnstableReadStatus!",                                                                "Check the value of the hwIdUnstableReadStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(722, new AxoMessengerTextItem("Error reading the MatchingLevelAndTotalEvaluationGradeStatus!",                                        "Check the value of the hwIdMatchingLevelAndTotalEvaluationGradeStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(723, new AxoMessengerTextItem("Error reading the OperationalResultStatus!",                                                           "Check the value of the hwIdOperationalResultStatus and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(724, new AxoMessengerTextItem("Error reading the ReadData!",                                                                          "Check the value of the hwIdReadData and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(725, new AxoMessengerTextItem("ResultData has invalid size!",                                                                         "Check the real size of the `ResultData`, so as the value of the ResultDataSize parameter!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(726, new AxoMessengerTextItem("Error writing the LatchAndErrorClearControl!",                                                         "Check the value of the hwIdLatchAndErrorClearControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(727, new AxoMessengerTextItem("Error writing the OperationInstructionControl!",                                                       "Check the value of the hwIdOperationInstructionControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(728, new AxoMessengerTextItem("Error writing the CompletionClearControl!",                                                            "Check the value of the hwIdCompletionClearControl and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(729, new AxoMessengerTextItem("Error writing the ParameterBankNumber!",                                                               "Check the value of the hwIdParameterBankNumber and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(730, new AxoMessengerTextItem("UserData has invalid size!",                                                                           "Check the real size of the `UserData`, so as the value of the UserDataSize parameter!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(731, new AxoMessengerTextItem("Error writing the 32bytes of the UserData!",                                                           "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(732, new AxoMessengerTextItem("Error writing the 64bytes of the UserData!",                                                           "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(733, new AxoMessengerTextItem("Error writing the 128bytes of the UserData!",                                                          "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(734, new AxoMessengerTextItem("Error writing the 250bytes of the UserData!",                                                          "Check the value of the hwIdUserData, the real size of the `UserData`, the value of the UserDataSize parameter and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(735, new AxoMessengerTextItem("Bank number out of range!",                                                                            "Check the value of the Bank number!")),

                //// Clear task
                //new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Clearing of the result data finished with error!",                             "Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Clearing of the result data was aborted, while not yet completed!",            "Check the details.")),
                //// Read Task
                //new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Reading finished with error!",                                                 "Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Reading was aborted, while not yet completed!",                                "Check the details.")),
                //// Continous reading
                //new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Continous reading finished with error!",                                       "Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Continous reading was aborted, while not yet completed!",                      "Check the details.")),
                // ClearResultDataTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(830, new AxoMessengerTextItem("ClearResultDataTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(831, new AxoMessengerTextItem("ClearResultDataTask was aborted, while not yet completed!","Check the details.")),
                //// TemplateTask_10steps_2
                //new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("TemplateTask_10steps_2 finished with error!","Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("TemplateTask_10steps_2 was aborted, while not yet completed!","Check the details.")),
                //// TemplateTask_10steps_3
                //new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("TemplateTask_10steps_3 finished with error!","Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("TemplateTask_10steps_3 was aborted, while not yet completed!","Check the details.")),
                //// TemplateTask_10steps_4
                //new KeyValuePair<ulong, AxoMessengerTextItem>(860, new AxoMessengerTextItem("TemplateTask_10steps_4 task finished with error!","Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(861, new AxoMessengerTextItem("TemplateTask_10steps_4 task was aborted, while not yet completed!","Check the details.")),
                //// TemplateTask_10steps_5
                //new KeyValuePair<ulong, AxoMessengerTextItem>(870, new AxoMessengerTextItem("TemplateTask_10steps_5 task finished with error!","Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(871, new AxoMessengerTextItem("TemplateTask_10steps_5 task was aborted, while not yet completed!","Check the details.")),
                // ReadTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(880, new AxoMessengerTextItem("ReadTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(881, new AxoMessengerTextItem("ReadTask was aborted, while not yet completed!","Check the details.")),
                // TuneTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(900, new AxoMessengerTextItem("TuneTask task finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(901, new AxoMessengerTextItem("TuneTask task was aborted, while not yet completed!","Check the details.")),
                //// TemplateTask_20steps_3
                //new KeyValuePair<ulong, AxoMessengerTextItem>(920, new AxoMessengerTextItem("TemplateTask_20steps_3 task finished with error!","Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(921, new AxoMessengerTextItem("TemplateTask_20steps_3 task was aborted, while not yet completed!","Check the details.")),
                //// TemplateTask_20steps_4
                //new KeyValuePair<ulong, AxoMessengerTextItem>(940, new AxoMessengerTextItem("TemplateTask_20steps_4 task finished with error!","Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(941, new AxoMessengerTextItem("TemplateTask_20steps_4 task was aborted, while not yet completed!","Check the details.")),
                //// TemplateTask_20steps_5
                //new KeyValuePair<ulong, AxoMessengerTextItem>(960, new AxoMessengerTextItem("TemplateTask_20steps_5 task finished with error!","Check the details.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(961, new AxoMessengerTextItem("TemplateTask_20steps_5 task was aborted, while not yet completed!","Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                //// Stop task
                //new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(505,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(506,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(507,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(508,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(509,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //// Move to home task
                //new KeyValuePair<ulong, AxoMessengerTextItem>(510,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(511,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Status.WorkSensor` to be reseted!","Check the status of the `Inputs.Status.WorkSensor`  signal.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Status.HomeSensor` to be set!","Check the status of the `Inputs.Status.HomeSensor`  signal.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(514,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(515,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(516,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(517,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(518,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(519,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //// Move to work task
                //new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Status.HomeSensor` to be reseted!","Check the status of the `Inputs.Status.HomeSensor`  signal.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signal `Inputs.Status.WorkSensor` to be set!","Check the status of the `Inputs.Status.WorkSensor`  signal.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(525,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(527,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(528,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(529,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //ClearResultDataTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                 "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.Error` to be reseted !",              "Check the status of the `HandshakeAndGeneralErrorStatus.Error` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(532,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !",                     "Check the status of the `CompletionStatus.ReadComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(533,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.PresetComplete` to be reseted !",                   "Check the status of the `CompletionStatus.PresetComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(534,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.RegisterPresetDataComplete` to be reseted !",       "Check the status of the `CompletionStatus.RegisterPresetDataComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(535,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !",                     "Check the status of the `CompletionStatus.TuneComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(536,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.EXT_RequestComplete` to be reseted !",              "Check the status of the `CompletionStatus.EXT_RequestComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(537,  new AxoMessengerTextItem("Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.GeneralError` to be reseted !",       "Check the status of the `HandshakeAndGeneralErrorStatus.GeneralError` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(538,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                 "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(539,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                 "Check the status of the `<insert name>` signal/variable.")),
                ////TemplateTask_10steps_2
                //new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(545,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(546,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(547,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(548,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(549,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                ////TemplateTask_10steps_3
                //new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(553,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(554,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(555,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(556,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(557,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(558,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(559,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                ////TemplateTask_10steps_4
                //new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(561,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(563,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(564,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(565,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(566,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(567,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(568,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(569,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                ////TemplateTask_10steps_5
                //new KeyValuePair<ulong, AxoMessengerTextItem>(570,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(571,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(572,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(573,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(574,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(575,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(576,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(577,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(578,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(579,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //ReadTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(580,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(581,  new AxoMessengerTextItem("Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.Error` to be reseted !",                      "Check the status of the `HandshakeAndGeneralErrorStatus.Error` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(582,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !",                             "Check the status of the `CompletionStatus.ReadComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(583,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.PresetComplete` to be reseted !",                           "Check the status of the `CompletionStatus.PresetComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(584,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.RegisterPresetDataComplete` to be reseted !",               "Check the status of the `CompletionStatus.RegisterPresetDataComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(585,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !",                             "Check the status of the `CompletionStatus.TuneComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(586,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.EXT_RequestComplete` to be reseted !",                      "Check the status of the `CompletionStatus.EXT_RequestComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(587,  new AxoMessengerTextItem("Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.GeneralError` to be reseted !",               "Check the status of the `HandshakeAndGeneralErrorStatus.GeneralError` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(588,  new AxoMessengerTextItem("Waiting for the signal/variable `ParameterBankNumber.BankNumberRegister` to be set to value from 0 to 10 !",  "Check the status of the `ParameterBankNumber.BankNumberRegister` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(589,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.ReadComplete` to be set !",                                 "Check the status of the `CompletionStatus.ReadComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(590,  new AxoMessengerTextItem("Waiting for the signal/variable `ReadData.ResultDataReadyCount` to be incremented !",                         "Check the status of the `ReadData.ResultDataReadyCount` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(591,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !",                             "Check the status of the `CompletionStatus.ReadComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(592,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(593,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(594,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(595,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(596,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(597,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(598,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(599,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                //TemplateTask_20steps_2
                new KeyValuePair<ulong, AxoMessengerTextItem>(600,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601,  new AxoMessengerTextItem("Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.Error` to be reseted !",                      "Check the status of the `HandshakeAndGeneralErrorStatus.Error` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.ReadComplete` to be reseted !",                             "Check the status of the `CompletionStatus.ReadComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.PresetComplete` to be reseted !",                           "Check the status of the `CompletionStatus.PresetComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.RegisterPresetDataComplete` to be reseted !",               "Check the status of the `CompletionStatus.RegisterPresetDataComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(605,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !",                             "Check the status of the `CompletionStatus.TuneComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(606,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.EXT_RequestComplete` to be reseted !",                      "Check the status of the `CompletionStatus.EXT_RequestComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(607,  new AxoMessengerTextItem("Waiting for the signal/variable `HandshakeAndGeneralErrorStatus.GeneralError` to be reseted !",               "Check the status of the `HandshakeAndGeneralErrorStatus.GeneralError` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(608,  new AxoMessengerTextItem("Waiting for the signal/variable `ParameterBankNumber.BankNumberRegister` to be set to value from 0 to 10 !",  "Check the status of the `ParameterBankNumber.BankNumberRegister` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(609,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.TuneComplete` to be set !",                                 "Check the status of the `CompletionStatus.TuneComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(610,  new AxoMessengerTextItem("Waiting for the signal/variable `CompletionStatus.TuneComplete` to be reseted !",                             "Check the status of the `CompletionStatus.TuneComplete` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(611,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(612,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(613,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(614,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(615,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(616,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(617,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(618,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(619,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !",                                         "Check the status of the `<insert name>` signal/variable.")),
                ////TemplateTask_20steps_3
                //new KeyValuePair<ulong, AxoMessengerTextItem>(620,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(621,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(622,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(623,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(624,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(625,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(626,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(627,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(628,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(629,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(630,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(631,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(632,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(633,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(634,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(635,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(636,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(637,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(638,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(639,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                ////TemplateTask_20steps_4
                //new KeyValuePair<ulong, AxoMessengerTextItem>(640,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(641,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(642,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(643,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(644,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(645,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(646,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(647,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(648,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(649,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(650,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(651,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(652,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(653,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(654,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(655,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(656,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(657,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(658,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(659,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                ////TemplateTask_20steps_5
                //new KeyValuePair<ulong, AxoMessengerTextItem>(660,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(661,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(662,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(663,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(664,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(665,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(666,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(667,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(668,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(669,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(670,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(671,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(672,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(673,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(674,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(675,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(676,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(677,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(678,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),
                //new KeyValuePair<ulong, AxoMessengerTextItem>(679,  new AxoMessengerTextItem("Waiting for the signal/variable `<insert name>` to be set/reseted !","Check the status of the `<insert name>` signal/variable.")),



        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
}
