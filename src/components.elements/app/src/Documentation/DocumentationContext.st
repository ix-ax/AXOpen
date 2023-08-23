CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC        
        //cyclinder : AXOpen.Pneumatics.Cylinder;        
    END_VAR

    VAR PRIVATE
        _homeSensor : BOOL;
        _workSensor : BOOL;
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
    END_VAR    

    METHOD PROTECTED OVERRIDE Main
        ;//cyclinder.Run(THIS, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);        
    END_METHOD
END_CLASS