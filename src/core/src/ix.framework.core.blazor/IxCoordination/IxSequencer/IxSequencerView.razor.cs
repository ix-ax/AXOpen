using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class IxSequencerView : IDisposable
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
