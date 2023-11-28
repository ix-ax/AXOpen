USING AXOpen.Core;
NAMESPACE AXOpen.Components.Drives

    INTERFACE IAxisReference
        
    END_INTERFACE

    {S7.extern=ReadWrite}
    CLASS RexrothAxisReference IMPLEMENTS IAxisReference
        VAR PUBLIC
            In          :   AxoAxisRefIn;
            Out         :   AxoAxisRefOut;
            Config      :   AxoDrive_Config;
            Status      :   AxoDrive_Status;
        END_VAR
        
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS AxoAxisRef IMPLEMENTS IAxisReference
        // VAR PUBLIC
        //     In          :   AxoAxisRefIn;
        //     Out         :   AxoAxisRefOut;
        //     Config      :   AxoDrive_Config;
        //     Status      :   AxoDrive_Status;
        // END_VAR
        VAR PRIVATE
            _axref : REF_TO RexrothAxisReference;
        END_VAR    
        METHOD Name : Int            
            VAR_INPUT
               axis : IAxisReference;
            END_VAR    
            _axref ?= axis;
            _axref^.Out.DriveControl :=WORD#4;
        END_METHOD
    END_CLASS

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

