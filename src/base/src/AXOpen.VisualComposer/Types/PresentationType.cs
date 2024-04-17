namespace AXOpen.VisualComposer.Types
{
    public class PresentationType
    {
        public PresentationType() { }
        private PresentationType(string value) { Value = value; }

        public string Value { get; private set; } = "Status-Display";

        public static PresentationType CommandControl { get { return new PresentationType("Command-Control"); } }
        public static PresentationType StatusDisplay { get { return new PresentationType("Status-Display"); } }

        public static PresentationType Spot { get { return new PresentationType("Spot"); } }

        public static PresentationType[] AllTypes { get; } = new PresentationType[]
        {
            CommandControl,
            StatusDisplay,
            Spot

        };

        public override string ToString()
        {
            return Value;
        }

        public static PresentationType? FromString(string value)
        {
            return AllTypes.Where(x => x.Value == value).FirstOrDefault();
        }

        public static bool IsEnumValue(string presentation)
        {
            return AllTypes.Any(x => x.Value == presentation);
        }
    }
}
