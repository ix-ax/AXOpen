using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Dialogs;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
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
    public partial class AxoDialogBaseView<T> : RenderableComplexComponentBase<T>, IAsyncDisposable where T : AxoDialogBase
    {

        [Inject]
        public AxoDialogContainer _dialogContainer { get; set; }
        [Inject]
        public NavigationManager _navigationManager { get; set; }


        private string _dialogId;
        private DialogClient _dialogClient { get; set; }

        private AxoDialogProxyService _dialogService{ get; set; }
        protected async override Task OnInitializedAsync()
        {

            _dialogId = Component.DialogId;
            //_dialogService
            //_dialogClient = new DialogClient(_navigationManager.BaseUri);
            _dialogContainer.DialogClient.MessageReceivedDialogClose += OnCloseDialogMessage;
            _dialogContainer.DialogClient.MessageReceivedDialogOpen += OnOpenDialogMessage;
            Console.WriteLine("Concrete initialized");


            //_dialogService.DialogInvoked += OnDialogInvoked;
            //await _dialogClient.StartAsync();
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

        private async Task Close()
        {
            ShowDialog = "";
            ShowBackdrop = false;
            //_dialogService.DialogInstance = null;


            await InvokeAsync(StateHasChanged);
            await Task.Delay(500);
        }


        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                Console.WriteLine("First render");
                await Close();
                await OpenDialog();
            }


        }

        public bool ShowBackdrop { get; set; }
        public string ShowDialog { get; set; }
        public virtual async Task CloseDialog()
        {
            await _dialogContainer.DialogClient.SendDialogClose(_dialogId);

        }

        public virtual async Task OpenDialog()
        {

            ShowDialog = "fade show";
            ShowBackdrop = true;
            await InvokeAsync(StateHasChanged);
        }
       

        public async void OnDialogInvoked(object sender, AxoDialogEventArgs e)
        {
            //Console.Write(e.DialogId);
            Console.WriteLine($"Invoke caught 2, ID: {e.DialogId}");
            await OpenDialog();

        }


        public async ValueTask DisposeAsync()
        {
            //_dialogService.DialogInvoked -= OnDialogInvoked;
            if (_dialogClient != null)
            {
                await _dialogClient.StopAsync();
            }
        }
    }
}
