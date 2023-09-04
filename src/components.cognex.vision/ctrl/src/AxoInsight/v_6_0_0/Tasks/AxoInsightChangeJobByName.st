USING AXOpen.Core;
USING System.Strings;
USING System.SerDe;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoInsightChangeJobByName EXTENDS AXOpen.Core.AxoTask
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
            _jobName        :   STRING;
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
                refUser                 :   REF_TO  AxoInsight_UserData;
                refMessenger            :   REF_TO  AxoMessenger;
            END_VAR          

            _infoTime := refConfig^.InfoTime;
            _errorTime := refConfig^.ErrorTime;
            _refStatus := refStatus;
            _refMessenger := refMessenger;

            IF THIS.Execute() THEN
                refMessenger^.Serve(THIS);
                IF _progress = 0 THEN
                    refStatus^.Action.Id := UINT#311;
                    refStatus^.Error.Id := UINT#0;
                    refMessenger^.Restore();
                    refStatus^.CurrentJobName := '';
                    refStatus^.CurrentJobNumber := UINT#0;
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;

                IF _progress = 1 THEN
                    THIS.CallTimers(FALSE);
                    refMessenger^.ActivateOnCondition(ULINT#715, _jobName='', eAxoMessageCategory#Error);

                    IF _jobName='' THEN
                        refStatus^.Error.Id := UINT#715;
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
                    refMessenger^.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#611;
                    END_IF;

                    refAcquisitionControl^.SetOffline := TRUE;
                    IF THIS.SetUserDataAsString(THIS.AppendSuffix(_jobName),UINT#0,refUser,refStatus) THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 6 THEN
                    refMessenger^.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#612;
                    END_IF;

                    refAcquisitionControl^.SetOffline := TRUE;
                    refInspectionControl^.ExtendedUserDataSet := TRUE;
                    IF(refInspectionStatus^.ExtendedUserDataSetAcknowledge) THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;            
                END_IF;
                
                IF _progress = 7 THEN	
                    refMessenger^.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#613;
                    END_IF;

                    refAcquisitionControl^.SetOffline := TRUE;
                    refInspectionControl^.ExtendedUserDataSet := FALSE;
                    IF(NOT refInspectionStatus^.ExtendedUserDataSetAcknowledge) THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
            
                IF _progress = 8 THEN
                    refMessenger^.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        refStatus^.Error.Id := UINT#614;
                    END_IF;

                    refAcquisitionControl^.SetOffline := TRUE;
                    refCommandControl^.Command := UINT#16384;//16#4000;
                    refInspectionControl^.ExecuteCommand:=TRUE;
                    
                    IF(refInspectionStatus^.CommandComplete AND NOT refInspectionStatus^.CommandFailed) THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    ELSIF(refInspectionStatus^.CommandComplete AND refInspectionStatus^.CommandFailed AND NOT refInspectionStatus^.CommandExecuting) THEN
                        _progress := 20;
                    END_IF;
                END_IF;
                
                IF _progress = 9 THEN
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
                
                IF _progress = 10 THEN
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

                IF _progress = 11 THEN
                    refStatus^.CurrentJobName := THIS.AppendSuffix(_jobName);
                    refInspectionControl^.ExecuteCommand := FALSE;
                    refAcquisitionControl^.SetOffline := FALSE;
                    refInspectionControl^.ClearError := FALSE;
                    refCommandControl^.Command := UINT#0;
                    THIS.ThrowWhen(FALSE);
                    THIS.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;               

                IF _progress = 20 THEN
                    refStatus^.Error.Id := UINT#718;
                    _refMessenger^.ActivateOnCondition(ULINT#718, TRUE , eAxoMessageCategory#Error);
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

        METHOD INTERNAL AppendSuffix :STRING
            VAR_INPUT
                jobName : STRING;
            END_VAR
            VAR 
                position : INT;
            END_VAR
            position := LengthOf(jobName) - 4;
            IF EndOf(jobName, position) <> '.job' THEN
                AppendSuffix := Concat(jobName,'.job');
            ELSE
                AppendSuffix := jobName;
            END_IF;
        END_METHOD

        METHOD INTERNAL SetUserDataAsString :   BOOL
            VAR_INPUT
                inValue     :   STRING;
                inPosition  :   UINT;	
                refUser     :   REF_TO  AxoInsight_UserData;
                refStatus   :   REF_TO  AxoInsight_Status;	
            END_VAR
            VAR
                _index : UINT;
                _size : UINT;
                _maxIndex : UINT; 
                _data : ARRAY[0..255] OF BYTE;
            END_VAR
            
            SetUserDataAsString := FALSE;

            _size := TO_UINT(LengthOf(inValue));

            _maxIndex := UINT#254;
            
            _refMessenger^.ActivateOnCondition(ULINT#716, (inPosition +_size) >= TO_UINT(refStatus^.UserDataSize), eAxoMessageCategory#Error);

            IF (inPosition +_size) >= TO_UINT(refStatus^.UserDataSize) THEN
                refStatus^.Error.Id := UINT#716;
                RETURN;
            END_IF;

            _refMessenger^.ActivateOnCondition(ULINT#717, (inPosition +_size) > _maxIndex ,eAxoMessageCategory#Error);
            
            IF (inPosition +_size) > _maxIndex THEN
                refStatus^.Error.Id := UINT#717;
                RETURN;
            END_IF;

            Serialize(UINT#0, inValue, _data);
            FOR	_index := UINT#0 TO _size BY UINT#1 DO	
                refUser^.Data[(inPosition + _index)] := _data[_index + UINT#1];
            END_FOR;
            
            FOR	_index := inPosition +_size TO _maxIndex BY UINT#1 DO	
                refUser^.Data[_index] := BYTE#0;
            END_FOR;
            refUser^.ToggleDataChangedFlag();

            SetUserDataAsString := TRUE;
        END_METHOD

        METHOD INTERNAL CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , _infoTime);
            _errorTimer.OnDelay(THIS, signal , _errorTime );
        END_METHOD

        METHOD PROTECTED OVERRIDE OnRestore 
            _refStatus^.Action.Id := UINT#313;
            _refStatus^.Error.Id  := UINT#0;
            _refMessenger^.Restore();
            _refStatus^.CurrentJobName := '';
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#602;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#312;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#702;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _refStatus <> NULL THEN
                _refStatus^.Action.Id := UINT#310;
            END_IF;
        END_METHOD
        
        METHOD INTERNAL InvokeWithParameters : IAxoTaskState
            VAR_INPUT
                inJobName : STRING;
            END_VAR
            _jobName := inJobName;
            InvokeWithParameters := THIS.Invoke();
        END_METHOD
        
        METHOD PUBLIC Manual
            VAR_INPUT
                RequiredJobName : STRING;
            END_VAR
            _jobName := RequiredJobName;
        END_METHOD
    END_CLASS    
END_NAMESPACE