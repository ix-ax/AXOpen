USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;

NAMESPACE AXOpen.Components.Zebra.Vision
    {S7.extern=ReadWrite}
    CLASS AxoEA3600 EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Read#>"}
            ReadTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read data#>"}
            {#ix-set:DisplayFormat = "string"}
            ReadData  :   AxoEA3600_ReadData;       
            {#ix-attr:[ComponentHeader()]}         
            {#ix-set:AttributeName = "<#Barcode type#>"}
            {#ix-attr:[ReadOnly()]}
            BarcodeType : eAxoEA3600BarcodeType;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-set:AttributeName = "<#Barcode length#>"}
            {#ix-attr:[ReadOnly()]}
            BarcodeLength : UINT;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-set:AttributeName = "<#Progress#>"}
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
            {#ix-set:AttributeName = "<#Clear data#>"}
            ClearDataTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear error#>"}
            ClearErrorTask : AXOpen.Core.AxoTask;

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
            Config  :   AxoEA3600_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoEA3600_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  AxoEA3600_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoEA3600_Out;
        END_VAR    

        VAR PUBLIC // HARDWARE DIAGNOSTICS TASK
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PRIVATE
            _progress       :   INT;
            _infoTimer      :   AXOpen.Timers.OnDelayTimer;
            _errorTimer     :   AXOpen.Timers.OnDelayTimer;
            _data_in        :   ARRAY[0..87] OF BYTE;
            _data_out       :   ARRAY[0..7] OF BYTE;
            _word           :   WORD;
            _dword          :   DWORD;

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _blink                  :   AXOpen.Timers.AxoBlinker;   
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT; 
            _timer                  :   AXOpen.Timers.OnDelayTimer;
            _updateCounterPV        :   UINT    :=  UINT#0;
            _dataOffset             :   UINT    :=  UINT#0; 
	        _dataLength             :   UINT    :=  UINT#0; 
            _copyCount              :   UINT    :=  UINT#0; 

            // TransferPulse           :   BOOL    :=  FALSE;
            // TransferEdge            :   BOOL    :=  FALSE;
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
            VAR
                _index  :   UINT;
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
    
                Config.HWIDs.HW_Device := hwID;                                                      
                _retval := ReadSlotFromHardwareID(hardwareID := Config.HWIDs.HW_Device, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_BarcodeData_v2);        
                IF Config.HWIDs.HwID_BarcodeData_v2 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_BarcodeData_v2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#88 OR _outputsCount <> UINT#6 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
 
                IF parent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_Device  = UINT#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_BarcodeData_v2  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs **************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_BarcodeData_v2) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            Inputs.Status_Fragmented                :=      _data_in[0].%X0;
            Inputs.Status_FirstFragment             :=      _data_in[0].%X1;
            Inputs.Status_MiddleFragment            :=      _data_in[0].%X2;
            Inputs.Status_LastFragment              :=      _data_in[0].%X3;
            Inputs.Status_Reserved_12               :=      _data_in[0].%X4;
            Inputs.Status_Reserved_13               :=      _data_in[0].%X5;
            Inputs.Status_Reserved_14               :=      _data_in[0].%X6;
            Inputs.Status_Reserved_15               :=      _data_in[0].%X7;
            Inputs.Status_TransferEnabled           :=      _data_in[1].%X0;
            Inputs.Status_HandshakeEnabled          :=      _data_in[1].%X1;
            Inputs.Status_FragmentationEnabled      :=      _data_in[1].%X2;
            Inputs.Status_CacheOverflow             :=      _data_in[1].%X3;
            Inputs.Status_InputDataOverflow         :=      _data_in[1].%X4;
            Inputs.Status_WaitingForHandshake       :=      _data_in[1].%X5;
            Inputs.Status_TriggerState              :=      _data_in[1].%X6;
            Inputs.Status_ScannerType               :=      _data_in[1].%X7;
            _word.%B1                               :=      _data_in[2];
            _word.%B0                               :=      _data_in[3];
            Inputs.UpdateCounter                    :=      TO_UINT(_word);
            _word.%B1                               :=      _data_in[4];
            _word.%B0                               :=      _data_in[5];
            Inputs.BarcodeType                      :=      TO_INT(_word);
            Inputs.NumberOfAttachedScanners         :=      _data_in[6];
            Inputs.BatteryStateOfCharge             :=      _data_in[7];
            _word.%B1                               :=      _data_in[8];
            _word.%B0                               :=      _data_in[9];
            Inputs.BatteryVoltage                   :=      TO_INT(_word);
            _word.%B1                               :=      _data_in[10];
            _word.%B0                               :=      _data_in[11];
            Inputs.BatteryTemp                      :=      TO_INT(_word);
            FOR _index := UINT#0 TO UINT#7 DO
                Inputs.BatteryDateOfManufacture[_index]      :=      _data_in[_index + UINT#12];
            END_FOR;
            _word.%B1                               :=      _data_in[20];
            _word.%B0                               :=      _data_in[21];
            Inputs.Reserved                         :=      TO_INT(_word);
            _word.%B1                               :=      _data_in[22];
            _word.%B0                               :=      _data_in[23];
            Inputs.Length                           :=      TO_UINT(_word);
            FOR _index := UINT#0 TO UINT#63 DO
                Inputs.Data[_index]      :=      _data_in[_index + UINT#24];
            END_FOR;

          
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            ReadTask.Run(THIS);
            ClearDataTask.Run(THIS);
            ClearErrorTask.Run(THIS);
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
    
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HW_Device);
            //****************************************
    
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************ReadTask*******************
            ReadTask.SetIsDisabled(FALSE);
            IF ReadTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,ReadTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ReadTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadTask.Execute(THIS) THEN
                // TODO check if it works also without this 
                // TransferPulse :=  (Inputs.UpdateCounter <> Outputs.AckCounter) AND (NOT TransferEdge); // P-Edge of comparator
                // TransferEdge :=  (Inputs.UpdateCounter <> Outputs.AckCounter); // store for next scan    

                // ReadTask running: clear outputs and reset offset
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _dataOffset := UINT#0; 
                    _dataLength := UINT#0; 
                    _copyCount  := UINT#0; 
                    BarcodeType := eAxoEA3600BarcodeType#none;
                    BarcodeLength := UINT#0;

                    FOR _index := UINT#0 TO UINT#1023 DO
                        ReadData.Data[_index] := BYTE#0;
                    END_FOR;
                    ReadData.ToggleDataChangedFlag();
                    _progress := 300;
                END_IF;
                // ReadTask running: set handshake according to config
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#500;
                    END_IF;

                    Outputs.Ctrl_EnableHandshake        :=  Config.HandshakeEnable;
                    Outputs.Ctrl_EnableFragmentation    :=  Config.FragmentEnable;

                    IF Inputs.Status_HandshakeEnabled = Config.HandshakeEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                // ReadTask running: set fragmentation according to config
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
    
                    Outputs.Ctrl_EnableHandshake        :=  Config.HandshakeEnable;
                    Outputs.Ctrl_EnableFragmentation    :=  Config.FragmentEnable;

                    IF Inputs.Status_FragmentationEnabled = Config.FragmentEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                // ReadTask running: enable transfer              
                IF _progress = 302 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    Outputs.Ctrl_EnableTransfer    :=  TRUE;

                    // TON timer 200ms in the vendor provided example ( Network 2)
                    IF Inputs.Status_TransferEnabled THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                // ReadTask running: store update counter value
                IF _progress = 303 THEN                                                                                     
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#503;
                    END_IF;
    
                    _updateCounterPV    :=  Inputs.UpdateCounter;    

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                // ReadTask running: scanning the barcode
                IF _progress = 304 THEN                  
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#504;
                    END_IF;

                    Outputs.Ctrl_StartScan  :=  TRUE;
                    Outputs.Ctrl_StopScan   :=  FALSE;

                    IF _updateCounterPV <> Inputs.UpdateCounter THEN
                        Outputs.Ctrl_StartScan  :=  FALSE;
                        Outputs.Ctrl_StopScan   :=  FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                // ReadTask running: copy data  NW8
                IF _progress = 305 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#505;
                    END_IF;
                    // bytes to copy from this fragment
                    _copyCount := Inputs.Length;
                
                    // Clamp to remaining space; mark truncation if needed
                    IF (_dataOffset + _copyCount) > UINT#1024 THEN
                        ;
                        // TODO Error messsage
                    ELSE
                        // copy data of this fragment
                        FOR _index := UINT#0 TO _copyCount - UINT#1 DO
                            ReadData.Data[_dataOffset + _index] := Inputs.Data[_index];
                        END_FOR;
                        _dataOffset := _dataOffset + Inputs.Length;
                    END_IF;
                    
                    // BarcodeType
                    BarcodeType := Inputs.BarcodeType; 

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                // ReadTask running: handshake NW5,NW11      
                IF _progress = 306 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#506, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#506;
                    END_IF;
                    // Handshake operations (handshake mode only)
                    // Increment OutScanObject.AckCounter when it does not
                    // match InScanObject.UpdateCounter. AckCounter is reset to 0 when 
                    // UpdateCounter is 0 (rollover/reset case).
                    IF Config.HandshakeEnable AND NOT Config.FragmentEnable THEN 
                        IF Outputs.AckCounter <> Inputs.UpdateCounter THEN
                            Outputs.AckCounter := Outputs.AckCounter + UINT#1;
                        END_IF;
                        // Reset AckCounter when UpdateCounter is 0
                        IF Inputs.UpdateCounter = UINT#0 THEN
                            Outputs.AckCounter := UINT#0;
                        END_IF;
                    END_IF;
                    // In simple mode (no handshake) or in fragment mode, keep AckCounter in sync so
                    // that transfers are released without explicit ack (simple), and after fragment burst.
                    IF ((NOT Config.HandshakeEnable AND NOT Config.FragmentEnable) OR 
                        (Config.HandshakeEnable AND Config.FragmentEnable)) AND
                        (Outputs.AckCounter <> Inputs.UpdateCounter OR Inputs.UpdateCounter = UINT#0 ) THEN
                        Outputs.AckCounter := Inputs.UpdateCounter; 
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 307;
                    END_IF;
                END_IF;
                // ReadTask running: Update DataLength NW9    
                IF _progress = 307 THEN  
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#507, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#507;
                    END_IF;
                    // Fragment mode: 
                    IF Config.HandshakeEnable AND Config.FragmentEnable THEN
                        // when last fragment arrives, finalize length and finish sequence
                        IF (Inputs.Status_LastFragment OR NOT Inputs.Status_Fragmented) (*AND TransferPulse*) THEN
                            BarcodeLength := _dataOffset;
                            THIS.CallTimers(FALSE);
                            _progress := 308;
                        ELSIF Outputs.AckCounter <> Inputs.UpdateCounter THEN
                            THIS.CallTimers(FALSE);
                            _progress := 305;
                        END_IF;
                    END_IF;
                    
                    // Simple or handshake-non-fragment transfer
                    IF (NOT Config.FragmentEnable) (*AND TransferPulse*) THEN
                        BarcodeLength := Inputs.Length; 
                        THIS.CallTimers(FALSE);
                        _progress := 308;
                    END_IF;
                END_IF;
                
                IF _progress = 308 THEN   
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#508, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#508;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 309;
                    END_IF;
                END_IF;
                
                IF _progress = 309 THEN   
                    ReadTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ReadTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ReadTask.ThrowWhen(ReadTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ReadTask timeout.#>');                
            END_IF;
            IF ReadTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF ReadTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,ReadTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,ReadTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#102,ReadTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ReadTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ClearDataTask************************
            ClearDataTask.SetIsDisabled(FALSE);
            IF ClearDataTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,ClearDataTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ClearDataTask.IsDone(), eAxoMessageCategory#Info);
            IF ClearDataTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_1
                IF _progress = 310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
                    
                    Outputs.Ctrl_EnableTransfer         :=  FALSE;
                    Outputs.Ctrl_EnableHandshake        :=  FALSE;
                    Outputs.Ctrl_EnableFragmentation    :=  FALSE;
                    Outputs.Ctrl_ClearFaults            :=  FALSE;
                    Outputs.Ctrl_StartScan              :=  FALSE;
                    Outputs.Ctrl_StopScan               :=  FALSE;
                    Outputs.Ctrl_SendAction             :=  FALSE;

                    _dataOffset := UINT#0; 
                    _dataLength := UINT#0; 
                    _copyCount  := UINT#0; 

                    BarcodeType := eAxoEA3600BarcodeType#none;
                    BarcodeLength := UINT#0;

                    FOR _index := UINT#0 TO UINT#1023 DO
                        ReadData.Data[_index] := BYTE#0;
                    END_FOR;

                    ReadData.ToggleDataChangedFlag();

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_2
                IF _progress = 311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#511;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_3
                IF _progress = 312 THEN                                                         
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_4
                IF _progress = 313 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_5
                IF _progress = 314 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#514;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_6
                IF _progress = 315 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#515;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_7
                IF _progress = 316 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#516;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_8
                IF _progress = 317 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#517;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_9
                IF _progress = 318 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#518;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 319;
                    END_IF;
                END_IF;
                // ClearDataTask running: , add_the_detailed_description_of_the_current_action_10
                IF _progress = 319 THEN
                    ClearDataTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ClearDataTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ClearDataTask.ThrowWhen(ClearDataTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ClearDataTask timeout.#>');                
            END_IF;
            IF ClearDataTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearDataTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF ClearDataTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,ClearDataTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,ClearDataTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#112,ClearDataTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ClearDataTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ClearErrorTask***********************
            ClearErrorTask.SetIsDisabled(FALSE);
            IF ClearErrorTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,ClearErrorTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,ClearErrorTask.IsDone(), eAxoMessageCategory#Info);
            IF ClearErrorTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
    
                IF _progress = 320 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#520;
                    END_IF;

                    Outputs.Ctrl_ClearFaults := TRUE;
    
                    IF _timer.elapsedTime >= T#250MS AND NOT Inputs.Status_CacheOverflow THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
    
                IF _progress = 321 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#521;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                
                IF _progress = 322 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#522;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                
                IF _progress = 323 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#523;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                
                IF _progress = 324 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#524;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#526;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
                
                IF _progress = 327 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#527;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    END_IF;
                END_IF;
                
                IF _progress = 328 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#528, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#528;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 329;
                    END_IF;
                END_IF;
                
                IF _progress = 329 THEN                                                                                     // ClearErrorTask running: , add_the_detailed_description_of_the_current_action_10
                    ClearErrorTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ClearErrorTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ClearErrorTask.ThrowWhen(ClearErrorTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ClearErrorTask timeout.#>');                
            END_IF;
            IF ClearErrorTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearErrorTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF ClearErrorTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10020,ClearErrorTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,ClearErrorTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#122,ClearErrorTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ClearErrorTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //**************************************************
    
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
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#530;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
    
                IF _progress = 331 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#531;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#532;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;
                
                IF _progress = 333 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#533, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#533;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#534, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#534;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 335 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#535, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#535;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#536, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#536;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 337;
                    END_IF;
                END_IF;
                
                IF _progress = 337 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#537, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#537;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 338;
                    END_IF;
                END_IF;
                
                IF _progress = 338 THEN                                                                                     // TemplateTask_10steps_4 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#538, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10031,TemplateTask_10steps_4.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#132,TemplateTask_10steps_4.RestoreTriggered() , eAxoMessageCategory#Info);
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
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#540;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;
    
                IF _progress = 341 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#541;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#542;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#543, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#543;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#544, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#544;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    END_IF;
                END_IF;
                
                IF _progress = 345 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#545, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#545;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 346;
                    END_IF;
                END_IF;
                
                IF _progress = 346 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#546, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#546;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 347;
                    END_IF;
                END_IF;
                
                IF _progress = 347 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#547, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#547;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 348;
                    END_IF;
                END_IF;
                
                IF _progress = 348 THEN                                                                                     // TemplateTask_10steps_5 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#548, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10041,TemplateTask_10steps_5.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#142,TemplateTask_10steps_5.RestoreTriggered() , eAxoMessageCategory#Info);
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
                        TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#550;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
    
                IF _progress = 351 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#551, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#551;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 352;
                    END_IF;
                END_IF;
                
                IF _progress = 352 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#552, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#552;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 353;
                    END_IF;
                END_IF;
                
                IF _progress = 353 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#553, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#553;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 354;
                    END_IF;
                END_IF;
                
                IF _progress = 354 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#554, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#554;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 355;
                    END_IF;
                END_IF;
                
                IF _progress = 355 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#555, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#555;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 356;
                    END_IF;
                END_IF;
                
                IF _progress = 356 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#556, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#556;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 357;
                    END_IF;
                END_IF;
                
                IF _progress = 357 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#557, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#557;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 358;
                    END_IF;
                END_IF;
                
                IF _progress = 358 THEN                                                                                     // TemplateTask_10steps_6 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#558, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10051,TemplateTask_10steps_6.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#152,TemplateTask_10steps_6.RestoreTriggered() , eAxoMessageCategory#Info);
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
                        TaskMessenger.Activate( UINT#560, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#560;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
    
                IF _progress = 361 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#561, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#561;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;
                
                IF _progress = 362 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#562, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#562;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;
                
                IF _progress = 363 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#563, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#563;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 364;
                    END_IF;
                END_IF;
                
                IF _progress = 364 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#564, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#564;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 365;
                    END_IF;
                END_IF;
                
                IF _progress = 365 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#565, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#565;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;
                
                IF _progress = 366 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#566, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#566;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 367;
                    END_IF;
                END_IF;
                
                IF _progress = 367 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#567, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#567;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 368;
                    END_IF;
                END_IF;
                
                IF _progress = 368 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#568, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#568;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 369;
                    END_IF;
                END_IF;
                
                IF _progress = 369 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#569, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#569;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 370;
                    END_IF;
                END_IF;
    
                IF _progress = 370 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#570, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#570;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;
    
                IF _progress = 371 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#571, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#571;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 372;
                    END_IF;
                END_IF;
                
                IF _progress = 372 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#572, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#572;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 373;
                    END_IF;
                END_IF;
                
                IF _progress = 373 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#573, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#573;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 374;
                    END_IF;
                END_IF;
                
                IF _progress = 374 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#574, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#574;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 375;
                    END_IF;
                END_IF;
                
                IF _progress = 375 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#575, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#575;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 376;
                    END_IF;
                END_IF;
                
                IF _progress = 376 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#576, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#576;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 377;
                    END_IF;
                END_IF;
                
                IF _progress = 377 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#577, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#577;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 378;
                    END_IF;
                END_IF;
                
                IF _progress = 378 THEN                                                                                     // TemplateTask_20steps_1 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#578, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10061,TemplateTask_20steps_1.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#162,TemplateTask_20steps_1.RestoreTriggered() , eAxoMessageCategory#Info);
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
                        TaskMessenger.Activate( UINT#580, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#580;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;
    
                IF _progress = 381 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#581, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#581;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#582, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#582;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#583, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#583;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;
                
                IF _progress = 384 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#584, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#584;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#585, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#585;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;
                
                IF _progress = 386 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#586, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#586;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#587, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#587;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                
                IF _progress = 388 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#588, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#588;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
                
                IF _progress = 389 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#589, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#589;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 390;
                    END_IF;
                END_IF;
    
                IF _progress = 390 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#590, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#590;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
    
                IF _progress = 391 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#591;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#592, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#592;
                    END_IF;;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 393;
                    END_IF;
                END_IF;
                
                IF _progress = 393 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#593, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#593;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 394;
                    END_IF;
                END_IF;
                
                IF _progress = 394 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#594, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#594;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 395;
                    END_IF;
                END_IF;
                
                IF _progress = 395 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#595, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#595;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 396;
                    END_IF;
                END_IF;
                
                IF _progress = 396 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#596, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#596;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 397;
                    END_IF;
                END_IF;
                
                IF _progress = 397 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#597, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#597;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 398;
                    END_IF;
                END_IF;
                
                IF _progress = 398 THEN                                                                                     // TemplateTask_20steps_2 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#598, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10081,TemplateTask_20steps_2.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#182,TemplateTask_20steps_2.RestoreTriggered() , eAxoMessageCategory#Info);
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
                        TaskMessenger.Activate( UINT#600, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#600;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 401;
                    END_IF;
                END_IF;
    
                IF _progress = 401 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#601, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#601;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#602, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#602;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#603, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#603;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 404;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#604, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#604;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 405;
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#605, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#605;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#606, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#606;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#607, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#607;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#608, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#608;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#609, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#609;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 410;
                    END_IF;
                END_IF;
    
                IF _progress = 410 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#610, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#610;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 411;
                    END_IF;
                END_IF;
    
                IF _progress = 411 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#611, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#611;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#612, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#612;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#613, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#613;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#614, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#614;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#615, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#615;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#616, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#616;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#617, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#617;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN                                                                                     // TemplateTask_20steps_3 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#618, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10101,TemplateTask_20steps_3.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#202,TemplateTask_20steps_3.RestoreTriggered() , eAxoMessageCategory#Info);
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
                        TaskMessenger.Activate( UINT#620, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#620;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 421;
                    END_IF;
                END_IF;
    
                IF _progress = 421 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#621, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#621;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 422;
                    END_IF;
                END_IF;
                
                IF _progress = 422 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#622, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#622;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 423;
                    END_IF;
                END_IF;
                
                IF _progress = 423 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#623, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#623;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 424;
                    END_IF;
                END_IF;
                
                IF _progress = 424 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#624, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#624;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 425;
                    END_IF;
                END_IF;
                
                IF _progress = 425 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#625, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#625;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 426;
                    END_IF;
                END_IF;
                
                IF _progress = 426 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#626, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#626;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 427;
                    END_IF;
                END_IF;
                
                IF _progress = 427 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#627, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#627;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 428;
                    END_IF;
                END_IF;
                
                IF _progress = 428 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#628, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#628;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 429;
                    END_IF;
                END_IF;
                
                IF _progress = 429 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#629, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#629;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 430;
                    END_IF;
                END_IF;
    
                IF _progress = 430 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#630, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#630;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 431;
                    END_IF;
                END_IF;
    
                IF _progress = 431 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#631, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#631;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 432;
                    END_IF;
                END_IF;
                
                IF _progress = 432 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#632, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#632;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 433;
                    END_IF;
                END_IF;
                
                IF _progress = 433 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#633, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#633;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 434;
                    END_IF;
                END_IF;
                
                IF _progress = 434 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#634, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#634;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 435;
                    END_IF;
                END_IF;
                
                IF _progress = 435 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#635, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#635;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 436;
                    END_IF;
                END_IF;
                
                IF _progress = 436 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#636, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#636;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 437;
                    END_IF;
                END_IF;
                
                IF _progress = 437 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#637, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#637;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 438;
                    END_IF;
                END_IF;
                
                IF _progress = 438 THEN                                                                                     // TemplateTask_20steps_4 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#638, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10121,TemplateTask_20steps_4.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#222,TemplateTask_20steps_4.RestoreTriggered() , eAxoMessageCategory#Info);
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
                        TaskMessenger.Activate( UINT#640, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#640;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 441;
                    END_IF;
                END_IF;
    
                IF _progress = 441 THEN                                                                                     // TemplateTask_20steps_5 running , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#641, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#641;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 442;
                    END_IF;
                END_IF;
                
                IF _progress = 442 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#642, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#642;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 443;
                    END_IF;
                END_IF;
                
                IF _progress = 443 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#643, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#643;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 444;
                    END_IF;
                END_IF;
                
                IF _progress = 444 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#644, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#644;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 445;
                    END_IF;
                END_IF;
                
                IF _progress = 445 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#645, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#645;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 446;
                    END_IF;
                END_IF;
                
                IF _progress = 446 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#646, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#646;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 447;
                    END_IF;
                END_IF;
                
                IF _progress = 447 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#647, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#647;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 448;
                    END_IF;
                END_IF;
                
                IF _progress = 448 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#648, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#648;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 449;
                    END_IF;
                END_IF;
                
                IF _progress = 449 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#649, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#649;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 450;
                    END_IF;
                END_IF;
    
                IF _progress = 450 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#650, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#650;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 451;
                    END_IF;
                END_IF;
    
                IF _progress = 451 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#651, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#651;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 452;
                    END_IF;
                END_IF;
                
                IF _progress = 452 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#652, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#652;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 453;
                    END_IF;
                END_IF;
                
                IF _progress = 453 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#653, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#653;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 454;
                    END_IF;
                END_IF;
                
                IF _progress = 454 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#654, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#654;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 455;
                    END_IF;
                END_IF;
                
                IF _progress = 455 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#655, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#655;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 456;
                    END_IF;
                END_IF;
                
                IF _progress = 456 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#656, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#656;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 457;
                    END_IF;
                END_IF;
                
                IF _progress = 457 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#657, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#657;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 458;
                    END_IF;
                END_IF;
                
                IF _progress = 458 THEN                                                                                     // TemplateTask_20steps_5 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#658, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10141,TemplateTask_20steps_5.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#242,TemplateTask_20steps_5.RestoreTriggered() , eAxoMessageCategory#Info);
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
                        TaskMessenger.Activate( UINT#660, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#660;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 461;
                    END_IF;
                END_IF;
    
                IF _progress = 461 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#661, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#661;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 462;
                    END_IF;
                END_IF;
                
                IF _progress = 462 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#662, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#662;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 463;
                    END_IF;
                END_IF;
                
                IF _progress = 463 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#663, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#663;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 464;
                    END_IF;
                END_IF;
                
                IF _progress = 464 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#664, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#664;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 465;
                    END_IF;
                END_IF;
                
                IF _progress = 465 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#665, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#665;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 466;
                    END_IF;
                END_IF;
                
                IF _progress = 466 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#666, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#666;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 467;
                    END_IF;
                END_IF;
                
                IF _progress = 467 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#667, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#667;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 468;
                    END_IF;
                END_IF;
                
                IF _progress = 468 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#668, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#668;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 469;
                    END_IF;
                END_IF;
                
                IF _progress = 469 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_10
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#669, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#669;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 470;
                    END_IF;
                END_IF;
    
                IF _progress = 470 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_11
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#670, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#670;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 471;
                    END_IF;
                END_IF;
    
                IF _progress = 471 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_12
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#671, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#671;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 472;
                    END_IF;
                END_IF;
                
                IF _progress = 472 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_13
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#672, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#672;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 473;
                    END_IF;
                END_IF;
                
                IF _progress = 473 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_14
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#673, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#673;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 474;
                    END_IF;
                END_IF;
                
                IF _progress = 474 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_15
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#674, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#674;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 475;
                    END_IF;
                END_IF;
                
                IF _progress = 475 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_16
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#675, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#675;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 476;
                    END_IF;
                END_IF;
                
                IF _progress = 476 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_17
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#676, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#676;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 477;
                    END_IF;
                END_IF;
                
                IF _progress = 477 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_18
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#677, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#677;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 478;
                    END_IF;
                END_IF;
                
                IF _progress = 478 THEN                                                                                     // TemplateTask_20steps_6 running: , add_the_detailed_description_of_the_current_action_19
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#678, eAxoMessageCategory#Potential);
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
            Messenger.ActivateOnCondition(ULINT#10161,TemplateTask_20steps_6.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#262,TemplateTask_20steps_6.RestoreTriggered() , eAxoMessageCategory#Info);
            IF TemplateTask_20steps_6.RestoreTriggered() AND _progress >= 460 AND _progress <= 479  THEN
                Status.Action.Id :=  UINT#262;
                _progress := 0;
            END_IF;
            //******************************************      

            //***********Update outputs ****************
            _data_out[0].%X0                  :=    Outputs.Ctrl_Reserved_8;
            _data_out[0].%X1                  :=    Outputs.Ctrl_Reserved_9;
            _data_out[0].%X2                  :=    Outputs.Ctrl_Reserved_10;
            _data_out[0].%X3                  :=    Outputs.Ctrl_Reserved_11;
            _data_out[0].%X4                  :=    Outputs.Ctrl_Reserved_12;
            _data_out[0].%X5                  :=    Outputs.Ctrl_Reserved_13;
            _data_out[0].%X6                  :=    Outputs.Ctrl_Reserved_14;
            _data_out[0].%X7                  :=    Outputs.Ctrl_Reserved_15;
            _data_out[1].%X0                  :=    Outputs.Ctrl_EnableTransfer;
            _data_out[1].%X1                  :=    Outputs.Ctrl_EnableHandshake;
            _data_out[1].%X2                  :=    Outputs.Ctrl_EnableFragmentation;
            _data_out[1].%X3                  :=    Outputs.Ctrl_Reserved_3;
            _data_out[1].%X4                  :=    Outputs.Ctrl_ClearFaults;
            _data_out[1].%X5                  :=    Outputs.Ctrl_StartScan;
            _data_out[1].%X6                  :=    Outputs.Ctrl_StopScan;
            _data_out[1].%X7                  :=    Outputs.Ctrl_SendAction;
            _word                             :=    TO_WORD(Outputs.AckCounter);
            _data_out[2]                      :=    _word.%B1;
            _data_out[3]                      :=    _word.%B0;
            _word                             :=    Outputs.UIActionCode;
            _data_out[4]                      :=    _word.%B1;
            _data_out[5]                      :=    _word.%B0;

            _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HwID_BarcodeData_v2),_data_out);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;            
           
            //******************************************      

        END_METHOD

        ///<summary>
		/// Triggers the reading sequence and waits for results. 	
        ///</summary>       
        METHOD PUBLIC Read : IAxoTaskState
            VAR_OUTPUT
                result : ARRAY [0..1023] OF BYTE;
            END_VAR
            result := ReadData.Data;
            Read := ReadTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ClearData : IAxoTaskState
            ClearData := ClearDataTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ClearError : IAxoTaskState
            ClearError := ClearErrorTask.Invoke(THIS);
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

            FOR _index := 0 TO 7 DO
                _data_in[_index] := BYTE#0;
                _data_out[_index] := BYTE#0;
            END_FOR;

            FOR _index := 7 TO 87 DO
                _data_in[_index] := BYTE#0;
            END_FOR;

            _word           :=   WORD#0;
            _dword          :=   DWORD#0;

            ReadTask.Restore();
            ClearDataTask.Restore();
            ClearErrorTask.Restore();
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
            _infoTimer.OnDelay(THIS, FALSE ,T#0s);
            _errorTimer.OnDelay(THIS, FALSE ,T#0s);
            _timer.OnDelay(THIS, FALSE ,T#0s);
            _updateCounterPV        :=  UINT#0;
            _dataOffset             :=  UINT#0; 
	        _dataLength             :=  UINT#0; 
            _copyCount              :=  UINT#0; 

            RestoreTask.DoneWhen(TRUE);
        END_METHOD        

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > T#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > T#0S , Config.ErrorTime);
            _timer.OnDelay(THIS, signal, T#10s);
        END_METHOD

    END_CLASS
END_NAMESPACE




