# 📦 Column Data in a DistributedDataView (Blazor)

The `DistributedDataView` displays data fragments dynamically.  
To control how each fragment's columns are displayed, you must define configurations using the `AxoDataExchangeConfigurationService`.

To use the `DistributedDataView`, you must register and configure the required services.

---

### ✅ Register Services

Register the exchange configuration service along with the distributed data service in your `Program.cs` file:

[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=DistributedDataServices)]

---

### ⚙️ Configure Exchange Columns

Define how columns should be displayed for each POCO type.  
As shown in the example below, you can also specify a custom template for each column:

[!code-csharp[ConfigurationOfColumnService](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=AxoDataExchangeConfigurationService)]

> [!IMPORTANT]  
> Column templates receive the value via the `PropertyValue` parameter, which is of type `object`.  
> To safely work with the expected type, cast the value inside the component’s `OnParametersSet()` method.

---

### 🎨 Custom Column Template

When creating column configurations, you can assign a custom Razor component to render a specific column.  
The component will receive the property value of the POCO and display it as needed:

[!code-csharp[ColumnRazorTemplate](../app/ix-blazor/librarytemplate.blazor/Templates/CustomBoolTemplate.razor)]
