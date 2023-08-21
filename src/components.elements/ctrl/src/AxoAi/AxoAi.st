USING AXOpen.Core;
NAMESPACE AXOpen.Elements
    /// <summary>
    /// Class representing Analog input
    /// </summary>
    CLASS AxoAi EXTENDS AXOpen.Core.AxoComponent


    VAR PUBLIC

        /// configuration for calculations
        {#ix-attr:[Container(Layout.Wrap)]}
        {#ix-attr:[ComponentDetails("Config")]}
        _config : AxoAiConfig;

        /// status of input
        {#ix-attr:[ComponentHeader()]}
        {#ix-attr:[Container(Layout.Wrap)]}
        {#ix-attr:[Group(GroupLayout.GroupBox)]}   
        {#ix-set:AttributeName = "<#Status#>"}
        _status : AxoAiStatus;	

        {#ix-attr:[Container(Layout.Wrap)]}
       
        _rawRange : REAL;
        _realRange : REAL;
        _scaled : REAL;


        {#ix-set:MessageText = "<#Division by zero: Verify values defined in config! (RawHigh,RawLow)#>"}
        _messengerDivisionByZero : AXOpen.Messaging.Static.AxoMessenger;

        {#ix-set:MessageText = "<#Invalid data: Gain is not defined!#>"}
        _messengerGainNotDefined : AXOpen.Messaging.Static.AxoMessenger;

        {#ix-set:MessageText = "<#Out of boundaries,check correction parameters (Gain,Ofset) in config!#>"}
        {#ix-set:Help = "<#Check your signal input.#>"}
        _messengerOutOfBoundaries : AXOpen.Messaging.Static.AxoMessenger;
    END_VAR

        VAR
            _signal : DINT;

        END_VAR

    /// <summary>
    /// Method, which scales input signal based on configuration
    /// </summary>
    METHOD PUBLIC AxoAiSignal :BOOL

        VAR_INPUT
            context : IAxoContext;
        END_VAR
        VAR_IN_OUT
            
            inoSignal: DINT;
        END_VAR

        THIS.Initialize(context);
        _messengerDivisionByZero.Serve(THIS); 
        _messengerGainNotDefined.Serve(THIS); 
        _messengerOutOfBoundaries.Serve(THIS);

        _signal := inoSignal;
        //scaling
        _rawRange  := TO_REAL(_config.RawHigh - _config.RawLow);
        _realRange := _config.RealHigh - _config.RealLow;
        _scaled    := 0;

        IF (_rawRange = 0) THEN
            _messengerDivisionByZero.Activate(AXOpen.Messaging.eAxoMessageCategory#Error);
            RETURN;
        END_IF;
        
        IF (_config.Gain = 0) THEN
            _messengerGainNotDefined.Activate(AXOpen.Messaging.eAxoMessageCategory#Error);
        END_IF;

        _scaled := TO_REAL(_signal - _config.RawLow) / _rawRange;

        _scaled := _scaled * _realRange;
        _scaled := _scaled + _config.RealLow;

        _scaled := _scaled * _config.Gain + _config.Offset;
        
        IF (_scaled > _config.RealHigh) AND (_config.Gain <> 1 OR _config.Offset <> 0) THEN
            _messengerOutOfBoundaries.Activate(AXOpen.Messaging.eAxoMessageCategory#Error);
        ELSIF (_scaled < _config.RealLow) AND (_config.Gain <> 1 OR _config.Offset <> 0) THEN
            _messengerOutOfBoundaries.Activate(AXOpen.Messaging.eAxoMessageCategory#Error);
        END_IF;

        _status.RawRange  := _rawRange;
        _status.RealRange := _realRange;
        _status.Scaled    := _scaled;

    END_METHOD

    
    METHOD PROTECTED OVERRIDE Restore : IAxoTask
        ;
    END_METHOD

    METHOD PROTECTED OVERRIDE ManualControl
        THIS._isManuallyControllable := TRUE;
    END_METHOD
END_CLASS
END_NAMESPACE