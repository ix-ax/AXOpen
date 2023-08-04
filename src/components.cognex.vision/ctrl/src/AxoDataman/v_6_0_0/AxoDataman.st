USING AXOpen.Core;
USING AXOpen.Components.Abstractions;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0

    CLASS PUBLIC AxoDataman EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.IAxoCodeReader     
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Read#>"}
            _readTask : AxoDatamanRead;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Results#>"}
            Results     :   AxoDataman_Results;


            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            _restoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear result data#>"}
            _clearResultDataTask : AxoDatamanClearResultData;
                

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            Config      :   AxoDataman_Config;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Update#>"}
            _updateSignalStatesTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status      :   AxoDataman_Status;

            {#ix-attr:[CompilerOmits()]} 
            User        :   AxoDataman_User;
        END_VAR

        VAR PRIVATE
            _AcquisitionControl     :   AxoDataman_AcquisitionControl;
            _AcquisitionStatus      :   AxoDataman_AcquisitionStatus;
            _ResultsControl         :   AxoDataman_ResultsControl;
            _ResultsStatus          :   AxoDataman_ResultsStatus;
            _SoftEventControl       :   AxoDataman_SoftEventControl;
            _SoftEventStatus        :   AxoDataman_SoftEventStatus;
            _taskDisabled           :   BOOL;
        END_VAR
               
        ///<summary>
		/// Restores this instance. 
        ///</summary>   
        METHOD PROTECTED OVERRIDE Restore: IAxoTask 
            VAR
                _index : INT;
            END_VAR
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;

            _updateSignalStatesTask.Restore();
            _clearResultDataTask.Restore();
            _readTask.Restore();
             
            Results.Code        :=  UINT#0;
            Results.Extended    :=  UINT#0;
            Results.Id          :=  UINT#0;
            Results.Length      :=  UINT#0;
            Results.Data        :=  '';

            _AcquisitionControl.TriggerEnable       :=  _ResultsStatus.ErrorDetected;
            _AcquisitionControl.Trigger             :=  FALSE;

            _ResultsControl.EnableResultBuffering   :=  FALSE;
            _ResultsControl.ResultsAcknowledge      :=  FALSE;       

            _SoftEventControl.TrainCode 			:=  FALSE;    			
            _SoftEventControl.TrainMatchString 		:=  FALSE;   
            _SoftEventControl.TrainFocus 			:=  FALSE;   			
            _SoftEventControl.TrainBrightness 		:=  FALSE;   
            _SoftEventControl.Untrain 				:=  FALSE;   		
            _SoftEventControl.ExecuteDMCC 			:=  FALSE;   	
            _SoftEventControl.Reserved06 			:=  FALSE;    	
            _SoftEventControl.SetMatchString 		:=  FALSE;   		

            User.Option :=  UINT#0;
            User.Length :=  UINT#0;
            FOR _index := 0 TO 245 DO
                User.Data[_index] := BYTE#0;
            END_FOR;

            IF NOT _ResultsStatus.ErrorDetected THEN
                Status.Action.Id := UINT#300;
                _restoreTask.DoneWhen(TRUE);
            END_IF;
        END_METHOD

        ///<summary>
		/// Custom logic for manual control of the AxoDataman.
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
            _AcquisitionStatus.TriggerReady                  :=      refAcquisitionStatus^[0].%X0;
            _AcquisitionStatus.TriggerAcknowledge            :=      refAcquisitionStatus^[0].%X1;
            _AcquisitionStatus.MissedAcquisition             :=      refAcquisitionStatus^[0].%X3;
            _AcquisitionStatus.TriggerID.%B1                 :=      refAcquisitionStatus^[1];	 
            _AcquisitionStatus.TriggerID.%B0                 :=      refAcquisitionStatus^[2];	 

            _ResultsStatus.Decoding                          :=      refResultsStatus^.%X0;
            _ResultsStatus.DecodeComplete                    :=      refResultsStatus^.%X1;
            _ResultsStatus.ResultsBufferOverrun              :=      refResultsStatus^.%X2;
            _ResultsStatus.ResultsAvailable                  :=      refResultsStatus^.%X3;
            _ResultsStatus.ErrorDetected                     :=      refResultsStatus^.%X7;

            _SoftEventStatus.TrainCodeAcknowledge            :=      refSoftEventStatus^.%X0;
            _SoftEventStatus.TrainMatchStringAcknowledge     :=      refSoftEventStatus^.%X1;
            _SoftEventStatus.TrainFocusAcknowledge           :=      refSoftEventStatus^.%X2;
            _SoftEventStatus.TrainBrightnessAcknowledge      :=      refSoftEventStatus^.%X3;
            _SoftEventStatus.UntrainAcknowledge              :=      refSoftEventStatus^.%X4;
            _SoftEventStatus.ExecuteDmccAcknowledge          :=      refSoftEventStatus^.%X5;
            _SoftEventStatus.Reserved06                      :=      refSoftEventStatus^.%X6;
            _SoftEventStatus.SetMatchStringAcknowledge       :=      refSoftEventStatus^.%X7;


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
                    Status.Error.Id := UINT#708;
                    UpdateInputs := FALSE;
                END_IF;
            ELSE
                Status.Error.Id := UINT#709;
                UpdateInputs := FALSE;
                Status.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            END_IF;

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

            refAcquisitionControl^.%X0      :=      _AcquisitionControl.TriggerEnable;
            refAcquisitionControl^.%X1      :=      _AcquisitionControl.Trigger;

            refResultsControl^.%X0          :=      _ResultsControl.EnableResultBuffering;
            refResultsControl^.%X1          :=      _ResultsControl.ResultsAcknowledge;
            
            refSoftEventControl^.%X0        :=      _SoftEventControl.TrainCode;
            refSoftEventControl^.%X1        :=      _SoftEventControl.TrainMatchString;
            refSoftEventControl^.%X2        :=      _SoftEventControl.TrainFocus;
            refSoftEventControl^.%X3        :=      _SoftEventControl.TrainBrightness;
            refSoftEventControl^.%X4        :=      _SoftEventControl.Untrain;
            refSoftEventControl^.%X5        :=      _SoftEventControl.ExecuteDMCC;
            refSoftEventControl^.%X6        :=      _SoftEventControl.Reserved06;
            refSoftEventControl^.%X7        :=      _SoftEventControl.SetMatchString;

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
                    Status.Error.Id := UINT#710;
                    UpdateOutputs := FALSE;
                END_IF;
            ELSE
                Status.Error.Id := UINT#711;
                UpdateOutputs := FALSE;
        END_IF;

            IF(Status.UserDataSize <> eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID) THEN
                refUserData^[0]     :=  User.Option.%B1;   
                refUserData^[1]     :=  User.Option.%B0;   
                refUserData^[2]     :=  User.Length.%B1;   
                refUserData^[3]     :=  User.Length.%B0;   
                UpdateOutputs := TRUE;
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
            ELSIF refSoftEventControl  = NULL THEN
                Status.Error.Id := UINT#704;
            ELSIF refSoftEventStatus = NULL THEN
                Status.Error.Id := UINT#705;
            ELSIF refResultData = NULL THEN
                Status.Error.Id := UINT#706;
            ELSIF refUserData = NULL THEN
                Status.Error.Id := UINT#707;
            ELSE
                IsValidReferences := TRUE;
            END_IF;
        END_METHOD

        METHOD PRIVATE ContinuousReading
            VAR_INPUT
                refResults             :   REF_TO  AxoDataman_Results;
                refResultData          :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR     

            IF _ResultsStatus.ResultsAvailable AND NOT _ResultsControl.ResultsAcknowledge AND Results.Code > UINT#0 AND Results.Length > UINT#0 THEN
                System.SerDe.Deserialize(UINT#7, refResultData^, refResults^.Data);
                Status.Action.Id := UINT#708;
            END_IF;

            _ResultsControl.ResultsAcknowledge := _ResultsStatus.ResultsAvailable;
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

            _restoreTask.Initialize(THIS);
            _updateSignalStatesTask.Initialize(THIS);
            _clearResultDataTask.Initialize(THIS);
            _readTask.Initialize(THIS);

            THIS.UpdateInputs(refAcquisitionStatus,refResultsStatus,refSoftEventStatus,refResultData);

            IF Config.ContinuousReading THEN
	            THIS.ContinuousReading(REF(Results),refResultData);
            END_IF;

            //*************RESTORE********************
            _taskDisabled := FALSE;
            _restoreTask.IsDisabled := _taskDisabled;
            IF _restoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************UPDATE*********************
            _taskDisabled := _taskDisabled OR _restoreTask.IsBusy();
            _updateSignalStatesTask.IsDisabled:= _taskDisabled;
            IF _updateSignalStatesTask.Execute() THEN
                THIS.UpdateSignalStates();
            END_IF;
            //****************************************

            //*************CLEAR*DATA*****************
            _taskDisabled := _taskDisabled OR _updateSignalStatesTask.IsBusy();
            _clearResultDataTask.IsDisabled := _taskDisabled;
            _clearResultDataTask.Run(REF(_AcquisitionControl),REF(_AcquisitionStatus),REF(_ResultsControl),REF(_ResultsStatus),REF(Config),REF(Status),REF(Results));
            //****************************************

        
            //*************READ***********************
            _taskDisabled := _taskDisabled OR _clearResultDataTask.IsBusy();
            _readTask.IsDisabled :=  _taskDisabled;
            _readTask.Run(REF(_AcquisitionControl),REF(_AcquisitionStatus),REF(_ResultsControl),REF(_ResultsStatus),REF(Config),REF(Status),REF(Results),refResultData);
            //****************************************

            THIS.UpdateOutputs(refAcquisitionControl,refResultsControl,refSoftEventControl,refUserData);
        END_METHOD    
        
        METHOD PROTECTED OVERRIDE Close
            SUPER.Close();
        END_METHOD  
    
        METHOD PUBLIC ClearResultData : IAxoTaskState
            ClearResultData :=_clearResultDataTask.Invoke();;
        END_METHOD

        METHOD PUBLIC Read : IAxoTaskState
            Read := _readTask.Invoke();
        END_METHOD
        
        METHOD PRIVATE UpdateSignalStates
            Status.SignalStatus.TriggerEnable 			:=	_AcquisitionControl.TriggerEnable; 
            Status.SignalStatus.Trigger				    :=	_AcquisitionControl.Trigger; 

            Status.SignalStatus.EnableResultBuffering	:=	_ResultsControl.EnableResultBuffering;
            Status.SignalStatus.ResultsAcknowledge		:=	_ResultsControl.ResultsAcknowledge;

            Status.SignalStatus.TriggerReady 			:= 	_AcquisitionStatus.TriggerReady;
            Status.SignalStatus.TriggerAcknowledge 	    := 	_AcquisitionStatus.TriggerAcknowledge;
            Status.SignalStatus.Acquiring 				:= 	_AcquisitionStatus.Acquiring;
            Status.SignalStatus.MissedAcquisition 		:= 	_AcquisitionStatus.MissedAcquisition;
            Status.SignalStatus.TriggerID 				:= 	_AcquisitionStatus.TriggerID;

            Status.SignalStatus.Decoding 				:= 	_ResultsStatus.Decoding;
            Status.SignalStatus.DecodeComplete 		    := 	_ResultsStatus.DecodeComplete;
            Status.SignalStatus.ResultsBufferOverrun 	:= 	_ResultsStatus.ResultsBufferOverrun;
            Status.SignalStatus.ResultsAvailable 		:= 	_ResultsStatus.ResultsAvailable;
            Status.SignalStatus.ErrorDetected 			:= 	_ResultsStatus.ErrorDetected;

            Status.SignalStatus.ResultID 				:= 	Results.ID;
            Status.SignalStatus.ResultCode  			:= 	Results.Code;
            Status.SignalStatus.ResultExtended  		:= 	Results.Extended;
            Status.SignalStatus.ResultLength  			:= 	Results.Length;

            _updateSignalStatesTask.DoneWhen(TRUE);
        END_METHOD
    END_CLASS    

END_NAMESPACE