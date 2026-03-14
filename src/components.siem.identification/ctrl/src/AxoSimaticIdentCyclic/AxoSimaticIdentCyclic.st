USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;

NAMESPACE AXOpen.Components.Siem.Identification
    {S7.extern=ReadWrite}
    CLASS AxoSimaticIdentCyclic EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
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
            {#ix-set:AttributeName = "<#ReadUID_Task#>"}
            ReadUID_Task : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Tag field to read#>"}
            ReadTagFieldManual : UINT;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ReadTagFieldTask#>"}
            ReadTagFieldTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Tag field to write#>"}
            WriteTagFieldManual : UINT;            
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Length of the tag field to write#>"}
            WriteTagFieldLengthManual : UINT;            
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#WriteTagFieldTask#>"}
            WriteTagFieldTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Read address#>"}
            ReadAddressManual : UDINT;            
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Length of data to read#>"}
            ReadLengthManual : UINT;            
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ReadTask#>"}
            ReadTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Write address#>"}
            WriteAddressManual : UDINT;            
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Length of data to write#>"}
            WriteLengthManual : UINT;            
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#WriteTask#>"}
            WriteTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ResetTask#>"}
            ResetTask : AXOpen.Core.AxoTask;

        END_VAR

        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoSimaticIdentCyclic_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoSimaticIdentCyclic_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  AxoSimaticIdentCyclic_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            // {#ix-attr:[ReadOnly()]}  //TODO uncomment this after debugging is finished
            Outputs              :   AxoSimaticIdentCyclic_Out;
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
            _data_in        :   ARRAY[0..127] OF BYTE;
            _data_out_1     :   ARRAY[0..0] OF BYTE;
            _data_out_2     :   ARRAY[0..1] OF BYTE;
            _data_out_32    :   ARRAY[0..31] OF BYTE;
            _data_out_116   :   ARRAY[0..115] OF BYTE;
            _data_out_128   :   ARRAY[0..127] OF BYTE;
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
            _NDR_PV                 :   BOOL;
            _dataBufferOffset       :   INT;
            _readTagField           :   UINT;
            _writeTagField          :   UINT;
            _writeTagFieldLength    :   UINT;
            _bytesToWrite           :   UINT;
            _readAddress            :   UDINT;
            _readLength             :   UINT;
            _writeAddress           :   UDINT;
            _writeLength            :   UINT;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent    :   IAxoObject;
                hwID        :   UINT;   //	Hardware ID address of the communication module
                Port        :   eAxoSimaticIdentCyclic_Port := eAxoSimaticIdentCyclic_Port#NONE;
            END_VAR
            VAR_IN_OUT
                DataBuffer  :   ARRAY[*] OF BYTE;
            END_VAR
            VAR
                _index      :   INT;
            END_VAR

            SUPER.Run(inParent);

            Messenger.Serve(THIS);
            
            Progress := _progress;

            IF NOT _initHwCheckDone THEN
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                IF hwID = UINT#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                Config.HWIDs.HW_Head := hwID;                                                      
                _retval := ReadSlotFromHardwareID(hardwareID := Config.HWIDs.HW_Head, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_CM);        
                IF Config.HWIDs.HwID_CM = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_CM) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#2 OR _outputsCount <> UINT#2 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                IF Port = eAxoSimaticIdentCyclic_Port#X21 THEN
                    //******************Slot 2*****************//
                    _geoAddr.Slot   :=  UINT#2;                                                            
                    _geoAddr.HardwareType := UINT#4; // (4-Module)
                    _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Reader);        
                    IF Config.HWIDs.HwID_Reader = UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_Reader) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _inputsCount = UINT#32 AND _outputsCount = UINT#32 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_32;
                    ELSIF _inputsCount = UINT#116 AND _outputsCount = UINT#116 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_116;
                    ELSIF _inputsCount = UINT#128 AND _outputsCount = UINT#128 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_128;
                    ELSE
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#INVALID;
                        Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#726;
                        RETURN;
                    END_IF;
                ELSIF Port = eAxoSimaticIdentCyclic_Port#X22 THEN
                    //******************Slot 3*****************//
                    _geoAddr.Slot   :=  UINT#3;                                                            
                    _geoAddr.HardwareType := UINT#4; // (4-Module)
                    _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Reader);        
                    IF Config.HWIDs.HwID_Reader = UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_Reader) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _inputsCount = UINT#32 AND _outputsCount = UINT#32 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_32;
                    ELSIF _inputsCount = UINT#116 AND _outputsCount = UINT#116 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_116;
                    ELSIF _inputsCount = UINT#128 AND _outputsCount = UINT#128 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_128;
                    ELSE
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#INVALID;
                        Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#736;
                        RETURN;
                    END_IF;
                ELSIF Port = eAxoSimaticIdentCyclic_Port#X23 THEN
                    //******************Slot 4*****************//
                    _geoAddr.Slot   :=  UINT#4;                                                            
                    _geoAddr.HardwareType := UINT#4; // (4-Module)
                    _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Reader);        
                    IF Config.HWIDs.HwID_Reader = UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_Reader) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _inputsCount = UINT#32 AND _outputsCount = UINT#32 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_32;
                    ELSIF _inputsCount = UINT#116 AND _outputsCount = UINT#116 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_116;
                    ELSIF _inputsCount = UINT#128 AND _outputsCount = UINT#128 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_128;
                    ELSE
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#INVALID;
                        Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#746;
                        RETURN;
                    END_IF;
                ELSIF Port = eAxoSimaticIdentCyclic_Port#X24 THEN
                    //******************Slot 5*****************//
                    _geoAddr.Slot   :=  UINT#5;                                                            
                    _geoAddr.HardwareType := UINT#4; // (4-Module)
                    _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Reader);        
                    IF Config.HWIDs.HwID_Reader = UINT#0 THEN
                        Messenger.Activate(UINT#750,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#750;
                        RETURN;
                    END_IF;
                    IF _retval = WORD#8091 THEN
                        Messenger.Activate(UINT#751,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#751;
                        RETURN;
                    END_IF;
                    IF _retval = WORD#8094 THEN
                        Messenger.Activate(UINT#752,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#752;
                        RETURN;
                    END_IF;
                    IF _retval = WORD#8095 THEN
                        Messenger.Activate(UINT#753,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#753;
                        RETURN;
                    END_IF;
                    IF _retval = WORD#8096 THEN
                        Messenger.Activate(UINT#754,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#754;
                        RETURN;
                    END_IF;
                    IF _retval = WORD#8097 THEN
                        Messenger.Activate(UINT#755,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#755;
                        RETURN;
                    END_IF;
                    ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_Reader) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _inputsCount = UINT#32 AND _outputsCount = UINT#32 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_32;
                    ELSIF _inputsCount = UINT#116 AND _outputsCount = UINT#116 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_116;
                    ELSIF _inputsCount = UINT#128 AND _outputsCount = UINT#128 THEN
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#BYTES_128;
                    ELSE
                        Config.IOsize := eAxoSimaticIdentCyclic_IOsize#INVALID;
                        Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#756;
                        RETURN;
                    END_IF;
                END_IF;
    
                Config.Port := Port;

                IF inParent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_Head  = UINT#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF Config.Port = eAxoSimaticIdentCyclic_Port#X21 AND Config.HWIDs.HwID_Reader  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
                IF Config.Port = eAxoSimaticIdentCyclic_Port#X22 AND Config.HWIDs.HwID_Reader  = UINT#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
                IF Config.Port = eAxoSimaticIdentCyclic_Port#X23 AND Config.HWIDs.HwID_Reader  = UINT#0 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;
                IF Config.Port = eAxoSimaticIdentCyclic_Port#X24 AND Config.HWIDs.HwID_Reader  = UINT#0 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;

                Config.DataBufferLowIndex   := TO_INT(LOWER_BOUND(DataBuffer, 1));
                Config.DataBufferHighIndex  := TO_INT(UPPER_BOUND(DataBuffer, 1));

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs **************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_CM) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_Reader) ,_data_in);

            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            Inputs.Status.NDR                       :=      _data_in[0].%X0;
            Inputs.Status.RESETCONF 			    :=      _data_in[0].%X1;
            Inputs.Status.STOPCONF 			        :=      _data_in[0].%X2;
            Inputs.Status.ANTSTATUS 			    :=      _data_in[0].%X3;
            Inputs.Status.BLOCK 			        :=      _data_in[0].%X4;

            Inputs.Status.PRESENCE 			        :=      _data_in[0].%X6;
            Inputs.Status.ERROR_STARTUP 	        :=      _data_in[0].%X7;

            Inputs.Status.ACTIVECMD 			    :=      _data_in[2];
            Inputs.Status.BLOCKLENGTH 		        :=      _data_in[3];

            FOR _index := INT#4 TO (TO_INT(Config.IOsize) - INT#1) DO
                Inputs.Data[_index - INT#4] := _data_in[_index];
            END_FOR;  
            FOR _index := TO_INT(Config.IOsize)  TO INT#127 DO
                Inputs.Data[_index - INT#4] := BYTE#0;
            END_FOR;  
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            ReadUID_Task.Run(THIS);
            ReadTagFieldTask.Run(THIS);
            WriteTagFieldTask.Run(THIS);
            ReadTask.Run(THIS);
            WriteTask.Run(THIS);
            ResetTask.Run(THIS);
                
            //****************************************
    
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HW_Head);
            //****************************************
    
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
    
            //*************ReadUID_Task**************
            ReadUID_Task.SetIsDisabled(FALSE);
            IF ReadUID_Task.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,ReadUID_Task.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ReadUID_Task.IsDone(), eAxoMessageCategory#Info);
            IF ReadUID_Task.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Outputs.Control.RESET := FALSE;
                    Outputs.Control.STOP := FALSE;
                    Outputs.Control.ANTOFF := FALSE;
                    Outputs.Control.BLOCK := FALSE;
                    _NDR_PV := Inputs.Status.NDR;
                    _index  := INT#0;
                    _dataBufferOffset := Config.DataBufferLowIndex;
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                // ReadUID_Task running: waiting for the tag presence.
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
    
                    IF Inputs.Status.PRESENCE THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                // ReadUID_Task running: command triggered.
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
    
                    Outputs.Control.CMD := BYTE#1;   // ReadUID command
                    Outputs.Control.START := NOT Outputs.Control.START;

                    IF TRUE THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                // ReadUID_Task running: waiting for active command to be equal 1 (ReadUID).
                IF _progress = 302 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#502;
                    END_IF;
    
                    IF Inputs.Status.ACTIVECMD = Outputs.Control.CMD THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                // ReadUID_Task running: waiting for the new data.
                IF _progress = 303 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#503;
                    END_IF;
    
                    IF Inputs.Status.NDR <> _NDR_PV THEN
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                // ReadUID_Task running: reading the data.
                IF _progress = 304 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#504;
                    END_IF;
                    FOR _index := INT#0 TO (TO_INT(Inputs.Status.BLOCKLENGTH) - INT#1) BY INT#1 DO
                        IF (_index + _dataBufferOffset) > Config.DataBufferHighIndex THEN
                            TaskMessenger.Activate( UINT#1301, eAxoMessageCategory#Error);
                            Status.Error.Id :=      UINT#1301;
                            RETURN;
                        ELSE
                            DataBuffer[ _index + _dataBufferOffset] := Inputs.Data[_index];
                        END_IF;
                    END_FOR;
                    _dataBufferOffset := _dataBufferOffset + TO_INT(Inputs.Status.BLOCKLENGTH);
                    IF Inputs.Status.BLOCK THEN
                        _NDR_PV := Inputs.Status.NDR;
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                // ReadUID_Task running: cleaning the tail of the data buffer.
                IF _progress = 305 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#505;
                    END_IF;

                    FOR _index := _dataBufferOffset TO Config.DataBufferHighIndex BY INT#1 DO
                        DataBuffer[_index] := BYTE#0;
                    END_FOR;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                // ReadUID_Task finished.
                IF _progress = 306 THEN
                    ReadUID_Task.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ReadUID_Task.ThrowWhen(_errorTimer.output OR Inputs.Status.ERROR_STARTUP);
                Status.Action.Id := TO_UINT(_progress);  
                ReadUID_Task.ThrowWhen(ReadUID_Task.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ReadUID_Task timeout.#>');                
            END_IF;
            IF ReadUID_Task.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadUID_Task.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF ReadUID_Task.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,ReadUID_Task.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,ReadUID_Task.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#102,ReadUID_Task.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ReadUID_Task.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ReadTagFieldTask***************
            ReadTagFieldTask.SetIsDisabled(FALSE);
            IF ReadTagFieldTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,ReadTagFieldTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ReadTagFieldTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadTagFieldTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Outputs.Control.RESET := FALSE;
                    Outputs.Control.STOP := FALSE;
                    Outputs.Control.ANTOFF := FALSE;
                    Outputs.Control.BLOCK := FALSE;
                    _NDR_PV := Inputs.Status.NDR;
                    _index  := INT#0;
                    _dataBufferOffset := Config.DataBufferLowIndex;
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
                // ReadTagFieldTask running: waiting for the tag presence.
                IF _progress = 310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
    
                    IF Inputs.Status.PRESENCE THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
                // ReadTagFieldTask running: command triggered.
                IF _progress = 311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#511;
                    END_IF;

                    Outputs.Control.CMD := BYTE#2;   // ReadTagField command
                    Outputs.Data[0] := _readTagField.%B1;
                    Outputs.Data[1] := _readTagField.%B0;
                    FOR _index := INT#2 TO (TO_INT(Config.IOsize) - INT#5) BY INT#1 DO
                        Outputs.Data[_index]  := BYTE#0;
                    END_FOR;
                    Outputs.Control.START := NOT Outputs.Control.START;
                    IF TRUE THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                // ReadTagFieldTask running: waiting for active command to be equal 2 (ReadTagField).
                IF _progress = 312 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    IF Inputs.Status.ACTIVECMD = Outputs.Control.CMD THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                // ReadTagFieldTask running: waiting for the new data.
                IF _progress = 313 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    IF Inputs.Status.NDR <> _NDR_PV THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                // ReadTagFieldTask running: reading the data.
                IF _progress = 314 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#514;
                    END_IF;
    
                    FOR _index := INT#0 TO (TO_INT(Inputs.Status.BLOCKLENGTH) - INT#1) BY INT#1 DO
                        IF (_index + _dataBufferOffset) > Config.DataBufferHighIndex THEN
                            TaskMessenger.Activate( UINT#1302, eAxoMessageCategory#Error);
                            Status.Error.Id :=      UINT#1302;
                            RETURN;
                        ELSE
                            DataBuffer[ _index + _dataBufferOffset] := Inputs.Data[_index];
                        END_IF;
                    END_FOR;
                    _dataBufferOffset := _dataBufferOffset + TO_INT(Inputs.Status.BLOCKLENGTH);
                    IF Inputs.Status.BLOCK THEN
                        _NDR_PV := Inputs.Status.NDR;
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                // ReadTagFieldTask running: cleaning the tail of the data buffer.
                IF _progress = 315 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#515;
                    END_IF;
                    FOR _index := _dataBufferOffset TO Config.DataBufferHighIndex BY INT#1 DO
                        DataBuffer[_index] := BYTE#0;
                    END_FOR;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                // ReadTagFieldTask finished.
                IF _progress = 316 THEN
                    ReadTagFieldTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ReadTagFieldTask.ThrowWhen(_errorTimer.output OR Inputs.Status.ERROR_STARTUP);
                Status.Action.Id := TO_UINT(_progress);  
                ReadTagFieldTask.ThrowWhen(ReadTagFieldTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ReadTagFieldTask timeout.#>');                
            END_IF;
            IF ReadTagFieldTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadTagFieldTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF ReadTagFieldTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,ReadTagFieldTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,ReadTagFieldTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#112,ReadTagFieldTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ReadTagFieldTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************WriteTagFieldTask***************
            WriteTagFieldTask.SetIsDisabled(FALSE);
            IF WriteTagFieldTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,WriteTagFieldTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,WriteTagFieldTask.IsDone(), eAxoMessageCategory#Info);
            IF WriteTagFieldTask.Execute(THIS) THEN
                IF _progress = 0 THEN                    
                    Outputs.Control.RESET := FALSE;
                    Outputs.Control.STOP := FALSE;
                    Outputs.Control.ANTOFF := FALSE;
                    Outputs.Control.BLOCK := FALSE;
                    _index  := INT#0;
                    _dataBufferOffset := Config.DataBufferLowIndex;
                    _bytesToWrite := _writeTagFieldLength;
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
                // WriteTagFieldTask running: waiting for the tag presence.
                IF _progress = 320 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#520;
                    END_IF;
    
                    IF Inputs.Status.PRESENCE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
                // WriteTagFieldTask running: writing data header and first frame.
                IF _progress = 321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#521;
                    END_IF;
                    Outputs.Data[0] := _writeTagField.%B1;
                    Outputs.Data[1] := _writeTagField.%B0;

                    IF _bytesToWrite > (TO_UINT(Config.IOsize) - UINT#6) THEN
                        FOR _index := INT#0 TO (TO_INT(Config.IOsize) - INT#7) BY INT#1 DO
                            Outputs.Data[_index + INT#2] := DataBuffer[_index +_dataBufferOffset];
                        END_FOR;
                        _bytesToWrite       := _bytesToWrite     - TO_UINT(Config.IOsize)   + UINT#6;
                        _dataBufferOffset   := _dataBufferOffset + TO_INT(Config.IOsize)    - INT#6;
                        Outputs.Control.BLOCK := TRUE;
                    ELSE
                        FOR _index := INT#0 TO TO_INT(_bytesToWrite - UINT#1) BY INT#1 DO
                            Outputs.Data[_index + INT#2] := DataBuffer[_index + _dataBufferOffset];
                        END_FOR;
                        FOR _index := _bytesToWrite TO (TO_INT(Config.IOsize) - INT#7) BY INT#1 DO
                            Outputs.Data[_index + INT#2] := BYTE#0;
                        END_FOR;
                        _bytesToWrite := UINT#0;
                        Outputs.Control.BLOCK := FALSE;
                    END_IF;
                    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                // WriteTagFieldTask running: command triggered.
                IF _progress = 322 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#522;
                    END_IF;

                    _NDR_PV := Inputs.Status.NDR;

                    Outputs.Control.CMD := BYTE#3;   // WriteTagField command
                    IF TRUE THEN
                        Outputs.Control.START := NOT Outputs.Control.START;
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                // WriteTagFieldTask running: waiting for active command to be equal 3 (WriteTagField).
                IF _progress = 323 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#523;
                    END_IF;
    
                    IF Inputs.Status.ACTIVECMD = Outputs.Control.CMD OR TRUE THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                // WriteTagFieldTask running: waiting for the new data accepted.
                IF _progress = 324 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#524;
                    END_IF;
    
                    IF Inputs.Status.NDR <> _NDR_PV THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                // WriteTagFieldTask running: writing additional data frame.
                IF _progress = 325 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
                    IF _bytesToWrite > Config.IOsize - UINT#4 THEN
                        FOR _index := INT#0 TO (TO_INT(Config.IOsize) - INT#5) BY INT#1 DO
                            Outputs.Data[_index] := DataBuffer[_index +_dataBufferOffset];
                        END_FOR;
                        _bytesToWrite       := _bytesToWrite    - TO_UINT(Config.IOsize) + UINT#4;
                        _dataBufferOffset   := _dataBufferOffset + TO_INT(Config.IOsize) - INT#4;
                        Outputs.Control.BLOCK := TRUE;
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    ELSIF _bytesToWrite > UINT#0 THEN
                        FOR _index := INT#0 TO TO_INT(_bytesToWrite - UINT#1) BY INT#1 DO
                            Outputs.Data[_index] := DataBuffer[_index + _dataBufferOffset];
                        END_FOR;
                        FOR _index := _bytesToWrite TO (TO_INT(Config.IOsize) - INT#5) BY INT#1 DO
                            Outputs.Data[_index] := BYTE#0;
                        END_FOR;
                        _bytesToWrite := UINT#0;
                        Outputs.Control.BLOCK := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                // WriteTagFieldTask running: waiting for active command to be equal 3 (WriteTagField).
                IF _progress = 326 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#526;
                    END_IF;

                    // Outputs.Control.CMD := BYTE#0;

                    IF Inputs.Status.ACTIVECMD = Outputs.Control.CMD THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
                // WriteTagFieldTask finished.
                IF _progress = 327 THEN                                                                                     // WriteTagFieldTask running: , <add the detailed description of the current action 10>
                    WriteTagFieldTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                WriteTagFieldTask.ThrowWhen(_errorTimer.output OR Inputs.Status.ERROR_STARTUP);
                Status.Action.Id := TO_UINT(_progress);  
                WriteTagFieldTask.ThrowWhen(WriteTagFieldTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#WriteTagFieldTask timeout.#>');                
            END_IF;
            IF WriteTagFieldTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF WriteTagFieldTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF WriteTagFieldTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10020,WriteTagFieldTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,WriteTagFieldTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#122,WriteTagFieldTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF WriteTagFieldTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ReadTask***************
            ReadTask.SetIsDisabled(FALSE);
            IF ReadTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#130,ReadTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,ReadTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Outputs.Control.RESET := FALSE;
                    Outputs.Control.STOP := FALSE;
                    Outputs.Control.ANTOFF := FALSE;
                    Outputs.Control.BLOCK := FALSE;
                    _NDR_PV := Inputs.Status.NDR;
                    _index  := INT#0;
                    _dataBufferOffset := Config.DataBufferLowIndex;
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
                // ReadTask running: waiting for the tag presence.
                IF _progress = 330 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#530;
                    END_IF;
    
                    IF Inputs.Status.PRESENCE THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
                // ReadTask running: command triggered.
                IF _progress = 331 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#531;
                    END_IF;

                    Outputs.Control.CMD := BYTE#4;                      // Read command
                    Outputs.Data[0] := BYTE#0;  //_readTagField.%B1;    // Byte 4
                    Outputs.Data[1] := BYTE#0;  //_readTagField.%B0;    // Byte 5  
                    Outputs.Data[2] := _readAddress.%B3;                // Byte 6
                    Outputs.Data[3] := _readAddress.%B2;                // Byte 7
                    Outputs.Data[4] := _readAddress.%B1;                // Byte 8
                    Outputs.Data[5] := _readAddress.%B0;                // Byte 9
                    Outputs.Data[6] := _readLength.%B1;                 // Byte 10
                    Outputs.Data[7] := _readLength.%B0;                 // Byte 11
                    FOR _index := INT#8 TO (TO_INT(Config.IOsize) - INT#5) BY INT#1 DO
                        Outputs.Data[_index]  := BYTE#0;
                    END_FOR;
                    
                    _NDR_PV := Inputs.Status.NDR;

                    Outputs.Control.START := NOT Outputs.Control.START;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                // ReadTask running: waiting for active command to be equal 4 (Read).
                IF _progress = 332 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#532;
                    END_IF;
    
                    IF Inputs.Status.ACTIVECMD = Outputs.Control.CMD THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;
                // ReadTask running: waiting for the new data.
                IF _progress = 333 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#533, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#533;
                    END_IF;
    
                    IF Inputs.Status.NDR <> _NDR_PV THEN
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                // ReadTask running: reading the data.
                IF _progress = 334 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#534, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#534;
                    END_IF;
    
                    FOR _index := INT#0 TO TO_INT(Inputs.Status.BLOCKLENGTH) DO
                        IF (_index + _dataBufferOffset) > Config.DataBufferHighIndex THEN
                            TaskMessenger.Activate( UINT#1303, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#1303;
                            RETURN;
                        ELSE
                            DataBuffer[ _index + _dataBufferOffset] := Inputs.Data[_index];
                        END_IF;
                    END_FOR;
                    _dataBufferOffset := _dataBufferOffset + TO_INT(Inputs.Status.BLOCKLENGTH);
                    IF Inputs.Status.BLOCK THEN
                        _NDR_PV := Inputs.Status.NDR;
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                // ReadTask running: cleaning the tail of the data buffer.
                IF _progress = 335 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#535, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#535;
                    END_IF;

                    FOR _index := _dataBufferOffset TO Config.DataBufferHighIndex BY INT#1 DO
                        DataBuffer[_index] := BYTE#0;
                    END_FOR;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                // ReadTask finished.
                IF _progress = 336 THEN
                    ReadTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ReadTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ReadTask.ThrowWhen(ReadTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ReadTask timeout.#>');                
            END_IF;
            IF ReadTask.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10030;
                Status.Error.Id  :=  UINT#10030;
            ELSIF ReadTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10031;
                Status.Error.Id  :=  UINT#10031;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10030,ReadTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10031,ReadTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#132,ReadTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ReadTask.RestoreTriggered() AND _progress >= 330 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************WriteTask***************
            WriteTask.SetIsDisabled(FALSE);
            IF WriteTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#140,WriteTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,WriteTask.IsDone(), eAxoMessageCategory#Info);
            IF WriteTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Outputs.Control.RESET := FALSE;
                    Outputs.Control.STOP := FALSE;
                    Outputs.Control.ANTOFF := FALSE;
                    Outputs.Control.BLOCK := FALSE;
                    _index  := INT#0;
                    _dataBufferOffset := Config.DataBufferLowIndex;
                    _bytesToWrite := _writeLength;
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
                // WriteTask running: waiting for the tag presence.
                IF _progress = 340 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#540;
                    END_IF;
    
                    IF Inputs.Status.PRESENCE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;
                // WriteTask running: writing data header and first frame.
                IF _progress = 341 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#541;
                    END_IF;

                    Outputs.Data[0] := BYTE#0;  //_writeTagField.%B1;   // Byte 4
                    Outputs.Data[1] := BYTE#0;  //_writeTagField.%B0;   // Byte 5  
                    Outputs.Data[2] := _writeAddress.%B3;               // Byte 6
                    Outputs.Data[3] := _writeAddress.%B2;               // Byte 7
                    Outputs.Data[4] := _writeAddress.%B1;               // Byte 8
                    Outputs.Data[5] := _writeAddress.%B0;               // Byte 9
                    Outputs.Data[6] := _writeLength.%B1;                // Byte 10
                    Outputs.Data[7] := _writeLength.%B0;                // Byte 11

                    IF _bytesToWrite > (TO_UINT(Config.IOsize) - UINT#12) THEN
                        FOR _index := INT#0 TO (TO_INT(Config.IOsize) - INT#13) BY INT#1 DO
                            Outputs.Data[_index + INT#8] := DataBuffer[_index +_dataBufferOffset];
                        END_FOR;
                        _bytesToWrite       := _bytesToWrite     - TO_UINT(Config.IOsize)   + UINT#12;
                        _dataBufferOffset   := _dataBufferOffset + TO_INT(Config.IOsize)    - INT#12;
                        Outputs.Control.BLOCK := TRUE;
                    ELSE
                        FOR _index := INT#0 TO TO_INT(_bytesToWrite - UINT#1) BY INT#1 DO
                            Outputs.Data[_index + INT#8] := DataBuffer[_index + _dataBufferOffset];
                        END_FOR;
                        FOR _index := _bytesToWrite TO (TO_INT(Config.IOsize) - INT#13) BY INT#1 DO
                            Outputs.Data[_index + INT#8] := BYTE#0;
                        END_FOR;
                        _bytesToWrite := UINT#0;
                        Outputs.Control.BLOCK := FALSE;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                // WriteTask running: command triggered.
                IF _progress = 342 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#542;
                    END_IF;

                    _NDR_PV := Inputs.Status.NDR;

                    Outputs.Control.CMD := BYTE#5;                      // Write command
                    IF TRUE THEN
                        Outputs.Control.START := NOT Outputs.Control.START;
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                // WriteTask running: waiting for active command to be equal 5 (Write).
                IF _progress = 343 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#543, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#543;
                    END_IF;
    
                    IF Inputs.Status.ACTIVECMD = Outputs.Control.CMD OR TRUE THEN              
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                // WriteTask running: waiting for the new data accepted.
                IF _progress = 344 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#544, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#544;
                    END_IF;
    
                    IF Inputs.Status.NDR <> _NDR_PV THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    END_IF;
                END_IF;
                // WriteTask running: writing additional data frame.
                IF _progress = 345 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#545, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#545;
                    END_IF;
    
                    IF _bytesToWrite > Config.IOsize - UINT#4 THEN
                        FOR _index := INT#0 TO (TO_INT(Config.IOsize) - INT#5) BY INT#1 DO
                            Outputs.Data[_index] := DataBuffer[_index +_dataBufferOffset];
                        END_FOR;
                        _bytesToWrite       := _bytesToWrite    - TO_UINT(Config.IOsize) + UINT#4;
                        _dataBufferOffset   := _dataBufferOffset + TO_INT(Config.IOsize) - INT#4;
                        Outputs.Control.BLOCK := TRUE;
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    ELSIF _bytesToWrite > UINT#0 THEN
                        FOR _index := INT#0 TO TO_INT(_bytesToWrite - UINT#1) BY INT#1 DO
                            Outputs.Data[_index] := DataBuffer[_index + _dataBufferOffset];
                        END_FOR;
                        FOR _index := _bytesToWrite TO (TO_INT(Config.IOsize) - INT#5) BY INT#1 DO
                            Outputs.Data[_index] := BYTE#0;
                        END_FOR;
                        _bytesToWrite := UINT#0;
                        Outputs.Control.BLOCK := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 346;
                    END_IF;
                END_IF;
                // WriteTask running: waiting for active command to be equal 5 (Write).
                IF _progress = 346 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#546, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#546;
                    END_IF;
    
                    // Outputs.Control.CMD := BYTE#0;

                    IF Inputs.Status.ACTIVECMD = Outputs.Control.CMD THEN            
                        THIS.CallTimers(FALSE);
                        _progress := 347;
                    END_IF;
                END_IF;
                // WriteTask finished.
                IF _progress = 347 THEN                                                                                     // WriteTask running: , <add the detailed description of the current action 10>
                    WriteTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                WriteTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                WriteTask.ThrowWhen(WriteTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#WriteTask timeout.#>');                
            END_IF;
            IF WriteTask.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF WriteTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10040;
                Status.Error.Id  :=  UINT#10040;
            ELSIF WriteTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10041;
                Status.Error.Id  :=  UINT#10041;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10040,WriteTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10041,WriteTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#142,WriteTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF WriteTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349  THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ResetTask***************
            ResetTask.SetIsDisabled(FALSE);
            IF ResetTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#150,ResetTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,ResetTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Outputs.Control.START 			:=  FALSE;
                    Outputs.Control.RESET 			:=  FALSE;
                    Outputs.Control.STOP 			:=  FALSE;
                    Outputs.Control.ANTOFF 			:=  FALSE;
                    Outputs.Control.BLOCK 			:=  FALSE;
                    Outputs.Control.CMD 			:=  BYTE#0;
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;
                // ResetTask running: waiting for 'Inputs.Status.RESETCONF' to be on.
                IF _progress = 350 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#550;
                    END_IF;

                    Outputs.Control.RESET 			:=  TRUE;

                    IF Inputs.Status.RESETCONF THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
                // ResetTask running: waiting for 'Inputs.Status.RESETCONF' to be off.
                IF _progress = 351 THEN                                                                                     // ResetTask running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#551, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#551;
                    END_IF;

                    Outputs.Control.RESET 			:=  FALSE;

                    IF NOT Inputs.Status.RESETCONF THEN
                        THIS.CallTimers(FALSE);
                        _progress := 352;
                    END_IF;
                END_IF;
                // ResetTask finished.
                IF _progress = 352 THEN                                                                                     // ResetTask running: , <add the detailed description of the current action 10>
                    ResetTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ResetTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ResetTask.ThrowWhen(ResetTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ResetTask timeout.#>');                
            END_IF;
            IF ResetTask.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10050;
                Status.Error.Id  :=  UINT#10050;
            ELSIF ResetTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10051;
                Status.Error.Id  :=  UINT#10051;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10050,ResetTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10051,ResetTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#152,ResetTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ResetTask.RestoreTriggered() AND _progress >= 350 AND _progress <= 359  THEN
                Status.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;
            //**************************************************

            //***********Update outputs ****************
            _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HwID_CM),_data_out_2);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;         
            
            IF Config.IOsize = eAxoSimaticIdentCyclic_IOsize#BYTES_32 THEN
                _data_out_32[0].%X0      :=      Outputs.Control.START;
                _data_out_32[0].%X1      :=      Outputs.Control.RESET;
                _data_out_32[0].%X2      :=      Outputs.Control.STOP;
                _data_out_32[0].%X3      :=      Outputs.Control.ANTOFF;
                _data_out_32[0].%X4      :=      Outputs.Control.BLOCK;
                
                _data_out_32[2]          :=      Outputs.Control.CMD;

                FOR _index := INT#4 TO INT#31 DO
                    _data_out_32[_index] :=      Outputs.Data[_index - INT#4];
                END_FOR;


                _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HwID_Reader),_data_out_32);
                IF _retVal > WORD#0 THEN
                    Messenger.Activate(UINT#1232, eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1232;
                    RETURN;
                END_IF;
            ELSIF Config.IOsize = eAxoSimaticIdentCyclic_IOsize#BYTES_116 THEN
                _data_out_116[0].%X0      :=      Outputs.Control.START;
                _data_out_116[0].%X1      :=      Outputs.Control.RESET;
                _data_out_116[0].%X2      :=      Outputs.Control.STOP;
                _data_out_116[0].%X3      :=      Outputs.Control.ANTOFF;
                _data_out_116[0].%X4      :=      Outputs.Control.BLOCK;
                
                _data_out_116[2]          :=      Outputs.Control.CMD;

                FOR _index := INT#4 TO INT#115 DO
                    _data_out_116[_index] :=      Outputs.Data[_index - INT#4];
                END_FOR;

                _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HwID_Reader),_data_out_116);
                IF _retVal > WORD#0 THEN
                    Messenger.Activate(UINT#1233, eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1233;
                    RETURN;
                END_IF;
            ELSIF Config.IOsize = eAxoSimaticIdentCyclic_IOsize#BYTES_128 THEN
                _data_out_128[0].%X0      :=      Outputs.Control.START;
                _data_out_128[0].%X1      :=      Outputs.Control.RESET;
                _data_out_128[0].%X2      :=      Outputs.Control.STOP;
                _data_out_128[0].%X3      :=      Outputs.Control.ANTOFF;
                _data_out_128[0].%X4      :=      Outputs.Control.BLOCK;
                
                _data_out_128[2]          :=      Outputs.Control.CMD;

                _data_out_128[4]          :=      Outputs.Data[0];

                FOR _index := INT#4 TO INT#127 DO
                    _data_out_128[_index] :=      Outputs.Data[_index - INT#4];
                END_FOR;

                _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HwID_Reader),_data_out_128);
                IF _retVal > WORD#0 THEN
                    Messenger.Activate(UINT#1234, eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1234;
                    RETURN;
                END_IF;
            END_IF;
           
            //******************************************      

        END_METHOD

        METHOD PUBLIC ReadUID : IAxoTaskState
            ReadUID := ReadUID_Task.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ReadTagField : IAxoTaskState
            VAR_INPUT 
                TagField : UINT;
            END_VAR
            _readTagField := TagField;
            ReadTagField := ReadTagFieldTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC WriteTagField : IAxoTaskState
            VAR_INPUT 
                TagField : UINT;
                TagFieldLength : UINT;
            END_VAR
            _writeTagField := TagField;
            _writeTagFieldLength := TagFieldLength;
            WriteTagField := WriteTagFieldTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT 
                Address : UDINT;
                Length  : UINT;
            END_VAR
            _readAddress    :=  Address;
            _readLength     :=  Length;
            Read := ReadTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC Write : IAxoTaskState
            VAR_INPUT 
                Address : UDINT;
                Length  : UINT;
            END_VAR
            _writeAddress    :=  Address;
            _writeLength     :=  Length;
            Write := WriteTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC Reset : IAxoTaskState
            Reset := ResetTask.Invoke(THIS);
        END_METHOD


        METHOD PROTECTED OVERRIDE ManualControl
            _readTagField           := ReadTagFieldManual;
            _writeTagField          := WriteTagFieldManual;
            _writeTagFieldLength    := WriteTagFieldLengthManual;
            _readAddress            := ReadAddressManual;
            _readLength             := ReadLengthManual;
            _writeAddress           := WriteAddressManual;
            _writeLength            := WriteLengthManual;
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

            FOR _index := 0 TO 31 DO
                _data_in[_index] := BYTE#0;
                _data_out_32[_index] := BYTE#0;
                _data_out_116[_index] := BYTE#0;
                _data_out_128[_index] := BYTE#0;
                Inputs.Data[_index] := BYTE#0;
                Outputs.Data[_index] := BYTE#0;
            END_FOR;

            FOR _index := 32 TO 115 DO
                _data_in[_index] := BYTE#0;
                _data_out_116[_index] := BYTE#0;
                _data_out_128[_index] := BYTE#0;
                Inputs.Data[_index] := BYTE#0;
                Outputs.Data[_index] := BYTE#0;
            END_FOR;

            FOR _index := 116 TO 123 DO
                _data_in[_index] := BYTE#0;
                _data_out_128[_index] := BYTE#0;
                Inputs.Data[_index] := BYTE#0;
                Outputs.Data[_index] := BYTE#0;
            END_FOR;
            FOR _index := 124 TO 127 DO
                _data_in[_index] := BYTE#0;
                _data_out_128[_index] := BYTE#0;
            END_FOR;

            _word           :=   WORD#0;
            _dword          :=   DWORD#0;

            _NDR_PV                 :=  FALSE;
            _dataBufferOffset       :=  INT#0;
            _readTagField           :=  UINT#0;
            _writeTagField          :=  UINT#0;
            _writeTagFieldLength    :=  UINT#0;
            _bytesToWrite           :=  UINT#0;

            ReadUID_Task.Restore();
            ReadTagFieldTask.Restore();
            WriteTagFieldTask.Restore();
            ReadTask.Restore();
            WriteTask.Restore();
            ResetTask.Restore();
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




