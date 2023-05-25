# AxoDataFragmentExchange

Fragment data exchange allows to group of multiple data managers into a single object and perform repository operations jointly on all nested repositories.

### Data fragment exchange manager

We must create a class extending the `AxoDataFragmentExchange` for the data fragment exchange to work. 

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoData/AxoDataFragmentExchangeDocu.st?name=ProcessDataMangerDeclaration)]

**Nesting AxoDataExchanger(s)**

AxoDataFragmenExchange can group several data managers where each can point to a different repository. Nested data managers must be set up as explained [here](AxoDataExchange.md#data-exchange-manager). 

> [!NOTE]
> Note that each data manager must be annotated with `AXOpen.Data.AxoDataFragmentAttribute` that will provide information to the parent manager that the member takes part in data operations.

> [!IMPORTANT]
> First data manager declared as a fragment is considered a master fragment. The overview and list of existing data are retrieved only from the master fragment.

### Initialization and handling in the controller

We will now need to create an instance of `AxoDataFragmentExchange` in a context object (`AxoContext`) (or as a member of another class that derives from `AxoObject`). We will also need to call `AxoDataFragmentExchangeContext` in the Main method of appropriate context.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoData/AxoDataFragmentExchangeDocu.st?name=ContextDeclaration)]

Instantiate context in a configuration
~~~
CONFIGURATION MyConfiguration
    VAR_GLOBAL
        _myContext : AxoDataFragmentExchangeContext;       
    END_VAR
END_CONFIGURATION
~~~

Execute the context in a program.
~~~
PROGRAM MAIN
VAR_EXTERNAL
    _myContext : AxoDataFragmentExchangeContext;
END_VAR

_myContext.Run();

~~~

### Data exchange initialization in .NET

At this point, we have everything ready in the PLC.

If the nested data exchange object does not have the repository set previously, we will need to tell the to fragment manager wich repositories we be used by in data exchange. We will work with data stored in files in JSON format.


[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Program.cs?name=AxoDataFragmentedExampleDocuIntialization)]

> [!NOTE]
> `MyData` should be of type from `Pocos`.


### Usage

Now we can freely shuffle the data between PLC and the local folder.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoData/AxoDataFragmentExchangeDocu.st?name=UseManager)]

## Data visualization

### Automated rendering using `RenderableContentControl`

With `Command` presentation type, options exist for adding, editing, and deleting records.

[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/DocuExamples/AxoDataFragmetsDocuExamples.razor?name=CommandView)]

![Command](~/images/Command.png)

If you use `Status` presentation type, data will be only displayed and cannot be manipulated.

[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/DocuExamples/AxoDataFragmetsDocuExamples.razor?name=DisplayView)]

![Status](~/images/Status.png)

### Custom columns

There is a possibility to add custom columns if it is needed. You must add `AXOpen.Data.ColumnData` view as a child in `DataView`. The `BindingValue` must be set in `ColumnData` and contains a string representing the attribute name of custom columns. If you want to add a custom header name, you can set the name in `HeaderName` attribute. Also, there is an attribute to make the column not clickable, which is clickable by default. The example using all attributes:


[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/DocuExamples/AxoDataFragmetsDocuExamples.razor?name=CustomColumns)]

When adding data view manually, you will need to create ViewModel:

[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/DocuExamples/AxoDataFragmetsDocuExamples.razor?name=CustomColumnsCode)]


![Custom columns](~/images/CustomColumns.png)

> [!NOTE]
> Custom columns can only added from master fragment (first declared repository).

### Modal detail view

The Detail View is default shown like modal view. That means if you click on some record, the modal window with a detail view will be shown. If necessary, this option can be changed with `ModalDetailView` attribute. This change will show a detail view under the record table. Example with `ModalDetailView` attribute:

~~~
<DataExchangeView Vm="@ViewModel.DataViewModel" Presentation="Command" ModalDetailView="false" />
~~~

![Not Modal detail view](~/images/NotModalDetailView.png)
