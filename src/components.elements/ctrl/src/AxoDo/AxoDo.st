USING AXOpen.Core;
NAMESPACE AXOpen.Elements

    /// <summary>
    /// Class representing Digital output
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS AxoDo EXTENDS AXOpen.Core.AxoComponent

        VAR
            _signal : BOOL;

        END_VAR

        VAR PUBLIC

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#On#>"}
            {#ix-attr:[ComponentHeader()]}
            _setTask : AxoTask;

            {#ix-set:AttributeName = "<#Off#>"}
            {#ix-attr:[ComponentHeader()]}
            _resetTask : AxoTask;

            {#ix-set:MessageText = "<#Expecting positive signal.#>"}
            {#ix-set:Help = "<#Check your signal input.#>"}
            _messengerInfoPositive : AXOpen.Messaging.Static.AxoMessenger;

            {#ix-set:MessageText = "<#Expecting negative signal.#>"}
            {#ix-set:Help = "<#Check your signal input.#>"}
            _messengerInfoNegative : AXOpen.Messaging.Static.AxoMessenger;

        END_VAR


        METHOD PUBLIC OVERRIDE Restore 
            _setTask.Restore();
            _resetTask.Restore();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;

        END_METHOD

        /// <summary>
        /// Method, which sets or reset input/output value
        /// </summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent : Axopen.Core.IAxoObject;
            END_VAR

            VAR_IN_OUT
                inoSignal: BOOL;
            END_VAR

            IF (parent = NULL) THEN RETURN; END_IF;

            IF THIS._context_ = NULL THEN
                THIS.Initialize(parent);
                _setTask.Initialize(THIS);
                _resetTask.Initialize(THIS);
            end_if;

            _messengerInfoPositive.Serve(THIS); 
            _messengerInfoNegative.Serve(THIS); 

            inoSignal := _signal;		

            IF(_setTask.Execute())THEN
                _setTask.DoneWhen(THIS.Set());
            END_IF;
            
            IF(_resetTask.Execute())THEN
                _resetTask.DoneWhen(THIS.Reset());
            END_IF;


        END_METHOD

        METHOD PUBLIC Set : BOOL
            _signal := TRUE;
            Set := TRUE;
        END_METHOD

        METHOD PUBLIC Reset: BOOL
            _signal := FALSE;
            Reset := TRUE;
        END_METHOD

        METHOD PUBLIC IsTrue : BOOL
            IsTrue := _signal;

            IF NOT IsTrue THEN
                _messengerInfoPositive.Activate(AXOpen.Messaging.eAxoMessageCategory#Warning);
            END_IF;


        END_METHOD

        METHOD PUBLIC IsFalse : BOOL
            IsFalse := NOT _signal;

            IF NOT IsFalse THEN
                _messengerInfoNegative.Activate(AXOpen.Messaging.eAxoMessageCategory#Warning);
            END_IF;


        END_METHOD
    
  
END_CLASS
END_NAMESPACE
