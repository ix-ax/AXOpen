using AXSharp.Presentation;
using Microsoft.AspNetCore.Components;

namespace VmT
{
    public class VMTestServiceViewModel : RenderableViewModelBase
    {
        public VMTestServiceViewModel()
        {
        }
        public VmTest Component { get; set; }
        public override object Model { get => this.Component; set { this.Component = value as VmTest; } }

        public void CreateToast()
        {
            //DialogService.CreateToast(this);
            //_toastService.AddToast("Success", "Test", "test", 30);
        }
    }
}