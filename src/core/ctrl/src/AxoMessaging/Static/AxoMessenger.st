USING AXOpen.Logging;
USING AXOpen.Core;

NAMESPACE AXOpen.Messaging.Static    

    TYPE                    
        eAxoMessengerState : (  Idle,                           // 0 - Not active
                                ActiveAlreadyAcknowledged,      // 1 - Is still active, but already acknowledged, after acknowledgement goes to 1                               
                                ActiveAcknowledgeRequired,      // 2 - Active and required acknowledgement. If acknowledged before deactivation, it goes to 0, if deactivated before acknowledgement, it goes to 4
                                ActiveAcknowledgeNotRequired,   // 3 - Active without acknowledgement required. After deactivation it goes to 1.
                                InactiveWaitingForAcknowledge,  // 4 - Not active waiting for acknowledgement. After acknowledgement it goes to 1.
                                InvalidImplementation           // 5 - Instance of the AxoMessenger has _NULL_CONTEXT or _NULL_RTM 
                                ) := Idle;
    END_TYPE

    {#ix-prop: public string PlcTextList }
    {S7.extern=ReadWrite}
    CLASS AxoMessenger EXTENDS AxoObject IMPLEMENTS AXOpen.Messaging.Static.IAxoMessageProperties, AXOpen.Core.IAxoMessenger
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            Category : eAxoMessageCategory;           
            {#ix-attr:[ReadOnly()]}
            MessageCode : ULINT;
            {#ix-attr:[ReadOnly()]}
            Risen : LDATE_AND_TIME;
            {#ix-attr:[ReadOnly()]}
            Fallen : LDATE_AND_TIME;
            {#ix-attr:[ReadOnly()]}
            {#ix-attr:[CompilerOmits()]} 
            AcknowledgementRequired : BOOL;
            AcknowledgeRequest : BOOL;
            {#ix-attr:[ReadOnly()]}
            Acknowledged : LDATE_AND_TIME; 
            {#ix-attr:[ReadOnly()]}
            MessengerState : eAxoMessengerState; 
            {#ix-attr:[ReadOnly()]}
            ActiveContextCount : ULINT;
        END_VAR

        VAR PRIVATE            
            _context : IAxoContext;         
        END_VAR
       
        ///<summary>
        /// Ensures the inicialization of the instance, so as the deactivation of the message. Must be called cyclically.
        ///</summary>
        METHOD PUBLIC Serve 
            VAR_INPUT
                inObject : IAxoObject;
            END_VAR  

            IF  _context = NULL THEN  
                IF inObject.GetContext() = NULL THEN
                    RETURN;
                END_IF;

                SUPER.Run(inObject);
                _context := inObject.GetContext(); 
            END_IF;

            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired AND NOT AcknowledgementRequired THEN
                THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeNotRequired;                 
            END_IF;

            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired AND AcknowledgementRequired THEN
                THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeRequired;                 
            END_IF;

            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired OR THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired OR THIS.MessengerState = eAxoMessengerState#ActiveAlreadyAcknowledged THEN
                IF _context.OpenCycleCount() = ULINT#0 OR  _context.GetRtc().NowUTC() = LDATE_AND_TIME#1970-01-01-00:00:00.000 THEN
                    THIS.MessengerState := eAxoMessengerState#InvalidImplementation;
                    THIS.Category := eAxoMessageCategory#ProgrammingError;
                END_IF;
                IF _context.OpenCycleCount() - ActiveContextCount > UINT#1 THEN
                    THIS.Deactivate(MessageCode);
                END_IF;
            END_IF;   

            IF AcknowledgeRequest THEN
                THIS.Acknowledge(MessageCode);
            END_IF;
            
            IF(THIS.MessengerState <> eAxoMessengerState#Idle) THEN
                THIS.AggregateMessage(LINT#1); 
            ELSE
                THIS.AggregateMessage(LINT#0); 
            END_IF;    
 
        END_METHOD

        METHOD PUBLIC Activate : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _messageCode : ULINT;
                _category : eAxoMessageCategory;
            END_VAR
            IF _context = NULL THEN
                _context := THIS.GetContext();
            END_IF;     

            Activate := THIS;
            
            IF _context = NULL THEN
                RETURN;
            END_IF;

            IF _messageCode = ULINT#0 THEN
                RETURN;
            END_IF;
            
            // "Complete new" activation
            IF THIS.MessengerState = eAxoMessengerState#Idle AND MessageCode = ULINT#0  AND ActiveContextCount = ULINT#0 THEN                
                Risen := _context.GetRtc().NowUTC();
                Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                _context.GetLogger().Log('Risen', THIS.ToLogLevel(_category), THIS);
                MessageCode := _messageCode;
                Category := _category;
                AcknowledgementRequired := Category >= eAxoMessageCategory#Error;
            END_IF;

            // "Reactivation" in case of acknowledgable alarm rised, falled and rised again without acknowledgement
            IF THIS.MessengerState = eAxoMessengerState#InactiveWaitingForAcknowledge AND MessageCode = _messageCode  AND ActiveContextCount = ULINT#0 THEN                
                Risen := _context.GetRtc().NowUTC();
                Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                _context.GetLogger().Log('Risen again before acknowledgement', THIS.ToLogLevel(_category), THIS);
            END_IF;

            IF MessageCode = _messageCode THEN
                ActiveContextCount := _context.OpenCycleCount();
                IF ActiveContextCount = ULINT#0 OR Risen = LDATE_AND_TIME#1970-01-01-00:00:00.000 THEN
                    THIS.MessengerState := eAxoMessengerState#InvalidImplementation;
                    THIS.Category := eAxoMessageCategory#ProgrammingError;
                END_IF;
                IF THIS.MessengerState <> eAxoMessengerState#ActiveAlreadyAcknowledged THEN
                    IF AcknowledgementRequired THEN
                        THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeRequired;
                    ELSE
                        THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeNotRequired;
                    END_IF;
                END_IF;
            END_IF;

            Activate := THIS;
        END_METHOD   

        ///<summary>
        /// Activates the message of the entered category by using the text list on the rising edge of the condition.
        ///</summary>
        METHOD PUBLIC ActivateOnCondition : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _messageCode : ULINT;
                _condition : BOOL;
                _category : eAxoMessageCategory;
            END_VAR

            ActivateOnCondition := THIS;

            IF _condition THEN
                ActivateOnCondition := THIS.Activate(_messageCode,_category);                    
            ELSE
                THIS.Deactivate(_messageCode);        
            END_IF;

        END_METHOD   

        METHOD PRIVATE Deactivate
            VAR_INPUT
                _messageCode : ULINT;
            END_VAR
            IF _context = NULL THEN
                _context := THIS.GetContext();
            END_IF;     

            IF _context = NULL THEN
                RETURN;
            END_IF;

            IF _messageCode = ULINT#0 THEN
                RETURN;
            END_IF;
            
            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired OR THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired OR THIS.MessengerState = eAxoMessengerState#ActiveAlreadyAcknowledged THEN 
                IF  MessageCode = _messageCode THEN
                    ActiveContextCount := ULINT#0;
                    Fallen := _context.GetRtc().NowUTC();                
                    _context.GetLogger().Log('Fallen', eLogLevel#Information, THIS);
                    IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired THEN
                        THIS.MessengerState := eAxoMessengerState#InactiveWaitingForAcknowledge;
                    ELSIF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired THEN
                        THIS.MessengerState := eAxoMessengerState#Idle;
                        MessageCode := ULINT#0;
                    ELSIF THIS.MessengerState = eAxoMessengerState#ActiveAlreadyAcknowledged THEN
                        THIS.MessengerState := eAxoMessengerState#Idle;
                        MessageCode := ULINT#0;
                    END_IF;
                END_IF;
            END_IF;
        END_METHOD   

        METHOD PRIVATE Acknowledge
            VAR_INPUT
                _messageCode : ULINT;
            END_VAR
            IF _context = NULL THEN
                _context := THIS.GetContext();
            END_IF;     

            IF _context = NULL THEN
                RETURN;
            END_IF;

            IF THIS.MessengerState = eAxoMessengerState#InvalidImplementation THEN
                RETURN;
            END_IF;

            IF NOT AcknowledgementRequired THEN
                RETURN;
            END_IF;

            IF _messageCode = ULINT#0 THEN
                RETURN;
            END_IF;
            
            IF MessageCode = _messageCode THEN
                IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired THEN
                    THIS.MessengerState := eAxoMessengerState#ActiveAlreadyAcknowledged; 
                END_IF;

                IF THIS.MessengerState = eAxoMessengerState#InactiveWaitingForAcknowledge THEN
                    THIS.MessengerState := eAxoMessengerState#Idle;
                    MessageCode := ULINT#0;
                END_IF;

                AcknowledgeRequest := FALSE;
                Acknowledged := _context.GetRtc().NowUTC();
            END_IF;
        END_METHOD    

        ///<summary>
        /// Restores all members of this instance to their initial states.
        ///</summary>
        METHOD PUBLIC Restore
            Category := eAxoMessageCategory#All;           
            MessageCode := ULINT#0;
            Risen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
            Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
            AcknowledgementRequired := FALSE;
            AcknowledgeRequest := FALSE;
            Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;;            
            ActiveContextCount := ULINT#0;
            MessengerState := eAxoMessengerState#Idle;
        END_METHOD   

        METHOD PRIVATE ToLogLevel : eLogLevel
            VAR_INPUT
                _messageCategory : eAxoMessageCategory;
            END_VAR    
            
            CASE _messageCategory OF
                eAxoMessageCategory#Trace : 
                    ToLogLevel := eLogLevel#Verbose;
                eAxoMessageCategory#Debug : 
                    ToLogLevel := eLogLevel#Debug;
                eAxoMessageCategory#Info : 
                    ToLogLevel := eLogLevel#Information;    
                eAxoMessageCategory#TimedOut : 
                    ToLogLevel := eLogLevel#Information;
                eAxoMessageCategory#Notification : 
                    ToLogLevel := eLogLevel#Information;
                eAxoMessageCategory#Warning : 
                    ToLogLevel := eLogLevel#Warning;    
                eAxoMessageCategory#Error : 
                    ToLogLevel := eLogLevel#Error;    
                eAxoMessageCategory#ProgrammingError : 
                    ToLogLevel := eLogLevel#Error;     
                eAxoMessageCategory#Critical : 
                    ToLogLevel := eLogLevel#Fatal;  
                eAxoMessageCategory#Fatal : 
                    ToLogLevel := eLogLevel#Fatal;     
                eAxoMessageCategory#Catastrophic : 
                    ToLogLevel := eLogLevel#Fatal;              
            END_CASE;

        END_METHOD    

        ///<summary>
        /// Forces to require the message acknowledgement, even if the message category does not require it by default.
        ///</summary>
        METHOD PUBLIC RequireAcknowledgement : AXOpen.Messaging.Static.IAxoMessageProperties
            AcknowledgementRequired := TRUE;
            RequireAcknowledgement := THIS;
        END_METHOD

        ///<summary>
        /// Forces to not require the message acknowledgement, even if the message category requires it by default.
        ///</summary>
        METHOD PUBLIC DoNotRequireAcknowledgement : AXOpen.Messaging.Static.IAxoMessageProperties
            AcknowledgementRequired := FALSE;
            DoNotRequireAcknowledgement := THIS;
        END_METHOD

        ///<summary>
        /// Returns TRUE if requires the message acknowledgement. 
        ///</summary>
        METHOD PUBLIC IsAcknowledgementRequired : BOOL
            IsAcknowledgementRequired := AcknowledgementRequired;
        END_METHOD
    END_CLASS
END_NAMESPACE
