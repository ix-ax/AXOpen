USING AXOpen.Core;
USING AXOpen.Messaging.Static;



NAMESPACE AXOpen.Messaging    
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoMessengerService EXTENDS AxoObject IMPLEMENTS IAxoMessagingServices
        VAR PRIVATE
            _messages : REF_TO ARRAY[*] OF REF_TO AxoMessenger; // Array to hold message references
            _nextMessageIndex : DINT;
            _isSuspended : BOOL := FALSE;
        END_VAR 

        METHOD PUBLIC Run 
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;                
                inMessages : REF_TO ARRAY[*] OF REF_TO AxoMessenger; // Input array of message references
            END_VAR   
            VAR
                lb : DINT;
                ub : DINT;
                i : DINT;
                queuedCount : DINT;
            END_VAR                        

            SUPER.Run(inParent); // Call the base class Run method          
            _messages := inMessages; // Assign input messages to the class property
            
            IF _messages <> NULL THEN            
                lb := LOWER_BOUND(_messages^, 1);
                ub := UPPER_BOUND(_messages^, 1);
                IF (_nextMessageIndex < lb) OR (_nextMessageIndex > ub) THEN
                    _nextMessageIndex := lb;
                END_IF;

                queuedCount := DINT#0;
                FOR i := lb TO ub DO
                    IF _messages^[i] <> NULL THEN
                        _messages^[i]^.Serve(_messages^[i]^.Sender); // Pass the message itself as the parameter
                        queuedCount := queuedCount + DINT#1;
                    END_IF;
                END_FOR;                
            END_IF;

            _nextMessageIndex := lb;
        END_METHOD    
       
        METHOD PUBLIC QueueMessage : BOOL
            VAR_INPUT
                inMessegenger : IAxoMessenger;
            END_VAR
            VAR
                lb : DINT;
                ub : DINT;
                length : DINT;
                offset : DINT;
                candidateIndex : DINT;
                i : DINT;
                tmpMsg : REF_TO AxoMessenger;
            END_VAR

            QueueMessage := FALSE;

            IF (_messages = NULL) OR (inMessegenger = NULL) THEN
                RETURN;
            END_IF;

            lb := LOWER_BOUND(_messages^, 1);
            ub := UPPER_BOUND(_messages^, 1);
            length := (ub - lb) + DINT#1;
            IF length <= DINT#0 THEN
                RETURN;
            END_IF;

            // Ensure the next index is within bounds
            IF (_nextMessageIndex < lb) OR (_nextMessageIndex > ub) THEN
                _nextMessageIndex := lb;
            END_IF;

            tmpMsg ?= inMessegenger;
           _messages^[_nextMessageIndex] := tmpMsg;
           QueueMessage := TRUE;                                                 
        END_METHOD                    
    
        METHOD PUBLIC SuspendMessaging
            _isSuspended := TRUE;
        END_METHOD
    
        METHOD PUBLIC ResumeMessaging
            _isSuspended := FALSE;
        END_METHOD

        METHOD PUBLIC IsSuspended : BOOL
            IsSuspended := _isSuspended;
        END_METHOD    

    END_CLASS
        
   
END_NAMESPACE