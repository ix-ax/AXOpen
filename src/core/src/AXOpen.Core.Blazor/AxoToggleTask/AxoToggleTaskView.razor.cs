using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoToggleTaskView : IDisposable
    {
        private string description;
        private void ToggleTask()
        {
            Component.RemoteToggle.Cyclic = true;
        }

        //private string ButtonClass = "btn-primary";
        private void UpdateTaskColor(object sender, EventArgs e)
        {
            //switch (Component.State.LastValue)
            //{
            //    //case eAxoTaskState.Done:
            //    //    ButtonClass = "btn-success";
            //    //    break;
            //    //case eAxoTaskState.Error:
            //    //    ButtonClass = "btn-danger";
            //    //    break;
            //    default:
            //        ButtonClass = "btn-primary";
            //        break;
            //}
        }

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            UpdateTaskColor(this, new EventArgs());
            Component.State.PropertyChanged += UpdateTaskColor;
        }

        public void Dispose()
        {
            Component.State.PropertyChanged -= UpdateTaskColor;
            Component.StopPolling();
        }

        [Parameter]
        public bool IsDisabled { get; set; }

        [Parameter]
        public string Description
        {
            get
            {
                return description;
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
