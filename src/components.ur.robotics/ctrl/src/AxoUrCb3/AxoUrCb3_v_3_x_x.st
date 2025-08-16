USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;
USING Siemens.Simatic.S71500.Hardware.Utilities;

NAMESPACE AXOpen.Components.Ur.Robotics
    {S7.extern=ReadWrite}
    CLASS AxoUrCb3_v_3_x_x EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
        VAR PRIVATE
            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _context                :   IAxoContext;
            _stopTasksAreActive     :   BOOL;
            _stopType               :   eAxoRoboticsStopType;
            _someTaskIsActive       :   BOOL;
            
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
                    
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;       
            
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Power On Task#>"}
            PowerOnTask : AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start at main#>"}
            StartAtMainTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start motors and program#>"}
            StartMotorsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements#>"}
            StopMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements and program#>"}
            StopMovementsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements with extended parameters#>"}
            StartMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements with extended parameters#>"}
            MovementParameters : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
        END_VAR
        
        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoUrRobotics_Config_v_1_x_x;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status         :   AxoUrRobotics_Component_Status_v_1_x_x;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Power progress#>"}
            _power_progress  :   INT := 0;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Movement progress#>"}
            _movement_progress  :   INT := 0;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR

        VAR PUBLIC //Hardware signals
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoUrRobotics_State_v_1_x_x;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoUrRobotics_Control_v_1_x_x;
        END_VAR    

        VAR PUBLIC //HardwareDiagnostics
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}            
            {#ix-set:AttributeName = "<#Reboot controller#>"}
            RebootControllerTask : AxoRemoteTask ;            
        END_VAR


        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent          :   IAxoObject;
                hwID            :   UINT;
                refPowerOnPulse :   REF_TO BOOL;
            END_VAR
            VAR 
                _word : WORD;
                _dword: DWORD;
                _retVal : WORD;
                _data : ARRAY[0..103] OF BYTE;
                _data24 : ARRAY[0..23] OF BYTE;
                _data100 : ARRAY[0..99] OF BYTE;
            END_VAR

            SUPER.Run(parent);

            Messenger.Serve(THIS);

            IF NOT _initHwCheckDone THEN
                IF parent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                Config.HWIDs.HwId_Device  := hwID;
                IF Config.HWIDs.HwId_Device = UINT#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                _retval := ReadSlotFromHardwareID(hardwareID := Config.HWIDs.HwId_Device, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_State = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_State) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#32 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_IO = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_IO) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#68 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#104 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#76 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers), inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers), inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#96 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#132 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                    RETURN;
                END_IF;
                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#24 THEN
                    Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#786;
                    RETURN;
                END_IF;
                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#100 THEN
                    Messenger.Activate(UINT#796,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#796;
                    RETURN;
                END_IF;
                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                IF Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#100 THEN
                    Messenger.Activate(UINT#806,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#806;
                    RETURN;
                END_IF;
 
                IF parent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_Device  = UINT#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_State  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_IO  = UINT#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints  = UINT#0 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP  = UINT#0 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers  = UINT#0 THEN
                    Messenger.Activate(UINT#1136,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers  = UINT#0 THEN
                    Messenger.Activate(UINT#1137,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1137;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers  = UINT#0 THEN
                    Messenger.Activate(UINT#1138,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1138;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO  = UINT#0 THEN
                    Messenger.Activate(UINT#1139,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1139;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1140,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1140;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2  = UINT#0 THEN
                    Messenger.Activate(UINT#1141,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1141;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            



            //*******************************************
            _context := THIS.GetContext();

            //*************INITIALIZATION*************
            // RestoreTask.Run(THIS);
            // PowerOnTask.Run(THIS);
            // StopMovementsTask.Run(THIS);
            // StopMovementsAndProgramTask.Run(THIS);
            
            // StartAtMainTask.Run(THIS);
            // StartMotorsAndProgramTask.Run(THIS);
            // StartMovementsTask.Run(THIS);
            // HardwareDiagnosticsTask.Run(THIS);
            // RebootControllerTask.Run(THIS);

            _stopTasksAreActive := StopMovementsTask.IsBusy() OR StopMovementsAndProgramTask.IsBusy();
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HwId_Device);
            RebootControllerTask.Execute(THIS);
            //****************************************
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //***********UPDATE**INPUTS******************
            //Inputs Low level
            //INPUTS T2O STATE ROBOT => st_URO_CB3_T2OInfoData
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_State), _data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;
            Inputs.Inputs.Robot.ControllerMajorVersion              := TO_USINT(_data[0]);
            Inputs.Inputs.Robot.ControllerMinorVersion              := TO_USINT(_data[1]);
            Inputs.Inputs.Robot.RobotMode                           := TO_USINT(_data[4]);
            Inputs.Inputs.Robot.RealtimeMachineSeconds              := TO_USINT(_data[5]);
            _word.%B1                                               := _data[6];
            _word.%B0                                               := _data[7];
            Inputs.Inputs.Robot.RealtimeMachineMilliseconds         := TO_UINT(_word);
            Inputs.Inputs.Robot.RealtimeMachineMinutes              := TO_USINT(_data[8]);
            Inputs.Inputs.Robot.RealtimeMachineHours                := TO_USINT(_data[9]);
            _word.%B1                                               := _data[10];
            _word.%B0                                               := _data[11];
            Inputs.Inputs.Robot.RealtimeMachineDays                 := TO_UINT(_word);
            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.Robot.RobotCurrent                        := TO_REAL(_dword);
            //INPUTS T2O STATE ROBOT => st_URO_CB3_T2OStateData
            Inputs.Inputs.Robot.PW_IsPowerOn                        := _data[16].%X0;
            Inputs.Inputs.Robot.PR_IsProgramRunning                 := _data[16].%X1;
            Inputs.Inputs.Robot.TB_IsTeachButtonPressed             := _data[16].%X2;
            Inputs.Inputs.Robot.PB_IsPowerButtonPressed             := _data[16].%X3;
            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.Robot.SpeedSliderFraction                 := REAL#100.0 * TO_REAL(_dword);
            Inputs.Inputs.Safety.SafetyMode                         := TO_USINT(_data[24]);
            Inputs.Inputs.Safety.NO_IsNormalMode                    := _data[28].%X0;
            Inputs.Inputs.Safety.RD_IsReducedMode                   := _data[28].%X1;
            Inputs.Inputs.Safety.PS_IsProtectiveStopped             := _data[28].%X2;
            Inputs.Inputs.Safety.RC_IsRecoveryMode                  := _data[28].%X3;
            Inputs.Inputs.Safety.SS_IsSafeguardStopped              := _data[28].%X4;
            Inputs.Inputs.Safety.SES_IsSystemEmergencyStopped       := _data[28].%X5;
            Inputs.Inputs.Safety.RES_IsRobotEmergencyStopped        := _data[28].%X6;
            Inputs.Inputs.Safety.ES_IsEmergencyStopped              := _data[28].%X7;
            Inputs.Inputs.Safety.VL_IsViolation                     := _data[29].%X0;
            Inputs.Inputs.Safety.FT_IsFault                         := _data[29].%X1;
            Inputs.Inputs.Safety.ST_IsStoppedDueSafety              := _data[29].%X2;

            //INPUTS T20 IO => st_URO_CB3_T2OIoStateData
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_IO), _data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;
            Inputs.Inputs.IO.StandardDigitalInputs                  := TO_USINT(_data[0]);
            Inputs.Inputs.IO.ConfigurableDigitalInputs              := TO_USINT(_data[1]);
            Inputs.Inputs.IO.StandardDigitalOutputs                 := TO_USINT(_data[2]);
            Inputs.Inputs.IO.ConfigurableDigitalOutputs             := TO_USINT(_data[3]);
            Inputs.Inputs.IO.AnalogIoTypes                          := TO_USINT(_data[4]);
            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.IO.StandardAnalogInput_0                  := TO_REAL(_dword);
            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.IO.StandardAnalogInput_1                  := TO_REAL(_dword);            
            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.IO.StandardAnalogOutput_0                 := TO_REAL(_dword);
            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.IO.StandardAnalogOutput_1                 := TO_REAL(_dword);            
            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.IO.Current                                := TO_REAL(_dword);            

            Inputs.Inputs.IO.Euromap67InputBit_0                    := _data[28].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_1                    := _data[28].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_2                    := _data[28].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_3                    := _data[28].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_4                    := _data[28].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_5                    := _data[28].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_6                    := _data[28].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_7                    := _data[28].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_8                    := _data[29].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_9                    := _data[29].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_10                   := _data[29].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_11                   := _data[29].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_12                   := _data[29].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_13                   := _data[29].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_14                   := _data[29].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_15                   := _data[29].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_16                   := _data[30].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_17                   := _data[30].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_18                   := _data[30].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_19                   := _data[30].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_20                   := _data[30].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_21                   := _data[30].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_22                   := _data[30].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_23                   := _data[30].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_24                   := _data[31].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_25                   := _data[31].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_26                   := _data[31].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_27                   := _data[31].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_28                   := _data[31].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_29                   := _data[31].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_30                   := _data[31].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_31                   := _data[31].%X7;

            Inputs.Inputs.IO.Euromap67OutputBit_0                   := _data[32].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_1                   := _data[32].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_2                   := _data[32].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_3                   := _data[32].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_4                   := _data[32].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_5                   := _data[32].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_6                   := _data[32].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_7                   := _data[32].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_8                   := _data[33].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_9                   := _data[33].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_10                  := _data[33].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_11                  := _data[33].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_12                  := _data[33].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_13                  := _data[33].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_14                  := _data[33].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_15                  := _data[33].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_16                  := _data[34].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_17                  := _data[34].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_18                  := _data[34].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_19                  := _data[34].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_20                  := _data[34].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_21                  := _data[34].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_22                  := _data[34].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_23                  := _data[34].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_24                  := _data[35].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_25                  := _data[35].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_26                  := _data[35].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_27                  := _data[35].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_28                  := _data[35].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_29                  := _data[35].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_30                  := _data[35].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_31                  := _data[35].%X7;

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.IO.Euromap6724Voltage                     := TO_REAL(_dword);            

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.IO.Euromap6724VCurrent                    := TO_REAL(_dword);  

            //INPUTS T20 IO => st_URO_CB3_T2OToolStateData
            Inputs.Inputs.Tool.ToolMode                             := TO_USINT(_data[44]);
            Inputs.Inputs.Tool.TDI_ToolDigitalInputs                := TO_USINT(_data[45]);
            Inputs.Inputs.Tool.TDO_ToolDigitalOutputs               := TO_USINT(_data[46]);
            Inputs.Inputs.Tool.TAIT_ToolAnalogInputTypes            := TO_USINT(_data[47]);

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.Tool.ToolAnalogInput_0                    := TO_REAL(_dword);    

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.Tool.ToolAnalogInput_1                    := TO_REAL(_dword);    

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.Tool.ToolOutputVoltage                    := TO_REAL(_dword);    

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.Tool.ToolCurrent                          := TO_REAL(_dword);    

            // //INPUTS T20 JOINT => st_URO_CB3_T2OJointsData
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_Joints), _data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1203, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1203;
                RETURN;
            END_IF;
            _dword.%B3                                              := _data[0];
            _dword.%B2                                              := _data[1];
            _dword.%B1                                              := _data[2];
            _dword.%B0                                              := _data[3];
            Inputs.Inputs.Joints.JointPosition_0                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[4];
            _dword.%B2                                              := _data[5];
            _dword.%B1                                              := _data[6];
            _dword.%B0                                              := _data[7];
            Inputs.Inputs.Joints.JointPosition_1                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.Joints.JointPosition_2                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.Joints.JointPosition_3                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.Joints.JointPosition_4                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.Joints.JointPosition_5                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.Joints.JointVelocity_0                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[28];
            _dword.%B2                                              := _data[29];
            _dword.%B1                                              := _data[30];
            _dword.%B0                                              := _data[31];
            Inputs.Inputs.Joints.JointVelocity_1                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[32];
            _dword.%B2                                              := _data[33];
            _dword.%B1                                              := _data[34];
            _dword.%B0                                              := _data[35];
            Inputs.Inputs.Joints.JointVelocity_2                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.Joints.JointVelocity_3                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.Joints.JointVelocity_4                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[44];
            _dword.%B2                                              := _data[45];
            _dword.%B1                                              := _data[46];
            _dword.%B0                                              := _data[47];
            Inputs.Inputs.Joints.JointVelocity_5                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.Joints.JointCurrent_0                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.Joints.JointCurrent_1                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.Joints.JointCurrent_2                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.Joints.JointCurrent_3                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[64];
            _dword.%B2                                              := _data[65];
            _dword.%B1                                              := _data[66];
            _dword.%B0                                              := _data[67];
            Inputs.Inputs.Joints.JointCurrent_4                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[68];
            _dword.%B2                                              := _data[69];
            _dword.%B1                                              := _data[70];
            _dword.%B0                                              := _data[71];
            Inputs.Inputs.Joints.JointCurrent_5                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[72];
            _dword.%B2                                              := _data[73];
            _dword.%B1                                              := _data[74];
            _dword.%B0                                              := _data[75];
            Inputs.Inputs.Joints.JointTemperature_0                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[76];
            _dword.%B2                                              := _data[77];
            _dword.%B1                                              := _data[78];
            _dword.%B0                                              := _data[79];
            Inputs.Inputs.Joints.JointTemperature_1                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[80];
            _dword.%B2                                              := _data[81];
            _dword.%B1                                              := _data[82];
            _dword.%B0                                              := _data[83];
            Inputs.Inputs.Joints.JointTemperature_2                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[84];
            _dword.%B2                                              := _data[85];
            _dword.%B1                                              := _data[86];
            _dword.%B0                                              := _data[87];
            Inputs.Inputs.Joints.JointTemperature_3                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[88];
            _dword.%B2                                              := _data[89];
            _dword.%B1                                              := _data[90];
            _dword.%B0                                              := _data[91];
            Inputs.Inputs.Joints.JointTemperature_4                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[92];
            _dword.%B2                                              := _data[93];
            _dword.%B1                                              := _data[94];
            _dword.%B0                                              := _data[95];
            Inputs.Inputs.Joints.JointTemperature_5                 :=  TO_REAL(_dword);    

            Inputs.Inputs.Joints.JointMode_0                        := TO_USINT(_data[96]);
            Inputs.Inputs.Joints.JointMode_1                        := TO_USINT(_data[97]);
            Inputs.Inputs.Joints.JointMode_2                        := TO_USINT(_data[98]);
            Inputs.Inputs.Joints.JointMode_3                        := TO_USINT(_data[99]);
            Inputs.Inputs.Joints.JointMode_4                        := TO_USINT(_data[100]);
            Inputs.Inputs.Joints.JointMode_5                        := TO_USINT(_data[101]);

            //INPUTS T20 TCP => st_URO_CB3_T2OTcpData
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_TCP), _data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1204, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1204;
                RETURN;
            END_IF;
            _dword.%B3                                              := _data[0];
            _dword.%B2                                              := _data[1];
            _dword.%B1                                              := _data[2];
            _dword.%B0                                              := _data[3];
            Inputs.Inputs.TCP.Postition.X                           := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[4];
            _dword.%B2                                              := _data[5];
            _dword.%B1                                              := _data[6];
            _dword.%B0                                              := _data[7];
            Inputs.Inputs.TCP.Postition.Y                           := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.TCP.Postition.Z                           := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.TCP.Postition.Rx                          := TO_REAL(_dword);  

            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.TCP.Postition.Ry                          := TO_REAL(_dword);  

            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.TCP.Postition.Rz                          := TO_REAL(_dword);  

            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.TCP.Velocity.X                            := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[28];
            _dword.%B2                                              := _data[29];
            _dword.%B1                                              := _data[30];
            _dword.%B0                                              := _data[31];
            Inputs.Inputs.TCP.Velocity.Y                            := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[32];
            _dword.%B2                                              := _data[33];
            _dword.%B1                                              := _data[34];
            _dword.%B0                                              := _data[35];
            Inputs.Inputs.TCP.Velocity.Z                            := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.TCP.Velocity.Rx                           := TO_REAL(_dword);  

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.TCP.Velocity.Ry                           := TO_REAL(_dword);  

            _dword.%B3                                              := _data[44];
            _dword.%B2                                              := _data[45];
            _dword.%B1                                              := _data[46];
            _dword.%B0                                              := _data[47];
            Inputs.Inputs.TCP.Velocity.Rz                           := TO_REAL(_dword);  

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.TCP.Force.X                               := TO_REAL(_dword);  

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.TCP.Force.Y                               := TO_REAL(_dword);  

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.TCP.Force.Z                               := TO_REAL(_dword);  

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.TCP.Torque.X                              := TO_REAL(_dword);  

            _dword.%B3                                              := _data[64];
            _dword.%B2                                              := _data[65];
            _dword.%B1                                              := _data[66];
            _dword.%B0                                              := _data[67];
            Inputs.Inputs.TCP.Torque.Y                              := TO_REAL(_dword);  

            _dword.%B3                                              := _data[68];
            _dword.%B2                                              := _data[69];
            _dword.%B1                                              := _data[70];
            _dword.%B0                                              := _data[71];
            Inputs.Inputs.TCP.Torque.Z                              := TO_REAL(_dword);  

            _dword.%B3                                              := _data[72];
            _dword.%B2                                              := _data[73];
            _dword.%B1                                              := _data[74];
            _dword.%B0                                              := _data[75];
            Inputs.Inputs.TCP.TCP_ForceScalar                       := TO_REAL(_dword);  

            //INPUTS T20 BITS => st_URO_CB3_T2OBitRegsData
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers), _data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1205, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1205;
                RETURN;
            END_IF;
            Inputs.Inputs.Bits.Register_0                           := _data[0].%X0;
            Inputs.Inputs.Bits.Register_1                           := _data[0].%X1;
            Inputs.Inputs.Bits.Register_2                           := _data[0].%X2;
            Inputs.Inputs.Bits.Register_3                           := _data[0].%X3;
            Inputs.Inputs.Bits.Register_4                           := _data[0].%X4;
            Inputs.Inputs.Bits.Register_5                           := _data[0].%X5;
            Inputs.Inputs.Bits.Register_6                           := _data[0].%X6;
            Inputs.Inputs.Bits.Register_7                           := _data[0].%X7;

            Inputs.Inputs.Bits.Register_8                           := _data[1].%X0;
            Inputs.Inputs.Bits.Register_9                           := _data[1].%X1;
            Inputs.Inputs.Bits.Register_10                          := _data[1].%X2;
            Inputs.Inputs.Bits.Register_11                          := _data[1].%X3;
            Inputs.Inputs.Bits.Register_12                          := _data[1].%X4;
            Inputs.Inputs.Bits.Register_13                          := _data[1].%X5;
            Inputs.Inputs.Bits.Register_14                          := _data[1].%X6;
            Inputs.Inputs.Bits.Register_15                          := _data[1].%X7;

            Inputs.Inputs.Bits.Register_16                          := _data[2].%X0;
            Inputs.Inputs.Bits.Register_17                          := _data[2].%X1;
            Inputs.Inputs.Bits.Register_18                          := _data[2].%X2;
            Inputs.Inputs.Bits.Register_19                          := _data[2].%X3;
            Inputs.Inputs.Bits.Register_20                          := _data[2].%X4;
            Inputs.Inputs.Bits.Register_21                          := _data[2].%X5;
            Inputs.Inputs.Bits.Register_22                          := _data[2].%X6;
            Inputs.Inputs.Bits.Register_23                          := _data[2].%X7;

            Inputs.Inputs.Bits.Register_24                          := _data[3].%X0;
            Inputs.Inputs.Bits.Register_25                          := _data[3].%X1;
            Inputs.Inputs.Bits.Register_26                          := _data[3].%X2;
            Inputs.Inputs.Bits.Register_27                          := _data[3].%X3;
            Inputs.Inputs.Bits.Register_28                          := _data[3].%X4;
            Inputs.Inputs.Bits.Register_29                          := _data[3].%X5;
            Inputs.Inputs.Bits.Register_30                          := _data[3].%X6;
            Inputs.Inputs.Bits.Register_31                          := _data[3].%X7;
            
            Inputs.Inputs.Bits.Register_32                          := _data[4].%X0;
            Inputs.Inputs.Bits.Register_33                          := _data[4].%X1;
            Inputs.Inputs.Bits.Register_34                          := _data[4].%X2;
            Inputs.Inputs.Bits.Register_35                          := _data[4].%X3;
            Inputs.Inputs.Bits.Register_36                          := _data[4].%X4;
            Inputs.Inputs.Bits.Register_37                          := _data[4].%X5;
            Inputs.Inputs.Bits.Register_38                          := _data[4].%X6;
            Inputs.Inputs.Bits.Register_39                          := _data[4].%X7;

            Inputs.Inputs.Bits.Register_40                          := _data[5].%X0;
            Inputs.Inputs.Bits.Register_41                          := _data[5].%X1;
            Inputs.Inputs.Bits.Register_42                          := _data[5].%X2;
            Inputs.Inputs.Bits.Register_43                          := _data[5].%X3;
            Inputs.Inputs.Bits.Register_44                          := _data[5].%X4;
            Inputs.Inputs.Bits.Register_45                          := _data[5].%X5;
            Inputs.Inputs.Bits.Register_46                          := _data[5].%X6;
            Inputs.Inputs.Bits.Register_47                          := _data[5].%X7;

            Inputs.Inputs.Bits.Register_48                          := _data[6].%X0;
            Inputs.Inputs.Bits.Register_49                          := _data[6].%X1;
            Inputs.Inputs.Bits.Register_50                          := _data[6].%X2;
            Inputs.Inputs.Bits.Register_51                          := _data[6].%X3;
            Inputs.Inputs.Bits.Register_52                          := _data[6].%X4;
            Inputs.Inputs.Bits.Register_53                          := _data[6].%X5;
            Inputs.Inputs.Bits.Register_54                          := _data[6].%X6;
            Inputs.Inputs.Bits.Register_55                          := _data[6].%X7;

            Inputs.Inputs.Bits.Register_56                          := _data[7].%X0;
            Inputs.Inputs.Bits.Register_57                          := _data[7].%X1;
            Inputs.Inputs.Bits.Register_58                          := _data[7].%X2;
            Inputs.Inputs.Bits.Register_59                          := _data[7].%X3;
            Inputs.Inputs.Bits.Register_60                          := _data[7].%X4;
            Inputs.Inputs.Bits.Register_61                          := _data[7].%X5;
            Inputs.Inputs.Bits.Register_62                          := _data[7].%X6;
            Inputs.Inputs.Bits.Register_63                          := _data[7].%X7;

            //INPUTS T20 BITS => st_URO_CB3_T2OIntRegsData
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers), _data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1206, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1206;
                RETURN;
            END_IF;
            _dword.%B3                                              := _data[0];
            _dword.%B2                                              := _data[1];
            _dword.%B1                                              := _data[2];
            _dword.%B0                                              := _data[3];
            Inputs.Inputs.Ints.Register_0                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[4];
            _dword.%B2                                              := _data[5];
            _dword.%B1                                              := _data[6];
            _dword.%B0                                              := _data[7];
            Inputs.Inputs.Ints.Register_1                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.Ints.Register_2                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.Ints.Register_3                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.Ints.Register_4                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.Ints.Register_5                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.Ints.Register_6                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[28];
            _dword.%B2                                              := _data[29];
            _dword.%B1                                              := _data[30];
            _dword.%B0                                              := _data[31];
            Inputs.Inputs.Ints.Register_7                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[32];
            _dword.%B2                                              := _data[33];
            _dword.%B1                                              := _data[34];
            _dword.%B0                                              := _data[35];
            Inputs.Inputs.Ints.Register_8                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.Ints.Register_9                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.Ints.Register_10                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[44];
            _dword.%B2                                              := _data[45];
            _dword.%B1                                              := _data[46];
            _dword.%B0                                              := _data[47];
            Inputs.Inputs.Ints.Register_11                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.Ints.Register_12                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.Ints.Register_13                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.Ints.Register_14                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.Ints.Register_15                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[64];
            _dword.%B2                                              := _data[65];
            _dword.%B1                                              := _data[66];
            _dword.%B0                                              := _data[67];
            Inputs.Inputs.Ints.Register_16                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[68];
            _dword.%B2                                              := _data[69];
            _dword.%B1                                              := _data[70];
            _dword.%B0                                              := _data[71];
            Inputs.Inputs.Ints.Register_17                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[72];
            _dword.%B2                                              := _data[73];
            _dword.%B1                                              := _data[74];
            _dword.%B0                                              := _data[75];
            Inputs.Inputs.Ints.Register_18                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[76];
            _dword.%B2                                              := _data[77];
            _dword.%B1                                              := _data[78];
            _dword.%B0                                              := _data[79];
            Inputs.Inputs.Ints.Register_19                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[80];
            _dword.%B2                                              := _data[81];
            _dword.%B1                                              := _data[82];
            _dword.%B0                                              := _data[83];
            Inputs.Inputs.Ints.Register_20                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[84];
            _dword.%B2                                              := _data[85];
            _dword.%B1                                              := _data[86];
            _dword.%B0                                              := _data[87];
            Inputs.Inputs.Ints.Register_21                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[88];
            _dword.%B2                                              := _data[89];
            _dword.%B1                                              := _data[90];
            _dword.%B0                                              := _data[91];
            Inputs.Inputs.Ints.Register_22                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[92];
            _dword.%B2                                              := _data[93];
            _dword.%B1                                              := _data[94];
            _dword.%B0                                              := _data[95];
            Inputs.Inputs.Ints.Register_23                          := TO_DINT(_dword);

            //INPUTS T20 BITS => st_URO_CB3_T2OFloatRegsData
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers), _data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1207, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1207;
                RETURN;
            END_IF;
            _dword.%B3                                              := _data[0];
            _dword.%B2                                              := _data[1];
            _dword.%B1                                              := _data[2];
            _dword.%B0                                              := _data[3];
            Inputs.Inputs.Floats.Register_0                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[4];
            _dword.%B2                                              := _data[5];
            _dword.%B1                                              := _data[6];
            _dword.%B0                                              := _data[7];
            Inputs.Inputs.Floats.Register_1                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.Floats.Register_2                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.Floats.Register_3                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.Floats.Register_4                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.Floats.Register_5                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.Floats.Register_6                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[28];
            _dword.%B2                                              := _data[29];
            _dword.%B1                                              := _data[30];
            _dword.%B0                                              := _data[31];
            Inputs.Inputs.Floats.Register_7                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[32];
            _dword.%B2                                              := _data[33];
            _dword.%B1                                              := _data[34];
            _dword.%B0                                              := _data[35];
            Inputs.Inputs.Floats.Register_8                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.Floats.Register_9                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.Floats.Register_10                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[44];
            _dword.%B2                                              := _data[45];
            _dword.%B1                                              := _data[46];
            _dword.%B0                                              := _data[47];
            Inputs.Inputs.Floats.Register_11                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.Floats.Register_12                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.Floats.Register_13                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.Floats.Register_14                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.Floats.Register_15                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[64];
            _dword.%B2                                              := _data[65];
            _dword.%B1                                              := _data[66];
            _dword.%B0                                              := _data[67];
            Inputs.Inputs.Floats.Register_16                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[68];
            _dword.%B2                                              := _data[69];
            _dword.%B1                                              := _data[70];
            _dword.%B0                                              := _data[71];
            Inputs.Inputs.Floats.Register_17                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[72];
            _dword.%B2                                              := _data[73];
            _dword.%B1                                              := _data[74];
            _dword.%B0                                              := _data[75];
            Inputs.Inputs.Floats.Register_18                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[76];
            _dword.%B2                                              := _data[77];
            _dword.%B1                                              := _data[78];
            _dword.%B0                                              := _data[79];
            Inputs.Inputs.Floats.Register_19                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[80];
            _dword.%B2                                              := _data[81];
            _dword.%B1                                              := _data[82];
            _dword.%B0                                              := _data[83];
            Inputs.Inputs.Floats.Register_20                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[84];
            _dword.%B2                                              := _data[85];
            _dword.%B1                                              := _data[86];
            _dword.%B0                                              := _data[87];
            Inputs.Inputs.Floats.Register_21                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[88];
            _dword.%B2                                              := _data[89];
            _dword.%B1                                              := _data[90];
            _dword.%B0                                              := _data[91];
            Inputs.Inputs.Floats.Register_22                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[92];
            _dword.%B2                                              := _data[93];
            _dword.%B1                                              := _data[94];
            _dword.%B0                                              := _data[95];
            Inputs.Inputs.Floats.Register_23                        := TO_REAL(_dword);


             Inputs.RobotMode := THIS.GetRobotModeDescription(Inputs.Inputs.Robot.RobotMode);
            //SYSTEM INPUTS
            //Area/positions flags this  should be obsolete because Zones and InPosition is used as byte below
            Inputs.InArea_1                                         := Inputs.Inputs.Bits.Register_0;
            Inputs.InArea_2                                         := Inputs.Inputs.Bits.Register_1;
            Inputs.InArea_3                                         := Inputs.Inputs.Bits.Register_2;
            Inputs.InArea_4                                         := Inputs.Inputs.Bits.Register_3;
            Inputs.InPosition_1                                     := Inputs.Inputs.Bits.Register_4;
            Inputs.InPosition_2                                     := Inputs.Inputs.Bits.Register_5;
            Inputs.InPosition_3                                     := Inputs.Inputs.Bits.Register_6;
            Inputs.InPosition_4                                     := Inputs.Inputs.Bits.Register_7;
            
            //Tool signals

            Inputs.Tool_1_Retract                                   := Inputs.Inputs.Bits.Register_8;
            Inputs.Tool_1_Extend                                    := Inputs.Inputs.Bits.Register_9;
            Inputs.Tool_2_Retract                                   := Inputs.Inputs.Bits.Register_10;
            Inputs.Tool_2_Extend                                    := Inputs.Inputs.Bits.Register_11;
            Inputs.Tool_3_Retract                                   := Inputs.Inputs.Bits.Register_12;
            Inputs.Tool_3_Extend                                    := Inputs.Inputs.Bits.Register_13;
            Inputs.Tool_4_Retract                                   := Inputs.Inputs.Bits.Register_14;
            Inputs.Tool_4_Extend                                    := Inputs.Inputs.Bits.Register_15;

            Inputs.Zone                                             := Inputs.Inputs.Ints.Register_0;
            Inputs.InPosition                                       := Inputs.Inputs.Ints.Register_1;

           //Movement parameters
            Inputs.ActionNo                                         := Inputs.Inputs.Ints.Register_2;
            Inputs.GlobalSpeed                                      := Inputs.Inputs.Ints.Register_3;
            Inputs.ToolNo                                           := Inputs.Inputs.Ints.Register_4;
            Inputs.WorkobjectNo                                     := Inputs.Inputs.Ints.Register_5;
            Inputs.PointNo                                          := Inputs.Inputs.Ints.Register_6;

            Inputs.UserSpecSpeed1                                   := Inputs.Inputs.Floats.Register_0;
            Inputs.UserSpecSpeed2                                   := Inputs.Inputs.Floats.Register_1;
            Inputs.Coordinates.X                                    := Inputs.Inputs.Floats.Register_2;
            Inputs.Coordinates.Y                                    := Inputs.Inputs.Floats.Register_3;
            Inputs.Coordinates.Z                                    := Inputs.Inputs.Floats.Register_4;
            Inputs.Coordinates.Rx                                   := Inputs.Inputs.Floats.Register_5;
            Inputs.Coordinates.Ry                                   := Inputs.Inputs.Floats.Register_6;
            Inputs.Coordinates.Rz                                   := Inputs.Inputs.Floats.Register_7;

            //*************StartAtMainTask***************
            StartAtMainTask.SetIsDisabled(_stopTasksAreActive);
            IF StartAtMainTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StartAtMainTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _power_progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 300;
                END_IF;
                
                IF _power_progress = 300 THEN  
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#500;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#501;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _power_progress:=302;                    
                    END_IF;
                END_IF;

                IF _power_progress = 302 THEN  
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    Outputs.Start:=_blink.output;	

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Start := FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress:=303;                    
                    END_IF;
                END_IF;

                IF _power_progress = 303 THEN  
                    StartAtMainTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _power_progress := 0;
                END_IF;

                THIS.CallTimers(TRUE);
                StartAtMainTask.ThrowWhen(_errorTimer.output );
                Status.Action.Id := TO_UINT(_power_progress);
                StartAtMainTask.ThrowWhen(StartAtMainTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StartAtMainTask timeout.');                
            END_IF;
            IF StartAtMainTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF StartAtMainTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF StartAtMainTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10000,StartAtMainTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,StartAtMainTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,StartAtMainTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartAtMainTask.RestoreTriggered() AND _power_progress >= 300 AND _power_progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _power_progress := 0;
            END_IF;
            //*******************************************

            //***********StartMotorsAndProgramTask*******
            StartMotorsAndProgramTask.SetIsDisabled(_stopTasksAreActive);
            IF StartMotorsAndProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#110,StartMotorsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,StartMotorsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsAndProgramTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _power_progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 310;
                END_IF;
              
                IF _power_progress = 310 THEN  
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#510;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#511;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _power_progress:=312;                    
                    END_IF;
                END_IF;

                IF _power_progress = 312 THEN	//Reseting error
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 313;
                    END_IF;
                END_IF;
              
                IF _power_progress = 313 THEN	//Reseting emergency stop error
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.ES_IsEmergencyStopped  THEN
                            TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#513;
                        END_IF;
                        IF Inputs.Inputs.Safety.PS_IsProtectiveStopped  THEN
                            TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#514;
                        END_IF;
                        IF Inputs.Inputs.Safety.SS_IsSafeguardStopped  THEN
                            TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#515;
                        END_IF;
                        IF Inputs.Inputs.Safety.RC_IsRecoveryMode  THEN
                            TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#516;
                        END_IF;
                        IF Inputs.Inputs.Safety.ST_IsStoppedDueSafety  THEN
                            TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#517;
                        END_IF;
                        IF Inputs.Inputs.Safety.VL_IsViolation  THEN
                            TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#518;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.ES_IsEmergencyStopped 
                        AND NOT Inputs.Inputs.Safety.PS_IsProtectiveStopped  
                        AND NOT Inputs.Inputs.Safety.SS_IsSafeguardStopped  
                        AND NOT Inputs.Inputs.Safety.RC_IsRecoveryMode 
                        AND NOT Inputs.Inputs.Safety.ST_IsStoppedDueSafety 
                        AND NOT Inputs.Inputs.Safety.VL_IsViolation THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 319;
                    END_IF;
                END_IF;
              
                IF _power_progress = 319 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#519, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#519;
                    END_IF;

                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _power_progress := 310;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _power_progress := 320;
                    END_IF;
                END_IF;		

                IF _power_progress = 320 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#520;
                    END_IF;

                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _power_progress := 310;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _power_progress := 321;
                    END_IF;
                END_IF;		

                IF _power_progress = 321 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;

                    Outputs.Start:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _power_progress := 310;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                         Outputs.Start:=FALSE;
                         THIS.CallTimers(FALSE);
                         _power_progress := 322;
                    END_IF;
                END_IF;		
              
                IF _power_progress = 322 THEN	
                    StartMotorsAndProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _power_progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StartMotorsAndProgramTask.ThrowWhen(StartMotorsAndProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StartMotorsAndProgramTask timeout.');                
            END_IF;
            IF StartMotorsAndProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF StartMotorsAndProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF StartMotorsAndProgramTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;         
            Messenger.ActivateOnCondition(ULINT#10010,StartMotorsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,StartMotorsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,StartMotorsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMotorsAndProgramTask.RestoreTriggered() AND _power_progress >= 310 AND _power_progress <= 329  THEN
                Status.Action.Id :=  UINT#112;
                _power_progress := 0;
            END_IF;   
            //*******************************************
                        
            //***********StartMovementsTask**************
            StartMovementsTask.SetIsDisabled(NOT Inputs.Inputs.Robot.PW_IsPowerOn);
            IF StartMovementsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#180,StartMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,StartMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMovementsTask.Execute(THIS) THEN
                IF _movement_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _movement_progress := 380;
                END_IF;
                
                IF _movement_progress = 380 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#580, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#580;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 381;
                    END_IF;
                END_IF;
                
                IF _movement_progress = 381 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#581, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#581;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 382;
                    END_IF;
                END_IF;
                
                IF _movement_progress = 382 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#582, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#582;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 383;
                    END_IF;
                END_IF;
                
                IF _movement_progress = 383 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#583, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#583;
                    END_IF;

                    Outputs.GlobalSpeed     := TO_DINT(Status.CurrentMovementParameters.GlobalSpeed);
                    Outputs.ToolNo          := TO_DINT(Status.CurrentMovementParameters.ToolNo);
                    Outputs.WorkobjectNo    := TO_DINT(Status.CurrentMovementParameters.WorkobjectNo);
                    Outputs.PointNo         := TO_DINT(Status.CurrentMovementParameters.PointNo);
                    Outputs.UserSpecSpeed1  := Status.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := Status.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := Status.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := DINT#254;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 384;
                    END_IF;
                END_IF;
                
                IF _movement_progress = 384 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> TO_DINT(Status.CurrentMovementParameters.GlobalSpeed) THEN
                            TaskMessenger.Activate( UINT#584, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#584;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> TO_DINT(Status.CurrentMovementParameters.ToolNo) THEN
                            TaskMessenger.Activate( UINT#585, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#585;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> TO_DINT(Status.CurrentMovementParameters.WorkobjectNo) THEN
                            TaskMessenger.Activate( UINT#586, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#586;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> TO_DINT(Status.CurrentMovementParameters.PointNo) THEN
                            TaskMessenger.Activate( UINT#587, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#587;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> Status.CurrentMovementParameters.UserSpecSpeed1 THEN
                            TaskMessenger.Activate( UINT#588, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#588;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> Status.CurrentMovementParameters.UserSpecSpeed2 THEN
                            TaskMessenger.Activate( UINT#589, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#589;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = TO_DINT(Status.CurrentMovementParameters.GlobalSpeed) AND
                        Inputs.ToolNo           = TO_DINT(Status.CurrentMovementParameters.ToolNo) AND
                        Inputs.WorkobjectNo     = TO_DINT(Status.CurrentMovementParameters.WorkobjectNo) AND
                        Inputs.PointNo          = TO_DINT(Status.CurrentMovementParameters.PointNo) AND
                        Inputs.UserSpecSpeed1   = Status.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = Status.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,Status.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress:=390;
                    END_IF;
                END_IF;		

                IF _movement_progress = 390 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#590, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#590;
                    END_IF;

                    Outputs.ActionNo := DINT#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress:=391;
                    END_IF;
                END_IF;	
                
                IF _movement_progress = 391 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#591;
                    END_IF;

                    Outputs.ActionNo := TO_DINT(Status.CurrentMovementParameters.ActionNo);

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress:=392;
                    END_IF;
                END_IF;	

                IF _movement_progress = 392 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#592, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#592;
                    END_IF;

                    Outputs.ActionNo := DINT#255;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        _movement_progress := 0;
                        StartMovementsTask.DoneWhen(TRUE);
                    END_IF;
                END_IF;	
                
	            THIS.CallTimers(TRUE);
                
                StartMovementsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_movement_progress);
                StartMovementsTask.ThrowWhen(StartMovementsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StartMovementsTask timeout.');                
            END_IF;
            IF StartMovementsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF StartMovementsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10080;
                Status.Error.Id  :=  UINT#10080;
            ELSIF StartMovementsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10081;
                Status.Error.Id  :=  UINT#10081;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10080,StartMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10081,StartMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,StartMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMovementsTask.RestoreTriggered() AND _movement_progress >= 380 AND _movement_progress <= 399  THEN
                Status.Action.Id :=  UINT#182;
                _movement_progress := 0;
            END_IF;
            //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.SetIsDisabled(FALSE);
            IF StopMovementsAndProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#210;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#210,StopMovementsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#211,StopMovementsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsAndProgramTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 410;
                END_IF;
                
                IF _power_progress = 410 THEN  
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            TaskMessenger.Activate( UINT#610, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#610;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            TaskMessenger.Activate( UINT#611, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#611;
                        END_IF;      
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _power_progress:=412;                    
                    END_IF;
                END_IF;

                IF _power_progress = 412 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#612, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#612;
                    END_IF;

                    Outputs.Stop := TRUE;

                    IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Stop := FALSE ;
                        THIS.CallTimers(FALSE);
                        _power_progress:=413;                    
                    END_IF;                    
                END_IF;                    

                IF _power_progress = 413 THEN
                    Outputs.Stop := FALSE ;
                    StopMovementsAndProgramTask.DoneWhen(TRUE);
                    _power_progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);                
                StopMovementsAndProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StopMovementsAndProgramTask.ThrowWhen(StopMovementsAndProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StopMovementsAndProgramTask timeout.');                
            END_IF;
            IF StopMovementsAndProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#211;
                Status.Error.Id :=  UINT#0;
            ELSIF StopMovementsAndProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10110;
                Status.Error.Id  :=  UINT#10110;
            ELSIF StopMovementsAndProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10111;
                Status.Error.Id  :=  UINT#10111;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10110,StopMovementsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10111,StopMovementsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#212,StopMovementsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsAndProgramTask.RestoreTriggered() AND _power_progress >= 410 AND _power_progress <= 419  THEN
                Status.Action.Id :=  UINT#212;
                _power_progress := 0;
            END_IF;
            //*******************************************
            
            //***********StopMovementsTask***************
            StopMovementsTask.SetIsDisabled(FALSE);
            IF StopMovementsAndProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#220;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#220,StopMovementsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#221,StopMovementsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 420;
                END_IF;
               
                IF _power_progress = 420 THEN 
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            TaskMessenger.Activate( UINT#620, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#620;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            TaskMessenger.Activate( UINT#621, eAxoMessageCategory#Warning);
                            Status.Error.Id :=      UINT#621;
                        END_IF;      
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _power_progress:=422;                    
                    END_IF;
                END_IF;

                IF _power_progress = 422 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#622, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#622;
                    END_IF; 

                    Outputs.Pause := TRUE;

                    IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Pause := FALSE ;
                        THIS.CallTimers(FALSE);
                        _power_progress:=423;                    
                    END_IF;                    
                END_IF;                    

                IF _power_progress = 423 THEN
                    Outputs.Pause := FALSE ;
                    StopMovementsTask.DoneWhen(TRUE);
                    _power_progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                StopMovementsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StopMovementsTask.ThrowWhen(StopMovementsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StopMovementsTask timeout.');                
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#221;
                Status.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10120;
                Status.Error.Id  :=  UINT#10120;
            ELSIF StopMovementsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10121;
                Status.Error.Id  :=  UINT#10121;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10120,StopMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10121,StopMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#222,StopMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsTask.RestoreTriggered() AND _power_progress >= 420 AND _power_progress <= 429  THEN
                Status.Action.Id :=  UINT#222;
                _power_progress := 0;
            END_IF;
            //*******************************************

            //*************POWER ON********************
            PowerOnTask.SetIsDisabled(NOT(Inputs.RobotMode=eAxoUrRoboticsRobotMode#DISCONNECTED AND Config.RemotePowerOnEnabled));
            IF PowerOnTask.Execute(THIS) THEN
                refPowerOnPulse^ :=TRUE;
                Status.Action.Id :=  UINT#420;//('<#POWER ON PULSE WAS SEND TO CONTROLER#>');
                PowerOnTask.DoneWhen(PowerOnTask.Duration > Config.RemotePowerOnPulse);
            END_IF;

            IF refPowerOnPulse^ AND PowerOnTask.IsDone()  OR NOT Config.RemotePowerOnEnabled THEN
                refPowerOnPulse^ :=FALSE;
            END_IF;

            //****************************************

            _someTaskIsActive := StartAtMainTask.IsBusy()
                                OR StartMotorsAndProgramTask.IsBusy()
                                OR StartMovementsTask.IsBusy()
                                OR StopMovementsTask.IsBusy()
                                OR StopMovementsAndProgramTask.IsBusy();
            

            IF _someTaskIsActive THEN
                IF(Inputs.Inputs.Safety.ES_IsEmergencyStopped) THEN
                    Messenger.Activate(UINT#2000, eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#2000;
                END_IF;
                IF(Inputs.Inputs.Safety.ST_IsStoppedDueSafety) THEN
                    Messenger.Activate(UINT#2001, eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#2001;
                END_IF;
            END_IF;
            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            Outputs.Outputs.Reg1.Bit_0 := Outputs.Start;
            Outputs.outputs.Reg1.Bit_1 := Outputs.Stop;
            Outputs.outputs.Reg1.Bit_2 := Outputs.Pause;
            Outputs.outputs.Reg1.Bit_3 := Outputs.MotorOn;
            //Outputs.outputs.Reg1.Bit_4 := Outputs.RunAction;

            //Tool signals
            Outputs.Outputs.Reg1.Bit_8 := Outputs.Tool_1_Retract;
            Outputs.outputs.Reg1.Bit_9 := Outputs.Tool_1_Extend;
            Outputs.outputs.Reg1.Bit_10 := Outputs.Tool_2_Retract;
            Outputs.outputs.Reg1.Bit_11 := Outputs.Tool_2_Extend;
            Outputs.outputs.Reg1.Bit_12 := Outputs.Tool_3_Retract;
            Outputs.outputs.Reg1.Bit_13 := Outputs.Tool_3_Extend;
            Outputs.outputs.Reg1.Bit_14 := Outputs.Tool_4_Retract;
            Outputs.outputs.Reg1.Bit_15 := Outputs.Tool_4_Extend;


            //zone
            Outputs.Outputs.Reg1.Int_0 := Outputs.Zone;
            //position
            Outputs.Outputs.Reg1.Int_1 := Outputs.InPosition;

            //Movement parameters
            Outputs.Outputs.Reg1.Int_2 := Outputs.ActionNo;
            Outputs.Outputs.Reg1.Int_3 := Outputs.GlobalSpeed;
            Outputs.Outputs.Reg1.Int_4 := Outputs.ToolNo;
            Outputs.Outputs.Reg1.Int_5 := Outputs.WorkobjectNo;
            Outputs.Outputs.Reg1.Int_6 := Outputs.PointNo;
            //master mode  such as manual/auto ....
            Outputs.Outputs.Reg1.Int_7 := TO_DINT(Outputs.MasterMode);

            Outputs.Outputs.Reg1.Float_0 := Outputs.UserSpecSpeed1;
            Outputs.Outputs.Reg1.Float_1 := Outputs.UserSpecSpeed2;

            ////Coordinates
            Outputs.Outputs.Reg1.Float_2 := Outputs.Coordinates.X ;
            Outputs.Outputs.Reg1.Float_3 := Outputs.Coordinates.Y;
            Outputs.Outputs.Reg1.Float_4 := Outputs.Coordinates.Z ;
            Outputs.Outputs.Reg1.Float_5 := (Outputs.Coordinates.Rx);
            Outputs.Outputs.Reg1.Float_6 := (Outputs.Coordinates.Ry);
            Outputs.Outputs.Reg1.Float_7 := (Outputs.Coordinates.Rz);

            //st_URO_CB3_O2TSpeedData => 8_O2T Robot IO
            _data24[0].%X0 := Outputs.Outputs.Speed.SSM_SpeedSliderFractionMask;

            _dword := TO_DWORD(Outputs.Outputs.Speed.SpeedSliderFraction * REAL#0.01);
            _data24[4] := _dword.%B3;
            _data24[5] := _dword.%B2;
            _data24[6] := _dword.%B1;
            _data24[7] := _dword.%B0;

            //st_URO_CB3_O2TIoData => 8_O2T Robot IO
            _data24[8]  := TO_BYTE(Outputs.Outputs.IO.StandardDigitalOutputMask);
            _data24[9]  := TO_BYTE(Outputs.Outputs.IO.ConfigurableDigitalOutputMask);
            _data24[10] := TO_BYTE(Outputs.Outputs.IO.StandardDigitalOutputs);
            _data24[11] := TO_BYTE(Outputs.Outputs.IO.ConfigurableDdigitalOutputs);
            _data24[12] := TO_BYTE(Outputs.Outputs.IO.AOM_AnalogOutputMask);
            _data24[13] := TO_BYTE(Outputs.Outputs.IO.AOT_AnalogOutputTypes);
            _data24[14] := TO_BYTE(Outputs.Outputs.IO.TDOM_ToolDigitalOutputMask);
            _data24[15] := TO_BYTE(Outputs.Outputs.IO.TDO_ToolDigitalOutput);

            _dword := TO_DWORD(Outputs.Outputs.IO.StandardAnalogOutput_0);
            _data24[16] := _dword.%B3;
            _data24[17] := _dword.%B2;
            _data24[18] := _dword.%B1;
            _data24[19] := _dword.%B0;

            _dword := TO_DWORD(Outputs.Outputs.IO.StandardAnalogOutput_1);
            _data24[20] := _dword.%B3;
            _data24[21] := _dword.%B2;
            _data24[22] := _dword.%B1;
            _data24[23] := _dword.%B0;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_O2T_Robot_IO),_data24);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF; 

            //st_URO_CB3_O2TRegData => 9_O2T General Purpose Registers 1
            _data100[0].%X0 :=  Outputs.Outputs.Reg1.Bit_0;
            _data100[0].%X1 :=  Outputs.Outputs.Reg1.Bit_1;
            _data100[0].%X2 :=  Outputs.Outputs.Reg1.Bit_2;
            _data100[0].%X3 :=  Outputs.Outputs.Reg1.Bit_3;
            _data100[0].%X4 :=  Outputs.Outputs.Reg1.Bit_4;
            _data100[0].%X5 :=  Outputs.Outputs.Reg1.Bit_5;
            _data100[0].%X6 :=  Outputs.Outputs.Reg1.Bit_6;
            _data100[0].%X7 :=  Outputs.Outputs.Reg1.Bit_7;

            _data100[1].%X0 :=  Outputs.Outputs.Reg1.Bit_8;
            _data100[1].%X1 :=  Outputs.Outputs.Reg1.Bit_9;
            _data100[1].%X2 :=  Outputs.Outputs.Reg1.Bit_10;
            _data100[1].%X3 :=  Outputs.Outputs.Reg1.Bit_11;
            _data100[1].%X4 :=  Outputs.Outputs.Reg1.Bit_12;
            _data100[1].%X5 :=  Outputs.Outputs.Reg1.Bit_13;
            _data100[1].%X6 :=  Outputs.Outputs.Reg1.Bit_14;
            _data100[1].%X7 :=  Outputs.Outputs.Reg1.Bit_15;

            _data100[2].%X0 :=  Outputs.Outputs.Reg1.Bit_16;
            _data100[2].%X1 :=  Outputs.Outputs.Reg1.Bit_17;
            _data100[2].%X2 :=  Outputs.Outputs.Reg1.Bit_18;
            _data100[2].%X3 :=  Outputs.Outputs.Reg1.Bit_19;
            _data100[2].%X4 :=  Outputs.Outputs.Reg1.Bit_20;
            _data100[2].%X5 :=  Outputs.Outputs.Reg1.Bit_21;
            _data100[2].%X6 :=  Outputs.Outputs.Reg1.Bit_22;
            _data100[2].%X7 :=  Outputs.Outputs.Reg1.Bit_23;

            _data100[3].%X0 :=  Outputs.Outputs.Reg1.Bit_24;
            _data100[3].%X1 :=  Outputs.Outputs.Reg1.Bit_25;
            _data100[3].%X2 :=  Outputs.Outputs.Reg1.Bit_26;
            _data100[3].%X3 :=  Outputs.Outputs.Reg1.Bit_27;
            _data100[3].%X4 :=  Outputs.Outputs.Reg1.Bit_28;
            _data100[3].%X5 :=  Outputs.Outputs.Reg1.Bit_29;
            _data100[3].%X6 :=  Outputs.Outputs.Reg1.Bit_30;
            _data100[3].%X7 :=  Outputs.Outputs.Reg1.Bit_31;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_0);
            _data100[4]     := _dword.%B3;
            _data100[5]     := _dword.%B2;
            _data100[6]     := _dword.%B1;
            _data100[7]     := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_1);
            _data100[8]     := _dword.%B3;
            _data100[9]     := _dword.%B2;
            _data100[10]    := _dword.%B1;
            _data100[11]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_2);
            _data100[12]    := _dword.%B3;
            _data100[13]    := _dword.%B2;
            _data100[14]    := _dword.%B1;
            _data100[15]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_3);
            _data100[16]    := _dword.%B3;
            _data100[17]    := _dword.%B2;
            _data100[18]    := _dword.%B1;
            _data100[19]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_4);
            _data100[20]    := _dword.%B3;
            _data100[21]    := _dword.%B2;
            _data100[22]    := _dword.%B1;
            _data100[23]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_5);
            _data100[24]    := _dword.%B3;
            _data100[25]    := _dword.%B2;
            _data100[26]    := _dword.%B1;
            _data100[27]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_6);
            _data100[28]    := _dword.%B3;
            _data100[29]    := _dword.%B2;
            _data100[30]    := _dword.%B1;
            _data100[31]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_7);
            _data100[32]    := _dword.%B3;
            _data100[33]    := _dword.%B2;
            _data100[34]    := _dword.%B1;
            _data100[35]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_8);
            _data100[36]    := _dword.%B3;
            _data100[37]    := _dword.%B2;
            _data100[38]    := _dword.%B1;
            _data100[39]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_9);
            _data100[40]    := _dword.%B3;
            _data100[41]    := _dword.%B2;
            _data100[42]    := _dword.%B1;
            _data100[43]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_10);
            _data100[44]    := _dword.%B3;
            _data100[45]    := _dword.%B2;
            _data100[46]    := _dword.%B1;
            _data100[47]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_11);
            _data100[48]    := _dword.%B3;
            _data100[49]    := _dword.%B2;
            _data100[50]    := _dword.%B1;
            _data100[51]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_0);
            _data100[52]    := _dword.%B3;
            _data100[53]    := _dword.%B2;
            _data100[54]    := _dword.%B1;
            _data100[55]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_1);
            _data100[56]    := _dword.%B3;
            _data100[57]    := _dword.%B2;
            _data100[58]    := _dword.%B1;
            _data100[59]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_2);
            _data100[60]    := _dword.%B3;
            _data100[61]    := _dword.%B2;
            _data100[62]    := _dword.%B1;
            _data100[63]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_3);
            _data100[64]    := _dword.%B3;
            _data100[65]    := _dword.%B2;
            _data100[66]    := _dword.%B1;
            _data100[67]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_4);
            _data100[68]    := _dword.%B3;
            _data100[69]    := _dword.%B2;
            _data100[70]    := _dword.%B1;
            _data100[71]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_5);
            _data100[72]    := _dword.%B3;
            _data100[73]    := _dword.%B2;
            _data100[74]    := _dword.%B1;
            _data100[75]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_6);
            _data100[76]    := _dword.%B3;
            _data100[77]    := _dword.%B2;
            _data100[78]    := _dword.%B1;
            _data100[79]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_7);
            _data100[80]    := _dword.%B3;
            _data100[81]    := _dword.%B2;
            _data100[82]    := _dword.%B1;
            _data100[83]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_8);
            _data100[84]    := _dword.%B3;
            _data100[85]    := _dword.%B2;
            _data100[86]    := _dword.%B1;
            _data100[87]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_9);
            _data100[88]    := _dword.%B3;
            _data100[89]    := _dword.%B2;
            _data100[90]    := _dword.%B1;
            _data100[91]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_10);
            _data100[92]    := _dword.%B3;
            _data100[93]    := _dword.%B2;
            _data100[94]    := _dword.%B1;
            _data100[95]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_11);
            _data100[96]    := _dword.%B3;
            _data100[97]    := _dword.%B2;
            _data100[98]    := _dword.%B1;
            _data100[99]    := _dword.%B0;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1),_data100);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1232, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1232;
                RETURN;
            END_IF; 

            //st_URO_CB3_O2TRegData => 10_O2T General Purpose Registers 2
            _data100[0].%X0 :=  Outputs.Outputs.Reg2.Bit_0;
            _data100[0].%X1 :=  Outputs.Outputs.Reg2.Bit_1;
            _data100[0].%X2 :=  Outputs.Outputs.Reg2.Bit_2;
            _data100[0].%X3 :=  Outputs.Outputs.Reg2.Bit_3;
            _data100[0].%X4 :=  Outputs.Outputs.Reg2.Bit_4;
            _data100[0].%X5 :=  Outputs.Outputs.Reg2.Bit_5;
            _data100[0].%X6 :=  Outputs.Outputs.Reg2.Bit_6;
            _data100[0].%X7 :=  Outputs.Outputs.Reg2.Bit_7;

            _data100[1].%X0 :=  Outputs.Outputs.Reg2.Bit_8;
            _data100[1].%X1 :=  Outputs.Outputs.Reg2.Bit_9;
            _data100[1].%X2 :=  Outputs.Outputs.Reg2.Bit_10;
            _data100[1].%X3 :=  Outputs.Outputs.Reg2.Bit_11;
            _data100[1].%X4 :=  Outputs.Outputs.Reg2.Bit_12;
            _data100[1].%X5 :=  Outputs.Outputs.Reg2.Bit_13;
            _data100[1].%X6 :=  Outputs.Outputs.Reg2.Bit_14;
            _data100[1].%X7 :=  Outputs.Outputs.Reg2.Bit_15;

            _data100[2].%X0 :=  Outputs.Outputs.Reg2.Bit_16;
            _data100[2].%X1 :=  Outputs.Outputs.Reg2.Bit_17;
            _data100[2].%X2 :=  Outputs.Outputs.Reg2.Bit_18;
            _data100[2].%X3 :=  Outputs.Outputs.Reg2.Bit_19;
            _data100[2].%X4 :=  Outputs.Outputs.Reg2.Bit_20;
            _data100[2].%X5 :=  Outputs.Outputs.Reg2.Bit_21;
            _data100[2].%X6 :=  Outputs.Outputs.Reg2.Bit_22;
            _data100[2].%X7 :=  Outputs.Outputs.Reg2.Bit_23;

            _data100[3].%X0 :=  Outputs.Outputs.Reg2.Bit_24;
            _data100[3].%X1 :=  Outputs.Outputs.Reg2.Bit_25;
            _data100[3].%X2 :=  Outputs.Outputs.Reg2.Bit_26;
            _data100[3].%X3 :=  Outputs.Outputs.Reg2.Bit_27;
            _data100[3].%X4 :=  Outputs.Outputs.Reg2.Bit_28;
            _data100[3].%X5 :=  Outputs.Outputs.Reg2.Bit_29;
            _data100[3].%X6 :=  Outputs.Outputs.Reg2.Bit_30;
            _data100[3].%X7 :=  Outputs.Outputs.Reg2.Bit_31;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_0);
            _data100[4]     := _dword.%B3;
            _data100[5]     := _dword.%B2;
            _data100[6]     := _dword.%B1;
            _data100[7]     := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_1);
            _data100[8]     := _dword.%B3;
            _data100[9]     := _dword.%B2;
            _data100[10]    := _dword.%B1;
            _data100[11]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_2);
            _data100[12]    := _dword.%B3;
            _data100[13]    := _dword.%B2;
            _data100[14]    := _dword.%B1;
            _data100[15]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_3);
            _data100[16]    := _dword.%B3;
            _data100[17]    := _dword.%B2;
            _data100[18]    := _dword.%B1;
            _data100[19]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_4);
            _data100[20]    := _dword.%B3;
            _data100[21]    := _dword.%B2;
            _data100[22]    := _dword.%B1;
            _data100[23]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_5);
            _data100[24]    := _dword.%B3;
            _data100[25]    := _dword.%B2;
            _data100[26]    := _dword.%B1;
            _data100[27]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_6);
            _data100[28]    := _dword.%B3;
            _data100[29]    := _dword.%B2;
            _data100[30]    := _dword.%B1;
            _data100[31]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_7);
            _data100[32]    := _dword.%B3;
            _data100[33]    := _dword.%B2;
            _data100[34]    := _dword.%B1;
            _data100[35]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_8);
            _data100[36]    := _dword.%B3;
            _data100[37]    := _dword.%B2;
            _data100[38]    := _dword.%B1;
            _data100[39]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_9);
            _data100[40]    := _dword.%B3;
            _data100[41]    := _dword.%B2;
            _data100[42]    := _dword.%B1;
            _data100[43]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_10);
            _data100[44]    := _dword.%B3;
            _data100[45]    := _dword.%B2;
            _data100[46]    := _dword.%B1;
            _data100[47]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_11);
            _data100[48]    := _dword.%B3;
            _data100[49]    := _dword.%B2;
            _data100[50]    := _dword.%B1;
            _data100[51]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_0);
            _data100[52]    := _dword.%B3;
            _data100[53]    := _dword.%B2;
            _data100[54]    := _dword.%B1;
            _data100[55]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_1);
            _data100[56]    := _dword.%B3;
            _data100[58]    := _dword.%B2;
            _data100[58]    := _dword.%B1;
            _data100[59]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_2);
            _data100[60]    := _dword.%B3;
            _data100[61]    := _dword.%B2;
            _data100[62]    := _dword.%B1;
            _data100[63]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_3);
            _data100[64]    := _dword.%B3;
            _data100[65]    := _dword.%B2;
            _data100[66]    := _dword.%B1;
            _data100[67]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_4);
            _data100[68]    := _dword.%B3;
            _data100[69]    := _dword.%B2;
            _data100[70]    := _dword.%B1;
            _data100[71]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_5);
            _data100[72]    := _dword.%B3;
            _data100[73]    := _dword.%B2;
            _data100[74]    := _dword.%B1;
            _data100[75]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_6);
            _data100[76]    := _dword.%B3;
            _data100[77]    := _dword.%B2;
            _data100[78]    := _dword.%B1;
            _data100[79]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_7);
            _data100[80]    := _dword.%B3;
            _data100[81]    := _dword.%B2;
            _data100[82]    := _dword.%B1;
            _data100[83]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_8);
            _data100[84]    := _dword.%B3;
            _data100[85]    := _dword.%B2;
            _data100[86]    := _dword.%B1;
            _data100[87]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_9);
            _data100[88]    := _dword.%B3;
            _data100[89]    := _dword.%B2;
            _data100[90]    := _dword.%B1;
            _data100[91]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_10);
            _data100[92]    := _dword.%B3;
            _data100[93]    := _dword.%B2;
            _data100[94]    := _dword.%B1;
            _data100[95]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_11);
            _data100[96]    := _dword.%B3;
            _data100[97]    := _dword.%B2;
            _data100[98]    := _dword.%B1;
            _data100[99]    := _dword.%B0;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2),_data100);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1233, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1233;
                RETURN;
            END_IF; 

        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            Status.CurrentMovementParameters := MovementParameters;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            PowerOnTask.Restore();
            StartAtMainTask.Restore();
            StartMotorsAndProgramTask.Restore();
            StopMovementsTask.Restore();
            StopMovementsAndProgramTask.Restore();
            StartMovementsTask.Restore();
	        RebootControllerTask.Restore();
            RestoreTask.DoneWhen(TRUE);
            Outputs.ActionNo:=255;
            Outputs.GlobalSpeed:=0;
            Outputs.ToolNo:=0;
            Outputs.WorkobjectNo:=0;
            Outputs.PointNo:=0;
            Outputs.UserSpecSpeed1:=0;
            Outputs.UserSpecSpeed2:=0;
            Outputs.Coordinates.X:=0;
            Outputs.Coordinates.Y:=0;
            Outputs.Coordinates.Z:=0;
            Outputs.Coordinates.Rx:=0;
            Outputs.Coordinates.Ry:=0;
            Outputs.Coordinates.Rz:=0;
            Outputs.Start :=FALSE;
            Outputs.Stop:=FALSE;
            Outputs.Pause:=FALSE;
            Outputs.RunAction:=FALSE;
            Outputs.MotorOn:=FALSE;
            _power_progress := 0;
            _movement_progress := 0;
        END_METHOD        
    
        METHOD PUBLIC StartAtMain : IAxoTaskState
            StartAtMain := StartAtMainTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC StartMotorsAndProgram : IAxoTaskState
            StartMotorsAndProgram := StartMotorsAndProgramTask.Invoke(THIS);
        END_METHOD
   
        METHOD PUBLIC StartMovements : IAxoTaskState
            VAR_IN_OUT
                inData : AxoRoboticsMovementsParams;
            END_VAR
            Status.CurrentMovementParameters := inData;

            StartMovements := StartMovementsTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StopMovements : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            _stopType := inStopType;
            StopMovements := StopMovementsTask.Invoke(THIS);           
        END_METHOD

        METHOD PUBLIC StopMovementsAndProgram : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            _stopType := inStopType;
            StopMovementsAndProgram := StopMovementsAndProgramTask.Invoke(THIS);
        END_METHOD
        
        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > LT#0s , Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > LT#0s , Config.ErrorTime );
        END_METHOD

        METHOD PRIVATE GetRobotModeDescription : eAxoUrRoboticsRobotMode
            VAR_INPUT
                inMode:USINT;
            END_VAR
            CASE inMode OF
                USINT#0: GetRobotModeDescription := eAxoUrRoboticsRobotMode#DISCONNECTED;
                USINT#1: GetRobotModeDescription := eAxoUrRoboticsRobotMode#SAFETY;
                USINT#2: GetRobotModeDescription := eAxoUrRoboticsRobotMode#BOOTING;
                USINT#3: GetRobotModeDescription := eAxoUrRoboticsRobotMode#POWER_OFF;
                USINT#4: GetRobotModeDescription := eAxoUrRoboticsRobotMode#POWER_ON;
                USINT#5: GetRobotModeDescription := eAxoUrRoboticsRobotMode#IDLE;
                USINT#6: GetRobotModeDescription := eAxoUrRoboticsRobotMode#BACKDRIVE;
                USINT#7: GetRobotModeDescription := eAxoUrRoboticsRobotMode#RUNNING;
                USINT#8: GetRobotModeDescription := eAxoUrRoboticsRobotMode#UPDATING_FIRMWARE;
            END_CASE;
        END_METHOD
    END_CLASS
END_NAMESPACE
