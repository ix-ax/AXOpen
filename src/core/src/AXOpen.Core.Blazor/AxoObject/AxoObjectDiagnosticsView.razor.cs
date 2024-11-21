using AXOpen.Messaging.Static;
using AXOpen.VisualComposer;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoObjectDiagnosticsView
    {
        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            if (element is AxoObject o)
            {
                base.AddToPolling(o.MsgCnt,2500);
            }
        }

        private void SetCurrentObject()
        {
            if (RccContainer is RenderableContentControl rccContainer)
            {
                if (rccContainer.ParentContainer is VisualComposerItem composerItem)
                {
                    composerItem.Parent.UpdateDetails(this.Component);
                }
            }
        }

        private async Task LoadMessages()
        {
            // Await async method to load the message state
            await MessageProvider.ReadMessageStateAsync();

            // Optionally load message details for each active message
            if (MessageProvider.Messengers != null)
            {
                foreach (var message in MessageProvider.Messengers)
                {
                    if (message.State > eAxoMessengerState.Idle)
                    {
                        await message.ReadDetailsAsync();
                    }
                }
            }
        }
    }
}
