CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC

        _startInspection : BOOL := FALSE;

        _inspectors : Inspectors;
      
    END_VAR


    METHOD PROTECTED OVERRIDE Main
        _inspectors.Initialize(THIS);

        IF _startInspection THEN
            _inspectors.Run();
        END_IF;
      
     
    END_METHOD


    
END_CLASS

