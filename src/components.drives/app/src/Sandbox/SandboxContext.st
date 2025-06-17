NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl  :   BOOL;          
            _AxisRef        :   AxoDriveAxisReferenceExample;
            _rootObject     :   AxoObject; 
            _testDrive      :   AXOpen.Components.Drives.AxoDriveExample;  
        END_VAR
        

        METHOD PROTECTED OVERRIDE Main  
            THIS.InitializeRootObject(_rootObject);
            IF(_manualControl) THEN            
                _testDrive.ActivateManualControl();
            END_IF;   
            _testDrive.Run(parent           :=  _rootObject,
                            AxisRef         :=  _AxisRef,
                            Enable          :=  TRUE,
                            EnablePositive  :=  TRUE,
                            EnableNegative  :=  TRUE);
        END_METHOD
    END_CLASS
END_NAMESPACE            

    

    
            
    
    
