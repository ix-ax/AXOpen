using AXOpen.Base.Dialogs;
using AXOpen.Core;
using AXOpen.Data;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace axosimple.server.Components
{
    public partial class Unit : RenderableComplexComponentBase<axosimple.IUnit>
    {
        [Inject]
        public IAlertDialogService _alerts { set; get; }

        private AxoMessageProvider _axoMessageProvider;
        private AxoMessageProvider AxoMessageProvider
        {
            get
            {
                if(_axoMessageProvider == null) _axoMessageProvider = AxoMessageProvider.Create(AllVisualItems);
                return _axoMessageProvider;
            }
            
        }

        [Parameter, BindRequired]
        public AXOpen.Data.AxoDataEntity? Data { get; set; }

        [Parameter]
        public AXOpen.Data.AxoDataEntity? DataHeader { get; set; }

        [Parameter]
        public AXOpen.Data.AxoDataExchangeBase? DataManger { get; set; }

        [Parameter]
        public AXOpen.Data.AxoDataEntity? TechnologySettings { get; set; }

        [Parameter]
        public AXOpen.Data.AxoDataEntity? SharedTechnologySettings { get; set; }

        [Parameter]
        public AxoObject? UnitComponents { get; set; }

        [Parameter]
        public IEnumerable<ITwinObject>? AditionalItems { get; set; } // Items that are passed into VisualComposer

        private ITwinObject[] _allVisualItems = null;

        public ITwinObject[] AllVisualItems
        {
            get
            {
                if (_allVisualItems == null)
                {
                    var objList = new List<ITwinObject>()
                    {
                        this.Data,
                        this.DataManger,
                        this.TechnologySettings,
                        base.Component,
                        this.UnitComponents
                    };

                    if (this.AditionalItems != null)
                    {
                        foreach (var item in this.AditionalItems)
                        {
                            objList.Add(item);
                        }
                    }

                    _allVisualItems = objList.ToArray();
                }

                return _allVisualItems;
            }
        }

        public bool EnableModalComponents { set; get; }
        public bool EnableModalProductionData { set; get; }
        public bool EnableModalProcessSettings { set; get; }
        public bool EnableModalTechnologySettings { set; get; }

        private void ShowModalComponents()
        {
            EnableModalComponents = true;
        }

        private void HideModalComponents()
        {
            EnableModalComponents = false;
        }

        private void ShowModalProductionData()
        {
            EnableModalProductionData = true;
        }

        private void HideModalProductionData()
        {
            EnableModalProductionData = false;
        }

        private void ShowModalProcessSettings()
        {
            EnableModalProcessSettings = true;
        }

        private void HideModalProcessSettings()
        {
            EnableModalProcessSettings = false;
        }

        private void ShowModalTechnologySettings()
        {
            EnableModalTechnologySettings = true;
        }

        private void HideModalTechnologySettings()
        {
            EnableModalTechnologySettings = false;
        }
    }
}