USING AXOpen.Core;
USING System.Strings;
USING System.SerDe;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoInsightSoftEvent EXTENDS AXOpen.Core.AxoTask
        VAR PROTECTED
            _progress : INT := 0;
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            _errorTimer :  AXOpen.Timers.OnDelayTimer;
        END_VAR

        VAR PRIVATE 
            _infoTime           :   LTIME := LT#2S;
            _errorTime          :   LTIME := LT#5S;
            _refStatus          :   REF_TO  AxoInsight_Status;	
            _refMessenger       :   REF_TO  AxoMessenger;	
            _softEventNumber    :   UINT;
        END_VAR

        ///<summary>
        /// Runs the logic of this tasks.
        /// >[!IMPORTANT] This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                refAcquisitionControl               :   REF_TO  AxoInsight_AcquisitionControl;
                refAcquisitionStatus                :   REF_TO  AxoInsight_AcquisitionStatus;
                refInspectionControl                :   REF_TO  AxoInsight_InspectionControl;
                refInspectionStatus                 :   REF_TO  AxoInsight_InspectionStatus;
                refCommandControl                   :   REF_TO  AxoInsight_CommandControl;
                refConfig                           :   REF_TO  AxoInsight_Config;
                refStatus                           :   REF_TO  AxoInsight_Status;	
                refTriggerSoftEvent                 :   REF_TO  AxoInsight_SoftEventControl;	
                refTriggerSoftEventAcknowledge      :   REF_TO  AxoInsight_SoftEventStatus;	
                refMessenger                        :   REF_TO  AxoMessenger;
            END_VAR          

            _infoTime := refConfig^.InfoTime;
            _errorTime := refConfig^.ErrorTime;
            _refStatus := refStatus;
            _refMessenger := refMessenger;
        
            IF THIS.Execute() THEN
                refMessenger^.Serve(THIS);
                IF _progress = 0 THEN
                    refStatus^.Action.Id := UINT#319;
                    refStatus^.Error.Id := UINT#0;
                    refMessenger^.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;

                IF _progress = 1 THEN
                    THIS.CallTimers(FALSE);
                    _refMessenger^.ActivateOnCondition(ULINT#721, _softEventNumber > UINT#7, eAxoMessageCategory#Error);

                    IF _softEventNumber > UINT#7 THEN
                        refStatus^.Error.Id := UINT#721;
                        THIS.ThrowWhen(TRUE);
                    ELSE	
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 2 THEN
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 3 THEN
                    refMessenger^.ActivateOnCondition(ULINT#617, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#617;
                    END_IF;

                    refTriggerSoftEvent^.TriggerSoftEvent.Data[_softEventNumber] := TRUE;
                    refTriggerSoftEvent^.TriggerSoftEvent.ToggleDataChangedFlag();
                    IF refTriggerSoftEventAcknowledge^.TriggerSoftEventAcknowledge.Data[_softEventNumber] THEN
                        refTriggerSoftEventAcknowledge^.TriggerSoftEventAcknowledge.ToggleDataChangedFlag();
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 4 THEN
                    refMessenger^.ActivateOnCondition(ULINT#618, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#618;
                    END_IF;

                    refTriggerSoftEvent^.TriggerSoftEvent.Data[_softEventNumber] := FALSE;
                    refTriggerSoftEvent^.TriggerSoftEvent.ToggleDataChangedFlag();
                    IF NOT refTriggerSoftEventAcknowledge^.TriggerSoftEventAcknowledge.Data[_softEventNumber] THEN
                        refTriggerSoftEventAcknowledge^.TriggerSoftEventAcknowledge.ToggleDataChangedFlag();
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 5 THEN
                    THIS.ThrowWhen(FALSE);
                    THIS.DoneWhen(TRUE);
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
            _refStatus^.Action.Id := UINT#321;
            _refStatus^.Error.Id  := UINT#0;
            _refMessenger^.Restore();
            _refStatus^.CurrentJobNumber := UINT#0;
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#604;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#320;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#704;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#318;
            END_IF;
        END_METHOD
        
        METHOD INTERNAL InvokeWithParameters : IAxoTaskState
            VAR_INPUT
                inSoftEventNumber : UINT;
            END_VAR
            _softEventNumber := inSoftEventNumber;
            InvokeWithParameters := THIS.Invoke();
        END_METHOD
        
        METHOD PUBLIC Manual
            VAR_INPUT
                RequiredSoftEventNumber : UINT;
            END_VAR
            _softEventNumber := RequiredSoftEventNumber;
        END_METHOD
    END_CLASS    
END_NAMESPACE