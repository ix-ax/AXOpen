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
            {#ix-set:AttributeName = "<#Update signal states#>"}
            _updateSignalStatesTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear result data#>"}
            _clearResultDataTask : AxoDatamanClearResultData;
                

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config      :   AxoDataman_Config;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status      :   AxoDataman_Status;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("User data")]}
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

            _updateSignalStatesTask.Restore();
            _clearResultDataTask.Restore();
            _readTask.Restore();
             
            Results.Code        :=  UINT#0;
            Results.Extended    :=  UINT#0;
            Results.Id          :=  UINT#0;
            Results.Length      :=  UINT#0;
                
            FOR _index := 0 TO 245 DO
                Results.Data[_index] := BYTE#0;
            END_FOR;

            _AcquisitionControl.TriggerEnable       :=  FALSE;
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

            Status.ActionDescription := '<#Restore executed!#>';
            _restoreTask.Restore();
        END_METHOD

        ///<summary>
		/// Custom logic for manual control of the AxoDataman.
        ///</summary>   
        METHOD PROTECTED OVERRIDE ManualControl
            ;
        END_METHOD

        METHOD PRIVATE UpdateInputs 
            VAR_INPUT
                AcquisitionStatus : ARRAY[0..2] OF BYTE;
                ResultsStatus : BYTE;
                SoftEventStatus : BYTE;
            END_VAR
            VAR_IN_OUT
                ResultData : ARRAY[*] OF BYTE;
            END_VAR

            _AcquisitionStatus.TriggerReady                  :=      AcquisitionStatus[0].%X0;
            _AcquisitionStatus.TriggerAcknowledge            :=      AcquisitionStatus[0].%X1;
            _AcquisitionStatus.MissedAcquisition             :=      AcquisitionStatus[0].%X3;
            _AcquisitionStatus.TriggerID.%B0                 :=      AcquisitionStatus[1];	 //TODO check order of the bytes
            _AcquisitionStatus.TriggerID.%B1                 :=      AcquisitionStatus[2];	 //TODO check order of the bytes

            _ResultsStatus.Decoding                          :=      ResultsStatus.%X0;
            _ResultsStatus.DecodeComplete                    :=      ResultsStatus.%X1;
            _ResultsStatus.ResultsBufferOverrun              :=      ResultsStatus.%X2;
            _ResultsStatus.ResultsAvailable                  :=      ResultsStatus.%X3;
            _ResultsStatus.ErrorDetected                     :=      ResultsStatus.%X7;

            _SoftEventStatus.TrainCodeAcknowledge            :=      SoftEventStatus.%X0;
            _SoftEventStatus.TrainMatchStringAcknowledge     :=      SoftEventStatus.%X1;
            _SoftEventStatus.TrainFocusAcknowledge           :=      SoftEventStatus.%X2;
            _SoftEventStatus.TrainBrightnessAcknowledge      :=      SoftEventStatus.%X3;
            _SoftEventStatus.UntrainAcknowledge              :=      SoftEventStatus.%X4;
            _SoftEventStatus.ExecuteDmccAcknowledge          :=      SoftEventStatus.%X5;
            _SoftEventStatus.Reserved06                      :=      SoftEventStatus.%X6;
            _SoftEventStatus.SetMatchStringAcknowledge       :=      SoftEventStatus.%X7;

            IF (LOWER_BOUND(ResultData,1) = 0) THEN
                IF (UPPER_BOUND(ResultData,1) = 23) THEN
                    Config.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_16B;
                ELSIF (UPPER_BOUND(ResultData,1) = 39) THEN
                    Config.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_32B;
                ELSIF (UPPER_BOUND(ResultData,1) = 71) THEN
                    Config.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_64B;
                ELSIF (UPPER_BOUND(ResultData,1) = 135) THEN
                    Config.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_128B;
                ELSIF (UPPER_BOUND(ResultData,1) = 253) THEN
                    Config.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_246B;
                ELSE
                    Config.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
                END_IF;
            ELSE
                Config.ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            END_IF;

            IF(Config.ResultDataSize <> eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID) THEN
                Results.Id.%B0          :=  ResultData[0];     //TODO check order of the bytes
                Results.Id.%B1          :=  ResultData[1];     //TODO check order of the bytes
                Results.Code.%B0        :=  ResultData[2];     //TODO check order of the bytes
                Results.Code.%B1        :=  ResultData[3];     //TODO check order of the bytes
                Results.Extended.%B0    :=  ResultData[4];     //TODO check order of the bytes
                Results.Extended.%B1    :=  ResultData[5];     //TODO check order of the bytes
                Results.Length.%B0      :=  ResultData[6];     //TODO check order of the bytes
                Results.Length.%B1      :=  ResultData[7];     //TODO check order of the bytes
            END_IF;

        END_METHOD  

        METHOD PRIVATE UpdateOutputs 
            VAR_IN_OUT
                AcquisitionControl : BYTE;
                ResultsControl : BYTE;
                SoftEventControl : BYTE;
                UserData : ARRAY[*] OF BYTE;
            END_VAR

            AcquisitionControl.%X0      :=      _AcquisitionControl.Trigger;
            AcquisitionControl.%X1      :=      _AcquisitionControl.TriggerEnable;

            ResultsControl.%X0          :=      _ResultsControl.EnableResultBuffering;
            ResultsControl.%X1          :=      _ResultsControl.ResultsAcknowledge;
            
            SoftEventControl.%X0        :=      _SoftEventControl.TrainCode;
            SoftEventControl.%X1        :=      _SoftEventControl.TrainMatchString;
            SoftEventControl.%X2        :=      _SoftEventControl.TrainFocus;
            SoftEventControl.%X3        :=      _SoftEventControl.TrainBrightness;
            SoftEventControl.%X4        :=      _SoftEventControl.Untrain;
            SoftEventControl.%X5        :=      _SoftEventControl.ExecuteDMCC;
            SoftEventControl.%X6        :=      _SoftEventControl.Reserved06;
            SoftEventControl.%X7        :=      _SoftEventControl.SetMatchString;

            IF (LOWER_BOUND(UserData,1) = 0) THEN
                IF (UPPER_BOUND(UserData,1) = 19) THEN
                    Config.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_16B;
                ELSIF (UPPER_BOUND(UserData,1) = 35) THEN
                    Config.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_32B;
                ELSIF (UPPER_BOUND(UserData,1) = 67) THEN
                    Config.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_64B;
                ELSIF (UPPER_BOUND(UserData,1) = 131) THEN
                    Config.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_128B;
                ELSIF (UPPER_BOUND(UserData,1) = 253) THEN
                    Config.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_250B;
                ELSE
                    Config.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID;
                END_IF;
            ELSE
                Config.UserDataSize := eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID;
            END_IF;

            IF(Config.UserDataSize <> eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID) THEN
                UserData[0]     :=  User.Option.%B0;    //TODO check order of the bytes
                UserData[1]     :=  User.Option.%B1;    //TODO check order of the bytes
                UserData[2]     :=  User.Length.%B0;    //TODO check order of the bytes
                UserData[3]     :=  User.Length.%B0;    //TODO check order of the bytes
            END_IF;           
        END_METHOD  

        METHOD PROTECTED OVERRIDE Open
            SUPER.Open();
        END_METHOD  

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject; 
                AcquisitionStatus : ARRAY[0..2] OF BYTE;
                ResultsStatus : BYTE;
                SoftEventStatus : BYTE;
            END_VAR
            VAR_IN_OUT
                ResultData : ARRAY[*] OF BYTE;
                AcquisitionControl : BYTE;
                ResultsControl : BYTE;
                SoftEventControl : BYTE;
                UserData : ARRAY[*] OF BYTE;
            END_VAR
            
            THIS.Initialize(parent);
            THIS.Open();
            THIS.Execute(AcquisitionStatus,ResultsStatus,SoftEventStatus,ResultData,AcquisitionControl,ResultsControl,SoftEventControl,UserData);
            THIS.Close();            
        END_METHOD

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoContext; 
                AcquisitionStatus : ARRAY[0..2] OF BYTE;
                ResultsStatus : BYTE;
                SoftEventStatus : BYTE;
            END_VAR
            VAR_IN_OUT
                ResultData : ARRAY[*] OF BYTE;
                AcquisitionControl : BYTE;
                ResultsControl : BYTE;
                SoftEventControl : BYTE;
                UserData : ARRAY[*] OF BYTE;
            END_VAR
            
            THIS.Initialize(parent);
            THIS.Open();
            THIS.Execute(AcquisitionStatus,ResultsStatus,SoftEventStatus,ResultData,AcquisitionControl,ResultsControl,SoftEventControl,UserData);
            THIS.Close();            
        END_METHOD

        METHOD PRIVATE Execute
            VAR_INPUT
                AcquisitionStatus : ARRAY[0..2] OF BYTE;
                ResultsStatus : BYTE;
                SoftEventStatus : BYTE;
            END_VAR
            VAR_IN_OUT
                ResultData : ARRAY[*] OF BYTE;
                AcquisitionControl : BYTE;
                ResultsControl : BYTE;
                SoftEventControl : BYTE;
                UserData : ARRAY[*] OF BYTE;
            END_VAR
            
            _restoreTask.Initialize(THIS);
            _updateSignalStatesTask.Initialize(THIS);
            _clearResultDataTask.Initialize(THIS);
            _readTask.Initialize(THIS);

            THIS.UpdateInputs(AcquisitionStatus,ResultsStatus,SoftEventStatus,ResultData);

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
            _clearResultDataTask.Run(_AcquisitionControl,_AcquisitionStatus,_ResultsControl,_ResultsStatus,Config,Status,Results);
            //****************************************

        
            //*************READ***********************
            _taskDisabled := _taskDisabled OR _clearResultDataTask.IsBusy();
            _readTask.IsDisabled :=  _taskDisabled;
            _readTask.Run(_AcquisitionControl,_AcquisitionStatus,_ResultsControl,_ResultsStatus,ResultData,Config,Status,Results);
            //****************************************

            THIS.UpdateOutputs(AcquisitionControl,ResultsControl,SoftEventControl,UserData);
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