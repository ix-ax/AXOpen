using AXOpen.Messaging.Static;
using AXOpen.VisualComposer.Components.VisualComposerItem;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoObjectDiagnosticsView
    {
        public override void ConfigurePolling()
        {
            if (this.Component is AxoObject o)
            {
                this.StartPolling(o.MsgCnt,2500);
            }
        }

        private void SetCurrentObject()
        {
            if (RccContainer is RenderableContentControl rccContainer)
            {
                if (rccContainer.ParentContainer is VisualComposerItem composerItem)
                {
                    composerItem.Parent.OpenDetails(this.Component);
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
