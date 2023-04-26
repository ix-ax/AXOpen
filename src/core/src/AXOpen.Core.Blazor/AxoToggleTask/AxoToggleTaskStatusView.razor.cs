using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoToggleTaskStatusView
    { 
        private string description;
        [Parameter]
        public string Description
        {
            get
            {
                return description ?? Component.AttributeName;
            }
            set
            {
                if (!string.IsNullOrEmpty(value)) 
                {
                    description = value;
                }
            }
               
        }
    }
}
