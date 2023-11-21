CLASS SandboContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        {#ix-attr:[Container(Layout.UniformGrid)]}
        {#ix-set:AttributeName = "<#Suspend move to work#>"}
        _suspendMoveToWork : BOOL;
        {#ix-set:AttributeName = "<#Suspend move to home#>"}
        _suspendMoveToHome : BOOL;

        {#ix-attr:[Container(Layout.UniformGrid)]}
        {#ix-set:AttributeName = "<#Abort move to work#>"}
        _abortMoveToWork : BOOL;
        {#ix-set:AttributeName = "<#Abort move to home#>"}
        _abortMoveToHome : BOOL;

        {#ix-attr:[Container(Layout.UniformGrid)]}
        {#ix-set:AttributeName = "<#Work sensor simulation#>"}
        _workSensor : BOOL;
        {#ix-set:AttributeName = "<#Home sensor simulation#>"}
        _homeSensor : BOOL;
        {#ix-attr:[Container(Layout.Stack)]}
        {#ix-set:AttributeName = "<#Test cylinder#>"}
        _testCylinder : AXOpen.Components.Pneumatics.AxoCylinder;        
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;       
        
        CylinderParent : AXOpen.Core.AxoObject;
    END_VAR

    VAR PRIVATE
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
    END_VAR    

    METHOD PROTECTED OVERRIDE Main
        CylinderParent.Initialize(THIS);
        _testCylinder.SuspendMoveToWorkWhile(_suspendMoveToWork);
        _testCylinder.SuspendMoveToHomeWhile(_suspendMoveToHome);
        _testCylinder.AbortMoveToWorkWhen(_abortMoveToWork);
        _testCylinder.AbortMoveToHomeWhen(_abortMoveToHome);
        _testCylinder.Run(CylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);
        IF(_manualControl) THEN
            _testCylinder.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS