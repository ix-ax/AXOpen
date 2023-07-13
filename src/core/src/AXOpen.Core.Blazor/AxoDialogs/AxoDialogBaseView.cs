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
    public partial class AxoDialogBaseView<T> : RenderableComplexComponentBase<T> where T : AxoDialogBase
    {

        [Inject]
        public AxoDialogContainer _dialogContainer { get; set; }
        [Inject]
        public NavigationManager _navigationManager { get; set; }


        private string _dialogId;
        private AxoDialogProxyService _myProxyService;
        protected async override Task OnInitializedAsync()
        {
            _dialogId = Component.DialogId;
            AxoDialogProxyService proxy;
            _dialogContainer.DialogProxyServicesDictionary.TryGetValue(_dialogId, out proxy);
            _myProxyService = proxy;
            _dialogContainer.DialogClient.MessageReceivedDialogClose += OnCloseDialogMessage;
            _dialogContainer.DialogClient.MessageReceivedDialogOpen += OnOpenDialogMessage;
        }
        private async void OnCloseDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            if (_dialogId == e.Message.ToString())
            {
                await Close();
                if(_myProxyService != null)
                    _myProxyService.IsDialogInvoked = false;
    
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

                    ShowBackdrop = false;
                    await OpenDialog();
                }
            }
         
        }

        public bool ShowBackdrop { get; set; }
        public string IsDialogInvoked { get; set; }
        public string ShowDialog { get; set; }
        public virtual async Task CloseDialog()
        {
            await _dialogContainer.DialogClient.SendDialogClose(_dialogId);
        }

        private async Task Close()
        {
            ShowDialog = "";
            ShowBackdrop = false;
            _myProxyService.DialogInstance = null;
            await InvokeAsync(StateHasChanged);

        }

        public virtual async Task OpenDialog()
        {
            ShowDialog = "show";
            ShowBackdrop = true;
            await InvokeAsync(StateHasChanged);
        }

     
    }
}
