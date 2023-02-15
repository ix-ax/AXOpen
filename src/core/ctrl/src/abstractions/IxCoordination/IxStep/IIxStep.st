NAMESPACE ix.framework.core
    INTERFACE IIxStep EXTENDS IIxTask
        METHOD GetStepOrder : ULINT END_METHOD
        METHOD SetStepOrder VAR_INPUT coord : IIxCoordinator; StepOrder : ULINT; END_VAR END_METHOD
        METHOD IsCalledJustOnceInThisPlcCycle : BOOL END_METHOD
        METHOD SetIsActive VAR_INPUT Active : BOOL; END_VAR END_METHOD
        METHOD GetIsActive : BOOL END_METHOD
        METHOD SetIsEnabled  VAR_INPUT Enabled : BOOL; END_VAR END_METHOD
        METHOD GetIsEnabled : BOOL END_METHOD
    END_INTERFACE
END_NAMESPACE
