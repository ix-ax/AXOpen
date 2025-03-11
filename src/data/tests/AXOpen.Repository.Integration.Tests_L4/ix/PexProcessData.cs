namespace Pocos.Exchange_Test_L4
{
    public partial class NestedPrimitives_L3 : AXSharp.Connector.IPlain
    {
        public string? NulableString { get; set; } 
        public long? NulableLong { get; set; }
        public ulong? NulableuLong { get; set; }
        public bool? NulableBool { get; set; }
    }
}