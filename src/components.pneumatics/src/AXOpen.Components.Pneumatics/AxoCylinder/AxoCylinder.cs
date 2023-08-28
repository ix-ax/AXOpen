using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;

namespace AXOpen.Components.Pneumatics
{
    public partial class AxoCylinder : AXOpen.Core.AxoComponent
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            try
            {
                InitializeMessenger();
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(1, new AxoMessengerTextItem("Movement to work position did not succeed.", "Check the cyclinder that it is free to move, air pressure input and extremity sensor.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2, new AxoMessengerTextItem("Movement to home position did not succeed.", "Check the cyclinder that it is free to move, air pressure input and extremity sensor.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(3, new AxoMessengerTextItem("Home and work position sensors are both active at the same time.", "Check the positions of the sensors.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(4, new AxoMessengerTextItem("Movement to work position is temporarily suspended.", "Check the blocking condition.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(5, new AxoMessengerTextItem("Movement to home position is temporarily suspended.", "Check the blocking condition.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(6, new AxoMessengerTextItem("Movement to work position is aborted.", "Check the blocking condition.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(7, new AxoMessengerTextItem("Movement to home position is aborted.", "Check the blocking condition.")),
            };

            _Messenger.DotNetMessengerTextList = messengerTextList;
        }
    }
}
