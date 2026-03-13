USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;
USING Siemens.Simatic.CommunicationsProcessor.PointToPoint;

NAMESPACE AXOpen.Components.Siem.Communication
    {S7.extern=ReadWrite}
    CLASS AxoCmPtp EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#SendDataTask#>"}
            SendDataTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Send data length#>"}
            SendDataLength : UINT;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Data to send#>"}
            DataToSend : AxoCmPtp_Data;

            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Receive data length#>"}
            ReceiveDataLength : UINT;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Received data#>"}
            ReceivedData : AxoCmPtp_Data;

            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            Progress       :   INT;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Set port config#>"}
            PortConfigTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Receive reset#>"}
            ReceiveResetTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoCmPtp_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoCmPtp_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  AxoCmPtp_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoCmPtp_Out;
        END_VAR    

        VAR PUBLIC // HARDWARE DIAGNOSTICS TASK
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PRIVATE
            _progress           :   INT;
            _infoTimer          :   AXOpen.Timers.OnDelayTimer;
            _errorTimer         :   AXOpen.Timers.OnDelayTimer;
            _data_in            :   ARRAY[0..254] OF BYTE;
            _data_out_1         :   ARRAY[0..0] OF BYTE;
            _data_out_2         :   ARRAY[0..1] OF BYTE;
            _data_out_4         :   ARRAY[0..3] OF BYTE;
            _data_out_8         :   ARRAY[0..7] OF BYTE;
            _data_out_255       :   ARRAY[0..254] OF BYTE;
            _word               :   WORD;
            _dword              :   DWORD;

            _initHwCheckDone    :   BOOL;
            _initHwCheckDonePV  :   BOOL;
            _retval             :   WORD;
            _geoAddr            :   GeoAddr;
            _outHwid            :   UINT;
            _blink              :   AXOpen.Timers.AxoBlinker;   
            _inputsAddress      :   UDINT;   
            _inputsCount        :   UINT;
            _outputsAddress     :   UDINT;  
            _outputsCount       :   UINT; 
            _portConfig         :   PortConfig;
            _receiveReset       :   ReceiveReset;
            _sendP2P            :   SendP2P;
            _receiveP2P         :   ReceiveP2P;

            _portConfigRequest  :   BOOL;
            _receiveResetRequest:   BOOL;
            _sendP2PRequest     :   BOOL;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent      :   IAxoObject;
                hwID        :   UINT;
            END_VAR

            SUPER.Run(parent);

            Messenger.Serve(THIS);
            
            Progress := _progress;

            IF NOT _initHwCheckDone THEN
                IF parent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                IF hwID = UINT#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                _retval := ReadSlotFromHardwareID(hardwareID := hwID, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                ReadHardwareIOAddress(hardwareID := (hwID) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;

                IF parent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF hwID  = UINT#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            
            //****************************************

            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            PortConfigTask.Run(THIS);
            ReceiveResetTask.Run(THIS);
            SendDataTask.Run(THIS);

            //****************************************
            IF _initHwCheckDone AND NOT _initHwCheckDonePV THEN
                PortConfigTask.Invoke();
            END_IF;

            _initHwCheckDonePV := _initHwCheckDone;
          
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,hwid);
            //****************************************
    
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
    
            //*************PortConfigTask*************
            _portConfig(request         :=  _portConfigRequest,
                        hardwareID      :=  hwID,
                        protocol        :=  Config.PortConfig.Protocol,
                        baud            :=  Config.PortConfig.BaudRate,
                        parity          :=  Config.PortConfig.Parity,
                        dataBits        :=  Config.PortConfig.DataBits,
                        stopBits        :=  Config.PortConfig.StopBits,
                        flowControl     :=  Config.PortConfig.FlowControl,
                        xonChar         :=  Config.PortConfig.XonChar,
                        xoffChar        :=  Config.PortConfig.XoffChar,
                        waitTime        :=  Config.PortConfig.WaitTime,
                        mode            :=  Config.PortConfig.Mode,
                        linePreset      :=  Config.PortConfig.LinePreset,
                        breakDetection  :=  Config.PortConfig.BreakDetection);

            PortConfigTask.SetIsDisabled(FALSE);
            IF PortConfigTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,PortConfigTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,PortConfigTask.IsDone(), eAxoMessageCategory#Info);
            IF PortConfigTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                // PortConfigTask running: waiting for '_portConfig.done' to be on.
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#500;
                    END_IF;

                    _portConfigRequest := TRUE;

                    IF _portConfig.done AND NOT _portConfig.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;

                    IF  _portConfig.error THEN 
                        TaskMessenger.Activate( TO_UINT(_portConfig.status), eAxoMessageCategory#Error);
                        Status.Error.Id :=      TO_UINT(_portConfig.status);
                        PortConfigTask.ThrowWhen(TRUE,'<#PortConfigTask error.#>');
                    END_IF;
                END_IF;
                // PortConfigTask running: waiting for '_portConfig.done' to be off.
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#501;
                    END_IF;

                    _portConfigRequest := FALSE;

                    IF NOT _portConfig.done THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                // PortConfigTask finished.
                IF _progress = 302 THEN  
                    PortConfigTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                PortConfigTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                PortConfigTask.ThrowWhen(PortConfigTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#PortConfigTask timeout.#>');                
            END_IF;
            IF PortConfigTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF PortConfigTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF PortConfigTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,PortConfigTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,PortConfigTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#102,PortConfigTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF PortConfigTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //********************************************
    
            //*************ReceiveResetTask***************
            _receiveReset(request := _receiveResetRequest,hardwareID := hwID);
            ReceiveResetTask.SetIsDisabled(FALSE);
            IF ReceiveResetTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,ReceiveResetTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ReceiveResetTask.IsDone(), eAxoMessageCategory#Info);
            IF ReceiveResetTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
                // ReceiveResetTask running: waiting for '_receiveReset.done' to be on. 
                IF _progress = 310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#510;
                    END_IF;

                    _receiveResetRequest := TRUE;
    
                    IF _receiveReset.done AND NOT _receiveReset.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                    IF _receiveReset.error THEN
                        TaskMessenger.Activate( TO_UINT(_receiveReset.status), eAxoMessageCategory#Error);
                        Status.Error.Id :=      TO_UINT(_receiveReset.status);
                        ReceiveResetTask.ThrowWhen(TRUE,'<#ReceiveResetTask error.#>');
                    END_IF;
                END_IF;
                // ReceiveResetTask running:waiting for '_receiveReset.done' to be off. 
                IF _progress = 311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#511;
                    END_IF;
    
                    _receiveResetRequest := FALSE;

                    IF NOT _receiveReset.done THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                // ReceiveResetTask finished.
                IF _progress = 312 THEN
                    ReceiveResetTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ReceiveResetTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ReceiveResetTask.ThrowWhen(ReceiveResetTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ReceiveResetTask timeout.#>');                
            END_IF;
            IF ReceiveResetTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF ReceiveResetTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF ReceiveResetTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,ReceiveResetTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,ReceiveResetTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#112,ReceiveResetTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ReceiveResetTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //****************************************
    
            //*************SendDataTask***************
            _sendP2P(   request     := _sendP2PRequest,
            hardwareID  :=  hwID,
            length      :=  SendDataLength,
            buffer      :=  DataToSend.Data);

            SendDataTask.SetIsDisabled(FALSE);
            IF SendDataTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,SendDataTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,SendDataTask.IsDone(), eAxoMessageCategory#Info);
            IF SendDataTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
                // SendDataTask running: waiting for '_sendP2P.done' to be on.  
                IF _progress = 320 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#520;
                    END_IF;

                    _sendP2PRequest := TRUE;

                    IF _sendP2P.done AND NOT _sendP2P.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                    IF _sendP2P.error THEN
                        TaskMessenger.Activate( TO_UINT(_sendP2P.status), eAxoMessageCategory#Error);
                        Status.Error.Id :=      TO_UINT(_sendP2P.status);
                        SendDataTask.ThrowWhen(TRUE,'<#SendDataTask error.#>');
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for '_sendP2P.done' to be off. 
                IF _progress = 321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#521;
                    END_IF;
    
                    _sendP2PRequest := FALSE;

                    IF NOT _sendP2P.done THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                // SendDataTask finished.
                IF _progress = 322 THEN
                    SendDataTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                SendDataTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                SendDataTask.ThrowWhen(SendDataTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#SendDataTask timeout.#>');                
            END_IF;
            IF SendDataTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF SendDataTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF SendDataTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10020,SendDataTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,SendDataTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#122,SendDataTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF SendDataTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //*******************************************
    
            //*************Receive***********************
            _receiveP2P(hardwareID := hwID, buffer := ReceivedData.Data);
            IF _receiveP2P.newDataReceived THEN
                ReceivedData.ToggleDataChangedFlag();
                ReceiveDataLength := _receiveP2P.length;
            END_IF;
            //*******************************************
        END_METHOD

        METHOD PUBLIC PortConfig : IAxoTaskState
            VAR_INPUT
                Protocol        :   eAxoCmPtp_Protocol := eAxoCmPtp_Protocol#Freeport;
                BaudRate        :   eAxoCmPtp_Baud := eAxoCmPtp_Baud#_9600;
                Parity          :   eAxoCmPtp_Parity := eAxoCmPtp_Parity#NoParity;
                DataBits        :   eAxoCmPtp_DataBits := eAxoCmPtp_DataBits#_8dataBits;
                StopBits        :   eAxoCmPtp_StopBits := eAxoCmPtp_StopBits#_1stopBits;
                FlowControl     :   eAxoCmPtp_FlowControl := eAxoCmPtp_FlowControl#NoFlowControl;
                XonChar         :   CHAR;
                XoffChar	    :   CHAR;
                WaitTime	    :   UINT;
                Mode            :   eAxoCmPtp_Mode := eAxoCmPtp_Mode#FullDuplexRS232; 
                LinePreset      :   eAxoCmPtp_LinePreset := eAxoCmPtp_LinePreset#NoInitialState;
                BreakDetection  :   eAxoCmPtp_BreakDetection := eAxoCmPtp_BreakDetection#deactivated;
            END_VAR
            Config.PortConfig.Protocol          :=  Protocol;
            Config.PortConfig.BaudRate          :=  BaudRate;
            Config.PortConfig.Parity            :=  Parity;
            Config.PortConfig.DataBits          :=  DataBits;
            Config.PortConfig.StopBits          :=  StopBits;
            Config.PortConfig.FlowControl       :=  FlowControl;
            Config.PortConfig.XonChar           :=  XonChar;
            Config.PortConfig.XoffChar          :=  XoffChar;
            Config.PortConfig.WaitTime          :=  WaitTime;
            Config.PortConfig.Mode              :=  Mode;
            Config.PortConfig.LinePreset        :=  LinePreset;
            Config.PortConfig.BreakDetection    :=  BreakDetection;
            PortConfig := PortConfigTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ReceiveReset : IAxoTaskState
            VAR
                i   :   INT;
            END_VAR
            FOR i := 0 TO 1023 DO
                ReceivedData.Data[i] := BYTE#0;
            END_FOR;
            ReceivedData.ToggleDataChangedFlag();
            ReceiveReset := ReceiveResetTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC SendData : IAxoTaskState
            VAR_IN_OUT
                Data : AxoCmPtp_Data;
            END_VAR
            DataToSend  :=  Data;
            SendData := SendDataTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC NewDataReceived : BOOL
            NewDataReceived := _receiveP2P.newDataReceived;
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            VAR
                _index : INT;
            END_VAR
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;

            _progress       :=   INT#0;
            _retVal    :=   WORD#0;

            _data_out_1[0] := BYTE#0;
            _data_out_2[0] := BYTE#0;
            _data_out_2[1] := BYTE#0;

            FOR _index := 0 TO 3 DO
                _data_in[_index] := BYTE#0;
                _data_out_4[_index] := BYTE#0;
                _data_out_8[_index] := BYTE#0;
                _data_out_255[_index] := BYTE#0;
            END_FOR;

            FOR _index := 4 TO 7 DO
                _data_in[_index] := BYTE#0;
                _data_out_8[_index] := BYTE#0;
                _data_out_255[_index] := BYTE#0;
            END_FOR;

            FOR _index := 8 TO 254 DO
                _data_in[_index] := BYTE#0;
                _data_out_255[_index] := BYTE#0;
            END_FOR;

            _word           :=   WORD#0;
            _dword          :=   DWORD#0;


            PortConfigTask.Restore();
            ReceiveResetTask.Restore();
            SendDataTask.Restore();
            HardwareDiagnosticsTask.Restore();

            Status.Action.Id := UINT#50;
            RestoreTask.DoneWhen(TRUE);

        END_METHOD        

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > T#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > T#0S , Config.ErrorTime);

        END_METHOD

    END_CLASS
END_NAMESPACE

