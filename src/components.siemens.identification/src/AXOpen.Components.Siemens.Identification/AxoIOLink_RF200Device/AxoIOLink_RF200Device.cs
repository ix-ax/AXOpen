using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.SIEM.Identification
{
    public partial class AxoIOLink_RF200Device : AXOpen.Core.AxoComponent
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                                        "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Read started.",                                                                                    "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Read finished succesfully.",                                                                       "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Read restored.",                                                                                   "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Write started.",                                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Write finished succesfully.",                                                                      "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Write restored.",                                                                                  "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("Soft reset started.",                                                                              "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("Soft reset finished succesfully.",                                                                 "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("Soft reset restored.",                                                                             "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("Reset reader started.",                                                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("Reset reader finished succesfully.",                                                               "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("Reset reader restored.",                                                                           "")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                      "Check the call of the `Run` method, if the `parent` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Read finished with error!",                                                                        "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Read was aborted, while not yet completed!",                                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Write finished with error!",                                                                       "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Write was aborted, while not yet completed!",                                                      "Check the details.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0001, new AxoMessengerTextItem("Input variable 'identData' has NULL reference in 'AxoIOLink_RF200_ReadTag.Run()' method!",  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0002, new AxoMessengerTextItem("Input variable 'identData' has NULL reference in 'AxoIOLink_RF200_WriteTag.Run()' method!", "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(0x00018101,new AxoMessengerTextItem("The transponder has left the field before the read/write process finished.","Restart the process")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0x00018102,new AxoMessengerTextItem("The previous job is not yet complete. The operation will be terminated as soon as possible.","Restart the process")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0x00018103,new AxoMessengerTextItem("No transponder was recognized in the reader's field within the specified time period.","Restart the process")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0x00018104,new AxoMessengerTextItem("The specified length is shorter than 4 (IO-Link V1.0) or 28 (IO-Link V1.1).","Specify a length longer than 4 bytes (IO-Link V1.0) or 28 bytes (IO-Link V1.1).")),
                

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(500,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be reseted!",                                                                              "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(501,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be set!",                                                                                  "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be reseted!",                                                                              "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Done` to be set!",                                                                                  "Check the status of the `_identProfile_Done` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(504,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Done` to be reseted!",                                                                              "Check the status of the `_identProfile_Done` variable.")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(520,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be reseted!",                                                                              "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(521,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be set!",                                                                                  "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(522,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be reseted!",                                                                              "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(523,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Done` to be set!",                                                                                  "Check the status of the `_identProfile_Done` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(524,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Done` to be reseted!",                                                                              "Check the status of the `_identProfile_Done` variable.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(540,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be reseted!",                                                                              "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(541,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be set!",                                                                                  "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(542,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be reseted!",                                                                              "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(543,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Done` to be set!",                                                                                  "Check the status of the `_identProfile_Done` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(544,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Done` to be reseted!",                                                                              "Check the status of the `_identProfile_Done` variable.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(550,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be reseted!",                                                                              "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(551,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be set!",                                                                                  "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(552,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Busy` to be reseted!",                                                                              "Check the status of the `_identProfile_Busy` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(553,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Done` to be set!",                                                                                  "Check the status of the `_identProfile_Done` variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(554,  new AxoMessengerTextItem("Waiting for the variable `_identProfile_Done` to be reseted!",                                                                              "Check the status of the `_identProfile_Done` variable.")),

        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }

 
    }
}
