CLASS SandboContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        // Logger : AXOpen.Logging.AxoLogger;
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
        {#ix-attr:[Container(Layout.Stack)]}
        {#ix-set:AttributeName = "<#Test cylinder#>"}
        _testCyclinder : AXOpen.Components.Pneumatics.AxoCylinder;        
    END_VAR

    VAR PRIVATE
        _homeSensor : BOOL;
        _workSensor : BOOL;
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
    END_VAR    

    METHOD PROTECTED OVERRIDE Main
        // THIS.InjectLogger(Logger);
        // Logger.SetMinimumLevel(AXOpen.Logging.eLogLevel#Verbose);
        _testCyclinder.SuspendMoveToWorkWhile(_suspendMoveToWork);
        _testCyclinder.SuspendMoveToHomeWhile(_suspendMoveToHome);
        _testCyclinder.AbortMoveToWorkWhen(_abortMoveToWork);
        _testCyclinder.AbortMoveToHomeWhen(_abortMoveToHome);
        _testCyclinder.Run(THIS, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);
        IF(_manualControl) THEN
            _testCyclinder.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS