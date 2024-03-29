﻿using AXOpen.VisualComposer.Types;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using AXSharp.Connector;
using Newtonsoft.Json.Linq;

namespace AXOpen.VisualComposer
{
    public partial class VisualComposerItem
    {
        private VisualComposerContainer? _parent;

        [CascadingParameter(Name = "Parent")]
        protected VisualComposerContainer? Parent
        {
            get => _parent;
            set
            {
                _parent = value;

                if (value != null)
                    value.AddChildren(this);
            }
        }

        [CascadingParameter(Name = "ImgId")]
        private Guid _imgId { get; set; }

        [Parameter]
        public VisualComposerItem? Origin
        {
            set
            {
                UniqueGuid = value.UniqueGuid;
                TwinElement = value.TwinElement;
                ratioImgX = value.ratioImgX;
                ratioImgY = value.ratioImgY;
                Transform = value.Transform;
                Presentation = value.Presentation;
                Width = value.Width;
                Height = value.Height;
                ZIndex = value.ZIndex;

                Id = value.TwinElement.HumanReadable.Replace(".", "_").Replace(" ", "_");
            }
        }

        [Inject]
        protected IJSRuntime js { get; set; }
        private IJSObjectReference? jsModule;

        public ITwinElement? TwinElement { get; set; }
        public string Id { get; set; }
        public Guid? UniqueGuid { get; set; } = null;

        private double startX;
        private double startY;

        public double ratioImgX = 10;
        public double ratioImgY = 10;

        public TransformType Transform { get; set; } = TransformType.TopCenter;
        private string _presentation = PresentationType.StatusDisplay.Value;
        public string Presentation
        {
            get => _presentation;
            set
            {
                _presentation = value;
                CustomPresentation = !PresentationType.IsEnumValue(value);
            }
        }
        public bool CustomPresentation { get; set; } = false;

        public double Width = -1;
        public double Height = -1;
        public int ZIndex = 0;

        private void OnDragStart(DragEventArgs args)
        {
            startX = args.ClientX;
            startY = args.ClientY;
        }

        private async void OnDragEnd(DragEventArgs args)
        {
            var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.VisualComposer/VisualComposerItem.razor.js");
            //var windowSize = await jsObject.InvokeAsync<WindowSize>("getWindowSize");
            var imageSize = await jsObject.InvokeAsync<WindowSize>("getImageSize", _imgId);

            double offsetX = startX - (ratioImgX / 100 * imageSize.Width);
            double offsetY = startY - (ratioImgY / 100 * imageSize.Height);

            ratioImgX = ((args.ClientX - offsetX) / imageSize.Width * 100);
            ratioImgY = ((args.ClientY - offsetY) / imageSize.Height * 100);

            StateHasChanged();
        }

        public void Remove()
        {
            Parent.RemoveChildren(this);
        }
    }
}
