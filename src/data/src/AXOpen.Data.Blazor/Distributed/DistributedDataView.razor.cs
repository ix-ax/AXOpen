using AXOpen.Base.Data.Query;
using AXOpen.Base.Dialogs;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.JSInterop;
using Operon.Components.Toast;
using Pocos.AXOpen.Data;
using System.Globalization;

namespace AXOpen.Data

{
    public partial class DistributedDataView
    {
        [Parameter, EditorRequired]
        public string Presentation { get; set; } = "Command";

        [Parameter, EditorRequired]
        public bool DisplayOnePerDataType { get; set; }

        [Parameter, EditorRequired]
        public string GroupName { get; set; }

        [Parameter] public string ConfigSuffix { get; set; } = "";

        [Parameter] public bool EnableCreate { get; set; } = false;
        [Parameter] public bool EnableCopy { get; set; } = false;
        [Parameter] public bool EnableDelete { get; set; } = false;
        [Parameter] public bool EnableSendToPlc { get; set; } = false;
        [Parameter] public bool EnableCreateNewFromPlc { get; set; } = false;
        //[Parameter] public bool EnableUpdateFromPlc { get; set; } = false;

        [Parameter] public bool EnableFiltering { get; set; } = false;
        [Parameter] public bool EnableExport { get; set; } = false;
        [Parameter] public bool EnableSorting { get; set; } = false;


        [Parameter] public List<string>? ExternalEntityIds { get; set; }
        [Parameter] public PredicateContainer? ExternalPredicates { get; set; }


        [Inject]
        public IJSRuntime JSRuntime { set; get; }

        [Inject]
        public AuthenticationStateProvider Authentication { set; get; }

        [Inject]
        public IToastService ToastService { get; set; }

        [Inject]
        public IDistributedDataExchangeService DistributedExchangeService { set; get; }

        [Inject]
        public IAxoDataExchangeConfigurationService? ExchangeConfigService { set; get; }


        public DistributedDataViewModel DistributedVM { set; get; }

        protected override async Task OnInitializedAsync()
        {
            await base.OnInitializedAsync();

            if (string.IsNullOrEmpty(Presentation)) Presentation = "Status";

            if (string.IsNullOrEmpty(GroupName))
            {
                GroupName = "default";
            }

            if (DistributedExchangeService.IsExistGroup(GroupName))
            {
                this.DistributedVM = new DistributedDataViewModel(
                    this.ToastService,
                    this.Authentication,
                    this.DistributedExchangeService,
                    this.ExchangeConfigService,
                    this.GroupName,
                    this.DisplayOnePerDataType,
                    this.ConfigSuffix,
                    this.ExternalEntityIds,
                    this.ExternalPredicates
                    );

                this.DistributedVM.StateHasChangedDelegate = StateHasChanged;
            }
            else
            {
                throw new Exception($"DistributedExchangeService does not contain requested group \"{GroupName}\"!");
            }
        }

    }
}
