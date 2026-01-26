NAMESPACE AXOpen.Components.Pneumatics

    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    //<DeclarationAndHWIO_Assignement>
        VAR PUBLIC        
            CylinderParent : AXOpen.Core.AxoObject;
            myAxoCylinder : AXOpen.Components.Pneumatics.AxoCylinder;        
        END_VAR
     
    //</DeclarationAndHWIO_Assignement>
    //<Pneumatic_Run>
        METHOD PROTECTED OVERRIDE Main    
            VAR_EXTERNAL        
                Inputs : AXOpen.Components.Pneumatics.Inputs;
                Outputs : AXOpen.Components.Pneumatics.Outputs;          
            END_VAR                   
            THIS.InitializeRootObject(CylinderParent);
            myAxoCylinder.Run(  CylinderParent, 
                            Inputs.plc_line_A1_Input.Channel_00DI, 
                            Inputs.plc_line_A1_Input.Channel_01DI, 
                            Outputs.aes_d_bc_pnio_Slot_1_Output.Signals_0_0,
                            Outputs.aes_d_bc_pnio_Slot_1_Output.Signals_0_1);                             
        END_METHOD
    //</Pneumatic_Run>
    END_CLASS


    {S7.extern=ReadWrite}
    CLASS AnotherDocumentationContext EXTENDS DocumentationContext
        VAR 
            _suspendHomeCondition : BOOL;
            _suspendWorkCondition : BOOL;
            _abortHomeCondition : BOOL;
            _abortWorkCondition : BOOL;
        END_VAR

        METHOD Examples
            //<MoveToHome>
            IF myAxoCylinder.MoveIn().IsDone() THEN
                ;
            END_IF;
            //</MoveToHome>

            //<MoveToWork>
            IF myAxoCylinder.MoveOut().IsDone() THEN
                ;
            END_IF;
            //</MoveToWork>

            //<Stop>
            IF myAxoCylinder.Stop().IsDone() THEN
                ;
            END_IF;
            //</Stop>

            //<SuspendMoveToInWhile>
            myAxoCylinder.SuspendMoveToInWhile(_suspendHomeCondition);
            //</SuspendMoveToInWhile>

            //<SuspendMoveToOutWhile>
            myAxoCylinder.SuspendMoveToOutWhile(_suspendWorkCondition);
            //</SuspendMoveToOutWhile>

            //<AbortMoveToHomeWhen>
            myAxoCylinder.AbortMoveToHomeWhen(_abortHomeCondition);
            //</AbortMoveToHomeWhen>

            //<AbortMoveToWorkWhen>
            myAxoCylinder.AbortMoveToWorkWhen(_abortWorkCondition);
            //</AbortMoveToWorkWhen>
        END_METHOD
    END_CLASS
END_NAMESPACE