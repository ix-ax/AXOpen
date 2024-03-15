using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.SIEM.Identification
{
    public partial class Axo_IdentDevice_Component_Status : AXOpen.Components.Abstractions.AxoComponent_Status
    {
        Dictionary<ulong, string> errorDescriptionDict = new Dictionary<ulong, string>();
        Dictionary<ulong, string> actionDescriptionDict = new Dictionary<ulong, string>();
        Dictionary<ulong, string> identProfile_StatusDict = new Dictionary<ulong, string>();

        public string ErrorDescription
        {
            get
            {
                if (errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<ulong, string>(); }
                if (errorDescriptionDict.Count == 0)
                {
                    errorDescriptionDict.Add(0, "   ");
                    errorDescriptionDict.Add(500, "Waiting for the variable `_identProfile_Busy` to be reseted!");
                    errorDescriptionDict.Add(501, "Waiting for the variable `_identProfile_Busy` to be set!");
                    errorDescriptionDict.Add(502, "Waiting for the variable `_identProfile_Busy` to be reseted!");
                    errorDescriptionDict.Add(503, "Waiting for the variable `_identProfile_Done` to be set!");
                    errorDescriptionDict.Add(504, "Waiting for the variable `_identProfile_Done` to be reseted!");
                    errorDescriptionDict.Add(520, "Waiting for the variable `_identProfile_Busy` to be reseted!");
                    errorDescriptionDict.Add(521, "Waiting for the variable `_identProfile_Busy` to be set!");
                    errorDescriptionDict.Add(522, "Waiting for the variable `_identProfile_Busy` to be reseted!");
                    errorDescriptionDict.Add(523, "Waiting for the variable `_identProfile_Done` to be set!");
                    errorDescriptionDict.Add(524, "Waiting for the variable `_identProfile_Done` to be reseted!");
                    errorDescriptionDict.Add(540, "Waiting for the variable `_identProfile_Busy` to be reseted!");
                    errorDescriptionDict.Add(541, "Waiting for the variable `_identProfile_Busy` to be set!");
                    errorDescriptionDict.Add(542, "Waiting for the variable `_identProfile_Busy` to be reseted!");
                    errorDescriptionDict.Add(543, "Waiting for the variable `_identProfile_Done` to be set!");
                    errorDescriptionDict.Add(544, "Waiting for the variable `_identProfile_Done` to be reseted!");
                    errorDescriptionDict.Add(550, "Waiting for the variable `_identProfile_Busy` to be reseted!");
                    errorDescriptionDict.Add(551, "Waiting for the variable `_identProfile_Busy` to be set!");
                    errorDescriptionDict.Add(552, "Waiting for the variable `_identProfile_Busy` to be reseted!");
                    errorDescriptionDict.Add(553, "Waiting for the variable `_identProfile_Done` to be set!");
                    errorDescriptionDict.Add(554, "Waiting for the variable `_identProfile_Done` to be reseted!");



                    errorDescriptionDict.Add(700, "Input variable `parent` has NULL reference in `Run` method!");

                    errorDescriptionDict.Add(800, "Read finished with error!");
                    errorDescriptionDict.Add(801, "Read was aborted, while not yet completed!");
                    errorDescriptionDict.Add(820, "Write finished with error!");
                    errorDescriptionDict.Add(821, "Write was aborted, while not yet completed!");
                    errorDescriptionDict.Add(840, "Soft reset finished with error!");
                    errorDescriptionDict.Add(841, "Soft reset was aborted, while not yet completed!");
                    errorDescriptionDict.Add(850, "Reset reader finished with error!");
                    errorDescriptionDict.Add(851, "Reset reader was aborted, while not yet completed!");

                    errorDescriptionDict.Add(0xFEFE0001, "Input variable 'refHwConnect' has NULL reference!");      
                    errorDescriptionDict.Add(0xFEFE0002, "Input variable 'refTx' has NULL reference!");             
                    errorDescriptionDict.Add(0xFEFE0003, "Input variable 'refRx' has NULL reference!");             
                    errorDescriptionDict.Add(0xFEFE0004, "Input variable 'refCmd' has NULL reference!");            
                    errorDescriptionDict.Add(0xFEFE0005, "Error reading input data from HW_ID!");                   
                    errorDescriptionDict.Add(0xFEFE0006, "Error writing output data to HW_ID!");


                }
                string errorDescription = "   ";

                if (Error == null || Error.Id == null)
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

                    actionDescriptionDict.Add(100, "Read started.");
                    actionDescriptionDict.Add(300, "Read running.");
                    actionDescriptionDict.Add(301, "Read running.");
                    actionDescriptionDict.Add(302, "Read running.");
                    actionDescriptionDict.Add(303, "Read running.");
                    actionDescriptionDict.Add(304, "Read running.");
                    actionDescriptionDict.Add(305, "Read running.");
                    actionDescriptionDict.Add(306, "Read running.");
                    actionDescriptionDict.Add(307, "Read running.");
                    actionDescriptionDict.Add(308, "Read running.");
                    actionDescriptionDict.Add(309, "Read running.");
                    actionDescriptionDict.Add(101, "Read finished succesfully.");
                    actionDescriptionDict.Add(102, "Read restored.");

                    actionDescriptionDict.Add(120, "Write started.");
                    actionDescriptionDict.Add(320, "Write running.");
                    actionDescriptionDict.Add(321, "Write running.");
                    actionDescriptionDict.Add(322, "Write running.");
                    actionDescriptionDict.Add(323, "Write running.");
                    actionDescriptionDict.Add(324, "Write running.");
                    actionDescriptionDict.Add(325, "Write running.");
                    actionDescriptionDict.Add(326, "Write running.");
                    actionDescriptionDict.Add(327, "Write running.");
                    actionDescriptionDict.Add(328, "Write running.");
                    actionDescriptionDict.Add(329, "Write running.");
                    actionDescriptionDict.Add(121, "Write finished succesfully.");
                    actionDescriptionDict.Add(122, "Write restored.");

                    actionDescriptionDict.Add(140, "Soft reset started.");
                    actionDescriptionDict.Add(340, "Soft reset running.");
                    actionDescriptionDict.Add(341, "Soft reset running.");
                    actionDescriptionDict.Add(342, "Soft reset running.");
                    actionDescriptionDict.Add(343, "Soft reset running.");
                    actionDescriptionDict.Add(344, "Soft reset running.");
                    actionDescriptionDict.Add(345, "Soft reset running.");
                    actionDescriptionDict.Add(346, "Soft reset running.");
                    actionDescriptionDict.Add(347, "Soft reset running.");
                    actionDescriptionDict.Add(348, "Soft reset running.");
                    actionDescriptionDict.Add(349, "Soft reset running.");
                    actionDescriptionDict.Add(141, "Soft reset finished succesfully.");
                    actionDescriptionDict.Add(142, "Soft reset restored.");

                    actionDescriptionDict.Add(150, "Reset reader started.");
                    actionDescriptionDict.Add(350, "Reset reader running.");
                    actionDescriptionDict.Add(351, "Reset reader running.");
                    actionDescriptionDict.Add(352, "Reset reader running.");
                    actionDescriptionDict.Add(353, "Reset reader running.");
                    actionDescriptionDict.Add(354, "Reset reader running.");
                    actionDescriptionDict.Add(355, "Reset reader running.");
                    actionDescriptionDict.Add(356, "Reset reader running.");
                    actionDescriptionDict.Add(357, "Reset reader running.");
                    actionDescriptionDict.Add(358, "Reset reader running.");
                    actionDescriptionDict.Add(359, "Reset reader running.");
                    actionDescriptionDict.Add(151, "Reset reader finished succesfully.");
                    actionDescriptionDict.Add(152, "Reset reader restored.");


                    actionDescriptionDict.Add(800, "Read finished with error!");
                    actionDescriptionDict.Add(801, "Read was aborted, while not yet completed!");
                    actionDescriptionDict.Add(820, "Write finished with error!");
                    actionDescriptionDict.Add(821, "Write was aborted, while not yet completed!");
                    actionDescriptionDict.Add(840, "Soft reset finished with error!");
                    actionDescriptionDict.Add(841, "Soft reset was aborted, while not yet completed!");
                    actionDescriptionDict.Add(850, "Reset reader finished with error!");
                    actionDescriptionDict.Add(851, "Reset reader was aborted, while not yet completed!");
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

        public string IdentProfileDescription
        {
            get
            {
                if (identProfile_StatusDict == null) { identProfile_StatusDict = new Dictionary<ulong, string>(); }
                if (identProfile_StatusDict.Count == 0)
                {

                    identProfile_StatusDict.Add(0xE1FE0100, "Memory of the transponder cannot be written to");
                    identProfile_StatusDict.Add(0xE1FE0200, "Presence error");
                    identProfile_StatusDict.Add(0xE1FE0300, "Address error");
                    identProfile_StatusDict.Add(0xE1FE0400, "Initialization error");
                    identProfile_StatusDict.Add(0xE1FE0500, "The transponder memory is full.");
                    identProfile_StatusDict.Add(0xE1FE0600, "Error in transponder memory");
                    identProfile_StatusDict.Add(0xE1FE0700, "Password error");
                    identProfile_StatusDict.Add(0xE1FE0800, "The transponder in the antenna field does not have the expected UID / EPC ID or has no UID / EPC");
                    identProfile_StatusDict.Add(0xE1FE0900, "The command is not supported by the transponder.");
                    identProfile_StatusDict.Add(0xE1FE0A00, "The transponder is read/write-protected.");
                    identProfile_StatusDict.Add(0xE1FE8100, "The transponder is not responding.");
                    identProfile_StatusDict.Add(0xE1FE8200, "The transponder password is incorrect. Access is denied.");
                    identProfile_StatusDict.Add(0xE1FE8300, "The verification of the written transponder data has failed.");
                    identProfile_StatusDict.Add(0xE1FE8400, "General transponder error");
                    identProfile_StatusDict.Add(0xE1FE8500, "The transponder has too little power to execute the command.");
                    identProfile_StatusDict.Add(0xE2FE0100, "Field disturbance on reader");
                    identProfile_StatusDict.Add(0xE2FE0200, "More transponders are located in the transmission window than can be processed at the same");
                    identProfile_StatusDict.Add(0xE2FE8100, "There is no transponder with the required EPC ID/UID in the transmission window or there is no transponder");
                    identProfile_StatusDict.Add(0xE2FE8200, "The requested data is not available.");
                    identProfile_StatusDict.Add(0xE2FE8300, "CRC error in reader-transponder communication.");
                    identProfile_StatusDict.Add(0xE2FE8400, "The selected antenna is not enabled.");
                    identProfile_StatusDict.Add(0xE2FE8500, "The selected frequency is not enabled.");
                    identProfile_StatusDict.Add(0xE2FE8600, "The carrier signal is not activated.");
                    identProfile_StatusDict.Add(0xE2FE8700, "There is more than one transponder in the transmission window.");
                    identProfile_StatusDict.Add(0xE2FE8800, "General radio protocol error");
                    identProfile_StatusDict.Add(0xE4FE0100, "Short circuit or overload of the 24 V outputs");
                    identProfile_StatusDict.Add(0xE4FE0300, "Error in the connection to the reader; the reader is not answering.");
                    identProfile_StatusDict.Add(0xE4FE0400, "The buffer on the communications module or reader is not adequate to store the command temporarily.");
                    identProfile_StatusDict.Add(0xE4FE0500, "The buffer on the communications module or reader is not adequate to store the data temporarily.");
                    identProfile_StatusDict.Add(0xE4FE0600, "The command is not permitted in this status or is not supported.");
                    identProfile_StatusDict.Add(0xE4FE8100, "The specified tag field of the transponder is unknown.");
                    identProfile_StatusDict.Add(0xE4FE8A00, "General error");
                    identProfile_StatusDict.Add(0xE4FE8B00, "No or bad configuration data/parameters were transferred.");
                    identProfile_StatusDict.Add(0xE4FE8C00, "Communication error between Ident profile and communications module. Handshake error.");
                    identProfile_StatusDict.Add(0xE4FE8D00, "Communication error of the communications module/reader");
                    identProfile_StatusDict.Add(0xE4FE8E00, "The current command was aborted by the 'WRITE-CONFIG' ('INIT' or 'RESET') command or the bus");
                    identProfile_StatusDict.Add(0xE5FE0100, "Incorrect sequence number order (SN) on the reader/communications module");
                    identProfile_StatusDict.Add(0xE5FE0200, "Incorrect sequence number order (SN) in the Ident profile");
                    identProfile_StatusDict.Add(0xE5FE0400, "Invalid data block number (DBN) on the reader/communications module");
                    identProfile_StatusDict.Add(0xE5FE0500, "Invalid data block number (DBN) in the Ident profile");
                    identProfile_StatusDict.Add(0xE5FE0600, "Invalid data block length (DBL) on the reader/communications module");
                    identProfile_StatusDict.Add(0xE5FE0700, "Invalid data block length (DBL) in the Ident profile");
                    identProfile_StatusDict.Add(0xE5FE0800, "The previous command is still active or the buffer is full.");
                    identProfile_StatusDict.Add(0xE5FE0900, "The reader or communication module executes a hardware reset ('INIT_ACTIVE' set to '1'). 'INIT' is");
                    identProfile_StatusDict.Add(0xE5FE0A00, "The 'CMD' command code and the relevant acknowledgment do not match. This can be a software");
                    identProfile_StatusDict.Add(0xE5FE0B00, "Incorrect sequence of acknowledgement frames (TDB / DBN)");
                    identProfile_StatusDict.Add(0xE5FE0C00, "Synchronization error (incorrect increment of 'AC_H / AC_L' and 'CC_H / CC_L' in the cyclic control");
                    identProfile_StatusDict.Add(0xE5FE8100, "Communications error between reader and communications module");
                    identProfile_StatusDict.Add(0xE5FE8200, "Communications error between reader and communications module");
                    identProfile_StatusDict.Add(0xE5FE8300, "Communications error between reader and communications module");
                    identProfile_StatusDict.Add(0xE5FE8400, "Communications error between reader and communications module");
                    identProfile_StatusDict.Add(0xE6FE0100, "Unknown command");
                    identProfile_StatusDict.Add(0xE6FE0200, "Invalid command index (CI)");
                    identProfile_StatusDict.Add(0xE6FE0300, "The communication module or reader was configured incorrectly.");
                    identProfile_StatusDict.Add(0xE6FE0400, "Presence error");
                    identProfile_StatusDict.Add(0xE6FE0500, "An error has occurred that makes a Reset_Reader ('WRITE-CONFIG') necessary.");
                    identProfile_StatusDict.Add(0xE6FE8100, "A parameter is missing.");
                    identProfile_StatusDict.Add(0xE6FE8200, "The parameter has an invalid format.");
                    identProfile_StatusDict.Add(0xE6FE8300, "The parameter type is invalid.");
                    identProfile_StatusDict.Add(0xE6FE8400, "Unknown parameter");
                    identProfile_StatusDict.Add(0xE6FE8500, "The command or the frame has an invalid format.");
                    identProfile_StatusDict.Add(0xE6FE8600, "The 'Inventory' command failed.");
                    identProfile_StatusDict.Add(0xE6FE8700, "Read access to the transponder has failed.");
                    identProfile_StatusDict.Add(0xE6FE8800, "Write access to the transponder has failed.");
                    identProfile_StatusDict.Add(0xE6FE8900, "Writing the EPC ID/UID on the transponder has failed.");
                    identProfile_StatusDict.Add(0xE6FE8A00, "Enabling write protection on the transponder has failed.");
                    identProfile_StatusDict.Add(0xE6FE8B00, "The 'Kill' command failed.");
                    identProfile_StatusDict.Add(0xE7FE0100, "In this state, only the 'Reset_Reader' command ('WRITE-CONFIG' with 'CMDSEL =1' and 'CMD =");
                    identProfile_StatusDict.Add(0xE7FE0200, "The command code 'CMD' or the value in 'CMDSEL' is not permitted.");
                    identProfile_StatusDict.Add(0xE7FE0300, "The value of the 'LEN_DATA' parameter of the command is too long and does not match the global");
                    identProfile_StatusDict.Add(0xE7FE0400, "The receive data buffer (RXBUF) or the send data buffer (TXBUF) is too small, the buffer created at");
                    identProfile_StatusDict.Add(0xE7FE0500, "Only an 'INIT' command is permitted as the next command. All other commands are rejected.");
                    identProfile_StatusDict.Add(0xE7FE0600, "Wrong data record index of an acyclic data record");
                    identProfile_StatusDict.Add(0xE7FE0700, "The reader or communication module does not respond to 'INIT' ('INIT_ACTIVE' is expected in the");
                    identProfile_StatusDict.Add(0xE7FE0800, "Timeout during 'INIT' (60 seconds)");
                    identProfile_StatusDict.Add(0xE7FE0900, "Command repetition is not supported.");
                    identProfile_StatusDict.Add(0xE7FE0A00, "Error during the transfer of the PDU (Protocol Data Unit).");
                    identProfile_StatusDict.Add(0xE7FE0B00, "The 'CMDREF' parameter was set incorrectly. Check the parameter.");
                    //identProfile_StatusDict.Add(0xE1FE0200, "The connection from the internal interface to the image sensor is disrupted.");
                    //identProfile_StatusDict.Add(0xE1FE0400, "Transmission error");
                    //identProfile_StatusDict.Add(0xE1FE0600, "Program cannot be started because there is not enough memory or the program is damaged.");
                    //identProfile_StatusDict.Add(0xE1FE0700, "Comparison error");
                    //identProfile_StatusDict.Add(0xE4FE0400, "Internal file error");
                    //identProfile_StatusDict.Add(0xE4FE0600, "Lamp overload");
                    //identProfile_StatusDict.Add(0xE4FE8400, "Error in last command sequence.");
                    //identProfile_StatusDict.Add(0xE6FE0400, "The program could not be created or saved.");
                    //identProfile_StatusDict.Add(0xE1FE0300, "Bad parameter in MV command");
                    //identProfile_StatusDict.Add(0xE6FE0100, "Command not permitted or the command was aborted.");
                    //identProfile_StatusDict.Add(0xE6FE0300, "Initialization with program selection ('INIT'/'WRITE-CONFIG') is not possible. Possible causes:");



                }
                string identProfileDescription = "   ";

                if (IdentProfile_Status == null || IdentProfile_Status.Id == null)
                    return identProfileDescription;

                if (identProfile_StatusDict.TryGetValue(IdentProfile_Status.Id.Cyclic, out identProfileDescription))
                {
                    return identProfileDescription;
                }
                else

                {
                    return "   ";
                }
            }
        }

    }
}

