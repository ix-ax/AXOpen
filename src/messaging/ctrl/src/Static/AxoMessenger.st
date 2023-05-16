USING AXOpen.Core;

NAMESPACE AXOpen.Messaging.Static    
    {#ix-prop: public string MessageText }
    {#ix-prop: public string Help }
    CLASS AxoMessenger IMPLEMENTS IAxoMessageProperties        
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
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
            
            IF IsActive THEN
                IF  Context.OpenCycleCount() - ActiveContextCount > UINT#1 THEN
                    THIS.Deactivate();
                END_IF;
            ELSE
                AcknowledgedBeforeFallen := FALSE;
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
            THIS.Serve(_object.GetContext());
        END_METHOD

        METHOD PUBLIC Activate : IAxoMessageProperties
            VAR_INPUT
                _category : eAxoMessageCategory;
            END_VAR

            Activate := THIS;

            IF AXOpen.Core.IsNullContext(Context) THEN
                RETURN;
            END_IF;

            IF ActiveContextCount = ULINT#0 THEN
                Risen := Context.GetRtc().NowUTC();
                Fallen := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                Acknowledged := LDATE_AND_TIME#1970-01-01-00:00:00.000;
                WaitingForAcknowledge := FALSE;
            END_IF;

            ActiveContextCount := Context.OpenCycleCount();

            Category := _category;

            AcknowledgementRequired := Category >= eAxoMessageCategory#Error;

            IsActive := TRUE;

            Activate := THIS;
        END_METHOD   
        
        METHOD PUBLIC ActivateOnCondition : IAxoMessageProperties
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
            END_IF;
            AcknowledgeRequest := FALSE;

            Acknowledged := Context.GetRtc().NowUTC();
        END_METHOD    

        METHOD PRIVATE Deactivate
            IF AXOpen.Core.IsNullContext(Context) THEN
                RETURN;
            END_IF;

            IF IsActive THEN
                IsActive := FALSE;
                ActiveContextCount := ULINT#0;
                Fallen := Context.GetRtc().NowUTC();
                IF AcknowledgementRequired AND NOT AcknowledgedBeforeFallen THEN
                    WaitingForAcknowledge := TRUE;
                END_IF;
            END_IF;
        END_METHOD   

        METHOD PUBLIC RequireAcknowledgement : IAxoMessageProperties
            AcknowledgementRequired := TRUE;
            RequireAcknowledgement := THIS;
        END_METHOD

        METHOD PUBLIC DoNotRequireAcknowledgement : IAxoMessageProperties
            AcknowledgementRequired := FALSE;
            DoNotRequireAcknowledgement := THIS;
        END_METHOD

        METHOD PUBLIC IsAcknowledgementRequired : BOOL
            IsAcknowledgementRequired := AcknowledgementRequired;
        END_METHOD
    END_CLASS

END_NAMESPACE