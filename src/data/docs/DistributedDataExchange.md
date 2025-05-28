# 📦 Distributed Data View (Blazor)

![Custom columns](assets/DistributedView.png)

The `DistributedDataView` is dynamic component for dispalying data from IDistributedDataExchangeService in a Blazor application.
---

# Usage (Blazor)

[!code-smalltalk[](../app/ix-blazor/librarytemplate.blazor/Pages/DistributedData.razor?name=BlazorViewDistributedData)]


### Parameters:
- GroupName: Group of data fragments to display ("default").

- ConfigSuffix: Enable extend the name of AxoDataExchange configuration for the same type (Usable in a case, you need special columns,sorting ...).

- Presentation: Data rendering mode ("Command", "Status", etc.).

- EnableExport: Allows exporting data from fragments.

- EnableSorting: Enables sorting in .

- DisplayOnePerDataType: Only one fragment per DataExchange type.

---
# Prerequisites (.Net)

### Register services
Register services in your 'Program.cs' file
[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=DistributedDataServices)]

### Collect AxoDataExchanges
[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=CollectingExchanges)]


### Ordering AxoDataExchanges
To define the **main exchange** for a group, use the following code in your Program.cs:
[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=DistributedGroupOrder)]

### Fill up exchange configuration
[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=AxoDataExchangeConfigurationService)]
     
---
# Prerequisites (Ax)
To enable automatic collection of data exchanges, you must use the appropriate attribute in your PLC code, like this:  
[!code-csharp[](../app/src/Examples/AxoDataDistributedExample.st?name=UseDistributedDataAttribute)]

     
