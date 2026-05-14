using AXOpen.VisualComposer.Components.VisualComposerItem;

namespace AXOpen.VisualComposer.Serializing
{
    public class SerializableControllerObjectsOptions : SerializableItem
    {
        public bool OptionsMove { get; set; }
        public int OptionsMoveDirection { get; set; }
        public double OptionsMoveBottom { get; set; }
        public double OptionsMoveRight { get; set; }
        public bool CustomPresentation { get; set; }

        public SerializableControllerObjectsOptions()
        {
            
        }

        public SerializableControllerObjectsOptions(VisualComposerItemData visualComposerItemData, bool optionsMove, int optionsMoveDirection, double optionsMoveBottom, double optionsMoveRight, bool customPresentation) : base(visualComposerItemData)
        {
            OptionsMove = optionsMove;
            OptionsMoveDirection = optionsMoveDirection;
            OptionsMoveBottom = optionsMoveBottom;
            OptionsMoveRight = optionsMoveRight;
            CustomPresentation = customPresentation;
        }
    }
}
