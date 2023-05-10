# AxoObject

AxoObject is the base class for any other classes of AXOpen.Core. It provides access to the parent AxoObject and the AxoContext in which it was initialized.


```mermaid
  classDiagram
    class Object{
        +Initialize(IAxoContext context)
        +Initialize(IAxoObject parent)        
    }     
```

**AxoObject initialization within a AxoContext**
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoObject/AxoObjectExample.st?name=AxoContext)]

**AxoObject initialization within another AxoObject**
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoObject/AxoObjectExample.st?name=AxoObject)]
