USING AXOpen.Core;
NAMESPACE AXOpen.Components.Abstractions.AxoDrives
    CLASS AxoAxisRef
        VAR PUBLIC
            In          :   AxoAxisRefIn;
            Out         :   AxoAxisRefOut;
            Config      :   AxoDrive_Config;
            Status      :   AxoDrive_Status;
            
        END_VAR
    END_CLASS

    CLASS AxoAxisRefIn 
        VAR PUBLIC
            ParameterChannel    :   AxoDriveParameterChannelIdnIn;
            DriveStatus         :   WORD;
            OpModeStatus        :   WORD;
            MotionStatus        :   WORD;
            DriveInputs         :   WORD;
            ActualPosition      :   DINT;
            ActualVelocity      :   DINT;
            ActualTorque        :   DINT;
            DiagnosticMessage   :   DINT;
        END_VAR
    END_CLASS

    CLASS AxoAxisRefOut 
        VAR PUBLIC
            ParameterChannel    :   AxoDriveParameterChannelIdnOut;
            DriveControl        :   WORD;
            OpModeControl       :   WORD;
            ReferenceA          :   DINT;
            ReferenceB          :   DINT;
            Acceleration        :   DINT;
            Decceleration       :   DINT;
        END_VAR
    END_CLASS
END_NAMESPACE

