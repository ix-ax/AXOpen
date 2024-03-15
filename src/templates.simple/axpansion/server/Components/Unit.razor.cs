using AXOpen.Base.Dialogs;
using AXOpen.Core;
using AXOpen.Data;
using AXOpen.Messaging.Static;
using AXOpen.Messaging.Static.Blazor;
using axosimple.server.Units;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace axosimple.server.Components
{
    public partial class Unit 
    {
        [Inject]
        public IAlertService _alerts { set; get; }
        
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