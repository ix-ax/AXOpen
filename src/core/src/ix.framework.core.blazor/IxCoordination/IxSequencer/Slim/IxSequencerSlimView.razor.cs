using Ix.Connector;
using Microsoft.AspNetCore.Components;

namespace ix.framework.core
{
    public partial class IxSequencerSlimView : IDisposable
    {
        private bool isControllable;

        [Parameter]
        public bool IsControllable
        {
            get
            {
                return isControllable;
            }
            set
            {
                isControllable = value;
            }
        }

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
        }
        public void Dispose()
        {
            Component.StopPolling();
        }
    }
}
