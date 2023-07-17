using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Dialogs;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using BlazorBootstrap;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public partial class AxoDialogBaseView<T> :  RenderableComplexComponentBase<T>,IDisposable where T : AxoDialogBase
    {

        [Inject]
        public AxoDialogContainer _dialogContainer { get; set; }
        [Inject]
        public NavigationManager _navigationManager { get; set; }



        protected ModalDialog ModalDialog;
        private string _dialogId;
        private AxoDialogProxyService _myProxyService;
        protected async override Task OnInitializedAsync()
        {
            _dialogId = Component.DialogId;
            AxoDialogProxyService proxy;
            _dialogContainer.DialogProxyServicesDictionary.TryGetValue(_dialogId, out proxy);
            _myProxyService = proxy;

            
        }
        private async void OnCloseDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (_dialogId == e.Message.ToString())
            {
                await Close();
            }
        }
        private async void OnOpenDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (_dialogId == e.Message.ToString())
            {
                await OpenDialog();
            }
        }


        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
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

        private async Task Close()
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

        public void Dispose()
        {
            _dialogContainer.DialogClient.MessageReceivedDialogClose -= OnCloseDialogMessage;
            _dialogContainer.DialogClient.MessageReceivedDialogOpen -= OnOpenDialogMessage;
        }

    }
}
