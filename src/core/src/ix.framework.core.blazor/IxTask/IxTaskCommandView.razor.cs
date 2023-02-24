using Microsoft.AspNetCore.Components;

namespace ix.framework.core
{
    public partial class IxTaskCommandView 
    {
        private string _description;
        [Parameter]
        public string Description
        {
            get
            {
                return _description ?? Component.AttributeName;
            }
            set
            {
                if (!string.IsNullOrEmpty(value)) 
                {
                    _description = value;
                }
            }
        }
        private bool _hideRestoreButton;
        [Parameter]
        public bool HideRestoreButton
        {
            get
            {
                return _hideRestoreButton;
            }
            set
            {
                _hideRestoreButton = value;
            }
        }
    }
}
