USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoInsightClearInspectionResults EXTENDS AXOpen.Core.AxoTask
        VAR PROTECTED
            _progress : INT := 0;
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            _errorTimer :  AXOpen.Timers.OnDelayTimer;
        END_VAR

        VAR PRIVATE 
            _infoTime       :   LTIME := LT#2S;
            _errorTime      :   LTIME := LT#5S;
            _refStatus      :   REF_TO  AxoInsight_Status;	
            _refMessenger   :   REF_TO  AxoMessenger;	
        END_VAR

        ///<summary>
        /// Runs the logic of this tasks.
        /// >[!IMPORTANT] This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                refAcquisitionControl   :   REF_TO  AxoInsight_AcquisitionControl;
                refAcquisitionStatus    :   REF_TO  AxoInsight_AcquisitionStatus;
                refInspectionControl    :   REF_TO  AxoInsight_InspectionControl;
                refInspectionStatus     :   REF_TO  AxoInsight_InspectionStatus;
                refConfig               :   REF_TO  AxoInsight_Config;
                refStatus               :   REF_TO  AxoInsight_Status;	
                refResults              :   REF_TO  AxoInsight_Results;
                refInspectionResults    :   REF_TO  AxoInsight_ResultData;
                refMessenger            :   REF_TO  AxoMessenger;    
            END_VAR          

            VAR
                _index : INT;
            END_VAR          

            _infoTime := refConfig^.InfoTime;
            _errorTime := refConfig^.ErrorTime;
            _refStatus := refStatus;
            _refMessenger := refMessenger;

            IF THIS.Execute() THEN
                refMessenger^.Serve(THIS);
                IF _progress = 0 THEN
                    refStatus^.Action.Id := UINT#302;
                    refStatus^.Error.Id := UINT#0;
                    refMessenger^.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 1 THEN
                    refAcquisitionControl^.TriggerEnable := FALSE;
                    refAcquisitionControl^.Trigger := FALSE;
                    refInspectionControl^.AcknowledgeInspectionResults := TRUE;
                    refResults^.InspectionID := UINT#0; 
                    refResults^.ResultCode := UINT#0; 

                    FOR _index := 0 TO 249 DO
                        refInspectionResults^.Data[_index] := BYTE#0;
                    END_FOR;
                    refInspectionResults^.DataChanged := NOT refInspectionResults^.DataChanged ;

                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 2 THEN
                    refMessenger^.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#601;
                    END_IF;

                    IF NOT refInspectionStatus^.ResultsValid THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    refInspectionControl^.AcknowledgeInspectionResults := TRUE;
                    THIS.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;
                
                THIS.CallTimers(TRUE);
                
                THIS.ThrowWhen(_errorTimer.output);
            END_IF;
                        
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , _infoTime);
            _errorTimer.OnDelay(THIS, signal , _errorTime );
        END_METHOD

        METHOD PROTECTED OVERRIDE OnRestore 
            _refStatus^.Action.Id := UINT#308;
            _refStatus^.Error.Id  := UINT#0;
            _refMessenger^.Restore();
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#600;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#303;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#700;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#301;
            END_IF;
        END_METHOD
    END_CLASS     
END_NAMESPACE
