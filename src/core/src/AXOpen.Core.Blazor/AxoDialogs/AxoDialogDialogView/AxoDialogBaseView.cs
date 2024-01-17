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
        [Inject]
        public NavigationManager NavigationManager { get; set; }


        private AxoDialogProxyService _dialogProxyService;


        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            //todo -> it is not needed to subscibe all -> optimalize at the end...
            var task = (AxoDialogBase)element;
            var kids = task.GetValueTags().ToList();

            kids.ForEach(p =>
            {
                p.StartPolling(pollingInterval, this);
                PolledElements.Add(p);
            });
        }


        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                DialogContainer.DialogProxyServicesDictionary.TryGetValue(Component.DialogLocatorId, out AxoDialogProxyService proxy);
                _dialogProxyService = proxy;

                DialogContainer.DialogClient.MessageReceivedDialogClose += OnCloseDialogMessage;
                DialogContainer.DialogClient.MessageReceivedDialogOpen += OnOpenDialogMessage;
            }
        }

        public virtual async Task CloseDialogsWithSignalR()
        {
            await DialogContainer.DialogClient.SendDialogCloseRequest(Component.Symbol);
        }

        protected async void OnCloseDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (e == null) return;// in same cases can be null
            if (e.Message == null) return;

            if (Component.Symbol == e.Message.ToString())
            {
                CloseDialog();
            }
        }
        protected async void OnOpenDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (e == null) return;// in same cases can be null
            if (e.Message == null) return;

            if (Component.Symbol == e.Message.ToString())
            {
                //todo - verify
                ;// await OpenDialog();
            }
        }

        protected void CloseDialog()
        {
            _dialogProxyService.RemoveDisplayedDialog(Component.Symbol);
        }

        public void OpenDialog()
        {
            ;// _dialogProxyService.add(Component.Symbol);

        }


        public override void Dispose()
        {
            base.Dispose();
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            this.UpdateValuesOnChange(Component);
        }
    }
}
