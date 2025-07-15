using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using Newtonsoft.Json.Linq;
using AXSharp.Presentation.Blazor.Services;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerItemModal
    {
        [CascadingParameter(Name = "Parent")]
        private VisualComposerContainer? _parent { get; set; }

        [Parameter]
        public VisualComposerItemData Origin { get; set; }

        private bool _customPresentation = false;
        private bool _customPresentationTemplate = false;

        [Inject]
        private ComponentService componentService { get; set; }
        private List<(string key, string? type)> Components { get; set; } = new();

        protected override void OnInitialized()
        {
            Components.Clear();
            foreach (var component in componentService.Components)
            {
                var property = component.Value.BaseType.GetProperty("Component");
                if (property != null)
                    Components.Add((component.Key, property.PropertyType.FullName));
                // else
                //     Components.Add((component.Key, ""));
            }
        }

        protected override void OnAfterRender(bool firstRender)
        {
            if (firstRender)
            {
                Origin.StateHasChangeModalDelegate += StateHasChanged;

                _customPresentation = !PresentationType.IsEnumValue(Origin.Presentation);
            }
        }

        public async Task RemoveAsync()
        {
            await _parent.RemoveItemAsync(Origin);
        }
    }
}
