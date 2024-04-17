using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace AXOpen.Components.Balluff.Identification
{
    public partial class Axo_BIS_M_4XX_045 : AXOpen.Core.AxoComponent
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,   new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Read at main started.",                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Read at main finished succesfully.",                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Read at main restored.",                                                                       "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Write started.",                                                                               "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Write finished succesfully.",                                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Write restored.",                                                                              "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("Reset communication started.",                                                                 "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("Reset communication finished succesfully.",                                                    "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("Reset communication restored.",                                                                "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("Reset reader started.",                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("Reset reader finished succesfully.",                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("Reset reader restored.",                                                                       "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(160, new AxoMessengerTextItem("Write char to memory started.",                                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(161, new AxoMessengerTextItem("Write char to memory finished succesfully.",                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(162, new AxoMessengerTextItem("Write char to memory restored.",                                                               "")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                  "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Input variable `hwId_BISM` has invalid value in `Run` method!",                                "Check the call of the `Run` method, if the `hwId_BISM` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Error reading the hwId_BISM in the UpdateInputs method!",                                      "Check the value of the hwId_BISM and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Error writing the hwId_BISM in the UpdateOutputs method!",                                     "Check the value of the hwId_BISM and reacheability of the device!")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Read finished with error!",                                                                    "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Read was aborted, while not yet completed!",                                                   "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Write finished with error!",                                                                   "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Write was aborted, while not yet completed!",                                                  "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Reset communication finished with error!",                                                     "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Reset communication was aborted, while not yet completed!",                                    "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("Reset reader finished with error!",                                                            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("Reset reader was aborted, while not yet completed!",                                           "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(860, new AxoMessengerTextItem("Write char to memory finished with error!",                                                    "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(861, new AxoMessengerTextItem("Write char to memory was aborted, while not yet completed!",                                   "Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_CodeTagPresent to be set!",                                                                      "Check the status of the `Inputs.BitHeader1_CodeTagPresent` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobAccepted to be reseted!",                                                                     "Check the status of the `Inputs.BitHeader1_JobAccepted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobEnd to be reseted!",                                                                          "Check the status of the `Inputs.BitHeader1_JobEnd` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_ToggleBit to be reseted!",                                                                       "Check the status of the `Inputs.BitHeader1_ToggleBit` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobEnd to be set!",                                                                              "Check the status of the `Inputs.BitHeader1_JobEnd` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(505,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobAccepted to be set!",                                                                         "Check the status of the `Inputs.BitHeader1_JobAccepted` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_CodeTagPresent to be set!",                                                                      "Check the status of the `Inputs.BitHeader1_CodeTagPresent` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobAccepted to be reseted!",                                                                     "Check the status of the `Inputs.BitHeader1_JobAccepted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobEnd to be reseted!",                                                                          "Check the status of the `Inputs.BitHeader1_JobEnd` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_ToggleBit to be reseted!",                                                                       "Check the status of the `Inputs.BitHeader1_ToggleBit` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(526,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobAccepted to be set!",                                                                         "Check the status of the `Inputs.BitHeader1_JobAccepted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(529,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobEnd to be set!",                                                                              "Check the status of the `Inputs.BitHeader1_JobEnd` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(530,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobAccepted to be reseted!",                                                                     "Check the status of the `Inputs.BitHeader1_JobAccepted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(531,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobError to be reseted!",                                                                        "Check the status of the `Inputs.BitHeader1_JobError` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_Power to be reseted!",                                                                           "Check the status of the `Inputs.BitHeader1_Power` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_Power to be set!",                                                                               "Check the status of the `Inputs.BitHeader1_Power` signal.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(560,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_CodeTagPresent to be set!",                                                                      "Check the status of the `Inputs.BitHeader1_CodeTagPresent` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(562,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobAccepted to be set!",                                                                         "Check the status of the `Inputs.BitHeader1_JobAccepted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(567,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobAccepted to be reseted!",                                                                     "Check the status of the `Inputs.BitHeader1_JobAccepted` signal.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(568,  new AxoMessengerTextItem("Waiting for the signal Inputs.BitHeader1_JobError to be reseted!",                                                                        "Check the status of the `Inputs.BitHeader1_JobError` signal.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
}
