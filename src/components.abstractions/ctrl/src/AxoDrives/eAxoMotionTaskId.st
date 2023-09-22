NAMESPACE AXOpen.Components.Abstractions.AxoDrives
    TYPE PUBLIC
        eAxoMotionTaskId :
        (		
            Axo_Power,
            Axo_Home,
            Axo_Stop,
            Axo_Halt,
            Axo_MoveAbsolute,
            Axo_MoveRelative,
            Axo_MoveAdditive,
            Axo_MoveSuperimposed,           (*Not implemented yet *)
            Axo_HaltSuperimposed,           (*Not implemented yet *)
            Axo_MoveVelocity,
            Axo_MoveContinuousAbsolute,     (*Not implemented yet *)
            Axo_MoveContinuousRelative,     (*Not implemented yet *)
            Axo_TorqueControl,
            Axo_PositionProfile,            (*Not implemented yet *)
            Axo_VelocityProfile,            (*Not implemented yet *)
            Axo_AccelerationProfile,        (*Not implemented yet *)
            Axo_SetPosition,
            Axo_SetOverride,
            Axo_ReadParameter,
            Axo_ReadBoolParameter,
            Axo_WriteParameter,
            Axo_WriteBoolParameter,
            Axo_ReadDigitalInput,
            Axo_ReadDigitalOutput,
            Axo_WriteDigitalOutput,
            Axo_ReadActualPosition,
            Axo_ReadActualVelocity,
            Axo_ReadActualTorque,
            Axo_ReadStatus,
            Axo_ReadMotionState,
            Axo_ReadAxisInfo,
            Axo_ReadAxisError,
            Axo_Reset,
            Axo_DigitalCamSwitch,           (*Not implemented yet *)
            Axo_TouchProbe,                 (*Not implemented yet *)
            Axo_AbortTrigger                (*Not implemented yet *)
        );
    END_TYPE
END_NAMESPACE