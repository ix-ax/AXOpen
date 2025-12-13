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

        VAR PUBLIC // TEMPLATE TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_4#>"}
            TemplateTask_10steps_4 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_5#>"}
            TemplateTask_10steps_5 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_6#>"}
            TemplateTask_10steps_6 : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_1#>"}
            TemplateTask_20steps_1 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_2#>"}
            TemplateTask_20steps_2 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_3#>"}
            TemplateTask_20steps_3 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_4#>"}
            TemplateTask_20steps_4 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_5#>"}
            TemplateTask_20steps_5 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_6#>"}
            TemplateTask_20steps_6 : AXOpen.Core.AxoTask;
            
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
            TemplateTask_10steps_4.Run(THIS);
            TemplateTask_10steps_5.Run(THIS);
            TemplateTask_10steps_6.Run(THIS);
            TemplateTask_20steps_1.Run(THIS);
            TemplateTask_20steps_2.Run(THIS);
            TemplateTask_20steps_3.Run(THIS);
            TemplateTask_20steps_4.Run(THIS);
            TemplateTask_20steps_5.Run(THIS);
            TemplateTask_20steps_6.Run(THIS);
    
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
    
                IF _progress = 300 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
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
    
                IF _progress = 301 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;

                    _portConfigRequest := FALSE;

                    IF NOT _portConfig.done THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#503;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                
                IF _progress = 304 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#504;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                
                IF _progress = 305 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#505;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                
                IF _progress = 306 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#506, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#506;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 307;
                    END_IF;
                END_IF;
                
                IF _progress = 307 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#507, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#507;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 308;
                    END_IF;
                END_IF;
                
                IF _progress = 308 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#508, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#508;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 309;
                    END_IF;
                END_IF;
                
                IF _progress = 309 THEN                                                                                     // PortConfigTask running: , add_the_detailed_description_of_the_current_action_10
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
            Messenger.ActivateOnCondition(ULINT#10001,PortConfigTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,PortConfigTask.RestoreTriggered() , eAxoMessageCategory#Error);
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
    
                IF _progress = 310 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
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
    
                IF _progress = 311 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;
    
                    _receiveResetRequest := FALSE;

                    IF NOT _receiveReset.done THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#514;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#515;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#516;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;
                
                IF _progress = 317 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#517;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;
                
                IF _progress = 318 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#518;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 319;
                    END_IF;
                END_IF;
                
                IF _progress = 319 THEN                                                                                     // ReceiveResetTask running: , add_the_detailed_description_of_the_current_action_10
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
            Messenger.ActivateOnCondition(ULINT#10011,ReceiveResetTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,ReceiveResetTask.RestoreTriggered() , eAxoMessageCategory#Error);
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
    
                IF _progress = 320 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
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
    
                IF _progress = 321 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;
    
                    _sendP2PRequest := FALSE;

                    IF NOT _sendP2P.done THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                
                IF _progress = 322 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#522;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                
                IF _progress = 323 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#523;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                
                IF _progress = 324 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#524;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#526;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
                
                IF _progress = 327 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#527;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    END_IF;
                END_IF;
                
                IF _progress = 328 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#528, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#528;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 329;
                    END_IF;
                END_IF;
                
                IF _progress = 329 THEN                                                                                     // SendDataTask running: , add_the_detailed_description_of_the_current_action_10
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
            Messenger.ActivateOnCondition(ULINT#10021,SendDataTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,SendDataTask.RestoreTriggered() , eAxoMessageCategory#Error);
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

            //*************TemplateTask_10steps_4***************
            TemplateTask_10steps_4.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_4.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#130,TemplateTask_10steps_4.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,TemplateTask_10steps_4.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_4.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
    
                IF _progress = 330 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#530;
                    END_IF;

    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
    
                IF _progress = 331 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#531;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#532;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;
                
                IF _progress = 333 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#533, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#533;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#534, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#534;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 335 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#535, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#535;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#536, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#536;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 337;
                    END_IF;
                END_IF;
                
                IF _progress = 337 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#537, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#537;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 338;
                    END_IF;
                END_IF;
                
                IF _progress = 338 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#538, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#538;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 339;
                    END_IF;
                END_IF;
                
                IF _progress = 339 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_10
                    TemplateTask_10steps_4.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_4.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_4.ThrowWhen(TemplateTask_10steps_4.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_10steps_4 timeout.#>');                
            END_IF;
            IF TemplateTask_10steps_4.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_4.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10030;
                Status.Error.Id  :=  UINT#10030;
            ELSIF TemplateTask_10steps_4.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10031;
                Status.Error.Id  :=  UINT#10031;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10030,TemplateTask_10steps_4.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10031,TemplateTask_10steps_4.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,TemplateTask_10steps_4.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_4.RestoreTriggered() AND _progress >= 330 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_5***************
            TemplateTask_10steps_5.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_5.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#140,TemplateTask_10steps_5.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,TemplateTask_10steps_5.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_5.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
    
                IF _progress = 340 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#540;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;
    
                IF _progress = 341 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#541;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#542;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#543, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#543;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#544, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#544;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    END_IF;
                END_IF;
                
                IF _progress = 345 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#545, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#545;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 346;
                    END_IF;
                END_IF;
                
                IF _progress = 346 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#546, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#546;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 347;
                    END_IF;
                END_IF;
                
                IF _progress = 347 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#547, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#547;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 348;
                    END_IF;
                END_IF;
                
                IF _progress = 348 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#548, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#548;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 349;
                    END_IF;
                END_IF;
                
                IF _progress = 349 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_10
                    TemplateTask_10steps_5.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_5.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_5.ThrowWhen(TemplateTask_10steps_5.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_10steps_5 timeout.#>');                
            END_IF;
            IF TemplateTask_10steps_5.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_5.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10040;
                Status.Error.Id  :=  UINT#10040;
            ELSIF TemplateTask_10steps_5.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10041;
                Status.Error.Id  :=  UINT#10041;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10040,TemplateTask_10steps_5.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10041,TemplateTask_10steps_5.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,TemplateTask_10steps_5.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_5.RestoreTriggered() AND _progress >= 340 AND _progress <= 349  THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_6***************
            TemplateTask_10steps_6.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_6.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#150,TemplateTask_10steps_6.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,TemplateTask_10steps_6.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_6.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;
    
                IF _progress = 350 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#550;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
    
                IF _progress = 351 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#551, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#551;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 352;
                    END_IF;
                END_IF;
                
                IF _progress = 352 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#552, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#552;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 353;
                    END_IF;
                END_IF;
                
                IF _progress = 353 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#553, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#553;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 354;
                    END_IF;
                END_IF;
                
                IF _progress = 354 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#554, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#554;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 355;
                    END_IF;
                END_IF;
                
                IF _progress = 355 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#555, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#555;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 356;
                    END_IF;
                END_IF;
                
                IF _progress = 356 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#556, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#556;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 357;
                    END_IF;
                END_IF;
                
                IF _progress = 357 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#557, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#557;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 358;
                    END_IF;
                END_IF;
                
                IF _progress = 358 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#558, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#558;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 359;
                    END_IF;
                END_IF;
                
                IF _progress = 359 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_10
                    TemplateTask_10steps_6.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_6.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_6.ThrowWhen(TemplateTask_10steps_6.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_10steps_6 timeout.#>');                
            END_IF;
            IF TemplateTask_10steps_6.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_6.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10050;
                Status.Error.Id  :=  UINT#10050;
            ELSIF TemplateTask_10steps_6.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10051;
                Status.Error.Id  :=  UINT#10051;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10050,TemplateTask_10steps_6.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10051,TemplateTask_10steps_6.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,TemplateTask_10steps_6.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_6.RestoreTriggered() AND _progress >= 350 AND _progress <= 359  THEN
                Status.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;
            //**************************************************

    
            //*************TemplateTask_20steps_1***************
            TemplateTask_20steps_1.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_1.StartTriggered() THEN
                Status.Action.Id :=  UINT#160;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#160,TemplateTask_20steps_1.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,TemplateTask_20steps_1.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_1.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;
    
                IF _progress = 360 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#560, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#560;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
    
                IF _progress = 361 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#561, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#561;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;
                
                IF _progress = 362 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#562, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#562;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;
                
                IF _progress = 363 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#563, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#563;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 364;
                    END_IF;
                END_IF;
                
                IF _progress = 364 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#564, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#564;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 365;
                    END_IF;
                END_IF;
                
                IF _progress = 365 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#565, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#565;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;
                
                IF _progress = 366 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#566, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#566;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 367;
                    END_IF;
                END_IF;
                
                IF _progress = 367 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#567, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#567;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 368;
                    END_IF;
                END_IF;
                
                IF _progress = 368 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#568, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#568;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 369;
                    END_IF;
                END_IF;
                
                IF _progress = 369 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#569, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#569;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 370;
                    END_IF;
                END_IF;
    
                IF _progress = 370 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#570, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#570;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;
    
                IF _progress = 371 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#571, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#571;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 372;
                    END_IF;
                END_IF;
                
                IF _progress = 372 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#572, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#572;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 373;
                    END_IF;
                END_IF;
                
                IF _progress = 373 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#573, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#573;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 374;
                    END_IF;
                END_IF;
                
                IF _progress = 374 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#574, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#574;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 375;
                    END_IF;
                END_IF;
                
                IF _progress = 375 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#575, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#575;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 376;
                    END_IF;
                END_IF;
                
                IF _progress = 376 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#576, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#576;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 377;
                    END_IF;
                END_IF;
                
                IF _progress = 377 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#577, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#577;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 378;
                    END_IF;
                END_IF;
                
                IF _progress = 378 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#578, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#578;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 379;
                    END_IF;
                END_IF;
                
                IF _progress = 379 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_20
                    TemplateTask_20steps_1.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_1.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_1.ThrowWhen(TemplateTask_20steps_1.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_20steps_1 timeout.#>');                
            END_IF;
            IF TemplateTask_20steps_1.DoneReached() THEN
                Status.Action.Id :=  UINT#161;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_1.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10060;
                Status.Error.Id  :=  UINT#10060;
            ELSIF TemplateTask_20steps_1.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10061;
                Status.Error.Id  :=  UINT#10061;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10060,TemplateTask_20steps_1.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10061,TemplateTask_20steps_1.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,TemplateTask_20steps_1.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_1.RestoreTriggered() AND _progress >= 360 AND _progress <= 379  THEN
                Status.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;
            //**************************************************            
    
            //*************TemplateTask_20steps_2***************
            TemplateTask_20steps_2.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_2.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#180,TemplateTask_20steps_2.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,TemplateTask_20steps_2.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_2.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
    
                IF _progress = 380 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#580, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#580;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;
    
                IF _progress = 381 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#581, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#581;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#582, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#582;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#583, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#583;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;
                
                IF _progress = 384 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#584, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#584;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#585, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#585;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;
                
                IF _progress = 386 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#586, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#586;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#587, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#587;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                
                IF _progress = 388 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#588, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#588;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
                
                IF _progress = 389 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#589, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#589;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 390;
                    END_IF;
                END_IF;
    
                IF _progress = 390 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#590, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#590;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
    
                IF _progress = 391 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#591;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#592, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#592;
                    END_IF;;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 393;
                    END_IF;
                END_IF;
                
                IF _progress = 393 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#593, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#593;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 394;
                    END_IF;
                END_IF;
                
                IF _progress = 394 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#594, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#594;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 395;
                    END_IF;
                END_IF;
                
                IF _progress = 395 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#595, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#595;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 396;
                    END_IF;
                END_IF;
                
                IF _progress = 396 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#596, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#596;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 397;
                    END_IF;
                END_IF;
                
                IF _progress = 397 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#597, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#597;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 398;
                    END_IF;
                END_IF;
                
                IF _progress = 398 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#598, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#598;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 399;
                    END_IF;
                END_IF;
                
                IF _progress = 399 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_20
                    TemplateTask_20steps_2.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                TemplateTask_20steps_2.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_2.ThrowWhen(TemplateTask_20steps_2.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_20steps_2 timeout.#>');                
            END_IF;
            IF TemplateTask_20steps_2.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_2.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10080;
                Status.Error.Id  :=  UINT#10080;
            ELSIF TemplateTask_20steps_2.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10081;
                Status.Error.Id  :=  UINT#10081;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10080,TemplateTask_20steps_2.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10081,TemplateTask_20steps_2.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,TemplateTask_20steps_2.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_2.RestoreTriggered() AND _progress >= 380 AND _progress <= 399  THEN
                Status.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_20steps_3***************
            TemplateTask_20steps_3.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_3.StartTriggered() THEN
                Status.Action.Id :=  UINT#200;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#200,TemplateTask_20steps_3.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,TemplateTask_20steps_3.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_3.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;
    
                IF _progress = 400 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#600, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#600;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 401;
                    END_IF;
                END_IF;
    
                IF _progress = 401 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#601, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#601;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#602, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#602;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#603, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#603;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 404;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#604, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#604;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 405;
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#605, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#605;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#606, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#606;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#607, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#607;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#608, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#608;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#609, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#609;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 410;
                    END_IF;
                END_IF;
    
                IF _progress = 410 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#610, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#610;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 411;
                    END_IF;
                END_IF;
    
                IF _progress = 411 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#611, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#611;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#612, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#612;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#613, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#613;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#614, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#614;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#615, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#615;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#616, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#616;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#617, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#617;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#618, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#618;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 419;
                    END_IF;
                END_IF;
                
                IF _progress = 419 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_20
                    TemplateTask_20steps_3.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_3.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_3.ThrowWhen(TemplateTask_20steps_3.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_20steps_3 timeout.#>');                
            END_IF;
            IF TemplateTask_20steps_3.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_3.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10100;
                Status.Error.Id  :=  UINT#10100;
            ELSIF TemplateTask_20steps_3.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10101;
                Status.Error.Id  :=  UINT#10101;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10100,TemplateTask_20steps_3.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10101,TemplateTask_20steps_3.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,TemplateTask_20steps_3.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_3.RestoreTriggered() AND _progress >= 400 AND _progress <= 419  THEN
                Status.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_20steps_4***************
            TemplateTask_20steps_4.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_4.StartTriggered() THEN
                Status.Action.Id :=  UINT#220;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#220,TemplateTask_20steps_4.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#221,TemplateTask_20steps_4.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_4.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 420;
                END_IF;
    
                IF _progress = 420 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#620, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#620;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 421;
                    END_IF;
                END_IF;
    
                IF _progress = 421 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#621, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#621;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 422;
                    END_IF;
                END_IF;
                
                IF _progress = 422 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#622, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#622;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 423;
                    END_IF;
                END_IF;
                
                IF _progress = 423 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#623, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#623;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 424;
                    END_IF;
                END_IF;
                
                IF _progress = 424 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#624, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#624;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 425;
                    END_IF;
                END_IF;
                
                IF _progress = 425 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#625, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#625;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 426;
                    END_IF;
                END_IF;
                
                IF _progress = 426 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#626, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#626;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 427;
                    END_IF;
                END_IF;
                
                IF _progress = 427 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#627, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#627;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 428;
                    END_IF;
                END_IF;
                
                IF _progress = 428 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#628, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#628;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 429;
                    END_IF;
                END_IF;
                
                IF _progress = 429 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#629, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#629;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 430;
                    END_IF;
                END_IF;
    
                IF _progress = 430 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#630, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#630;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 431;
                    END_IF;
                END_IF;
    
                IF _progress = 431 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#631, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#631;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 432;
                    END_IF;
                END_IF;
                
                IF _progress = 432 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#632, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#632;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 433;
                    END_IF;
                END_IF;
                
                IF _progress = 433 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#633, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#633;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 434;
                    END_IF;
                END_IF;
                
                IF _progress = 434 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#634, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#634;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 435;
                    END_IF;
                END_IF;
                
                IF _progress = 435 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#635, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#635;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 436;
                    END_IF;
                END_IF;
                
                IF _progress = 436 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#636, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#636;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 437;
                    END_IF;
                END_IF;
                
                IF _progress = 437 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#637, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#637;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 438;
                    END_IF;
                END_IF;
                
                IF _progress = 438 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#638, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#638;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 439;
                    END_IF;
                END_IF;
                
                IF _progress = 439 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_20
                    TemplateTask_20steps_4.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_4.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_4.ThrowWhen(TemplateTask_20steps_4.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_20steps_4 timeout.#>');                
            END_IF;
            IF TemplateTask_20steps_4.DoneReached() THEN
                Status.Action.Id :=  UINT#221;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_4.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10120;
                Status.Error.Id  :=  UINT#10120;
            ELSIF TemplateTask_20steps_4.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10121;
                Status.Error.Id  :=  UINT#10121;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10120,TemplateTask_20steps_4.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10121,TemplateTask_20steps_4.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#222,TemplateTask_20steps_4.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_4.RestoreTriggered() AND _progress >= 420 AND _progress <= 439  THEN
                Status.Action.Id :=  UINT#222;
                _progress := 0;
            END_IF;
            //**************************************************       
            
            //*************TemplateTask_20steps_5***************
            TemplateTask_20steps_5.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_5.StartTriggered() THEN
                Status.Action.Id :=  UINT#240;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#240,TemplateTask_20steps_5.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#241,TemplateTask_20steps_5.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_5.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 440;
                END_IF;
    
                IF _progress = 440 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#640, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#640;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 441;
                    END_IF;
                END_IF;
    
                IF _progress = 441 THEN                                                                                     // TemplateTask_20steps_5 running , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#641, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#641;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 442;
                    END_IF;
                END_IF;
                
                IF _progress = 442 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#642, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#642;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 443;
                    END_IF;
                END_IF;
                
                IF _progress = 443 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#643, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#643;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 444;
                    END_IF;
                END_IF;
                
                IF _progress = 444 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#644, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#644;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 445;
                    END_IF;
                END_IF;
                
                IF _progress = 445 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#645, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#645;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 446;
                    END_IF;
                END_IF;
                
                IF _progress = 446 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#646, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#646;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 447;
                    END_IF;
                END_IF;
                
                IF _progress = 447 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#647, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#647;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 448;
                    END_IF;
                END_IF;
                
                IF _progress = 448 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#648, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#648;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 449;
                    END_IF;
                END_IF;
                
                IF _progress = 449 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#649, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#649;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 450;
                    END_IF;
                END_IF;
    
                IF _progress = 450 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#650, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#650;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 451;
                    END_IF;
                END_IF;
    
                IF _progress = 451 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#651, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#651;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 452;
                    END_IF;
                END_IF;
                
                IF _progress = 452 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#652, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#652;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 453;
                    END_IF;
                END_IF;
                
                IF _progress = 453 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#653, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#653;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 454;
                    END_IF;
                END_IF;
                
                IF _progress = 454 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#654, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#654;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 455;
                    END_IF;
                END_IF;
                
                IF _progress = 455 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#655, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#655;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 456;
                    END_IF;
                END_IF;
                
                IF _progress = 456 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#656, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#656;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 457;
                    END_IF;
                END_IF;
                
                IF _progress = 457 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#657, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#657;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 458;
                    END_IF;
                END_IF;
                
                IF _progress = 458 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#658, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#658;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 459;
                    END_IF;
                END_IF;
                
                IF _progress = 459 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_20
                    TemplateTask_20steps_5.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_5.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_5.ThrowWhen(TemplateTask_20steps_5.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_20steps_5 timeout.#>');                
            END_IF;
            IF TemplateTask_20steps_5.DoneReached() THEN
                Status.Action.Id :=  UINT#241;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_5.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10140;
                Status.Error.Id  :=  UINT#10140;
            ELSIF TemplateTask_20steps_5.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10141;
                Status.Error.Id  :=  UINT#10141;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10140,TemplateTask_20steps_5.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10141,TemplateTask_20steps_5.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#242,TemplateTask_20steps_5.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_5.RestoreTriggered() AND _progress >= 440 AND _progress <= 459  THEN
                Status.Action.Id :=  UINT#242;
                _progress := 0;
            END_IF;
            //**************************************************
            
            //*************TemplateTask_20steps_6***************
            TemplateTask_20steps_6.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_6.StartTriggered() THEN
                Status.Action.Id :=  UINT#260;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#260,TemplateTask_20steps_6.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#261,TemplateTask_20steps_6.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_6.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 460;
                END_IF;
    
                IF _progress = 460 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#660, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#660;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 461;
                    END_IF;
                END_IF;
    
                IF _progress = 461 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#661, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#661;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 462;
                    END_IF;
                END_IF;
                
                IF _progress = 462 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#662, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#662;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 463;
                    END_IF;
                END_IF;
                
                IF _progress = 463 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#663, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#663;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 464;
                    END_IF;
                END_IF;
                
                IF _progress = 464 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#664, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#664;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 465;
                    END_IF;
                END_IF;
                
                IF _progress = 465 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#665, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#665;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 466;
                    END_IF;
                END_IF;
                
                IF _progress = 466 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#666, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#666;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 467;
                    END_IF;
                END_IF;
                
                IF _progress = 467 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#667, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#667;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 468;
                    END_IF;
                END_IF;
                
                IF _progress = 468 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#668, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#668;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 469;
                    END_IF;
                END_IF;
                
                IF _progress = 469 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#669, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#669;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 470;
                    END_IF;
                END_IF;
    
                IF _progress = 470 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#670, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#670;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 471;
                    END_IF;
                END_IF;
    
                IF _progress = 471 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#671, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#671;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 472;
                    END_IF;
                END_IF;
                
                IF _progress = 472 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#672, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#672;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 473;
                    END_IF;
                END_IF;
                
                IF _progress = 473 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#673, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#673;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 474;
                    END_IF;
                END_IF;
                
                IF _progress = 474 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#674, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#674;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 475;
                    END_IF;
                END_IF;
                
                IF _progress = 475 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#675, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#675;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 476;
                    END_IF;
                END_IF;
                
                IF _progress = 476 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#676, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#676;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 477;
                    END_IF;
                END_IF;
                
                IF _progress = 477 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#677, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#677;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 478;
                    END_IF;
                END_IF;
                
                IF _progress = 478 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#678, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#678;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 479;
                    END_IF;
                END_IF;
                
                IF _progress = 479 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_20
                    TemplateTask_20steps_6.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_6.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_6.ThrowWhen(TemplateTask_20steps_6.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TemplateTask_20steps_6 timeout.#>');                
            END_IF;
            IF TemplateTask_20steps_6.DoneReached() THEN
                Status.Action.Id :=  UINT#261;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_6.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10160;
                Status.Error.Id  :=  UINT#10160;
            ELSIF TemplateTask_20steps_6.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10161;
                Status.Error.Id  :=  UINT#10161;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10160,TemplateTask_20steps_6.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10161,TemplateTask_20steps_6.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#262,TemplateTask_20steps_6.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_6.RestoreTriggered() AND _progress >= 460 AND _progress <= 479  THEN
                Status.Action.Id :=  UINT#262;
                _progress := 0;
            END_IF;
            //******************************************      
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

        METHOD PUBLIC TemplateMethod_10steps_4 : IAxoTaskState
            TemplateMethod_10steps_4 := TemplateTask_10steps_4.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_5 : IAxoTaskState
            TemplateMethod_10steps_5 := TemplateTask_10steps_5.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_6 : IAxoTaskState
            TemplateMethod_10steps_6 := TemplateTask_10steps_6.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_1 : IAxoTaskState
            TemplateMethod_20steps_1 := TemplateTask_20steps_1.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_2 : IAxoTaskState
            TemplateMethod_20steps_2 := TemplateTask_20steps_2.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_3 : IAxoTaskState
            TemplateMethod_20steps_3 := TemplateTask_20steps_3.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_4 : IAxoTaskState
            TemplateMethod_20steps_4 := TemplateTask_20steps_4.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_5 : IAxoTaskState
            TemplateMethod_20steps_5 := TemplateTask_20steps_5.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_6 : IAxoTaskState
            TemplateMethod_20steps_6 := TemplateTask_20steps_6.Invoke(THIS);
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
            TemplateTask_10steps_4.Restore();
            TemplateTask_10steps_5.Restore();
            TemplateTask_10steps_6.Restore();
            TemplateTask_20steps_1.Restore();
            TemplateTask_20steps_2.Restore();
            TemplateTask_20steps_3.Restore();
            TemplateTask_20steps_4.Restore();
            TemplateTask_20steps_5.Restore();
            TemplateTask_20steps_6.Restore();
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

