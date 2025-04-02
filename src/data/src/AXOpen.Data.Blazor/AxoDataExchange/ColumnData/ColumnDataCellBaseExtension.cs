using Microsoft.AspNetCore.Components;

namespace AXOpen.Data
{
    public static class ColumnDataCellBaseExtension
    {
        public static Func<object, RenderFragment> GetRenderFragment(Type razorTemplateType)
        {

            if (razorTemplateType == null)
                return null;

            return (propertyValue) =>
                 {
                     return builder =>
                     {
                         builder.OpenComponent(0, razorTemplateType);
                         builder.AddAttribute(1, "PropertyValue", propertyValue);
                         builder.CloseComponent();
                     };
                 };
        }
    }
}