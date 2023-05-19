USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AxoStaticMessengerDocuExample
    CLASS Messengers EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:MessageText = "<#Message text for messenger 1#>"}
            {#ix-set:Help = "<#Help text for messenger 1#>"}
            _messenger1 : AxoMessenger;
            _messenger1condition : BOOL;
            {#ix-set:MessageText = "<#Message text for messenger 2#>"}
            {#ix-set:MessageText = "<#Message text for messenger 2#>"}
            _messenger2 : AxoMessenger;
            _messenger2condition : BOOL;
       END_VAR    
    
       METHOD PROTECTED OVERRIDE Main
            _messenger1.Serve(THIS);    
            IF _messenger1condition THEN
                _messenger1.Activate(eAxoMessageCategory#Error);
            END_IF;

            _messenger2.Serve(THIS);    
            _messenger2.ActivateOnCondition(_messenger2condition,eAxoMessageCategory#Warning);
        END_METHOD
    
        METHOD Examples
            //<Activate>
            _messenger1.Serve(THIS);    
            IF _messenger1condition THEN
                _messenger1.Activate(eAxoMessageCategory#Error);
            END_IF;
            //</Activate>

            //<ActivateOnCondition>
            _messenger2.Serve(THIS);    
            _messenger2.ActivateOnCondition(_messenger2condition,eAxoMessageCategory#Warning);
            //</ActivateOnCondition>

            //<RequireAcknowledgement>
            _messenger2.ActivateOnCondition(_messenger2condition,eAxoMessageCategory#Warning).RequireAcknowledgement();
            //</RequireAcknowledgement>

            //<DoNotRequireAcknowledgement>
            _messenger2.ActivateOnCondition(_messenger2condition,eAxoMessageCategory#Error).DoNotRequireAcknowledgement();
            //</DoNotRequireAcknowledgement>
        END_METHOD
    END_CLASS    
END_NAMESPACE
