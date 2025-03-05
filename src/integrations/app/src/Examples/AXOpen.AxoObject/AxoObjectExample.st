USING AXOpen.Core;

NAMESPACE AxoObjectExamples
//<AxoContext>
    {S7.extern=ReadWrite}
    CLASS PUBLIC MyContext EXTENDS  AXOpen.Core.AxoContext
        VAR
            _myObject : AxoObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_myObject);
        END_METHOD
    END_CLASS
//</AxoContext>
//<AxoObject>
    {S7.extern=ReadWrite}
    CLASS PUBLIC MyParentObject  EXTENDS AxoContext
        VAR
            _myChildObject  : AxoObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_myChildObject);
        END_METHOD
    END_CLASS
//</AxoObject>
END_NAMESPACE
