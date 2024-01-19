using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using Serilog;

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
            Log.Logger.Information($"- AxoDialogBaseView --> Initialized --> CloseValue:{Component._closeSignal.Cyclic.ToString()}, in {Component.Symbol}");

        }

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            var task = (AxoDialogBase)element;

            task._closeSignal.StartPolling(pollingInterval, this);
            PolledElements.Add(task._closeSignal);
        }


        private async void OnCloseSignal(object sender, EventArgs e)
        {
            Log.Logger.Information($"- AxoDialogBaseView --> OnCloseSignal() --> CloseValue:{Component._closeSignal.Cyclic.ToString()}, in {Component.Symbol}");
            if (Component._closeSignal.Cyclic)
            {
                //this is probably reduntant (normal Close should enough, however some wierdness is occuring
                await CloseDialogsWithSignalR();
            }
            else
            {
                var ss = Component._closeSignal;
            }
        }

        private bool _sendingCloseToAll = false;

        public virtual async Task CloseDialogsWithSignalR()
        {
            Log.Logger.Information($"- AxoDialogBaseView - Closing by SignalR {Component.Symbol}");
            await DialogContainer.SendToAllClients_CloseDialog(Component.Symbol);
        }

        public override void Dispose()
        {

            Log.Logger.Information($"- AxoDialogBaseView --> Disposing --> CloseValue:{Component._closeSignal.Cyclic.ToString()}, in {Component.Symbol}");

            Component._closeSignal.ValueChangeEvent -= OnCloseSignal;
            base.Dispose();
        }

    }
}
