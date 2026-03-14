USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;
USING Siemens.Simatic.DistributedIO;

NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoIOLinkET200SP_Balluff_IO EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Config#>"}
            ConfigTask : AXOpen.Core.AxoTask;            
        END_VAR
      
        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoIOLinkET200SP_Balluff_IO_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoIOLinkET200SP_Balluff_IO_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Progress       :   INT;            
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Tabs)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  AxoIOLinkET200SP_Balluff_IO_In;
        END_VAR    

        VAR PUBLIC // HARDWARE DIAGNOSTICS TASK
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PRIVATE
            _progress               :   INT;
            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _data_in_32             :   ARRAY[0..31] OF BYTE;
            _data_config_54         :   ARRAY[0..53] OF BYTE;

            _initHwCheckDone        :   BOOL;
            _initHwCheckDonePV      :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _blink                  :   AXOpen.Timers.AxoBlinker;   
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT; 
  
            _writeRecord            :   WriteRecord;  
            _readRecord             :   ReadRecord;  
            _readRecordLastLength    :   UINT;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent    :   IAxoObject;
                hwID        :   UINT;
                Port_1      :   eAxoIOLinkET200SP_Balluff_PortConfig;
                Port_2      :   eAxoIOLinkET200SP_Balluff_PortConfig;
                Port_3      :   eAxoIOLinkET200SP_Balluff_PortConfig;
                Port_4      :   eAxoIOLinkET200SP_Balluff_PortConfig;
            END_VAR

            VAR
                _inputOffset : INT;
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
    
                Config.Hwid := hwID;                                                      
                _retval := ReadSlotFromHardwareID(hardwareID := Config.Hwid, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot ******************//
                // _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.Hwid);        
                IF Config.Hwid = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.Hwid) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#32 OR _outputsCount <> UINT#32 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
 
                _initHwCheckDone    := TRUE;
            END_IF;            

            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            ConfigTask.Run(THIS);
    
            //************Config*******************
            IF _initHwCheckDone AND NOT _initHwCheckDonePV THEN
                ConfigTask.Invoke();
            END_IF;

            _initHwCheckDonePV := _initHwCheckDone;
          
            //********************Diagnostics*********       
            HardwareDiagnosticsTask.Run(THIS,Config.Hwid);
            //****************************************
    
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*****************ConfigTask*************
    
            ConfigTask.SetIsDisabled(FALSE);
            IF ConfigTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,ConfigTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ConfigTask.IsDone(), eAxoMessageCategory#Info);
            IF ConfigTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    Config.Port_1 := eAxoIOLinkET200SP_Balluff_PortConfig#NONE;
                    Config.Port_2 := eAxoIOLinkET200SP_Balluff_PortConfig#NONE;
                    Config.Port_3 := eAxoIOLinkET200SP_Balluff_PortConfig#NONE;
                    Config.Port_4 := eAxoIOLinkET200SP_Balluff_PortConfig#NONE;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                // ConfigTask running: datarecord 128 write running
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
                    _data_config_54[0]  := BYTE#16#04;
                    _data_config_54[1]  := BYTE#16#34;
                    _data_config_54[2]  := BYTE#16#01;
                    _data_config_54[3]  := BYTE#16#00;
                    _data_config_54[4]  := BYTE#16#0E;
                    _data_config_54[5]  := BYTE#16#04;
                    _data_config_54[6]  := BYTE#16#01;
                    IF Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 THEN
                        _data_config_54[7]  := BYTE#16#05;
                        _data_config_54[8]  := BYTE#16#02;
                        _data_config_54[9]  := BYTE#16#00;
                        _data_config_54[10] := BYTE#16#03;
                        _data_config_54[11] := BYTE#16#03;
                        _data_config_54[12] := BYTE#16#78;
                        _data_config_54[13] := BYTE#16#00;
                        _data_config_54[14] := BYTE#16#05;
                        _data_config_54[15] := BYTE#16#0B;
                        _data_config_54[16] := BYTE#16#60;
                        _data_config_54[17] := BYTE#16#00;
                    ELSIF Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 THEN
                        _data_config_54[7]  := BYTE#16#05;
                        _data_config_54[8]  := BYTE#16#03;
                        _data_config_54[9]  := BYTE#16#00;
                        _data_config_54[10] := BYTE#16#03;
                        _data_config_54[11] := BYTE#16#03;
                        _data_config_54[12] := BYTE#16#78;
                        _data_config_54[13] := BYTE#16#00;
                        _data_config_54[14] := BYTE#16#05;
                        _data_config_54[15] := BYTE#16#0B;
                        _data_config_54[16] := BYTE#16#61;
                        _data_config_54[17] := BYTE#16#00;
                    ELSIF Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY THEN
                        _data_config_54[7]  := BYTE#16#05;
                        _data_config_54[8]  := BYTE#16#03;
                        _data_config_54[9]  := BYTE#16#00;
                        _data_config_54[10] := BYTE#16#03;
                        _data_config_54[11] := BYTE#16#03;
                        _data_config_54[12] := BYTE#16#78;
                        _data_config_54[13] := BYTE#16#00;
                        _data_config_54[14] := BYTE#16#05;
                        _data_config_54[15] := BYTE#16#0D;
                        _data_config_54[16] := BYTE#16#40;
                        _data_config_54[17] := BYTE#16#00;
                    ELSIF Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                        _data_config_54[7]  := BYTE#16#05;
                        _data_config_54[8]  := BYTE#16#05;
                        _data_config_54[9]  := BYTE#16#00;
                        _data_config_54[10] := BYTE#16#03;
                        _data_config_54[11] := BYTE#16#03;
                        _data_config_54[12] := BYTE#16#78;
                        _data_config_54[13] := BYTE#16#00;
                        _data_config_54[14] := BYTE#16#05;
                        _data_config_54[15] := BYTE#16#0D;
                        _data_config_54[16] := BYTE#16#41;
                        _data_config_54[17] := BYTE#16#00;
                    ELSE
                        _data_config_54[7]  := BYTE#16#1C;
                        _data_config_54[8]  := BYTE#16#00;
                        _data_config_54[9]  := BYTE#16#00;
                        _data_config_54[10] := BYTE#16#00;
                        _data_config_54[11] := BYTE#16#00;
                        _data_config_54[12] := BYTE#16#00;
                        _data_config_54[13] := BYTE#16#00;
                        _data_config_54[14] := BYTE#16#00;
                        _data_config_54[15] := BYTE#16#00;
                        _data_config_54[16] := BYTE#16#00;
                        _data_config_54[17] := BYTE#16#00;
                    END_IF;
                    _data_config_54[18] := BYTE#16#02;
                    IF Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 THEN
                        _data_config_54[19] := BYTE#16#05;
                        _data_config_54[20] := BYTE#16#02;
                        _data_config_54[21] := BYTE#16#00;
                        _data_config_54[22] := BYTE#16#03;
                        _data_config_54[23] := BYTE#16#03;
                        _data_config_54[24] := BYTE#16#78;
                        _data_config_54[25] := BYTE#16#00;
                        _data_config_54[26] := BYTE#16#05;
                        _data_config_54[27] := BYTE#16#0B;
                        _data_config_54[28] := BYTE#16#60;
                        _data_config_54[29] := BYTE#16#00;
                    ELSIF Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 THEN
                        _data_config_54[19] := BYTE#16#05;
                        _data_config_54[20] := BYTE#16#03;
                        _data_config_54[21] := BYTE#16#00;
                        _data_config_54[22] := BYTE#16#03;
                        _data_config_54[23] := BYTE#16#03;
                        _data_config_54[24] := BYTE#16#78;
                        _data_config_54[25] := BYTE#16#00;
                        _data_config_54[26] := BYTE#16#05;
                        _data_config_54[27] := BYTE#16#0B;
                        _data_config_54[28] := BYTE#16#61;
                        _data_config_54[29] := BYTE#16#00;
                    ELSIF Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY THEN
                        _data_config_54[19] := BYTE#16#05;
                        _data_config_54[20] := BYTE#16#03;
                        _data_config_54[21] := BYTE#16#00;
                        _data_config_54[22] := BYTE#16#03;
                        _data_config_54[23] := BYTE#16#03;
                        _data_config_54[24] := BYTE#16#78;
                        _data_config_54[25] := BYTE#16#00;
                        _data_config_54[26] := BYTE#16#05;
                        _data_config_54[27] := BYTE#16#0D;
                        _data_config_54[28] := BYTE#16#40;
                        _data_config_54[29] := BYTE#16#00;
                    ELSIF Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                        _data_config_54[19] := BYTE#16#05;
                        _data_config_54[20] := BYTE#16#05;
                        _data_config_54[21] := BYTE#16#00;
                        _data_config_54[22] := BYTE#16#03;
                        _data_config_54[23] := BYTE#16#03;
                        _data_config_54[24] := BYTE#16#78;
                        _data_config_54[25] := BYTE#16#00;
                        _data_config_54[26] := BYTE#16#05;
                        _data_config_54[27] := BYTE#16#0D;
                        _data_config_54[28] := BYTE#16#41;
                        _data_config_54[29] := BYTE#16#00;
                    ELSE
                        _data_config_54[19] := BYTE#16#1C;
                        _data_config_54[20] := BYTE#16#00;
                        _data_config_54[21] := BYTE#16#00;
                        _data_config_54[22] := BYTE#16#00;
                        _data_config_54[23] := BYTE#16#00;
                        _data_config_54[24] := BYTE#16#00;
                        _data_config_54[25] := BYTE#16#00;
                        _data_config_54[26] := BYTE#16#00;
                        _data_config_54[27] := BYTE#16#00;
                        _data_config_54[28] := BYTE#16#00;
                        _data_config_54[29] := BYTE#16#00;
                    END_IF;
                    _data_config_54[30] := BYTE#16#03;
                    IF Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 THEN
                        _data_config_54[31] := BYTE#16#05;
                        _data_config_54[32] := BYTE#16#02;
                        _data_config_54[33] := BYTE#16#00;
                        _data_config_54[34] := BYTE#16#03;
                        _data_config_54[35] := BYTE#16#03;
                        _data_config_54[36] := BYTE#16#78;
                        _data_config_54[37] := BYTE#16#00;
                        _data_config_54[38] := BYTE#16#05;
                        _data_config_54[39] := BYTE#16#0B;
                        _data_config_54[40] := BYTE#16#60;
                        _data_config_54[41] := BYTE#16#00;
                    ELSIF Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 THEN
                        _data_config_54[31] := BYTE#16#05;
                        _data_config_54[32] := BYTE#16#03;
                        _data_config_54[33] := BYTE#16#00;
                        _data_config_54[34] := BYTE#16#03;
                        _data_config_54[35] := BYTE#16#03;
                        _data_config_54[36] := BYTE#16#78;
                        _data_config_54[37] := BYTE#16#00;
                        _data_config_54[38] := BYTE#16#05;
                        _data_config_54[39] := BYTE#16#0B;
                        _data_config_54[40] := BYTE#16#61;
                        _data_config_54[41] := BYTE#16#00;
                    ELSIF Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY THEN
                        _data_config_54[31] := BYTE#16#05;
                        _data_config_54[32] := BYTE#16#03;
                        _data_config_54[33] := BYTE#16#00;
                        _data_config_54[34] := BYTE#16#03;
                        _data_config_54[35] := BYTE#16#03;
                        _data_config_54[36] := BYTE#16#78;
                        _data_config_54[37] := BYTE#16#00;
                        _data_config_54[38] := BYTE#16#05;
                        _data_config_54[39] := BYTE#16#0D;
                        _data_config_54[40] := BYTE#16#40;
                        _data_config_54[41] := BYTE#16#00;
                    ELSIF Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                        _data_config_54[31] := BYTE#16#05;
                        _data_config_54[32] := BYTE#16#05;
                        _data_config_54[33] := BYTE#16#00;
                        _data_config_54[34] := BYTE#16#03;
                        _data_config_54[35] := BYTE#16#03;
                        _data_config_54[36] := BYTE#16#78;
                        _data_config_54[37] := BYTE#16#00;
                        _data_config_54[38] := BYTE#16#05;
                        _data_config_54[39] := BYTE#16#0D;
                        _data_config_54[40] := BYTE#16#41;
                        _data_config_54[41] := BYTE#16#00;
                    ELSE
                        _data_config_54[31] := BYTE#16#1C;
                        _data_config_54[32] := BYTE#16#00;
                        _data_config_54[33] := BYTE#16#00;
                        _data_config_54[34] := BYTE#16#00;
                        _data_config_54[35] := BYTE#16#00;
                        _data_config_54[36] := BYTE#16#00;
                        _data_config_54[37] := BYTE#16#00;
                        _data_config_54[38] := BYTE#16#00;
                        _data_config_54[39] := BYTE#16#00;
                        _data_config_54[40] := BYTE#16#00;
                        _data_config_54[41] := BYTE#16#00;
                    END_IF;
                    _data_config_54[42] := BYTE#16#04;
                    IF Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 THEN
                        _data_config_54[43] := BYTE#16#05;
                        _data_config_54[44] := BYTE#16#02;
                        _data_config_54[45] := BYTE#16#00;
                        _data_config_54[46] := BYTE#16#03;
                        _data_config_54[47] := BYTE#16#03;
                        _data_config_54[48] := BYTE#16#78;
                        _data_config_54[49] := BYTE#16#00;
                        _data_config_54[50] := BYTE#16#05;
                        _data_config_54[51] := BYTE#16#0B;
                        _data_config_54[52] := BYTE#16#60;
                        _data_config_54[53] := BYTE#16#00;
                    ELSIF Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 THEN
                        _data_config_54[43] := BYTE#16#05;
                        _data_config_54[44] := BYTE#16#03;
                        _data_config_54[45] := BYTE#16#00;
                        _data_config_54[46] := BYTE#16#03;
                        _data_config_54[47] := BYTE#16#03;
                        _data_config_54[48] := BYTE#16#78;
                        _data_config_54[49] := BYTE#16#00;
                        _data_config_54[50] := BYTE#16#05;
                        _data_config_54[51] := BYTE#16#0B;
                        _data_config_54[52] := BYTE#16#61;
                        _data_config_54[53] := BYTE#16#00;
                    ELSIF Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY THEN
                        _data_config_54[43] := BYTE#16#05;
                        _data_config_54[44] := BYTE#16#03;
                        _data_config_54[45] := BYTE#16#00;
                        _data_config_54[46] := BYTE#16#03;
                        _data_config_54[47] := BYTE#16#03;
                        _data_config_54[48] := BYTE#16#78;
                        _data_config_54[49] := BYTE#16#00;
                        _data_config_54[50] := BYTE#16#05;
                        _data_config_54[51] := BYTE#16#0D;
                        _data_config_54[52] := BYTE#16#40;
                        _data_config_54[53] := BYTE#16#00;
                    ELSIF Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                        _data_config_54[43] := BYTE#16#05;
                        _data_config_54[44] := BYTE#16#05;
                        _data_config_54[45] := BYTE#16#00;
                        _data_config_54[46] := BYTE#16#03;
                        _data_config_54[47] := BYTE#16#03;
                        _data_config_54[48] := BYTE#16#78;
                        _data_config_54[49] := BYTE#16#00;
                        _data_config_54[50] := BYTE#16#05;
                        _data_config_54[51] := BYTE#16#0D;
                        _data_config_54[52] := BYTE#16#41;
                        _data_config_54[53] := BYTE#16#00;
                    ELSE
                        _data_config_54[43] := BYTE#16#1C;
                        _data_config_54[44] := BYTE#16#00;
                        _data_config_54[45] := BYTE#16#00;
                        _data_config_54[46] := BYTE#16#00;
                        _data_config_54[47] := BYTE#16#00;
                        _data_config_54[48] := BYTE#16#00;
                        _data_config_54[49] := BYTE#16#00;
                        _data_config_54[50] := BYTE#16#00;
                        _data_config_54[51] := BYTE#16#00;
                        _data_config_54[52] := BYTE#16#00;
                        _data_config_54[53] := BYTE#16#00;
                    END_IF;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#128, 
                                    length      :=  UINT#54, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                // ConfigTask running: datarecord 128 write reset
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#501;
                    END_IF;

                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                // ConfigTask running: Port 1 
                IF _progress = 302 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#502;
                    END_IF;
                   
                    IF Port_1 <> eAxoIOLinkET200SP_Balluff_PortConfig#NONE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 1 Index 55 running
                IF _progress = 303 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#503;
                    END_IF;

                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#1;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#2;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#85;                     
                    _data_config_54[7]  := BYTE#0;                      
                    IF Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 OR Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                        _data_config_54[8]  := BYTE#1;
                    ELSE
                        _data_config_54[8]  := BYTE#0;
                    END_IF;
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#9, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 1 Index 55 reset
                IF _progress = 304 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#504;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 1 Index 2 running
                IF _progress = 305 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#505;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#1;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#2;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#2;                     
                    _data_config_54[7]  := BYTE#0;                      
                    _data_config_54[8]  := BYTE#5;                      
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#9, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 1 Index 2 reset
                IF _progress = 306 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#506, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#506;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 307;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write read request Port 1 Index 55 running
                IF _progress = 307 THEN                           
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#507, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#507;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#1;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#3;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#85;                     
                    _data_config_54[7]  := BYTE#0;                      
                    _data_config_54[8]  := BYTE#255;
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#8, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 308;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write read request Port 1 Index 55 reset
                IF _progress = 308 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#508, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#508;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 309;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter read Port 1 Index 55 running
                IF _progress = 309 THEN                    
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#509, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#509;
                    END_IF;
    
                    _readRecord(request     :=  TRUE, 
                                hardwareID  :=  HwID,       
                                index       :=  DINT#227,   
                                maxLength   :=  UINT#12,    
                                record      :=  _data_config_54);
                    
                    // TODO: error handling

                    IF _readRecord.valid AND NOT _readRecord.error THEN
                        _readRecordLastLength := _readRecord.length;
                        _progress := 310;
                        THIS.CallTimers(FALSE);
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter read Port 1 Index 55 reset
                IF _progress = 310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
    
                    _readRecord(request := FALSE, record := _data_config_54);
                    
                    IF NOT _readRecord.valid AND NOT _readRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter Port 1 Index 55 compare
                IF _progress = 311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#511;
                    END_IF;

                    IF _readRecordLastLength <> UINT#9 THEN
                        _progress := 302;
                    ELSE
                        IF (Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 OR 
                            Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY AND 
                            _data_config_54[8] = BYTE#1) OR
                            (Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 OR 
                            Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY AND 
                            _data_config_54[8] = BYTE#0) THEN
                            THIS.CallTimers(FALSE);
                            Config.Port_1 := Port_1;
                            _progress := 312;
                        ELSE
                            TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Error);
                            Status.Error.Id :=      UINT#511;
                            END_IF;
                    END_IF;
                END_IF;
                // ConfigTask running: Port 2 
                IF _progress = 312 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
                   
                    IF Port_2 <> eAxoIOLinkET200SP_Balluff_PortConfig#NONE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;                
                // ConfigTask running: ISDU parameter write Port 2 Index 55 running
                IF _progress = 313 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#2;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#2;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#85;                     
                    _data_config_54[7]  := BYTE#0;                      
                    IF Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 OR Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                        _data_config_54[8]  := BYTE#1;
                    ELSE
                        _data_config_54[8]  := BYTE#0;
                    END_IF;
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#9, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 2 Index 55 reset
                IF _progress = 314 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#514;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 2 Index 2 running
                IF _progress = 315 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#515;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#2;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#2;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#2;                     
                    _data_config_54[7]  := BYTE#0;                      
                    _data_config_54[8]  := BYTE#5;                      
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#9, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 2 Index 2 reset
                IF _progress = 316 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#516;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write read request Port 2 Index 55 running
                IF _progress = 317 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#517;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#2;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#3;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#85;                     
                    _data_config_54[7]  := BYTE#0;                      
                    _data_config_54[8]  := BYTE#255;
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#8, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write read request Port 2 Index 55 reset
                IF _progress = 318 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#518;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 319;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter read Port 2 Index 55 running
                IF _progress = 319 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#519, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#519;
                    END_IF;
    
                    _readRecord(request     :=  TRUE, 
                                hardwareID  :=  HwID,       
                                index       :=  DINT#227,   
                                maxLength   :=  UINT#12,    
                                record      :=  _data_config_54);
                    
                    // TODO: error handling
                    IF _readRecord.valid AND NOT _readRecord.error THEN
                        _readRecordLastLength := _readRecord.length;
                        _progress := 320;
                        THIS.CallTimers(FALSE);
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter read Port 2 Index 55 reset
                IF _progress = 320 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#520;
                    END_IF;
    
                    _readRecord(request := FALSE, record := _data_config_54);
                    
                    IF NOT _readRecord.valid AND NOT _readRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter Port 2 Index 55 compare
                IF _progress = 321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#521;
                    END_IF;

                    IF _readRecordLastLength <> UINT#9 THEN
                        _progress := 312;
                    ELSE
                        IF (Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 OR 
                            Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY AND 
                            _data_config_54[8] = BYTE#1) OR
                            (Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 OR 
                             Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY AND 
                            _data_config_54[8] = BYTE#0) THEN
                            THIS.CallTimers(FALSE);
                            Config.Port_2 := Port_2;
                            _progress := 322;
                        ELSE
                            ; // TODO: Error message
                        END_IF;
                    END_IF;
                END_IF;
                // ConfigTask running: Port 3 
                IF _progress = 322 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#522;
                    END_IF;
                   
                    IF Port_3 <> eAxoIOLinkET200SP_Balluff_PortConfig#NONE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;                
                // ConfigTask running: ISDU parameter write Port 3 Index 55 running
                IF _progress = 323 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#523;
                    END_IF;

                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#3;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#2;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#85;                     
                    _data_config_54[7]  := BYTE#0;                      
                    IF Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 OR Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                        _data_config_54[8]  := BYTE#1;
                    ELSE
                        _data_config_54[8]  := BYTE#0;
                    END_IF;
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#9, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 3 Index 55 reset
                IF _progress = 324 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#524;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 3 Index 2 running
                IF _progress = 325 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#3;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#2;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#2;                     
                    _data_config_54[7]  := BYTE#0;                      
                    _data_config_54[8]  := BYTE#5;                      
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#9, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 3 Index 2 reset
                IF _progress = 326 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#526;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write read request Port 3 Index 55 running
                IF _progress = 327 THEN                           
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#527;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#3;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#3;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#85;                     
                    _data_config_54[7]  := BYTE#0;                      
                    _data_config_54[8]  := BYTE#255;
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#8, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write read request Port 3 Index 55 reset
                IF _progress = 328 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#528, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#528;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 329;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter read Port 3 Index 55 running
                IF _progress = 329 THEN                    
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#529, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#529;
                    END_IF;
    
                    _readRecord(request     :=  TRUE, 
                                hardwareID  :=  HwID,       
                                index       :=  DINT#227,   
                                maxLength   :=  UINT#12,    
                                record      :=  _data_config_54);
                    
                    // TODO: error handling

                    IF _readRecord.valid AND NOT _readRecord.error THEN
                        _readRecordLastLength := _readRecord.length;
                        _progress := 330;
                        THIS.CallTimers(FALSE);
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter read Port 3 Index 55 reset
                IF _progress = 330 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#530;
                    END_IF;
    
                    _readRecord(request := FALSE, record := _data_config_54);
                    
                    IF NOT _readRecord.valid AND NOT _readRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter Port 3 Index 55 compare
                IF _progress = 331 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#531;
                    END_IF;

                    IF _readRecordLastLength <> UINT#9 THEN
                        _progress := 322;
                    ELSE
                        IF (Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 OR 
                            Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY AND 
                            _data_config_54[8] = BYTE#1) OR
                            (Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 OR 
                             Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY AND 
                            _data_config_54[8] = BYTE#0) THEN
                            THIS.CallTimers(FALSE);
                            Config.Port_3 := Port_3;
                            _progress := 332;
                        ELSE
                            ; // TODO: Error message
                        END_IF;
                    END_IF;
                END_IF;
                // ConfigTask running: Port 4 
                IF _progress = 332 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#532;
                    END_IF;
                   
                    IF Port_4 <> eAxoIOLinkET200SP_Balluff_PortConfig#NONE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;                
                // ConfigTask running: ISDU parameter write Port 4 Index 55 running
                IF _progress = 333 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#533, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#533;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#4;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#2;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#85;                     
                    _data_config_54[7]  := BYTE#0;                      
                    IF Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 OR Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                        _data_config_54[8]  := BYTE#1;
                    ELSE
                        _data_config_54[8]  := BYTE#0;
                    END_IF;
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#9, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 4 Index 55 reset
                IF _progress = 334 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#534, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#534;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 4 Index 2 running
                IF _progress = 335 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#535, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#535;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#4;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#2;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#2;                     
                    _data_config_54[7]  := BYTE#0;                      
                    _data_config_54[8]  := BYTE#5;                      
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#9, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write Port 4 Index 2 reset
                IF _progress = 336 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#536, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#536;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 337;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write read request Port 4 Index 55 running
                IF _progress = 337 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#537, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#537;
                    END_IF;
    
                    _data_config_54[0]  := BYTE#8;                      
                    _data_config_54[1]  := BYTE#4;                      
                    _data_config_54[2]  := BYTE#254;                    
                    _data_config_54[3]  := BYTE#74;                     
                    _data_config_54[4]  := BYTE#3;                      
                    _data_config_54[5]  := BYTE#0;                      
                    _data_config_54[6]  := BYTE#85;                     
                    _data_config_54[7]  := BYTE#0;                      
                    _data_config_54[8]  := BYTE#255;
                    _data_config_54[9]  := BYTE#0;
                    _data_config_54[10] := BYTE#0;
                    _data_config_54[11] := BYTE#0;

                    _writeRecord(   request     :=  TRUE,
                                    hardwareID  :=  Config.Hwid, 
                                    index       :=  DINT#227, 
                                    length      :=  UINT#8, 
                                    record      :=  _data_config_54);

                    // TODO: error handling
                    IF _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 338;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter write read request Port 4 Index 55 reset
                IF _progress = 338 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#538, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#538;
                    END_IF;
    
                    _writeRecord(request := FALSE, record := _data_config_54);

                    IF NOT _writeRecord.done AND NOT _writeRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 339;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter read Port 4 Index 55 running
                IF _progress = 339 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#539, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#539;
                    END_IF;
    
                    _readRecord(request     :=  TRUE, 
                                hardwareID  :=  HwID,       
                                index       :=  DINT#227,   
                                maxLength   :=  UINT#12,    
                                record      :=  _data_config_54);
                    
                    // TODO: error handling
                    IF _readRecord.valid AND NOT _readRecord.error THEN
                        _readRecordLastLength := _readRecord.length;
                        _progress := 340;
                        THIS.CallTimers(FALSE);
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter read Port 4 Index 55 reset
                IF _progress = 340 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#540;
                    END_IF;
    
                    _readRecord(request := FALSE, record := _data_config_54);
                    
                    IF NOT _readRecord.valid AND NOT _readRecord.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;
                // ConfigTask running: ISDU parameter Port 4 Index 55 compare
                IF _progress = 341 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#541;
                    END_IF;

                    IF _readRecordLastLength <> UINT#9 THEN
                        _progress := 332;
                    ELSE
                        IF (Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 OR 
                            Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY AND 
                            _data_config_54[8] = BYTE#1) OR
                            (Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 OR 
                             Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY AND 
                            _data_config_54[8] = BYTE#0) THEN
                            THIS.CallTimers(FALSE);
                            Config.Port_4 := Port_4;
                            _progress := 342;
                        ELSE
                            ; // TODO: Error message
                        END_IF;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#542;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 379;
                    END_IF;
                END_IF;
                
                IF _progress = 379 THEN 
                    ConfigTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ConfigTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ConfigTask.ThrowWhen(ConfigTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ConfigTask timeout.#>');                
            END_IF;
            IF ConfigTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ConfigTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF ConfigTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,ConfigTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,ConfigTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ConfigTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ConfigTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 379  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************            
            IF NOT ConfigTask.IsDone() THEN
                RETURN;
            END_IF;

            //***********Update inputs **************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.Hwid) ,_data_in_32);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;
            _inputOffset := INT#0;
            
            IF Config.Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 THEN
                Inputs.C1.PortStatus := _data_in_32[_inputOffset + INT#1];
                IF Inputs.C1.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],BYTE#0,Inputs.C1.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#2;
            ELSIF Config.Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 THEN
                Inputs.C1.PortStatus := _data_in_32[_inputOffset + INT#2];
                IF Inputs.C1.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],BYTE#0,Inputs.C1.Box1);
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset + INT#1], BYTE#0,Inputs.C1.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#3;
            ELSIF Config.Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY THEN
                Inputs.C1.PortStatus := _data_in_32[_inputOffset + INT#2];
                IF Inputs.C1.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],_data_in_32[_inputOffset + INT#1],Inputs.C1.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#3;
            ELSIF Config.Port_1 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                Inputs.C1.PortStatus := _data_in_32[_inputOffset + INT#4];
                IF Inputs.C1.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],_data_in_32[_inputOffset + INT#1],Inputs.C1.Box1);
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset + INT#2],_data_in_32[_inputOffset + INT#3],Inputs.C1.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#5;
            ELSE
                Inputs.C1.PortStatus := BYTE#255;
                THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box1);
                THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C1.Box2);
            END_IF;

            IF Config.Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 THEN
                Inputs.C2.PortStatus := _data_in_32[_inputOffset + INT#1];
                IF Inputs.C2.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],BYTE#0,Inputs.C2.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#2;
            ELSIF Config.Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 THEN
                Inputs.C2.PortStatus := _data_in_32[_inputOffset + INT#2];
                IF Inputs.C2.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],BYTE#0,Inputs.C2.Box1);
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset + INT#1], BYTE#0,Inputs.C2.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#3;
            ELSIF Config.Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY THEN
                Inputs.C2.PortStatus := _data_in_32[_inputOffset + INT#2];
                IF Inputs.C2.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],_data_in_32[_inputOffset + INT#1],Inputs.C2.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#3;
            ELSIF Config.Port_2 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                Inputs.C2.PortStatus := _data_in_32[_inputOffset + INT#4];
                IF Inputs.C2.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],_data_in_32[_inputOffset + INT#1],Inputs.C2.Box1);
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset + INT#2],_data_in_32[_inputOffset + INT#3],Inputs.C2.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#5;
            ELSE
                Inputs.C2.PortStatus := BYTE#255;
                THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box1);
                THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C2.Box2);
            END_IF;

            IF Config.Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 THEN
                Inputs.C3.PortStatus := _data_in_32[_inputOffset + INT#1];
                IF Inputs.C3.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],BYTE#0,Inputs.C3.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#2;
            ELSIF Config.Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 THEN
                Inputs.C3.PortStatus := _data_in_32[_inputOffset + INT#2];
                IF Inputs.C3.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],BYTE#0,Inputs.C3.Box1);
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset + INT#1], BYTE#0,Inputs.C3.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#3;
            ELSIF Config.Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY THEN
                Inputs.C3.PortStatus := _data_in_32[_inputOffset + INT#2];
                IF Inputs.C3.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],_data_in_32[_inputOffset + INT#1],Inputs.C3.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#3;
            ELSIF Config.Port_3 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                Inputs.C3.PortStatus := _data_in_32[_inputOffset + INT#4];
                IF Inputs.C3.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],_data_in_32[_inputOffset + INT#1],Inputs.C3.Box1);
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset + INT#2],_data_in_32[_inputOffset + INT#3],Inputs.C3.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#5;
            ELSE
                Inputs.C3.PortStatus := BYTE#255;
                THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box1);
                THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C3.Box2);
            END_IF;

            IF Config.Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099 THEN
                Inputs.C4.PortStatus := _data_in_32[_inputOffset + INT#1];
                IF Inputs.C4.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],BYTE#0,Inputs.C4.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#2;
            ELSIF Config.Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099_BNI0099 THEN
                Inputs.C4.PortStatus := _data_in_32[_inputOffset + INT#2];
                IF Inputs.C4.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],BYTE#0,Inputs.C4.Box1);
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset + INT#1], BYTE#0,Inputs.C4.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#3;
            ELSIF Config.Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY THEN
                Inputs.C4.PortStatus := _data_in_32[_inputOffset + INT#2];
                IF Inputs.C4.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],_data_in_32[_inputOffset + INT#1],Inputs.C4.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#3;
            ELSIF Config.Port_4 = eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY_BNI00AY THEN
                Inputs.C4.PortStatus := _data_in_32[_inputOffset + INT#4];
                IF Inputs.C4.PortStatus = BYTE#16#A0 THEN
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset],_data_in_32[_inputOffset + INT#1],Inputs.C4.Box1);
                    THIS.BytesToBox(THIS,_data_in_32[_inputOffset + INT#2],_data_in_32[_inputOffset + INT#3],Inputs.C4.Box2);
                ELSE
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box1);
                    THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box2);
                END_IF;
                _inputOffset := _inputOffset + INT#5;
            ELSE
                Inputs.C4.PortStatus := BYTE#255;
                THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box1);
                THIS.BytesToBox(THIS,BYTE#0,BYTE#0,Inputs.C4.Box2);
            END_IF;
            
            //******************************************      

        END_METHOD

        METHOD PRIVATE BytesToBox
            VAR_INPUT
                inParent    :   IAxoObject;
                in1         :   BYTE;
                in2         :   BYTE;
            END_VAR
            VAR_IN_OUT
                ino         :   AxoIOLinkET200SP_Balluff_IO_Box;
            END_VAR
            ino.In[0]   :=  in1.%X0;
            ino.In[1]   :=  in1.%X1;
            ino.In[2]   :=  in1.%X2;
            ino.In[3]   :=  in1.%X3;
            ino.In[4]   :=  in1.%X4;
            ino.In[5]   :=  in1.%X5;
            ino.In[6]   :=  in1.%X6;
            ino.In[7]   :=  in1.%X7;
            ino.In[8]   :=  in2.%X0;
            ino.In[9]   :=  in2.%X1;
            ino.In[10]  :=  in2.%X2;
            ino.In[11]  :=  in2.%X3;
            ino.In[12]  :=  in2.%X4;
            ino.In[13]  :=  in2.%X5;
            ino.In[14]  :=  in2.%X6;
            ino.In[15]  :=  in2.%X7;
        END_METHOD

        METHOD PUBLIC Configure : IAxoTaskState
            Configure := ConfigTask.Invoke(THIS);
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

            FOR _index := 0 TO 31 DO
                _data_in_32[_index] := BYTE#0;
                _data_config_54[_index] := BYTE#0;
            END_FOR;
            FOR _index := 32 TO 53 DO
                _data_config_54[_index] := BYTE#0;
            END_FOR;

            ConfigTask.Restore();

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
