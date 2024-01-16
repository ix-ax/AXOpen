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
    public partial class AxoDialogBaseView<T> :  RenderableComplexComponentBase<T> where T : AxoDialogBase
    {

        [Inject]
        public AxoDialogContainer DialogContainer { get; set; }
        [Inject]
        public NavigationManager NavigationManager { get; set; }

        protected ModalDialog ModalDialog;

        private string _ParentDialogLocatorId;

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

        protected async void OnCloseDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (e == null) return;// in same cases can be null
            if (e.Message == null) return;

            if (_ParentDialogLocatorId == e.Message.ToString())
            {
                await Close();
            }
        }
        protected async void OnOpenDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (e == null) return;// in same cases can be null
            if (e.Message == null) return;

            if (_ParentDialogLocatorId == e.Message.ToString())
            {
                await OpenDialog();
            }
        }


        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            _ParentDialogLocatorId = Component.DialogLocatorId;

            DialogContainer.DialogProxyServicesDictionary.TryGetValue(_ParentDialogLocatorId, out AxoDialogProxyService proxy);
            _dialogProxyService = proxy;

            if (firstRender)
            {
                if (_dialogProxyService.IsInListOfDisplayeDialog(Component.Symbol))
                {
                   await ModalDialog.Open();
                }

                DialogContainer.DialogClient.MessageReceivedDialogClose += OnCloseDialogMessage;
                DialogContainer.DialogClient.MessageReceivedDialogOpen += OnOpenDialogMessage;
            }
        }

        public virtual async Task CloseDialogsWithSignalR()
        {
            await DialogContainer.DialogClient.SendDialogClose(_ParentDialogLocatorId);
        }

        protected async Task Close()
        {
            await ModalDialog.Close();
            DialogContainer.DialogProxyServicesDictionary.TryGetValue(_ParentDialogLocatorId, out var proxy);

            //todo -> verify if is passed dialog and if is removed...
            proxy.RemoveDisplayeDialog(Component);

            _dialogProxyService = proxy;
           
        }

        public virtual async Task OpenDialog()
        {
            await ModalDialog.Open();
        }

        public override void Dispose()
        {
            base.Dispose();
            DialogContainer.DialogClient.MessageReceivedDialogClose -= OnCloseDialogMessage;
            DialogContainer.DialogClient.MessageReceivedDialogOpen -= OnOpenDialogMessage;
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            this.UpdateValuesOnChange(Component);
        }
    }
}
