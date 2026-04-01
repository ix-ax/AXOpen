NAMESPACE AXOpen.Showcase.Pneumatics

    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoObject
        //<DeclarationAndHWIO_Assignement>
        VAR PUBLIC
            CylinderParent : AXOpen.Core.AxoObject;
            myAxoCylinder : AXOpen.Components.Pneumatics.AxoCylinder;
            inSensorSignal : BOOL;
            outSensorSignal : BOOL;
            moveInSignal : BOOL;
            moveOutSignal : BOOL;
        END_VAR
        //</DeclarationAndHWIO_Assignement>

        //<Pneumatic_Run>
        METHOD PUBLIC Execute
            CylinderParent.Run(THIS);
            myAxoCylinder.Run(  CylinderParent,
                                inSensorSignal,
                                outSensorSignal,
                                moveInSignal,
                                moveOutSignal);
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
