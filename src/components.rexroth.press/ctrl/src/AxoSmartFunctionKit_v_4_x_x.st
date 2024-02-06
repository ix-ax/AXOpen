USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING System.Serialization;

NAMESPACE AXOpen.Components.Rexroth.Press
    
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoSmartFunctionKit_v_4_x_x EXTENDS AXOpen.Core.AxoComponent
        VAR PRIVATE
            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _infoTime               :   LTIME := LT#2S;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _errorTime              :   LTIME := LT#5S;
            _blink                  :   AXOpen.Timers.AxoBlinker;
            _context                :   IAxoContext;
            _hwID                   :   WORD;
            _hwIdParamCh_IDN        :   WORD;
            _hwIdInput_24_Words     :   WORD;
            _hwIdOutput_21_Words    :   WORD;
        END_VAR

        VAR PUBLIC //HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}            
            {#ix-set:AttributeName = "<#Results#>"}
            Results	: AxoSmartFunctionKitResults_v_4_x_x;
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
            RunCommandParameters : AxoSmartFunctionKitRequest_v_4_x_x;            
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
            Config  :   AxoSmartFunctionKit_Config_v_4_x_x;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            ComponentStatus     :   AxoSmartFunctionKit_ComponentStatus_v_4_x_x;
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
            Inputs              :   AxoSmartFunctionKit_State_v_4_x_x;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoSmartFunctionKit_Control_v_4_x_x;
        END_VAR    

        VAR PUBLIC //HardwareDiagnostics
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        ///<summary>
		/// Custom component logic running before any other component logic.
        ///</summary>   
        METHOD PROTECTED OVERRIDE Open
            SUPER.Open();
        END_METHOD  

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoObject; 
                hwID                :   WORD;
                hwIdParamCh_IDN     :   WORD;
                hwIdInput_24_Words  :   WORD;
                hwIdOutput_21_Words :   WORD;
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwID = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwIdParamCh_IDN = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwIdInput_24_Words = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwIdOutput_21_Words = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                ComponentStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwID = WORD#0 THEN
                ComponentStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdParamCh_IDN = WORD#0 THEN
                ComponentStatus.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdInput_24_Words = WORD#0 THEN
                ComponentStatus.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdInput_24_Words = WORD#0 THEN
                ComponentStatus.Error.Id := UINT#704;
                RETURN;
            END_IF;

            _hwID                       := hwID;
            _hwIdParamCh_IDN            := hwIdParamCh_IDN;     
            _hwIdInput_24_Words         := hwIdInput_24_Words;  
            _hwIdOutput_21_Words        := hwIdOutput_21_Words;             
    
            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD   

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoContext; 
                hwID                :   WORD;
                hwIdParamCh_IDN     :   WORD;
                hwIdInput_24_Words  :   WORD;
                hwIdOutput_21_Words :   WORD;
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwID = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwIdParamCh_IDN = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwIdInput_24_Words = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwIdOutput_21_Words = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                ComponentStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwID = WORD#0 THEN
                ComponentStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdParamCh_IDN = WORD#0 THEN
                ComponentStatus.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdInput_24_Words = WORD#0 THEN
                ComponentStatus.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdInput_24_Words = WORD#0 THEN
                ComponentStatus.Error.Id := UINT#704;
                RETURN;
            END_IF;

            _hwID                       := hwID;
            _hwIdParamCh_IDN            := hwIdParamCh_IDN;     
            _hwIdInput_24_Words         := hwIdInput_24_Words;  
            _hwIdOutput_21_Words        := hwIdOutput_21_Words;             
    
            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD 
        
        METHOD PRIVATE Execute
            VAR 
                _dword  : DWORD;
                _data10 : ARRAY[0..9] OF BYTE; 
                _data42 : ARRAY[0..41] OF BYTE; 
                _data48 : ARRAY[0..47] OF BYTE; 
                returnValue : WORD;
            END_VAR

            THIS.Open();

            //***********UPDATE**INPUTS******************
            //Parameter Channel
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdParamCh_IDN ,_data10);
            Messenger.ActivateOnCondition(ULINT#705,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                ComponentStatus.Error.Id := UINT#705;
                RETURN;
            END_IF;

            //Input 24W
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdInput_24_Words ,_data48);
            Messenger.ActivateOnCondition(ULINT#706,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                ComponentStatus.Error.Id := UINT#706;
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
            ComponentStatus.Status.ResponseStatus.AxisInReference	        :=	Inputs.NotificationStatus.%X2; 
            ComponentStatus.Status.ResponseStatus.ProgramActive	            :=	Inputs.NotificationStatus.%X3; 
            ComponentStatus.Status.ResponseStatus.LastPressingOk	        :=	Inputs.NotificationStatus.%X4; 
            ComponentStatus.Status.ResponseStatus.LastPressingNok	        :=	Inputs.NotificationStatus.%X5; 
            ComponentStatus.Status.ResponseStatus.SensorTared	            :=	Inputs.NotificationStatus.%X6; 
            ComponentStatus.Status.ResponseStatus.PressReady	            :=	Inputs.NotificationStatus.%X7; 
            ComponentStatus.Status.ResponseStatus.Error	                    :=	Inputs.NotificationStatus.%X8; 
            ComponentStatus.Status.ResponseStatus.Warning	                :=	Inputs.NotificationStatus.%X9; 
            ComponentStatus.Status.ResponseStatus.RequestPossible	        :=	Inputs.NotificationStatus.%X11;
            ComponentStatus.Status.ResponseStatus.ResponsAvialable	        :=	Inputs.NotificationStatus.%X12; 
            ComponentStatus.Status.ResponseStatus.NotificationAvailable	    :=	Inputs.NotificationStatus.%X13; 
            ComponentStatus.Status.ResponseStatus.EmergencyOffActive	    :=	Inputs.NotificationStatus.%X14; 
            ComponentStatus.Status.ResponseStatus.SafeStandstillActive	    :=	Inputs.NotificationStatus.%X15; 
            
            ComponentStatus.Status.NotificationPosition                     :=  TO_REAL(Inputs.NotificationPosition)/REAL#10000.0;
            ComponentStatus.Status.NotificationVelocity                     :=  TO_REAL(Inputs.NotificationVelocity)/REAL#10000.0;
            ComponentStatus.Status.NotificationForce                        :=  TO_REAL(Inputs.NotificationForce)/REAL#1000.0;
            ComponentStatus.Status.NotificationId                           :=  TO_UINT(Inputs.NotificationId);
            
            CASE ComponentStatus.Status.NotificationId of
                eAxoSmartFunctionKitStatusInformation_v_4_x_x#ActiveProgramNumber:
                    ComponentStatus.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation_v_4_x_x#ActiveProgramNumber;
                eAxoSmartFunctionKitStatusInformation_v_4_x_x#CurrentForce:
                    ComponentStatus.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation_v_4_x_x#CurrentForce;
                eAxoSmartFunctionKitStatusInformation_v_4_x_x#CurrentPosition:
                    ComponentStatus.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation_v_4_x_x#CurrentPosition;
                eAxoSmartFunctionKitStatusInformation_v_4_x_x#CurrentTravelSpeed:
                    ComponentStatus.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation_v_4_x_x#CurrentTravelSpeed;
                eAxoSmartFunctionKitStatusInformation_v_4_x_x#RemainingStorageSpaceOnIPC:
                    ComponentStatus.Status.NotificationToDisplay:=eAxoSmartFunctionKitStatusInformation_v_4_x_x#RemainingStorageSpaceOnIPC;
                    
            END_CASE;
            ComponentStatus.Status.DigitalIoMapping:=Inputs.DigitalIoMapping;
            //*******************************************
                 
            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            RunCommandTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);
            GetResultsTask.Initialize(THIS);
            ExportCurveTask.Initialize(THIS);
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(_hwID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************
            //*************RunCommandTask***************
            RunCommandTask.IsDisabled := FALSE;
            IF RunCommandTask.StartTriggered() THEN
                ComponentStatus.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,RunCommandTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,RunCommandTask.IsDone(), eAxoMessageCategory#Info);
            IF RunCommandTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    ComponentStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#500, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ComponentStatus.Error.Id := UINT#500;
                    END_IF;
                    Outputs.Value1 := DWORD#0;
                    Outputs.Value2 := DWORD#0;
                    Outputs.Value3 := DWORD#0;
                    Outputs.Value4 := DWORD#0;
                    Outputs.Value5 := DWORD#0;
                    Outputs.Value6 := DWORD#0;
                    Outputs.Value7 := DWORD#0;
                    CASE ComponentStatus.CurrentCommandParameters.Command OF
                        eAxoSmartFunctionKitCommand_v_4_x_x#StartProgram:
                            Serialize(UINT#0, ComponentStatus.CurrentCommandParameters.SerialNumber, _data42);

                            //todo check if the rest of the array needs to be cleaned
                            Outputs.Value1.%B0  := _data42[1];
                            Outputs.Value1.%B1  := _data42[2];
                            Outputs.Value1.%B2  := _data42[3];
                            Outputs.Value1.%B3  := _data42[4];

                            Outputs.Value2.%B0  := _data42[5];
                            Outputs.Value2.%B1  := _data42[6];
                            Outputs.Value2.%B2  := _data42[7];
                            Outputs.Value2.%B3  := _data42[8];

                            Outputs.Value3.%B0  := _data42[9];
                            Outputs.Value3.%B1  := _data42[10];
                            Outputs.Value3.%B2  := _data42[11];
                            Outputs.Value3.%B3  := _data42[12];

                            Outputs.Value4.%B0  := _data42[13];
                            Outputs.Value4.%B1  := _data42[14];
                            Outputs.Value4.%B2  := _data42[15];
                            Outputs.Value4.%B3  := _data42[16];

                            Outputs.Value5.%B0  := _data42[17];
                            Outputs.Value5.%B1  := _data42[18];
                            Outputs.Value5.%B2  := _data42[19];
                            Outputs.Value5.%B3  := _data42[20];

                            Outputs.Value6.%B0  := _data42[21];
                            Outputs.Value6.%B1  := _data42[22];
                            Outputs.Value6.%B2  := _data42[23];
                            Outputs.Value6.%B3  := _data42[24];

                            Outputs.Value7.%B0  := _data42[25];
                            Outputs.Value7.%B1  := _data42[26];
                            Outputs.Value7.%B2  := _data42[27];
                            Outputs.Value7.%B3  := _data42[28];
                        
                        eAxoSmartFunctionKitCommand_v_4_x_x#SetProgramActive:
                            Outputs.Value1:= TO_DWORD(ComponentStatus.CurrentCommandParameters.ProgramId*1000);	
                        eAxoSmartFunctionKitCommand_v_4_x_x#Positioning:
                            Outputs.Value1:= TO_DWORD(ComponentStatus.CurrentCommandParameters.PositionDistanceTara*1000);
                            Outputs.Value2:= TO_DWORD(ComponentStatus.CurrentCommandParameters.TravelSpeed*1000);	
                            Outputs.Value3:= TO_DWORD(ComponentStatus.CurrentCommandParameters.Acceleration*1000);
                        eAxoSmartFunctionKitCommand_v_4_x_x#Jog:
                            Outputs.Value1:= TO_DWORD(ComponentStatus.CurrentCommandParameters.PositionDistanceTara*1000);
                            Outputs.Value2:= TO_DWORD(ComponentStatus.CurrentCommandParameters.TravelSpeed*1000);	
                            Outputs.Value3:= TO_DWORD(ComponentStatus.CurrentCommandParameters.Acceleration*1000);
                        eAxoSmartFunctionKitCommand_v_4_x_x#Tare:
                            Outputs.Value1:= TO_DWORD(ComponentStatus.CurrentCommandParameters.Offset*1000);		
                        
                    END_CASE;
                            
                    _progress:=301;                    
                END_IF;

                IF _progress = 301 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#501, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ComponentStatus.Error.Id := UINT#501;
                    END_IF;
                    
                    Outputs.Handle:=TO_WORD(TO_INT(Inputs.Handle)+INT#1);
                    IF Outputs.Handle >WORD#1000 THEN
                        Outputs.Handle:=WORD#1;
                    END_IF;
                    _progress := 302;
                    THIS.CallTimers(FALSE);
                END_IF;

                IF _progress = 302 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#502, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ComponentStatus.Error.Id := UINT#502;
                    END_IF;
                    
                    IF Outputs.Handle=Inputs.Handle THEN
                        IF Inputs.Status=WORD#0 THEN
                            THIS.CallTimers(FALSE);
                            _progress := 303;
                        ELSE
                            ComponentStatus.Error.Id := TO_UINT(Inputs.Status);
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
                ComponentStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF RunCommandTask.DoneReached() THEN
                ComponentStatus.Action.Id :=  UINT#101;
                ComponentStatus.Error.Id :=  UINT#0;
            ELSIF RunCommandTask.ErrorOccured() THEN
                ComponentStatus.Action.Id :=  UINT#800;
                ComponentStatus.Error.Id  :=  UINT#800;
            ELSIF RunCommandTask.AbortTriggered()THEN
                ComponentStatus.Action.Id :=  UINT#801;
                ComponentStatus.Error.Id  :=  UINT#801;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#800,RunCommandTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#801,RunCommandTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,RunCommandTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF RunCommandTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                ComponentStatus.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //*******************************************
            //*************GetResultsTask***************
            GetResultsTask.IsDisabled := FALSE;
            IF ExportCurveTask.StartTriggered() THEN
                ComponentStatus.Action.Id :=  UINT#110;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#110,ExportCurveTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ExportCurveTask.IsDone(), eAxoMessageCategory#Info);
            ExportCurveTask.Execute();
            IF ExportCurveTask.DoneReached() THEN
                ComponentStatus.Action.Id :=  UINT#111;
                ComponentStatus.Error.Id :=  UINT#0;
            ELSIF ExportCurveTask.ErrorOccured() THEN
                ComponentStatus.Action.Id :=  UINT#810;
                ComponentStatus.Error.Id  :=  UINT#810;
            ELSIF ExportCurveTask.AbortTriggered()THEN
                ComponentStatus.Action.Id :=  UINT#811;
                ComponentStatus.Error.Id  :=  UINT#811;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#810,ExportCurveTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#811,ExportCurveTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,ExportCurveTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ExportCurveTask.RestoreTriggered()THEN
                ComponentStatus.Action.Id :=  UINT#112;
            END_IF;
            //*******************************************
            //*************ExportCurveTask***************
            ExportCurveTask.IsDisabled := FALSE;
            IF ExportCurveTask.StartTriggered() THEN
                ComponentStatus.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,ExportCurveTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,ExportCurveTask.IsDone(), eAxoMessageCategory#Info);
            ExportCurveTask.Execute();
            IF ExportCurveTask.DoneReached() THEN
                ComponentStatus.Action.Id :=  UINT#121;
                ComponentStatus.Error.Id :=  UINT#0;
            ELSIF ExportCurveTask.ErrorOccured() THEN
                ComponentStatus.Action.Id :=  UINT#820;
                ComponentStatus.Error.Id  :=  UINT#820;
            ELSIF ExportCurveTask.AbortTriggered()THEN
                ComponentStatus.Action.Id :=  UINT#821;
                ComponentStatus.Error.Id  :=  UINT#821;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#820,ExportCurveTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#821,ExportCurveTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,ExportCurveTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ExportCurveTask.RestoreTriggered()THEN
                ComponentStatus.Action.Id :=  UINT#122;
            END_IF;
            //*******************************************
             
            //***********UPDATE**OUTPUTS*****************
            //Parameter Channel
            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdParamCh_IDN,_data10);
            Messenger.ActivateOnCondition(ULINT#707,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                ComponentStatus.Error.Id := UINT#707;
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

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdOutput_21_Words,_data42);
            Messenger.ActivateOnCondition(ULINT#708,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                ComponentStatus.Error.Id := UINT#708;
                RETURN;
            END_IF;
            
            //*******************************************
            THIS.Close();

        END_METHOD

        
        ///<summary>
        /// This method starts the command
        ///<summary>
        METHOD PUBLIC RunCommand : IAxoTaskState
            VAR_INPUT
                Parameters : AxoSmartFunctionKitRequest_v_4_x_x;
            END_VAR
            
            ComponentStatus.CurrentCommandParameters := RunCommandParameters;            

            RunCommand    := RunCommandTask.Invoke();
        END_METHOD

        ///<summary>
        /// This method gets results
        ///<summary>
        METHOD PUBLIC GetResults : IAxoTaskState
            GetResults    := GetResultsTask.Invoke();
        END_METHOD

        ///<summary>
        /// This method exports the last curve
        ///<summary>
        METHOD PUBLIC ExportCurve : IAxoTaskState
            ExportCurve    := ExportCurveTask.Invoke();
        END_METHOD

        ///<summary>
		/// Custom component logic running after any other component logic.
        ///</summary>   
        METHOD PROTECTED OVERRIDE Close
            SUPER.Close();
        END_METHOD 

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal , Config.ErrorTime );
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            ComponentStatus.CurrentCommandParameters := RunCommandParameters;            
        END_METHOD

        METHOD PUBLIC OVERRIDE Restore
            RunCommandTask.Restore();
            ExportCurveTask.Restore();
            GetResultsTask.Restore();
            _progress := 0;
            ComponentStatus.Action.Id := UINT#50;
        END_METHOD
    
    END_CLASS
END_NAMESPACE