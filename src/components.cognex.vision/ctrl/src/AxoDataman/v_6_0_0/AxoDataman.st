USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;

NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0

    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoDataman EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.IAxoCodeReader 
        VAR PRIVATE
            _ResultDataSize          :   eAxoDataman_ResultDataSize;
            _UserDataSize            :   eAxoDataman_UserDataSize;
            _hwID                    :   WORD;
            _hwIdAcquisitionControl  :   WORD;
            _hwIdAcquisitionStatus   :   WORD;
            _hwIdResultsControl      :   WORD;
            _hwIdResultsStatus       :   WORD;
            _hwIdSoftEventControl    :   WORD;
            _hwIdResultData          :   WORD;
            _hwIdUserData            :   WORD;

            _progress : INT := 0;
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            _errorTimer :  AXOpen.Timers.OnDelayTimer;
            _inspectionCompleted    : BOOL;
            _data_in : ARRAY[0..254] OF BYTE;
            _jobNumber      :   UINT;
            _softEventNumber    :   UINT;
            _UserDataChanged         :   BOOL;

        END_VAR            
        
        VAR PUBLIC //Header
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Read#>"}
            ReadTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Inspection results#>"}
            {#ix-set:DisplayFormat = "string"}
            ResultData  :   AxoDataman_ResultData;
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear result data#>"}
            ClearResultDataTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC //Config
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            Config      :   AxoDataman_Config;

        END_VAR

        VAR PUBLIC //Status
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status      :   AxoDataman_Status;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Results#>"}
            Results     :   AxoDataman_Results;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Acquisition control#>"}
            {#ix-attr:[ReadOnly()]}
            AcquisitionControl     :   AxoDataman_AcquisitionControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Acquisition status#>"}
            {#ix-attr:[ReadOnly()]}
            AcquisitionStatus      :   AxoDataman_AcquisitionStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Results control#>"}
            {#ix-attr:[ReadOnly()]}
            ResultsControl         :   AxoDataman_ResultsControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Results status#>"}
            {#ix-attr:[ReadOnly()]}
            ResultsStatus          :   AxoDataman_ResultsStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Soft-event control#>"}
            {#ix-attr:[ReadOnly()]}
            SoftEventControl       :   AxoDataman_SoftEventControl;
 
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Soft-event status#>"}
            {#ix-attr:[ReadOnly()]}
            SoftEventStatus        :   AxoDataman_SoftEventStatus;
 
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#User data#>"}
            {#ix-attr:[ReadOnly()]}
            User        :   AxoDataman_User;
            {#ix-set:AttributeName = "<#User data#>"}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:DisplayFormat = "hexadecimal"}
            UserData        :   AxoDataman_UserData;
        END_VAR

        VAR PUBLIC //Hardware diagnostics
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PUBLIC //Messengers
            Messenger          :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger      :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent                  :   IAxoObject; 
                ResultDataSize          :   eAxoDataman_ResultDataSize;
                UserDataSize            :   eAxoDataman_UserDataSize;
                hwID                    :   WORD;
                hwIdAcquisitionControl  :   WORD;
                hwIdAcquisitionStatus   :   WORD;
                hwIdResultsControl      :   WORD;
                hwIdResultsStatus       :   WORD;
                hwIdSoftEventControl    :   WORD;
                hwIdResultData          :   WORD;
                hwIdUserData            :   WORD;
            END_VAR

            
            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwIdAcquisitionControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwIdAcquisitionStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwIdResultsControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwIdResultsStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,hwIdSoftEventControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,hwIdResultData = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,hwIdUserData = WORD#0, eAxoMessageCategory#ProgrammingError);            

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwIdAcquisitionControl = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdAcquisitionStatus = WORD#0 THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdResultsControl = WORD#0 THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdResultsStatus = WORD#0 THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF hwIdSoftEventControl = WORD#0 THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF hwIdResultData = WORD#0 THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF hwIdUserData = WORD#0 THEN
                Status.Error.Id := UINT#707;
                RETURN;
            END_IF;

            _hwID                    := hwID;
            _ResultDataSize          := ResultDataSize;
            _UserDataSize            := UserDataSize;
            _hwIdAcquisitionControl  := hwIdAcquisitionControl;
            _hwIdAcquisitionStatus   := hwIdAcquisitionStatus;
            _hwIdResultsControl      := hwIdResultsControl;
            _hwIdResultsStatus       := hwIdResultsStatus;
            _hwIdSoftEventControl    := hwIdSoftEventControl;
            _hwIdResultData          := hwIdResultData;
            _hwIdUserData            := hwIdUserData;     

            THIS.Initialize(parent);
            
            THIS.Open();
            THIS.Execute();
            THIS.Close();                   
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent                  :   IAxoContext; 
                ResultDataSize          :   eAxoDataman_ResultDataSize;
                UserDataSize            :   eAxoDataman_UserDataSize;
                hwID                    :   WORD;
                hwIdAcquisitionControl  :   WORD;
                hwIdAcquisitionStatus   :   WORD;
                hwIdResultsControl      :   WORD;
                hwIdResultsStatus       :   WORD;
                hwIdSoftEventControl    :   WORD;
                hwIdResultData          :   WORD;
                hwIdUserData            :   WORD;
            END_VAR

            
            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwIdAcquisitionControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwIdAcquisitionStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwIdResultsControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwIdResultsStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,hwIdSoftEventControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,hwIdResultData = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,hwIdUserData = WORD#0, eAxoMessageCategory#ProgrammingError);            

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwIdAcquisitionControl = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdAcquisitionStatus = WORD#0 THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdResultsControl = WORD#0 THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdResultsStatus = WORD#0 THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF hwIdSoftEventControl = WORD#0 THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF hwIdResultData = WORD#0 THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF hwIdUserData = WORD#0 THEN
                Status.Error.Id := UINT#707;
                RETURN;
            END_IF;

            _hwID                    := hwID;
            _ResultDataSize          := ResultDataSize;
            _UserDataSize            := UserDataSize;
            _hwIdAcquisitionControl  := hwIdAcquisitionControl;
            _hwIdAcquisitionStatus   := hwIdAcquisitionStatus;
            _hwIdResultsControl      := hwIdResultsControl;
            _hwIdResultsStatus       := hwIdResultsStatus;
            _hwIdSoftEventControl    := hwIdSoftEventControl;
            _hwIdResultData          := hwIdResultData;
            _hwIdUserData            := hwIdUserData;     

            THIS.Initialize(parent);
            
            THIS.Open();
            THIS.Execute();
            THIS.Close();       
        END_METHOD

        METHOD PRIVATE UpdateInputs : BOOL
            VAR
                returnValue : WORD;
                _invalidDataSize : BOOL;
            END_VAR

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAcquisitionStatus ,_data_in);
            Messenger.ActivateOnCondition(ULINT#708,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#708;
                RETURN;
            END_IF;

            AcquisitionStatus.TriggerReady                  :=      _data_in[0].%X0;
            AcquisitionStatus.TriggerAcknowledge            :=      _data_in[0].%X1;
            AcquisitionStatus.MissedAcquisition             :=      _data_in[0].%X3;
            AcquisitionStatus.TriggerID.%B1                 :=      _data_in[1];	 
            AcquisitionStatus.TriggerID.%B0                 :=      _data_in[2];	 

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdResultsStatus ,_data_in);
            Messenger.ActivateOnCondition(ULINT#709,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#709;
                RETURN;
            END_IF;

            ResultsStatus.Decoding                          :=      _data_in[0].%X0;
            ResultsStatus.DecodeComplete                    :=      _data_in[0].%X1;
            ResultsStatus.ResultsBufferOverrun              :=      _data_in[0].%X2;
            ResultsStatus.ResultsAvailable                  :=      _data_in[0].%X3;
            ResultsStatus.ErrorDetected                     :=      _data_in[0].%X7;

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdSoftEventControl ,_data_in);
            Messenger.ActivateOnCondition(ULINT#710,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#710;
                RETURN;
            END_IF;

            SoftEventStatus.TrainCodeAcknowledge            :=      _data_in[0].%X0;
            SoftEventStatus.TrainMatchStringAcknowledge     :=      _data_in[0].%X1;
            SoftEventStatus.TrainFocusAcknowledge           :=      _data_in[0].%X2;
            SoftEventStatus.TrainBrightnessAcknowledge      :=      _data_in[0].%X3;
            SoftEventStatus.UntrainAcknowledge              :=      _data_in[0].%X4;
            SoftEventStatus.ExecuteDmccAcknowledge          :=      _data_in[0].%X5;
            SoftEventStatus.Reserved06                      :=      _data_in[0].%X6;
            SoftEventStatus.SetMatchStringAcknowledge       :=      _data_in[0].%X7;

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdResultData ,_data_in);
            Messenger.ActivateOnCondition(ULINT#711,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#711;
                RETURN;
            END_IF;

            _invalidDataSize := NOT (_ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_16B OR
            _ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_32B OR
            _ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_64B OR
            _ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_128B OR
            _ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_246B);

            Messenger.ActivateOnCondition(ULINT#712,_invalidDataSize, eAxoMessageCategory#ProgrammingError);

            IF _invalidDataSize THEN
                Status.Error.Id := UINT#712;
                RETURN;
            END_IF;

            Config.ResultDataSize := _ResultDataSize;


            Results.Id.%B1          :=  _data_in[0];     
            Results.Id.%B0          :=  _data_in[1];     
            Results.Code.%B1        :=  _data_in[2];     
            Results.Code.%B0        :=  _data_in[3];     
            Results.Extended.%B1    :=  _data_in[4];     
            Results.Extended.%B0    :=  _data_in[5];     
            Results.Length.%B1      :=  _data_in[6];     
            Results.Length.%B0      :=  _data_in[7];     
            UpdateInputs := TRUE;

        END_METHOD  

        METHOD PRIVATE UpdateOutputs : BOOL
            VAR
                index                   :   INT;
                _invalidDataSize        :   BOOL;
                returnValue             :   WORD;
                _data_1                 :   ARRAY[0..0] OF BYTE;
                _data_16                :   ARRAY[0..15] OF BYTE;
                _data_32                :   ARRAY[0..31] OF BYTE;
                _data_64                :   ARRAY[0..63] OF BYTE;
                _data_128               :   ARRAY[0..127] OF BYTE;
                _data_250               :   ARRAY[0..249] OF BYTE;                
            END_VAR

            UpdateOutputs := TRUE;

            _data_1[0].%X0                  :=      AcquisitionControl.TriggerEnable;
            _data_1[0].%X1                  :=      AcquisitionControl.Trigger;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdAcquisitionControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#713,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#713;
                RETURN;
            END_IF;

            _data_1[0].%X0                  :=      ResultsControl.EnableResultBuffering;
            _data_1[0].%X1                  :=      ResultsControl.ResultsAcknowledge;
            
            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdResultsControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#714,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#714;
                RETURN;
            END_IF;

            _data_1[0].%X0                  :=      SoftEventControl.TrainCode;
            _data_1[0].%X1                  :=      SoftEventControl.TrainMatchString;
            _data_1[0].%X2                  :=      SoftEventControl.TrainFocus;
            _data_1[0].%X3                  :=      SoftEventControl.TrainBrightness;
            _data_1[0].%X4                  :=      SoftEventControl.Untrain;
            _data_1[0].%X5                  :=      SoftEventControl.ExecuteDMCC;
            _data_1[0].%X6                  :=      SoftEventControl.Reserved06;
            _data_1[0].%X7                  :=      SoftEventControl.SetMatchString;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdSoftEventControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#715,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#715;
                RETURN;
            END_IF;

            _invalidDataSize := NOT (_UserDataSize = eAxoDataman_UserDataSize#USER_DATA_16B OR
                                     _UserDataSize = eAxoDataman_UserDataSize#USER_DATA_32B OR
                                     _UserDataSize = eAxoDataman_UserDataSize#USER_DATA_64B OR
                                     _UserDataSize = eAxoDataman_UserDataSize#USER_DATA_128B OR
                                     _UserDataSize = eAxoDataman_UserDataSize#USER_DATA_250B);

            Messenger.ActivateOnCondition(ULINT#716,_invalidDataSize, eAxoMessageCategory#ProgrammingError);

            IF _invalidDataSize THEN
                Status.Error.Id := UINT#716;
                RETURN;
            END_IF;

            Config.UserDataSize := _UserDataSize;

            IF (UserData.DataChanged <> _UserDataChanged) THEN
                IF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_16B THEN
                    FOR index := 0 TO 15 DO
                        _data_16[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_16);
                    Messenger.ActivateOnCondition(ULINT#717,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#717;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_32B THEN
                    FOR index := 0 TO 31 DO
                        _data_32[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_32);
                    Messenger.ActivateOnCondition(ULINT#718,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#718;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_64B THEN
                    FOR index := 0 TO 63 DO
                        _data_64[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_64);
                    Messenger.ActivateOnCondition(ULINT#719,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#719;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_128B THEN
                    FOR index := 0 TO 127 DO
                        _data_128[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_128);
                    Messenger.ActivateOnCondition(ULINT#720,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#720;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_250B THEN
                    FOR index := 0 TO 253 DO
                        _data_250[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_250);
                    Messenger.ActivateOnCondition(ULINT#721,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#721;
                        RETURN;
                    END_IF;
                END_IF;
                _UserDataChanged := UserData.DataChanged;
            END_IF;
        END_METHOD  

        METHOD PRIVATE Execute
            VAR
                _index          :   INT;
                returnValue : WORD;
            END_VAR

            THIS.UpdateInputs();

            RestoreTask.Initialize(THIS);
            ClearResultDataTask.Initialize(THIS);
            ReadTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);
            HardwareDiagnosticsTask.Run(_hwID);

            TaskMessenger.Serve(THIS);

            IF Config.ContinuousReading THEN
	            THIS.ContinuousReading();
            END_IF;

            
            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************CLEAR*DATA*****************
            ClearResultDataTask.IsDisabled := RestoreTask.IsBusy() OR ReadTask.IsBusy();
            IF ClearResultDataTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,ClearResultDataTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ClearResultDataTask.IsDone(), eAxoMessageCategory#Info);
            IF ClearResultDataTask.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN
                    AcquisitionControl.TriggerEnable := FALSE;
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.ResultsAcknowledge := TRUE;
                    Results.Id := UINT#0; 
                    Results.Code := UINT#0; 
                    Results.Extended := UINT#0; 
                    Results.Length := UINT#0; 

                    FOR _index := 0 TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    THIS.CallTimers(FALSE);
                    _progress := 301;
                END_IF;
                
                IF _progress = 301 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#600;
                    END_IF;
                    IF NOT ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN
                    ResultsControl.ResultsAcknowledge := FALSE;
                    ClearResultDataTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;
                
                THIS.CallTimers(TRUE);
                
                ClearResultDataTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);                
            END_IF;
            IF ClearResultDataTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearResultDataTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#800;
                Status.Error.Id  :=  UINT#800;
            ELSIF ClearResultDataTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#801;
                Status.Error.Id  :=  UINT#801;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#800,ClearResultDataTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#801,ClearResultDataTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ClearResultDataTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ClearResultDataTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //****************************************

            //*************READ***********************
            ReadTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearResultDataTask.IsBusy();
            IF ReadTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,ReadTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ReadTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadTask.Execute() THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    IF ResultsStatus.ErrorDetected THEN
                        _progress := 319;
                    ELSE
                        _progress := 310;
                    END_IF;
                END_IF;

                IF _progress = 310 THEN
                    AcquisitionControl.TriggerEnable := TRUE;
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.EnableResultBuffering := FALSE;
                    ResultsControl.ResultsAcknowledge := ResultsStatus.ResultsAvailable;
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#610;
                    END_IF;
                    IF NOT ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
                
                IF _progress = 311 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#611;
                    END_IF;
                    IF AcquisitionStatus.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    AcquisitionControl.Trigger := TRUE;
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#612;
                    END_IF;
                    IF AcquisitionStatus.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#613;
                    END_IF;
                    IF ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#614, Results.Length > TO_UINT(Config.ResultDataSize), eAxoMessageCategory#Error);
                    IF Results.Code = UINT#0 OR Results.Length=UINT#0 OR Results.Length > TO_UINT(Config.ResultDataSize) THEN
                        ReadTask.ThrowWhen(TRUE);
                        IF Results.Length > TO_UINT(Config.ResultDataSize) THEN
                            Status.Error.Id := UINT#614;
                        END_IF;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#615;
                    END_IF;

                    FOR _index := 0 TO (TO_INT(Results.Length) - INT#1) DO
                        ResultData.Data[_index] := _data_in[_index + 8];
                    END_FOR;
                    FOR _index := TO_INT(Results.Length) TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    ResultData.DataChanged := NOT ResultData.DataChanged ;
                    _progress := 316;
                END_IF;
                
                IF _progress = 316 THEN
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.EnableResultBuffering := FALSE;
                    ResultsControl.ResultsAcknowledge := TRUE;
                    ReadTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                
                IF _progress = 319 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#619, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#619;
                    END_IF;
                    AcquisitionControl.TriggerEnable :=FALSE;
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.EnableResultBuffering := FALSE;
                    ResultsControl.ResultsAcknowledge := FALSE;
                    IF NOT AcquisitionStatus.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 320;
                    END_IF;
                END_IF;

                IF _progress = 320 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#620, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#620;
                    END_IF;
                    AcquisitionControl.TriggerEnable :=TRUE;
                    IF NOT ResultsStatus.ErrorDetected THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN
                    AcquisitionControl.TriggerEnable :=FALSE;
                    IF _infoTimer.elapsedTime >= T#1s THEN
                        THIS.CallTimers(FALSE);
                        _progress :=  310;
                    END_IF;
                END_IF;
                
                THIS.CallTimers(TRUE);
                
                ReadTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ReadTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#810;
                Status.Error.Id  :=  UINT#810;
            ELSIF ReadTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#811;
                Status.Error.Id  :=  UINT#811;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#810,ReadTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#811,ReadTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,ReadTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ReadTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //****************************************
            THIS.UpdateOutputs();
        END_METHOD    
        
        ///<summary>
		/// Custom component logic running before any other component logic.
        ///</summary>   
        METHOD PROTECTED OVERRIDE Open
            SUPER.Open();
        END_METHOD  

        ///<summary>
		/// Custom component logic running after any other component logic.
        ///</summary>   
        METHOD PROTECTED OVERRIDE Close
            SUPER.Close();
        END_METHOD  

        ///<summary>
		/// Clears the result data. 	
        ///</summary>       
        METHOD PUBLIC ClearResultData : IAxoTaskState
            ClearResultData :=ClearResultDataTask.Invoke();;
        END_METHOD

        ///<summary>
		/// Triggers the reading sequence and waits for results. 	
        ///</summary>       
        METHOD PUBLIC Read : IAxoTaskState
            VAR_OUTPUT
                result : ARRAY [0..245] OF BYTE;
            END_VAR
            result := ResultData.Data;
            Read := ReadTask.Invoke();
        END_METHOD
        
        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal , Config.ErrorTime );
        END_METHOD
  
        METHOD PRIVATE ContinuousReading
            VAR 
                _index : INT;
            END_VAR
            IF ResultsStatus.ResultsAvailable AND NOT ResultsControl.ResultsAcknowledge AND Results.Code > UINT#0 AND Results.Length > UINT#0 THEN
                Messenger.ActivateOnCondition(ULINT#820, Results.Length > TO_UINT(Config.ResultDataSize), eAxoMessageCategory#Error);
                TaskMessenger.ActivateOnCondition(ULINT#713, Results.Length > TO_UINT(Config.ResultDataSize), eAxoMessageCategory#Error);
                IF Results.Length > TO_UINT(Config.ResultDataSize) THEN
                    Status.Action.Id := UINT#820;
                    Status.Error.Id := UINT#713;
                ELSE
                    FOR _index := 0 TO (TO_INT(Results.Length) - INT#1) DO
                        ResultData.Data[_index] := _data_in[_index + 8];
                    END_FOR;
                    FOR _index := TO_INT(Results.Length) TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    ResultData.DataChanged := NOT ResultData.DataChanged ;
                    Status.Action.Id := UINT#120;
                END_IF;
            END_IF;

            ResultsControl.ResultsAcknowledge := ResultsStatus.ResultsAvailable;
        END_METHOD
        
        ///<summary>
		/// Custom logic for the manual control.
        ///</summary>   
        METHOD PROTECTED OVERRIDE ManualControl
            ;
        END_METHOD

        ///<summary>
		/// Restores this instance to its initial state. 
        ///</summary>   
        METHOD PUBLIC OVERRIDE Restore
            VAR
                _index : INT;
            END_VAR
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;
            Messenger.Restore();
            TaskMessenger.Restore();

            ClearResultDataTask.Restore();
            ReadTask.Restore();
             
            Results.Code        :=  UINT#0;
            Results.Extended    :=  UINT#0;
            Results.Id          :=  UINT#0;
            Results.Length      :=  UINT#0;

            FOR _index := 0 TO 245 DO
                ResultData.Data[_index] := BYTE#0;
            END_FOR;
            ResultData.ToggleDataChangedFlag();

            AcquisitionControl.TriggerEnable       :=  ResultsStatus.ErrorDetected;
            AcquisitionControl.Trigger             :=  FALSE;

            ResultsControl.EnableResultBuffering   :=  FALSE;
            ResultsControl.ResultsAcknowledge      :=  FALSE;       

            SoftEventControl.TrainCode 			    :=  FALSE;    			
            SoftEventControl.TrainMatchString 		:=  FALSE;   
            SoftEventControl.TrainFocus 			:=  FALSE;   			
            SoftEventControl.TrainBrightness 		:=  FALSE;   
            SoftEventControl.Untrain 				:=  FALSE;   		
            SoftEventControl.ExecuteDMCC 			:=  FALSE;   	
            SoftEventControl.Reserved06 			:=  FALSE;    	
            SoftEventControl.SetMatchString 		:=  FALSE;   		

            User.Option :=  UINT#0;
            User.Length :=  UINT#0;
            FOR _index := 0 TO 249 DO
                UserData.Data[_index] := BYTE#0;
            END_FOR;
            UserData.ToggleDataChangedFlag();

            IF NOT ResultsStatus.ErrorDetected THEN
                Status.Action.Id := UINT#50;
                RestoreTask.DoneWhen(TRUE);
            END_IF;
        END_METHOD


END_CLASS    
END_NAMESPACE
