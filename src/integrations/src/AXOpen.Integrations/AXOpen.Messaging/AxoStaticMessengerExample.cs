using AXSharp.Connector;
using AXOpen.Messaging.Static;

namespace AxoStaticMessengerExample
{
    public partial class Messengers : AXOpen.Core.AxoContext
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
			try
			{
                InitializeMessenger5();
			}
			catch (Exception)
			{

				throw;
			}
        }
        private void InitializeMessenger5()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(1, new AxoMessengerTextItem("Messenger 5: message text 1", "Messenger 5: help text 1")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(2, new AxoMessengerTextItem("Messenger 5: message text 2", "Messenger 5: help text 2")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(3, new AxoMessengerTextItem("Messenger 5: message text 3", "Messenger 5: help text 3")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(4, new AxoMessengerTextItem("Messenger 5: message text 4", "Messenger 5: help text 4")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(5, new AxoMessengerTextItem("Messenger 5: message text 5", "Messenger 5: help text 5")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(6, new AxoMessengerTextItem("Messenger 5: message text 6", "Messenger 5: help text 6")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(7, new AxoMessengerTextItem("Messenger 5: message text 7", "Messenger 5: help text 7")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(8, new AxoMessengerTextItem("Messenger 5: message text 8", "Messenger 5: help text 8")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(9, new AxoMessengerTextItem("Messenger 5: message text 9", "Messenger 5: help text 9")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10, new AxoMessengerTextItem("Messenger 5: message text 10", "Messenger 5: help text 10"))
            };

            _messenger5.DotNetMessengerTextList = messengerTextList;
        }
    }
}