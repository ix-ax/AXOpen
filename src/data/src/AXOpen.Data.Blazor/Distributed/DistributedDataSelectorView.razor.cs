using AXOpen.Base.Data;
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
    public partial class DistributedDataSelectorView
    {
        [Parameter, EditorRequired]
        public string GroupName { get; set; }

        [Parameter]
        public string ConfigSuffix { get; set; } = "";

        [Parameter]
        public PredicateContainer? InjectedPredicateContainer { set; get; }

        [Parameter]
        public Action<string>? OnDataSend { get; set; }

        [Parameter]
        public bool EnableCurrentView { get; set; }

        [Parameter]
        public bool DisableUserRoles { get; set; }

        [Parameter]
        public int MinPaginationLimit { get; set; } = 25;


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

        public DistributedDataSelectorViewModel DistributedVM { set; get; }
        public AxoDataExchangeConfiguration ExchangeConfig { get; set; } = new();

        public bool IsDropdownOpen { set; get; } = false;
        public bool IsCurrentIdsDropdownOpen { set; get; } = false;
        public string BtnOperation { get; set; } = string.Empty;
        public IBrowsableDataObject SelectedEntity { get; set; }


        protected override async Task OnInitializedAsync()
        {
            await base.OnInitializedAsync();

            if (DistributedExchangeService.IsExistGroup(GroupName))
            {
                IEnumerable<IAxoDataExchange> DataFragments;

                DataFragments = DistributedExchangeService.GetExchanges(GroupName, false);

                if (DataFragments != null)
                {
                    DistributedVM = new DistributedDataSelectorViewModel(ToastService, Authentication, DistributedExchangeService, GroupName, InjectedPredicateContainer);

                    DistributedVM.FilteredPageLimit = this.MinPaginationLimit;

                    await DistributedVM.ReadAllCurrentEntityIds();
                    await DistributedVM.FillObservableRecordsAsync();

                    if (DistributedVM.AllExchangesHasTheSameId())
                    {
                        var id = (DistributedVM.MainExchange.DataExchangeTwinObject as IAxoDataEntity)._EntityId.Cyclic;
                        this.SelectedEntity = DistributedVM.MainExchange.GetRecords(id, 1, 0, eSearchMode.Exact, "", false).First();
                    }

                    ConfigSuffix = string.IsNullOrEmpty(ConfigSuffix) ? string.Empty : ConfigSuffix;

                    ExchangeConfig = ExchangeConfigService.GetConfigution(DistributedVM.MainExchange, ConfigSuffix);
                }
            }
            else
            {
                throw new Exception($"DistributedExchangeService does not contain requested group \"{GroupName}\"!");
            }
        }

        public string GetCurrentDataEntityId(IAxoDataExchange ex)
        {
            string ret = "";

            if (ex != null)
            {
                IAxoDataEntity entity = (ex.DataExchangeTwinObject as IAxoDataEntity);

                if (entity != null)
                {
                    ret = entity._EntityId.Cyclic;
                }
            }

            return ret;
        }


        private void ToggleDropdown()
        {
            IsCurrentIdsDropdownOpen = false; // enable only one
            IsDropdownOpen = !IsDropdownOpen;
        }

        private void ToggleCurrentIdsDropdown()
        {
            IsDropdownOpen = false; // enable only one
            IsCurrentIdsDropdownOpen = !IsCurrentIdsDropdownOpen;
        }

        private void SelectEntity(IBrowsableDataObject rec)
        {
            SelectedEntity = rec;
            IsDropdownOpen = false;
        }

        public void EndBtnOperation()
        {
            this.BtnOperation = "";
        }

        public bool IsAnyActiveOperation()
        {
            return !string.IsNullOrEmpty(this.BtnOperation);
        }

        public bool IsNoActiveOperation()
        {
            return string.IsNullOrEmpty(this.BtnOperation);
        }
        private Task SendToPlc()
        {
            if (this.SelectedEntity == null) return Task.CompletedTask;

            return DistributedVM.SendToPlc(this.SelectedEntity._EntityId);
        }

        public int Limit
        {
            set
            {
                DistributedVM.FilteredPageLimit = value;
                DistributedVM.FillObservableRecordsAsync();
            }
            get
            {
                return DistributedVM.FilteredPageLimit;
            }
        }

        public int Page
        {
            set
            {
                DistributedVM.FilteredPage = value;
                DistributedVM.FillObservableRecordsAsync();
            }
            get
            {
                return DistributedVM.FilteredPage;
            }
        }

        private async Task PageSizeAndSelectedChangedAsync(int pageSize, int selected)
        {
            DistributedVM.FilteredPageLimit = pageSize;
            DistributedVM.FilteredPage = selected;
            await DistributedVM.FillObservableRecordsAsync();
        }
    }
}