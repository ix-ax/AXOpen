USING AXOpen.Core;
NAMESPACE AXOpen.Elements

    /// <summary>
    /// Class representing Analog output
    /// </summary>
    CLASS AxoAo EXTENDS AXOpen.Core.AxoComponent
        
        VAR PUBLIC


            /// required value
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#SetPoint#>"}
            {#ix-attr:[ComponentHeader()]}
            _requiredValue : REAL;

            /// configuration for calculations
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            _config : AxoAoConfig;
    
            /// status of output
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}   
            {#ix-set:AttributeName = "<#Status#>"}
            _status : AxoAoStatus;	
    

            _rawRange  : REAL;
            _realRange : REAL;
            _unscaled  : REAL;
    
    
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
        /// Method, which unscales input signal based on configuration and writes it to output
        /// </summary>
        METHOD PUBLIC AxoAoSignal

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
            //unscaling
            _rawRange  := TO_REAL(_config.RawHigh - _config.RawLow);
            _realRange := _config.RealHigh - _config.RealLow;
            _unscaled  := 0;
    
            IF (_rawRange = 0) THEN
                _messengerDivisionByZero.Activate(AXOpen.Messaging.eAxoMessageCategory#Error);
                RETURN;
            END_IF;
            
            IF (_config.Gain = 0) THEN
                _messengerGainNotDefined.Activate(AXOpen.Messaging.eAxoMessageCategory#Error);
            END_IF;
    
            _unscaled := (_requiredValue - _config.RealLow) / _realRange;

            _unscaled := _unscaled * _rawRange;

            _unscaled := _unscaled + TO_REAL(_config.RawLow);

            _unscaled := _unscaled * _config.Gain + _config.Offset;
            
            IF (_unscaled > TO_REAL(_config.RawHigh)) AND (_config.Gain <> 1 OR _config.Offset <> 0) THEN
                _messengerOutOfBoundaries.Activate(AXOpen.Messaging.eAxoMessageCategory#Error);
            ELSIF (_unscaled < TO_REAL(_config.RawLow)) AND (_config.Gain <> 1 OR _config.Offset <> 0) THEN
                _messengerOutOfBoundaries.Activate(AXOpen.Messaging.eAxoMessageCategory#Error);
            END_IF;
    
            _signal := TO_DINT(_unscaled);
            _status.RawRange  := _rawRange;
            _status.RealRange := _realRange;
            _status.Unscaled  := _unscaled;
    
            inoSignal := _signal;
        END_METHOD
    
    METHOD PROTECTED OVERRIDE Restore : IAxoTask
        ;
    END_METHOD

    METHOD PROTECTED OVERRIDE ManualControl
        _isManuallyControllable := TRUE;
    END_METHOD
END_CLASS
END_NAMESPACE