using AXSharp.Connector;

namespace Pocos.Exchange_Test_L4
{
    public class NulableAxoDataEntity : Pocos.AXOpen.Data.AxoDataEntity
    {
        public PlainDataWithNulableProperties? NulableObject { get; set; }

        [CustomExcludeAttribute]
        public PlainDataWithNulableProperties? ExcludedNulableObject { get; set; } 
    }

    public class PlainDataWithNulableProperties : IPlain
    {
        public string? NulableString { get; set; }
    }

    public class CustomExcludeAttribute : Attribute
    {
    }

}