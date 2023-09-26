# AxoContext

AxoContext encapsulates entire application or application units. Any solution may contain one or more contexts, however the each should be considered to be an isolated island and any **direct inter-context access to members must be avoided**.


>[!NOTE] 
>Each AxoContext must belong to a single PLC task.Multiple AxoContexts can be however running on the same task.


```mermaid
  classDiagram
    class Context{
        +Main()*
        +Run()        
    }     
```

In its basic implementation AxoContext has relatively simple interface. `Main` is the method where we place all calls of our sub-routines. **In other words the `Run` is the root of the call tree of our program.**

`Run` method runs the AxoContext. It must be called cyclically within a program unit that is attached to a cyclic `task`.

## Why do we need AxoContext

 `AxoContext` provides counters, object identification and other information about the execution of the program. These information is then used by the objects contained at different levels of the AxoContext.

## How AxoContext works

When you call `Run` method on an instance of a AxoContext, it will ensure opening AxoContext, running `Main` method (root of all your program calls) and AxoContext closing.


```mermaid
  flowchart LR
    classDef run fill:#80FF00,stroke:#0080FF,stroke-width:4px,color:#7F00FF,font-size:15px,font-weight:bold                                                      
    classDef main fill:#ff8000,stroke:#0080ff,stroke-width:4px,color:#7F00FF,font-size:15px,font-weight:bold                                                                                                           
    id1(Open):::run-->id2(#Main*):::main-->id3(Close):::run-->id1
```

## How to use AxoContext

Base class for the AxoContext is `AXOpen.Core.AxoContext`. The entry point of call execution of the AxoContext is `Main` method. Notice that the `AxoContext` class is abstract and cannot be instantiated if not extended. `Main` method must be overridden in derived class notice the use of override keyword and also that the method is `protected` which means the it is visible only from within the `AxoContext` and derived classes.


 **How to extend AxoContext class**

[!code-smalltalk[](../app/src/Examples/AXOpen.AxoContext/AxoContextExample.st?name=Declaration)]


Cyclical call of the AxoContext logic (`Main` method) is ensured when AxoContext `Run` method is called. `Run` method is public therefore accessible and visible to any part of the program that whishes to call it.

**How to start AxoContext's execution**

[!code-smalltalk[](../app/src/Examples/AXOpen.AxoContext/AxoContextExample.st?name=Implementation)]