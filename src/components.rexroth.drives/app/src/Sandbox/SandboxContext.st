USING AXOpen.Components.Rexroth.Drives;

CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        _testCyclinder : AXOpen.Pneumatics.Cylinder;        
        _testDrive  : AXOpen.Components.Rexroth.Drives.AxoIndraDrive;
    END_VAR

    VAR PRIVATE
        _homeSensor : BOOL;
        _workSensor : BOOL;
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
        _refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
        _refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis
    END_VAR    

    METHOD PROTECTED OVERRIDE Main
        _testCyclinder.Run(THIS, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);
        _testDrive.Run(THIS,_refAxisIn,_refAxisOut,TRUE,TRUE,TRUE);

        IF(_manualControl) THEN
            _testCyclinder.ActivateManualControl();
            _testDrive.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS