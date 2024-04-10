using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.SIEM.Identification
{
    public partial class Axo_IdentDevice : AXOpen.Core.AxoComponent
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            try
            {
                InitializeMessenger();
                InitializeTaskMessenger();
                InitializeIdentProfileMessenger();
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

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Read started.",                                                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Read finished succesfully.",                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Read restored.",                                                                               "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Write started.",                                                                               "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Write finished succesfully.",                                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Write restored.",                                                                              "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("Soft reset started.",                                                                          "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("Soft reset finished succesfully.",                                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("Soft reset restored.",                                                                         "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("Reset reader started.",                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("Reset reader finished succesfully.",                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("Reset reader restored.",                                                                       "")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                  "Check the call of the `Run` method, if the `parent` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Read finished with error!",                                                                    "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Read was aborted, while not yet completed!",                                                   "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Write finished with error!",                                                                   "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Write was aborted, while not yet completed!",                                                  "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Soft reset finished with error!",                                                              "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Soft reset was aborted, while not yet completed!",                                             "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("Reset reader finished with error!",                                                            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("Reset reader was aborted, while not yet completed!",                                           "Check the details.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0001, new AxoMessengerTextItem("Input variable 'refHwConnect' has NULL reference!",                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0002, new AxoMessengerTextItem("Input variable 'refTx' has NULL reference!",                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0003, new AxoMessengerTextItem("Input variable 'refRx' has NULL reference!",                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0004, new AxoMessengerTextItem("Input variable 'refCmd' has NULL reference!",                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0005, new AxoMessengerTextItem("Error reading input data from HW_ID!",                                                  "Check the value of the HW_ID and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0006, new AxoMessengerTextItem("Error writing output data to HW_ID!",                                                   "Check the value of the HW_ID and reacheability of the device!")),



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

        private void InitializeIdentProfileMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,   new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.",                                                                    "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("Read started.",                                                                                "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("Read finished succesfully.",                                                                   "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("Read restored.",                                                                               "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(120, new AxoMessengerTextItem("Write started.",                                                                               "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(121, new AxoMessengerTextItem("Write finished succesfully.",                                                                  "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(122, new AxoMessengerTextItem("Write restored.",                                                                              "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(140, new AxoMessengerTextItem("Soft reset started.",                                                                          "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(141, new AxoMessengerTextItem("Soft reset finished succesfully.",                                                             "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(142, new AxoMessengerTextItem("Soft reset restored.",                                                                         "")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(150, new AxoMessengerTextItem("Reset reader started.",                                                                        "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(151, new AxoMessengerTextItem("Reset reader finished succesfully.",                                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(152, new AxoMessengerTextItem("Reset reader restored.",                                                                       "")),


                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                  "Check the call of the `Run` method, if the `parent` parameter is assigned.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(800, new AxoMessengerTextItem("Read finished with error!",                                                                    "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(801, new AxoMessengerTextItem("Read was aborted, while not yet completed!",                                                   "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(820, new AxoMessengerTextItem("Write finished with error!",                                                                   "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(821, new AxoMessengerTextItem("Write was aborted, while not yet completed!",                                                  "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(840, new AxoMessengerTextItem("Soft reset finished with error!",                                                              "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(841, new AxoMessengerTextItem("Soft reset was aborted, while not yet completed!",                                             "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(850, new AxoMessengerTextItem("Reset reader finished with error!",                                                            "Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(851, new AxoMessengerTextItem("Reset reader was aborted, while not yet completed!",                                           "Check the details.")),

                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0001, new AxoMessengerTextItem("Input variable 'refHwConnect' has NULL reference!",                                     "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0002, new AxoMessengerTextItem("Input variable 'refTx' has NULL reference!",                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0003, new AxoMessengerTextItem("Input variable 'refRx' has NULL reference!",                                            "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0004, new AxoMessengerTextItem("Input variable 'refCmd' has NULL reference!",                                           "")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0005, new AxoMessengerTextItem("Error reading input data from HW_ID!",                                                  "Check the value of the HW_ID and reacheability of the device!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(0xFEFE0006, new AxoMessengerTextItem("Error writing output data to HW_ID!",                                                   "Check the value of the HW_ID and reacheability of the device!")),

                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0100,new AxoMessengerTextItem("Memory of the transponder cannot be written to","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0200,new AxoMessengerTextItem("Presence error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0300,new AxoMessengerTextItem("Address error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0400,new AxoMessengerTextItem("Initialization error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0500,new AxoMessengerTextItem("The transponder memory is full.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0600,new AxoMessengerTextItem("Error in transponder memory","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0700,new AxoMessengerTextItem("Password error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0800,new AxoMessengerTextItem("The transponder in the antenna field does not have the expected UID / EPC ID or has no UID / EPC","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0900,new AxoMessengerTextItem("The command is not supported by the transponder.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0A00,new AxoMessengerTextItem("The transponder is read/write-protected.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE8100,new AxoMessengerTextItem("The transponder is not responding.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE8200,new AxoMessengerTextItem("The transponder password is incorrect. Access is denied.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE8300,new AxoMessengerTextItem("The verification of the written transponder data has failed.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE8400,new AxoMessengerTextItem("General transponder error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE8500,new AxoMessengerTextItem("The transponder has too little power to execute the command.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE0100,new AxoMessengerTextItem("Field disturbance on reader","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE0200,new AxoMessengerTextItem("More transponders are located in the transmission window than can be processed at the same","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE8100,new AxoMessengerTextItem("There is no transponder with the required EPC ID/UID in the transmission window or there is no transponder","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE8200,new AxoMessengerTextItem("The requested data is not available.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE8300,new AxoMessengerTextItem("CRC error in reader-transponder communication.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE8400,new AxoMessengerTextItem("The selected antenna is not enabled.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE8500,new AxoMessengerTextItem("The selected frequency is not enabled.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE8600,new AxoMessengerTextItem("The carrier signal is not activated.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE8700,new AxoMessengerTextItem("There is more than one transponder in the transmission window.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE2FE8800,new AxoMessengerTextItem("General radio protocol error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE0100,new AxoMessengerTextItem("Short circuit or overload of the 24 V outputs","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE0300,new AxoMessengerTextItem("Error in the connection to the reader; the reader is not answering.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE0400,new AxoMessengerTextItem("The buffer on the communications module or reader is not adequate to store the command temporarily.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE0500,new AxoMessengerTextItem("The buffer on the communications module or reader is not adequate to store the data temporarily.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE0600,new AxoMessengerTextItem("The command is not permitted in this status or is not supported.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE8100,new AxoMessengerTextItem("The specified tag field of the transponder is unknown.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE8A00,new AxoMessengerTextItem("General error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE8B00,new AxoMessengerTextItem("No or bad configuration data/parameters were transferred.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE8C00,new AxoMessengerTextItem("Communication error between Ident profile and communications module. Handshake error.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE8D00,new AxoMessengerTextItem("Communication error of the communications module/reader","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE8E00,new AxoMessengerTextItem("The current command was aborted by the 'WRITE-CONFIG' ('INIT' or 'RESET') command or the bus","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0100,new AxoMessengerTextItem("Incorrect sequence number order (SN) on the reader/communications module","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0200,new AxoMessengerTextItem("Incorrect sequence number order (SN) in the Ident profile","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0400,new AxoMessengerTextItem("Invalid data block number (DBN) on the reader/communications module","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0500,new AxoMessengerTextItem("Invalid data block number (DBN) in the Ident profile","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0600,new AxoMessengerTextItem("Invalid data block length (DBL) on the reader/communications module","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0700,new AxoMessengerTextItem("Invalid data block length (DBL) in the Ident profile","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0800,new AxoMessengerTextItem("The previous command is still active or the buffer is full.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0900,new AxoMessengerTextItem("The reader or communication module executes a hardware reset ('INIT_ACTIVE' set to '1'). 'INIT' is","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0A00,new AxoMessengerTextItem("The 'CMD' command code and the relevant acknowledgment do not match. This can be a software","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0B00,new AxoMessengerTextItem("Incorrect sequence of acknowledgement frames (TDB / DBN)","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE0C00,new AxoMessengerTextItem("Synchronization error (incorrect increment of 'AC_H / AC_L' and 'CC_H / CC_L' in the cyclic control","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE8100,new AxoMessengerTextItem("Communications error between reader and communications module","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE8200,new AxoMessengerTextItem("Communications error between reader and communications module","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE8300,new AxoMessengerTextItem("Communications error between reader and communications module","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE5FE8400,new AxoMessengerTextItem("Communications error between reader and communications module","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE0100,new AxoMessengerTextItem("Unknown command","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE0200,new AxoMessengerTextItem("Invalid command index (CI)","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE0300,new AxoMessengerTextItem("The communication module or reader was configured incorrectly.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE0400,new AxoMessengerTextItem("Presence error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE0500,new AxoMessengerTextItem("An error has occurred that makes a Reset_Reader ('WRITE-CONFIG') necessary.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8100,new AxoMessengerTextItem("A parameter is missing.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8200,new AxoMessengerTextItem("The parameter has an invalid format.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8300,new AxoMessengerTextItem("The parameter type is invalid.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8400,new AxoMessengerTextItem("Unknown parameter","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8500,new AxoMessengerTextItem("The command or the frame has an invalid format.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8600,new AxoMessengerTextItem("The 'Inventory' command failed.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8700,new AxoMessengerTextItem("Read access to the transponder has failed.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8800,new AxoMessengerTextItem("Write access to the transponder has failed.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8900,new AxoMessengerTextItem("Writing the EPC ID/UID on the transponder has failed.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8A00,new AxoMessengerTextItem("Enabling write protection on the transponder has failed.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE8B00,new AxoMessengerTextItem("The 'Kill' command failed.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0100,new AxoMessengerTextItem("In this state, only the 'Reset_Reader' command ('WRITE-CONFIG' with 'CMDSEL =1' and 'CMD =","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0200,new AxoMessengerTextItem("The command code 'CMD' or the value in 'CMDSEL' is not permitted.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0300,new AxoMessengerTextItem("The value of the 'LEN_DATA' parameter of the command is too long and does not match the global","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0400,new AxoMessengerTextItem("The receive data buffer (RXBUF) or the send data buffer (TXBUF) is too small, the buffer created at","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0500,new AxoMessengerTextItem("Only an 'INIT' command is permitted as the next command. All other commands are rejected.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0600,new AxoMessengerTextItem("Wrong data record index of an acyclic data record","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0700,new AxoMessengerTextItem("The reader or communication module does not respond to 'INIT' ('INIT_ACTIVE' is expected in the","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0800,new AxoMessengerTextItem("Timeout during 'INIT' (60 seconds)","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0900,new AxoMessengerTextItem("Command repetition is not supported.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0A00,new AxoMessengerTextItem("Error during the transfer of the PDU (Protocol Data Unit).","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 new KeyValuePair<ulong, AxoMessengerTextItem>(0xE7FE0B00,new AxoMessengerTextItem("The 'CMDREF' parameter was set incorrectly. Check the parameter.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),

                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0200,new AxoMessengerTextItem("The connection from the internal interface to the image sensor is disrupted.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0400,new AxoMessengerTextItem("Transmission error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0600,new AxoMessengerTextItem("Program cannot be started because there is not enough memory or the program is damaged.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0700,new AxoMessengerTextItem("Comparison error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE0400,new AxoMessengerTextItem("Internal file error","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE0600,new AxoMessengerTextItem("Lamp overload","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE4FE8400,new AxoMessengerTextItem("Error in last command sequence.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE0400,new AxoMessengerTextItem("The program could not be created or saved.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE1FE0300,new AxoMessengerTextItem("Bad parameter in MV command","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE0100,new AxoMessengerTextItem("Command not permitted or the command was aborted.","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),
                 //new KeyValuePair<ulong, AxoMessengerTextItem>(0xE6FE0300,new AxoMessengerTextItem("Initialization with program selection ('INIT'/'WRITE-CONFIG') is not possible. Possible causes:","For detail check the manufacturer manual 'RFID systems Ident profile and Ident blocks, standard function for Ident systems',Document ID number: C79000-G8976-C387-06")),



        };

            IdentProfileMessenger.DotNetMessengerTextList = messengerTextList;
        }

    }
}
