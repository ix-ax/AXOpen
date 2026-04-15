using AXSharp.Connector;
using AXOpen.Messaging.Static;

namespace AxoStaticMessengerDocuExample
{
    //<InitializationOfTheDotNetTextList>
    public partial class Messengers : AXOpen.Core.AxoObject
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(10, new AxoMessengerTextItem("Messenger 4: static message text for message code 10 declared in .NET", "Messenger 4: static help text for message code 10 declared in .NET")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(20, new AxoMessengerTextItem("Messenger 4: static message text for message code 20 declared in .NET", "Messenger 4: static help text for message code 20 declared in .NET")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(30, new AxoMessengerTextItem("Messenger 4: static message text for message code 30 declared in .NET", "Messenger 4: static help text for message code 30 declared in .NET")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(40, new AxoMessengerTextItem("Messenger 4: static message text for message code 40 declared in .NET", "Messenger 4: static help text for message code 40 declared in .NET")),
                new KeyValuePair<ulong, AxoMessengerTextItem>(50, new AxoMessengerTextItem("Messenger 4: static message text for message code 50 declared in .NET", "Messenger 4: static help text for message code 50 declared in .NET"))
            };

            _messenger4.DotNetMessengerTextList = messengerTextList;
        }
    }
    //</InitializationOfTheDotNetTextList>

    public partial class MessengersExamples : AXOpen.Core.AxoObject
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
                new KeyValuePair<ulong, AxoMessengerTextItem>(10, new AxoMessengerTextItem("Messenger 5: message text 10"))
            };

            _messenger5.DotNetMessengerTextList = messengerTextList;
        }
    }

}