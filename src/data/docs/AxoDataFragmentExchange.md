# AxoDataFragmentExchange

Fragment data exchange allows to group of multiple data managers into a single object and perform repository operations jointly on all nested repositories.

## Getting started

### Data fragment exchange manager

Data exchange object must be extended by `AxoDataFragmentExchange`.

[!code-smalltalk[](../app/src/Examples/AxoDataFragmentExchangeExample.st?name=AxoProcessDataManagerDeclaration)]

**Nesting AxoDataExchanger(s)**

AxoDataFragmenExchange can group several data managers where each can point to a different repository. Nested data managers must be set up as explained [here](AxoDataExchange.md#data-exchange-manager).

> [!NOTE]
> Note that each data manager must be annotated with `AXOpen.Data.AxoDataFragmentAttribute` that will provide information to the parent manager that the member takes part in data operations.

> [!IMPORTANT]
> First data manager declared as a fragment is considered a master fragment. The overview and list of existing data are retrieved only from the master fragment.

### Initialization and handling in the controller

We will now need to create an instance of `AxoDataFragmentExchange` in a context object (`AxoContext`) (or as a member of another class that derives from `AxoObject`). We will also need to call `AxoDataFragmentExchangeContext` in the Main method of appropriate context.

[!code-smalltalk[](../app/src/Examples/AxoDataFragmentExchangeExample.st?name=ContextDeclaration)]

Execute run method in CU

[!code-smalltalk[](../app/src/Examples/AxoDataExchangeExample.st?name=Execute)]

Use in Automat Sequence

[!code-smalltalk[](../app/src/Examples/AxoDataExchangeExample.st?name=Run)]

### Data exchange initialization in .NET

At this point, we have everything ready in the PLC.

If the nested data exchange object does not have the repository set previously, we will need to tell the to fragment manager wich repositories we be used by in data exchange. We will work with data stored in files in JSON format.

[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=SetUpAxoDataFragmentExchange)]

> [!NOTE]
> `MyData` should be of type from `Pocos`.
