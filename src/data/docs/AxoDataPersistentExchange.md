# AxoDataPersistentExchange

Persistent data exchange allows the grouping of multiple primitive variables or properties assigned by an attribute into tag lists, on which repository operations can be performed.

> [!IMPORTANT]
> The main goal is to store the values of selected variables that are not on the same level in the program structure. It is important to retain them in case of a program restart. Therefore, this storage is suitable for scenarios such as remembering "only the Identifier" of process data settings or technology data, which can be loaded from another repository or source at startup.

## Getting started

### Label the requested variable as Persistent

Anywhere in the structured code, use the persistent attribute `AXOpen.Data.PersistentAttribute("PersistentGroupName")` to mark a variable as persistent.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=PersistentAttribute)]

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
    "description": "The variable will be flagged as persistent, and the persistent data exchange will handle CRUD operations."
    }
```
### Create an instance of the exchange manager

Create an instance of the manager and call it in the Context.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=ContextDeclaration)]

> [!NOTE]
> Note that you can use multiple instances of the persistent manager, which can operate on different root objects that are initialized on the .NET side.

### Usage in the controller

In the case of saving variables to a repository, call the `InvokeUpdate()` method, which returns `true` if the invocation is successful. To monitor the completion status, use the `IsUpdateDone()` method.

Other operations like `InvokeRead`, `InvokeUpdateAll`, `InvokeReadAll`, and `InvokeEntityExist` follow the same principle. These methods accept an `IAxoObject`, which uses the identity of the object to prevent concurrent calls. The object executing the first call is prioritized, and subsequent calls with a different caller will wait until the first caller has finished.


> [!WARNING]
> If the record does not exist, the loading task will end with an error. Therefore, it is necessary to ensure that the record exists, either by manual saving or by generating a new record.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=Usage)]

### Data exchange initialization in .NET

At this point, we have everything ready in the PLC.

An instance of the Persistent Manager requires additional parameters for initialization. It needs to set up a repository where the data will be saved. The next parameter is the root object of the PLC tree from which it begins collecting persistent variables.

[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=SetUpAxoDataPersistentExchange)]
