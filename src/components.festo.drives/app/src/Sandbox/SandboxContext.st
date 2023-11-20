USING AXOpen.Components.Festo.Drives;

CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        {#ix-attr:[Container(Layout.Wrap)]}
        _manualControl  : BOOL := TRUE;          
        _enable         : BOOL := TRUE;          
        _enablePositive : BOOL := TRUE;          
        _enableNegative : BOOL := TRUE;          
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          
        {#ix-attr:[Container(Layout.Stack)]}
        _testDrive  : AXOpen.Components.Festo.Drives.AxoCmmtAsDrive;
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
                        Enable              :=  _enable,
                        EnablePositive      :=  _enablePositive,
                        EnableNegative      :=  _enableNegative);
    END_METHOD
END_CLASS
          

  

 
          
  
  