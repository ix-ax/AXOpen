USING AXOpen.Core;

NAMESPACE AXOpen.Showcase.Pneumatics

    {S7.extern=ReadWrite}
    CLASS AxoCylinder_Example EXTENDS AXOpen.Core.AxoObject

        //<ComponentDeclaration>
        //<DeclarationAndHWIO_Assignement>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#CYLINDER 1#>"}
            AxoCylinder_ : AXOpen.Components.Pneumatics.AxoCylinder;
        END_VAR
        //</ComponentDeclaration>

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC
            manualControl   : BOOL;
            inHomeSensor    : BOOL;     // TRUE when cylinder is retracted
            inWorkSensor    : BOOL;     // TRUE when cylinder is extended
            outMoveToWork   : BOOL;     // Valve: extend
            outMoveToHome   : BOOL;     // Valve: retract
        END_VAR
        //</InitializationArgumentsDeclaration>
        //</DeclarationAndHWIO_Assignement>

        VAR PUBLIC
            _suspendHomeCondition : BOOL;
            _suspendWorkCondition : BOOL;
            _abortHomeCondition   : BOOL;
            _abortWorkCondition   : BOOL;
        END_VAR

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            IF(manualControl) THEN
                AxoCylinder_.ActivateManualControl();
            END_IF;

            //<SuspendMoveToInWhile>
            AxoCylinder_.SuspendMoveToInWhile(_suspendHomeCondition);
            //</SuspendMoveToInWhile>

            //<SuspendMoveToOutWhile>
            AxoCylinder_.SuspendMoveToOutWhile(_suspendWorkCondition);
            //</SuspendMoveToOutWhile>

            //<AbortMoveToHomeWhen>
            AxoCylinder_.AbortMoveToHomeWhen(_abortHomeCondition);
            //</AbortMoveToHomeWhen>

            //<AbortMoveToWorkWhen>
            AxoCylinder_.AbortMoveToWorkWhen(_abortWorkCondition);
            //</AbortMoveToWorkWhen>

            //<Initialization>
            //<Pneumatic_Run>
            AxoCylinder_.Run(inParent      := THIS,
                             inInSensor    := inHomeSensor,
                             inOutSensor   := inWorkSensor,
                             outMoveInSignal  => outMoveToHome,
                             outMoveOutSignal => outMoveToWork);
            //</Pneumatic_Run>
            //</Initialization>

            //<Usage>
            //<MoveToHome>
            IF AxoCylinder_.MoveIn().IsDone() THEN
                ;// cylinder reached home position
            END_IF;
            //</MoveToHome>

            //<MoveToWork>
            IF AxoCylinder_.MoveOut().IsDone() THEN
                ;// cylinder reached work position
            END_IF;
            //</MoveToWork>

            //<Stop>
            IF AxoCylinder_.Stop().IsDone() THEN
                ;// cylinder stopped
            END_IF;
            //</Stop>
            //</Usage>
        END_METHOD
    END_CLASS

END_NAMESPACE
