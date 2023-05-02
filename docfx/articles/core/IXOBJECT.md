# IxObject

IxObject is the base class for any other classes of AXOpen. It provides access to the parent IxObject and the IxContext in which it was initialized.


```mermaid
  classDiagram
    class Object{
        +Initialize(IIxContext context)
        +Initialize(IIxObject parent)        
    }     
```

**IxObject initialization within a IxContext**
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxObject/IxObjectExample.st?name=IxContext)]

**IxObject initialization within another IxObject**
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxObject/IxObjectExample.st?name=IxObject)]
