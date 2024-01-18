using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Base class for dialogues, where open/close method are implemented needed for correct synchronization between dialogues.
    /// </summary>
    /// <typeparam name="T">Type of dialogue</typeparam>
    public partial class AxoDialogBaseView<T> : RenderableComplexComponentBase<T> where T : AxoDialogBase
    {

        [Inject]
        public AxoDialogContainer DialogContainer { get; set; }

        protected override void OnInitialized()
        {
            base.OnInitialized();

            Component._closeSignal.ValueChangeEvent += OnCloseSignal;
            
            this.UpdateValuesOnChange(Component); //todo - every children must define addto pooling... verify ...
        }

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            var task = (AxoDialogBase)element;

            task._closeSignal.StartPolling(pollingInterval, this);
            PolledElements.Add(task._closeSignal);
        }


        private async void OnCloseSignal(object sender, EventArgs e)
        {
            if (Component._closeSignal.Cyclic)
            {
                //this is probably reduntant (normal Close should enough, however some wierdness is occuring
                await CloseDialogsWithSignalR();
            }
        }

        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            await base.OnAfterRenderAsync(firstRender);

            if (Component._closeSignal.Cyclic)
            {
                await CloseDialogsWithSignalR();
            }
        }

        public virtual async Task CloseDialogsWithSignalR()
        {
            await DialogContainer.SendToAllClients_CloseDialog(Component.Symbol);
        }

        public override void Dispose()
        {
            Component._closeSignal.ValueChangeEvent -= OnCloseSignal;
            base.Dispose();
        }

    }
}
