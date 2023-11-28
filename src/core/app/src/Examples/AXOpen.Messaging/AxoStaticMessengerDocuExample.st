USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AxoStaticMessengerDocuExample
    {S7.extern=ReadWrite}
    CLASS MessengersExamples EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            //<MessageTextHelpDeclaration>
            {#ix-set:MessageText = "<#Static message text for messenger 1 declared in the PLC code#>"}
            {#ix-set:Help = "<#Static help text for messenger 1 declared in the PLC code#>"}
            _messenger1 : AXOpen.Messaging.Static.AxoMessenger;
            //</MessageTextHelpDeclaration>
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 1#>"}
            _messenger1condition : BOOL;

            {#ix-set:MessageText = "<#Static message text for messenger 2 declared in the PLC code#>"}
            {#ix-set:Help = "<#Static help text for messenger 2 declared in the PLC code#>"}
            _messenger2 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 2#>"}
            _messenger2condition : BOOL;

            //<PlcTextListDeclaration>
            {#ix-set:PlcTextList = "[10]:'<#Messenger 3: static message text for message code 10 declared in the PLC code#>':'<#Messenger 3: static help text for message code 10 declared in the PLC code#>';[20]:'<#Messenger 3: static message text for message code 20 declared in the PLC code#>':'<#Messenger 3: static help text for message code 20 declared in the PLC code#>'"}
            _messenger3 : AXOpen.Messaging.Static.AxoMessenger;
            //</PlcTextListDeclaration>
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 3 with message code 10#>"}
            _messenger3condition_10 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 3 with message code 20#>"}
            _messenger3condition_20 : BOOL;

            //<TextListGoingToBeDeclaredInDotNet>
            _messenger4 : AXOpen.Messaging.Static.AxoMessenger;
            //</TextListGoingToBeDeclaredInDotNet>
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 4 with message code 10#>"}
            _messenger4condition_10 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 4 with message code 20#>"}
            _messenger4condition_20 : BOOL;
       END_VAR    
    
       METHOD PROTECTED OVERRIDE Main
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

            //<ActivateOnConditionWithMessageCodeTextListDeclaredInThePlcCode>
            _messenger3.Serve(THIS);
            _messenger3.ActivateOnCondition(ULINT#10,_messenger3condition_10,eAxoMessageCategory#Warning);
            _messenger3.ActivateOnCondition(ULINT#20,_messenger3condition_20,eAxoMessageCategory#Warning);
            //</ActivateOnConditionWithMessageCodeTextListDeclaredInThePlcCode>

            //<ActivateOnConditionWithMessageCodeTextListDeclaredInDotNet>
            _messenger4.Serve(THIS);    
            _messenger4.ActivateOnCondition(ULINT#10,_messenger4condition_10,eAxoMessageCategory#Warning);
            _messenger4.ActivateOnCondition(ULINT#20,_messenger4condition_20,eAxoMessageCategory#Warning);
            //</ActivateOnConditionWithMessageCodeTextListDeclaredInDotNet>
        END_METHOD
    END_CLASS    

    //<MessengerCompleteExample
    {S7.extern=ReadWrite}
    CLASS Messengers EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:MessageText = "<#Static message text for messenger 1 declared in the PLC code#>"}
            {#ix-set:Help = "<#Static help text for messenger 1 declared in the PLC code#>"}
            _messenger1 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 1#>"}
            _messenger1condition : BOOL;

            {#ix-set:MessageText = "<#Static message text for messenger 2 declared in the PLC code#>"}
            {#ix-set:Help = "<#Static help text for messenger 2 declared in the PLC code#>"}
            _messenger2 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 2#>"}
            _messenger2condition : BOOL;

            {#ix-set:PlcTextList = "[10]:'<#Messenger 3: static message text for message code 10 declared in the PLC code#>':'<#Messenger 3: static help text for message code 10 declared in the PLC code#>';[20]:'<#Messenger 3: static message text for message code 20 declared in the PLC code#>':'<#Messenger 3: static help text for message code 20 declared in the PLC code#>'"}
            _messenger3 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 3 with message code 10#>"}
            _messenger3condition_10 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 3 with message code 20#>"}
            _messenger3condition_20 : BOOL;

            _messenger4 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 4 with message code 10#>"}
            _messenger4condition_10 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 4 with message code 20#>"}
            _messenger4condition_20 : BOOL;
       END_VAR    
    
       METHOD PROTECTED OVERRIDE Main
            _messenger1.Serve(THIS);    
            IF _messenger1condition THEN
                _messenger1.Activate(eAxoMessageCategory#Error);
            END_IF;

            _messenger2.Serve(THIS);    
            _messenger2.ActivateOnCondition(_messenger2condition,eAxoMessageCategory#Warning);

            _messenger3.Serve(THIS);
            _messenger3.ActivateOnCondition(ULINT#10,_messenger3condition_10,eAxoMessageCategory#Error).DoNotRequireAcknowledgement();
            _messenger3.ActivateOnCondition(ULINT#20,_messenger3condition_20,eAxoMessageCategory#Warning).RequireAcknowledgement();

            _messenger4.Serve(THIS);    
            _messenger4.ActivateOnCondition(ULINT#10,_messenger4condition_10,eAxoMessageCategory#Warning);
            _messenger4.ActivateOnCondition(ULINT#20,_messenger4condition_20,eAxoMessageCategory#Warning);

        END_METHOD
    END_CLASS    
    //</MessengerCompleteExample
END_NAMESPACE
