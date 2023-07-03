using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public partial class AxoDialogBaseView<T> : RenderableComplexComponentBase<T>, IAsyncDisposable
    {

        [Inject]
        public AxoDialogProxyService _dialogService { get; set; }
        [Inject]
        public NavigationManager _navigationManager { get; set; }


        private DialogClient _dialogClient { get; set; }

        protected async override Task OnInitializedAsync()
        {
            _dialogClient = new DialogClient(_navigationManager.BaseUri);
            _dialogClient.MessageReceivedDialogClose += OnCloseDialogMessage;
            Console.WriteLine("Concrete initialized");


            _dialogService.DialogInvoked += OnDialogInvoked;
            await _dialogClient.StartAsync();
        }
        private async void OnCloseDialogMessage(object sender, MessageReceivedEventArgs e)
        {
            await Close();
        }

        private async Task Close()
        {
            ShowDialog = "";
            ShowBackdrop = false;
            _dialogService.DialogInstance = null;


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
            await _dialogClient.SendDialogClose("1");

        }

        public virtual async Task OpenDialog()
        {
            ShowDialog = "fade show";
            ShowBackdrop = true;
            await InvokeAsync(StateHasChanged);

        }
       

        public async void OnDialogInvoked()
        {
            Console.WriteLine("Invoke caught 2");
            await OpenDialog();

        }


        public async ValueTask DisposeAsync()
        {
            _dialogService.DialogInvoked -= OnDialogInvoked;
            if (_dialogClient != null)
            {
                await _dialogClient.StopAsync();
            }
        }
    }
}
