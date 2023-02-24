using Ix.Connector;
using Microsoft.AspNetCore.Components;

namespace ix.framework.core
{
    public partial class IxSequencerView 
    {
        private bool _isControllable;

        [Parameter]
        public bool IsControllable
        {
            get
            {
                return _isControllable;
            }
            set
            {
                _isControllable = value;
            }
        }
    }
}
