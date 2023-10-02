USING AXOpen.Components.Rexroth.Drives;

CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;          
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          
        _testDrive  : AXOpen.Components.Rexroth.Drives.AxoIndraDrive;
    END_VAR
    

    METHOD PROTECTED OVERRIDE Main  
        IF(_manualControl) THEN            
            _testDrive.ActivateManualControl();
        END_IF;   
        _testDrive.Run(THIS,REF(PlcInputs^._7600_Results_64_bytes_1),REF(PlcOutputs^._7600_User_Data_64_bytes_1),TRUE,TRUE,TRUE);
    END_METHOD
END_CLASS