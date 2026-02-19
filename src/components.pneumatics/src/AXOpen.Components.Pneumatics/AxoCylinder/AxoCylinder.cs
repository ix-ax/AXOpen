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
                new KeyValuePair<ulong, AxoMessengerTextItem>(1, new AxoMessengerTextItem(() => $"Movement position `{this.OutLabel}` did not succeed.", "Check that cylinder is free to move, check the air pressure, and extremity sensor.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2, new AxoMessengerTextItem(() => $"Movement  position `{this.InLabel}` did not succeed.", "Check that cylinder is free to move, check the air pressure, and extremity sensor.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(3, new AxoMessengerTextItem("Both extremity sensors are active at the same time.", "Check the positions of the sensors.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(4, new AxoMessengerTextItem(() => $"Movement to position `{this.OutLabel}` is temporarily suspended.", "Check the blocking condition.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(5, new AxoMessengerTextItem(() => $"Movement to position `{this.InLabel}` is temporarily suspended.", "Check the blocking condition.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(6, new AxoMessengerTextItem(() => $"Movement position `{this.OutLabel}` is aborted.", "Check the blocking condition.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(7, new AxoMessengerTextItem(() => $"Movement position `{this.InLabel}` is aborted.", "Check the blocking condition.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(8, new AxoMessengerTextItem(() => $"Movement position `{this.InLabel}` overshot the extremity sensor.", "Check the sensor position.")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(9, new AxoMessengerTextItem(() => $"Movement  position `{this.OutLabel}` overshot the extremity sensor.", "Check the sensor position.")),
            };

            _Messenger.DotNetMessengerTextList = messengerTextList;
        }
    }
}
