USING AXOpen.Core;
NAMESPACE AXOpen.Components.Elements
    /// <summary>
    /// Class representing Analog input
    /// </summary>
    {S7.extern=ReadWrite}
    {#ix-prop:public string Units}
    {#ix-set:Units = ".#"}
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
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Status#>"}
            _status : AxoAiStatus;	

            {#ix-attr:[Container(Layout.Wrap)]}
            _rawRange : REAL;
            _realRange : REAL;
            _scaled : REAL;

            {#ix-set:AttributeName = "<#MessengerInfo#>"}
            {#ix-set:PlcTextList = "[1]:'<#Division by zero: Verify values defined in config! (RawHigh,RawLow)':'<#Check the scaling parameters.#>';[2]:'<#Invalid data: Gain is not defined!#>':'<#Check the scaling parameters.#>';[3]:'<#Out of boundaries,check correction parameters (Gain,Ofset) in config!#>':'<#Check your signal input.#>'"}
            _messengerInfo : AXOpen.Messaging.Static.AxoMessenger;
        END_VAR

        VAR
            _signal : DINT;
        END_VAR

        VAR PRIVATE
            _context : IAxoContext;
        END_VAR

        /// <summary>
        /// Method, which scales input signal based on configuration
        /// </summary>
        METHOD PUBLIC Run 

            VAR_INPUT
                inParent : Axopen.Core.IAxoObject;
                inSignal: DINT;
            END_VAR
            

            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;

         
            SUPER.Run(inParent);
         
            _messengerInfo.Serve(THIS); 
 
            _signal := inSignal;
            //scaling
            _rawRange  := TO_REAL(_config.RawHigh - _config.RawLow);
            _realRange := _config.RealHigh - _config.RealLow;
            _scaled    := 0;

            IF (_rawRange = 0) THEN
                _messengerInfo.Activate(UINT#1,AXOpen.Messaging.eAxoMessageCategory#Error);
                RETURN;
            END_IF;
            
            IF (_config.Gain = 0) THEN
                _messengerInfo.Activate(UINT#2,AXOpen.Messaging.eAxoMessageCategory#Error);
            END_IF;

            _scaled := TO_REAL(_signal - _config.RawLow) / _rawRange;

            _scaled := _scaled * _realRange;
            _scaled := _scaled + _config.RealLow;

            _scaled := _scaled * _config.Gain + _config.Offset;
            
            IF (_scaled > _config.RealHigh) AND (_config.Gain <> 1 OR _config.Offset <> 0) THEN
                _messengerInfo.Activate(UINT#3,AXOpen.Messaging.eAxoMessageCategory#Error);
            ELSIF (_scaled < _config.RealLow) AND (_config.Gain <> 1 OR _config.Offset <> 0) THEN
                _messengerInfo.Activate(UINT#3,AXOpen.Messaging.eAxoMessageCategory#Error);
            END_IF;

            _status.RawRange  := _rawRange;
            _status.RealRange := _realRange;
            _status.Scaled    := _scaled;
        END_METHOD

        /// <summary>
        /// Method, which scales input signal based on configuration
        /// </summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                inParent : Axopen.Core.IAxoObject;
                inSignal: WORD;
            END_VAR
            THIS.Run(inParent,TO_DINT(inSignal));
        END_METHOD

        METHOD PUBLIC OVERRIDE Restore 
            ;
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := TRUE;
        END_METHOD
    END_CLASS
END_NAMESPACE
