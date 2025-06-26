USING AXOpen.Core;
NAMESPACE AXOpen.Elements

    /// <summary>
    /// Class representing Digital input
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS AxoDi EXTENDS AXOpen.Core.AxoComponent

        VAR PUBLIC
            
            // task, which checks if signal is on
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Check on#>"}
            {#ix-attr:[ComponentHeader()]}
            _isTrueTask : AxoTask;
            
            // task, which checks if signal is off
            {#ix-set:AttributeName = "<#Check off#>"}
            {#ix-attr:[ComponentHeader()]}
            _isFalseTask : AxoTask;
            
            {#ix-set:AttributeName = "<#MessengerInfo#>"}
            {#ix-set:PlcTextList = "[1]:'<#Expecting positive signal.#>':'<#Check your signal input.#>';[2]:'<#Expecting negative signal.#>':'<#Check your signal input.#>'"}
            _messengerInfo : AXOpen.Messaging.Static.AxoMessenger;
            

            {#ix-attr:[ComponentDetails("Signal status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Signal#>"}
            _signal : BOOL;
        END_VAR
       
        VAR PRIVATE
            _context : IAxoContext;
        END_VAR
        
        METHOD PUBLIC OVERRIDE Restore 
            _isFalseTask.Restore();
            _isTrueTask.Restore();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := TRUE;
        END_METHOD


        /// <summary>
        /// Method, which implement logic for checking of digital input
        /// </summary>
        METHOD PUBLIC Run

            VAR_INPUT
                parent : Axopen.Core.IAxoObject;
                inSignal: BOOL;
            END_VAR

            IF (parent = NULL) THEN 
                RETURN; 
            END_IF;

            IF _context = NULL THEN
                SUPER.Run(parent);
                _isTrueTask.Run(THIS);
                _isFalseTask.Run(THIS);
                _context := THIS.GetContext();
            END_IF;

            _messengerInfo.Serve(THIS); 

            _signal := inSignal;

            IF(_isTrueTask.Execute(THIS))THEN
                _isTrueTask.DoneWhen(THIS.IsTrue());
            END_IF;
            
            IF(_isFalseTask.Execute(THIS))THEN
                _isFalseTask.DoneWhen(THIS.IsFalse());
            END_IF;
        END_METHOD

        /// <summary>
        /// Returns TRUE if signal is on. It creates alarm otherwise.
        /// </summary>
        METHOD PUBLIC IsTrue : BOOL
            IsTrue := _signal;
            _messengerInfo.ActivateOnCondition(UINT#1,IsTrue,AXOpen.Messaging.eAxoMessageCategory#Warning);
        END_METHOD
        /// <summary>
        /// Returns TRUE if signal is off. It creates alarm otherwise.
        /// </summary>
        METHOD PUBLIC IsFalse : BOOL
            IsFalse := NOT _signal;
            _messengerInfo.ActivateOnCondition(UINT#2,IsFalse,AXOpen.Messaging.eAxoMessageCategory#Warning);
        END_METHOD

        METHOD PUBLIC SignalStatus : BOOL
            SignalStatus :=  _signal;
        END_METHOD
    END_CLASS
END_NAMESPACE 
