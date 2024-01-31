USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING System.Strings;
USING System.Serialization;

NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoInsight EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.IAxoVisionSensor
        VAR PRIVATE
            _ResultDataSize          :   eAxoInsight_ResultDataSize;
            _UserDataSize            :   eAxoInsight_UserDataSize;
            _hwID                    :   WORD;
            _hwIdAcquisitionControl  :   WORD;
            _hwIdAcquisitionStatus   :   WORD;
            _hwIdInspectionControl   :   WORD;
            _hwIdInspectionStatus    :   WORD;
            _hwIdCommandControl      :   WORD;
            _hwIdSoftEventControl    :   WORD;
            _hwIdResultData          :   WORD;
            _hwIdUserData            :   WORD;

            _progress : INT := 0;
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            _errorTimer :  AXOpen.Timers.OnDelayTimer;
            _jobName        :   STRING;
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
            TriggerTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Inspection results#>"}
            InspectionResults : AxoInsight_ResultData;

        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear inspection results#>"}
            ClearInspectionResultsTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required job name#>"}
            RequiredJobName : STRING;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Change job by name#>"}
            ChangeJobByNameTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required job number#>"}
            RequiredJobNumber : UINT;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Change job by number#>"}
            ChangeJobByNumberTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required soft event number#>"}
            RequiredSoftEventNumber : UINT;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Trigger soft event#>"}
            SoftEventTask : AXOpen.Core.AxoTask;

        END_VAR

        VAR PUBLIC //Config
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            Config      :   AxoInsight_Config;
        END_VAR

        VAR PUBLIC //Status
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status      :   AxoInsight_Status;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Results#>"}
            Results     :   AxoInsight_Results;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Acquisition control#>"}
            {#ix-attr:[ReadOnly()]} 
            AcquisitionControl      :   AxoInsight_AcquisitionControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Acquisition status#>"}
            {#ix-attr:[ReadOnly()]}
            AcquisitionStatus      :   AxoInsight_AcquisitionStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Inspection control#>"}
            {#ix-attr:[ReadOnly()]} 
            InspectionControl      :   AxoInsight_InspectionControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Inspection status#>"}
            {#ix-attr:[ReadOnly()]}
            InspectionStatus      :   AxoInsight_InspectionStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Command control#>"}
            {#ix-attr:[ReadOnly()]} 
            CommandControl      :   AxoInsight_CommandControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Command status#>"}
            {#ix-attr:[ReadOnly()]}
            CommandStatus      :   AxoInsight_CommandStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Soft-event control#>"}
            {#ix-attr:[ReadOnly()]} 
            SoftEventControl      :           AxoInsight_SoftEventControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Soft-event status#>"}
            {#ix-attr:[ReadOnly()]}
            SoftEventStatus      :           AxoInsight_SoftEventStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#User data#>"}
            {#ix-attr:[ReadOnly()]} 
            UserData        :   AxoInsight_UserData;
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
                ResultDataSize          :   eAxoInsight_ResultDataSize;
                UserDataSize            :   eAxoInsight_UserDataSize;
                hwID                    :   WORD;
                hwIdAcquisitionControl  :   WORD;
                hwIdAcquisitionStatus   :   WORD;
                hwIdInspectionControl   :   WORD;
                hwIdInspectionStatus    :   WORD;
                hwIdCommandControl      :   WORD;
                hwIdSoftEventControl    :   WORD;
                hwIdResultData          :   WORD;
                hwIdUserData            :   WORD;
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwIdAcquisitionControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwIdAcquisitionStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwIdInspectionControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwIdInspectionStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,hwIdCommandControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,hwIdSoftEventControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,hwIdResultData = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#708,hwIdUserData = WORD#0, eAxoMessageCategory#ProgrammingError);            

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwIdAcquisitionControl = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdAcquisitionStatus = WORD#0 THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdInspectionControl = WORD#0 THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdInspectionStatus = WORD#0 THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF hwIdCommandControl  = WORD#0 THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF hwIdSoftEventControl = WORD#0 THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF hwIdResultData = WORD#0 THEN
                Status.Error.Id := UINT#707;
                RETURN;
            ELSIF hwIdUserData = WORD#0 THEN
                Status.Error.Id := UINT#708;
                RETURN;
            END_IF;

            _ResultDataSize         :=  ResultDataSize;
            _UserDataSize           :=  UserDataSize;
            _hwID                   :=  hwID;
            _hwIdAcquisitionControl :=  hwIdAcquisitionControl;
            _hwIdAcquisitionStatus  :=  hwIdAcquisitionStatus;
            _hwIdInspectionControl  :=  hwIdInspectionControl;
            _hwIdInspectionStatus   :=  hwIdInspectionStatus;
            _hwIdCommandControl     :=  hwIdCommandControl;
            _hwIdSoftEventControl   :=  hwIdSoftEventControl;
            _hwIdResultData         :=  hwIdResultData;
            _hwIdUserData           :=  hwIdUserData;

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
                ResultDataSize          :   eAxoInsight_ResultDataSize;
                UserDataSize            :   eAxoInsight_UserDataSize;
                hwID                    :   WORD;
                hwIdAcquisitionControl  :   WORD;
                hwIdAcquisitionStatus   :   WORD;
                hwIdInspectionControl   :   WORD;
                hwIdInspectionStatus    :   WORD;
                hwIdCommandControl      :   WORD;
                hwIdSoftEventControl    :   WORD;
                hwIdResultData          :   WORD;
                hwIdUserData            :   WORD;
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwIdAcquisitionControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwIdAcquisitionStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwIdInspectionControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwIdInspectionStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,hwIdCommandControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,hwIdSoftEventControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,hwIdResultData = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#708,hwIdUserData = WORD#0, eAxoMessageCategory#ProgrammingError);            

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwIdAcquisitionControl = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdAcquisitionStatus = WORD#0 THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdInspectionControl = WORD#0 THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdInspectionStatus = WORD#0 THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF hwIdCommandControl  = WORD#0 THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF hwIdSoftEventControl = WORD#0 THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF hwIdResultData = WORD#0 THEN
                Status.Error.Id := UINT#707;
                RETURN;
            ELSIF hwIdUserData = WORD#0 THEN
                Status.Error.Id := UINT#708;
                RETURN;
            END_IF;

            _ResultDataSize         :=  ResultDataSize;
            _UserDataSize           :=  UserDataSize;
            _hwID                   :=  hwID;
            _hwIdAcquisitionControl :=  hwIdAcquisitionControl;
            _hwIdAcquisitionStatus  :=  hwIdAcquisitionStatus;
            _hwIdInspectionControl  :=  hwIdInspectionControl;
            _hwIdInspectionStatus   :=  hwIdInspectionStatus;
            _hwIdCommandControl     :=  hwIdCommandControl;
            _hwIdSoftEventControl   :=  hwIdSoftEventControl;
            _hwIdResultData         :=  hwIdResultData;
            _hwIdUserData           :=  hwIdUserData;

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
            Messenger.ActivateOnCondition(ULINT#709,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#709;
                RETURN;
            END_IF;

            AcquisitionStatus.TriggerReady                  :=      _data_in[0].%X0;
            AcquisitionStatus.TriggerAcknowledge            :=      _data_in[0].%X1;
            AcquisitionStatus.ExposureComplete              :=      _data_in[0].%X2;
            AcquisitionStatus.MissedAcquisition             :=      _data_in[0].%X3;
            AcquisitionStatus.OfflineReason0                :=      _data_in[0].%X4;
            AcquisitionStatus.OfflineReason1                :=      _data_in[0].%X5;
            AcquisitionStatus.OfflineReason2                :=      _data_in[0].%X6;
            AcquisitionStatus.Online                        :=      _data_in[0].%X7;

            AcquisitionStatus.AcquisitionID.%B1             :=      _data_in[1];	 
            AcquisitionStatus.AcquisitionID.%B0             :=      _data_in[2];	 

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdInspectionStatus ,_data_in);
            Messenger.ActivateOnCondition(ULINT#710,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#710;
                RETURN;
            END_IF;

            InspectionStatus.SystemBusy                     :=      _data_in[0].%X0;
            InspectionStatus.InspectionCompleted            :=      _data_in[0].%X1;
            InspectionStatus.ResultsBufferOverrun           :=      _data_in[0].%X2;
            InspectionStatus.ResultsValid                   :=      _data_in[0].%X3;
            InspectionStatus.CommandExecuting               :=      _data_in[0].%X4;
            InspectionStatus.CommandComplete                :=      _data_in[0].%X5;
            InspectionStatus.CommandFailed                  :=      _data_in[0].%X6;
            InspectionStatus.ExtendedUserDataSetAcknowledge :=      _data_in[0].%X0;
            InspectionStatus.OverallJobPassFail             :=      _data_in[1].%X0;
            InspectionStatus.TestRunReady                   :=      _data_in[1].%X1;
            InspectionStatus.Error                          :=      _data_in[1].%X7;

            InspectionStatus.ErrorCode.%B1                  :=      _data_in[2];	 
            InspectionStatus.ErrorCode.%B0                  :=      _data_in[3];	 

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdCommandControl ,_data_in);
            Messenger.ActivateOnCondition(ULINT#711,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#711;
                RETURN;
            END_IF;

            CommandStatus.CurrentJobID.%B0                  :=      _data_in[1];
            CommandStatus.CurrentJobID.%B1                  :=      _data_in[0];

            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdSoftEventControl ,_data_in);
            Messenger.ActivateOnCondition(ULINT#712,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#712;
                RETURN;
            END_IF;
            
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[0] :=      _data_in[0].%X0;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[1] :=      _data_in[0].%X1;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[2] :=      _data_in[0].%X2;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[3] :=      _data_in[0].%X3;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[4] :=      _data_in[0].%X4;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[5] :=      _data_in[0].%X5;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[6] :=      _data_in[0].%X6;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[7] :=      _data_in[0].%X7;


            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdResultData ,_data_in);
            Messenger.ActivateOnCondition(ULINT#713,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#713;
                RETURN;
            END_IF;

            _invalidDataSize := NOT (_ResultDataSize = eAxoInsight_ResultDataSize#RESULT_DATA_16B OR
                                    _ResultDataSize = eAxoInsight_ResultDataSize#RESULT_DATA_32B OR
                                    _ResultDataSize = eAxoInsight_ResultDataSize#RESULT_DATA_64B OR
                                    _ResultDataSize = eAxoInsight_ResultDataSize#RESULT_DATA_128B OR
                                    _ResultDataSize = eAxoInsight_ResultDataSize#RESULT_DATA_250B);

                                    Messenger.ActivateOnCondition(ULINT#714,_invalidDataSize, eAxoMessageCategory#ProgrammingError);

            IF _invalidDataSize THEN
                Status.Error.Id := UINT#714;
                RETURN;
            END_IF;

            Config.ResultDataSize := _ResultDataSize;

            Results.InspectionID.%B1        :=  _data_in[0];     
            Results.InspectionID.%B0        :=  _data_in[1];     
            Results.ResultCode.%B1          :=  _data_in[2];     
            Results.ResultCode.%B0          :=  _data_in[3];     
            
            UpdateInputs := TRUE;
        END_METHOD  

        METHOD PRIVATE UpdateOutputs : BOOL
            VAR
                index                   :   INT;
                _invalidDataSize        :   BOOL;
                returnValue             :   WORD;
                _data_1                 :   ARRAY[0..0] OF BYTE;
                _data_2                 :   ARRAY[0..1] OF BYTE;
                _data_16                :   ARRAY[0..15] OF BYTE;
                _data_32                :   ARRAY[0..31] OF BYTE;
                _data_64                :   ARRAY[0..63] OF BYTE;
                _data_128               :   ARRAY[0..127] OF BYTE;
                _data_254               :   ARRAY[0..253] OF BYTE;
            END_VAR

            _data_1[0].%X0              :=      AcquisitionControl.TriggerEnable;
            _data_1[0].%X1              :=      AcquisitionControl.Trigger;
            _data_1[0].%X2              :=      AcquisitionControl.ClearExposureComplete;
            _data_1[0].%X7              :=      AcquisitionControl.SetOffline;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdAcquisitionControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#715,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#715;
                RETURN;
            END_IF;

            _data_1[0].%X0               :=      InspectionControl.EnableResultsBuffering;
            _data_1[0].%X1               :=      InspectionControl.AcknowledgeInspectionResults;
            _data_1[0].%X2               :=      InspectionControl.ExtendedUserDataSet;
            _data_1[0].%X3               :=      InspectionControl.ExecuteCommand;
            _data_1[0].%X7               :=      InspectionControl.ClearError;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdInspectionControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#716,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#716;
                RETURN;
            END_IF;

            _data_2[0]                    :=      CommandControl.Command.%B1;
            _data_2[1]                    :=      CommandControl.Command.%B0;
            
            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdCommandControl,_data_2);
            Messenger.ActivateOnCondition(ULINT#717,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#717;
                RETURN;
            END_IF;

            _data_1[0].%X0                  :=      SoftEventControl.TriggerSoftEvent.Data[0];
            _data_1[0].%X1                  :=      SoftEventControl.TriggerSoftEvent.Data[1];
            _data_1[0].%X2                  :=      SoftEventControl.TriggerSoftEvent.Data[2];
            _data_1[0].%X3                  :=      SoftEventControl.TriggerSoftEvent.Data[3];
            _data_1[0].%X4                  :=      SoftEventControl.TriggerSoftEvent.Data[4];
            _data_1[0].%X5                  :=      SoftEventControl.TriggerSoftEvent.Data[5];
            _data_1[0].%X6                  :=      SoftEventControl.TriggerSoftEvent.Data[6];
            _data_1[0].%X7                  :=      SoftEventControl.TriggerSoftEvent.Data[7];

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdSoftEventControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#718,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                Status.Error.Id := UINT#718;
                RETURN;
            END_IF;

            _invalidDataSize := NOT (_UserDataSize = eAxoInsight_UserDataSize#USER_DATA_16B OR
                                     _UserDataSize = eAxoInsight_UserDataSize#USER_DATA_32B OR
                                     _UserDataSize = eAxoInsight_UserDataSize#USER_DATA_64B OR
                                     _UserDataSize = eAxoInsight_UserDataSize#USER_DATA_128B OR
                                     _UserDataSize = eAxoInsight_UserDataSize#USER_DATA_254B);

            Messenger.ActivateOnCondition(ULINT#719,_invalidDataSize, eAxoMessageCategory#ProgrammingError);

            IF _invalidDataSize THEN
                Status.Error.Id := UINT#719;
                RETURN;
            END_IF;

            Config.UserDataSize := _UserDataSize;

            IF (UserData.DataChanged <> _UserDataChanged) THEN
                IF Config.UserDataSize = eAxoInsight_UserDataSize#USER_DATA_16B THEN
                    FOR index := 0 TO 15 DO
                        _data_16[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_16);
                    Messenger.ActivateOnCondition(ULINT#720,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#720;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxoInsight_UserDataSize#USER_DATA_32B THEN
                    FOR index := 0 TO 31 DO
                        _data_32[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_32);
                    Messenger.ActivateOnCondition(ULINT#721,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#721;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxoInsight_UserDataSize#USER_DATA_64B THEN
                    FOR index := 0 TO 63 DO
                        _data_64[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_64);
                    Messenger.ActivateOnCondition(ULINT#722,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#722;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxoInsight_UserDataSize#USER_DATA_128B THEN
                    FOR index := 0 TO 127 DO
                        _data_128[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_128);
                    Messenger.ActivateOnCondition(ULINT#723,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#723;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxoInsight_UserDataSize#USER_DATA_254B THEN
                    FOR index := 0 TO 253 DO
                        _data_254[index] := UserData.Data[index];
                    END_FOR;
                    returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_254);
                    Messenger.ActivateOnCondition(ULINT#724,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#724;
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

            RestoreTask.Initialize(THIS);
            ClearInspectionResultsTask.Initialize(THIS);
            TriggerTask.Initialize(THIS);
            ChangeJobByNameTask.Initialize(THIS);
            ChangeJobByNumberTask.Initialize(THIS);
            SoftEventTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            HardwareDiagnosticsTask.Run(_hwID);
            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************CLEAR*DATA*****************
            ClearInspectionResultsTask.IsDisabled := RestoreTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR ChangeJobByNumberTask.IsBusy() OR SoftEventTask.IsBusy();
            IF ClearInspectionResultsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;
            IF ClearInspectionResultsTask.Execute() THEN
                THIS.UpdateInputs();
                IF _progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN
                    AcquisitionControl.TriggerEnable := FALSE;
                    AcquisitionControl.Trigger := FALSE;
                    InspectionControl.AcknowledgeInspectionResults := TRUE;
                    Results.InspectionID := UINT#0; 
                    Results.ResultCode := UINT#0; 

                    FOR _index := 0 TO 249 DO
                        InspectionResults.Data[_index] := BYTE#0;
                    END_FOR;
                    InspectionResults.DataChanged := NOT InspectionResults.DataChanged ;

                    THIS.CallTimers(FALSE);
                    _progress := 301;
                END_IF;
                
                IF _progress = 301 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#601;
                    END_IF;

                    IF NOT InspectionStatus.ResultsValid THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN
                    InspectionControl.AcknowledgeInspectionResults := TRUE;
                    ClearInspectionResultsTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;
                
                THIS.CallTimers(TRUE);
                
                ClearInspectionResultsTask.ThrowWhen(_errorTimer.output);

                Status.Action.Id := TO_UINT(_progress);

                THIS.UpdateOutputs();
            END_IF;
            IF ClearInspectionResultsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearInspectionResultsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#800;
                Status.Error.Id  :=  UINT#800;
            ELSIF ClearInspectionResultsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#801;
                Status.Error.Id  :=  UINT#801;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#800,ClearInspectionResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#801,ClearInspectionResultsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ClearInspectionResultsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ClearInspectionResultsTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //****************************************
            //*************READ***********************
            TriggerTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR ChangeJobByNumberTask.IsBusy() OR SoftEventTask.IsBusy();
            IF TriggerTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;
            IF TriggerTask.Execute() THEN
                THIS.UpdateInputs();
                IF _progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;

                IF _progress = 310 THEN
                    AcquisitionControl.TriggerEnable  := TRUE;
                    AcquisitionControl.Trigger := FALSE;
                    AcquisitionControl.ClearExposureComplete := AcquisitionStatus.ExposureComplete;
                    AcquisitionControl.SetOffline := FALSE;
                
                    InspectionControl.EnableResultsBuffering := FALSE; 
                    InspectionControl.AcknowledgeInspectionResults := InspectionStatus.ResultsValid;
                    InspectionControl.ExtendedUserDataSet := FALSE;
                    InspectionControl.ExecuteCommand := FALSE;
                    InspectionControl.ClearError := InspectionStatus.Error;
    
                    CommandControl.Command:= UINT#0;
                    _progress := 311;
                END_IF;

                IF _progress = 311 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#611;
                    END_IF;

                    IF NOT AcquisitionStatus.ExposureComplete THEN
                        AcquisitionControl.ClearExposureComplete := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress :=312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#612;
                    END_IF;

                    IF NOT InspectionStatus.ResultsValid THEN
                        InspectionControl.AcknowledgeInspectionResults := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#613;
                    END_IF;

                    IF NOT InspectionStatus.Error THEN
                        InspectionControl.ClearError := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#614;
                    END_IF;

                    _inspectionCompleted := InspectionStatus.InspectionCompleted;
                    IF AcquisitionStatus.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#615;
                    END_IF;

                    AcquisitionControl.Trigger := TRUE;
                    IF AcquisitionStatus.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#616, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#616;
                    END_IF;

                    AcquisitionControl.Trigger := FALSE;
                    IF _inspectionCompleted <> InspectionStatus.InspectionCompleted THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;
            
                IF _progress = 317 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#617, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#617;
                    END_IF;

                    IF InspectionStatus.ResultsValid THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;
                
                IF _progress = 318 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#618, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#618;
                    END_IF;
                    FOR _index := 0 TO (TO_INT(Config.ResultDataSize) - INT#1) DO
                        InspectionResults.Data[_index] := _data_in[_index + 4];
                    END_FOR;
                    FOR _index := Config.ResultDataSize TO 249 DO
                        InspectionResults.Data[_index] := BYTE#0;
                    END_FOR;
                    InspectionResults.DataChanged := NOT InspectionResults.DataChanged ;
                    _progress := 319;
                END_IF;

                IF _progress = 319 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#619, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#619;
                    END_IF;
                    AcquisitionControl.Trigger := FALSE;
                    InspectionControl.EnableResultsBuffering := FALSE;
                    InspectionControl.AcknowledgeInspectionResults := TRUE;
                    TriggerTask.ThrowWhen(InspectionStatus.Error);
                    TriggerTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;               


                THIS.CallTimers(TRUE);
                
                TriggerTask.ThrowWhen(_errorTimer.output);

                Status.Action.Id := TO_UINT(_progress);

                THIS.UpdateOutputs();
            END_IF;
            IF TriggerTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF TriggerTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#810;
                Status.Error.Id  :=  UINT#810;
            ELSIF TriggerTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#811;
                Status.Error.Id  :=  UINT#811;
            END_IF;         
            Messenger.ActivateOnCondition(ULINT#810,TriggerTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#811,TriggerTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,TriggerTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TriggerTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;   
            //****************************************

            //*************CHANGE JOB BY NAME*********
            ChangeJobByNameTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNumberTask.IsBusy() OR SoftEventTask.IsBusy();
            IF ChangeJobByNameTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;
            IF ChangeJobByNameTask.Execute() THEN
                THIS.UpdateInputs();
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    Status.CurrentJobName := '';
                    Status.CurrentJobNumber := UINT#0;
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;

                IF _progress = 320 THEN
                    THIS.CallTimers(FALSE);
                    TaskMessenger.ActivateOnCondition(ULINT#725, _jobName='', eAxoMessageCategory#Error);

                    IF _jobName='' THEN
                        Status.Error.Id := UINT#725;
                        ChangeJobByNameTask.ThrowWhen(TRUE);
                    ELSE	
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#621, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#621;
                    END_IF;

                    InspectionControl.ExecuteCommand:=FALSE;
                    InspectionControl.ClearError:=TRUE;
                    AcquisitionControl.SetOffline := FALSE;
                    IF NOT InspectionStatus.CommandExecuting THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                
                IF _progress = 322 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#622, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#622;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    IF(NOT AcquisitionStatus.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                
                IF _progress = 323 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#623, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#623;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    InspectionControl.ExecuteCommand := FALSE;
                    InspectionControl.ClearError := InspectionStatus.Error;
                    IF NOT InspectionStatus.Error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                        _jobName := THIS.AppendSuffix(_jobName);
                    END_IF;
                END_IF;
                
                IF _progress = 324 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#624, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#624;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;

                    IF THIS.SetUserDataAsString(_jobName,UINT#0) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#625, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#625;
                    END_IF;

                    UserData.ToggleDataChangedFlag();

                    AcquisitionControl.SetOffline := TRUE;
                    InspectionControl.ExtendedUserDataSet := TRUE;
                    CommandControl.Command := UINT#16384;//16#4000;
                    InspectionControl.ExecuteCommand:=TRUE;

                    IF(InspectionStatus.ExtendedUserDataSetAcknowledge) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;            
                END_IF;
                
                IF _progress = 326 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#626, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#626;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    InspectionControl.ExtendedUserDataSet := FALSE;
                    CommandControl.Command := UINT#16384;//16#4000;
                    InspectionControl.ExecuteCommand:=TRUE;
                                        
                    IF(NOT InspectionStatus.ExtendedUserDataSetAcknowledge) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
            
                IF _progress = 327 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#627, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#627;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    CommandControl.Command := UINT#16384;//16#4000;
                    InspectionControl.ExecuteCommand:=TRUE;
                    
                    IF(InspectionStatus.CommandComplete AND NOT InspectionStatus.CommandFailed) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    ELSIF(InspectionStatus.CommandComplete AND InspectionStatus.CommandFailed AND NOT InspectionStatus.CommandExecuting) THEN
                        _progress := 339;
                    END_IF;
                END_IF;
                
                IF _progress = 328 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#628, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#628;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    CommandControl.Command := UINT#0;
                    InspectionControl.ExecuteCommand:=FALSE;
                    IF(NOT InspectionStatus.CommandComplete) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 329;
                    END_IF;
                END_IF;
                
                IF _progress = 329 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#629, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#629;
                    END_IF;

                    AcquisitionControl.SetOffline := FALSE;
                    
                    IF(AcquisitionStatus.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 330;
                    END_IF;
                END_IF;               

                IF _progress = 330 THEN
                    Status.CurrentJobName := _jobName;
                    InspectionControl.ExecuteCommand := FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    InspectionControl.ClearError := FALSE;
                    CommandControl.Command := UINT#0;
                    ChangeJobByNameTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;               

                IF _progress = 339 THEN
                    InspectionControl.ExecuteCommand := FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    CommandControl.Command := UINT#0;
                    ChangeJobByNameTask.ThrowWhen(TRUE);
                END_IF;               

                THIS.CallTimers(TRUE);
                ChangeJobByNameTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
                THIS.UpdateOutputs();
            END_IF;
            IF ChangeJobByNameTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF ChangeJobByNameTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#820;
                Status.Error.Id  :=  UINT#820;
            ELSIF ChangeJobByNameTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#821;
                Status.Error.Id  :=  UINT#821;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#820,ChangeJobByNameTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#821,ChangeJobByNameTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,ChangeJobByNameTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ChangeJobByNameTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;  
            //****************************************

            //*************CHANGE JOB BY NUMBER*******
            ChangeJobByNumberTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR SoftEventTask.IsBusy();
            IF ChangeJobByNumberTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;
            IF ChangeJobByNumberTask.Execute() THEN
                THIS.UpdateInputs();
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    Status.CurrentJobName := '';
                    Status.CurrentJobNumber := UINT#0;
                    THIS.CallTimers(FALSE);
                    _progress := 340;

                END_IF;

                IF _progress = 340 THEN
                    THIS.CallTimers(FALSE);
                    TaskMessenger.ActivateOnCondition(ULINT#726, _jobNumber > Config.MaxJobNumber, eAxoMessageCategory#Error);

                    IF _jobNumber > Config.MaxJobNumber THEN
                        Status.Error.Id := UINT#726;
                        ChangeJobByNumberTask.ThrowWhen(TRUE);
                    ELSE	
                        _progress := 341;
                    END_IF;
                END_IF;

                IF _progress = 341 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#641, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#641;
                    END_IF;

                    InspectionControl.ExecuteCommand:=FALSE;
                    InspectionControl.ClearError:=FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    IF NOT InspectionStatus.CommandExecuting THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#642, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#642;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    IF(NOT AcquisitionStatus.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#643, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#643;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    InspectionControl.ExecuteCommand := FALSE;
                    InspectionControl.ClearError := InspectionStatus.Error;
                    IF NOT InspectionStatus.Error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#644, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#644;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    CommandControl.Command := _jobNumber;
                    InspectionControl.ExecuteCommand:=TRUE;
                    
                    IF(InspectionStatus.CommandComplete AND NOT InspectionStatus.CommandFailed) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    ELSIF(InspectionStatus.CommandComplete AND InspectionStatus.CommandFailed AND NOT InspectionStatus.CommandExecuting) THEN
                        _progress := 349;
                    END_IF;
                END_IF;
                
                IF _progress = 345 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#645, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#645;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    CommandControl.Command := UINT#0;
                    InspectionControl.ExecuteCommand:=FALSE;
                    IF(NOT InspectionStatus.CommandComplete) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 346;
                    END_IF;
                END_IF;
                
                IF _progress = 346 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#646, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#646;
                    END_IF;

                    AcquisitionControl.SetOffline := FALSE;
                    IF(AcquisitionStatus.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 347;
                    END_IF;
                END_IF;

                IF _progress = 347 THEN
                    Status.CurrentJobNumber := _jobNumber;
                    InspectionControl.ExecuteCommand := FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    InspectionControl.ClearError := FALSE;
                    CommandControl.Command := UINT#0;
                    ChangeJobByNumberTask.DoneWhen(TRUE);
                    _progress := 0;            
                END_IF;               

                IF _progress = 349 THEN
                    InspectionControl.ExecuteCommand := FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    CommandControl.Command := UINT#0;
                    ChangeJobByNumberTask.ThrowWhen(TRUE);
                END_IF;                   

                THIS.CallTimers(TRUE);
                ChangeJobByNumberTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
                THIS.UpdateOutputs();
            END_IF;
            IF ChangeJobByNumberTask.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF ChangeJobByNumberTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#840;
                Status.Error.Id  :=  UINT#840;
            ELSIF ChangeJobByNumberTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#841;
                Status.Error.Id  :=  UINT#841;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#840,ChangeJobByNumberTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#841,ChangeJobByNumberTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,ChangeJobByNumberTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ChangeJobByNumberTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349 THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;  
            //****************************************

            //*************Soft event*****************
            SoftEventTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR ChangeJobByNumberTask.IsBusy();
            IF SoftEventTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;
            IF SoftEventTask.Execute() THEN
                THIS.UpdateInputs();
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;

                IF _progress = 350 THEN
                    THIS.CallTimers(FALSE);
                    TaskMessenger.ActivateOnCondition(ULINT#727, _softEventNumber > UINT#7, eAxoMessageCategory#Error);

                    IF _softEventNumber > UINT#7 THEN
                        Status.Error.Id := UINT#727;
                        SoftEventTask.ThrowWhen(TRUE);
                    ELSE	
                        _progress := 351;
                    END_IF;
                END_IF;

                IF _progress = 351 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 352;
                END_IF;
                
                IF _progress = 352 THEN
                    Messenger.ActivateOnCondition(ULINT#652, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#652;
                    END_IF;

                    SoftEventControl.TriggerSoftEvent.Data[_softEventNumber] := TRUE;
                    SoftEventControl.TriggerSoftEvent.ToggleDataChangedFlag();
                    IF SoftEventStatus.TriggerSoftEventAcknowledge.Data[_softEventNumber] THEN
                        SoftEventStatus.TriggerSoftEventAcknowledge.ToggleDataChangedFlag();
                        THIS.CallTimers(FALSE);
                        _progress := 353;
                    END_IF;
                END_IF;
                
                IF _progress = 353 THEN
                    Messenger.ActivateOnCondition(ULINT#653, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#653;
                    END_IF;

                    SoftEventControl.TriggerSoftEvent.Data[_softEventNumber] := FALSE;
                    SoftEventControl.TriggerSoftEvent.ToggleDataChangedFlag();
                    IF NOT SoftEventStatus.TriggerSoftEventAcknowledge.Data[_softEventNumber] THEN
                        SoftEventStatus.TriggerSoftEventAcknowledge.ToggleDataChangedFlag();
                        THIS.CallTimers(FALSE);
                        _progress := 354;
                    END_IF;
                END_IF;
                
                IF _progress = 354 THEN
                    SoftEventTask.DoneWhen(TRUE);
                    _progress := 0;            
                END_IF;               

                THIS.CallTimers(TRUE);
                SoftEventTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
                THIS.UpdateOutputs();
            END_IF;
            IF SoftEventTask.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF SoftEventTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#850;
                Status.Error.Id  :=  UINT#850;
            ELSIF SoftEventTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#851;
                Status.Error.Id  :=  UINT#851;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#850,SoftEventTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#851,SoftEventTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,SoftEventTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SoftEventTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349 THEN
                Status.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;   
            //****************************************

            Messenger.ActivateOnCondition(ULINT#717,ClearInspectionResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#718,TriggerTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#719,ChangeJobByNameTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#720,ChangeJobByNumberTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#721,SoftEventTask.HasError(), eAxoMessageCategory#Error);

            Messenger.ActivateOnCondition(ULINT#722,ClearInspectionResultsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#723,TriggerTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#724,ChangeJobByNameTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#725,ChangeJobByNumberTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#726,SoftEventTask.IsAborted(), eAxoMessageCategory#Error);

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
		/// Clears the inspection results. 	
        ///</summary>       
        METHOD PUBLIC ClearInspectionResults : IAxoTaskState
            ClearInspectionResults := ClearInspectionResultsTask.Invoke();;
        END_METHOD

        ///<summary>
		/// Triggers the reading sequence and waits for results. 	
        ///</summary>       
        METHOD PUBLIC Trigger : IAxoTaskState
            Trigger := TriggerTask.Invoke();
        END_METHOD

        ///<summary>
		/// Changes the sensor job using job number. 	
        ///</summary>       
        METHOD PUBLIC ChangeJob : IAxoTaskState
            VAR_INPUT 
                Job : UINT;
            END_VAR
            _jobNumber := Job;
            ChangeJob := ChangeJobByNumberTask.Invoke();
        END_METHOD

        ///<summary>
		/// Changes the sensor job using job name. 	
        ///</summary>       
        METHOD PUBLIC ChangeJob : IAxoTaskState
            VAR_INPUT 
                Job : STRING;
            END_VAR
            _jobName := Job;
            ChangeJob := ChangeJobByNameTask.Invoke();
        END_METHOD
        
        ///<summary>
		/// Triggers the soft event. 
        ///</summary>       
        METHOD PUBLIC SoftEvent : IAxoTaskState
            VAR_INPUT 
                EventNumber : UINT;
            END_VAR
            _softEventNumber := EventNumber;
            SoftEvent := SoftEventTask.Invoke();
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal , Config.ErrorTime );
        END_METHOD
        METHOD INTERNAL AppendSuffix :STRING
            VAR_INPUT
                jobName : STRING;
            END_VAR
            VAR 
                position : INT;
            END_VAR
            position := LengthOf(jobName) - 4;
            Status.CurrentJobName := EndOf(jobName, 4);
            IF EndOf(jobName, 4) <> '.job' THEN
                AppendSuffix := Concat(jobName,'.job');
            ELSE
                AppendSuffix := jobName;
            END_IF;
        END_METHOD

        METHOD INTERNAL SetUserDataAsString :   BOOL
            VAR_INPUT
                inValue     :   STRING;
                inPosition  :   UINT;	
            END_VAR
            VAR
                _index : UINT;
                _size : UINT;
                _maxIndex : UINT; 
                _data : ARRAY[0..255] OF BYTE;
            END_VAR
            
            SetUserDataAsString := FALSE;

            _size := TO_UINT(LengthOf(inValue));

            _maxIndex := UINT#255;
            
            Messenger.ActivateOnCondition(ULINT#716, (inPosition +_size) >= TO_UINT(Config.UserDataSize), eAxoMessageCategory#Error);

            IF (inPosition +_size) >= TO_UINT(Config.UserDataSize) THEN
                Status.Error.Id := UINT#716;
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#717, (inPosition +_size) > _maxIndex ,eAxoMessageCategory#Error);
            
            IF (inPosition +_size) > _maxIndex THEN
                Status.Error.Id := UINT#717;
                RETURN;
            END_IF;

            Serialize(UINT#0, inValue, _data);
            FOR	_index := UINT#0 TO _size BY UINT#1 DO	
                UserData.Data[(inPosition + _index)] := _data[_index + UINT#1];
            END_FOR;
            
            FOR	_index := inPosition +_size TO _maxIndex BY UINT#1 DO	
                UserData.Data[_index] := BYTE#0;
            END_FOR;
            // UserData.ToggleDataChangedFlag();

            SetUserDataAsString := TRUE;
        END_METHOD

        ///<summary>
		/// Custom logic for the manual control.
        ///</summary>   
        METHOD PROTECTED OVERRIDE ManualControl
            _jobName := RequiredJobName;
            _jobNumber := RequiredJobNumber;
            _softEventNumber := RequiredSoftEventNumber;
        END_METHOD


        ///<summary>
		/// Restores this instance . 
        ///</summary>   
        METHOD PUBLIC OVERRIDE Restore
            VAR
                _index : INT;
            END_VAR
            _progress := 0;
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;
            Status.CurrentJobName := '';
            Messenger.Restore();
            TaskMessenger.Restore();


            ClearInspectionResultsTask.Restore();
            TriggerTask.Restore();
            ChangeJobByNameTask.Restore();
            ChangeJobByNumberTask.Restore();

            RequiredJobName := '';
            RequiredJobNumber := UINT#0;
             
            Results.InspectionID                            :=  UINT#0;
            Results.ResultCode                              :=  UINT#0;
            
            FOR _index := 0 TO 249 DO
                InspectionResults.Data[_index] := BYTE#0;
            END_FOR;
            InspectionResults.ToggleDataChangedFlag();
  
            AcquisitionControl.TriggerEnable                :=  FALSE;
            AcquisitionControl.Trigger					    :=  FALSE;
            AcquisitionControl.ClearExposureComplete        :=  AcquisitionStatus.ExposureComplete;
            AcquisitionControl.SetOffline                   :=  FALSE;


            InspectionControl.EnableResultsBuffering        :=  FALSE;
            InspectionControl.AcknowledgeInspectionResults  :=  FALSE;
            InspectionControl.ExtendedUserDataSet           :=  FALSE;
            InspectionControl.ExecuteCommand                :=  FALSE;
            InspectionControl.ClearError                    :=  InspectionStatus.Error;

            CommandControl.Command                          :=  UINT#0;

            SoftEventControl.TriggerSoftEvent.Data[0]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[1]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[2]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[3]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[4]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[5]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[6]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[7]       :=  FALSE;

            FOR _index := 0 TO 253 DO
                UserData.Data[_index] := BYTE#0;
            END_FOR;
            UserData.ToggleDataChangedFlag();

            IF NOT AcquisitionStatus.ExposureComplete AND NOT InspectionStatus.Error THEN
                Status.Action.Id := UINT#50;
                RestoreTask.DoneWhen(TRUE);
            END_IF;
        END_METHOD

    END_CLASS    
END_NAMESPACE
