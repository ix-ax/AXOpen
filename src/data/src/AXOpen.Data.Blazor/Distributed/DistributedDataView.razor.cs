using AXOpen.Base.Dialogs;
using Humanizer.DateTimeHumanizeStrategy;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.JSInterop;
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

        [Parameter]
        public string ConfigSuffix { get; set; } = "";

        [Parameter]
        public bool EnableExport { get; set; } = true;

        [Parameter]
        public bool EnableSorting { get; set; } = true;

        [Inject]
        public IAlertService AlertService { get; set; }

        [Inject]
        public AuthenticationStateProvider Authentication { set; get; }

        [Inject]
        public IDistributedDataExchangeService DistributedExchangeService { set; get; }

        [Inject]
        public IJSRuntime JSRuntime { set; get; }

        [Inject]
        public IAxoDataExchangeConfigurationService? ExchangeConfigService { set; get; }

        public string BtnOperation {  get; set; } = string.Empty;
        public string SelectedEntityId { get; set; } = string.Empty;
        public string OperationRecordName {  get; set; } = string.Empty;

        public bool AdvanceFilterConfig { get; set; } = false;

        public DistributedDataViewModel DistributedVM { set; get; }

        protected override async Task OnInitializedAsync()
        {
            await base.OnInitializedAsync();

            if (string.IsNullOrEmpty(Presentation)) Presentation = "Status";

            if (string.IsNullOrEmpty(GroupName))
            {
                GroupName = "default";
            }

            if (DistributedExchangeService.Exchanges.ContainsKey(GroupName))
            {
                IEnumerable<IAxoDataExchange> DataFragments;

                if (DisplayOnePerDataType)
                {
                    DataFragments = DistributedExchangeService.GetMangersForGroup(GroupName);
                }
                else
                {
                    DataFragments = DistributedExchangeService.Exchanges[GroupName];
                }

                if (DataFragments != null)
                {
                    this.DistributedVM = new DistributedDataViewModel(DataFragments, this.AlertService, this.Authentication, this.ExchangeConfigService);
                    this.DistributedVM.StateHasChangedDelegate = StateHasChanged;
                }
            }
        }

        public void EndBtnOperation()
        {
            this.BtnOperation = "";
            this.SelectedEntityId = "";
            this.OperationRecordName = "";
        }

        public bool IsAnyActiveOperation()
        {
            return !string.IsNullOrEmpty(this.BtnOperation);
        }
        public bool IsNoActiveOperation()
        {
            return string.IsNullOrEmpty(this.BtnOperation);
        }
    }
}