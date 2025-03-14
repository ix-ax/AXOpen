using AXOpen.Base.Dialogs;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.JSInterop;
using System.Globalization;

namespace AXOpen.Data

{
    public partial class DistributedDataView
    {
        [Parameter, EditorRequired]
        public string Presentation { get; set; }

        [Parameter, EditorRequired]
        public bool DisplayOnePerDataType { get; set; }

        [Parameter, EditorRequired]
        public string GroupName { get; set; }

        [Parameter]
        public string ConfigSuffix { get; set; } = "";

        [Inject]
        public IAlertService AlertService { get; set; }

        [Inject]
        public AuthenticationStateProvider Authentication { set; get; }

        [Inject]
        public IDistributedDataExchangeService DistributedExchangeService { set; get; }

        [Inject]
        public IJSRuntime JSRuntime { set; get; }

        [Inject]
        public IDataExchangeConfigurationProvider? ConfigurationProvider { set; get; }

        public List<IAxoDataExchange> DataFragments { set; get; }

        public DistributedDataViewModel DistributedViewModel { set; get; }

        protected override async Task OnInitializedAsync()
        {
            await base.OnInitializedAsync();

            if (string.IsNullOrEmpty(Presentation)) Presentation = "Status";

            if (string.IsNullOrEmpty(GroupName))
            {
                GroupName = "default";
            }

            if (DataFragments != null) this.DataFragments.Clear();

            if (DistributedExchangeService.Exchanges.ContainsKey(GroupName))
            {
                if (DisplayOnePerDataType)
                {
                    this.DataFragments = DistributedExchangeService.GetMangersForGroup(GroupName);
                }
                else
                {
                    this.DataFragments = DistributedExchangeService.Exchanges[GroupName];
                }

                var firstManager = DataFragments.First();
            }

            this.DistributedViewModel = new DistributedDataViewModel();
        }

    }
}