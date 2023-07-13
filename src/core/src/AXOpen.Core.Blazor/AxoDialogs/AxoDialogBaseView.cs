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

            //if (_myProxyService.DialogInstance != null)
            //{

            //    ShowDialog = "";
            //    ShowBackdrop = false;
            //    StateHasChanged();
            //    await OpenDialog();
            //}
            Console.WriteLine($"Initialize {_myProxyService.DialogInstance.ToString()}");
            

            
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
                Console.WriteLine($"Initialize after render {_myProxyService.DialogInstance?.ToString()}");
                if (_myProxyService.DialogInstance != null)
                {
                    await ModalDialog.Open();
                }
                _dialogContainer.DialogClient.MessageReceivedDialogClose += OnCloseDialogMessage;
                _dialogContainer.DialogClient.MessageReceivedDialogOpen += OnOpenDialogMessage;

                //await ModalDialog.Open();
                //if (_myProxyService.DialogInstance != null)
                //{

                //    ShowDialog = "";
                //    ShowBackdrop = false;
                //    StateHasChanged();
                //    await OpenDialog();
                //}
            }

        }

        public bool ShowBackdrop { get; set; }
        public string ShowDialog { get; set; }
        public virtual async Task CloseDialog()
        {
            await _dialogContainer.DialogClient.SendDialogClose(_dialogId);
        }

        private async Task Close()
        {
            await ModalDialog.Close();

            _dialogContainer.DialogProxyServicesDictionary.TryGetValue(_dialogId, out var x);
            x.DialogInstance = null;
            _myProxyService = x;
            //_myProxyService.DialogInstance = null;
            Console.WriteLine($"after close {_myProxyService.DialogInstance?.ToString()}");
            await Task.Delay(200);
            //ShowDialog = "";
            //ShowBackdrop = false;
            //_myProxyService.DialogInstance = null;
            //await InvokeAsync(StateHasChanged);

        }

        public virtual async Task OpenDialog()
        {
            await ModalDialog.Open();
            //ShowDialog = "show";
            //ShowBackdrop = true;
            //await InvokeAsync(StateHasChanged);
        }

        public void Dispose()
        {
            _dialogContainer.DialogClient.MessageReceivedDialogClose -= OnCloseDialogMessage;
            _dialogContainer.DialogClient.MessageReceivedDialogOpen -= OnOpenDialogMessage;
        }

    }
}
