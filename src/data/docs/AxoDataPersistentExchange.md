# AxoDataPersistentExchange

Persistent data exchange allows grouping of multiple primitive variables or properties assigned by an attribute into tag lists, on which repository operations can be performed.

## Getting started

### Label requested variable as a Persistent

Anywhere in the structured code, use the persistent attribute "Persistent("PersistentGroupName")" to mark a variable as persistent.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=PersistentAttribute)]

### Make instance of Persistent exchange manager

Create instance of the manager and call it in the Context.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=ContextDeclaration)]

> [!NOTE]
> Note that you can use multiple instance of persistent manager, that can operate on different root object that is initialized on .net side.

### Usage in the controller

In the case of saving, call the Update() method in the PLC, and in the case of loading, call the Read() method.

[!code-smalltalk[](../app/src/Examples/AxoDataPersistentExchangeExample.st?name=Usage)]

### Data exchange initialization in .NET

At this point, we have everything ready in the PLC.

An instance of Persistent Manager requires additional parameters for initialization. It needs to set up a repository where the data will be saved. The next parameter is the root object of the PLC tree, from which it starts collecting persistent variables.

[!code-csharp[](../app/ix-blazor/librarytemplate.blazor/Program.cs?name=SetUpAxoDataPersistentExchange)]
