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
    public partial class AxoDialogBaseView<T> : RenderableComplexComponentBase<T>, IDisposable
    {

        [Inject]
        public AxoDialogProxyService _dialogService { get; set; }

        protected async override Task OnInitializedAsync()
        {

            Console.WriteLine("Concrete initialized");


            _dialogService.DialogInvoked += OnDialogInvoked;
            _dialogService.HasConcreteEventHandlerInitialized = true;

        }

        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                await CloseDialog();
                await OpenDialog();
            }


        }

        public bool ShowBackdrop { get; set; }
        public string ShowDialog { get; set; }
        public virtual async Task CloseDialog()
        {
            ShowDialog = "";
            ShowBackdrop = false;
       
            if (_dialogService.DialogInstance != null)
                _dialogService.DialogInstance.Show = false;

            _dialogService.DialogInstance = null;

            await InvokeAsync(StateHasChanged);
            await Task.Delay(500);

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
            _dialogService.DialogInstance.Show = true;
            await OpenDialog();
            //await InvokeAsync(StateHasChanged);

        }

        public void Dispose()
        {
            _dialogService.DialogInvoked -= OnDialogInvoked;
        }
    }
}
