using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Elements
{
    public partial class AxoRotaryIndexingTable
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Restore has been executed.","")),
                // TurnTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(100, new AxoMessengerTextItem("TurnTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(101, new AxoMessengerTextItem("TurnTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(102, new AxoMessengerTextItem("TurnTask restored.","")),
                // InitPositionTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(110, new AxoMessengerTextItem("InitPositionTask started.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(111, new AxoMessengerTextItem("InitPositionTask finished succesfully.","")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(112, new AxoMessengerTextItem("InitPositionTask restored.","")),
                //  General alarm
                new KeyValuePair<ulong, AxoMessengerTextItem>(700, new AxoMessengerTextItem("Input variable `parent` has NULL reference in `Run` method!",                                  "Check the call of the `Run` method, if the `parent` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("Parameter 'Config.NumberOfPositions' is lower then 2!",                                        "This parameters must be grater or equal to 2!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("Parameter 'Config.NumberOfPositions' is greather then 32!",                                    "This parameters must be lower or equal to 32!")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Turn table is not in the initial position!",                                                   "Move the turn table in the initial position and check the signals of the position sensors.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Invalid coding, no signal from any coding sensor!",                                            "Check the signals of the coding sensors.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Invalid coding, current position is greather then maximum!",                                   "Check the signals of the coding sensors, so as the value of 'Config.NumberOfPositions' variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Invalid coding, unexpected value of coding sensors!",                                          "Check the signals of the coding sensors.")),


                // TurnTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10000, new AxoMessengerTextItem("TurnTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10001, new AxoMessengerTextItem("TurnTask was aborted, while not yet completed!","Check the details.")),
                // InitPositionTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(10010, new AxoMessengerTextItem("InitPositionTask finished with error!","Check the details.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10011, new AxoMessengerTextItem("InitPositionTask was aborted, while not yet completed!","Check the details.")),

        };

            Messenger.DotNetMessengerTextList = messengerTextList;
        }

        private void InitializeTaskMessenger()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0,    new AxoMessengerTextItem("  ", "  ")),
                // TurnTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(502,  new AxoMessengerTextItem("Waiting for the signal/variable 'Inputs.InPosition' to be reseted !","Check the status of the 'Inputs.InPosition'  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(503,  new AxoMessengerTextItem("Waiting for the signal/variable 'Inputs.InPosition' to be set !","Check the status of the 'Inputs.InPosition'  signal/variable.")),
                // InitPositionTask
                new KeyValuePair<ulong, AxoMessengerTextItem>(512,  new AxoMessengerTextItem("Waiting for the signal/variable 'Inputs.InPosition' to be reseted !","Check the status of the 'Inputs.InPosition'  signal/variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(513,  new AxoMessengerTextItem("Waiting for the signal/variable 'Inputs.InPosition' to be set !","Check the status of the 'Inputs.InPosition'  signal/variable.")),
                
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("Turn table is not in the initial position!",                                                   "Move the turn table in the initial position and check the signals of the position sensors.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("Invalid coding, no signal from any coding sensor!",                                            "Check the signals of the coding sensors.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("Invalid coding, current position is greather then maximum!",                                   "Check the signals of the coding sensors, so as the value of 'Config.NumberOfPositions' variable.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("Invalid coding, unexpected value of coding sensors!",                                          "Check the signals of the coding sensors.")),


        };

            TaskMessenger.DotNetMessengerTextList = messengerTextList;
        }
    }
}
