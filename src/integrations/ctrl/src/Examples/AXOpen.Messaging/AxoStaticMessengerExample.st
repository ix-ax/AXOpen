USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AxoStaticMessengerExample

    CLASS Messengers EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Messenger 1#>"}
            {#ix-set:MessageText = "<#Message text for messenger 1#>"}
            {#ix-set:Help = "<#Help text for messenger 1#>"}
            _messenger1 : AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 1#>"}
            _messenger1condition : BOOL;
            {#ix-set:AttributeName = "<#Messenger 2#>"}
            {#ix-set:MessageText = "<#Message text for messenger 2#>"}
            {#ix-set:Help = "<#Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus neque eros, malesuada ac orci ut, ornare ullamcorper purus. Integer ultrices turpis vel est suscipit blandit. Mauris blandit eros augue, in mollis dui tincidunt vel. Sed placerat augue risus, eget pulvinar felis dictum quis. Aliquam ut interdum nisl. Aliquam et velit id turpis blandit laoreet nec ut ligula. Aliquam ac neque risus. Fusce porta mauris eget nulla iaculis mattis. Etiam auctor mi eget libero laoreet, sed interdum ipsum pellentesque. Maecenas vitae quam vitae velit tincidunt fringilla. Fusce sagittis elit sit amet tempor pretium. Donec elementum, ligula at laoreet mollis, est ipsum elementum lectus, et mollis nisi tellus id erat. In hac habitasse platea dictumst.#>"}
            _messenger2 : AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 2#>"}
            _messenger2condition : BOOL;
            {#ix-set:AttributeName = "<#Messenger 3#>"}
            {#ix-set:MessageText = "<#Message text for messenger 3#>"}
            {#ix-set:Help = "<#Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus neque eros, malesuada ac orci ut, ornare ullamcorper purus. Integer ultrices turpis vel est suscipit blandit. Mauris blandit eros augue, in mollis dui tincidunt vel. Sed placerat augue risus, eget pulvinar felis dictum quis. Aliquam ut interdum nisl. Aliquam et velit id turpis blandit laoreet nec ut ligula. Aliquam ac neque risus. Fusce porta mauris eget nulla iaculis mattis. Etiam auctor mi eget libero laoreet, sed interdum ipsum pellentesque. Maecenas vitae quam vitae velit tincidunt fringilla. Fusce sagittis elit sit amet tempor pretium. Donec elementum, ligula at laoreet mollis, est ipsum elementum lectus, et mollis nisi tellus id erat. In hac habitasse platea dictumst.#>"}
            _messenger3 : AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 3#>"}
            _messenger3condition : BOOL;
            {#ix-set:AttributeName = "<#Messenger 4#>"}
            {#ix-set:MessageText = "<#Message text for messenger 4#>"}
            {#ix-set:Help = "<#Help text for messenger 4#>"}
            _messenger4 : AxoMessenger;
            {#ix-set:AttributeName = "<#Set to high to activate the messenger 4#>"}
            _messenger4condition : BOOL;
       END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            _messenger1.Serve(THIS);    
            IF _messenger1condition THEN
                _messenger1.Activate(eAxoMessageCategory#Error);
            END_IF;
            _messenger2.ActivateOnCondition(_messenger2condition,eAxoMessageCategory#Warning).RequireAcknowledgement();
            _messenger2.Serve(THIS);    
            _messenger3.ActivateOnCondition(_messenger3condition,eAxoMessageCategory#Info);
            _messenger3.Serve(THIS);    
            _messenger4.ActivateOnCondition(_messenger4condition,eAxoMessageCategory#Info).RequireAcknowledgement();
            _messenger4.Serve(THIS);    
        END_METHOD
    END_CLASS    
END_NAMESPACE
