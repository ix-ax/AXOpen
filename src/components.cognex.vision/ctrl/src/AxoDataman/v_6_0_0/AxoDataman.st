USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0

    CLASS PUBLIC AxoDataman EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.IAxoCodeReader     
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Read#>"}
            ReadTask : AxoDatamanRead;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Inspection results#>"}
            ResultData  :   AxoDataman_ResultData;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear result data#>"}
            ClearResultDataTask : AxoDatamanClearResultData;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            Config      :   AxoDataman_Config;

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
            UserData        :   AxoDataman_UserData;

            {#ix-attr:[ReadOnly()]}
            _Messenger    :   AXOpen.Messaging.Static.AxoMessenger;
            {#ix-attr:[ReadOnly()]}
            _TaskMessenger    :   AXOpen.Messaging.Static.AxoMessenger;
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
            _Messenger.Restore();
            _TaskMessenger.Restore();

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
                Status.Action.Id := UINT#300;
                RestoreTask.DoneWhen(TRUE);
            END_IF;
        END_METHOD

        ///<summary>
		/// Custom logic for the manual control.
        ///</summary>   
        METHOD PROTECTED OVERRIDE ManualControl
            ;
        END_METHOD

        METHOD PRIVATE UpdateInputs : BOOL
            VAR_INPUT
                refAcquisitionStatus   :   REF_TO  ARRAY[0..2] OF BYTE;
                refResultsStatus       :   REF_TO  BYTE;
                refSoftEventStatus     :   REF_TO  BYTE;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR
            AcquisitionStatus.TriggerReady                  :=      refAcquisitionStatus^[0].%X0;
            AcquisitionStatus.TriggerAcknowledge            :=      refAcquisitionStatus^[0].%X1;
            AcquisitionStatus.MissedAcquisition             :=      refAcquisitionStatus^[0].%X3;
            AcquisitionStatus.TriggerID.%B1                 :=      refAcquisitionStatus^[1];	 
            AcquisitionStatus.TriggerID.%B0                 :=      refAcquisitionStatus^[2];	 

            ResultsStatus.Decoding                          :=      refResultsStatus^.%X0;
            ResultsStatus.DecodeComplete                    :=      refResultsStatus^.%X1;
            ResultsStatus.ResultsBufferOverrun              :=      refResultsStatus^.%X2;
            ResultsStatus.ResultsAvailable                  :=      refResultsStatus^.%X3;
            ResultsStatus.ErrorDetected                     :=      refResultsStatus^.%X7;

            SoftEventStatus.TrainCodeAcknowledge            :=      refSoftEventStatus^.%X0;
            SoftEventStatus.TrainMatchStringAcknowledge     :=      refSoftEventStatus^.%X1;
            SoftEventStatus.TrainFocusAcknowledge           :=      refSoftEventStatus^.%X2;
            SoftEventStatus.TrainBrightnessAcknowledge      :=      refSoftEventStatus^.%X3;
            SoftEventStatus.UntrainAcknowledge              :=      refSoftEventStatus^.%X4;
            SoftEventStatus.ExecuteDmccAcknowledge          :=      refSoftEventStatus^.%X5;
            SoftEventStatus.Reserved06                      :=      refSoftEventStatus^.%X6;
            SoftEventStatus.SetMatchStringAcknowledge       :=      refSoftEventStatus^.%X7;


            IF (LOWER_BOUND(refResultData^,1) = 0) THEN
                IF (UPPER_BOUND(refResultData^,1) = 23) THEN
                    Status.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_16B;
                ELSIF (UPPER_BOUND(refResultData^,1) = 39) THEN
                    Status.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_32B;
                ELSIF (UPPER_BOUND(refResultData^,1) = 71) THEN
                    Status.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_64B;
                ELSIF (UPPER_BOUND(refResultData^,1) = 135) THEN
                    Status.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_128B;
                ELSIF (UPPER_BOUND(refResultData^,1) = 253) THEN
                    Status.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_246B;
                ELSE
                    Status.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
                    Status.Error.Id := UINT#709;
                    UpdateInputs := FALSE;
                END_IF;
            ELSE
                Status.Error.Id := UINT#710;
                UpdateInputs := FALSE;
                Status.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            END_IF;

            _Messenger.ActivateOnCondition(ULINT#709,Status.ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#710,LOWER_BOUND(refResultData^,1) <> 0, eAxoMessageCategory#ProgrammingError);

            IF(Status.ResultDataSize <> eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID) THEN
                Results.Id.%B1          :=  refResultData^[0];     
                Results.Id.%B0          :=  refResultData^[1];     
                Results.Code.%B1        :=  refResultData^[2];     
                Results.Code.%B0        :=  refResultData^[3];     
                Results.Extended.%B1    :=  refResultData^[4];     
                Results.Extended.%B0    :=  refResultData^[5];     
                Results.Length.%B1      :=  refResultData^[6];     
                Results.Length.%B0      :=  refResultData^[7];     
                UpdateInputs := TRUE;
            END_IF;

        END_METHOD  

        METHOD PRIVATE UpdateOutputs : BOOL
            VAR_INPUT
                refAcquisitionControl  :   REF_TO  BYTE;
                refResultsControl      :   REF_TO  BYTE;
                refSoftEventControl    :   REF_TO  BYTE;
                refUserData            :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR
            VAR
                UserDataChanged         :   BOOL;
                index                   :   INT;
            END_VAR

            UpdateOutputs := TRUE;

            refAcquisitionControl^.%X0      :=      AcquisitionControl.TriggerEnable;
            refAcquisitionControl^.%X1      :=      AcquisitionControl.Trigger;

            refResultsControl^.%X0          :=      ResultsControl.EnableResultBuffering;
            refResultsControl^.%X1          :=      ResultsControl.ResultsAcknowledge;
            
            refSoftEventControl^.%X0        :=      SoftEventControl.TrainCode;
            refSoftEventControl^.%X1        :=      SoftEventControl.TrainMatchString;
            refSoftEventControl^.%X2        :=      SoftEventControl.TrainFocus;
            refSoftEventControl^.%X3        :=      SoftEventControl.TrainBrightness;
            refSoftEventControl^.%X4        :=      SoftEventControl.Untrain;
            refSoftEventControl^.%X5        :=      SoftEventControl.ExecuteDMCC;
            refSoftEventControl^.%X6        :=      SoftEventControl.Reserved06;
            refSoftEventControl^.%X7        :=      SoftEventControl.SetMatchString;

            IF (LOWER_BOUND(refUserData^,1) = 0) THEN
                IF (UPPER_BOUND(refUserData^,1) = 19) THEN
                    Status.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_16B;
                ELSIF (UPPER_BOUND(refUserData^,1) = 35) THEN
                    Status.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_32B;
                ELSIF (UPPER_BOUND(refUserData^,1) = 67) THEN
                    Status.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_64B;
                ELSIF (UPPER_BOUND(refUserData^,1) = 131) THEN
                    Status.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_128B;
                ELSIF (UPPER_BOUND(refUserData^,1) = 253) THEN
                    Status.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_250B;
                ELSE
                    Status.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID;
                    Status.Error.Id := UINT#711;
                    UpdateOutputs := FALSE;
                END_IF;
            ELSE
                Status.Error.Id := UINT#712;
                UpdateOutputs := FALSE;
            END_IF;
            _Messenger.ActivateOnCondition(ULINT#711,Status.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#712,LOWER_BOUND(refUserData^,1) <> 0, eAxoMessageCategory#ProgrammingError);

            IF(Status.UserDataSize <> eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID) AND (UserData.DataChanged <> UserDataChanged) THEN
                refUserData^[0]     :=  User.Option.%B1;   
                refUserData^[1]     :=  User.Option.%B0;   
                refUserData^[2]     :=  User.Length.%B1;   
                refUserData^[3]     :=  User.Length.%B0;   
                FOR index := 0 TO (TO_INT(User.Length) - INT#1) DO
                    refUserData^[index + 4] := UserData.Data[index];
                END_FOR;
                UserDataChanged := UserData.DataChanged;
            END_IF;           
        END_METHOD  

        METHOD PRIVATE IsValidReferences: BOOL
            VAR_INPUT
                refAcquisitionControl  :   REF_TO  BYTE;
                refAcquisitionStatus   :   REF_TO  ARRAY[0..2] OF BYTE;
                refResultsControl      :   REF_TO  BYTE;
                refResultsStatus       :   REF_TO  BYTE;
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
            ELSIF refResultsControl = NULL THEN
                Status.Error.Id := UINT#703;
            ELSIF refResultsStatus = NULL THEN
                Status.Error.Id := UINT#704;
            ELSIF refSoftEventControl  = NULL THEN
                Status.Error.Id := UINT#705;
            ELSIF refSoftEventStatus = NULL THEN
                Status.Error.Id := UINT#706;
            ELSIF refResultData = NULL THEN
                Status.Error.Id := UINT#707;
            ELSIF refUserData = NULL THEN
                Status.Error.Id := UINT#708;
            ELSE
                IsValidReferences := TRUE;
            END_IF;

            _Messenger.ActivateOnCondition(ULINT#701,refAcquisitionControl = NULL, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#702,refAcquisitionStatus = NULL, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#703,refResultsControl = NULL, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#704,refResultsStatus = NULL, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#705,refSoftEventControl = NULL, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#706,refSoftEventStatus = NULL, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#707,refResultData = NULL, eAxoMessageCategory#ProgrammingError);
            _Messenger.ActivateOnCondition(ULINT#708,refUserData = NULL, eAxoMessageCategory#ProgrammingError);
        END_METHOD

        METHOD PRIVATE ContinuousReading
            VAR_INPUT
                refStatus              :   REF_TO  AxoDataman_Status;
                refResults             :   REF_TO  AxoDataman_Results;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR     
            VAR 
                _index : INT;
            END_VAR
            IF ResultsStatus.ResultsAvailable AND NOT ResultsControl.ResultsAcknowledge AND Results.Code > UINT#0 AND Results.Length > UINT#0 THEN
                _Messenger.ActivateOnCondition(ULINT#713, refResults^.Length > TO_UINT(refStatus^.ResultDataSize), eAxoMessageCategory#Error);
                IF refResults^.Length > TO_UINT(refStatus^.ResultDataSize) THEN
                    Status.Action.Id := UINT#701;
                    Status.Error.Id := UINT#713;
                ELSE
                    FOR _index := 0 TO (TO_INT(refResults^.Length) - INT#1) DO
                        ResultData.Data[_index] := refResultData^[_index + 8];
                    END_FOR;
                    FOR _index := TO_INT(refResults^.Length) TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    ResultData.DataChanged := NOT ResultData.DataChanged ;
                    Status.Action.Id := UINT#307;
                END_IF;
            END_IF;

            ResultsControl.ResultsAcknowledge := ResultsStatus.ResultsAvailable;
        END_METHOD

        METHOD PROTECTED OVERRIDE Open
            SUPER.Open();
        END_METHOD  

        METHOD PUBLIC Run
            VAR_INPUT
                parent                  :   IAxoObject; 
                refAcquisitionControl   :   REF_TO  BYTE;
                refAcquisitionStatus    :   REF_TO  ARRAY[0..2] OF BYTE;
                refResultsControl       :   REF_TO  BYTE;
                refResultsStatus        :   REF_TO  BYTE;
                refSoftEventControl     :   REF_TO  BYTE;
                refSoftEventStatus      :   REF_TO  BYTE;
                refResultData           :   REF_TO  ARRAY[*] OF BYTE;
                refUserData             :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR
            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;

            _Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF NOT THIS.IsValidReferences(refAcquisitionControl,refAcquisitionStatus,refResultsControl,refResultsStatus,refSoftEventControl,refSoftEventStatus,refResultData,refUserData) THEN
                RETURN;
            END_IF;
            THIS.Initialize(parent);
            THIS.Open();
            THIS.Execute(refAcquisitionControl,refAcquisitionStatus,refResultsControl,refResultsStatus,refSoftEventControl,refSoftEventStatus,refResultData,refUserData);
            THIS.Close();            
        END_METHOD

        METHOD PUBLIC Run
            VAR_INPUT
                parent                  :   IAxoContext; 
                refAcquisitionControl   :   REF_TO  BYTE;
                refAcquisitionStatus    :   REF_TO  ARRAY[0..2] OF BYTE;
                refResultsControl       :   REF_TO  BYTE;
                refResultsStatus        :   REF_TO  BYTE;
                refSoftEventControl     :   REF_TO  BYTE;
                refSoftEventStatus      :   REF_TO  BYTE;
                refResultData           :   REF_TO  ARRAY[*] OF BYTE;
                refUserData             :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR
            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            END_IF;

            _Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF NOT THIS.IsValidReferences(refAcquisitionControl,refAcquisitionStatus,refResultsControl,refResultsStatus,refSoftEventControl,refSoftEventStatus,refResultData,refUserData) THEN
                RETURN;
            END_IF;
            THIS.Initialize(parent);
            THIS.Open();
            THIS.Execute(refAcquisitionControl,refAcquisitionStatus,refResultsControl,refResultsStatus,refSoftEventControl,refSoftEventStatus,refResultData,refUserData);
            THIS.Close();          
        END_METHOD

        METHOD PRIVATE Execute
            VAR_INPUT
                refAcquisitionControl  :   REF_TO  BYTE;
                refAcquisitionStatus   :   REF_TO  ARRAY[0..2] OF BYTE;
                refResultsControl      :   REF_TO  BYTE;
                refResultsStatus       :   REF_TO  BYTE;
                refSoftEventControl    :   REF_TO  BYTE;
                refSoftEventStatus     :   REF_TO  BYTE;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
                refUserData            :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR

            RestoreTask.Initialize(THIS);
            ClearResultDataTask.Initialize(THIS);
            ReadTask.Initialize(THIS);

            _Messenger.Serve(THIS);
 
            THIS.UpdateInputs(refAcquisitionStatus,refResultsStatus,refSoftEventStatus,refResultData);
 
            IF Config.ContinuousReading THEN
	            THIS.ContinuousReading(REF(Status), REF(Results),refResultData);
            END_IF;

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************CLEAR*DATA*****************
            ClearResultDataTask.IsDisabled := RestoreTask.IsBusy() OR ReadTask.IsBusy();
            ClearResultDataTask.Run(REF(AcquisitionControl),REF(AcquisitionStatus),REF(ResultsControl),REF(ResultsStatus),REF(Config),REF(Status),REF(Results),REF(ResultData),REF(_TaskMessenger));
            //****************************************

            //*************READ***********************
            ReadTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearResultDataTask.IsBusy();
            ReadTask.Run(REF(AcquisitionControl),REF(AcquisitionStatus),REF(ResultsControl),REF(ResultsStatus),REF(Config),REF(Status),REF(Results),REF(ResultData),refResultData,REF(_TaskMessenger));
            //****************************************

            THIS.UpdateOutputs(refAcquisitionControl,refResultsControl,refSoftEventControl,refUserData);
        END_METHOD    
        
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
            Read := ReadTask.Invoke();
        END_METHOD

    END_CLASS    

END_NAMESPACE