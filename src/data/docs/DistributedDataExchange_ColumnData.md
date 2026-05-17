# 📦 Column Data in a DistributedDataView (Blazor)

The `DistributedDataView` displays data fragments dynamically.  
To control how each fragment's columns are displayed, you must define configurations using the `AxoDataExchangeConfigurationService`.

To use the `DistributedDataView`, you must register and configure the required services.

---

### ✅ Register Services

Register the exchange configuration service along with the distributed data service in your `Program.cs` file:

[!code-csharp[](../../showcase/app/docs-snippets/data-blazor/Program.cs?name=DistributedDataServices)]

---

### ⚙️ Configure Exchange Columns

Define how columns should be displayed for each POCO type.  
As shown in the example below, you can also specify a custom template for each column:

[!code-csharp[ConfigurationOfColumnService](../../showcase/app/docs-snippets/data-blazor/Program.cs?name=AxoDataExchangeConfigurationService)]


[!include[](ColumnCellTemplate.md)]

