using AXSharp.Connector;

namespace AXOpen.Data
{
    public class ValueItemDescriptor
    {

        public ValueItemDescriptor()
        {

        }

        public ValueItemDescriptor(ITwinPrimitive valueTag)
        {
            this.HumanReadable = valueTag.HumanReadable;
            this.Symbol = valueTag.Symbol;
        }
        public string HumanReadable { get; set; }
        public string Symbol { get; set; }
    }
}
