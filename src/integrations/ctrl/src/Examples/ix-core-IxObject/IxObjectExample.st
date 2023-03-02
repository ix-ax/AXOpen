USING ix.framework.core;

NAMESPACE IxObjectExamples
//<IxContext>
    CLASS PUBLIC MyContext EXTENDS IxContext
        VAR
            _myObject : IxObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            _myObject.Initialize(THIS);            
        END_METHOD
    END_CLASS
//</IxContext>
//<IxObject>
    CLASS PUBLIC MyParentObject  EXTENDS IxContext
        VAR
            _myChildObject  : IxObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            _myChildObject.Initialize(THIS);            
        END_METHOD
    END_CLASS
//</IxObject>
END_NAMESPACE