USING AXOpen.Logging;
USING AXOpen.Core;

NAMESPACE AXOpen.Messaging.Static    
    {#ix-prop: public string MessageText }
    {#ix-prop: public string MessageTextList }
    {#ix-prop: public string Help }
    CLASS AxoMessenger EXTENDS AxoObject IMPLEMENTS AXOpen.Messaging.Static.IAxoMessageProperties        
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            IsActive : BOOL;
            {#ix-attr:[ReadOnly()]}
            Category : eAxoMessageCategory;           
            {#ix-attr:[ReadOnly()]}
            MessageCode : INT;
            {#ix-attr:[ReadOnly()]}
            Risen : LDATE_AND_TIME;
            {#ix-attr:[ReadOnly()]}
            Fallen : LDATE_AND_TIME;
            {#ix-attr:[ReadOnly()]}
            WaitingForAcknowledge : BOOL;
            {#ix-attr:[ReadOnly()]}
            AcknowledgementRequired : BOOL;
            AcknowledgeRequest : BOOL;
            {#ix-attr:[ReadOnly()]}
            AcknowledgedBeforeFallen : BOOL;
            {#ix-attr:[ReadOnly()]}
            Acknowledged : LDATE_AND_TIME;            
        END_VAR

        VAR PRIVATE
            ActiveContextCount : ULINT;
            Context : IAxoContext;         
        END_VAR

        METHOD PUBLIC Serve 
            VAR_INPUT
                _context : IAxoContext;
            END_VAR     

            IF AXOpen.Core.IsNullContext(_context) THEN
                RETURN;
            END_IF;

            Context := _context;

            IF MessageCode = INT#0 THEN
                IF IsActive THEN
                    IF Context.OpenCycleCount() - ActiveContextCount > UINT#1 THEN
                        THIS.Deactivate();
                    END_IF;
                ELSIF AcknowledgedBeforeFallen THEN
                    AcknowledgedBeforeFallen := FALSE;
                END_IF;
            ELSE
                IF IsActive THEN
                    IF Context.OpenCycleCount() - ActiveContextCount > UINT#1 THEN
                        THIS.Deactivate(MessageCode);
                    END_IF;
                ELSIF AcknowledgedBeforeFallen THEN
                    AcknowledgedBeforeFallen := FALSE;
                    MessageCode := INT#0;
                END_IF;
            END_IF;

            IF AcknowledgeRequest THEN
                THIS.Acknowledge();
            END_IF;
        END_METHOD

        METHOD PUBLIC Serve 
            VAR_INPUT
                _object : IAxoObject;
            END_VAR  
            IF AXOpen.Core.IsNullContext(_object.GetContext()) THEN
                RETURN;
            END_IF;
            THIS.Initialize(_object);

            THIS.Serve(_object.GetContext());                       
        END_METHOD

        METHOD PUBLIC Activate : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _category : eAxoMessageCategory;
            END_VAR

            Activate := THIS;
            
            IF AXOpen.Core.IsNullContext(Context) THEN
                RETURN;
            END_IF;
            
            IF MessageCode = INT#0 THEN
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
        
        METHOD PUBLIC Activate : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _messageCode : INT;
                _category : eAxoMessageCategory;
            END_VAR

            Activate := THIS;
            
            IF AXOpen.Core.IsNullContext(Context) THEN
                RETURN;
            END_IF;
            
            IF NOT IsActive AND NOT WaitingForAcknowledge AND MessageCode = INT#0 AND ActiveContextCount = ULINT#0 THEN                
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
        
        
        // METHOD PUBLIC Activate : AXOpen.Messaging.Static.IAxoMessageProperties
        //     VAR_INPUT
        //         _messageCode : INT;
        //         _category : eAxoMessageCategory;
        //     END_VAR

        //     Activate := THIS;

        //     IF NOT IsActive AND NOT WaitingForAcknowledge THEN
        //         MessageCode := _messageCode;
        //     END_IF;
        //     Activate := THIS.Activate(_category);
        // END_METHOD   

        // METHOD PUBLIC Activate : AXOpen.Messaging.Static.IAxoMessageProperties
        //     Activate := THIS;
        //     Activate := THIS.Activate(eAxoMessageCategory#All);
        // END_METHOD   

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

        METHOD PUBLIC ActivateOnCondition : AXOpen.Messaging.Static.IAxoMessageProperties
            VAR_INPUT
                _messageCode : INT;
                _condition : BOOL;
                _category : eAxoMessageCategory;
            END_VAR

            ActivateOnCondition := THIS;

            IF NOT IsActive AND NOT WaitingForAcknowledge AND _condition THEN
                MessageCode := _messageCode;
            END_IF;
            IF _condition THEN
                ActivateOnCondition := THIS.Activate(_messageCode,_category);                    
            ELSE
                THIS.Deactivate(_messageCode);        
            END_IF;
        END_METHOD   

        METHOD PRIVATE Deactivate
            VAR_INPUT
                _messageCode : INT;
            END_VAR

            IF AXOpen.Core.IsNullContext(Context) THEN
                RETURN;
            END_IF;

            IF IsActive AND MessageCode = _messageCode THEN
                IsActive := FALSE;
                ActiveContextCount := ULINT#0;
                Fallen := Context.GetRtc().NowUTC();                
                Context.GetLogger().Log('Fallen', eLogLevel#Information, THIS);
                IF AcknowledgementRequired AND NOT AcknowledgedBeforeFallen THEN
                    WaitingForAcknowledge := TRUE;
                ELSE
                    MessageCode := INT#0;
                END_IF;
            END_IF;
        END_METHOD   

        METHOD PRIVATE Deactivate
            IF AXOpen.Core.IsNullContext(Context) THEN
                RETURN;
            END_IF;

            IF IsActive AND MessageCode = INT#0 THEN
                IsActive := FALSE;
                ActiveContextCount := ULINT#0;
                Fallen := Context.GetRtc().NowUTC();                
                Context.GetLogger().Log('Fallen', eLogLevel#Information, THIS);
                IF AcknowledgementRequired AND NOT AcknowledgedBeforeFallen THEN
                    WaitingForAcknowledge := TRUE;
                END_IF;
            END_IF;
        END_METHOD   

        METHOD PUBLIC Acknowledge
            IF AXOpen.Core.IsNullContext(Context) THEN
                RETURN;
            END_IF;

            IF NOT AcknowledgementRequired THEN
                RETURN;
            END_IF;

            IF NOT WaitingForAcknowledge THEN
                AcknowledgedBeforeFallen := TRUE;
            ELSE
                WaitingForAcknowledge := FALSE;
                MessageCode := INT#0;
            END_IF;
            AcknowledgeRequest := FALSE;

            Acknowledged := Context.GetRtc().NowUTC();
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

        METHOD PUBLIC RequireAcknowledgement : AXOpen.Messaging.Static.IAxoMessageProperties
            AcknowledgementRequired := TRUE;
            RequireAcknowledgement := THIS;
        END_METHOD

        METHOD PUBLIC DoNotRequireAcknowledgement : AXOpen.Messaging.Static.IAxoMessageProperties
            AcknowledgementRequired := FALSE;
            DoNotRequireAcknowledgement := THIS;
        END_METHOD

        METHOD PUBLIC IsAcknowledgementRequired : BOOL
            IsAcknowledgementRequired := AcknowledgementRequired;
        END_METHOD
    END_CLASS

END_NAMESPACE