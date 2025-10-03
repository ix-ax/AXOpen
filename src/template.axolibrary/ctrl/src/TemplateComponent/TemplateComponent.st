USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.S71500.Hardware.Utilities;

NAMESPACE Template.Axolibrary
    {S7.extern=ReadWrite}
    CLASS TemplateComponent EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[ReadOnly()]}
            Progress       :   INT;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC // TEMPLATE TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_1#>"}
            TemplateTask_10steps_1 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_2#>"}
            TemplateTask_10steps_2 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_3#>"}
            TemplateTask_10steps_3 : AXOpen.Core.AxoTask;
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
            Config  :   TemplateComponent_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   TemplateComponent_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  TemplateComponent_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   TemplateComponent_Out;
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
            _data_in        :   ARRAY[0..254] OF BYTE;
            _data_out_1     :   ARRAY[0..0] OF BYTE;
            _data_out_2     :   ARRAY[0..1] OF BYTE;
            _data_out_4     :   ARRAY[0..3] OF BYTE;
            _data_out_8     :   ARRAY[0..7] OF BYTE;
            _data_out_255   :   ARRAY[0..254] OF BYTE;
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
        END_VAR


        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent    :   IAxoObject;
                hwID        :   UINT;
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
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_1);        
                IF Config.HWIDs.HwID_in_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_2);        
                IF Config.HWIDs.HwID_in_2 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_3);        
                IF Config.HWIDs.HwID_in_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_3) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_4);        
                IF Config.HWIDs.HwID_in_4 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_4) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_5);        
                IF Config.HWIDs.HwID_in_5 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_5) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_6);        
                IF Config.HWIDs.HwID_in_6 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_6) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_7);        
                IF Config.HWIDs.HwID_in_7 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_7) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                    RETURN;
                END_IF;
                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_8);        
                IF Config.HWIDs.HwID_in_8 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_8) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#786;
                    RETURN;
                END_IF;
                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_9);        
                IF Config.HWIDs.HwID_in_9 = UINT#0 THEN
                    Messenger.Activate(UINT#790,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#790;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#791,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#791;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#792,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#792;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#793,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#793;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#794,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#794;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#795,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#795;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_9) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#796,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#796;
                    RETURN;
                END_IF;
                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_10);        
                IF Config.HWIDs.HwID_in_10 = UINT#0 THEN
                    Messenger.Activate(UINT#800,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#800;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#801,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#801;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#802,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#802;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#803,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#803;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#804,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#804;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#805,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#805;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_10) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#806,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#806;
                    RETURN;
                END_IF;
                //******************Slot 11*****************//
                _geoAddr.Slot   :=  UINT#11;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_11);        
                IF Config.HWIDs.HwID_in_11 = UINT#0 THEN
                    Messenger.Activate(UINT#810,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#810;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#811,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#811;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#812,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#812;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#813,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#813;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#814,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#814;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#815,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#815;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_11) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#816,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#816;
                    RETURN;
                END_IF;
                //******************Slot 12*****************//
                _geoAddr.Slot   :=  UINT#12;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_12);        
                IF Config.HWIDs.HwID_in_12 = UINT#0 THEN
                    Messenger.Activate(UINT#820,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#820;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#821,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#821;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#822,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#822;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#823,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#823;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#824,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#824;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#825,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#825;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_12) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#826,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#826;
                    RETURN;
                END_IF;
                //******************Slot 13*****************//
                _geoAddr.Slot   :=  UINT#13;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_13);        
                IF Config.HWIDs.HwID_in_13 = UINT#0 THEN
                    Messenger.Activate(UINT#830,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#830;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#831,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#831;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#832,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#832;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#833,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#833;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#834,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#834;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#835,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#835;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_13) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#836,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#836;
                    RETURN;
                END_IF;
                //******************Slot 14*****************//
                _geoAddr.Slot   :=  UINT#14;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_14);        
                IF Config.HWIDs.HwID_in_14 = UINT#0 THEN
                    Messenger.Activate(UINT#840,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#840;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#841,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#841;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#842,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#842;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#843,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#843;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#844,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#844;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#845,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#845;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_14) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#846,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#846;
                    RETURN;
                END_IF;
                //******************Slot 15*****************//
                _geoAddr.Slot   :=  UINT#15;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_15);        
                IF Config.HWIDs.HwID_in_15 = UINT#0 THEN
                    Messenger.Activate(UINT#850,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#850;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#851,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#851;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#852,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#852;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#853,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#853;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#854,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#854;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#855,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#855;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_15) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#856,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#856;
                    RETURN;
                END_IF;
                //******************Slot 16*****************//
                _geoAddr.Slot   :=  UINT#16;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_16);        
                IF Config.HWIDs.HwID_in_16 = UINT#0 THEN
                    Messenger.Activate(UINT#860,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#860;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#861,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#861;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#862,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#862;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#863,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#863;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#864,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#864;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#865,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#865;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_16) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#866,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#866;
                    RETURN;
                END_IF;
                //******************Slot 17*****************//
                _geoAddr.Slot   :=  UINT#17;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_17);        
                IF Config.HWIDs.HwID_in_17 = UINT#0 THEN
                    Messenger.Activate(UINT#870,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#870;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#871,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#871;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#872,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#872;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#873,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#873;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#874,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#874;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#875,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#875;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_17) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#876,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#876;
                    RETURN;
                END_IF;
                //******************Slot 18*****************//
                _geoAddr.Slot   :=  UINT#18;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_18);        
                IF Config.HWIDs.HwID_in_18 = UINT#0 THEN
                    Messenger.Activate(UINT#880,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#880;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#881,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#881;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#882,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#882;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#883,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#883;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#884,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#884;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#885,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#885;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_18) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#886,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#886;
                    RETURN;
                END_IF;
                //******************Slot 19*****************//
                _geoAddr.Slot   :=  UINT#19;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_19);        
                IF Config.HWIDs.HwID_in_19 = UINT#0 THEN
                    Messenger.Activate(UINT#890,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#890;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#891,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#891;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#892,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#892;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#893,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#893;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#894,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#894;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#895,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#895;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_19) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#896,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#896;
                    RETURN;
                END_IF;
                //******************Slot 20*****************//
                _geoAddr.Slot   :=  UINT#20;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_in_20);        
                IF Config.HWIDs.HwID_in_20 = UINT#0 THEN
                    Messenger.Activate(UINT#900,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#900;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#901,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#901;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#902,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#902;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#903,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#903;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#904,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#904;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#905,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#905;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_in_20) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#916,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#916;
                    RETURN;
                END_IF;
                //******************Slot 21*****************//
                _geoAddr.Slot   :=  UINT#21;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_1);        
                IF Config.HWIDs.HwID_out_1 = UINT#0 THEN
                    Messenger.Activate(UINT#910,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#910;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#911,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#911;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#912,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#912;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#913,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#913;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#914,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#914;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#715,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#715;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#916,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#916;
                    RETURN;
                END_IF;
                //******************Slot 22*****************//
                _geoAddr.Slot   :=  UINT#22;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_2);        
                IF Config.HWIDs.HwID_out_2 = UINT#0 THEN
                    Messenger.Activate(UINT#920,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#920;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#921,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#921;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#922,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#922;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#923,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#923;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#924,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#924;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#925,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#925;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#926,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#926;
                    RETURN;
                END_IF;
                //******************Slot 23*****************//
                _geoAddr.Slot   :=  UINT#23;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_3);        
                IF Config.HWIDs.HwID_out_3 = UINT#0 THEN
                    Messenger.Activate(UINT#930,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#930;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#931,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#931;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#932,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#932;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#933,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#933;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#934,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#934;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#935,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#935;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_3) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#936,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#936;
                    RETURN;
                END_IF;
                //******************Slot 24*****************//
                _geoAddr.Slot   :=  UINT#24;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_4);        
                IF Config.HWIDs.HwID_out_4 = UINT#0 THEN
                    Messenger.Activate(UINT#940,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#940;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#941,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#941;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#942,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#942;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#943,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#943;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#944,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#944;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#945,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#945;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_4) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#946,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#946;
                    RETURN;
                END_IF;
                //******************Slot 25*****************//
                _geoAddr.Slot   :=  UINT#25;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_5);        
                IF Config.HWIDs.HwID_out_5 = UINT#0 THEN
                    Messenger.Activate(UINT#950,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#950;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#951,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#951;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#952,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#952;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#953,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#953;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#954,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#954;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#955,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#955;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_5) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#956,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#956;
                    RETURN;
                END_IF;
                //******************Slot 26*****************//
                _geoAddr.Slot   :=  UINT#26;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_6);        
                IF Config.HWIDs.HwID_out_6 = UINT#0 THEN
                    Messenger.Activate(UINT#960,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#960;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#961,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#961;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#962,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#962;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#963,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#963;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#964,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#964;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#965,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#965;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_6) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#966,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#966;
                    RETURN;
                END_IF;
                //******************Slot 27*****************//
                _geoAddr.Slot   :=  UINT#27;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_7);        
                IF Config.HWIDs.HwID_out_7 = UINT#0 THEN
                    Messenger.Activate(UINT#970,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#970;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#971,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#971;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#972,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#972;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#973,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#973;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#974,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#974;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#975,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#975;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_7) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#976,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#976;
                    RETURN;
                END_IF;
                //******************Slot 28*****************//
                _geoAddr.Slot   :=  UINT#28;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_8);        
                IF Config.HWIDs.HwID_out_8 = UINT#0 THEN
                    Messenger.Activate(UINT#980,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#980;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#981,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#981;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#982,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#982;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#983,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#983;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#984,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#984;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#985,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#985;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_8) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#986,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#986;
                    RETURN;
                END_IF;
                //******************Slot 29*****************//
                _geoAddr.Slot   :=  UINT#29;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_9);        
                IF Config.HWIDs.HwID_out_9 = UINT#0 THEN
                    Messenger.Activate(UINT#990,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#990;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#991,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#991;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#992,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#992;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#993,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#993;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#994,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#994;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#995,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#995;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_9) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#996,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#996;
                    RETURN;
                END_IF;
                //******************Slot 30*****************//
                _geoAddr.Slot   :=  UINT#30;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_10);        
                IF Config.HWIDs.HwID_out_10 = UINT#0 THEN
                    Messenger.Activate(UINT#1000,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1000;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1001,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1001;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1002,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1002;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1003,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1003;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1004,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1004;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1005,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1005;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_10) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1006,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1006;
                    RETURN;
                END_IF;
                //******************Slot 31*****************//
                _geoAddr.Slot   :=  UINT#31;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_11);        
                IF Config.HWIDs.HwID_out_11 = UINT#0 THEN
                    Messenger.Activate(UINT#1010,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1010;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1011,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1011;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1012,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1012;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1013,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1013;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1014,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1014;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1015,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1015;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_11) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1016,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1016;
                    RETURN;
                END_IF;
                //******************Slot 32*****************//
                _geoAddr.Slot   :=  UINT#32;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_12);        
                IF Config.HWIDs.HwID_out_12 = UINT#0 THEN
                    Messenger.Activate(UINT#1020,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1020;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1021,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1021;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1022,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1022;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1023,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1023;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1024,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1024;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1025,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1025;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_12) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1026,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1026;
                    RETURN;
                END_IF;
                //******************Slot 33*****************//
                _geoAddr.Slot   :=  UINT#33;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_13);        
                IF Config.HWIDs.HwID_out_13 = UINT#0 THEN
                    Messenger.Activate(UINT#1030,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1030;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1031,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1031;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1032,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1032;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1033,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1033;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1034,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1034;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1035,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1035;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_13) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1036,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1036;
                    RETURN;
                END_IF;
                //******************Slot 34*****************//
                _geoAddr.Slot   :=  UINT#34;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_14);        
                IF Config.HWIDs.HwID_out_14 = UINT#0 THEN
                    Messenger.Activate(UINT#1040,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1040;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1041,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1041;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1042,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1042;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1043,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1043;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1044,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1044;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1045,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1045;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_14) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1046,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1046;
                    RETURN;
                END_IF;
                //******************Slot 35*****************//
                _geoAddr.Slot   :=  UINT#35;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_15);        
                IF Config.HWIDs.HwID_out_15 = UINT#0 THEN
                    Messenger.Activate(UINT#1050,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1050;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1051,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1051;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1052,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1052;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1053,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1053;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1054,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1054;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1055,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1055;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_15) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1056,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1056;
                    RETURN;
                END_IF;
                //******************Slot 36*****************//
                _geoAddr.Slot   :=  UINT#36;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_16);        
                IF Config.HWIDs.HwID_out_16 = UINT#0 THEN
                    Messenger.Activate(UINT#1060,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1060;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1061,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1061;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1062,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1062;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1063,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1063;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1064,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1064;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1065,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1065;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_16) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1066,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1066;
                    RETURN;
                END_IF;
                //******************Slot 37*****************//
                _geoAddr.Slot   :=  UINT#37;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_17);        
                IF Config.HWIDs.HwID_out_17 = UINT#0 THEN
                    Messenger.Activate(UINT#1070,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1070;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1071,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1071;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1072,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1072;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1073,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1073;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1074,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1074;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1075,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1075;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_17) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1076,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1076;
                    RETURN;
                END_IF;
                //******************Slot 38*****************//
                _geoAddr.Slot   :=  UINT#38;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_18);        
                IF Config.HWIDs.HwID_out_18 = UINT#0 THEN
                    Messenger.Activate(UINT#1080,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1080;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1081,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1081;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1082,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1082;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1083,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1083;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1084,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1084;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1085,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1085;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_18) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1086,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1086;
                    RETURN;
                END_IF;
                //******************Slot 39*****************//
                _geoAddr.Slot   :=  UINT#39;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_19);        
                IF Config.HWIDs.HwID_out_19 = UINT#0 THEN
                    Messenger.Activate(UINT#1090,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1090;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1091,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1091;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1092,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1092;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1093,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1093;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1094,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1094;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1095,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1095;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_19) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1096,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1096;
                    RETURN;
                END_IF;
                //******************Slot 40*****************//
                _geoAddr.Slot   :=  UINT#40;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_out_20);        
                IF Config.HWIDs.HwID_out_20 = UINT#0 THEN
                    Messenger.Activate(UINT#1100,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1100;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1101,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1101;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1102,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1102;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1103,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1103;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1104,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1104;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1105,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1105;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_out_20) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1106,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1106;
                    RETURN;
                END_IF;
 
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
                IF Config.HWIDs.HwID_in_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_2  = UINT#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_3  = UINT#0 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_4  = UINT#0 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_5  = UINT#0 THEN
                    Messenger.Activate(UINT#1136,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_6  = UINT#0 THEN
                    Messenger.Activate(UINT#1137,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1137;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_7  = UINT#0 THEN
                    Messenger.Activate(UINT#1138,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1138;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_8  = UINT#0 THEN
                    Messenger.Activate(UINT#1139,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1139;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_9  = UINT#0 THEN
                    Messenger.Activate(UINT#1140,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1140;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_10  = UINT#0 THEN
                    Messenger.Activate(UINT#1141,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1141;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_11  = UINT#0 THEN
                    Messenger.Activate(UINT#1142,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1142;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_12  = UINT#0 THEN
                    Messenger.Activate(UINT#1143,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1143;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_13  = UINT#0 THEN
                    Messenger.Activate(UINT#1144,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1144;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_14  = UINT#0 THEN
                    Messenger.Activate(UINT#1145,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1145;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_15  = UINT#0 THEN
                    Messenger.Activate(UINT#1146,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1146;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_16  = UINT#0 THEN
                    Messenger.Activate(UINT#1147,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1147;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_17  = UINT#0 THEN
                    Messenger.Activate(UINT#1148,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1148;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_18  = UINT#0 THEN
                    Messenger.Activate(UINT#1149,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1149;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_19  = UINT#0 THEN
                    Messenger.Activate(UINT#1150,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1150;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_in_20  = UINT#0 THEN
                    Messenger.Activate(UINT#1151,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1151;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HwID_out_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1152,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1152;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_2  = UINT#0 THEN
                    Messenger.Activate(UINT#1153,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1153;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_3  = UINT#0 THEN
                    Messenger.Activate(UINT#1154,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1154;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_4  = UINT#0 THEN
                    Messenger.Activate(UINT#1155,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1155;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_5  = UINT#0 THEN
                    Messenger.Activate(UINT#1156,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1156;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_6  = UINT#0 THEN
                    Messenger.Activate(UINT#1157,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1157;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_7  = UINT#0 THEN
                    Messenger.Activate(UINT#1158,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1158;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_8  = UINT#0 THEN
                    Messenger.Activate(UINT#1159,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1159;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_9  = UINT#0 THEN
                    Messenger.Activate(UINT#1160,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1160;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_10  = UINT#0 THEN
                    Messenger.Activate(UINT#1161,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1161;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_11  = UINT#0 THEN
                    Messenger.Activate(UINT#1162,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1162;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_12  = UINT#0 THEN
                    Messenger.Activate(UINT#1163,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1163;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_13  = UINT#0 THEN
                    Messenger.Activate(UINT#1164,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1164;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_14  = UINT#0 THEN
                    Messenger.Activate(UINT#1165,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1165;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_15  = UINT#0 THEN
                    Messenger.Activate(UINT#1166,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1166;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_16  = UINT#0 THEN
                    Messenger.Activate(UINT#1167,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1167;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_17  = UINT#0 THEN
                    Messenger.Activate(UINT#1168,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1168;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_18  = UINT#0 THEN
                    Messenger.Activate(UINT#1169,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1169;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_19  = UINT#0 THEN
                    Messenger.Activate(UINT#1170,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1170;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_out_20  = UINT#0 THEN
                    Messenger.Activate(UINT#1171,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1171;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs **************
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_1) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_1.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_1.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_1.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_1.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_1.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_2) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_2.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_2.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_2.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_2.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_2.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_3) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1203, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1203;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_3.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_3.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_3.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_3.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_3.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_4) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1204, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1204;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_4.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_4.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_4.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_4.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_4.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_5) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1205, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1205;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_5.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_5.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_5.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_5.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_5.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_6) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1206, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1206;
                RETURN;
            END_IF;

            // _word.%B1                                                           :=  _data_in[0];
            // _word.%B0                                                           :=  _data_in[1];
            // TemplateComponentInputStructure_hwID_in_6.Item1                     :=  TO_UINT(_word);
            // _word.%B1                                                           :=  _data_in[2];
            // _word.%B0                                                           :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_6.Item2                     :=  TO_UINT(_word);
            // _word.%B1                                                           :=  _data_in[4];
            // _word.%B0                                                           :=  _data_in[5];
            // TemplateComponentInputStructure_hwID_in_6.Item3                     :=  TO_UINT(_word);
            // _word.%B1                                                           :=  _data_in[6];
            // _word.%B0                                                           :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_6.Item4                     :=  TO_UINT(_word);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_7) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1207, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1207;
                RETURN;
            END_IF;

            // _dword.%B3                                                          :=  _data_in[0];
            // _dword.%B2                                                          :=  _data_in[1];
            // _dword.%B1                                                          :=  _data_in[2];
            // _dword.%B0                                                          :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_7.Item1                     :=  TO_DINT(_dword);
            // _dword.%B3                                                          :=  _data_in[4];
            // _dword.%B2                                                          :=  _data_in[5];
            // _dword.%B1                                                          :=  _data_in[6];
            // _dword.%B0                                                          :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_7.Item2                     :=  TO_REAL(_dword);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_8) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1208, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1208;
                RETURN;
            END_IF;

            // _dword.%B3                                                          :=  _data_in[0];
            // _dword.%B2                                                          :=  _data_in[1];
            // _dword.%B1                                                          :=  _data_in[2];
            // _dword.%B0                                                          :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_8.Item1                     :=  TO_DINT(_dword);
            // _dword.%B3                                                          :=  _data_in[4];
            // _dword.%B2                                                          :=  _data_in[5];
            // _dword.%B1                                                          :=  _data_in[6];
            // _dword.%B0                                                          :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_8.Item2                     :=  TO_REAL(_dword);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_9) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1209, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1209;
                RETURN;
            END_IF;

            // _dword.%B3                                                          :=  _data_in[0];
            // _dword.%B2                                                          :=  _data_in[1];
            // _dword.%B1                                                          :=  _data_in[2];
            // _dword.%B0                                                          :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_9.Item1                     :=  TO_DINT(_dword);
            // _dword.%B3                                                          :=  _data_in[4];
            // _dword.%B2                                                          :=  _data_in[5];
            // _dword.%B1                                                          :=  _data_in[6];
            // _dword.%B0                                                          :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_9.Item2                     :=  TO_REAL(_dword);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_10) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1210, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1210;
                RETURN;
            END_IF;

            // _dword.%B3                                                          :=  _data_in[0];
            // _dword.%B2                                                          :=  _data_in[1];
            // _dword.%B1                                                          :=  _data_in[2];
            // _dword.%B0                                                          :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_10.Item1                    :=  TO_DINT(_dword);
            // _dword.%B3                                                          :=  _data_in[4];
            // _dword.%B2                                                          :=  _data_in[5];
            // _dword.%B1                                                          :=  _data_in[6];
            // _dword.%B0                                                          :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_10.Item2                    :=  TO_REAL(_dword);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_11) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1211, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1211;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_11.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_11.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_11.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_11.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_11.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_12) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1212, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1212;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_12.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_12.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_12.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_12.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_12.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_13) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1213, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1213;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_13.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_13.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_13.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_13.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_13.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_14) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1214, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1214;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_14.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_14.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_14.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_14.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_14.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_15) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1215, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1215;
                RETURN;
            END_IF;

            // TemplateComponentInputStructure_hwID_in_15.Item1  :=      _data_in[0].%X0;
            // TemplateComponentInputStructure_hwID_in_15.Item2  :=      _data_in[0].%X1;
            // TemplateComponentInputStructure_hwID_in_15.Item3  :=      _data_in[0].%X2;
            // TemplateComponentInputStructure_hwID_in_15.Item4  :=      _data_in[0].%X3; 
            // TemplateComponentInputStructure_hwID_in_15.Item5  :=      _data_in[0].%X4; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_16) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1216, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1216;
                RETURN;
            END_IF;

            // _word.%B1                                                           :=  _data_in[0];
            // _word.%B0                                                           :=  _data_in[1];
            // TemplateComponentInputStructure_hwID_in_16.Item1                    :=  TO_UINT(_word);
            // _word.%B1                                                           :=  _data_in[2];
            // _word.%B0                                                           :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_16.Item2                    :=  TO_UINT(_word);
            // _word.%B1                                                           :=  _data_in[4];
            // _word.%B0                                                           :=  _data_in[5];
            // TemplateComponentInputStructure_hwID_in_16.Item3                    :=  TO_UINT(_word);
            // _word.%B1                                                           :=  _data_in[6];
            // _word.%B0                                                           :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_16.Item4                    :=  TO_UINT(_word);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_17) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1217, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1217;
                RETURN;
            END_IF;

            // _dword.%B3                                                          :=  _data_in[0];
            // _dword.%B2                                                          :=  _data_in[1];
            // _dword.%B1                                                          :=  _data_in[2];
            // _dword.%B0                                                          :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_17.Item1                    :=  TO_DINT(_dword);
            // _dword.%B3                                                          :=  _data_in[4];
            // _dword.%B2                                                          :=  _data_in[5];
            // _dword.%B1                                                          :=  _data_in[6];
            // _dword.%B0                                                          :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_17.Item2                    :=  TO_REAL(_dword);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_18) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1218, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1218;
                RETURN;
            END_IF;

            // _dword.%B3                                                          :=  _data_in[0];
            // _dword.%B2                                                          :=  _data_in[1];
            // _dword.%B1                                                          :=  _data_in[2];
            // _dword.%B0                                                          :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_18.Item1                    :=  TO_DINT(_dword);
            // _dword.%B3                                                          :=  _data_in[4];
            // _dword.%B2                                                          :=  _data_in[5];
            // _dword.%B1                                                          :=  _data_in[6];
            // _dword.%B0                                                          :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_18.Item2                    :=  TO_REAL(_dword);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_19) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1219, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1219;
                RETURN;
            END_IF;

            // _dword.%B3                                                          :=  _data_in[0];
            // _dword.%B2                                                          :=  _data_in[1];
            // _dword.%B1                                                          :=  _data_in[2];
            // _dword.%B0                                                          :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_19.Item1                    :=  TO_DINT(_dword);
            // _dword.%B3                                                          :=  _data_in[4];
            // _dword.%B2                                                          :=  _data_in[5];
            // _dword.%B1                                                          :=  _data_in[6];
            // _dword.%B0                                                          :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_19.Item2                    :=  TO_REAL(_dword);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_in_20) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1220, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1220;
                RETURN;
            END_IF;

            // _dword.%B3                                                          :=  _data_in[0];
            // _dword.%B2                                                          :=  _data_in[1];
            // _dword.%B1                                                          :=  _data_in[2];
            // _dword.%B0                                                          :=  _data_in[3];
            // TemplateComponentInputStructure_hwID_in_20.Item1                    :=  TO_DINT(_dword);
            // _dword.%B3                                                          :=  _data_in[4];
            // _dword.%B2                                                          :=  _data_in[5];
            // _dword.%B1                                                          :=  _data_in[6];
            // _dword.%B0                                                          :=  _data_in[7];
            // TemplateComponentInputStructure_hwID_in_20.Item2                    :=  TO_REAL(_dword);

          
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            TemplateTask_10steps_1.Run(THIS);
            TemplateTask_10steps_2.Run(THIS);
            TemplateTask_10steps_3.Run(THIS);
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
            
    
            //*************TemplateTask_10steps_1**************
            TemplateTask_10steps_1.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_1.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,TemplateTask_10steps_1.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,TemplateTask_10steps_1.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_1.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
    
                IF _progress = 300 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
    
                IF _progress = 301 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#503;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                
                IF _progress = 304 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#504;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                
                IF _progress = 305 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#505;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                
                IF _progress = 306 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#506, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#506;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 307;
                    END_IF;
                END_IF;
                
                IF _progress = 307 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#507, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#507;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 308;
                    END_IF;
                END_IF;
                
                IF _progress = 308 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#508, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#508;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 309;
                    END_IF;
                END_IF;
                
                IF _progress = 309 THEN                                                                                     // TemplateTask_10steps_1 running: , add_the_detailed_description_of_the_current_action_10
                    TemplateTask_10steps_1.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_1.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_1.ThrowWhen(TemplateTask_10steps_1.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_1 timeout.');                
            END_IF;
            IF TemplateTask_10steps_1.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_1.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF TemplateTask_10steps_1.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,TemplateTask_10steps_1.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,TemplateTask_10steps_1.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,TemplateTask_10steps_1.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_1.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_2***************
            TemplateTask_10steps_2.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_2.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,TemplateTask_10steps_2.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,TemplateTask_10steps_2.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_2.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
    
                IF _progress = 310 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
    
                IF _progress = 311 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#514;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#515;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#516;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;
                
                IF _progress = 317 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#517;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;
                
                IF _progress = 318 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#518;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 319;
                    END_IF;
                END_IF;
                
                IF _progress = 319 THEN                                                                                     // TemplateTask_10steps_2 running: , add_the_detailed_description_of_the_current_action_10
                    TemplateTask_10steps_2.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_2.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_2.ThrowWhen(TemplateTask_10steps_2.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_2 timeout.');                
            END_IF;
            IF TemplateTask_10steps_2.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_2.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF TemplateTask_10steps_2.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,TemplateTask_10steps_2.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,TemplateTask_10steps_2.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,TemplateTask_10steps_2.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_2.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_3***************
            TemplateTask_10steps_3.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_3.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,TemplateTask_10steps_3.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,TemplateTask_10steps_3.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_3.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
    
                IF _progress = 320 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_1
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#520;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
    
                IF _progress = 321 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_2
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                
                IF _progress = 322 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_3
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#522;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                
                IF _progress = 323 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_4
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#523;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                
                IF _progress = 324 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_5
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#524;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_6
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_7
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#526;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
                
                IF _progress = 327 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_8
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#527;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    END_IF;
                END_IF;
                
                IF _progress = 328 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_9
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#528, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#528;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 329;
                    END_IF;
                END_IF;
                
                IF _progress = 329 THEN                                                                                     // TemplateTask_10steps_3 running: , add_the_detailed_description_of_the_current_action_10
                    TemplateTask_10steps_3.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_3.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_3.ThrowWhen(TemplateTask_10steps_3.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_3 timeout.');                
            END_IF;
            IF TemplateTask_10steps_3.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_3.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF TemplateTask_10steps_3.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10020,TemplateTask_10steps_3.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,TemplateTask_10steps_3.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,TemplateTask_10steps_3.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_3.RestoreTriggered() AND _progress >= 320 AND _progress <= 329  THEN
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
                TemplateTask_10steps_4.ThrowWhen(TemplateTask_10steps_4.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_4 timeout.');                
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
                TemplateTask_10steps_5.ThrowWhen(TemplateTask_10steps_5.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_5 timeout.');                
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
                TemplateTask_10steps_6.ThrowWhen(TemplateTask_10steps_6.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_6 timeout.');                
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
                TemplateTask_20steps_1.ThrowWhen(TemplateTask_20steps_1.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_1 timeout.');                
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
                TemplateTask_20steps_2.ThrowWhen(TemplateTask_20steps_2.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_2 timeout.');                
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
                TemplateTask_20steps_3.ThrowWhen(TemplateTask_20steps_3.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_3 timeout.');                
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
                TemplateTask_20steps_4.ThrowWhen(TemplateTask_20steps_4.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_4 timeout.');                
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
                TemplateTask_20steps_5.ThrowWhen(TemplateTask_20steps_5.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_5 timeout.');                
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
                TemplateTask_20steps_6.ThrowWhen(TemplateTask_20steps_6.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_6 timeout.');                
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

            //***********Update outputs ****************
            // _data_out_1[0].%X1                  :=      TemplateComponentOutputStructure_hwID_out_1.Item1;
            // _data_out_1[0].%X2                  :=      TemplateComponentOutputStructure_hwID_out_1.Item2;
            // _data_out_1[0].%X3                  :=      TemplateComponentOutputStructure_hwID_out_1.Item1;
            // _data_out_1[0].%X4                  :=      TemplateComponentOutputStructure_hwID_out_1.Item2;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_1),_data_out_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;            

            // _data_out_1[0].%X1                  :=      TemplateComponentOutputStructure_hwID_out_2.Item1;
            // _data_out_1[0].%X2                  :=      TemplateComponentOutputStructure_hwID_out_2.Item2;
            // _data_out_1[0].%X3                  :=      TemplateComponentOutputStructure_hwID_out_2.Item1;
            // _data_out_1[0].%X4                  :=      TemplateComponentOutputStructure_hwID_out_2.Item2;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_2),_data_out_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1232, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1232;
                RETURN;
            END_IF;

            // _data_out_4[1]                     :=      TO_WORD(TemplateComponentOutputStructure_hwID_out_3.Item1).%B0;
            // _data_out_4[0]                     :=      TO_WORD(TemplateComponentOutputStructure_hwID_out_3.Item1).%B1;
            // _data_out_4[3]                     :=      TO_WORD(TemplateComponentOutputStructure_hwID_out_3.Item2).%B0;
            // _data_out_4[2]                     :=      TO_WORD(TemplateComponentOutputStructure_hwID_out_3.Item2).%B1;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_3),_data_out_4);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1233, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1233;
                RETURN;
            END_IF;

            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_4.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_4.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_4.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_4.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_4.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_4.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_4.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_4.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_4),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1234, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1234;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_5.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_5.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_5.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_5.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_5.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_5.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_5.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_5.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_5),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1235, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1235;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_6.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_6.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_6.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_6.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_6.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_6.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_6.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_6.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_6),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1236, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1236;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_7.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_7.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_7.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_7.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_7.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_7.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_7.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_7.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_7),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1237, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1237;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_8.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_8.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_8.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_8.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_8.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_8.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_8.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_8.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_8),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1238, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1238;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_9.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_9.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_9.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_9.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_9.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_9.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_9.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_9.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_9),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1239, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1239;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_10.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_10.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_10.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_10.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_10.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_10.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_10.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_10.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_10),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1240, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1240;
                RETURN;
            END_IF;

            // _data_out_1[0].%X1                  :=      TemplateComponentOutputStructure_hwID_out_11.Item1;
            // _data_out_1[0].%X2                  :=      TemplateComponentOutputStructure_hwID_out_11.Item2;
            // _data_out_1[0].%X3                  :=      TemplateComponentOutputStructure_hwID_out_11.Item1;
            // _data_out_1[0].%X4                  :=      TemplateComponentOutputStructure_hwID_out_11.Item2;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_11),_data_out_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1241, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1241;
                RETURN;
            END_IF;
            
            // _data_out_1[0].%X1                  :=      TemplateComponentOutputStructure_hwID_out_12.Item1;
            // _data_out_1[0].%X2                  :=      TemplateComponentOutputStructure_hwID_out_12.Item2;
            // _data_out_1[0].%X3                  :=      TemplateComponentOutputStructure_hwID_out_12.Item1;
            // _data_out_1[0].%X4                  :=      TemplateComponentOutputStructure_hwID_out_12.Item2;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_12),_data_out_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1242, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1242;
                RETURN;
            END_IF;

            // _data_out_4[1]                     :=      TO_WORD(TemplateComponentOutputStructure_hwID_out_13.Item1).%B0;
            // _data_out_4[0]                     :=      TO_WORD(TemplateComponentOutputStructure_hwID_out_13.Item1).%B1;
            // _data_out_4[3]                     :=      TO_WORD(TemplateComponentOutputStructure_hwID_out_13.Item2).%B0;
            // _data_out_4[2]                     :=      TO_WORD(TemplateComponentOutputStructure_hwID_out_13.Item2).%B1;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_13),_data_out_4);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1243, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1243;
                RETURN;
            END_IF;

            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_14.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_14.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_14.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_14.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_14.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_14.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_14.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_14.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_14),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1244, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1244;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_15.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_15.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_15.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_15.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_15.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_15.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_15.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_15.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_15),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1245, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1245;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_16.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_16.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_16.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_16.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_16.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_16.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_16.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_16.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_16),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1246, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1246;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_17.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_17.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_17.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_17.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_17.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_17.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_17.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_17.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_17),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1247, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1247;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_18.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_18.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_18.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_18.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_18.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_18.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_18.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_18.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_18),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1248, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1248;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_19.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_19.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_19.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_19.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_19.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_19.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_19.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_19.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_19),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1249, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1249;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_20.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_20.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_20.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_20.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_20.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_20.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_20.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(TemplateComponentOutputStructure_hwID_out_20.Item2).%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_out_20),_data_out_8);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1250, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1250;
                RETURN;
            END_IF;
            
            //******************************************      

        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_1 : IAxoTaskState
            TemplateMethod_10steps_1 := TemplateTask_10steps_1.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_2 : IAxoTaskState
            TemplateMethod_10steps_2 := TemplateTask_10steps_2.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_3 : IAxoTaskState
            TemplateMethod_10steps_3 := TemplateTask_10steps_3.Invoke(THIS);
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


            TemplateTask_10steps_1.Restore();
            TemplateTask_10steps_2.Restore();
            TemplateTask_10steps_3.Restore();
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
