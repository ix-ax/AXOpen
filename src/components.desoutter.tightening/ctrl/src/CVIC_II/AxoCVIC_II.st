USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;
USING System.Math;
USING System.BitAccess;
USING Siemens.Simatic.S71500.Hardware.Utilities;

NAMESPACE AXOpen.Components.Desoutter.Tightening
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoCVIC_II EXTENDS AXOpen.Core.AxoComponent
        VAR PRIVATE
            _RequiredScrewingProgram : BYTE;
            _infoTimer :  AXOpen.Timers.OnDelayTimer;
            _errorTimer :  AXOpen.Timers.OnDelayTimer;
            _hwID                   :   WORD;
            _hwId_Input_1_byte_1    :   WORD;
            _hwId_Input_1_byte_2    :   WORD;
            _hwId_Input_2_word_1    :   WORD;
            _hwId_Input_1_word_1    :   WORD;
            _hwId_Input_2_word_2    :   WORD;
            _hwId_Input_1_word_2    :   WORD;
            _hwId_Output_1_byte_1   :   WORD;
            _hwId_Output_1_byte_2   :   WORD;

            _tempDword  :   DWORD;
            _returnValue : WORD;
            _data_1 : ARRAY[0..0] OF BYTE;
            _data_2 : ARRAY[0..1] OF BYTE;
            _data_4 : ARRAY[0..3] OF BYTE;      
            
            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _startAddress           :   UDINT;
            _bytesCount             :   UINT;
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT; 
        END_VAR

        VAR PUBLIC  //HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#_progress#>"}
            _progress          :   INT;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Screwing program#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgram	:   BYTE;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Passed#>"}
            Passed          :   BOOL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Failed#>"}
            Failed         :   BOOL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Torque#>"}
            {#ix-attr:[ReadOnly()]}
            Torque	    :   REAL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Torque trend#>"}
            {#ix-attr:[ReadOnly()]}
            TorqueTrend	:   INT;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Angle#>"}
            {#ix-attr:[ReadOnly()]}
            Angle	    :   REAL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Angle trend#>"}
            {#ix-attr:[ReadOnly()]}
            AngleTrend	:   INT;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Reset#>"}
            ResetTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required screwing program#>"}
            RequiredScrewingProgram : BYTE;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Set screwing program#>"}
            SetScrewingProgramTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Start screwing#>"}
            StartScrewingTask : AXOpen.Core.AxoTask;


        END_VAR

        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoCVIC_II_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoCVIC_II_ComponentStatus;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC //HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoCVIC_II_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoCVIC_II_Out;
        END_VAR    

        VAR PUBLIC

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
                parent                  :   IAxoObject; 
                hwID                    :   WORD;
            END_VAR

            SUPER.Run(parent);
            Messenger.Serve(THIS);

            IF NOT _initHwCheckDone THEN
                IF parent = NULL THEN
                    Messenger.Activate(ULINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                IF hwID = WORD#0 THEN
                    Messenger.Activate(ULINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                _hwID                    := hwID;                                                      
                _retval := ReadSlotFromHardwareID(hardwareID := TO_UINT(_hwID), geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwId_Input_1_byte_1 :=  TO_WORD(_outHwid);                                         
                IF _hwId_Input_1_byte_1 = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_Input_1_byte_1 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwId_Input_1_byte_2 :=  TO_WORD(_outHwid);                                         
                IF _hwId_Input_1_byte_2 = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_Input_1_byte_2 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwId_Input_2_word_1 :=  TO_WORD(_outHwid);                                         
                IF _hwId_Input_2_word_1 = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_Input_2_word_1 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwId_Input_1_word_1 :=  TO_WORD(_outHwid);                                         
                IF _hwId_Input_1_word_1 = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_Input_1_word_1 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#2 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwId_Input_2_word_2 :=  TO_WORD(_outHwid);                                         
                IF _hwId_Input_2_word_2 = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_Input_2_word_2 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwId_Input_1_word_2 :=  TO_WORD(_outHwid);                                         
                IF _hwId_Input_1_word_2 = WORD#0 THEN
                    Messenger.Activate(UINT#760,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#760;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#761,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#761;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#762,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#762;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#763,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#763;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#764,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#764;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#765,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#765;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_Input_1_word_2 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#2 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwId_Output_1_byte_1 :=  TO_WORD(_outHwid);                                         
                IF _hwId_Output_1_byte_1 = WORD#0 THEN
                    Messenger.Activate(UINT#770,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#770;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#771,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#771;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#772,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#772;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#773,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#773;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#774,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#774;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#775,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#775;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_Output_1_byte_1 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#1 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                    RETURN;
                END_IF;                
                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwId_Output_1_byte_2 :=  TO_WORD(_outHwid);                                         
                IF _hwId_Output_1_byte_2 = WORD#0 THEN
                    Messenger.Activate(UINT#780,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#780;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#781,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#781;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#782,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#782;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#783,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#783;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#784,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#784;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#785,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#785;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_Output_1_byte_2 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#1 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#786;
                    RETURN;
                END_IF;


                IF parent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;

                IF _hwID  = WORD#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
            
                IF _hwId_Input_1_byte_1  = WORD#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
            
                IF _hwId_Input_1_byte_2  = WORD#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
            
                IF _hwId_Input_2_word_1  = WORD#0 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;

                IF _hwId_Input_1_word_1  = WORD#0 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;
            
                IF _hwId_Input_2_word_2  = WORD#0 THEN
                    Messenger.Activate(UINT#1136,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                END_IF;
            
                IF _hwId_Input_1_word_2  = WORD#0 THEN
                    Messenger.Activate(UINT#1137,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1137;
                    RETURN;
                END_IF;
            
                IF _hwId_Output_1_byte_1  = WORD#0 THEN
                    Messenger.Activate(UINT#1138,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1138;
                    RETURN;
                END_IF;
            
                IF _hwId_Output_1_byte_2  = WORD#0 THEN
                    Messenger.Activate(UINT#1139,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1139;
                    RETURN;
                END_IF;
            
                _initHwCheckDone    := TRUE;
            END_IF;            

            //*****************************************
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_1_byte_1 ,_data_1);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            Inputs.Status.CycleBit1         := _data_1[0].%X0;
            Inputs.Status.CycleBit2         := _data_1[0].%X1;
            Inputs.Status.CycleBit4         := _data_1[0].%X2;
            Inputs.Status.Ready             := _data_1[0].%X3;
            Inputs.Status.InCycle           := _data_1[0].%X4;
            Inputs.Status.Passed            := _data_1[0].%X5;
            Inputs.Status.Failed            := _data_1[0].%X6;
            Inputs.Status.NumberOfCyclesOk  := _data_1[0].%X7;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_1_byte_2 ,_data_1);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            Inputs.ScrewingProgram          := _data_1[0];

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_2_word_1 ,_data_4);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1203, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1203;
                RETURN;
            END_IF;

            System.Serialization.Deserialize(UINT#0,_data_4,Inputs.Torque);

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_1_word_1 ,_data_2);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1204, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1204;
                RETURN;
            END_IF;

            System.Serialization.Deserialize(UINT#0,_data_2,Inputs.TorqueTrend);

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_2_word_2 ,_data_4);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1205, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1205;
                RETURN;
            END_IF;

            System.Serialization.Deserialize(UINT#0,_data_4,Inputs.Angle);

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_Input_1_word_2 ,_data_2);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1206, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1206;
                RETURN;
            END_IF;

            System.Serialization.Deserialize(UINT#0,_data_2,Inputs.AngleTrend);

            //***********************************************//

            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            ResetTask.Run(THIS);
            SetScrewingProgramTask.Run(THIS);
            StartScrewingTask.Run(THIS);
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,_hwID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************RESET**********************
            ResetTask.SetIsDisabled(FALSE);
            IF ResetTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,ResetTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ResetTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;

                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;

                    Outputs.Control.SpindleValidation := FALSE;
                    Outputs.Control.StartCycle := FALSE;
                    Outputs.Control.Reset := TRUE;
                    Outputs.Control.Direction := FALSE;
                    Outputs.Control.ErrorAck := FALSE;
                    IF NOT Inputs.Status.Failed THEN
                        _progress := 301;
                    END_IF;
                END_IF;

                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;

                    IF NOT Inputs.Status.InCycle THEN
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    IF Inputs.Status.Ready THEN
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN
                    Outputs.Control.SpindleValidation := FALSE;
                    Outputs.Control.StartCycle := FALSE;
                    Outputs.Control.Reset := FALSE;
                    Outputs.Control.Direction := FALSE;
                    Outputs.Control.ErrorAck := FALSE;
                    ResetTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                THIS.CallTimers(TRUE);
                
                ResetTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ResetTask.ThrowWhen(ResetTask.Duration >= T#3S ,'Unable to reset the device.');
            END_IF;
            IF ResetTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF ResetTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,ResetTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,ResetTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ResetTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;

            //******************************************

            //*************SetScrewingProgram***********
            SetScrewingProgramTask.IsDisabled := FALSE;
            IF SetScrewingProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,SetScrewingProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,SetScrewingProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF SetScrewingProgramTask.Execute(THIS) THEN
                IF _RequiredScrewingProgram < Config.ScrewingProgramMin THEN
                    Status.Error.Id := UINT#1401;
                    RETURN;
                END_IF;
                IF _RequiredScrewingProgram > Config.ScrewingProgramMax THEN
                    Status.Error.Id := UINT#1402;
                    RETURN;
                END_IF; 

                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);      
                    _progress := 310;
                END_IF; 

                //Set program
                IF _progress = 310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;

                    Outputs.ScrewingProgram := _RequiredScrewingProgram;
                    
                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;

                IF _progress = 311 THEN
                    SetScrewingProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;

                SetScrewingProgramTask.ThrowWhen(SetScrewingProgramTask.Duration > Config.ProgramChangeTimeout, 'Unable to change the screwing program.');
                THIS.CallTimers(TRUE);
                
                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF SetScrewingProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF SetScrewingProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF SetScrewingProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,SetScrewingProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,SetScrewingProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,SetScrewingProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SetScrewingProgramTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //****************************************

            //*************StartScrewing**************
            StartScrewingTask.IsDisabled := FALSE;
            IF StartScrewingTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;
            IF StartScrewingTask.Execute(THIS) THEN
                IF _RequiredScrewingProgram < Config.ScrewingProgramMin THEN
                    Status.Error.Id := UINT#1401;
                    RETURN;
                END_IF;
                IF _RequiredScrewingProgram > Config.ScrewingProgramMax THEN
                    Status.Error.Id := UINT#1402;
                    RETURN;
                END_IF; 

                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF; 

                //Reset results
                IF _progress = 320 THEN
                    Outputs.Control.SpindleValidation := FALSE;
                    Outputs.Control.Reset := FALSE;
                    Outputs.Control.StartCycle := FALSE;
                    Passed := FALSE;
                    Failed := FALSE;
                    Torque	    :=  REAL#0.0;
                    TorqueTrend	:=  INT#0;
                    Angle	    :=  REAL#0.0;
                    AngleTrend	:=  INT#0;
                    THIS.CallTimers(FALSE);
                    _progress := 321;
                END_IF;

                //Check if program already set 
                IF _progress = 321 THEN
                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        _progress := 323;
                    ELSE
                        ScrewingProgram	:= BYTE#0;
                        _progress := 322;
                    END_IF;
                END_IF;

                //Set program
                IF _progress = 322 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#522;
                    END_IF;

                    Outputs.ScrewingProgram := _RequiredScrewingProgram;

                    IF _RequiredScrewingProgram = Inputs.ScrewingProgram THEN
                        ScrewingProgram	:= _RequiredScrewingProgram;
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;

                
                // wait for screwdriver ready
                IF _progress = 323 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#523;
                    END_IF;

                    IF (NOT Inputs.Status.InCycle) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;

                // wait for screwdriver ready
                IF _progress = 324 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#524;
                    END_IF;

                    IF (Inputs.Status.Ready ) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;

                // start screwing cycle 
                IF _progress = 325 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#525;
                    END_IF;

                    Outputs.Control.StartCycle := TRUE;
                    Outputs.Control.SpindleValidation := TRUE;
                    
                    IF (Inputs.Status.InCycle) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;

                // wait for screwing cycle end
                IF _progress = 326 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#526;
                    END_IF;
                    
                    IF (NOT Inputs.Status.InCycle ) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;

                
                // wait for screwing cycle end
                IF _progress = 327 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#527;
                    END_IF;

                    IF (Inputs.Status.Failed OR Inputs.Status.Passed) THEN
                        Outputs.Control.StartCycle := FALSE;
                        Outputs.Control.SpindleValidation := FALSE;
                        
                        Passed          := Inputs.Status.Passed;
                        Failed          := Inputs.Status.Failed;
                        Torque          := Inputs.Torque;
                        TorqueTrend     := Inputs.TorqueTrend;
                        Angle           := Inputs.Angle;
                        AngleTrend      := Inputs.AngleTrend;
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    END_IF;
                END_IF;

                // finished
                IF _progress = 328 THEN
                    _progress := 0;
                    StartScrewingTask.DoneWhen(TRUE);
                END_IF;

                StartScrewingTask.ThrowWhen(StartScrewingTask.Duration > Config.ScrewingCycleTimeout, 'Screwing cycle takes too long.');
                Status.Action.Id := TO_UINT(_progress);
                THIS.CallTimers(TRUE);
            END_IF;
            IF StartScrewingTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF StartScrewingTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF StartScrewingTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#10020,StartScrewingTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,StartScrewingTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,StartScrewingTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartScrewingTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;  
            //****************************************

            //***********************************************//
            _data_1[0].%X0         :=  Outputs.Control.CycleBit1;      
            _data_1[0].%X1         :=  Outputs.Control.CycleBit2;      
            _data_1[0].%X2         :=  Outputs.Control.CycleBit4;      
            _data_1[0].%X3         :=  Outputs.Control.SpindleValidation;      
            _data_1[0].%X4         :=  Outputs.Control.ErrorAck;      
            _data_1[0].%X5         :=  Outputs.Control.StartCycle;      
            _data_1[0].%X6         :=  Outputs.Control.Direction;      
            _data_1[0].%X7         :=  Outputs.Control.Reset;      

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwId_Output_1_byte_1,_data_1);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;

            _data_1[0]  :=  Outputs.ScrewingProgram;             

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwId_Output_1_byte_2,_data_1);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1232, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1232;
                RETURN;
            END_IF;

        END_METHOD   

        ///<summary>
        /// This method resets the device
        ///<summary>
        METHOD PUBLIC Reset : IAxoTaskState
            Reset    := ResetTask.Invoke(THIS);
        END_METHOD

        ///<summary>
        /// This method changes the screwing program
        ///<summary>
        METHOD PUBLIC SetScrewingProgram : IAxoTaskState
            VAR_INPUT
                ProgramNo : INT;
            END_VAR
            
            _RequiredScrewingProgram := TO_BYTE(ProgramNo);

            SetScrewingProgram    := SetScrewingProgramTask.Invoke(THIS);
        END_METHOD


        ///<summary>
        /// This method starts the screwing process
        ///<summary>
        METHOD PUBLIC StartScrewing : IAxoTaskState
            VAR_INPUT
                ProgramNo : INT;
            END_VAR
            
            _RequiredScrewingProgram := TO_BYTE(ProgramNo);

            StartScrewing    := StartScrewingTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC OVERRIDE Restore
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;

            ResetTask.Restore();
            SetScrewingProgramTask.Restore();
            StartScrewingTask.Restore();
            _progress := 0;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD
    
        METHOD PROTECTED OVERRIDE ManualControl
            _RequiredScrewingProgram := RequiredScrewingProgram;
            
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > LT#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > LT#0S , Config.ErrorTime);
        END_METHOD


    END_CLASS
END_NAMESPACE