using Microsoft.AspNetCore.Components;

namespace ix.framework.core
{
    public partial class IxTaskCommandSlimView 
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

        private bool hideRestoreButton;
        [Parameter]
        public bool HideRestoreButton
        {
            get
            {
                return hideRestoreButton;
            }
            set
            {
                hideRestoreButton = value;
            }
        }
    }
}
