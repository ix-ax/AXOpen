## Column cell template (Blazor)

When creating column configurations, you can assign a custom Razor template to render a specific value.  
The template will receive the property value of the POCO and display it as needed.

Customn template must inherits from `AXOpen.Data.ColumnDataCellBase`.

> [!IMPORTANT]  
> Column cell template receive the value via the `PropertyValue` parameter, which is of type `object`.  
> To safely work with the expected type, cast the value inside the component’s `OnParametersSet()` method.

---

### 🎨 Template example

[!code-csharp[ColumnRazorTemplate](../app/ix-blazor/librarytemplate.blazor/Templates/CustomBoolTemplate.razor)]
