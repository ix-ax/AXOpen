{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;          
        PlcInputs : ARRAY [0..10] OF BYTE;
        PlcOutputs : ARRAY [0..10] OF BYTE;          
        _testDrive  : AXOpen.Components.Drives.AxoDriveExample;  
    END_VAR
    

    METHOD PROTECTED OVERRIDE Main  
        IF(_manualControl) THEN            
            _testDrive.ActivateManualControl();
        END_IF;   
        _testDrive.Run(parent:=THIS,
                        refAxisIn           :=  REF(PlcInputs),
                        refAxisOut          :=  REF(PlcOutputs),
                        Enable              :=  TRUE,
                        EnablePositive      :=  TRUE,
                        EnableNegative      :=  TRUE);
    END_METHOD
END_CLASS
          

  

 
          
  
  
