USING AXOpen.Core;
USING System.Strings;
USING System.SerDe;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoInsightChangeJobByNumber EXTENDS AXOpen.Core.AxoTask
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
            _jobNumber      :   UINT;
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
                refCommandControl       :   REF_TO  AxoInsight_CommandControl;
                refConfig               :   REF_TO  AxoInsight_Config;
                refStatus               :   REF_TO  AxoInsight_Status;	
                refMessenger            :   REF_TO  AxoMessenger;
            END_VAR          

            _infoTime := refConfig^.InfoTime;
            _errorTime := refConfig^.ErrorTime;
            _refStatus := refStatus;
            _refMessenger := refMessenger;
        
            IF THIS.Execute() THEN
                refMessenger^.Serve(THIS);
                IF _progress = 0 THEN
                    refStatus^.Action.Id := UINT#315;
                    refStatus^.Error.Id := UINT#0;
                    refMessenger^.Restore();
                    refStatus^.CurrentJobName := '';
                    refStatus^.CurrentJobNumber := UINT#0;
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;

                END_IF;

                IF _progress = 1 THEN
                    THIS.CallTimers(FALSE);
                    _refMessenger^.ActivateOnCondition(ULINT#719, _jobNumber > refConfig^.MaxJobNumber, eAxoMessageCategory#Error);

                    IF _jobNumber > refConfig^.MaxJobNumber THEN
                        refStatus^.Error.Id := UINT#719;
                        THIS.ThrowWhen(TRUE);
                    ELSE	
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 2 THEN
                    refMessenger^.ActivateOnCondition(ULINT#608, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#608;
                    END_IF;

                    refInspectionControl^.ExecuteCommand:=FALSE;
                    refInspectionControl^.ClearError:=FALSE;
                    refAcquisitionControl^.SetOffline := FALSE;
                    IF NOT refInspectionStatus^.CommandExecuting THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    refMessenger^.ActivateOnCondition(ULINT#609, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#609;
                    END_IF;

                    refAcquisitionControl^.SetOffline := TRUE;
                    IF(NOT refAcquisitionStatus^.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 4 THEN
                    refMessenger^.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#610;
                    END_IF;

                    refAcquisitionControl^.SetOffline := TRUE;
                    refInspectionControl^.ExecuteCommand := FALSE;
                    refInspectionControl^.ClearError := refInspectionStatus^.Error;
                    IF NOT refInspectionStatus^.Error THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 5 THEN
                    refMessenger^.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#614;
                    END_IF;

                    refAcquisitionControl^.SetOffline := TRUE;
                    refCommandControl^.Command := _jobNumber;
                    refInspectionControl^.ExecuteCommand:=TRUE;
                    
                    IF(refInspectionStatus^.CommandComplete AND NOT refInspectionStatus^.CommandFailed) THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    ELSIF(refInspectionStatus^.CommandComplete AND refInspectionStatus^.CommandFailed AND NOT refInspectionStatus^.CommandExecuting) THEN
                        _progress := 20;
                    END_IF;
                END_IF;
                
                IF _progress = 6 THEN
                    refMessenger^.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#615;
                    END_IF;

                    refAcquisitionControl^.SetOffline := TRUE;
                    refCommandControl^.Command := UINT#0;
                    refInspectionControl^.ExecuteCommand:=FALSE;
                    IF(NOT refInspectionStatus^.CommandComplete) THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 7 THEN	
                    refMessenger^.ActivateOnCondition(ULINT#616, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#616;
                    END_IF;

                    refAcquisitionControl^.SetOffline := FALSE;
                    IF(refAcquisitionStatus^.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 8 THEN
                    refStatus^.CurrentJobNumber := _jobNumber;
                    refInspectionControl^.ExecuteCommand := FALSE;
                    refAcquisitionControl^.SetOffline := FALSE;
                    refInspectionControl^.ClearError := FALSE;
                    refCommandControl^.Command := UINT#0;
                    THIS.ThrowWhen(FALSE);
                    THIS.DoneWhen(TRUE);
                    _progress := 0;            
                END_IF;               

                IF _progress = 20 THEN
                    refStatus^.Error.Id := UINT#720;
                    _refMessenger^.ActivateOnCondition(ULINT#720, TRUE , eAxoMessageCategory#Error);
                    refInspectionControl^.ExecuteCommand := FALSE;
                    refAcquisitionControl^.SetOffline := FALSE;
                    refCommandControl^.Command := UINT#0;
                    THIS.ThrowWhen(TRUE);
                    THIS.DoneWhen(FALSE);
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
            _refStatus^.Action.Id := UINT#317;
            _refStatus^.Error.Id  := UINT#0;
            _refMessenger^.Restore();
            _refStatus^.CurrentJobNumber := UINT#0;
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#603;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#316;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#703;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#314;
            END_IF;
        END_METHOD
        
        METHOD INTERNAL InvokeWithParameters : IAxoTaskState
            VAR_INPUT
                inJobNumber : UINT;
            END_VAR
            _jobNumber := inJobNumber;
            InvokeWithParameters := THIS.Invoke();
        END_METHOD
        
        METHOD PUBLIC Manual
            VAR_INPUT
                RequiredJobNumber : UINT;
            END_VAR
            _jobNumber := RequiredJobNumber;
        END_METHOD
    END_CLASS    
END_NAMESPACE