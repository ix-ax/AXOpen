USING AXOpen.Logging;
USING AXOpen.Core;

NAMESPACE AXOpen.Messaging.Static       
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
            {#ix-attr:[ReadOnly()]}
            Message : STRING[254];            
            Sender : IAxoObject;
        END_VAR

        VAR PRIVATE            
            _context : IAxoContext;         
        END_VAR
        
        VAR PRIVATE
            {#ix-attr:[ReadOnly()]}         
            _requalifiedToCategory : eAxoMessageCategory := eAxoMessageCategory#None; // This property is used to store the new category of the message in case it gets requalified by the messenger service configuration.            
        END_VAR    

        VAR CONSTANT PROTECTED
            RISE_SIGNATURE : STRING[4] := '^ : ';
            FALL_SIGNATURE : STRING[4] := 'v : ';
        END_VAR    
        
       
        ///<summary>
        /// Ensures the inicialization of the instance, so as the deactivation of the message. Must be called cyclically.
        ///</summary>
        METHOD PUBLIC Serve 
            VAR_INPUT
                inObject : IAxoObject;
            END_VAR  
           
            SUPER.Run(inObject);
            _context := THIS.GetContext();
            IF(NOT THIS.IsValid()) THEN
                RETURN;
            END_IF;    
                       
            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired AND NOT AcknowledgementRequired THEN
                THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeNotRequired;                 
            END_IF;

            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired AND AcknowledgementRequired THEN
                THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeRequired;                 
            END_IF;

            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired OR 
               THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired OR 
               THIS.MessengerState = eAxoMessengerState#ActiveAlreadyAcknowledged THEN
                IF _context.OpenCycleCount() = ULINT#0 OR  _context.GetRtc().NowUTC() = LDATE_AND_TIME#1970-01-01-00:00:00.000 THEN
                    THIS.MessengerState := eAxoMessengerState#InvalidImplementation;
                    THIS.Category := eAxoMessageCategory#ProgrammingError;
                END_IF;
                IF _context.OpenCycleCount() - ActiveContextCount > UINT#1 THEN
                    THIS.Deactivate(MessageCode, THIS.ToLogLevel(Category));
                END_IF;
            END_IF;   

            IF AcknowledgeRequest THEN
                THIS.Acknowledge(MessageCode);
            END_IF;
            
            
            IF(_lastMessageAggregationCycle <> _context.OpenCycleCount()) THEN
                THIS.MsgCnt := LINT#0;
            END_IF;   

            IF((THIS.MessengerState = eAxoMessengerState#ActiveAlreadyAcknowledged ||
                THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired ||
                THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired) 
                && Category >= eAxoMessageCategory#Warning) THEN
                THIS.AggregateMessage(LINT#1);            
            END_IF;    
 
        END_METHOD

        METHOD PUBLIC Activate : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _messageCode : ULINT;
                inCategory : eAxoMessageCategory;
            END_VAR
            VAR
                _category : eAxoMessageCategory;
            END_VAR

            _category := inCategory;
            
            IF _context = NULL THEN
                _context := THIS.GetContext();
            END_IF;     

            Activate := THIS;
            
            IF _context = NULL THEN
                RETURN;
            END_IF;

            IF _context.GetMessengerService().IsSuspended() THEN
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
                _context.GetLogger().Log(RISE_SIGNATURE, THIS.ToLogLevel(_category), THIS, _messageCode);
                MessageCode := _messageCode;
                Category := _category;
                _requalifiedToCategory := eAxoMessageCategory#None;
                //  AcknowledgementRequired := Category >= eAxoMessageCategory#Error;
            END_IF;
              
            // "Reactivation" in case of acknowledgable alarm rised, falled and rised again without acknowledgement
            IF THIS.MessengerState = eAxoMessengerState#InactiveWaitingForAcknowledge AND 
                MessageCode = _messageCode  AND 
                ActiveContextCount = ULINT#0 THEN                
                Risen := _context.GetRtc().NowUTC();
                Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;       
                _requalifiedToCategory := eAxoMessageCategory#None;         
            END_IF;

            IF MessageCode = _messageCode THEN
                ActiveContextCount := _context.OpenCycleCount();
                IF ActiveContextCount = ULINT#0 OR Risen = LDATE_AND_TIME#1970-01-01-00:00:00.000 THEN
                    THIS.MessengerState := eAxoMessengerState#InvalidImplementation;
                    THIS.Category := eAxoMessageCategory#ProgrammingError;
                    RETURN;
                END_IF;
                IF THIS.MessengerState <> eAxoMessengerState#ActiveAlreadyAcknowledged THEN
                    IF AcknowledgementRequired THEN
                        THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeRequired;
                    ELSE
                        THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeNotRequired;
                    END_IF;
                END_IF;
            END_IF;

            // This will requalify the message category in case the messenger service is configured to do so.
            // Only potential messages can be requalified to Warning or Error, any other category will not be requalified and will be logged as configured by the user.
            IF(_category = eAxoMessageCategory#Potential 
                AND _context.GetMessengerService().GetRequalifiedMessageCategory() <> eAxoMessageCategory#None
                AND _requalifiedToCategory = eAxoMessageCategory#None) THEN                
                Risen := _context.GetRtc().NowUTC();
                Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;               
                MessageCode := _messageCode;
                Category := _context.GetMessengerService().GetRequalifiedMessageCategory();
                _requalifiedToCategory := Category;
                _context.GetLogger().Log(RISE_SIGNATURE, THIS.ToLogLevel(Category), THIS, _messageCode);
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
                THIS.Deactivate(_messageCode, THIS.ToLogLevel(_category));        
            END_IF;
        END_METHOD   
          
        METHOD PUBLIC Post : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                inParent : IAxoObject;
                inMessage : STRING[254];
                inCategory : eAxoMessageCategory;
            END_VAR
            Post := THIS;            
            IF inParent = NULL THEN                
                RETURN;
            END_IF;
            SUPER.Run(inParent);
            THIS.Sender := inParent;                    
            THIS.Message := inMessage;
            THIS.Activate(ULINT#18446744073709551615, inCategory);  
            IF(THIS.GetContext().GetMessengerService() <> NULL) THEN
                THIS.GetContext().GetMessengerService().QueueMessage(THIS);             
            END_IF;
        END_METHOD

        METHOD PROTECTED Deactivate
            VAR_INPUT
                _messageCode : ULINT;
                _logLevel : eLogLevel;
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
                       
            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired OR 
               THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired OR 
               THIS.MessengerState = eAxoMessengerState#ActiveAlreadyAcknowledged THEN 
                IF  MessageCode = _messageCode THEN
                    ActiveContextCount := ULINT#0;
                    Fallen := _context.GetRtc().NowUTC();     
                    _context.GetLogger().Log(FALL_SIGNATURE, _logLevel, THIS, _messageCode);                       
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
            Category := 0;           
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
                eAxoMessageCategory#Info : 
                    ToLogLevel := eLogLevel#Information;                                        
                eAxoMessageCategory#Warning : 
                    ToLogLevel := eLogLevel#Warning;    
                eAxoMessageCategory#Error : 
                    ToLogLevel := eLogLevel#Error;
                eAxoMessageCategory#ProgrammingError :  
                    ToLogLevel := eLogLevel#Error;                                         
                eAxoMessageCategory#Critical : 
                    ToLogLevel := eLogLevel#Fatal;                  
            END_CASE;

        END_METHOD    
        ///<summary>
        /// Forces to require the message acknowledgement, even if the message category does not require it by default.
        ///</summary>
        METHOD PUBLIC RequireAcknowledgement : AXOpen.Messaging.Static.IAxoMessageProperties
            AcknowledgementRequired := TRUE;
            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired THEN
                THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeRequired;
            END_IF;            
            RequireAcknowledgement := THIS;
        END_METHOD

        ///<summary>
        /// Forces to not require the message acknowledgement, even if the message category requires it by default.
        ///</summary>
        METHOD PUBLIC DoNotRequireAcknowledgement : AXOpen.Messaging.Static.IAxoMessageProperties
            AcknowledgementRequired := FALSE;
            IF THIS.MessengerState = eAxoMessengerState#ActiveAcknowledgeRequired THEN
                THIS.MessengerState := eAxoMessengerState#ActiveAcknowledgeNotRequired;
            END_IF;            
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
