USING AXOpen.Core;
NAMESPACE AXOpen.Components.Elements

    /// <summary>
    /// Class representing Analog output
    /// </summary>
    {S7.extern=ReadWrite}
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
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Status#>"}
            _status : AxoAoStatus;	
    
            _rawRange  : REAL;
            _realRange : REAL;
            _unscaled  : REAL;

            {#ix-set:AttributeName = "<#MessengerInfo#>"}
            {#ix-set:PlcTextList = "[1]:'<#Division by zero: Verify values defined in config! (RawHigh,RawLow)':'<#Check the scaling parameters.#>';[2]:'<#Invalid data: Gain is not defined!#>':'<#Check the scaling parameters.#>';[3]:'<#Out of boundaries,check correction parameters (Gain,Ofset) in config!#>':'<#Check your signal output.#>'"}
            _messengerInfo : AXOpen.Messaging.Static.AxoMessenger;
        END_VAR
    
        VAR
            _signal : DINT;

        END_VAR   

        VAR PRIVATE
            _context : IAxoContext;
        END_VAR

        /// <summary>
        /// Method, which unscales input signal based on configuration and writes it to output
        /// </summary>
        METHOD PUBLIC Run

            VAR_INPUT
                inParent : Axopen.Core.IAxoObject;
            END_VAR

            VAR_OUTPUT
                oSignal: DINT;
            END_VAR
    

            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;
           
            SUPER.Run(inParent);
           
            _messengerInfo.Serve(THIS); 
    
            //unscaling
            _rawRange  := TO_REAL(_config.RawHigh - _config.RawLow);
            _realRange := _config.RealHigh - _config.RealLow;
            _unscaled  := 0;
    
            IF (_rawRange = 0) THEN
                _messengerInfo.Activate(UINT#1,AXOpen.Messaging.eAxoMessageCategory#Error);
                RETURN;
            END_IF;
            
            IF (_config.Gain = 0) THEN
                _messengerInfo.Activate(UINT#2,AXOpen.Messaging.eAxoMessageCategory#Error);
            END_IF;
            
            IF (_requiredValue > _config.RealHigh) THEN
                _requiredValue := _config.RealHigh;
                _messengerInfo.Activate(UINT#3,AXOpen.Messaging.eAxoMessageCategory#Error);
            END_IF;
            
            IF (_requiredValue < _config.RealLow) THEN
                _requiredValue := _config.RealLow;
                _messengerInfo.Activate(UINT#3,AXOpen.Messaging.eAxoMessageCategory#Error);
            END_IF;

            _unscaled := (_requiredValue - _config.RealLow) / _realRange;

            _unscaled := _unscaled * _rawRange;

            _unscaled := _unscaled + TO_REAL(_config.RawLow);

            _unscaled := _unscaled * _config.Gain + _config.Offset;
            
            IF (_unscaled > TO_REAL(_config.RawHigh)) AND (_config.Gain <> 1 OR _config.Offset <> 0) THEN
                _messengerInfo.Activate(UINT#3,AXOpen.Messaging.eAxoMessageCategory#Error);
            ELSIF (_unscaled < TO_REAL(_config.RawLow)) AND (_config.Gain <> 1 OR _config.Offset <> 0) THEN
                _messengerInfo.Activate(UINT#3,AXOpen.Messaging.eAxoMessageCategory#Error);
            END_IF;
    
            _signal := TO_DINT(_unscaled);
            _status.RawRange  := _rawRange;
            _status.RealRange := _realRange;
            _status.Unscaled  := _unscaled;
    
            oSignal := _signal;
        END_METHOD
    
        METHOD PUBLIC OVERRIDE Restore 
        ;
    END_METHOD

    METHOD PROTECTED OVERRIDE ManualControl
        _isManuallyControllable := TRUE;
    END_METHOD
END_CLASS
END_NAMESPACE
