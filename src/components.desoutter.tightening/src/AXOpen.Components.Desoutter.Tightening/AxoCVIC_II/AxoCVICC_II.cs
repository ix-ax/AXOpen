using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Numerics;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Components.Desoutter.Tightening
{
    public partial class AxoCVIC_II : AXOpen.Core.AxoComponent
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Reset started.",                                                               "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Reset finished succesfully.",                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Reset restored.",                                                              "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("Set screwing program started.",                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("Set screwing program finished succesfully.",                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("Set screwing program restored.",                                               "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Screwing started.",                                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Screwing finished succesfully.",                                               "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Screwing restored.",                                                           "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in the`Run` method!",                               "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwId_Input_1_byte_1` has invalid value in the `Run` method!",                  "Check the call of the `Run` method, if the `hwId_Input_1_byte_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Input variable `hwId_Input_1_byte_2` has invalid value in the `Run` method!",                  "Check the call of the `Run` method, if the `hwId_Input_1_byte_2` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Input variable `hwId_Input_2_word_1` has invalid value in the `Run` method!",                  "Check the call of the `Run` method, if the `hwId_Input_2_word_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Input variable `hwId_Input_1_word_1` has invalid value in the `Run` method!",                  "Check the call of the `Run` method, if the `hwId_Input_1_word_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Input variable `hwId_Input_2_word_2` has invalid value in the `Run` method!",                  "Check the call of the `Run` method, if the `hwId_Input_2_word_2` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Input variable `hwId_Input_1_word_2` has invalid value in the `Run` method!",                  "Check the call of the `Run` method, if the `hwId_Input_1_word_2` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("Input variable `hwId_Output_1_byte_1` has invalid value in the `Run` method!",                 "Check the call of the `Run` method, if the `hwId_Output_1_byte_1` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("Input variable `hwId_Output_1_byte_2` has invalid value in the `Run` method!",                 "Check the call of the `Run` method, if the `hwId_Output_1_byte_2` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("Error reading the hwId_Input_1_byte_1 in the Execute method!",                                 "Check the value of the hwId_Input_1_byte_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("Error reading the hwId_Input_1_byte_2 in the Execute method!",                                 "Check the value of the hwId_Input_1_byte_2 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("Error reading the hwId_Input_2_word_1 in the Execute method!",                                 "Check the value of the hwId_Input_2_word_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("Error reading the hwId_Input_1_word_1 in the Execute method!",                                 "Check the value of the hwId_Input_1_word_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("Error reading the hwId_Input_2_word_2 in the Execute method!",                                 "Check the value of the hwId_Input_2_word_2 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("Error reading the hwId_Input_1_word_2 in the Execute method!",                                 "Check the value of the hwId_Input_1_word_2 and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("Error writing the hwId_Output_1_byte_1 in the Execute method!",                                "Check the value of the hwId_Output_1_byte_1 and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("Error writing the hwId_Output_1_byte_2 in the Execute method!",                                "Check the value of the hwId_Output_1_byte_2 and reacheability of the device!")),



                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("Value of the required screwing program is lower then the minimal value!",                       "Check the value of the required screwing program.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(718, new AxoMessengerTextItem("Value of the required screwing program is higher then the maximal value!",                      "Check the value of the required screwing program.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Reseting the device results finished with error!",                                             "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Reseting the device results was aborted, while not yet completed!",                            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(810, new AxoMessengerTextItem("Changing of the screwing program finished with error!",                                        "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(811, new AxoMessengerTextItem("Changing of the screwing program was aborted, while not yet completed!",                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Screwing finished with error!",                                                                "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Screwing was aborted, while not yet completed!",                                               "Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(600, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(601, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(602, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(603, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(604, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(605, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(606, new AxoMessengerTextItem("   ", "   ")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
    public partial class AxoCVIC_II_ComponentStatus : AxoComponent_Status
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
                    errorDescriptionDict.Add(600, "Waiting for the signal Inputs.Status.Failed to be reseted!");
                    errorDescriptionDict.Add(601, "Waiting for the signal Inputs.Status.InCycle to be reseted!");
                    errorDescriptionDict.Add(602, "Waiting for the signal `Inputs.Status.Ready` to be set!");

                    errorDescriptionDict.Add(610, "Waiting for the value of the `Inputs.ScrewingProgram` to be the same as the value of `Outputs.ScrewingProgram`!");

                    errorDescriptionDict.Add(622, "Waiting for the value of the `Inputs.ScrewingProgram` to be the same as the value of `Outputs.ScrewingProgram`!");
                    errorDescriptionDict.Add(623, "Waiting for the signal Inputs.Status.InCycle to be reseted!");
                    errorDescriptionDict.Add(624, "Waiting for the signal `Inputs.Status.Ready` to be set!");
                    errorDescriptionDict.Add(625, "Waiting for the signal `Inputs.Status.InCycle` to be set!");
                    errorDescriptionDict.Add(626, "Waiting for the signal `Inputs.Status.InCycle` to be reseted!");
                    errorDescriptionDict.Add(627, "Waiting for the the result bits: One of the signals 'Inputs.Status.Failed' or 'Inputs.Status.Passed' has to be set!");
                    

                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in the`Run` method!");
                    errorDescriptionDict.Add(701, "Input variable `hwId_Input_1_byte_1` has invalid value in the `Run` method!");
                    errorDescriptionDict.Add(702, "Input variable `hwId_Input_1_byte_2` has invalid value in the `Run` method!");
                    errorDescriptionDict.Add(703, "Input variable `hwId_Input_2_word_1` has invalid value in the `Run` method!");
                    errorDescriptionDict.Add(704, "Input variable `hwId_Input_1_word_1` has invalid value in the `Run` method!");
                    errorDescriptionDict.Add(705, "Input variable `hwId_Input_2_word_2` has invalid value in the `Run` method!");
                    errorDescriptionDict.Add(706, "Input variable `hwId_Input_1_word_2` has invalid value in the `Run` method!");
                    errorDescriptionDict.Add(707, "Input variable `hwId_Output_1_byte_1` has invalid value in the `Run` method!");
                    errorDescriptionDict.Add(708, "Input variable `hwId_Output_1_byte_2` has invalid value in the `Run` method!");
                    errorDescriptionDict.Add(709, "Error reading the hwId_Input_1_byte_1 in the Execute method!");
                    errorDescriptionDict.Add(710, "Error reading the hwId_Input_1_byte_2 in the Execute method!");
                    errorDescriptionDict.Add(711, "Error reading the hwId_Input_2_word_1 in the Execute method!");
                    errorDescriptionDict.Add(712, "Error reading the hwId_Input_1_word_1 in the Execute method!");
                    errorDescriptionDict.Add(713, "Error reading the hwId_Input_2_word_2 in the Execute method!");
                    errorDescriptionDict.Add(714, "Error reading the hwId_Input_1_word_2 in the Execute method!");
                    errorDescriptionDict.Add(715, "Error writing the hwId_Output_1_byte_1 in the Execute method!");
                    errorDescriptionDict.Add(716, "Error writing the hwId_Output_1_byte_2 in the Execute method!");
                    errorDescriptionDict.Add(717, "Value of the required screwing program is lower then the minimal value!");
                    errorDescriptionDict.Add(718, "Value of the required screwing program is higher then the maximal value!");
                    errorDescriptionDict.Add(800, "Reseting the device results finished with error!");
                    errorDescriptionDict.Add(801, "Reseting the device results was aborted, while not yet completed!");
                    errorDescriptionDict.Add(810, "Changing of the screwing program finished with error!");
                    errorDescriptionDict.Add(811, "Changing of the screwing program was aborted, while not yet completed!");
                    errorDescriptionDict.Add(820, "Screwing finished with error!");
                    errorDescriptionDict.Add(821, "Screwing was aborted, while not yet completed!");

                }
                string errorDescription = "   ";

                if (Error == null || Error.Id == null )
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

                    actionDescriptionDict.Add(100, "Reset started.");
                    actionDescriptionDict.Add(300, "Reset running.");
                    actionDescriptionDict.Add(301, "Reset running.");
                    actionDescriptionDict.Add(302, "Reset running.");
                    actionDescriptionDict.Add(303, "Reset running.");
                    actionDescriptionDict.Add(304, "Reset running.");
                    actionDescriptionDict.Add(305, "Reset running.");
                    actionDescriptionDict.Add(306, "Reset running.");
                    actionDescriptionDict.Add(307, "Reset running.");
                    actionDescriptionDict.Add(308, "Reset running.");
                    actionDescriptionDict.Add(309, "Reset running.");
                    actionDescriptionDict.Add(101, "Reset finished succesfully.");
                    actionDescriptionDict.Add(102, "Reset restored.");

                    actionDescriptionDict.Add(110, "Set screwing program started.");
                    actionDescriptionDict.Add(310, "Set screwing program running.");
                    actionDescriptionDict.Add(311, "Set screwing program running.");
                    actionDescriptionDict.Add(312, "Set screwing program running.");
                    actionDescriptionDict.Add(313, "Set screwing program running.");
                    actionDescriptionDict.Add(314, "Set screwing program running.");
                    actionDescriptionDict.Add(315, "Set screwing program running.");
                    actionDescriptionDict.Add(316, "Set screwing program running.");
                    actionDescriptionDict.Add(317, "Set screwing program running.");
                    actionDescriptionDict.Add(318, "Set screwing program running.");
                    actionDescriptionDict.Add(319, "Set screwing program running.");
                    actionDescriptionDict.Add(110, "Set screwing program started.");
                    actionDescriptionDict.Add(111, "Set screwing program finished succesfully.");
                    actionDescriptionDict.Add(112, "Set screwing program restored.");

                    actionDescriptionDict.Add(120, "Screwing started.");
                    actionDescriptionDict.Add(320, "Screwing running.");
                    actionDescriptionDict.Add(321, "Screwing running.");
                    actionDescriptionDict.Add(322, "Screwing running.");
                    actionDescriptionDict.Add(323, "Screwing running.");
                    actionDescriptionDict.Add(324, "Screwing running.");
                    actionDescriptionDict.Add(325, "Screwing running.");
                    actionDescriptionDict.Add(326, "Screwing running.");
                    actionDescriptionDict.Add(327, "Screwing running.");
                    actionDescriptionDict.Add(328, "Screwing running.");
                    actionDescriptionDict.Add(329, "Screwing running.");
                    actionDescriptionDict.Add(330, "Screwing running.");
                    actionDescriptionDict.Add(331, "Screwing running.");
                    actionDescriptionDict.Add(332, "Screwing running.");
                    actionDescriptionDict.Add(333, "Screwing running.");
                    actionDescriptionDict.Add(334, "Screwing running.");
                    actionDescriptionDict.Add(335, "Screwing running.");
                    actionDescriptionDict.Add(336, "Screwing running.");
                    actionDescriptionDict.Add(337, "Screwing running.");
                    actionDescriptionDict.Add(338, "Screwing running.");
                    actionDescriptionDict.Add(339, "Screwing running.");
                    actionDescriptionDict.Add(121, "Screwing finished succesfully.");
                    actionDescriptionDict.Add(122, "Screwing restored.");

                    actionDescriptionDict.Add(800, "Reseting the device finished with error!");
                    actionDescriptionDict.Add(801, "Reseting the device was aborted, while not yet completed!");
                    actionDescriptionDict.Add(810, "Changing of the screwing program finished with error!");
                    actionDescriptionDict.Add(811, "Changing of the screwing program was aborted, while not yet completed!");
                    actionDescriptionDict.Add(820, "Screwing finished with error!");
                    actionDescriptionDict.Add(821, "Screwing  was aborted, while not yet completed!");


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

