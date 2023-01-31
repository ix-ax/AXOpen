# **ix.core**

**ix.core** provides basic blocks for building ix.framework applications.

# Basic concepts

## Context

Context encapsulates entire application or application units. Any solution may contain one or more contexts, however the each should be considered to be an isolated island and any **direct inter-context access to members must be avoided**.

**IMPORTANT** Each context must belong to a single PLC task. Multiple contexts can be however running on the same task.


```mermaid
  classDiagram
    class Context{
        #Main()*
        +Execute()
    }
```

In its basic implementation context has relatively simple interface. The main method is the method where we place all calls of our sub-routines. **In other words the `Main` is the root of the call tree of our program.**

`Execute` method runs the context. It must be called cyclically within a program unit that is attached to a cyclic `task`.

### Why do we need context

 `Context` provides counters, object identification and other information about the execution of the program. These information is then used by the objects contained at different levels of the context.

### How context works

When you call `Execute` method on an instance of a context, it will ensure opening context, running `Main` method (root of all your program calls) and context closing.


```mermaid
  flowchart LR
    id1(Open)-->id2(#Main*)-->id3(Close)-->id1(Open)
    style id1 fill:#fff,stroke:#333,stroke-width:2px
    style id2 fill:#000,stroke:#f66,stroke-width:2px
    style id3 fill:#fff,stroke:#333,stroke-width:4px

```

### How to use context

Base class for the context is `ix.core.Context`. The entry point of call execution of the context is `Main` method. Notice that the `context` class is abstract and cannot be instantiated if not extended. `Main` method must be overridden in derived class notice the use of override keyword and also that the method is `protected` which means the it is visible only from within the `Context` and derived classes.

 
 **How to extend Context class**

~~~iecst

USING ix.core

CLASS PUBLIC MyContext EXTENDS Context
    METHOD PROTECTED OVERRIDE Main
        // Here goes all your logic for given context.
    END_METHOD
END_CLASS
~~~

Cyclical call of the context logic (`Main` method) is ensured when context `Execute` method is called. `Execute` method is public therefore accessible and visible to any part of the program that whishes to call it.

**How to start context's execution**

~~~iecst
PROGRAM MyProgram
    VAR
        _myContext : MyContext;
    END_VAR

    _myContext.Execute();
END_PROGRAM
~~~



## Object

Object is the base class for any other classes of ix.framework. It provides access to the parent object and the context in which it was initialized.


```mermaid
  classDiagram
    class Object{
        +Initialize(IContext context)
        +Initialize(IObject parent)        
    }     
```

**Object initialization within a context**

~~~iecst
    CLASS PUBLIC MyContext EXTENDS ix.core.Context
        VAR
            _myObject : ix.core.Object;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            _myObject.Initialize(THIS);            
        END_METHOD
    END_CLASS
~~~

**Object initialization within another object**

~~~iecst
    CLASS PUBLIC MyParentObject EXTENDS ix.core.Object
        VAR
            _myChildObject : ix.core.Object;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            _myChildObject.Initialize(THIS);            
        END_METHOD
    END_CLASS
~~~