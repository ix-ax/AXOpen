USING AXOpen.Core;
NAMESPACE AXOpen.Elements

    CLASS AxoDi EXTENDS AXOpen.Core.AxoComponent

        VAR
            _inSignal : BOOL;

        END_VAR

        VAR PUBLIC
            

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            _signalName : STRING := 'test signal';
            
            {#ix-set:AttributeName = "<#Check on#>"}
            {#ix-attr:[ComponentHeader()]}
            _isTrueTask : AxoTask;
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
       

        METHOD PROTECTED OVERRIDE Restore : IAxoTask
            _isFalseTask.Restore();
            _isTrueTask.Restore();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
            ;
        END_METHOD



        METHOD PUBLIC AxoDiSignal :BOOL

            VAR_INPUT
                context : IAxoContext;
            END_VAR
            VAR_IN_OUT
                
                inoSignal: BOOL;
            END_VAR

            THIS.Initialize(context);
            _isTrueTask.Initialize(THIS);
            _isFalseTask.Initialize(THIS);
            IF(_isTrueTask.Execute())THEN
                _isTrueTask.DoneWhen(THIS.IsTrue());
            END_IF;
            
            IF(_isFalseTask.Execute())THEN
                _isFalseTask.DoneWhen(THIS.IsFalse());
            END_IF;

            THIS._inSignal := inoSignal;	

        END_METHOD

        METHOD PUBLIC IsTrue :BOOL
            IsTrue := _inSignal;

            IF NOT IsTrue THEN
                _messengerInfoPositive.Serve(THIS); 
                _messengerInfoPositive.Activate(AXOpen.Messaging.eAxoMessageCategory#Info);
            END_IF;


        END_METHOD

        METHOD PUBLIC IsFalse:BOOL
            IsFalse := NOT _inSignal;

            IF NOT IsFalse THEN
                _messengerInfoNegative.Serve(THIS); 
                _messengerInfoNegative.Activate(AXOpen.Messaging.eAxoMessageCategory#Info);
            END_IF;


        END_METHOD
    END_CLASS

END_NAMESPACE 