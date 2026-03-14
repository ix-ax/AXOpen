using AXOpen.Data.Interfaces;
using AXOpen.Data;
using AXSharp.Presentation;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using AXSharp.Connector.ValueTypes.Online;
using AXSharp.Connector;
using System.Linq.Expressions;
using System.Numerics;
using Microsoft.AspNetCore.Components;
using AXOpen.Base.Dialogs;
using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Newtonsoft.Json.Linq;
using System.ComponentModel;
using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Claims;
using AXOpen.Base;
using System.Collections;
using Operon.Components.Toast;
using Properties = AXOpen.Data.Blazor.Properties;

namespace AXOpen.Data
{
    public class AxoDataPersistentExchangeViewModel : RenderableViewModelBase
    {
        public AxoDataPersistentExchange DataExchange
        {
            get;
            private set;
        }

        public override object Model
        {
            get => this.DataExchange;
            set => this.DataExchange = (AxoDataPersistentExchange)value;
        }

        public AxoDataPersistentExchangeViewModel()
        {
        }

        private IToastService _toastService;

        public IToastService ToastService
        {
            get
            {
                if (_toastService == null)
                    throw new Exception("ToastService must be implemented in " + this.ToString());
                return _toastService;
            }
            set
            {
                _toastService = value;
            }
        }

        private PersistentRecord _selectedRecord;

        public PersistentRecord SelectedRecord
        {
            get
            {
                return _selectedRecord;
            }

            set
            {
                _selectedRecord = value;
            }
        }

        public Task FillObservableRecordsAsync()
        {
            return Task.Run(() =>
            {
                IsBusy = true;
                UpdateObservableRecords();
                IsBusy = false;
            });
        }

        public void UpdateObservableRecords()
        {
            this.Filter(FilterById, Limit, Page * Limit, SearchMode).ToList();
        }

        public async Task Filter()
        {
            Page = 0;
            await FillObservableRecordsAsync();
        }

        public IEnumerable<PersistentRecord> Filter(string identifier, int limit = 10, int skip = 0, eSearchMode searchMode = eSearchMode.Exact)
        {
            Records.Clear();

            var recordsIds = FilterIdFromCollected(identifier, limit: limit, skip: skip, searchMode);

            foreach (var id in recordsIds)
            {
                var rec = this.DataExchange.Repository.Read(id);
                this.Records.Add(rec);
            }

            if (SelectedRecord != null)
            {
                var recsWithSameId = Records.Where((p) => p._EntityId == SelectedRecord._EntityId);

                if (recsWithSameId.Any())
                {
                    SelectedRecord = recsWithSameId.First();
                }
                else
                {
                    SelectedRecord = null;
                }
            }

            return Records;
        }

        public IEnumerable<string> FilterIdFromCollected(string identifier, int limit = 10, int skip = 0, eSearchMode searchMode = eSearchMode.Exact)
        {
            IEnumerable<string> enumerable;

            if (string.IsNullOrEmpty(identifier) || string.IsNullOrWhiteSpace(identifier) || identifier == "*")
            {
                enumerable = this.DataExchange.CollectedGroups;
            }
            else
            {
                switch (searchMode)
                {
                    case eSearchMode.StartsWith:
                        enumerable = this.DataExchange.CollectedGroups.Where(p => new FileInfo(p).Name.StartsWith(identifier));
                        break;

                    case eSearchMode.Contains:
                        enumerable = this.DataExchange.CollectedGroups.Where(p => new FileInfo(p).Name.Contains(identifier));
                        break;

                    case eSearchMode.Exact:
                    default:
                        enumerable = this.DataExchange.CollectedGroups.Select(p => new FileInfo(p)).Where(p => p.Name == identifier).Select(p => p.FullName);
                        break;
                }
            }

            return enumerable.Skip(skip).Take(limit);
        }

        public async Task RefreshFilter()
        {
            Limit = 10;
            FilterById = "";
            Page = 0;
            await FillObservableRecordsAsync();
        }

        public async Task SendAllToPlc()
        {
            await DataExchange.WriteAllPersistentGroupsFromRepositoryToPlc();
            await FillObservableRecordsAsync();
            ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Persistent_Data, Properties.AxOpenDataResources.Whole_persistent_data_was_successfully_sent_to_PLC, 10);
        }

        public async Task ReadAllFromPlc()
        {
            await DataExchange.UpdateAllPersistentGroupsToRepository();
            await FillObservableRecordsAsync();
            ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Persistent_Data, Properties.AxOpenDataResources.Whole_persistent_data_was_successfully_read_from_PLC, 10);
        }


        public async Task EnsureThatAllGroupsExistInDatabase()
        {
            foreach (var groupName in DataExchange.CollectedGroups)
            {
                if (!DataExchange.Repository.Exists(groupName))
                {
                    await DataExchange.UpdatePersistentGroupFromPlcToRepository(groupName);

                    ToastService?.AddToast(eToastType.Success, Properties.AxOpenDataResources.Persistent_Data, string.Format(Properties.AxOpenDataResources.Persistent_group_was_successfully_read_from_PLC, groupName), 10);
                }
            }

            this.FilteredCount = DataExchange.CollectedGroups.Count();
        }

        public ObservableCollection<PersistentRecord> Records { get; set; } = new();
        public int Limit { get; set; } = 10;
        public string FilterById { get; set; } = "";
        public eSearchMode SearchMode { get; set; } = eSearchMode.Exact;

        public long FilteredCount { get; set; }
        public int Page { get; set; } = 0;
        public bool IsBusy { get; set; }

        public Action StateHasChangedDelegate { get; set; }
    }
}