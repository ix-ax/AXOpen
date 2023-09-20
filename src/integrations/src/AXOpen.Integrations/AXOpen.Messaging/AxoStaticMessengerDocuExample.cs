using AXSharp.Connector;
using AXOpen.Messaging.Static;

namespace AxoStaticMessengerDocuExample
{
    //<InitializationOfTheDotNetTextList>
    public partial class Messengers : AXOpen.Core.AxoContext
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
			try
			{
                InitializeMessenger4();
			}
			catch (Exception)
			{

				throw;
			}
        }

        private void InitializeMessenger4()
        {
            List<KeyValuePair<ulong, AxoMessengerTextItem>> messengerTextList = new List<KeyValuePair<ulong, AxoMessengerTextItem>>
            {
                new KeyValuePair<ulong, AxoMessengerTextItem>(0, new AxoMessengerTextItem("  ", "  ")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(10, new AxoMessengerTextItem("Messenger 4: static message text for message code 10 declared in .NET", "Messenger 5: static help text for message code 10 declared in .NET")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(20, new AxoMessengerTextItem("Messenger 4: static message text for message code 20 declared in .NET", "Messenger 5: static help text for message code 20 declared in .NET")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(30, new AxoMessengerTextItem("Messenger 4: static message text for message code 30 declared in .NET", "Messenger 5: static help text for message code 30 declared in .NET")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40, new AxoMessengerTextItem("Messenger 4: static message text for message code 40 declared in .NET", "Messenger 5: static help text for message code 40 declared in .NET")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Messenger 4: static message text for message code 50 declared in .NET", "Messenger 5: static help text for message code 50 declared in .NET"))
            };

            _messenger4.DotNetMessengerTextList = messengerTextList;
        }
    }
    //</InitializationOfTheDotNetTextList>
}