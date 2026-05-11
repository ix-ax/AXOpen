USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING System.Serialization;
USING Siemens.Simatic.Hardware.Utilities;

NAMESPACE AXOpen.Components.Rexroth.Press.v_4_x_x
    
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoSmartFunctionKit EXTENDS AXOpen.Core.AxoComponent
        VAR PRIVATE
            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _context                :   IAxoContext;

            _dword  : DWORD;
            _data10 : ARRAY[0..9] OF BYTE; 
            _data42 : ARRAY[0..41] OF BYTE; 
            _data48 : ARRAY[0..47] OF BYTE; 

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _blink                  :   AXOpen.Timers.AxoBlinker;   
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT;       
        END_VAR

        VAR PUBLIC //HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}            
            {#ix-set:AttributeName = "<#Results#>"}
            Results	: AxoSmartFunctionKitResults;
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;       
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Run command#>"}
            RunCommandTask : AxoTask;         
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Run command parameters#>"}
            RunCommandParameters : AxoSmartFunctionKitRequest;            
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Get results#>"}
            GetResultsTask : AxoRemoteTask;       
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Export curve#>"}
            ExportCurveTask : AxoRemoteTask;                                    
        END_VAR
        
        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoSmartFunctionKit_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoSmartFunctionKit_ComponentStatus;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
            _progress           :   INT := 0;
        END_VAR

        VAR PUBLIC //Hardware signals
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoSmartFunctionKit_State;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoSmartFunctionKit_Control;
        END_VAR    

        VAR PUBLIC //HardwareDiagnostics
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent            :   IAxoObject; 
                hwID                :   UINT;
            END_VAR

            SUPER.Run(inParent);

            Messenger.Serve(THIS);


            IF NOT _initHwCheckDone THEN
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                Config.HWIDs.HW_Device := hwID;
                IF Config.HWIDs.HW_Device = UINT#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                _retval := ReadSlotFromHardwareID(hardwareID := Config.HWIDs.HW_Device, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_ParamCh_IDN);        
                IF Config.HWIDs.HW_ParamCh_IDN = UINT#0 THEN
                    Messenger.Activate(UINT#710,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#710;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#711,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#711;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#712,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#712;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#713,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#713;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#714,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#714;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#715,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#715;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_ParamCh_IDN) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#10 OR _outputsCount <> UINT#10 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID =>  Config.HWIDs.HW_F_ModulNotUsed);        
                IF Config.HWIDs.HW_F_ModulNotUsed = UINT#0 THEN
                    Messenger.Activate(UINT#720,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#720;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#721,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#721;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#722,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#722;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#723,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#723;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#724,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#724;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#725,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#725;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_F_ModulNotUsed) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_Input_24_Words);        
                IF Config.HWIDs.HW_Input_24_Words = UINT#0 THEN
                    Messenger.Activate(UINT#730,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#730;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#731,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#731;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#732,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#732;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#733,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#733;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#734,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#734;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#735,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#735;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Input_24_Words) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#48 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_Output_21_Words);        
                IF Config.HWIDs.HW_Output_21_Words = UINT#0 THEN
                    Messenger.Activate(UINT#740,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#740;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#741,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#741;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#742,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#742;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#743,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#743;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#744,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#744;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#745,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#745;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Output_21_Words) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#42 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //*****************************************//
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_Device  = UINT#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_ParamCh_IDN  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_F_ModulNotUsed = UINT#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_Input_24_Words  = UINT#0 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;               
                IF Config.HWIDs.HW_Output_21_Words  = UINT#0 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            
            
    
            //***********************************************
            
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            RunCommandTask.Run(THIS);
            GetResultsTask.Run(THIS);
            ExportCurveTask.Run(THIS);
            TaskMessenger.Serve(THIS);
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HW_Device);
            //****************************************

            //***********UPDATE**INPUTS******************
            //Parameter Channel
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HW_ParamCh_IDN) ,_data10);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            //Input 24W
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HW_Input_24_Words) ,_data48);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            Inputs.Handle.%B0               :=  _data48[1];
            Inputs.Handle.%B1               :=  _data48[0];
            Inputs.Status.%B0               :=  _data48[3];
            Inputs.Status.%B1               :=  _data48[2];
            Inputs.Value1.%B0               :=  _data48[7];
            Inputs.Value1.%B1               :=  _data48[6];
            Inputs.Value1.%B2               :=  _data48[5];
            Inputs.Value1.%B3               :=  _data48[4];
            Inputs.Value2.%B0               :=  _data48[11];
            Inputs.Value2.%B1               :=  _data48[10];
            Inputs.Value2.%B2               :=  _data48[9];
            Inputs.Value2.%B3               :=  _data48[8];
            Inputs.Value3.%B0               :=  _data48[15];
            Inputs.Value3.%B1               :=  _data48[14];
            Inputs.Value3.%B2               :=  _data48[13];
            Inputs.Value3.%B3               :=  _data48[12];
            Inputs.NotificationId.%B0       :=  _data48[17];
            Inputs.NotificationId.%B1       :=  _data48[16];
            Inputs.NotificationValue.%B0    :=  _data48[21];
            Inputs.NotificationValue.%B1    :=  _data48[20];
            Inputs.NotificationValue.%B2    :=  _data48[19];
            Inputs.NotificationValue.%B3    :=  _data48[18];
            Inputs.NotificationStatus.%B0   :=  _data48[23];
            Inputs.NotificationStatus.%B1   :=  _data48[22];
            Inputs.NotificationPosition.%B0 :=  _data48[27];
            Inputs.NotificationPosition.%B1 :=  _data48[26];
            Inputs.NotificationPosition.%B2 :=  _data48[25];
            Inputs.NotificationPosition.%B3 :=  _data48[24];
            Inputs.NotificationVelocity.%B0 :=  _data48[31];
            Inputs.NotificationVelocity.%B1 :=  _data48[30];
            Inputs.NotificationVelocity.%B2 :=  _data48[29];
            Inputs.NotificationVelocity.%B3 :=  _data48[28];
            Inputs.NotificationForce.%B0    :=  _data48[35];
            Inputs.NotificationForce.%B1    :=  _data48[34];
            Inputs.NotificationForce.%B2    :=  _data48[33];
            Inputs.NotificationForce.%B3    :=  _data48[32];
            Inputs.DigitalIoMapping.%B0     :=  _data48[37];
            Inputs.DigitalIoMapping.%B1     :=  _data48[36];
            Inputs.VirtualIo.%B0            :=  _data48[39];
            Inputs.VirtualIo.%B1            :=  _data48[38];
            Inputs.FastVarState.%B0         :=  _data48[43];
            Inputs.FastVarState.%B1         :=  _data48[42];
            Inputs.FastVarState.%B2         :=  _data48[41];
            Inputs.FastVarState.%B3         :=  _data48[40];
            Inputs.FastVarData.%B0          :=  _data48[47];
            Inputs.FastVarData.%B1          :=  _data48[46];
            Inputs.FastVarData.%B2          :=  _data48[45];
            Inputs.FastVarData.%B3          :=  _data48[44];
            //*******************************************

            //***********UPDATE**STATUS******************
            Status.Status.ResponseStatus.AxisInReference	        :=	Inputs.NotificationStatus.%X2; 
            Status.Status.ResponseStatus.ProgramActive	            :=	Inputs.NotificationStatus.%X3; 
            Status.Status.ResponseStatus.LastPressingOk	            :=	Inputs.NotificationStatus.%X4; 
            Status.Status.ResponseStatus.LastPressingNok	        :=	Inputs.NotificationStatus.%X5; 
            Status.Status.ResponseStatus.SensorTared	            :=	Inputs.NotificationStatus.%X6; 
            Status.Status.ResponseStatus.PressReady	                :=	Inputs.NotificationStatus.%X7; 
            Status.Status.ResponseStatus.Error	                    :=	Inputs.NotificationStatus.%X8; 
            Status.Status.ResponseStatus.Warning	                :=	Inputs.NotificationStatus.%X9; 
            Status.Status.ResponseStatus.RequestPossible	        :=	Inputs.NotificationStatus.%X11;
            Status.Status.ResponseStatus.ResponsAvialable	        :=	Inputs.NotificationStatus.%X12; 
            Status.Status.ResponseStatus.NotificationAvailable	    :=	Inputs.NotificationStatus.%X13; 
            Status.Status.ResponseStatus.EmergencyOffActive	        :=	Inputs.NotificationStatus.%X14; 
            Status.Status.ResponseStatus.SafeStandstillActive	    :=	Inputs.NotificationStatus.%X15; 
            
            Status.Status.NotificationPosition                     :=  TO_REAL(Inputs.NotificationPosition)/REAL#10000.0;
            Status.Status.NotificationVelocity                     :=  TO_REAL(Inputs.NotificationVelocity)/REAL#10000.0;
            Status.Status.NotificationForce                        :=  TO_REAL(Inputs.NotificationForce)/REAL#1000.0;
            Status.Status.NotificationId                           :=  TO_UINT(Inputs.NotificationId);
            
            CASE Status.Status.NotificationId of
                eAxoSmartFunctionKitStatusInformation#ActiveProgramNumber:
                    Status.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation#ActiveProgramNumber;
                eAxoSmartFunctionKitStatusInformation#CurrentForce:
                    Status.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation#CurrentForce;
                eAxoSmartFunctionKitStatusInformation#CurrentPosition:
                    Status.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation#CurrentPosition;
                eAxoSmartFunctionKitStatusInformation#CurrentTravelSpeed:
                    Status.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation#CurrentTravelSpeed;
                eAxoSmartFunctionKitStatusInformation#RemainingStorageSpaceOnIPC:
                    Status.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation#RemainingStorageSpaceOnIPC;
                    
            END_CASE;
            Status.Status.DigitalIoMapping:=Inputs.DigitalIoMapping;
            //*******************************************
                

            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
            //*************RunCommandTask***************
            RunCommandTask.SetIsDisabled(FALSE);
            IF RunCommandTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,RunCommandTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,RunCommandTask.IsDone(), eAxoMessageCategory#Info);
            IF RunCommandTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN  
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
                    Outputs.Value1 := DWORD#0;
                    Outputs.Value2 := DWORD#0;
                    Outputs.Value3 := DWORD#0;
                    Outputs.Value4 := DWORD#0;
                    Outputs.Value5 := DWORD#0;
                    Outputs.Value6 := DWORD#0;
                    Outputs.Value7 := DWORD#0;
                    CASE Status.CurrentCommandParameters.Command OF
                        eAxoSmartFunctionKitCommand#StartProgram:
                            Serialize(UINT#0, Status.CurrentCommandParameters.SerialNumber, _data42);

                            //todo check if the rest of the array needs to be cleaned
                            Outputs.Value1.%B0  := _data42[4];
                            Outputs.Value1.%B1  := _data42[3];
                            Outputs.Value1.%B2  := _data42[2];
                            Outputs.Value1.%B3  := _data42[1];

                            Outputs.Value2.%B0  := _data42[8];
                            Outputs.Value2.%B1  := _data42[7];
                            Outputs.Value2.%B2  := _data42[6];
                            Outputs.Value2.%B3  := _data42[5];

                            Outputs.Value3.%B0  := _data42[12];
                            Outputs.Value3.%B1  := _data42[11];
                            Outputs.Value3.%B2  := _data42[10];
                            Outputs.Value3.%B3  := _data42[9];

                            Outputs.Value4.%B0  := _data42[16];
                            Outputs.Value4.%B1  := _data42[15];
                            Outputs.Value4.%B2  := _data42[14];
                            Outputs.Value4.%B3  := _data42[13];

                            Outputs.Value5.%B0  := _data42[20];
                            Outputs.Value5.%B1  := _data42[19];
                            Outputs.Value5.%B2  := _data42[18];
                            Outputs.Value5.%B3  := _data42[17];

                            Outputs.Value6.%B0  := _data42[24];
                            Outputs.Value6.%B1  := _data42[23];
                            Outputs.Value6.%B2  := _data42[22];
                            Outputs.Value6.%B3  := _data42[21];

                            Outputs.Value7.%B0  := _data42[28];
                            Outputs.Value7.%B1  := _data42[27];
                            Outputs.Value7.%B2  := _data42[26];
                            Outputs.Value7.%B3  := _data42[25];
                        
                        eAxoSmartFunctionKitCommand#SetProgramActive:
                            Outputs.Value1:= TO_DWORD(Status.CurrentCommandParameters.ProgramId*1000);	
                        eAxoSmartFunctionKitCommand#Positioning:
                            Outputs.Value1:= TO_DWORD(Status.CurrentCommandParameters.PositionDistanceTara*1000);
                            Outputs.Value2:= TO_DWORD(Status.CurrentCommandParameters.TravelSpeed*1000);	
                            Outputs.Value3:= TO_DWORD(Status.CurrentCommandParameters.Acceleration*1000);
                        eAxoSmartFunctionKitCommand#Jog:
                            Outputs.Value1:= TO_DWORD(Status.CurrentCommandParameters.PositionDistanceTara*1000);
                            Outputs.Value2:= TO_DWORD(Status.CurrentCommandParameters.TravelSpeed*1000);	
                            Outputs.Value3:= TO_DWORD(Status.CurrentCommandParameters.Acceleration*1000);
                        eAxoSmartFunctionKitCommand#Tare:
                            Outputs.Value1:= TO_DWORD(Status.CurrentCommandParameters.Offset*1000);		
                    END_CASE;
                    Outputs.Command     := TO_WORD(Status.CurrentCommandParameters.Command);
                    IF Status.Status.ResponseStatus.RequestPossible THEN
                        _progress:=301;   
                    END_IF;                 
                END_IF;

                IF _progress = 301 THEN  
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
                    
                    Outputs.Handle:=TO_WORD(TO_INT(Inputs.Handle)+INT#1);
                    IF Outputs.Handle >WORD#1000 THEN
                        Outputs.Handle:=WORD#1;
                    END_IF;
                    _progress := 302;
                    THIS.CallTimers(FALSE);
                END_IF;

                IF _progress = 302 THEN  
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#502;
                    END_IF;
                    
                    IF Outputs.Handle=Inputs.Handle THEN
                        IF Inputs.Status=WORD#0 THEN
                            THIS.CallTimers(FALSE);
                            _progress := 303;
                        ELSE
                            Status.Error.Id := TO_UINT(Inputs.Status);
                            RunCommandTask.ThrowWhen(TRUE);
                        END_IF;
                    END_IF;
                END_IF;

                IF _progress = 303 THEN  
                    RunCommandTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                THIS.CallTimers(TRUE);
                RunCommandTask.ThrowWhen(_errorTimer.output );
                Status.Action.Id := TO_UINT(_progress);
                RunCommandTask.ThrowWhen(RunCommandTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#RunCommandTask timeout.#>');                
            END_IF;
            IF RunCommandTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF RunCommandTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#2000;
                Status.Error.Id  :=  UINT#2000;
            ELSIF RunCommandTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#2001;
                Status.Error.Id  :=  UINT#2001;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#2000,RunCommandTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#2001,RunCommandTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#102,RunCommandTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF RunCommandTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            TaskMessenger.ActivateOnCondition(TO_ULINT(Inputs.Status), Inputs.Status>WORD#0, eAxoMessageCategory#Error);
            //*******************************************
            //*************GetResultsTask***************
            GetResultsTask.SetIsDisabled(Config.IpAddress = '');
            IF GetResultsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#110,GetResultsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,GetResultsTask.IsDone(), eAxoMessageCategory#Info);
            GetResultsTask.Execute(THIS);
            IF GetResultsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF GetResultsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#2010;
                Status.Error.Id  :=  UINT#2010;
            ELSIF GetResultsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#2011;
                Status.Error.Id  :=  UINT#2011;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#2010,GetResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#2011,GetResultsTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#112,GetResultsTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF GetResultsTask.RestoreTriggered()THEN
                Status.Action.Id :=  UINT#112;
            END_IF;
            //*******************************************
            //*************ExportCurveTask***************
            ExportCurveTask.SetIsDisabled(Config.IpAddress = '' OR Config.CurveExportLocation = '');
            IF ExportCurveTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,ExportCurveTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,ExportCurveTask.IsDone(), eAxoMessageCategory#Info);
            ExportCurveTask.Execute(THIS);
            IF ExportCurveTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF ExportCurveTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#2020;
                Status.Error.Id  :=  UINT#2020;
            ELSIF ExportCurveTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#2021;
                Status.Error.Id  :=  UINT#2021;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#2020,ExportCurveTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#2021,ExportCurveTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#122,ExportCurveTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ExportCurveTask.RestoreTriggered()THEN
                Status.Action.Id :=  UINT#122;
            END_IF;
            //*******************************************
             
            //***********UPDATE**OUTPUTS*****************
            //Parameter Channel
            _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HW_ParamCh_IDN),_data10);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;       

            //Output 21W
            _data42[0]          :=      Outputs.Handle.%B1;
            _data42[1]          :=      Outputs.Handle.%B0;
            _data42[2]          :=      Outputs.Command.%B1;
            _data42[3]          :=      Outputs.Command.%B0;
            _data42[4]          :=      Outputs.Value1.%B3;
            _data42[5]          :=      Outputs.Value1.%B2;
            _data42[6]          :=      Outputs.Value1.%B1;
            _data42[7]          :=      Outputs.Value1.%B0;
            _data42[8]          :=      Outputs.Value2.%B3;
            _data42[9]          :=      Outputs.Value2.%B2;
            _data42[10]         :=      Outputs.Value2.%B1;
            _data42[11]         :=      Outputs.Value2.%B0;
            _data42[12]         :=      Outputs.Value3.%B3;
            _data42[13]         :=      Outputs.Value3.%B2;
            _data42[14]         :=      Outputs.Value3.%B1;
            _data42[15]         :=      Outputs.Value3.%B0;
            _data42[16]         :=      Outputs.Value4.%B3;
            _data42[17]         :=      Outputs.Value4.%B2;
            _data42[18]         :=      Outputs.Value4.%B1;
            _data42[19]         :=      Outputs.Value4.%B0;
            _data42[20]         :=      Outputs.Value5.%B3;
            _data42[21]         :=      Outputs.Value5.%B2;
            _data42[22]         :=      Outputs.Value5.%B1;
            _data42[23]         :=      Outputs.Value5.%B0;
            _data42[24]         :=      Outputs.Value6.%B3;
            _data42[25]         :=      Outputs.Value6.%B2;
            _data42[26]         :=      Outputs.Value6.%B1;
            _data42[27]         :=      Outputs.Value6.%B0;
            _data42[28]         :=      Outputs.Value7.%B3;
            _data42[29]         :=      Outputs.Value7.%B2;
            _data42[30]         :=      Outputs.Value7.%B1;
            _data42[31]         :=      Outputs.Value7.%B0;
            _data42[32]         :=      Outputs.VirtualIo.%B1;
            _data42[33]         :=      Outputs.VirtualIo.%B0;
            _data42[34]         :=      Outputs.FastVarControl.%B3;
            _data42[35]         :=      Outputs.FastVarControl.%B2;
            _data42[36]         :=      Outputs.FastVarControl.%B1;
            _data42[37]         :=      Outputs.FastVarControl.%B0;
            _data42[38]         :=      Outputs.FastVarData.%B3;
            _data42[39]         :=      Outputs.FastVarData.%B2;
            _data42[40]         :=      Outputs.FastVarData.%B1;
            _data42[41]         :=      Outputs.FastVarData.%B0;

            _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HW_Output_21_Words),_data42);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1232, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1232;
                RETURN;
            END_IF;       
            
            //*******************************************
 
        END_METHOD   

        
        ///<summary>
        /// This method starts the command
        ///<summary>
        METHOD PUBLIC RunCommand : IAxoTaskState
            VAR_INPUT
                Parameters : REF_TO AxoSmartFunctionKitRequest;
            END_VAR

            IF Parameters = NULL THEN
                Messenger.Activate(         UINT#1400, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1400;
                RETURN;
            END_IF;

            Status.CurrentCommandParameters := Parameters^;            

            RunCommand    := RunCommandTask.Invoke(THIS);
        END_METHOD

        ///<summary>
        /// This method gets results
        ///<summary>
        METHOD PUBLIC GetResults : IAxoTaskState
            GetResults    := GetResultsTask.Invoke(THIS);
        END_METHOD

        ///<summary>
        /// This method exports the last curve
        ///<summary>
        METHOD PUBLIC ExportCurve : IAxoTaskState
            ExportCurve    := ExportCurveTask.Invoke(THIS);
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > LT#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > LT#0S , Config.ErrorTime);
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            Status.CurrentCommandParameters := RunCommandParameters;            
        END_METHOD

        METHOD PUBLIC OVERRIDE Restore
            RunCommandTask.Restore();
            ExportCurveTask.Restore();
            GetResultsTask.Restore();
            RestoreTask.DoneWhen(TRUE);
            _progress := 0;
            Status.Action.Id := UINT#50;
        END_METHOD
    
    END_CLASS
END_NAMESPACE



