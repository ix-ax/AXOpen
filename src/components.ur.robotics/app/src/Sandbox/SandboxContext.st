NAMESPACE AXOpen.Components.Ur.Robotics
        
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl : BOOL;
            PowerOnImpulse : BOOL;         
            movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;

            _testRobot     :  AXOpen.Components.Ur.Robotics.AxoUrCb3_v_3_x_x;
            _rootObject :   AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            RETURN;
            THIS.InitializeRootObject(_rootObject);

            _testRobot.Run(     inParent                                                  := _rootObject,
                                hwID                                                    := HwIdentifiers#ureol2l_HwID,
                                refPowerOnPulse                                         := REF (PowerOnImpulse));

            IF(_manualControl) THEN
                _testRobot.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE
