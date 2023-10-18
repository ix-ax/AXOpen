USING AXOpen.Logging;
USING AXOpen.Core;

NAMESPACE AXOpen.Messaging.Static    

    TYPE
        eAxoMessengerState : (Idle, ActiveNoAck, ActiveAckn, NotActiveWatingAckn);
    END_TYPE

    {#ix-prop: public string MessageText }
    {#ix-prop: public string Help }
    {#ix-prop: public string PlcTextList }
    CLASS AxoMessenger EXTENDS AxoObject IMPLEMENTS AXOpen.Messaging.Static.IAxoMessageProperties        
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            {#ix-attr:[CompilerOmits()]} 
            IsActive : BOOL;
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
            WaitingForAcknowledge : BOOL;
            {#ix-attr:[ReadOnly()]}
            {#ix-attr:[CompilerOmits()]} 
            AcknowledgementRequired : BOOL;
            AcknowledgeRequest : BOOL;
            {#ix-attr:[ReadOnly()]}
            AcknowledgedBeforeFallen : BOOL;
            {#ix-attr:[ReadOnly()]}
            Acknowledged : LDATE_AND_TIME; 
            {#ix-attr:[ReadOnly()]}
            MessengerState : eAxoMessengerState; 
        END_VAR

        VAR PRIVATE
            ActiveContextCount : ULINT;
            Context : IAxoContext;         
        END_VAR
 
        ///<summary>
        /// Ensures the inicialization of the instance, so as the deactivation of the message. Must be called cyclically.
        ///</summary>
        METHOD PUBLIC Serve 
            VAR_INPUT
                _context : IAxoContext;
            END_VAR     

            IF  _context_ = null THEN  
                IF _context = NULL THEN
                    RETURN;
                END_IF;

                THIS.Initialize(_context);
                Context := _context; // Duplicity!!!
            ELSE

                THIS.MessengerState := eAxoMessengerState#Idle;
                
                IF THIS.IsActive THEN
                    THIS.MessengerState := eAxoMessengerState#ActiveNoAck;                 
                END_IF;

                IF MessageCode = ULINT#0 THEN
                    IF IsActive THEN
                        IF Context.OpenCycleCount() - ActiveContextCount > UINT#1 THEN
                            THIS.Deactivate();
                        END_IF;
                    ELSIF AcknowledgedBeforeFallen THEN
                        AcknowledgedBeforeFallen := FALSE;
                        THIS.MessengerState := eAxoMessengerState#ActiveAckn;       
                    END_IF;                
                    IF AcknowledgeRequest THEN
                        THIS.Acknowledge();                    
                    END_IF;
                END_IF;

                IF(THIS.WaitingForAcknowledge) THEN
                    THIS.MessengerState := eAxoMessengerState#NotActiveWatingAckn;  
                END_IF;                     
            END_IF; 
            
        END_METHOD
        
        ///<summary>
        /// Ensures the inicialization of the instance, so as the deactivation of the message. Must be called cyclically.
        ///</summary>
        METHOD PUBLIC Serve 
            VAR_INPUT
                _object : IAxoObject;
            END_VAR  
        
            IF  _context_ = null THEN  
                IF _object.GetContext() = NULL THEN
                    RETURN;
                END_IF;

                THIS.Initialize(_object);
                Context := _context_; // Duplicity!!!
            ELSE

                THIS.MessengerState := eAxoMessengerState#Idle;
                
                IF THIS.IsActive THEN
                    THIS.MessengerState := eAxoMessengerState#ActiveNoAck;                 
                END_IF;

                IF MessageCode = ULINT#0 THEN
                    IF IsActive THEN
                        IF Context.OpenCycleCount() - ActiveContextCount > UINT#1 THEN
                            THIS.Deactivate();
                        END_IF;
                    ELSIF AcknowledgedBeforeFallen THEN
                        AcknowledgedBeforeFallen := FALSE;
                        THIS.MessengerState := eAxoMessengerState#ActiveAckn;       
                    END_IF;                
                    IF AcknowledgeRequest THEN
                        THIS.Acknowledge();                    
                    END_IF;
                END_IF;

                IF(THIS.WaitingForAcknowledge) THEN
                    THIS.MessengerState := eAxoMessengerState#NotActiveWatingAckn;  
                END_IF;                     
            END_IF;
        END_METHOD

        ///<summary>
        /// Activates the message of the entered category immediatelly.
        ///</summary>
        METHOD PUBLIC Activate : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _category : eAxoMessageCategory;
            END_VAR

            Activate := THIS;
            
            IF Context = NULL THEN
                RETURN;
            END_IF;
            
            IF MessageCode = ULINT#0 THEN
                IF ActiveContextCount = ULINT#0 THEN                
                    Risen := Context.GetRtc().NowUTC();
                    Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                    Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                    WaitingForAcknowledge := FALSE;
                    Context.GetLogger().Log('Risen', THIS.ToLogLevel(_category), THIS);
                END_IF;

                ActiveContextCount := Context.OpenCycleCount();

                Category := _category;

                AcknowledgementRequired := Category >= eAxoMessageCategory#Error;

                IsActive := TRUE;
            END_IF;

            Activate := THIS;
        END_METHOD   
        
        METHOD PRIVATE Activate : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _messageCode : ULINT;
                _category : eAxoMessageCategory;
            END_VAR

            Activate := THIS;
            
            IF Context = NULL THEN
                RETURN;
            END_IF;
            
            IF NOT IsActive AND NOT WaitingForAcknowledge AND MessageCode = ULINT#0 AND ActiveContextCount = ULINT#0 THEN                
                Risen := Context.GetRtc().NowUTC();
                Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                WaitingForAcknowledge := FALSE;
                Context.GetLogger().Log('Risen', THIS.ToLogLevel(_category), THIS);
                MessageCode := _messageCode;
            END_IF;

            IF MessageCode = _messageCode THEN
                ActiveContextCount := Context.OpenCycleCount();
                Category := _category;
                AcknowledgementRequired := Category >= eAxoMessageCategory#Error;
                IsActive := TRUE;
            END_IF;

            Activate := THIS;
        END_METHOD   

        ///<summary>
        /// Activates the message of the entered category on the rising edge of the condition.
        ///</summary>
        METHOD PUBLIC ActivateOnCondition : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _condition : BOOL;
                _category : eAxoMessageCategory;
            END_VAR

            ActivateOnCondition := THIS;

            IF _condition THEN
                ActivateOnCondition := THIS.Activate(_category);                    
            ELSE
                THIS.Deactivate();        
            END_IF;
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

            IF NOT IsActive AND AcknowledgedBeforeFallen THEN
                AcknowledgedBeforeFallen := FALSE;
                MessageCode := ULINT#0;
            END_IF;

            IF AcknowledgeRequest THEN
                THIS.Acknowledge(MessageCode);
            END_IF;
        END_METHOD   

        METHOD PRIVATE Deactivate
            VAR_INPUT
                _messageCode : ULINT;
            END_VAR

            IF Context = NULL THEN
                RETURN;
            END_IF;

            IF IsActive THEN 
                IF  MessageCode = _messageCode THEN
                    IsActive := FALSE;
                    ActiveContextCount := ULINT#0;
                    Fallen := Context.GetRtc().NowUTC();                
                    Context.GetLogger().Log('Fallen', eLogLevel#Information, THIS);
                    IF AcknowledgementRequired AND NOT AcknowledgedBeforeFallen THEN
                        WaitingForAcknowledge := TRUE;
                    ELSE
                        MessageCode := ULINT#0;
                    END_IF;
                END_IF;
            END_IF;
        END_METHOD   

        METHOD PRIVATE Deactivate
            IF Context = NULL THEN
                RETURN;
            END_IF;

            IF IsActive THEN 
                IF MessageCode = ULINT#0 THEN
                    IsActive := FALSE;
                    ActiveContextCount := ULINT#0;
                    Fallen := Context.GetRtc().NowUTC();                
                    Context.GetLogger().Log('Fallen', eLogLevel#Information, THIS);
                    IF AcknowledgementRequired AND NOT AcknowledgedBeforeFallen THEN
                        WaitingForAcknowledge := TRUE;
                    END_IF;
                END_IF;
            END_IF;
        END_METHOD   

        METHOD PRIVATE Acknowledge
            VAR_INPUT
                _messageCode : ULINT;
            END_VAR
            IF Context = NULL THEN
                RETURN;
            END_IF;

            IF NOT AcknowledgementRequired THEN
                RETURN;
            END_IF;

            IF MessageCode = _messageCode THEN
                IF NOT WaitingForAcknowledge THEN
                    AcknowledgedBeforeFallen := TRUE;
                ELSE
                    WaitingForAcknowledge := FALSE;
                    MessageCode := ULINT#0;
                END_IF;
                AcknowledgeRequest := FALSE;
                Acknowledged := Context.GetRtc().NowUTC();
            END_IF;
        END_METHOD    

        METHOD PRIVATE Acknowledge
            IF Context = NULL THEN
                RETURN;
            END_IF;

            IF NOT AcknowledgementRequired THEN
                RETURN;
            END_IF;

            IF NOT WaitingForAcknowledge THEN
                AcknowledgedBeforeFallen := TRUE;
            ELSE
                WaitingForAcknowledge := FALSE;
                MessageCode := ULINT#0;
            END_IF;
            AcknowledgeRequest := FALSE;
            Acknowledged := Context.GetRtc().NowUTC();
        END_METHOD    

        ///<summary>
        /// Restores all members of this instance to their initial states.
        ///</summary>
        METHOD PUBLIC Restore
            IF Context = NULL THEN
                RETURN;
            END_IF;

            IsActive := FALSE;
            Category := eAxoMessageCategory#All;           
            MessageCode := ULINT#0;
            Risen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
            Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
            WaitingForAcknowledge := FALSE;
            AcknowledgementRequired := FALSE;
            AcknowledgeRequest := FALSE;
            AcknowledgedBeforeFallen := FALSE;
            Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;;            
            ActiveContextCount := ULINT#0;
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