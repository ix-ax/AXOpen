USING AXOpen.Core;
NAMESPACE AXOpen.Elements

    /// <summary>
    /// Class representing Digital input
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS AxoDi EXTENDS AXOpen.Core.AxoComponent

        VAR
            _inSignal : BOOL;
        END_VAR

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

            {#ix-set:MessageText = "<#Expecting positive signal.#>"}
            {#ix-set:Help = "<#Check your signal input.#>"}
            _messengerInfoPositive : AXOpen.Messaging.Static.AxoMessenger;

            {#ix-set:MessageText = "<#Expecting negative signal.#>"}
            {#ix-set:Help = "<#Check your signal input.#>"}
            _messengerInfoNegative : AXOpen.Messaging.Static.AxoMessenger;

            
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

            IF (parent = NULL) THEN RETURN; END_IF;

            IF THIS._context_ = NULL THEN
                THIS.Initialize(parent);
                _isTrueTask.Initialize(THIS);
                _isFalseTask.Initialize(THIS);
            end_if;
          
            _messengerInfoPositive.Serve(THIS); 
            _messengerInfoNegative.Serve(THIS); 

            THIS._inSignal := inSignal;	


            IF(_isTrueTask.Execute())THEN
                _isTrueTask.DoneWhen(THIS.IsTrue());
            END_IF;
            
            IF(_isFalseTask.Execute())THEN
                _isFalseTask.DoneWhen(THIS.IsFalse());
            END_IF;
        END_METHOD

        /// <summary>
        /// Returns TRUE if signal is on. It creates alarm otherwise.
        /// </summary>
        METHOD PUBLIC IsTrue : BOOL
            IsTrue := _inSignal;

            IF NOT IsTrue THEN
                _messengerInfoPositive.Activate(AXOpen.Messaging.eAxoMessageCategory#Warning);
            END_IF;


        END_METHOD
        /// <summary>
        /// Returns TRUE if signal is off. It creates alarm otherwise.
        /// </summary>
        METHOD PUBLIC IsFalse : BOOL
            IsFalse := NOT _inSignal;

            IF NOT IsFalse THEN
                _messengerInfoNegative.Activate(AXOpen.Messaging.eAxoMessageCategory#Warning);
            END_IF;

        END_METHOD
    END_CLASS

END_NAMESPACE 
