USING AXOpen.Components.Festo.Drives;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        {#ix-attr:[Container(Layout.Wrap)]}
        _manualControl  : BOOL := TRUE;          
        _enable         : BOOL := TRUE;          
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          

        {#ix-attr:[Container(Layout.Stack)]}
        _testDrive  : AXOpen.Components.Festo.Drives.AxoCmmtAsPtP;
    END_VAR
    

    METHOD PROTECTED OVERRIDE Main  
        IF(_manualControl) THEN            
            _testDrive.ActivateManualControl();
        END_IF;   
        _testDrive.Run(parent               :=  THIS,
                        refTelegram111_In   :=  REF(PlcInputs^.Tel111In),
                        refTelegram750_In   :=  REF(PlcInputs^.Tel750In),
                        refTelegram111_Out  :=  REF(PlcOutputs^.Tel111Out),
                        refTelegram750_Out  :=  REF(PlcOutputs^.Tel750Out),
                        MAP_HW_ID           :=  264,
                        Enable              :=  _enable);
        
    END_METHOD
END_CLASS
          

  