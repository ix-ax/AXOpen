using Microsoft.AspNetCore.Components;

namespace AXOpen.Data
{
    public class ColumnDataCellBase : ComponentBase
    {
        [Parameter]
        public object PropertyValue { set; get; }
    }
}