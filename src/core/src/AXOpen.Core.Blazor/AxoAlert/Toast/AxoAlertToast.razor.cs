using AXOpen.Base.Dialogs;
using Microsoft.AspNetCore.Components;
using System;

namespace AXOpen.Core.Blazor.AxoAlertDialog
{
    public partial class AxoAlertToast : ComponentBase, IDisposable
    {

        [Inject]
        public IAlertService DialogService { get; set; }
                
        //[Parameter]
        //public IAlertService ParameterDialogService { get; set; }


        private void AlertDialogChanged(object? sender, EventArgs e) => InvokeAsync(StateHasChanged);

        //protected override void OnInitialized()
        //{
        //    //if(ParameterDialogService != null)
        //    //{
        //    //    DialogService = ParameterDialogService;
        //    //}

        //}

        protected override void OnAfterRender(bool firstRender)
        {
            if (firstRender)
            {
                DialogService!.AlertDialogChanged += AlertDialogChanged;
            }
        }

        private string GetTime(DateTimeOffset time)
        {
            var calcTime = -(time - DateTimeOffset.Now);
            if (calcTime.TotalSeconds < 5)
            {
                return "just now";
            }
            else if (calcTime.TotalSeconds < 60)
            {
                return $"{Math.Round(calcTime.TotalSeconds)} secs ago";
            }
            else
            {
                return $"{Math.Round(calcTime.TotalMinutes)} mins ago";
            }
        }

        public void Dispose()
        {
            if (DialogService != null)
            {
                DialogService!.AlertDialogChanged -= AlertDialogChanged;
            }
        }

    }
}
