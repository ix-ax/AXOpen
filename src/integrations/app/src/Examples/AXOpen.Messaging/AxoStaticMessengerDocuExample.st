USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AxoStaticMessengerDocuExample
    {S7.extern=ReadWrite}
    CLASS MessengersExamples EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Messenger 1 - activate using 'Activate' method called inside the if statement#>"}
            {#ix-set:PlcTextList = "[1]:'<#Messenger 1: message text for message code 1#>':'<#Messenger 1: help text for message code 1#>';[2]:'<#Messenger 1: message text for message code 2#>':'<#Messenger 1: help text for message code 2#>';[3]:'<#Messenger 1: message text for message code 3#>':'<#Messenger 1: help text for message code 3#>';[4]:'<#Messenger 1: message text for message code 4#>':'<#Messenger 1: help text for message code 4#>';[5]:'<#Messenger 1: message text for message code 5#>':'<#Messenger 1: help text for message code 5#>';[6]:'<#Messenger 1: message text for message code 6#>':'<#Messenger 1: help text for message code 6#>';[7]:'<#Messenger 1: message text for message code 7#>':'<#Messenger 1: help text for message code 7#>';[8]:'<#Messenger 1: message text for message code 8#>':'<#Messenger 1: help text for message code 8#>';[9]:'<#Messenger 1: message text for message code 9#>':'<#Messenger 1: help text for message code 9#>';[10]:'<#Messenger 1: message text for message code 10#>':'<#Messenger 1: help text for message code 10#>';[11]:'<#Messenger 1: message text for message code 11#>':'<#Messenger 1: help text for message code 11#>'"}
            _messenger1 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 1#>"}
            _messenger1condition : BOOL;
            {#ix-set:AttributeName = "<#message 1 code#>"}
            _messenger1code : UINT;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Messenger 2 - activate using 'ActivateOnCondition' method called cyclically#>"}
            {#ix-set:PlcTextList = "[1]:'<#Messenger 2: message text for message code 1#>':'<#Messenger 2: help text for message code 1#>'[2]:'<#Messenger 2: message text for message code 2#>':'<#Messenger 2: help text for message code 2#>'"}
            _messenger2 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 2#>"}
            _messenger2condition : BOOL;
            {#ix-set:AttributeName = "<#message 2 code#>"}
            _messenger2code : UINT;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Messenger 3 - one message example, long help text#>"}
            {#ix-set:PlcTextList = "[1]:'<#Message text for messenger 3#>':'<#Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus neque eros, malesuada ac orci ut, ornare ullamcorper purus. Integer ultrices turpis vel est suscipit blandit. Mauris blandit eros augue, in mollis dui tincidunt vel. Sed placerat augue risus, eget pulvinar felis dictum quis. Aliquam ut interdum nisl. Aliquam et velit id turpis blandit laoreet nec ut ligula. Aliquam ac neque risus. Fusce porta mauris eget nulla iaculis mattis. Etiam auctor mi eget libero laoreet, sed interdum ipsum pellentesque. Maecenas vitae quam vitae velit tincidunt fringilla. Fusce sagittis elit sit amet tempor pretium. Donec elementum, ligula at laoreet mollis, est ipsum elementum lectus, et mollis nisi tellus id erat. In hac habitasse platea dictumst.#>'"}
            _messenger3 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 3#>"}
            _messenger3condition : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            //<PlcTextListDeclaration>
            {#ix-set:AttributeName = "<#Messenger 4 - textlist in PLC#>"}
            {#ix-set:PlcTextList = "[1]:'<#Messenger 4: static message text for message code 1 declared in the PLC code#>':'<#Messenger 4: static help text for message code 1 declared in the PLC code#>'[2]:'<#Messenger 4: static message text for message code 2 declared in the PLC code#>':'<#Messenger 4: static help text for message code 2 declared in the PLC code#>'"}
            _messenger4 : AXOpen.Messaging.Static.AxoMessenger;
            //</PlcTextListDeclaration>
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 4 with message code 1#>"}
            _messenger4condition_1 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 4 with message code 2#>"}
            _messenger4condition_2 : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            //<TextListGoingToBeDeclaredInDotNet>
            {#ix-set:AttributeName = "<#Messenger 5 - textlist in .NET#>"}
            _messenger5 : AXOpen.Messaging.Static.AxoMessenger;
            //</TextListGoingToBeDeclaredInDotNet>
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 1#>"}
            _messenger5condition_1 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 2#>"}
            _messenger5condition_2 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 3#>"}
            _messenger5condition_3 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 4#>"}
            _messenger5condition_4 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 5#>"}
            _messenger5condition_5 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 6#>"}
            _messenger5condition_6 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 7#>"}
            _messenger5condition_7 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 8#>"}
            _messenger5condition_8 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 9#>"}
            _messenger5condition_9 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 5 with code 10, with no help text defined#>"}
            _messenger5condition_10 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to call the messenger 5#>"}
            _messenger5callcondition : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Messenger 6 - invalid implementation#>"}
            {#ix-set:PlcTextList = "[1]:'<#Messenger 6: static message text for message code 1 declared in the PLC code#>':'<#Messenger 6: static help text for message code 1 declared in the PLC code#>'[2]:'<#Messenger 6: static message text for message code 2 declared in the PLC code#>':'<#Messenger 6: static help text for message code 2 declared in the PLC code#>'"}
            _messenger6 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 6 with message code 1#>"}
            _messenger6condition_1 : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 6 with message code 2#>"}
            _messenger6condition_2 : BOOL;
        END_VAR    
    
        VAR PRIVATE
            _rootObject :   AxoObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            //<Activate>
            _messenger1.Serve(_rootObject);    
            IF _messenger1condition THEN
                _messenger1.Activate(_messenger1code,eAxoMessageCategory#Error);
            END_IF;
            //</Activate>

            //<ActivateOnCondition>
            _messenger2.Serve(_rootObject);    
            _messenger2.ActivateOnCondition(_messenger2code,_messenger2condition,eAxoMessageCategory#Warning).RequireAcknowledgement();
            //</ActivateOnCondition>

            //<RequireAcknowledgement>
            _messenger2.Serve(_rootObject);    
            _messenger2.ActivateOnCondition(_messenger2code,_messenger2condition,eAxoMessageCategory#Warning).RequireAcknowledgement();
            //</RequireAcknowledgement>

            //<DoNotRequireAcknowledgement>
            _messenger3.Serve(_rootObject);    
            _messenger3.ActivateOnCondition(UINT#1,_messenger3condition,eAxoMessageCategory#Error).DoNotRequireAcknowledgement();
            //</DoNotRequireAcknowledgement>

            //<ActivateOnConditionWithMessageCodeTextListDeclaredInThePlcCode>
            _messenger4.Serve(_rootObject);    
            _messenger4.ActivateOnCondition(UINT#1,_messenger4condition_1,eAxoMessageCategory#Info).RequireAcknowledgement();
            _messenger4.ActivateOnCondition(UINT#2,_messenger4condition_2,eAxoMessageCategory#Info).RequireAcknowledgement();
            //</ActivateOnConditionWithMessageCodeTextListDeclaredInThePlcCode>

            //<ActivateOnConditionWithMessageCodeTextListDeclaredInDotNet>
            IF _messenger5callcondition THEN
                _messenger5.Serve(_rootObject);    
                _messenger5.ActivateOnCondition(ULINT#1,_messenger5condition_1,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#2,_messenger5condition_2,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#3,_messenger5condition_3,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#4,_messenger5condition_4,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#5,_messenger5condition_5,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#6,_messenger5condition_6,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#7,_messenger5condition_7,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#8,_messenger5condition_8,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#9,_messenger5condition_9,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#10,_messenger5condition_10,eAxoMessageCategory#Error).RequireAcknowledgement();
            ELSE
                _messenger5.Restore();
            END_IF;
            //</ActivateOnConditionWithMessageCodeTextListDeclaredInDotNet>
    
            //<InvalidImplementation>
            _messenger6.ActivateOnCondition(UINT#1,_messenger6condition_1,eAxoMessageCategory#Info).RequireAcknowledgement();
            _messenger6.ActivateOnCondition(UINT#2,_messenger6condition_2,eAxoMessageCategory#Info).RequireAcknowledgement();
            _messenger6.Serve(_rootObject);    
            //</InvalidImplementation>
        END_METHOD
    END_CLASS    

    //<MessengerCompleteExample
    {S7.extern=ReadWrite}
    CLASS Messengers EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:PlcTextList = "[10]:'<#Messenger 1: static message text for message code 10 declared in the PLC code#>':'<#Messenger 1: static help text for message code 10 declared in the PLC code#>'"}
            _messenger1 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 1#>"}
            _messenger1condition : BOOL;

            {#ix-set:PlcTextList = "[10]:'<#Messenger 2: static message text for message code 10 declared in the PLC code#>':'<#Messenger 2: static help text for message code 10 declared in the PLC code#>'"}
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
        VAR PRIVATE
            _rootObject :   AxoObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            _messenger1.Serve(_rootObject);    
            IF _messenger1condition THEN
                _messenger1.Activate(ULINT#10,eAxoMessageCategory#Error);
            END_IF;

            _messenger2.Serve(_rootObject);    
            _messenger2.ActivateOnCondition(ULINT#10,_messenger2condition,eAxoMessageCategory#Warning);

            _messenger3.Serve(_rootObject);
            _messenger3.ActivateOnCondition(ULINT#10,_messenger3condition_10,eAxoMessageCategory#Error).DoNotRequireAcknowledgement();
            _messenger3.ActivateOnCondition(ULINT#20,_messenger3condition_20,eAxoMessageCategory#Warning).RequireAcknowledgement();

            _messenger4.Serve(_rootObject);    
            _messenger4.ActivateOnCondition(ULINT#10,_messenger4condition_10,eAxoMessageCategory#Warning);
            _messenger4.ActivateOnCondition(ULINT#20,_messenger4condition_20,eAxoMessageCategory#Warning);

        END_METHOD
    END_CLASS    
    //</MessengerCompleteExample
END_NAMESPACE
