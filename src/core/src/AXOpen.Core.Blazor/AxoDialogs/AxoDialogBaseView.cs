using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Base class for dialogues, where open/close method are implemented needed for correct synchronization between dialogues.
    /// </summary>
    /// <typeparam name="T">Type of dialogue</typeparam>
    public partial class AxoDialogBaseView<T> :  RenderableComplexComponentBase<T>,IDisposable where T : AxoDialogBase
    {

        [Inject]
        public AxoDialogContainer _dialogContainer { get; set; }
        [Inject]
        public NavigationManager _navigationManager { get; set; }


        protected ModalDialog ModalDialog;
        private string _dialogId;
        private AxoDialogProxyService _myProxyService;

        protected async void OnCloseDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (_dialogId == e.Message.ToString())
            {
                await Close();
            }
        }
        protected async void OnOpenDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (_dialogId == e.Message.ToString())
            {
                await OpenDialog();
            }
        }


        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            _dialogId = Component.DialogId;
            _dialogContainer.DialogProxyServicesDictionary.TryGetValue(_dialogId, out AxoDialogProxyService proxy);
            _myProxyService = proxy;
            if (firstRender)
            {
                if (_myProxyService.DialogInstance != null)
                {
                   await ModalDialog.Open();
                }
                _dialogContainer.DialogClient.MessageReceivedDialogClose += OnCloseDialogMessage;
                _dialogContainer.DialogClient.MessageReceivedDialogOpen += OnOpenDialogMessage;
            }
        }

        public virtual async Task CloseDialogsWithSignalR()
        {
            await _dialogContainer.DialogClient.SendDialogClose(_dialogId);
        }

        protected async Task Close()
        {
            await ModalDialog.Close();
            _dialogContainer.DialogProxyServicesDictionary.TryGetValue(_dialogId, out var proxy);
            proxy.DialogInstance = null;
            _myProxyService = proxy;
           
        }

        public virtual async Task OpenDialog()
        {
            await ModalDialog.Open();
        }

        public override void Dispose()
        {
            base.Dispose();
            _dialogContainer.DialogClient.MessageReceivedDialogClose -= OnCloseDialogMessage;
            _dialogContainer.DialogClient.MessageReceivedDialogOpen -= OnOpenDialogMessage;
        }

    }
}
