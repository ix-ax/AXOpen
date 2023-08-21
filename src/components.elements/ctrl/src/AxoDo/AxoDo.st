USING AXOpen.Core;
NAMESPACE AXOpen.Elements

    CLASS AxoDo EXTENDS AXOpen.Core.AxoComponent

        VAR
            _signal : BOOL;

        END_VAR

        VAR PUBLIC


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


        METHOD PROTECTED OVERRIDE Restore : IAxoTask
            _setTask.Restore();
            _resetTask.Restore();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;

        END_METHOD


        METHOD PUBLIC AxoDoSignal : BOOL
            VAR_INPUT
                context : IAxoContext;
            END_VAR

            VAR_IN_OUT
                inoSignal: BOOL;
            END_VAR

            THIS.Initialize(context);
            _setTask.Initialize(THIS);
            _resetTask.Initialize(THIS);
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