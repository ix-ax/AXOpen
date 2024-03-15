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

                    //WARNINGs
                    errorDescriptionDict.Add(600, "");
                    errorDescriptionDict.Add(601, "");
                    errorDescriptionDict.Add(602, "");
                    errorDescriptionDict.Add(603, "");
                    errorDescriptionDict.Add(604, "");
                    errorDescriptionDict.Add(605, "");
                    errorDescriptionDict.Add(606, "");
                    errorDescriptionDict.Add(607, "");
                    errorDescriptionDict.Add(608, "");
                    errorDescriptionDict.Add(609, "");
                    errorDescriptionDict.Add(610, "");


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

                }
                string errorDescription = "   ";
                if (Error != null && Error.Id != null && errorDescriptionDict.TryGetValue(Error.Id.LastValue, out errorDescription))
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
                    //INFOs
                    actionDescriptionDict.Add(300, "");
                    actionDescriptionDict.Add(301, "");
                    actionDescriptionDict.Add(302, "");
                    actionDescriptionDict.Add(303, "");
                    actionDescriptionDict.Add(304, "");
                    actionDescriptionDict.Add(305, "");
                    actionDescriptionDict.Add(306, "");
                    actionDescriptionDict.Add(307, "");
                    actionDescriptionDict.Add(308, "");
                    actionDescriptionDict.Add(309, "");
                    actionDescriptionDict.Add(310, "");

                    //WARNINGs
                    actionDescriptionDict.Add(600, "");
                    actionDescriptionDict.Add(601, "");
                    actionDescriptionDict.Add(602, "");
                    actionDescriptionDict.Add(603, "");
                    actionDescriptionDict.Add(604, "");
                    actionDescriptionDict.Add(605, "");
                    actionDescriptionDict.Add(606, "");
                    actionDescriptionDict.Add(607, "");
                    actionDescriptionDict.Add(608, "");
                    actionDescriptionDict.Add(609, "");
                    actionDescriptionDict.Add(610, "");

                    //ERRORs
                    actionDescriptionDict.Add(700, "");
                    actionDescriptionDict.Add(701, "");
                    actionDescriptionDict.Add(702, "");
                    actionDescriptionDict.Add(703, "");
                    actionDescriptionDict.Add(704, "");
                    actionDescriptionDict.Add(705, "");
                    actionDescriptionDict.Add(706, "");
                    actionDescriptionDict.Add(707, "");
                    actionDescriptionDict.Add(708, "");
                    actionDescriptionDict.Add(709, "");
                    actionDescriptionDict.Add(710, "");

                }
                string actionDescription = "   ";
                if (Action != null && Action.Id != null && actionDescriptionDict.TryGetValue(Action.Id.LastValue, out actionDescription))
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
