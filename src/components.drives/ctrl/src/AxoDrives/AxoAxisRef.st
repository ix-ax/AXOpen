USING AXOpen.Core;
NAMESPACE AXOpen.Components.Drives

    INTERFACE IAxisReference
        
    END_INTERFACE

    {S7.extern=ReadWrite}
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

    {S7.extern=ReadWrite}
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

