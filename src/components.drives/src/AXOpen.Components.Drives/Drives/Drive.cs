using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using AXOpen.Components.Abstractions;
using AXOpen.Messaging.Static;
using AXSharp.Connector;

namespace AXOpen.Components.Drives
{
    public partial class AxoDrive
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(701, new AxoMessengerTextItem("refAxisIn has NULL reference!",                                                "Check the call of the `Run` method, if the `refAxisIn` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(702, new AxoMessengerTextItem("refAxisOut has NULL reference!",                                               "Check the call of the `Run` method, if the `refAxisOut` parameter is assigned.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(703, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(704, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(705, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(706, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(707, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(708, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(709, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(710, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(711, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(712, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(713, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(714, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(715, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(716, new AxoMessengerTextItem("   ", "   ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(717, new AxoMessengerTextItem("   ", "   ")),
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

    public partial class AxoDrive_Status : AxoComponent_Status
    {
        Dictionary<uint, string> errorDescriptionDict = new Dictionary<uint, string>();
        Dictionary<uint, string> actionDescriptionDict = new Dictionary<uint, string>();

        public string ErrorDescription
        {
            get
            {
                if (errorDescriptionDict == null) { errorDescriptionDict = new Dictionary<uint, string>(); }
                if (errorDescriptionDict.Count == 0)
                {
                    errorDescriptionDict.Add(0, "   ");
                    errorDescriptionDict.Add(600, "");
                    errorDescriptionDict.Add(601, "");
                    errorDescriptionDict.Add(602, "");
                    errorDescriptionDict.Add(603, "");
                    errorDescriptionDict.Add(604, "");
                    errorDescriptionDict.Add(605, "");
                    errorDescriptionDict.Add(606, "");


                    errorDescriptionDict.Add(700, "Error: Parent has NULL reference!");
                    errorDescriptionDict.Add(701, "Error: refAxisIn has NULL reference!");
                    errorDescriptionDict.Add(702, "Error: refAxisOut has NULL reference!");
                    errorDescriptionDict.Add(703, "Error: ");
                    errorDescriptionDict.Add(704, "Error: ");
                    errorDescriptionDict.Add(705, "Error: ");
                    errorDescriptionDict.Add(706, "Error: ");
                    errorDescriptionDict.Add(707, "Error: ");
                    errorDescriptionDict.Add(708, "Error: ");
                    errorDescriptionDict.Add(709, "Error: ");
                    errorDescriptionDict.Add(710, "Error: ");
                    errorDescriptionDict.Add(711, "Error: ");
                    errorDescriptionDict.Add(712, "Error: ");
                    errorDescriptionDict.Add(713, "Error: ");

                }
                string errorDescription = "   ";
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


                    actionDescriptionDict.Add(600, "Clearing of the result data was aborted, while not yet completed!");
                    actionDescriptionDict.Add(601, "Reading was aborted, while not yet completed!");

                    actionDescriptionDict.Add(700, "Clearing of the result data finished with error!");
                    actionDescriptionDict.Add(701, "Reading finished with error!");

                }
                string actionDescription = "   ";
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
