namespace AXOpen.VisualComposer.Types
{
    public class TransformType
    {
        public TransformType() { }
        private TransformType(string value, double x, double y) { Value = value; X = x; Y = y; }

        public string Value { get; private set; } = "TopCenter";
        public double X { get; private set; } = -50;
        public double Y { get; private set; } = 0;

        public static TransformType TopLeft { get { return new TransformType("TopLeft", 0, 0); } }
        public static TransformType TopCenter { get { return new TransformType("TopCenter", -50, 0); } }
        public static TransformType TopRight { get { return new TransformType("TopRight", -100, 0); } }
        public static TransformType CenterLeft { get { return new TransformType("CenterLeft", 0, -50); } }
        public static TransformType CenterCenter { get { return new TransformType("CenterCenter", -50, -50); } }
        public static TransformType CenterRight { get { return new TransformType("CenterRight", -100, -50); } }
        public static TransformType BottomLeft { get { return new TransformType("BottomLeft", 0, -100); } }
        public static TransformType BottomCenter { get { return new TransformType("BottomCenter", -50, -100); } }
        public static TransformType BottomRight { get { return new TransformType("BottomRight", -100, -100); } }

        public static TransformType[] AllTypes { get; } = new TransformType[]
        {
            TopLeft,
            TopCenter,
            TopRight,
            CenterLeft,
            CenterCenter,
            CenterRight,
            BottomLeft,
            BottomCenter,
            BottomRight
        };

        public override string ToString()
        {
            return Value;
        }

        public static TransformType? FromString(string value)
        {
            return AllTypes.Where(x => x.Value == value).FirstOrDefault();
        }
    }
}
