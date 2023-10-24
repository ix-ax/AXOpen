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
        _testDrive.Run(parent:=THIS,
                        refParameter_In     :=  REF(PlcInputs^.ST3_indradrive_ParamCh_IDN_1),
                        refFieldbus_In      :=  REF(PlcInputs^.ST3_indradrive_Input_9_Words_1),
                        refParameter_Out    :=  REF(PlcOutputs^.ST3_indradrive_ParamCh_IDN_1),
                        refFieldbus_Out     :=  REF(PlcOutputs^.ST3_indradrive_Output_13_Words_1),
                        Enable              :=  TRUE,
                        EnablePositive      :=  TRUE,
                        EnableNegative      :=  TRUE);
    END_METHOD
END_CLASS
          

  

 
          
  
  