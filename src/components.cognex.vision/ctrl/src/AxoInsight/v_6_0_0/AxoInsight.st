USING AXOpen.Core;
USING AXOpen.Components.Abstractions;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoInsight EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.IAxoVisionSensor
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Read#>"}
            TriggerTask : AxoInsightTrigger;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Inspection results#>"}
            InspectionResults : AxoByteArray255;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear inspection results#>"}
            ClearInspectionResultsTask : AxoInsightClearInspectionResults;
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required job name#>"}
            RequiredJobName : STRING;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Change job by name#>"}
            ChangeJobByNameTask : AxoChangeJobByName;
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required job number#>"}
            RequiredJobNumber : UINT;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Change job by number#>"}
            ChangeJobByNumberTask : AxoChangeJobByNumber;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            Config      :   AxoInsight_Config;

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
            User        :   AxoInsight_User;
        END_VAR
               
        VAR PRIVATE
            _taskDisabled : BOOL;
        END_VAR
        ///<summary>
		/// Restores this instance . 
        ///</summary>   
        METHOD PROTECTED OVERRIDE Restore: IAxoTask 
            VAR
                _index : INT;
            END_VAR
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;
            Status.CurrentJobName := '';

            ClearInspectionResultsTask.Restore();
            TriggerTask.Restore();
            ChangeJobByNameTask.Restore();
            ChangeJobByNumberTask.Restore();

            RequiredJobName := '';
            RequiredJobNumber := UINT#0;
             
            Results.InspectionID                            :=  UINT#0;
            Results.ResultCode                              :=  UINT#0;
            
            FOR _index := 0 TO 254 DO
                InspectionResults.Data[_index] := BYTE#0;
            END_FOR;
            InspectionResults.DataChanged := NOT InspectionResults.DataChanged;

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

            FOR _index := 0 TO 254 DO
                User.UserData.Data[_index] := BYTE#0;
            END_FOR;
            User.UserData.DataChanged := NOT User.UserData.DataChanged;

            IF NOT AcquisitionStatus.ExposureComplete AND NOT InspectionStatus.Error THEN
                Status.Action.Id := UINT#300;
                RestoreTask.DoneWhen(TRUE);
            END_IF;
        END_METHOD

        ///<summary>
		/// Custom logic for the manual control.
        ///</summary>   
        METHOD PROTECTED OVERRIDE ManualControl
            ChangeJobByNameTask.Manual(RequiredJobName);
            ChangeJobByNumberTask.Manual(RequiredJobNumber);
        END_METHOD

        METHOD PRIVATE UpdateInputs : BOOL
            VAR_INPUT
                refAcquisitionStatus   :   REF_TO  ARRAY[0..2] OF BYTE;
                refInspectionStatus    :   REF_TO  DWORD;
                refCommandStatus       :   REF_TO  WORD;
                refSoftEventStatus     :   REF_TO  BYTE;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR
            AcquisitionStatus.TriggerReady                  :=      refAcquisitionStatus^[0].%X0;
            AcquisitionStatus.TriggerAcknowledge            :=      refAcquisitionStatus^[0].%X1;
            AcquisitionStatus.ExposureComplete              :=      refAcquisitionStatus^[0].%X2;
            AcquisitionStatus.MissedAcquisition             :=      refAcquisitionStatus^[0].%X3;
            AcquisitionStatus.OfflineReason0                :=      refAcquisitionStatus^[0].%X4;
            AcquisitionStatus.OfflineReason1                :=      refAcquisitionStatus^[0].%X5;
            AcquisitionStatus.OfflineReason2                :=      refAcquisitionStatus^[0].%X6;
            AcquisitionStatus.Online                        :=      refAcquisitionStatus^[0].%X7;

            AcquisitionStatus.AcquisitionID.%B1             :=      refAcquisitionStatus^[1];	 
            AcquisitionStatus.AcquisitionID.%B0             :=      refAcquisitionStatus^[2];	 

            InspectionStatus.SystemBusy                     :=      refInspectionStatus^.%X24;
            InspectionStatus.InspectionCompleted            :=      refInspectionStatus^.%X25;
            InspectionStatus.ResultsBufferOverrun           :=      refInspectionStatus^.%X26;
            InspectionStatus.ResultsValid                   :=      refInspectionStatus^.%X27;
            InspectionStatus.CommandExecuting               :=      refInspectionStatus^.%X28;
            InspectionStatus.CommandComplete                :=      refInspectionStatus^.%X29;
            InspectionStatus.CommandFailed                  :=      refInspectionStatus^.%X30;
            InspectionStatus.ExtendedUserDataSetAcknowledge :=      refInspectionStatus^.%X31;
            InspectionStatus.OverallJobPassFail             :=      refInspectionStatus^.%X16;
            InspectionStatus.TestRunReady                   :=      refInspectionStatus^.%X17;
            InspectionStatus.Error                          :=      refInspectionStatus^.%X23;

            InspectionStatus.ErrorCode.%B1                  :=      refInspectionStatus^.%B1;	 
            InspectionStatus.ErrorCode.%B0                  :=      refInspectionStatus^.%B0;	 
            
            CommandStatus.CurrentJobID.%B1                 :=      refCommandStatus^.%B1;
            CommandStatus.CurrentJobID.%B0                 :=      refCommandStatus^.%B0;

            SoftEventStatus.TriggerSoftEventAcknowledge.Data[0] :=      refSoftEventStatus^.%X0;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[1] :=      refSoftEventStatus^.%X1;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[2] :=      refSoftEventStatus^.%X2;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[3] :=      refSoftEventStatus^.%X3;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[4] :=      refSoftEventStatus^.%X4;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[5] :=      refSoftEventStatus^.%X5;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[6] :=      refSoftEventStatus^.%X6;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[7] :=      refSoftEventStatus^.%X7;

            IF (LOWER_BOUND(refResultData^,1) = 0) THEN
                IF (UPPER_BOUND(refResultData^,1) = 19) THEN
                    Status.ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_16B;
                ELSIF (UPPER_BOUND(refResultData^,1) = 35) THEN
                    Status.ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_32B;
                ELSIF (UPPER_BOUND(refResultData^,1) = 67) THEN
                    Status.ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_64B;
                ELSIF (UPPER_BOUND(refResultData^,1) = 131) THEN
                    Status.ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_128B;
                ELSIF (UPPER_BOUND(refResultData^,1) = 253) THEN
                    Status.ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_250B;
                ELSE
                    Status.ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_SIZE_INVALID;
                    Status.Error.Id := UINT#711;
                    UpdateInputs := FALSE;
                END_IF;
            ELSE
                Status.Error.Id := UINT#712;
                UpdateInputs := FALSE;
                Status.ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            END_IF;

            IF(Status.ResultDataSize <> eAxoInsight_ResultDataSize#RESULT_DATA_SIZE_INVALID) THEN
                Results.InspectionID.%B1        :=  refResultData^[0];     
                Results.InspectionID.%B0        :=  refResultData^[1];     
                Results.ResultCode.%B1          :=  refResultData^[2];     
                Results.ResultCode.%B0          :=  refResultData^[3];     
                UpdateInputs := TRUE;
            END_IF;

        END_METHOD  

        METHOD PRIVATE UpdateOutputs : BOOL
            VAR_INPUT
                refAcquisitionControl   :   REF_TO  BYTE;
                refInspectionControl    :   REF_TO  BYTE;
                refCommandControl       :   REF_TO  WORD;
                refSoftEventControl     :   REF_TO  BYTE;
                refUserData             :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR

            refAcquisitionControl^.%X0      :=      AcquisitionControl.TriggerEnable;
            refAcquisitionControl^.%X1      :=      AcquisitionControl.Trigger;
            refAcquisitionControl^.%X2      :=      AcquisitionControl.ClearExposureComplete;
            refAcquisitionControl^.%X7      :=      AcquisitionControl.SetOffline;

            refInspectionControl^.%X0       :=      InspectionControl.EnableResultsBuffering;
            refInspectionControl^.%X1       :=      InspectionControl.AcknowledgeInspectionResults;
            refInspectionControl^.%X2       :=      InspectionControl.ExtendedUserDataSet;
            refInspectionControl^.%X3       :=      InspectionControl.ExecuteCommand;
            refInspectionControl^.%X7       :=      InspectionControl.ClearError;

            refCommandControl^.%B0          :=      CommandControl.Command.%B0;
            refCommandControl^.%B1          :=      CommandControl.Command.%B1;
            
            refSoftEventControl^.%X0        :=      SoftEventControl.TriggerSoftEvent.Data[0];
            refSoftEventControl^.%X1        :=      SoftEventControl.TriggerSoftEvent.Data[1];
            refSoftEventControl^.%X2        :=      SoftEventControl.TriggerSoftEvent.Data[2];
            refSoftEventControl^.%X3        :=      SoftEventControl.TriggerSoftEvent.Data[3];
            refSoftEventControl^.%X4        :=      SoftEventControl.TriggerSoftEvent.Data[4];
            refSoftEventControl^.%X5        :=      SoftEventControl.TriggerSoftEvent.Data[5];
            refSoftEventControl^.%X6        :=      SoftEventControl.TriggerSoftEvent.Data[6];
            refSoftEventControl^.%X7        :=      SoftEventControl.TriggerSoftEvent.Data[7];

            IF (LOWER_BOUND(refUserData^,1) = 0) THEN
                IF (UPPER_BOUND(refUserData^,1) = 15) THEN
                    Status.UserDataSize := eAxoInsight_UserDataSize#USER_DATA_16B;
                ELSIF (UPPER_BOUND(refUserData^,1) = 31) THEN
                    Status.UserDataSize := eAxoInsight_UserDataSize#USER_DATA_32B;
                ELSIF (UPPER_BOUND(refUserData^,1) = 63) THEN
                    Status.UserDataSize := eAxoInsight_UserDataSize#USER_DATA_64B;
                ELSIF (UPPER_BOUND(refUserData^,1) = 127) THEN
                    Status.UserDataSize := eAxoInsight_UserDataSize#USER_DATA_128B;
                ELSIF (UPPER_BOUND(refUserData^,1) = 253) THEN
                    Status.UserDataSize := eAxoInsight_UserDataSize#USER_DATA_254B;
                ELSE
                    Status.Error.Id := UINT#713;
                    UpdateOutputs := FALSE;
                END_IF;
            ELSE
                Status.Error.Id := UINT#714;
                UpdateOutputs := FALSE;
            END_IF;
       
        END_METHOD  

        METHOD PRIVATE IsValidReferences: BOOL
            VAR_INPUT
                refAcquisitionControl  :   REF_TO  BYTE;
                refAcquisitionStatus   :   REF_TO  ARRAY[0..2] OF BYTE;
                refInspectionControl   :   REF_TO  BYTE;
                refInspectionStatus    :   REF_TO  DWORD;
                refCommandControl      :   REF_TO  WORD;
                refCommandStatus       :   REF_TO  WORD;
                refSoftEventControl    :   REF_TO  BYTE;
                refSoftEventStatus     :   REF_TO  BYTE;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
                refUserData            :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR
            IsValidReferences := FALSE;
            IF refAcquisitionControl = NULL THEN
                Status.Error.Id := UINT#701;
            ELSIF refAcquisitionStatus = NULL THEN
                Status.Error.Id := UINT#702;
            ELSIF refInspectionControl = NULL THEN
                Status.Error.Id := UINT#703;
            ELSIF refInspectionStatus = NULL THEN
                Status.Error.Id := UINT#704;
            ELSIF refCommandControl  = NULL THEN
                Status.Error.Id := UINT#705;
            ELSIF refCommandStatus  = NULL THEN
                Status.Error.Id := UINT#706;
            ELSIF refSoftEventControl = NULL THEN
                Status.Error.Id := UINT#707;
            ELSIF refSoftEventStatus = NULL THEN
                Status.Error.Id := UINT#708;
            ELSIF refResultData = NULL THEN
                Status.Error.Id := UINT#709;
            ELSIF refUserData = NULL THEN
                Status.Error.Id := UINT#710;
            ELSE
                IsValidReferences := TRUE;
            END_IF;
        END_METHOD

        METHOD PROTECTED OVERRIDE Open
            SUPER.Open();
        END_METHOD  

        METHOD PUBLIC Run
            VAR_INPUT
                parent                 :   IAxoObject; 
                refAcquisitionControl  :   REF_TO  BYTE;
                refAcquisitionStatus   :   REF_TO  ARRAY[0..2] OF BYTE;
                refInspectionControl   :   REF_TO  BYTE;
                refInspectionStatus    :   REF_TO  DWORD;
                refCommandControl      :   REF_TO  WORD;
                refCommandStatus       :   REF_TO  WORD;
                refSoftEventControl    :   REF_TO  BYTE;
                refSoftEventStatus     :   REF_TO  BYTE;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
                refUserData            :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR
            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;
            IF NOT THIS.IsValidReferences(refAcquisitionControl,refAcquisitionStatus,refInspectionControl,refInspectionStatus,refCommandControl,refCommandStatus,refSoftEventControl,refSoftEventStatus,refResultData,refUserData) THEN
                RETURN;
            END_IF;
            THIS.Initialize(parent);
            THIS.Open();
            THIS.Execute(refAcquisitionControl,refAcquisitionStatus,refInspectionControl,refInspectionStatus,refCommandControl,refCommandStatus,refSoftEventControl,refSoftEventStatus,refResultData,refUserData);
            THIS.Close();            
        END_METHOD

        METHOD PUBLIC Run
            VAR_INPUT
                parent                 :   IAxoContext; 
                refAcquisitionControl  :   REF_TO  BYTE;
                refAcquisitionStatus   :   REF_TO  ARRAY[0..2] OF BYTE;
                refInspectionControl   :   REF_TO  BYTE;
                refInspectionStatus    :   REF_TO  DWORD;
                refCommandControl      :   REF_TO  WORD;
                refCommandStatus       :   REF_TO  WORD;
                refSoftEventControl    :   REF_TO  BYTE;
                refSoftEventStatus     :   REF_TO  BYTE;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
                refUserData            :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR
            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;
            IF NOT THIS.IsValidReferences(refAcquisitionControl,refAcquisitionStatus,refInspectionControl,refInspectionStatus,refCommandControl,refCommandStatus,refSoftEventControl,refSoftEventStatus,refResultData,refUserData) THEN
                RETURN;
            END_IF;
            THIS.Initialize(parent);
            THIS.Open();
            THIS.Execute(refAcquisitionControl,refAcquisitionStatus,refInspectionControl,refInspectionStatus,refCommandControl,refCommandStatus,refSoftEventControl,refSoftEventStatus,refResultData,refUserData);
            THIS.Close();            
        END_METHOD

        METHOD PRIVATE Execute
            VAR_INPUT
                refAcquisitionControl  :   REF_TO  BYTE;
                refAcquisitionStatus   :   REF_TO  ARRAY[0..2] OF BYTE;
                refInspectionControl   :   REF_TO  BYTE;
                refInspectionStatus    :   REF_TO  DWORD;
                refCommandControl      :   REF_TO  WORD;
                refCommandStatus       :   REF_TO  WORD;
                refSoftEventControl    :   REF_TO  BYTE;
                refSoftEventStatus     :   REF_TO  BYTE;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
                refUserData            :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR

            RestoreTask.Initialize(THIS);
            ClearInspectionResultsTask.Initialize(THIS);
            TriggerTask.Initialize(THIS);
            ChangeJobByNameTask.Initialize(THIS);
            ChangeJobByNumberTask.Initialize(THIS);

            THIS.UpdateInputs(refAcquisitionStatus,refInspectionStatus,refCommandStatus,refSoftEventStatus,refResultData);

            //*************RESTORE********************
            _taskDisabled := FALSE;
            RestoreTask.IsDisabled := _taskDisabled;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************CLEAR*DATA*****************
            _taskDisabled := _taskDisabled OR RestoreTask.IsBusy();
            ClearInspectionResultsTask.IsDisabled := _taskDisabled;
            ClearInspectionResultsTask.Run(REF(AcquisitionControl),REF(AcquisitionStatus),REF(InspectionControl),REF(InspectionStatus),REF(Config),REF(Status),REF(Results),REF(InspectionResults));
            //****************************************

            //*************READ***********************
            _taskDisabled := _taskDisabled OR ClearInspectionResultsTask.IsBusy();
            TriggerTask.IsDisabled :=  _taskDisabled;
            TriggerTask.Run(REF(AcquisitionControl),REF(AcquisitionStatus),REF(InspectionControl),REF(InspectionStatus),REF(CommandControl),REF(Config),REF(Status),REF(Results),REF(InspectionResults),refResultData);
            //****************************************

            //*************CHANGE JOB BY NAME*********
            _taskDisabled := _taskDisabled OR TriggerTask.IsBusy();
            ChangeJobByNameTask.IsDisabled :=  _taskDisabled;
            ChangeJobByNameTask.Run(REF(AcquisitionControl),REF(AcquisitionStatus),REF(InspectionControl),REF(InspectionStatus),REF(CommandControl),REF(Config),REF(Status),REF(Results),REF(User),REF(InspectionResults),refResultData,refUserData);
            //****************************************

            //*************CHANGE JOB BY NUMBER*********
            _taskDisabled := _taskDisabled OR ChangeJobByNameTask.IsBusy();
            ChangeJobByNumberTask.IsDisabled :=  _taskDisabled;
            ChangeJobByNumberTask.Run(REF(AcquisitionControl),REF(AcquisitionStatus),REF(InspectionControl),REF(InspectionStatus),REF(CommandControl),REF(Config),REF(Status),REF(Results),REF(User),REF(InspectionResults),refResultData,refUserData);
            //****************************************

            THIS.UpdateOutputs(refAcquisitionControl,refInspectionControl,refCommandControl,refSoftEventControl,refUserData);
        END_METHOD    
        
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
		/// Change the sensor job using job number. 	
        ///</summary>       
        METHOD PUBLIC ChangeJob : IAxoTaskState
            VAR_INPUT 
                Job : UINT;
            END_VAR
            ChangeJob := ChangeJobByNumberTask.InvokeWithParameters(Job);
        END_METHOD
        ///<summary>
		/// Change the sensor job using job name. 	
        ///</summary>       
        METHOD PUBLIC ChangeJob : IAxoTaskState
            VAR_INPUT 
                Job : STRING;
            END_VAR
            ChangeJob := ChangeJobByNameTask.InvokeWithParameters(Job);
        END_METHOD
    END_CLASS    

END_NAMESPACE