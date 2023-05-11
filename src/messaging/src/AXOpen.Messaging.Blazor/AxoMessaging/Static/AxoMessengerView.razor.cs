using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Messaging.Static
{
    public partial class AxoMessengerView : IDisposable
    {
        private bool showHelp = false;

        private void AcknowledgeTask()
        {
            Component.AcknowledgeRequest.Cyclic = true;
        }
        private void Help()
        {
            showHelp = !showHelp;
        }
        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component);
        }

        public void Dispose()
        {
            Component.StopPolling();
        }

        private string BackgroundColor
        {
            get
            {
                string retval = "btn-default";
                if (IsActive  && !AcknowledgedBeforeFallen) { retval = "btn-danger"; }
                if (!IsActive &&  WaitingForAcknowledge && !AcknowledgedBeforeFallen) { retval = "btn-warning"; }
                if (IsActive  && !WaitingForAcknowledge && AcknowledgedBeforeFallen) { retval = "btn-success"; }
                return retval;
            }
        }

        private string Category
        {
            get
            {
                switch (Component.Category.Cyclic)
                {
                    case 0:
                        return "All";
                        break;
                    case 100:
                        return "Trace";
                        break;
                    case 200: 
                        return "Debug";
                        break;
                    case 300:
                        return "Info";
                        break;
                    case 400:
                        return "TimedOut";
                        break;
                    case 500:
                        return "Notification";
                        break;
                    case 600:
                        return "Warning";
                        break;
                    case 700:
                        return "Error";
                        break;
                    case 900:
                        return "ProgrammingError";
                        break;
                    case 1000:
                        return "Critical";
                        break;
                    case 1100:
                        return "Fatal";
                        break;
                    case 1200:
                        return "Catastrophic";
                        break;
                    case 32000:
                        return "None";
                        break;
                    default:
                        return "None";
                        break;
                }            
            }
        }
        private string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.AttributeName;
        private string Symbol => !(string.IsNullOrEmpty(Component.Symbol)) ? Component.Symbol : "Unable to retrieve symbol!";
        private string MessageText => !(string.IsNullOrEmpty(Component.MessageText)) ? Component.MessageText : "Message text not defined!";
        private string HelpText => !(string.IsNullOrEmpty(Component.Help)) ? Component.Help : "Help not defined!";
        private string Risen => !(string.IsNullOrEmpty(Component.Risen.Cyclic.ToString())) ? Component.Risen.Cyclic.ToString() : "";
        private string Fallen => !(string.IsNullOrEmpty(Component.Fallen.Cyclic.ToString())) ? Component.Fallen.Cyclic.ToString() : "";
        private string Acknowledged => !(string.IsNullOrEmpty(Component.Acknowledged.Cyclic.ToString())) ? Component.Acknowledged.Cyclic.ToString() : "";
        private bool IsActive => Component.IsActive.Cyclic;
        private bool AcknowledgementRequired => Component.AcknowledgementRequired.Cyclic;
        private bool AcknowledgedBeforeFallen => Component.AcknowledgedBeforeFallen.Cyclic;
        private bool AcknowledgementDoesNotRequired => !AcknowledgementRequired;
        private bool WaitingForAcknowledge => Component.WaitingForAcknowledge.Cyclic;
        private bool HideAckowledgeButton => !AcknowledgementRequired || AcknowledgedBeforeFallen || (!IsActive && !WaitingForAcknowledge);
    }

    public class AxoMessengerCommandView : AxoMessengerView
    {
        public AxoMessengerCommandView()
        {

        }
    }

    public class AxoMessengerStatusView : AxoMessengerView
    {
        public AxoMessengerStatusView()
        {
        }
    }
}
