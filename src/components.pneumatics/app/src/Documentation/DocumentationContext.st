
CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
//<DeclarationAndHWIO_Assignement>
    VAR PUBLIC        
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          
        CylinderParent : AXOpen.Core.AxoObject;
        myAxoCylinder : AXOpen.Components.Pneumatics.AxoCylinder;        
    END_VAR
//</DeclarationAndHWIO_Assignement>
//<Pneumatic_Run>
    METHOD PROTECTED OVERRIDE Main        
        CylinderParent.Initialize(THIS);
        myAxoCylinder.Run(  CylinderParent, 
                        PlcInputs^.ET200SP_DI_8x24VDC_ST_V1_1_1.%X0, 
                        PlcInputs^.ET200SP_DI_8x24VDC_ST_V1_1_1.%X1, 
                        PlcOutputs^.ET200SP_DQ_8x24VDC_0_5A_ST_V1_1_1.%X0, 
                        PlcOutputs^.ET200SP_DQ_8x24VDC_0_5A_ST_V1_1_1.%X0); 
    END_METHOD
//</Pneumatic_Run>
END_CLASS


CLASS AnotherDocumentationContext EXTENDS DocumentationContext
    VAR 
        _suspendHomeCondition : BOOL;
        _suspendWorkCondition : BOOL;
        _abortHomeCondition : BOOL;
        _abortWorkCondition : BOOL;
    END_VAR

    METHOD Examples
        //<MoveToHome>
        IF myAxoCylinder.MoveToHome().IsDone() THEN
            ;
        END_IF;
        //</MoveToHome>

        //<MoveToWork>
        IF myAxoCylinder.MoveToWork().IsDone() THEN
            ;
        END_IF;
        //</MoveToWork>

        //<Stop>
        IF myAxoCylinder.Stop().IsDone() THEN
            ;
        END_IF;
        //</Stop>

        //<SuspendMoveToHomeWhile>
        myAxoCylinder.SuspendMoveToHomeWhile(_suspendHomeCondition);
        //</SuspendMoveToHomeWhile>

        //<SuspendMoveToWorkWhile>
        myAxoCylinder.SuspendMoveToWorkWhile(_suspendWorkCondition);
        //</SuspendMoveToWorkWhile>

        //<AbortMoveToHomeWhen>
        myAxoCylinder.AbortMoveToHomeWhen(_abortHomeCondition);
        //</AbortMoveToHomeWhen>

        //<AbortMoveToWorkWhen>
        myAxoCylinder.AbortMoveToWorkWhen(_abortWorkCondition);
        //</AbortMoveToWorkWhen>
    END_METHOD
END_CLASS
