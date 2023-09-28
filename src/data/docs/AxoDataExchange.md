# AxoDataExchange

## Getting started

### Data exchange manager

Data exchange object must be extended by `AxoDataExchange`.

[!code-smalltalk[](../app/src/Examples/AxoDataExchangeExample.st?name=AxoProcessDataManagerDeclaration)]

### Data exchange object

The data entity variable must be created. It contains data that we want to exchange between PLC and repository. This variable must be annotated with following attributes:

- `AxoDataEntityAttribute` -- unique attribute for finding a correct instance of data exchange.
- `#ix-generic:TOnline` -- type information attribute.
- `#ix-generic:TPlain as POCO` -- type information attribute.

> [!NOTE]
> The `AxoDataExchange` object must be unique. Annotations `AxoDataEntityAttribute`, `#ix-generic:TOnline` and `#ix-generic:TPlain as POCO` must be attributed to only one member `AxoDataExchange` object, which is used to locate data object that contains data to be exchanged between PLC and the target repository. 
An exception is thrown when `AxoDataEntityAttribute` is missing or multiple members have the annotation.

> [!NOTE]
> The 'Data' variable must be of a type that extends `AxoDataEntity`.

[!code-smalltalk[](../app/src/Examples/AxoDataExchangeExample.st?name=AxoProcessDataDeclaration)]

### Data exchange initialization in PLC

As mentioned earlier, we use remote calls to execute the CRUD operations. These calls are a variant of `AxoTask`, which allows for invoking a C# code. We will now need to create an instance of `AxoProcessDataManager` in a context object (`AxoContext`) (or as a member of another class that derives from `AxoObject`). We will also need to call `DataManager` in the Main method of appropriate context.

[!code-smalltalk[](../app/src/Examples/AxoDataExchangeExample.st?name=ContextDeclaration)]

Execute run method in CU

[!code-smalltalk[](../app/src/Examples/AxoDataExchangeExample.st?name=Execute)]

Use in Automat Sequence

[!code-smalltalk[](../app/src/Examples/AxoDataExchangeExample.st?name=Run)]

### Data exchange initialization in .NET

At this point, we have everything ready in the PLC.

We must now tell the `DataManager` what repository to use. As a example, data repository is set as JSON files.

Let's create a configuration for the repository and initialize remote data exchange:

[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=SetUpAxoDataExchange)]

> [!NOTE]
> `MyData` should be of type from `Pocos`.
