using AngleSharp.Text;
using AXOpen.Base.Data.Query;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.IO.Enumeration;
using System.Linq.Expressions;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using System.Text.Json;

namespace AXOpen.Data
{
    public partial class DataEntitySelector : IDisposable
    {
        [Parameter]
        public IEnumerable<string> Elements { get; set; }

        [Parameter]
        public string SelectdValue { get; set; }

        [Parameter]
        public EventCallback<string> SelectdValueChanged { get; set; }

        public Guid ViewGuid { get; } = new Guid();

        private string _Filter = "";

        public string Filter // string that contains the symbol
        {
            set
            {
                if (_Filter != value)
                {
                    _Filter = value;
                    UpdateFilteredList();
                }
            }

            get
            {
                return _Filter;
            }
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            TotalCount = Elements.Count();
            FilterAsync().GetAwaiter();
        }

        public async Task UpdateFilteredList()
        {
            await FilterAsync();
            this.StateHasChanged();
        }

        public int TotalCount { set; get; } // all symbols from query
        public int FilteredPage { set; get; }// displaing only selected page
        public int FilteredPageLimit { set; get; } = 5;// displaing only selected page

        private int MaxPage =>
       (int)(TotalCount % FilteredPageLimit == 0 ? TotalCount / FilteredPageLimit - 1 : TotalCount / FilteredPageLimit);

        public List<string> FilteredElements { private set; get; } = new List<string>();

        private List<string> _DisplyedElements = new List<string>();

        private volatile object _displayLock = new object();

        public List<string> GetDisplaySymbols()
        {
            var symbolList = new List<string>();

            lock (_displayLock)
            {
                symbolList.AddRange(_DisplyedElements);
            }

            return symbolList;
        }

        private Task FillDisplayedElements()
        {
            return Task.Run(() =>
            {
                _DisplyedElements.Clear();

                _DisplyedElements.AddRange(
                    FilteredElements.Skip(FilteredPage * FilteredPageLimit).Take(FilteredPageLimit)
                    );
            });
        }

        private async Task SetLimitAsync(int limit)
        {
            var oldLimit = FilteredPageLimit;
            FilteredPageLimit = limit;

            FilteredPage = FilteredPage * oldLimit / FilteredPageLimit;

            await FillDisplayedElements();
        }

        private async Task SetPageAsync(int page)
        {
            FilteredPage = page;
            await FillDisplayedElements();
        }

        private int Modulo(int x, int m)
        {
            if (m == 0) return 0; // avoid exception caused by % 0
            var r = x % m;
            return r < 0 ? r + m : r;
        }

        private async Task FilterAsync()
        {
            await InvokeAsync(() =>
            {
                var query = Elements.Where(s => string.IsNullOrEmpty(Filter) || s.Contains(Filter, StringComparison.OrdinalIgnoreCase)).ToList();
                TotalCount = query.Count;
                FilteredElements = query;
            });

            await FillDisplayedElements();
        }

        private async Task SelectElement(string selectdValue)
        {
            SelectdValue = selectdValue;
            await SelectdValueChanged.InvokeAsync(selectdValue);
        }

        public void Dispose()
        {
            ;
        }
    }
}