# AxoDataPersistentExchange

Persistent data exchange enables the grouping of multiple primitive variables or properties marked with an attribute into tag lists, allowing repository operations to be performed on them.

> [!IMPORTANT]
> The primary purpose is to persist values of selected variables across different levels of the program structure. This ensures data retention during program restarts or memory resets. This approach is ideal for scenarios such as storing identifiers for process data settings or technology parameters that can be reloaded from external repositories or sources at PLC startup.

## Getting started

### Mark the variable as persistent

Anywhere in the structured code, use the persistent attribute `AXOpen.Data.PersistentAttribute("PersistentGroupName")` to mark a variable as persistent.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=PersistentAttribute)]


### Create an instance of the exchange manager
Create an instance of the manager and call its `.Run()` method within the Context.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=ContextDeclaration)]

> [!NOTE]
> You can use multiple instances of the persistent manager, each operating on different root objects initialized on the .NET side. In this case, they can operate independently on both PLC and .NET sides.

### Usage in the controller

To save variables to a repository, call the `InvokeUpdate()` method. It returns `true` if the invocation is successful. To wait for completion, use the `IsUpdateDone()` method.

Other operations such as `InvokeRead`, `InvokeUpdateAll`, `InvokeReadAll`, and `InvokeEntityExist` follow the same pattern. These methods accept an `IAxoObject` parameter, which uses the object's identity to prevent concurrent calls. The object that initiates the first call is prioritized, and subsequent calls from different callers will wait until the first caller completes.

> [!WARNING]
> If the record does not exist, the read operation will fail. Ensure the record exists by either saving it manually or generating a new record before attempting to read.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=ConcurrentUsage)]

### Data exchange initialization in .NET

At this point, we have everything ready in the PLC.

The Persistent Manager instance requires additional initialization parameters. You must configure a repository for data storage and specify the root object of the PLC tree from which persistent variables are collected.

[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=SetUpAxoDataPersistentExchange)]

### Data view 
The DataExchange view is connected to an instance. Therefore, you need to pass the instance through the Context property.

Usage: 
```
<AxoDataPersistentExchangeView Context="@Entry.Plc.Context.Glob.Persits"></AxoDataPersistentExchangeView>
```

### AX Snippet for attribute

```
 "attritubePersistentProperty":
    {
        "prefix": ["attPersistent","persistent"],
        "scope": "st",
        "body":[
        "{#ix-attr:[AXOpen.Data.PersistentAttribute(\"\")]}",
        "$0"
        ],
    "description": "Marks the variable as persistent, enabling CRUD operations through the persistent data exchange manager."
    }
```