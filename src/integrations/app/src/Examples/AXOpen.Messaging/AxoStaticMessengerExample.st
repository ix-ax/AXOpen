USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AxoStaticMessengerExample

    {S7.extern=ReadWrite}
    CLASS Messengers EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Messenger 1#>"}
            {#ix-set:MessageText = "<#Message text for messenger 1#>"}
            {#ix-set:Help = "<#Help text for messenger 1#>"}
            {#ix-set:PlcTextList = "[1]:'<#Messenger 1: message text for message code 1#>':'<#Messenger 1: help text for message code 1#>';[2]:'<#Messenger 1: message text for message code 2#>':'<#Messenger 1: help text for message code 2#>';[3]:'<#Messenger 1: message text for message code 3#>':'<#Messenger 1: help text for message code 3#>';[4]:'<#Messenger 1: message text for message code 4#>':'<#Messenger 1: help text for message code 4#>';[5]:'<#Messenger 1: message text for message code 5#>':'<#Messenger 1: help text for message code 5#>';[6]:'<#Messenger 1: message text for message code 6#>':'<#Messenger 1: help text for message code 6#>';[7]:'<#Messenger 1: message text for message code 7#>':'<#Messenger 1: help text for message code 7#>';[8]:'<#Messenger 1: message text for message code 8#>':'<#Messenger 1: help text for message code 8#>';[9]:'<#Messenger 1: message text for message code 9#>':'<#Messenger 1: help text for message code 9#>';[10]:'<#Messenger 1: message text for message code 10#>':'<#Messenger 1: help text for message code 10#>';[11]:'<#Messenger 1: message text for message code 11#>':'<#Messenger 1: help text for message code 11#>'"}
            _messenger1 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 1 with default value#>"}
            _messenger1condition : BOOL;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 1 with messageCode#>"}
            _messenger1conditionWithCode : BOOL;
            {#ix-set:AttributeName = "<#message 1 code#>"}
            _messenger1code : UINT;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Messenger 2#>"}
            {#ix-set:MessageText = "<#Message text for messenger 2#>"}
            {#ix-set:Help = "<#Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus neque eros, malesuada ac orci ut, ornare ullamcorper purus. Integer ultrices turpis vel est suscipit blandit. Mauris blandit eros augue, in mollis dui tincidunt vel. Sed placerat augue risus, eget pulvinar felis dictum quis. Aliquam ut interdum nisl. Aliquam et velit id turpis blandit laoreet nec ut ligula. Aliquam ac neque risus. Fusce porta mauris eget nulla iaculis mattis. Etiam auctor mi eget libero laoreet, sed interdum ipsum pellentesque. Maecenas vitae quam vitae velit tincidunt fringilla. Fusce sagittis elit sit amet tempor pretium. Donec elementum, ligula at laoreet mollis, est ipsum elementum lectus, et mollis nisi tellus id erat. In hac habitasse platea dictumst.#>"}
            {#ix-set:PlcTextList = "[1]:'<#Messenger 2: message text for message code 1#>':'<#Messenger 2: help text for message code 1#>'[2]:'<#Messenger 2: message text for message code 2#>':'<#Messenger 2: help text for message code 2#>'"}
            _messenger2 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 2#>"}
            _messenger2condition : BOOL;
            {#ix-set:AttributeName = "<#message 2 code#>"}
            _messenger2code : UINT;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Messenger 3#>"}
            {#ix-set:MessageText = "<#Message text for messenger 3#>"}
            {#ix-set:Help = "<#Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus neque eros, malesuada ac orci ut, ornare ullamcorper purus. Integer ultrices turpis vel est suscipit blandit. Mauris blandit eros augue, in mollis dui tincidunt vel. Sed placerat augue risus, eget pulvinar felis dictum quis. Aliquam ut interdum nisl. Aliquam et velit id turpis blandit laoreet nec ut ligula. Aliquam ac neque risus. Fusce porta mauris eget nulla iaculis mattis. Etiam auctor mi eget libero laoreet, sed interdum ipsum pellentesque. Maecenas vitae quam vitae velit tincidunt fringilla. Fusce sagittis elit sit amet tempor pretium. Donec elementum, ligula at laoreet mollis, est ipsum elementum lectus, et mollis nisi tellus id erat. In hac habitasse platea dictumst.#>"}
            _messenger3 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 3#>"}
            _messenger3condition : BOOL;
            {#ix-set:AttributeName = "<#Messenger 4#>"}
            {#ix-set:MessageText = "<#Message text for messenger 4#>"}
            {#ix-set:Help = "<#Help text for messenger 4#>"}
            _messenger4 : AXOpen.Messaging.Static.AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 4#>"}
            _messenger4condition : BOOL;
            {#ix-set:AttributeName = "<#Messenger 5#>"}
            _messenger5 : AXOpen.Messaging.Static.AxoMessenger;
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
            {#ix-set:AttributeName = "<#Set to high to call the messenger 5#>"}
            _messenger5callcondition : BOOL;
       END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            _messenger1.Serve(THIS);    
            IF _messenger1condition AND NOT _messenger1conditionWithCode THEN
                _messenger1.Activate(eAxoMessageCategory#Error);
            END_IF;
            _messenger1.ActivateOnCondition(_messenger1code,NOT _messenger1condition AND  _messenger1conditionWithCode,eAxoMessageCategory#Error);
            _messenger2.ActivateOnCondition(_messenger2code,_messenger2condition,eAxoMessageCategory#Warning).RequireAcknowledgement();
            _messenger2.Serve(THIS);    
            _messenger3.ActivateOnCondition(_messenger3condition,eAxoMessageCategory#Info);
            _messenger3.Serve(THIS);    
            _messenger4.ActivateOnCondition(_messenger4condition,eAxoMessageCategory#Info).RequireAcknowledgement();
            _messenger4.Serve(THIS);    
            IF _messenger5callcondition THEN
                _messenger5.ActivateOnCondition(ULINT#1,_messenger5condition_1,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#2,_messenger5condition_2,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#3,_messenger5condition_3,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#4,_messenger5condition_4,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#5,_messenger5condition_5,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#6,_messenger5condition_6,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#7,_messenger5condition_7,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#8,_messenger5condition_8,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.ActivateOnCondition(ULINT#9,_messenger5condition_9,eAxoMessageCategory#Error).RequireAcknowledgement();
                _messenger5.Serve(THIS);    
            ELSE
                _messenger5.Restore();
            END_IF;
        END_METHOD
    END_CLASS    
END_NAMESPACE
