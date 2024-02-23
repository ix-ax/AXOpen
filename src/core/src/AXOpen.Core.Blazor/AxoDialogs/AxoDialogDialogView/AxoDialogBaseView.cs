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
        public AxoDialogAndAlertContainer DialogContainer { get; set; }

        public bool EnableLoging { set; get; }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            
            this.UpdateValuesOnChange(Component); 
        }

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            var task = (AxoDialogBase)element;

            task._closeSignal.StartPolling(pollingInterval, this);
            PolledElements.Add(task._closeSignal);
        }


        private bool _sendingCloseToAll = false;

        public virtual async Task CloseDialogsWithSignalR()
        {
            if (EnableLoging)
                Log.Logger.Information($"AxoDialogBaseView - Closing by SignalR {Component.Symbol}");

            await DialogContainer.SendToAllClients_CloseDialog(Component.Symbol);
        }

        public override void Dispose()
        {
            if (EnableLoging)
                Log.Logger.Information($"AxoDialogBaseView --> Disposing --> CloseValue:{Component._closeSignal.Cyclic.ToString()}, in {Component.Symbol}");
           
            base.Dispose();
        }

    }
}
