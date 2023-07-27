USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING System.SerDe;


NAMESPACE AXOpen.Cgn
    CLASS DatamanReader EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}            
            ReadedData : STRING;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            Trigger : AxoTask;
            {#ix-attr:[ComponentHeader()]}
            ReadData : AxoTask;
            {#ix-attr:[ComponentHeader()]}
            ClearData : AxoTask;
            {#ix-attr:[ComponentHeader()]}            
            Reset : AxoTask;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Control")]}
            _AcquisitionControl : CgnReader_Acquisition_Control;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            _AcquisitionStatus : CgnReader_AcquisitionStatus;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("ResultsControl")]}
            _ResultsControl : CgnReader_ResultsControl;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("ResultsStatus")]}
            {#ix-attr:[ReadOnly()]}
            _ResultsStatus : CgnReader_ResultsStatus;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("SoftEventControl")]}
            {#ix-attr:[ReadOnly()]}
            _SoftEventControl : CgnReader_SoftEventControl;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("SoftEventControl")]}
            TrainCode : AxoTask;
            {#ix-attr:[ComponentDetails("SoftEventControl")]}
            TrainFocus : AxoTask;
            {#ix-attr:[ComponentDetails("SoftEventControl")]}
            TrainBrightness : AxoTask;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("SoftEventStatus")]}
            {#ix-attr:[ReadOnly()]}
            _SoftEventStatus : CgnReader_SoftEventStatus;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("UserData")]}
            {#ix-attr:[ReadOnly()]}
            _UserData_128_DataString : STRING;

			{#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Results")]}
            {#ix-attr:[ReadOnly()]}
            _Results_128_DataString : STRING;



         (*   {#ix-attr:[ComponentDetails("Signals")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Move work signal#>"}
            _MoveWorkSignal : BOOL;

            {#ix-set:MessageText = "<#Move to work position did not succeed.#>"}
            {#ix-set:Help = "<#Check the cyclinder that it is free to move, check that the air pressure reaches... and extremity sensor.#>"}
            _MoveToWorkNotReached : AXOpen.Messaging.Static.AxoMessenger;

            {#ix-set:MessageText = "<#Move to home position did not succeed.#>"}
            {#ix-set:Help = "<#Check the cyclinder that it is free to move, check that the air pressure reaches... and extremity sensor.#>"}
            _MoveToHomeNotReached : AXOpen.Messaging.Static.AxoMessenger;   
	*)		         
        END_VAR
               
        METHOD PUBLIC Update 
             VAR_INPUT
                parent : IAxoObject; 

				Acquisition_Status : ARRAY[0..2] OF BYTE;
				Results_Status : BYTE;
				Soft_Event_Status : BYTE;
				Result_Data_128 : ARRAY[0..135] OF BYTE;
            END_VAR
			VAR_IN_OUT
				Acquisition_Control : BYTE;
				Results_Control : BYTE;
				//Soft_Event_Control : BYTE;
				//User_Data_128 : ARRAY[0..131] OF BYTE;
			END_VAR
			(*VAR
			   Data : CgnReader;
			END_VAR

			Data.AcquisitionStatus.TriggerReady := Acquisition_Status[0].%X0;
			Data.AcquisitionStatus.TriggerAck := Acquisition_Status[0].%X1;
			Data.AcquisitionStatus.MissedAcquisition := Acquisition_Status[0].%X3;
			Data.AcquisitionStatus.TriggerID := TO_UINT(Acquisition_Status[2]) + (UINT#256 * TO_UINT(Acquisition_Status[1]));	//TODO - najst lepsiu konverziu. 

			Data.ResultsStatus.Decoding := Results_Status.%X0;
			Data.ResultsStatus.DecodingComplete := Results_Status.%X1;
			Data.ResultsStatus.ResultsBufferOverrun := Results_Status.%X2;
			Data.ResultsStatus.ResultsAvailable := Results_Status.%X3;
			Data.ResultsStatus.Error := Results_Status.%X7;

			Data.SoftEventStatus.TrainCodeAcknowledge := Soft_Event_Status.%X0;
			Data.SoftEventStatus.TrainMatchStringAcknowledge := Soft_Event_Status.%X1;
			Data.SoftEventStatus.TrainFocusAcknowledge := Soft_Event_Status.%X2;
			Data.SoftEventStatus.TrainBrightnessAcknowledge := Soft_Event_Status.%X3;
			Data.SoftEventStatus.UntrainAcknowledge := Soft_Event_Status.%X4;
			Data.SoftEventStatus.Reserved := Soft_Event_Status.%X5;
			Data.SoftEventStatus.ExecuteDmccAcknowledge := Soft_Event_Status.%X6;
			Data.SoftEventStatus.SetMatchStringAcknowledge := Soft_Event_Status.%X7;
*)

			_AcquisitionStatus.TriggerReady := Acquisition_Status[0].%X0;
			_AcquisitionStatus.TriggerAck := Acquisition_Status[0].%X1;
			_AcquisitionStatus.MissedAcquisition := Acquisition_Status[0].%X3;
			_AcquisitionStatus.TriggerID := TO_UINT(Acquisition_Status[2]) + (UINT#256 * TO_UINT(Acquisition_Status[1]));	//TODO - najst lepsiu konverziu. 

			_ResultsStatus.Decoding := Results_Status.%X0;
			_ResultsStatus.DecodingComplete := Results_Status.%X1;
			_ResultsStatus.ResultsBufferOverrun := Results_Status.%X2;
			_ResultsStatus.ResultsAvailable := Results_Status.%X3;
			_ResultsStatus.Error := Results_Status.%X7;

			_SoftEventStatus.TrainCodeAcknowledge := Soft_Event_Status.%X0;
			_SoftEventStatus.TrainMatchStringAcknowledge := Soft_Event_Status.%X1;
			_SoftEventStatus.TrainFocusAcknowledge := Soft_Event_Status.%X2;
			_SoftEventStatus.TrainBrightnessAcknowledge := Soft_Event_Status.%X3;
			_SoftEventStatus.UntrainAcknowledge := Soft_Event_Status.%X4;
			_SoftEventStatus.Reserved := Soft_Event_Status.%X5;
			_SoftEventStatus.ExecuteDmccAcknowledge := Soft_Event_Status.%X6;
			_SoftEventStatus.SetMatchStringAcknowledge := Soft_Event_Status.%X7;

			//_AcquisitionStatus := Data.AcquisitionStatus; 
			//_ResultsStatus := Data.ResultsStatus; 
			//_SoftEventStatus := Data.SoftEventStatus; 


            THIS._isManuallyControllable := FALSE;
            
            THIS.Initialize(parent);
            Trigger.Initialize(THIS);
            Reset.Initialize(THIS);
            ReadData.Initialize(THIS);
            ClearData.Initialize(THIS);
            TrainCode.Initialize(THIS);
            TrainFocus.Initialize(THIS);
            TrainBrightness.Initialize(THIS);



            IF(Reset.Execute()) THEN

				_AcquisitionControl.TriggerEnable := false;  
				_AcquisitionControl.Trigger := false; 

                Trigger.Restore();          
				ReadData.Restore();
				ClearData.Restore();      
				
				TrainCode.Restore();
				TrainFocus.Restore();
				TrainBrightness.Restore();

                Reset.DoneWhen(TRUE);
                Reset.Restore();
            END_IF;    

            IF(Trigger.Execute()) THEN    
				_AcquisitionControl.Trigger := true;  
                Trigger.DoneWhen(true);
            END_IF;     
            IF(ReadData.Execute()) THEN   
				Deserialize(UINT#7, Result_Data_128, ReadedData);
				ReadData.DoneWhen(true);
            END_IF;   
            IF(ClearData.Execute()) THEN      
				ReadedData := '';
				_AcquisitionControl.TriggerEnable := true;  
				ClearData.DoneWhen(true);
            END_IF;      
			   
            IF(TrainCode.Execute()) THEN   
				TrainCode.DoneWhen(true);
			END_IF;   
			   
			IF(TrainFocus.Execute()) THEN  
				TrainFocus.DoneWhen(true);
			END_IF;   
			   
			IF(TrainBrightness.Execute()) THEN  
				TrainBrightness.DoneWhen(true);
			END_IF;      
			  

			Acquisition_Control.%X0 := _AcquisitionControl.TriggerEnable;
			Acquisition_Control.%X1 := _AcquisitionControl.Trigger;
			
			Results_Control.%X0 := _ResultsControl.EnableResultBuffering;
			Results_Control.%X1 := _ResultsControl.ResultsAcknowledge;
			
            
			//_ResultsControl := Data.ResultsControl; 
			//_AcquisitionControl := Data.AcquisitionControl; 

        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD

        
        METHOD PROTECTED OVERRIDE Restore : IAxoTask
            Trigger.Restore();
            Reset.Restore();     
			ReadData.Restore();
			ClearData.Restore();   

			TrainCode.Restore();
			TrainFocus.Restore();
			TrainBrightness.Restore();
				
        END_METHOD
        
    END_CLASS
END_NAMESPACE





TYPE
	CgnReader_IODATA : STRUCT
		i_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		i_Results_Status_1 : BYTE;
		i_Soft_Event_Control_1 : BYTE;
		i_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;

		q_Acquisition_Control_1 : BYTE;
		q_Results_Control_1 : BYTE;
		q_Soft_Event_Control_1 : BYTE;
		q_User_Data_128_bytes_1 : ARRAY[0..131] OF BYTE;
	END_STRUCT;

	CgnReader: STRUCT
		//Data : CgnReader_IODATA;
		AcquisitionControl : CgnReader_Acquisition_Control;
		AcquisitionStatus : CgnReader_AcquisitionStatus;
		ResultsControl : CgnReader_ResultsControl;
		ResultsStatus : CgnReader_ResultsStatus;
		SoftEventControl : CgnReader_SoftEventControl;
		SoftEventStatus : CgnReader_SoftEventStatus;
		UserData : CgnReader_UserData_128;
		Results : CgnReader_Results_128;
	END_STRUCT;

	CgnReader_Acquisition_Control : STRUCT
		TriggerEnable :	Bool;
		Trigger : Bool;
	END_STRUCT;

	CgnReader_AcquisitionStatus : STRUCT
		TriggerReady :	Bool;
		TriggerAck  :	Bool;
		MissedAcquisition :	Bool;
		TriggerID :	UInt;
	END_STRUCT;

	CgnReader_ResultsControl : STRUCT
		EnableResultBuffering	:	Bool;
		ResultsAcknowledge	:	Bool;
	END_STRUCT;

	CgnReader_ResultsStatus : STRUCT
		Decoding	:	Bool;
		DecodingComplete	:	Bool;
		ResultsBufferOverrun	:	Bool;
		ResultsAvailable	:	Bool;
		Error	:	Bool;
	END_STRUCT;

	CgnReader_SoftEventControl : STRUCT
		TrainCode	:	Bool;
		TrainMatchString	:	Bool;
		TrainFocus	:	Bool;
		TrainBrightness	:	Bool;
		Untrain	:	Bool;
		Reserved	:	Bool;
		ExecuteDmcc	:	Bool;
		SetMatchString	:	Bool;
	END_STRUCT;

	CgnReader_SoftEventStatus : STRUCT
		TrainCodeAcknowledge	:	Bool;
		TrainMatchStringAcknowledge	:	Bool;
		TrainFocusAcknowledge	:	Bool;
		TrainBrightnessAcknowledge	:	Bool;
		UntrainAcknowledge	:	Bool;
		Reserved	:	Bool;
		ExecuteDmccAcknowledge	:	Bool;
		SetMatchStringAcknowledge	:	Bool;
	END_STRUCT;
	
	CgnReader_UserData_128 : STRUCT
		UserDataOption	:UInt;
		UserDataLength:	UInt;
		DataArray	:Array[0..127] of Byte;
		DataString : STRING;
	END_STRUCT;
	
	CgnReader_Results_128 : STRUCT
		ResultID	:UInt;
		ResultCode:	UInt;
		ResultExtended:	UInt;
		ResultLength:	UInt;
		DataArray:	Array[0..127] of Byte;
		DataString : STRING;
	END_STRUCT;
	
END_TYPE
