USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Components.Drives;
USING System.Math;
USING Siemens.Simatic.S71500.Hardware.Utilities;
USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCtrlxDriveXsc EXTENDS AXOpen.Components.Drives.AxoDrive IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoDrive
        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            DriveStatus         :   AxoCtrlxDriveXsc_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR
        VAR PUBLIC // HwDiag
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR
        VAR PUBLIC // AxisRef
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("AxisRef")]}
            {#ix-attr:[ReadOnly()]}
            AxisRefExt :  AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
        END_VAR
        VAR PUBLIC // Scaling
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required position#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantRequiredPosition         :   LREAL   :=  10000.0;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual position#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantActualPosition         :   LREAL   :=  0.0001;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required velocity#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantRequiredVelocity         :   LREAL   :=  LREAL#0.01666666666666666666666666666667;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual velocity#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantActualVelocity         :   LREAL   :=  60.0;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required torque#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantRequiredTorque         :   LREAL   :=  10.0;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual torque#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantActualTorque         :   LREAL   :=  0.1;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required acceleration#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantRequiredAcceleration        :   LREAL   :=  1000.0;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual acceleration#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantActualAcceleration        :   LREAL   :=  0.001;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant required deceleration#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantRequiredDeceleration        :   LREAL   :=  1000.0;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual deceleration#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantActualDeceleration        :   LREAL   :=  0.001;
            {#ix-set:AttributeName = "<#Scaling constant required jerk#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantRequiredJerk        :   LREAL   :=  1000.0;
            {#ix-attr:[ComponentDetails("Scaling")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Scaling constant actual jerk#>"}
            {#ix-set:AttributeToolTip = "<#Depends on the actual settings in the ctrlX DRIVE Engineering#>"}
            ScalingConstantActualJerk       :   LREAL   :=  0.001;
        END_VAR
        VAR PUBLIC // Debug
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#_State#>"}
            _State                  :   UINT;
        END_VAR

        VAR PRIVATE
            _data2      :   ARRAY[0..1] OF BYTE; 
            _data4      :   ARRAY[0..3] OF BYTE; 
            _data8      :   ARRAY[0..7] OF BYTE; 
            _word       :   WORD;                  
            _dword      :   DWORD;
            _lword      :   LWORD;

            _Parameter  : ARRAY[0..9] OF BYTE; 
            _Fieldbus   : ARRAY[0..25] OF BYTE; 
               
            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _blink                  :   AXOpen.Timers.AxoBlinker;   
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT; 
            _ReadRecord             :   ReadRecord;
            _WriteRecord            :   WriteRecord;
            _ScalingRead            :   BOOL;
            _S_0_0076               :   WORD;       // 2byte, binary
            _S_0_0077               :   INT;        // 2byte, 0 decimal places
            _S_0_0078               :   INT;        // 2byte, 0 decimal places
            _S_0_0044               :   WORD;       // 2byte, binary
            _S_0_0045               :   INT;        // 2byte, 0 decimal places
            _S_0_0046               :   INT;        // 2byte, 0 decimal places
            _S_0_0160               :   WORD;       // 2byte, binary
            _S_0_0161               :   INT;        // 2byte, 0 decimal places
            _S_0_0162               :   INT;        // 2byte, 0 decimal places
            _S_0_0086               :   WORD;       // 2byte, binary
            _S_0_0093               :   INT;        // 2byte, 0 decimal places
            _S_0_0094               :   INT;        // 2byte, 0 decimal places
            _S_0_0112               :   REAL;       // 4bytes, 3decimal places
            _P_0_0450               :   REAL;       // 2bytes, 2decimal places

            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _lastMessageCodeFromMC  :   ULINT;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent              :   IAxoObject; 
                hwID                :   UINT;
                Enable              :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
                EnablePositive      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
                EnableNegative      :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            END_VAR
            VAR 
                //                                      |     -10   |     -9    |    -8    |    -7   |   -6   |   -5  |  -4  | -3  | -2 |-1|  0 | 1  |  2  |  3   |   4   |   5    |   6     |    7     |     8     |    9      |     10    |
                _exp    :   ARRAY [-10..10] OF LREAL := [0.000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,1.0,10.0,100.0,1000.0,10000.0,100000.0,1000000.0,10000000.0,100000000.0,100000000.0,100000000.0];
            END_VAR
            SUPER.Run(parent);
            Messenger.Serve(THIS);

            IF NOT _initHwCheckDone THEN
                IF parent = NULL THEN
                    Messenger.Activate(     UINT#700, eAxoMessageCategory#ProgrammingError);
                    DriveStatus.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                AxisRefExt.HWIDs.HW_Device :=  hwID;
                IF AxisRefExt.HWIDs.HW_Device = UINT#0 THEN
                    Messenger.Activate(     UINT#701, eAxoMessageCategory#ProgrammingError);
                    DriveStatus.Error.Id := UINT#701;
                    RETURN;
                END_IF;

                _retval := ReadSlotFromHardwareID(hardwareID := AxisRefExt.HWIDs.HW_Device, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(     UINT#702,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_Outputs);        
                IF AxisRefExt.HWIDs.HW_Outputs = UINT#0 THEN
                    Messenger.Activate(     UINT#710,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#710;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#711,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#711;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#712,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#712;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#713,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#713;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#714,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#714;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#715,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#715;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_Outputs), inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#716,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID =>  AxisRefExt.HWIDs.HW_Inputs);        
                IF AxisRefExt.HWIDs.HW_Inputs = UINT#0 THEN
                    Messenger.Activate(     UINT#720,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#720;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#721,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#721;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#722,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#722;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#723,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#723;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#724,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#724;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#725,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#725;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_Inputs), inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#726,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#726;
                    RETURN;
                END_IF;  
                //************Slot 1 Subslot 1*****************//
                _geoAddr.Subslot:=      UINT#1;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0134_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0134_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#730,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#730;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#731,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#731;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#732,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#732;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#733,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#733;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#734,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#734;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#735,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#735;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#2 THEN
                    Messenger.Activate(     UINT#736,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //************Slot 1 Subslot 2*****************//
                _geoAddr.Subslot:=      UINT#2;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0145_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0145_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#740,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#740;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#741,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#741;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#742,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#742;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#743,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#743;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#744,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#744;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#745,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#745;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0145_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#2 THEN
                    Messenger.Activate(     UINT#746,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //************Slot 1 Subslot 3*****************//
                _geoAddr.Subslot:=      UINT#3;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0282_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0282_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#750,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#750;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#751,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#751;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#752,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#752;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#753,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#753;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#754,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#754;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#755,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#755;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0282_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#4 THEN
                    Messenger.Activate(     UINT#756,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //************Slot 1 Subslot 4*****************//
                _geoAddr.Subslot:=      UINT#4;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0259_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0259_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#760,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#760;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#761,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#761;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#762,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#762;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#763,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#763;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#764,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#764;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#765,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#765;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0259_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#4 THEN
                    Messenger.Activate(     UINT#766,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#766;
                    RETURN;
                END_IF;                
                //************Slot 1 Subslot 5*****************//
                _geoAddr.Subslot:=      UINT#5;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0260_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0260_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#770,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#770;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#771,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#771;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#772,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#772;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#773,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#773;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#774,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#774;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#775,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#775;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0260_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#4 THEN
                    Messenger.Activate(     UINT#776,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#776;
                    RETURN;
                END_IF;                
                //************Slot 1 Subslot 6*****************//
                _geoAddr.Subslot:=      UINT#6;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0359_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0359_0_0 = UINT#0 THEN
                    Messenger.Activate(     UINT#780,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#780;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#781,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#781;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#782,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#782;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#783,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#783;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#784,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#784;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#785,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#785;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0359_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#4 THEN
                    Messenger.Activate(     UINT#786,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#786;
                    RETURN;
                END_IF;                
                //************Slot 1 Subslot 7*****************//
                _geoAddr.Subslot:=      UINT#7;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_1720_0_1);        
                IF AxisRefExt.HWIDs.HW_S_0_1720_0_1 = UINT#0 THEN
                    Messenger.Activate(     UINT#790,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#790;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#791,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#791;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#792,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#792;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#793,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#793;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#794,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#794;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#795,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#795;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_1720_0_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#2 THEN
                    Messenger.Activate(     UINT#796,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#796;
                    RETURN;
                END_IF;                
                //************Slot 1 Subslot 8*****************//
                _geoAddr.Subslot:=      UINT#8;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0092_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0092_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#800,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#800;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#801,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#801;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#802,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#802;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#803,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#803;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#804,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#804;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#805,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#805;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0092_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#2 THEN
                    Messenger.Activate(     UINT#806,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#806;
                    RETURN;
                END_IF;                
                //************Slot 1 Subslot 9*****************//
                _geoAddr.Subslot:=      UINT#9;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0080_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0080_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#810,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#810;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#811,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#811;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#812,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#812;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#813,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#813;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#814,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#814;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#815,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#815;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0080_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#2 THEN
                    Messenger.Activate(     UINT#816,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#816;
                    RETURN;
                END_IF;     
                //************Slot 1 Subslot 10*****************//
                _geoAddr.Subslot:=      UINT#10;                                                            
                _geoAddr.Slot   :=      UINT#1;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID =>  AxisRefExt.HWIDs.HW_S_0_0193_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0193_0_0 = UINT#0 THEN
                    Messenger.Activate(     UINT#820,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#820;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#821,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#821;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#822,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#822;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#823,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#823;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#824,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#824;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#825,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#825;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0193_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#4 THEN
                    Messenger.Activate(     UINT#826,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#826;
                    RETURN;
                END_IF;     
                //************Slot 2 Subslot 1*****************//
                _geoAddr.Subslot:=      UINT#1;                                                            
                _geoAddr.Slot   :=      UINT#2;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0135_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0135_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#830,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#830;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#831,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#831;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#832,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#832;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#833,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#833;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#834,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#834;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#835,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#835;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0135_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#2 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#836,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#836;
                    RETURN;
                END_IF;     
                //************Slot 2 Subslot 2*****************//
                _geoAddr.Subslot:=      UINT#2;                                                            
                _geoAddr.Slot   :=      UINT#2;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0144_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0144_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#840,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#840;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#841,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#841;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#842,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#842;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#843,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#843;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#844,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#844;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#845,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#845;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0144_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#2 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#846,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#846;
                    RETURN;
                END_IF;     
                //************Slot 2 Subslot 3*****************//
                _geoAddr.Subslot:=      UINT#3;                                                            
                _geoAddr.Slot   :=      UINT#2;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0386_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0386_0_0 = UINT#0 THEN
                    Messenger.Activate(     UINT#850,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#850;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#851,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#851;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#852,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#852;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#853,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#853;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#854,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#854;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#855,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#855;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0386_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#856,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#856;
                    RETURN;
                END_IF;     
                //************Slot 2 Subslot 4*****************//
                _geoAddr.Subslot:=      UINT#4;                                                            
                _geoAddr.Slot   :=      UINT#2;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0535_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0535_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#860,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#860;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#861,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#861;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#862,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#862;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#863,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#863;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#864,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#864;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#865,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#865;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0535_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#866,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#866;
                    RETURN;
                END_IF;     
                //************Slot 2 Subslot 5*****************//
                _geoAddr.Subslot:=      UINT#5;                                                            
                _geoAddr.Slot   :=      UINT#2;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0390_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0390_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#870,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#870;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#871,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#871;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#872,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#872;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#873,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#873;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#874,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#874;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#875,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#875;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0390_0_0), inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#876,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#876;
                    RETURN;
                END_IF;     
                //************Slot 2 Subslot 6*****************//
                _geoAddr.Subslot:=      UINT#6;                                                            
                _geoAddr.Slot   :=      UINT#2;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_1720_0_2);        
                IF AxisRefExt.HWIDs.HW_S_0_1720_0_2  = UINT#0 THEN
                    Messenger.Activate(     UINT#880,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#880;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#881,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#881;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#882,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#882;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#883,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#883;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#884,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#884;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#885,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#885;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_1720_0_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#2 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#886,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#886;
                    RETURN;
                END_IF;                     
                //************Slot 2 Subslot 7*****************//
                _geoAddr.Subslot:=      UINT#7;                                                            
                _geoAddr.Slot   :=      UINT#2;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_S_0_0084_0_0);        
                IF AxisRefExt.HWIDs.HW_S_0_0084_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#890,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#890;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#891,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#891;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#892,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#892;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#893,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#893;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#894,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#894;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#895,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#895;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_S_0_0084_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#2 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#896,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#896;
                    RETURN;
                END_IF;                     
                //************Slot 2 Subslot 8*****************//
                _geoAddr.Subslot:=      UINT#8;                                                            
                _geoAddr.Slot   :=      UINT#2;                                                            
                _geoAddr.HardwareType := UINT#5; // (5-Submodule)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => AxisRefExt.HWIDs.HW_P_0_0106_0_0);        
                IF AxisRefExt.HWIDs.HW_P_0_0106_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#900,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#900;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(     UINT#901,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#901;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(     UINT#902,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#902;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(     UINT#903,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#903;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(     UINT#904,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#904;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(     UINT#905,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#905;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier := TO_WORD(AxisRefExt.HWIDs.HW_P_0_0106_0_0) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#2 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(     UINT#906,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#906;
                    RETURN;
                END_IF;                     
                //****************************** */
                IF parent = NULL THEN
                    Messenger.Activate(     UINT#1130,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_Device  = UINT#0 THEN
                    Messenger.Activate(     UINT#1131,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_Outputs = UINT#0 THEN
                    Messenger.Activate(     UINT#1132,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_Inputs = UINT#0 THEN
                    Messenger.Activate(     UINT#1133,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0134_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1134,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1134;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0145_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1135,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1135;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0282_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1136,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1136;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0259_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1137,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1137;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0260_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1138,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1138;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0359_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1139,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1139;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_1720_0_1  = UINT#0 THEN
                    Messenger.Activate(     UINT#1140,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1140;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0092_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1141,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1141;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0080_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1142,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1142;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0193_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1143,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1143;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0135_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1144,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1144;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0144_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1145,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1145;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0386_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1146,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1146;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0535_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1147,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1147;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0390_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1148,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1148;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_1720_0_2  = UINT#0 THEN
                    Messenger.Activate(     UINT#1149,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1149;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_S_0_0084_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1150,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1150;
                    RETURN;
                END_IF;
                IF AxisRefExt.HWIDs.HW_P_0_0106_0_0  = UINT#0 THEN
                    Messenger.Activate(     UINT#1151,eAxoMessageCategory#Error);
                    DriveStatus.Error.Id := UINT#1151;
                    RETURN;
                END_IF;
                _initHwCheckDone    := TRUE;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#1800, NOT _ScalingRead, eAxoMessageCategory#Warning);            
            //********************Diagnostics******************//          
            HardwareDiagnosticsTask.Run(THIS,AxisRefExt.HWIDs.HW_Device);
            //*******************SCALING***********************//          
            IF NOT _ScalingRead THEN
                IF _State = UINT#0 THEN
                    _State := UINT#1;
                END_IF;
                //Reading Position data scaling: Type (0x2900:01 / S-0-0076 / --) 2byte, binary
                IF _State = UINT#1 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#76,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0076   :=  _word;
                        _State := UINT#2;
                    END_IF;
                END_IF;
                IF _State = UINT#2 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#3;
                    END_IF;
                END_IF;
                //Reading Position data scaling: Factor (0x2900:02 / S-0-0077 / --) 2byte, 0 decimal places
                IF _State = UINT#3 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#77,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0077   :=  TO_INT(_word);
                        _State := UINT#4;
                    END_IF;
                END_IF;
                IF _State = UINT#4 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#5;
                    END_IF;
                END_IF;
                //Reading Position data scaling: Exponent (0x2900:03 / S-0-0078 / --) 2byte, 0 decimal places
                IF _State = UINT#5 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#78,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0078   :=  TO_INT(_word);
                        _State := UINT#6;
                    END_IF;
                END_IF;
                IF _State = UINT#6 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#7;
                    END_IF;
                END_IF;
                //Reading Velocity data scaling: Type (0x2902:01 / S-0-0044 / --) 2byte, binary
                IF _State = UINT#7 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#44,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0044   :=  _word;
                        _State := UINT#8;
                    END_IF;
                END_IF;
                IF _State = UINT#8 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#9;
                    END_IF;
                END_IF;
                //Reading Velocity data scaling: Factor (0x2902:02 / S-0-0045 / --) 2byte, 0 decimal places
                IF _State = UINT#9 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#45,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0045   :=  TO_INT(_word);
                        _State := UINT#10;
                    END_IF;
                END_IF;
                IF _State = UINT#10 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#11;
                    END_IF;
                END_IF;
                //Reading Velocity data scaling: Exponent (0x2902:03 / S-0-0046 / --) 2byte, 0 decimal places
                IF _State = UINT#11 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#46,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0046   :=  TO_INT(_word);
                        _State := UINT#12;
                    END_IF;
                END_IF;
                IF _State = UINT#12 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#13;
                    END_IF;
                END_IF;
                //Reading Acceleration data scaling: Type (0x2904:01 / S-0-0160 / --) 2byte, binary
                IF _State = UINT#13 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#160,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0160   :=  _word;
                        _State := UINT#14;
                    END_IF;
                END_IF;
                IF _State = UINT#14 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#15;
                    END_IF;
                END_IF;
                //Reading Acceleration data scaling: Factor (0x2904:02 / S-0-0161 / --) 2byte, 0 decimal places
                IF _State = UINT#15 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#161,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0161   :=  TO_INT(_word);
                        _State := UINT#16;
                    END_IF;
                END_IF;
                IF _State = UINT#16 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#17;
                    END_IF;
                END_IF;
                //Reading Acceleration data scaling: Exponent (0x2904:03 / S-0-0162 / --) 2byte, 0 decimal places
                IF _State = UINT#17 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#162,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0162   :=  TO_INT(_word);
                        _State := UINT#18;
                    END_IF;
                END_IF;
                IF _State = UINT#18 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#19;
                    END_IF;
                END_IF;
                //Reading Torque/force data scaling: Type (0x2906:01 / S-0-0086 / --) 2byte, binary
                IF _State = UINT#19 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#86,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0086   :=  _word;
                        _State := UINT#20;
                    END_IF;
                END_IF;
                IF _State = UINT#20 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#21;
                    END_IF;
                END_IF;
                //Reading Torque/force data scaling: Factor (0x2906:02 / S-0-0093 / --) 2byte, 0 decimal places
                IF _State = UINT#21 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#93,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0093   :=  TO_INT(_word);
                        _State := UINT#22;
                    END_IF;
                END_IF;
                IF _State = UINT#22 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#23;
                    END_IF;
                END_IF;
                //Reading Torque/force data scaling: Exponent (0x2906:03 / S-0-0094 / --) 2byte, 0 decimal places
                IF _State = UINT#23 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#94,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _S_0_0094   :=  TO_INT(_word);
                        _State := UINT#24;
                    END_IF;
                END_IF;
                IF _State = UINT#24 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#25;
                    END_IF;
                END_IF;
                //Reading Inverter type data: Nominal current (0x2314:01 / S-0-0112 / --) 4bytes, 3decimal places
                IF _State = UINT#25 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#112,
                                    maxLength   :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _dword.%B0   :=  _data4[0];
                        _dword.%B1   :=  _data4[1];
                        _dword.%B2   :=  _data4[2];
                        _dword.%B3   :=  _data4[3];
                        _S_0_0112   :=  TO_REAL(TO_INT(_dword)) * REAL#0.001;
                        _State := UINT#26;
                    END_IF;
                END_IF;
                IF _State = UINT#26 THEN
                    _ReadRecord(request := FALSE, record := _data4);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#27;
                    END_IF;
                END_IF;
                //Reading Motor torque model: Current constant (0x2018:01 / P-0-0450 / --) 2bytes, 2decimal places
                IF _State = UINT#27 THEN
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#4546,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _word.%B0   :=  _data2[0];
                        _word.%B1   :=  _data2[1];
                        _P_0_0450   :=  TO_REAL(TO_INT(_word)) * REAL#0.01;
                        _State := UINT#28;
                    END_IF;
                END_IF;
                IF _State = UINT#28 THEN
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#29;
                    END_IF;
                END_IF;                                
                //Calculating scaling constants
                IF _State = UINT#29 THEN
                    //  Position
                    ScalingConstantRequiredPosition := _exp[-_S_0_0078 - 3] / TO_LREAL(_S_0_0077);
                    ScalingConstantActualPosition       := LREAL#1.0/ScalingConstantRequiredPosition;
                    //  Velocity
                    ScalingConstantRequiredVelocity := LREAL#60.0 * _exp[-_S_0_0046 - 3] / TO_LREAL(_S_0_0045);
                    ScalingConstantActualVelocity       := LREAL#1.0/ScalingConstantRequiredVelocity;
                    //  Acceleration
                    ScalingConstantRequiredAcceleration :=  _exp[-_S_0_0162 - 3] / TO_LREAL(_S_0_0161);
                    ScalingConstantActualAcceleration       := LREAL#1.0/ScalingConstantRequiredAcceleration;
                    //  Deceleration
                    ScalingConstantRequiredDeceleration := ScalingConstantRequiredAcceleration;
                    ScalingConstantActualDeceleration   := ScalingConstantActualAcceleration;
                    //  Torque
                    ScalingConstantActualTorque         := TO_LREAL(_S_0_0093) *_exp[_S_0_0094 - 2] * TO_LREAL(_P_0_0450) * TO_LREAL(_S_0_0112) ;
                    ScalingConstantRequiredTorque       := LREAL#1.0/ScalingConstantActualTorque;
                    //  Jerk
                    ScalingConstantRequiredJerk         :=  1000.0;
                    ScalingConstantActualJerk           :=  0.001;

                    AxoStop_Deceleration := 1000.0;         // mm/s2
                    AxoStop_Jerk := 150000.0;               // mm/s3
                    AxoHalt_Deceleration := 1000.0;         // mm/s2
                    AxoHalt_Jerk := 150000.0;               // mm/s3
                    AxoHome_Position := 0.0;                // mm
                    AxoHome_HommingMode := 551;             // Negative direction, travel range limit switch, negative edge (NC contact)
                    AxoHome_Velocity := 2.0;                // mm/s
                    AxoHome_Acceleration := 1000.0;         // mm/s2
                    AxoHome_Deceleration := 1000.0;         // mm/s2
                    AxoSetPosition_Position := 0.0;         // mm
                    AxoMoveAbsolute_Position := 0.0;        // mm
                    AxoMoveAbsolute_Velocity := 5.0;        // mm/s
                    AxoMoveAbsolute_Acceleration := 1000.0; // mm/s2
                    AxoMoveAbsolute_Deceleration := 1000.0; // mm/s2
                    AxoMoveAbsolute_Jerk := 150000.0;       // mm/s3
                    AxoMoveRelative_Distance := 5.0;        // mm
                    AxoMoveRelative_Velocity := 5.0;        // mm/s
                    AxoMoveRelative_Acceleration := 1000.0; // mm/s2
                    AxoMoveRelative_Deceleration := 1000.0; // mm/s2
                    AxoMoveRelative_Jerk := 150000.0;       // mm/s3
                    AxoMoveAdditive_Distance := 5.0;        // mm
                    AxoMoveAdditive_Velocity := 5.0;        // mm/s
                    AxoMoveAdditive_Acceleration := 1000.0; // mm/s2
                    AxoMoveAdditive_Deceleration := 1000.0; // mm/s2
                    AxoMoveAdditive_Jerk := 150000.0;       // mm/s3
                    AxoMoveVelocity_Velocity := 5.0;        // mm/s
                    AxoMoveVelocity_Acceleration := 1000.0; // mm/s2
                    AxoMoveVelocity_Deceleration := 1000.0; // mm/s2
                    AxoMoveVelocity_Jerk := 150000.0;       // mm/s3
                    AxoTorqueControl_Torque := 0.0;         // Nm
                    AxoTorqueControl_TorqueRamp := 1.0;     // Nm/s
                    AxoTorqueControl_Velocity := 5.0;       // mm/s
                    AxoTorqueControl_Acceleration := 1000.0;// mm/s2
                    AxoTorqueControl_Deceleration := 1000.0;// mm/s2
                    AxoTorqueControl_Jerk := 150000.0;      // mm/s3
                    AxoJog_Velocity := 2.0;                 // mm/s
                    AxoJog_Acceleration := 500.0;           // mm/s2
                    AxoJog_Deceleration := 500.0;           // mm/s2
                    AxoJog_Jerk := 150000.0;                // mm/s3
                    AxisRefExt.Outputs.BipolarTorqueLimitation_S_0_0092_0_0 := INT#1000;  // 1000~~ 100%

                    _ScalingRead := TRUE;
                    _State := UINT#0;
                END_IF;                                
                RETURN;
            END_IF;
            //*************************************************//

            Messenger.ActivateOnCondition(ULINT#300, Enable AND NOT EnablePositive, eAxoMessageCategory#Warning);
            Messenger.ActivateOnCondition(ULINT#301, Enable AND NOT EnableNegative, eAxoMessageCategory#Warning);

            //************************************************************
            SUPER.Run(THIS,AxisRefExt,Enable,EnablePositive,EnableNegative);
            //************************************************************

            THIS.ActualPosition := AxisRefExt.Inputs.ActualPosition_S_0_0386_0_0 * ScalingConstantActualPosition;
            THIS.ActualVelocity := AxisRefExt.Inputs.ActualVelocity_S_0_0535_0_0 * ScalingConstantActualVelocity;
            THIS.ActualTorque   := AxisRefExt.Inputs.ActualTorque_S_0_0084_0_0  * ScalingConstantActualTorque;

            IF NOT AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Disabled;
            ELSIF _State>=UINT#310 AND _State<=UINT#327 AND 
                    (NOT AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.InReference OR NOT AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill ) THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Homing;
            ELSIF   _State>=UINT#350 AND _State<=UINT#357 OR                                            //******MC_MoveAbsolute***************                                                 
                    _State>=UINT#360 AND _State<=UINT#367 OR                                            //******MC_MoveRelative***************                                                  
                    _State>=UINT#370 AND _State<=UINT#377 THEN                                          //******MC_MoveAditive****************                                                  
                DriveState := AXOpen.Components.Drives.eAxoDriveState#DiscreteMotion;
            ELSIF (_State>=UINT#380 AND _State<UINT#387) OR                                             //(************************************ 
                    AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative OR                    //******MC_MoveVelocity OR MC_Jog****** 
                    AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive OR                    //************************************)
                    _State>=UINT#390 AND _State<UINT#397 OR                                             //(************************************
                    (   AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0 AND      //*************************************
                    NOT AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1 AND      //******MC_TorqueControl***************
                    NOT AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2 AND      //*************************************  
                        AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt) THEN                //************************************)
                DriveState := AXOpen.Components.Drives.eAxoDriveState#ContinuousMotion;
            ELSIF FALSE THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#SynchronizedMotion;               //*****Not implemented*****************
            ELSIF   AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND
                    AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 AND
                    NOT AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt AND
                    NOT AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Stopping;
            ELSIF AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Errorstop;
            ELSIF AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill THEN
                DriveState := AXOpen.Components.Drives.eAxoDriveState#Standstill;
            END_IF;

            Messenger.ActivateOnCondition(THIS.MessageCodeFromMC, THIS.ErrorFromMC AND MessageCodeFromMC = _lastMessageCodeFromMC ,eAxoMessageCategory#Error);
            IF Messenger.MessengerState = eAxoMessengerState#Idle THEN
                IF THIS.ErrorFromMC THEN
                    _lastMessageCodeFromMC := THIS.MessageCodeFromMC;
                ELSE
                    THIS.MessageCodeFromMC := ULINT#0;
                END_IF;                          
            END_IF;                          
        END_METHOD   

        ///<summary>
        /// Ensures swapping the hardware input data structure into the AxisRef data structure  
        ///</summary>
        METHOD PROTECTED  OVERRIDE UpdateInputs : BOOL
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            VAR
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR

           _AxisReference ?= AxisRef;

           IF(_AxisReference = NULL) THEN
               Messenger.Activate(     UINT#1410, eAxoMessageCategory#ProgrammingError);
               DriveStatus.Error.Id := UINT#1410;
               RETURN;
           END_IF;

           _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0135_0_0) ,_data2);
           IF _retVal > WORD#0 THEN
               Messenger.Activate(     UINT#1201, eAxoMessageCategory#ProgrammingError);
               DriveStatus.Error.Id := UINT#1201;
               RETURN;
           END_IF;
           
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0._bit00_Reserve 			:=  _data2[1].%X0;     //  0
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0._bit01_Reserve 			:=  _data2[1].%X1;     //  1
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0._bit02_Reserve 			:=  _data2[1].%X2;     //  2
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.CommandProcessingStatus	:=  _data2[1].%X3;     //  3
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill 			    :=  _data2[1].%X4;     //  4
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.InReference 			    :=  _data2[1].%X5;     //  5
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0._bit06_Reserve 			:=  _data2[1].%X6;     //  6
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.HardwareLock              :=  _data2[1].%X7;     //  7
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0   :=  _data2[0].%X0;     //  8
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1   :=  _data2[0].%X1;     //  9
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2   :=  _data2[0].%X2;     //  10
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0._bit11_Reserve 			:=  _data2[0].%X3;     //  11
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.WarningZKL2 			    :=  _data2[0].%X4;     //  12
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 			:=  _data2[0].%X5;     //  13
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0     :=  _data2[0].%X6;     //  14
           AxisRefExt.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1     :=  _data2[0].%X7;     //  15

           _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0144_0_0) ,_data2);
           IF _retVal > WORD#0 THEN
               Messenger.Activate(     UINT#1202, eAxoMessageCategory#ProgrammingError);
               DriveStatus.Error.Id := UINT#1202;
               RETURN;
           END_IF;

           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0.CmPmOmBit0 			    :=  _data2[1].%X0;     //  0
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0.CmPmOmBit1 			    :=  _data2[1].%X1;     //  1
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition 	    :=  _data2[1].%X2;     //  2
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck	    :=  _data2[1].%X3;     //  3
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill 	        :=  _data2[1].%X4;     //  4
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0.CommandChangeBit 	    :=  _data2[1].%X5;     //  5
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit6_Reserve 			:=  _data2[1].%X6;     //  6
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit7_Reserve            :=  _data2[1].%X7;     //  7
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0.LockedByHardware         :=  _data2[0].%X0;     //  8
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit9_Reserve            :=  _data2[0].%X1;     //  9
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit10_Reserve           :=  _data2[0].%X2;     //  10
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit11_Reserve 			:=  _data2[0].%X3;     //  11
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit12_Reserve 			:=  _data2[0].%X4;     //  12
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit13_Reserve 			:=  _data2[0].%X5;     //  13
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit14_Reserve           :=  _data2[0].%X6;     //  14
           AxisRefExt.Inputs.SignalStatusWord_S_0_0144_0_0._bit15_Reserve           :=  _data2[0].%X7;     //  15

           _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0386_0_0) ,_data4);
           IF _retVal > WORD#0 THEN
               Messenger.Activate(     UINT#1203, eAxoMessageCategory#ProgrammingError);
               DriveStatus.Error.Id := UINT#1203;
               RETURN;
           END_IF;
           _dword.%B3  :=  _data4[0];
           _dword.%B2  :=  _data4[1];
           _dword.%B1  :=  _data4[2];
           _dword.%B0  :=  _data4[3];
           AxisRefExt.Inputs.ActualPosition_S_0_0386_0_0 := TO_DINT(_dword);

           _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0535_0_0) ,_data4);
           IF _retVal > WORD#0 THEN
               Messenger.Activate(     UINT#1204, eAxoMessageCategory#ProgrammingError);
               DriveStatus.Error.Id := UINT#1204;
               RETURN;
           END_IF;
           _dword.%B3  :=  _data4[0];
           _dword.%B2  :=  _data4[1];
           _dword.%B1  :=  _data4[2];
           _dword.%B0  :=  _data4[3];
           AxisRefExt.Inputs.ActualVelocity_S_0_0535_0_0 := TO_DINT(_dword);

           _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0390_0_0) ,_data4);
           IF _retVal > WORD#0 THEN
               Messenger.Activate(     UINT#1205, eAxoMessageCategory#ProgrammingError);
               DriveStatus.Error.Id := UINT#1205;
               RETURN;
           END_IF;
           _dword.%B3  :=  _data4[0];
           _dword.%B2  :=  _data4[1];
           _dword.%B1  :=  _data4[2];
           _dword.%B0  :=  _data4[3];
           AxisRefExt.Inputs.DiagnosticMessage_S_0_0390_0_0 := _dword;

           _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_1720_0_2) ,_data2);
           IF _retVal > WORD#0 THEN
               Messenger.Activate(     UINT#1206, eAxoMessageCategory#ProgrammingError);
               DriveStatus.Error.Id := UINT#1206;
               RETURN;
           END_IF;
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2._bit0_Reserve 				        := _data2[1].%X0;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2._bit1_Reserve 				        := _data2[1].%X1;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2._bit2_Reserve 				        := _data2[1].%X2;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2._bit3_Reserve 				        := _data2[1].%X3;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.MainsStatus				            := _data2[1].%X4;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.HardwareEnable				        := _data2[1].%X5;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.ControllingTheMainsConnection        := _data2[1].%X6;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.BbContact				            := _data2[1].%X7;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.PreselectedOPmodesFB_bit0            := _data2[0].%X0;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.PreselectedOPmodesFB_bit01           := _data2[0].%X1;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.DCbusDischarge                       := _data2[0].%X2;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.BrakingResistor                      := _data2[0].%X3;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.Warning                              := _data2[0].%X4;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.Error                                := _data2[0].%X5;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.ReadyForEnabling                     := _data2[0].%X6;	
           AxisRefExt.Inputs.SupplyUnitStatusWord_S_0_1720_0_2.Enabling                             := _data2[0].%X7;	

           _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0084_0_0) ,_data2);
           IF _retVal > WORD#0 THEN
               Messenger.Activate(     UINT#1207, eAxoMessageCategory#ProgrammingError);
               DriveStatus.Error.Id := UINT#1207;
               RETURN;
           END_IF;
           _word.%B1  :=  _data2[0];
           _word.%B0  :=  _data2[1];
           AxisRefExt.Inputs.ActualTorque_S_0_0084_0_0 := TO_INT(_word);
        END_METHOD   

        ///<summary>
        /// Ensures swapping the AxisRef data structure into the hardware output data structure
        ///</summary>
        METHOD PROTECTED OVERRIDE UpdateOutputs : BOOL
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
            END_VAR
            VAR
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1420, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1420;
                RETURN;
            END_IF;
            //***********Update outputs **************
            _data2[1].%X0   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit00_Reserve;
            _data2[1].%X1   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit01_Reserve;
            _data2[1].%X2   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit02_Reserve;
            _data2[1].%X3   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit03_Reserve;
            _data2[1].%X4   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit04_Reserve;
            _data2[1].%X5   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit05_Reserve;
            _data2[1].%X6   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit06_Reserve;
            _data2[1].%X7   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit07_Reserve;
            _data2[0].%X0   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit0;
            _data2[0].%X1   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit1;
            _data2[0].%X2   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit2;
            _data2[0].%X3   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit11_Reserve;
            _data2[0].%X4   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0._bit12_Reserve;
            _data2[0].%X5   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt;
            _data2[0].%X6   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable;
            _data2[0].%X7   :=  AxisRefExt.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),_data2);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1231, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1231;
                RETURN;
            END_IF;    

            _data2[1].%X0   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue;
            _data2[1].%X2   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl;
            _data2[1].%X3   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative;
            _data2[1].%X4   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange;
            _data2[1].%X5   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.ClearError;
            _data2[1].%X6   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive;
            _data2[1].%X7   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative;
            _data2[0].%X0   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.SwitchToCM;
            _data2[0].%X1   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.SwitchTo0M;
            _data2[0].%X2   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint;
            _data2[0].%X3   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0._bit11_Reserve;
            _data2[0].%X4   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0._bit12_Reserve;
            _data2[0].%X5   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0._bit13_Reserve;
            _data2[0].%X6   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0._bit14_Reserve;
            _data2[0].%X7   :=  AxisRefExt.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0145_0_0),_data2);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1232, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1232;
                RETURN;
            END_IF;    

            _data4[3]   :=  AxisRefExt.Outputs.CommandPosition_S_0_0282_0_0.%B0;
            _data4[2]   :=  AxisRefExt.Outputs.CommandPosition_S_0_0282_0_0.%B1;
            _data4[1]   :=  AxisRefExt.Outputs.CommandPosition_S_0_0282_0_0.%B2;
            _data4[0]   :=  AxisRefExt.Outputs.CommandPosition_S_0_0282_0_0.%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0282_0_0),_data4);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1233, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1233;
                RETURN;
            END_IF;    

            _data4[3]   :=  AxisRefExt.Outputs.CommandVelocity_S_0_0259_0_0.%B0;
            _data4[2]   :=  AxisRefExt.Outputs.CommandVelocity_S_0_0259_0_0.%B1;
            _data4[1]   :=  AxisRefExt.Outputs.CommandVelocity_S_0_0259_0_0.%B2;
            _data4[0]   :=  AxisRefExt.Outputs.CommandVelocity_S_0_0259_0_0.%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0259_0_0),_data4);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1234, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1234;
                RETURN;
            END_IF;    

            _data4[3]   :=  AxisRefExt.Outputs.CommandAcceleration_S_0_0260_0_0.%B0;
            _data4[2]   :=  AxisRefExt.Outputs.CommandAcceleration_S_0_0260_0_0.%B1;
            _data4[1]   :=  AxisRefExt.Outputs.CommandAcceleration_S_0_0260_0_0.%B2;
            _data4[0]   :=  AxisRefExt.Outputs.CommandAcceleration_S_0_0260_0_0.%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0260_0_0),_data4);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1235, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1235;
                RETURN;
            END_IF;    

            _data4[3]   :=  AxisRefExt.Outputs.CommandDecceleration_S_0_0359_0_0.%B0;
            _data4[2]   :=  AxisRefExt.Outputs.CommandDecceleration_S_0_0359_0_0.%B1;
            _data4[1]   :=  AxisRefExt.Outputs.CommandDecceleration_S_0_0359_0_0.%B2;
            _data4[0]   :=  AxisRefExt.Outputs.CommandDecceleration_S_0_0359_0_0.%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0359_0_0),_data4);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1236, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1236;
                RETURN;
            END_IF;    

            _data2[1].%X0   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit0_Reserve;
            _data2[1].%X1   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit1_Reserve;
            _data2[1].%X2   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit2_Reserve;
            _data2[1].%X3   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit3_Reserve;
            _data2[1].%X4   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit4_Reserve;
            _data2[1].%X5   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit5_Reserve;
            _data2[1].%X6   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit6_Reserve;
            _data2[1].%X7   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit7_Reserve;
            _data2[0].%X0   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1.ModeSelectionBit0;
            _data2[0].%X1   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1.ModeSelectionBit1;
            _data2[0].%X2   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1.DCbusDischarge;
            _data2[0].%X3   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit11_Reserve;
            _data2[0].%X4   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1.ControllingTheReadyForOperationRelay;
            _data2[0].%X5   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1._bit13_Reserve;
            _data2[0].%X6   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1.ControllingDCbusChargingAndMainsContactor;
            _data2[0].%X7   :=  AxisRefExt.Outputs.SupplyUnitControlWord_S_0_1720_0_1.Enabling;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_1720_0_1),_data2);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1237, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1237;
                RETURN;
            END_IF;    

            _data2[1]   :=  AxisRefExt.Outputs.BipolarTorqueLimitation_S_0_0092_0_0.%B0;
            _data2[0]   :=  AxisRefExt.Outputs.BipolarTorqueLimitation_S_0_0092_0_0.%B1;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0092_0_0),_data2);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1238, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1238;
                RETURN;
            END_IF;  

            _data2[1]   :=  AxisRefExt.Outputs.CommandTorque_S_0_0080_0_0.%B0;
            _data2[0]   :=  AxisRefExt.Outputs.CommandTorque_S_0_0080_0_0.%B1;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0080_0_0),_data2);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1239, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1239;
                RETURN;
            END_IF;  

            _data4[3]   :=  AxisRefExt.Outputs.CommandJerk_S_0_0193_0_0.%B0;
            _data4[2]   :=  AxisRefExt.Outputs.CommandJerk_S_0_0193_0_0.%B1;
            _data4[1]   :=  AxisRefExt.Outputs.CommandJerk_S_0_0193_0_0.%B2;
            _data4[0]   :=  AxisRefExt.Outputs.CommandJerk_S_0_0193_0_0.%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(AxisRefExt.HWIDs.HW_S_0_0193_0_0),_data4);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(     UINT#1240, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1240;
                RETURN;
            END_IF;  

            //************************************************************
            
        END_METHOD   
            
        ///<summary>
        /// This method controls the power stage (On or Off).
        ///</summary>
        VAR INTERNAL
            MC_PowerEnable_PV					:	BOOL := FALSE;		//Enable - previous value
        END_VAR
        METHOD PUBLIC OVERRIDE MC_Power 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            END_VAR
            VAR_OUTPUT
                Status          :   BOOL;                       //  Effective_State of the power stage
                Valid           :   BOOL;                       //  If true, a valid set of outputs is available at the method
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification            
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1430, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1430;
                RETURN;
            END_IF;

            Valid   := FALSE;
            IF Enable THEN
                IF NOT MC_PowerEnable_PV THEN
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable   :=  TRUE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn       :=  TRUE;
                END_IF;
                IF NOT  _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 AND 
                        _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND 
                        _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                    Status  := TRUE;	
                    Valid   := TRUE;
                ELSE
                    Status  := FALSE;	
                    Valid   := TRUE;
                END_IF;
                IF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 = TRUE THEN
                    Status	:= FALSE;	
                    Error   := TRUE; 						
                    ErrorID.%B1 := _AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0.%B1;
                    ErrorID.%B0 := _AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0.%B0;
                END_IF;                
            END_IF;

            IF NOT Enable AND MC_PowerEnable_PV THEN
                _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable   :=  FALSE;
                _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn       :=  FALSE;
            END_IF;

            MC_PowerEnable_PV := Enable;
        END_METHOD 

        ///<summary>
        /// This method commands the axis to perform the «search home» sequence. The details of this sequence are
        /// manufacturer dependent and can be set by the axis’ parameters. The ‘Position’ input is used to set the absolute 
        /// position when reference signal is detected. This method completes at ‘Standstill’ if it was started in ‘Standstill’.
        ///</summary>
        VAR INTERNAL
            MC_HomeExecute_PV					: 	BOOL;				//Execute - previous value
            MC_HomeErrorID					    : 	DINT;
            MC_HomeCycle					    : 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_Home
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                Position        :   LREAL;                      //  Absolute position when the reference signal is detected             
                HommingMode     :   INT;                        //  Required homming mode           
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Reference known and set sucessfully
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   DINT;                       // Error identification           
             END_VAR
             VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1440, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1440;
                RETURN;
            END_IF;

            IF THIS.AxoHome_Task.StartTriggered() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Home;
            END_IF;

            IF Execute AND NOT MC_HomeExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_HomeCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                Messenger.ActivateOnCondition(ULINT#1441, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1442, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);

                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_HomeErrorID :=  DINT#0;
                    DriveStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.IPOSYNC := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := FALSE;      
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ClearError := FALSE;
                    _State := UINT#310;
                END_IF;
                // Reseting InReference flag 
                IF _State = UINT#310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#510;
                    END_IF;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := TRUE;
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference THEN
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                        _State := UINT#311;
                        RETURN;
                    END_IF;
                END_IF;                
                //Writing Homing configuration ENC_1: Home offset (0x607C:00 / S-0-0052 / --)
                IF _State = UINT#311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#511;
                    END_IF;                    
                    IF Acceleration <= 0 OR Deceleration <= 0 THEN
                        _State := UINT#329;
                        RETURN;
                    END_IF;

                    _dword :=  TO_DWORD(TO_DINT(Position * ScalingConstantRequiredPosition));
                    _data4[0] := _dword.%B0;
                    _data4[1] := _dword.%B1;
                    _data4[2] := _dword.%B2;
                    _data4[3] := _dword.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#52,
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#312;
                    ElSIF _WriteRecord.error THEN 
                        Messenger.Activate( UINT#1444, eAxoMessageCategory#ProgrammingError);
                        MC_HomeErrorID :=   DINT#1444;
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#329;
                    END_IF;
                END_IF;
                IF _State = UINT#312 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#512;
                    END_IF; 
                    _WriteRecord(request := FALSE, record := _data4);
                    IF NOT _WriteRecord.busy AND NOT _WriteRecord.done AND NOT _WriteRecord.error  THEN
                        _State := UINT#313;
                    END_IF;
                END_IF;
                //Writing Homing function: Configuration (0x2500:02 / S-0-0147 / --)
                IF _State = UINT#313 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#513;
                    END_IF; 
                    _word :=  TO_WORD(HommingMode);
                    _data2[0] := _word.%B0;
                    _data2[1] := _word.%B1;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#147,
                                    length      :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#314;
                    ElSIF _WriteRecord.error THEN 
                        Messenger.Activate( UINT#1445, eAxoMessageCategory#ProgrammingError);
                        MC_HomeErrorID :=   DINT#1445;
                        _WriteRecord(request := FALSE, record := _data2);
                        _State := UINT#329;
                    END_IF;
                END_IF;
                IF _State = UINT#314 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#514;
                    END_IF; 
                    _WriteRecord(request := FALSE, record := _data2);
                    IF NOT _WriteRecord.busy AND NOT _WriteRecord.done AND NOT _WriteRecord.error  THEN
                        _State := UINT#315;
                    END_IF;
                END_IF;
                //Writing Homing speeds: Speed during search for switch (0x6099:01 / S-0-0041 / --)
                IF _State = UINT#315 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#515;
                    END_IF; 
                    _dword :=  TO_DWORD(TO_DINT(Velocity * ScalingConstantRequiredVelocity));
                    _data4[0] := _dword.%B0;
                    _data4[1] := _dword.%B1;
                    _data4[2] := _dword.%B2;
                    _data4[3] := _dword.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#41,
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#316;
                    ElSIF _WriteRecord.error THEN 
                        Messenger.Activate( UINT#1446, eAxoMessageCategory#ProgrammingError);
                        MC_HomeErrorID :=   DINT#1446;
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#329;
                    END_IF;
                END_IF;
                //Writing Homing speeds: Speed during search for zero (0x6099:02 / S-0-0542 / --)
                IF _State = UINT#316 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#516;
                    END_IF; 
                    _dword :=  TO_DWORD(TO_DINT(Velocity * ScalingConstantRequiredVelocity * 0.1));
                    _data4[0] := _dword.%B0;
                    _data4[1] := _dword.%B1;
                    _data4[2] := _dword.%B2;
                    _data4[3] := _dword.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#542,
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#317;
                    ElSIF _WriteRecord.error THEN 
                        Messenger.Activate( UINT#1446, eAxoMessageCategory#ProgrammingError);
                        MC_HomeErrorID :=   DINT#1446;
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#329;
                    END_IF;
                END_IF;
                //Writing Homing acceleration (0x609A:00 / S-0-0042 / --)
                IF _State = UINT#317 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#517;
                    END_IF; 
                    _dword :=  TO_DWORD(TO_DINT(Acceleration * ScalingConstantRequiredAcceleration));
                    _data4[0] := _dword.%B0;
                    _data4[1] := _dword.%B1;
                    _data4[2] := _dword.%B2;
                    _data4[3] := _dword.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#42,
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#318;
                    ElSIF _WriteRecord.error THEN 
                        Messenger.Activate( UINT#1447, eAxoMessageCategory#ProgrammingError);
                        MC_HomeErrorID :=   DINT#1447;
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#329;
                    END_IF;
                END_IF;
                IF _State = UINT#318 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#518;
                    END_IF; 
                    _WriteRecord(request := FALSE, record := _data4);
                    IF NOT _WriteRecord.busy AND NOT _WriteRecord.done AND NOT _WriteRecord.error  THEN
                        _State := UINT#319;
                    END_IF;
                END_IF;
                IF _State = UINT#319 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#519, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#519;
                    END_IF; 
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit0  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit1  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit2  := FALSE;
                    IF  NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2 THEN
                        _State := UINT#320;
                    END_IF;
                END_IF;
                IF _State = UINT#320 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#520;
                    END_IF; 
                    IF  _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND
                        _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                       _State := UINT#321;
                    END_IF;                
                END_IF;                
                IF _State = UINT#321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#521;
                    END_IF; 
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := TRUE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := TRUE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := NOT _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue;    
                   _State := UINT#322;
                END_IF;
                IF _State = UINT#322 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#522;
                    END_IF; 
                    IF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference AND _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill THEN
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                        _State := UINT#323;
                    END_IF;
                END_IF;
                IF _State = UINT#323 THEN
                    _State := UINT#327;
                END_IF;
                IF _State = UINT#327 THEN
                    Done := TRUE;            
                    MC_HomeCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#328 THEN
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    MC_HomeCycle := ULINT#0;     
                    CommandAborted := TRUE;  
                    AxoHome_Task.Abort();          
                END_IF;         
                IF _State = UINT#329 THEN
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    MC_HomeCycle := ULINT#0;     
                    Error := TRUE;    
                    AxoHome_Task.ThrowWhen(TRUE);          
                END_IF;         
                
                IF _State>=UINT#310 AND _State<UINT#327 THEN
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#328;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_HomeErrorID = DINT#0 THEN
                            MC_HomeErrorID := TO_DINT(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#329;
                    ELSIF _AxisReference^.Data.Cycle <> MC_HomeCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#328;
                    END_IF;                  
                END_IF;     
                
                THIS.CallTimers(TRUE,FALSE);
                THIS.AxoHome_Task.ThrowWhen(_errorTimer.output );
                THIS.AxoHome_Task.ThrowWhen(THIS.AxoHome_Task.Duration >= DriveConfig.TaskTimeout AND DriveConfig.TaskTimeout > T#0s ,'AxoHome_Task timeout.');                
                DriveStatus.Action.Id := _State;    
            END_IF;

            IF THIS.AxoHome_Task.DoneReached() AND _State>=UINT#310 AND _State<=UINT#329 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                MC_HomeErrorID := DINT#0;
                _State := UINT#0;
            END_IF;
            IF THIS.AxoHome_Task.RestoreTriggered() AND _State>=UINT#310 AND _State<=UINT#329 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                MC_HomeErrorID := DINT#0;
                _State := UINT#0;
                MC_HomeCycle := ULINT#0;     
            END_IF;     

            ErrorID := MC_HomeErrorID;
            MC_HomeExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop and transfers the axis to the_State ‘Stopping’. It aborts any
        /// ongoing method execution. While the axis is in_State ‘Stopping’, no other method can perform any motion on the
        /// same axis. 
        ///</summary>
        VAR INTERNAL
            MC_StopExecute_PV					: 	BOOL;				//Execute - previous value
            MC_StopErrorID					    : 	DINT;
            MC_StopCycle					    : 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_Stop 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the action at rising edge
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Zero velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   DINT;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1470, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1470;
                RETURN;
            END_IF;

            IF THIS.AxoStop_Task.StartTriggered() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Stop;
            END_IF;

            IF Execute AND NOT MC_StopExecute_PV THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_StopCycle := _AxisReference^.Data.Cycle ;
                _State := UINT#0;
            END_IF;

            IF Execute THEN 
                Messenger.ActivateOnCondition(ULINT#1471, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1472, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);
    
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_StopErrorID := DINT#0;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0 := TO_DINT(Deceleration * ScalingConstantRequiredDeceleration );
                    _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0 := TO_DINT(Jerk * ScalingConstantRequiredJerk );     
                    _State := UINT#330;
                END_IF;
                IF _State = UINT#330 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF Deceleration <= 0 OR Jerk <= 0 THEN
                        _State := UINT#339;
                    ELSE
                        _State := UINT#331;
                    END_IF;
                END_IF;
                IF _State = UINT#331 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#531;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := FALSE;
                    IF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill THEN
                        _State := UINT#332;
                    END_IF;
                END_IF;
                IF _State = UINT#332 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        _State := UINT#333;
                    END_IF;
                END_IF;               
                IF _State = UINT#333 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        _State := UINT#334;
                    END_IF;
                END_IF;     
                IF _State = UINT#334 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        _State := UINT#335;
                    END_IF;
                END_IF;                          
                IF _State = UINT#335 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        _State := UINT#336;
                    END_IF;
                END_IF;                          
                IF _State = UINT#336 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        _State := UINT#337;
                    END_IF;
                END_IF;                          
                IF _State = UINT#337 THEN
                    Done := TRUE;            
                    Active := TRUE;     
                    MC_StopCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#338 THEN
                    MC_StopCycle := ULINT#0;     
                    CommandAborted := TRUE;            
                    AxoStop_Task.Abort();          
                END_IF;         
                IF _State = UINT#339 THEN
                    MC_StopCycle := ULINT#0;     
                    Error := TRUE;    
                    AxoStop_Task.ThrowWhen(TRUE);          
                END_IF;         
 
                IF _State>=UINT#330 AND _State<UINT#337 THEN
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#338;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_StopErrorID = DINT#0 THEN
                            MC_StopErrorID := TO_DINT(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#339;
                    ELSIF _AxisReference^.Data.Cycle <> MC_StopCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#338;
                    END_IF;                  
                END_IF;       
                THIS.CallTimers(TRUE,FALSE);
                THIS.AxoStop_Task.ThrowWhen(_errorTimer.output );
                THIS.AxoStop_Task.ThrowWhen(THIS.AxoStop_Task.Duration >= DriveConfig.TaskTimeout AND DriveConfig.TaskTimeout > T#0s ,'AxoStop_Task timeout.');                
                DriveStatus.Action.Id := _State;   
            END_IF;

            IF THIS.AxoStop_Task.DoneReached() AND _State>=UINT#330 AND _State<=UINT#339 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_StopErrorID := DINT#0;
                _State := UINT#0;
            END_IF;
            IF THIS.AxoStop_Task.RestoreTriggered() AND _State>=UINT#330 AND _State<=UINT#339 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_StopErrorID := DINT#0;
                _State := UINT#0;
                MC_StopCycle := ULINT#0;  
            END_IF;     
            ErrorID := MC_StopErrorID;
            MC_StopExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion stop. The axis is moved to the_State ‘DiscreteMotion’, until the
        /// velocity is zero. With the ‘Done’ output set, the_State is transferred to ‘Standstill’.
        ///</summary>
        VAR INTERNAL
            MC_HaltExecute_PV					: 	BOOL;				//Execute - previous value
            MC_HaltErrorID					    : 	DINT;
            MC_HaltCycle					    : 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_Halt 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the action at rising edge
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ [u/s2]
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Zero velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by switching off power (only possibility to abort)                
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   DINT;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1480, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1480;
                RETURN;
            END_IF;

            IF THIS.AxoHalt_Task.StartTriggered() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Halt;
            END_IF;

            IF Execute AND NOT MC_HaltExecute_PV THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_HaltCycle := _AxisReference^.Data.Cycle ;
                _State := UINT#0;
            END_IF;

            IF Execute THEN 	
                Messenger.ActivateOnCondition(ULINT#1481, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1482, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);
    
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_HaltErrorID := DINT#10;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0 := TO_DINT(Deceleration * ScalingConstantRequiredDeceleration);
                    _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0 := TO_DINT(Jerk * ScalingConstantRequiredJerk);
                    _State := UINT#340;
                END_IF;
                IF _State = UINT#340 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#540;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF Deceleration <= 0 OR Jerk <= 0 THEN
                        _State := UINT#349;
                    ELSE
                        _State := UINT#341;
                    END_IF;
                END_IF;
                IF _State = UINT#341 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#541;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := FALSE;
                    IF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill THEN
                        _State := UINT#342;
                    END_IF;
                END_IF;
                IF _State = UINT#342 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        _State := UINT#343;
                    END_IF;
                END_IF;               
                IF _State = UINT#343 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF TRUE THEN
                        _State := UINT#344;
                    END_IF;
                END_IF;          
                IF _State = UINT#344 THEN
                    IF TRUE THEN
                        _State := UINT#345;
                    END_IF;
                END_IF;                                           
                IF _State = UINT#345 THEN
                    IF TRUE THEN
                        _State := UINT#346;
                    END_IF;
                END_IF;                                           
                IF _State = UINT#346 THEN
                    IF TRUE THEN
                        _State := UINT#347;
                    END_IF;
                END_IF;                                           
                IF _State = UINT#347 THEN
                    Done := TRUE;            
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := TRUE;
                    MC_HaltCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#348 THEN
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := TRUE;
                    CommandAborted := TRUE;            
                    THIS.AxoHalt_Task.Abort();
                END_IF;         
                IF _State = UINT#349 THEN
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := TRUE;
                    MC_HaltCycle := ULINT#0;     
                    Error := TRUE;    
                    THIS.AxoHalt_Task.ThrowWhen(TRUE);
                END_IF;         
                IF _State>=UINT#340 AND _State<UINT#347 THEN
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#348;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_HaltErrorID = DINT#0 THEN
                            MC_HaltErrorID := TO_DINT(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#349;
                    ELSIF _AxisReference^.Data.Cycle <> MC_HaltCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#348;
                    END_IF;                  
                END_IF;           
                THIS.CallTimers(TRUE,FALSE);
                THIS.AxoHalt_Task.ThrowWhen(_errorTimer.output );
                THIS.AxoHalt_Task.ThrowWhen(THIS.AxoHalt_Task.Duration >= DriveConfig.TaskTimeout AND DriveConfig.TaskTimeout > T#0s ,'AxoHalt_Task timeout.');                
                DriveStatus.Action.Id := _State;     
            END_IF;

            IF THIS.AxoHalt_Task.DoneReached() AND _State>=UINT#340 AND _State<=UINT#349 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := TRUE;
                MC_HaltErrorID := DINT#0;
                _State := UINT#0;
            END_IF;
            IF THIS.AxoHalt_Task.RestoreTriggered() AND _State>=UINT#340 AND _State<=UINT#349 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := TRUE;
                MC_HaltErrorID := DINT#0;
                _State := UINT#0;
                MC_HaltCycle := ULINT#0;   
            END_IF;     
            ErrorID := MC_HaltErrorID;
            MC_HaltExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion to a specified absolute position.
        ///<summary>
        VAR INTERNAL
            MC_MoveAbsoluteExecute_PV					: 	BOOL;				//Execute - previous value
            MC_MoveAbsoluteErrorID					    : 	DINT;
            MC_MoveAbsoluteCycle					    : 	ULINT;
            MC_MoveAbsoluteContinuousUpdate_SV          :   BOOL;
            MC_MoveAbsolutePosition_PV                  :   LREAL;                                          
            MC_MoveAbsoluteVelocity_PV                  :   LREAL;                    
            MC_MoveAbsoluteAcceleration_PV              :   LREAL;                    
            MC_MoveAbsoluteDeceleration_PV              :   LREAL;                                
            MC_MoveAbsoluteJerk_PV                      :   LREAL;                     
            MC_MoveAbsoluteDirection_PV                 :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;        
        END_VAR
        METHOD PUBLIC OVERRIDE MC_MoveAbsolute
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Position        :   LREAL;                      //  Commanded ‘Position’ for the motion (in technical unit [u]) (negative or positive)                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-4 values: PositiveDirection, ShortestWay, NegativeDirection, CurrentDirection)
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded position finally reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   DINT;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
                        
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1490, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1490;
                RETURN;
            END_IF;

            IF THIS.AxoMoveAbsolute_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_MoveAbsolute;
            END_IF;

            IF Execute AND NOT MC_MoveAbsoluteExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_MoveAbsoluteCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 
                Messenger.ActivateOnCondition(ULINT#1491, Execute AND Velocity <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1492, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1493, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1494, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);
    
                IF NOT ContinuousUpdate THEN
                    MC_MoveAbsoluteContinuousUpdate_SV := FALSE;
                END_IF;
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_MoveAbsoluteErrorID := DINT#0; 
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive      := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative      := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl    := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := FALSE;      
                    MC_MoveAbsoluteContinuousUpdate_SV := ContinuousUpdate;
                    _State := UINT#350;
                END_IF;
                IF _State = UINT#350 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#550;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;   
                    IF Velocity > 0 AND Acceleration > 0 AND Deceleration > 0 AND Jerk > 0 THEN
                        _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0 :=         TO_DINT(Position        *   ScalingConstantRequiredPosition);
                        _AxisReference^.Outputs.CommandVelocity_S_0_0259_0_0 :=         TO_DINT(Velocity        *   ScalingConstantRequiredVelocity     * _AxisReference^.Data.OverrideVelocityFactor);
                        _AxisReference^.Outputs.CommandAcceleration_S_0_0260_0_0 :=     TO_DINT(Acceleration    *   ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0 :=    TO_DINT(Deceleration    *   ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);                        
                        _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0 :=             TO_DINT(Jerk            *   ScalingConstantRequiredJerk         * _AxisReference^.Data.OverrideJerkFactor);                        
                        MC_MoveAbsolutePosition_PV      :=  Position;                  
                        MC_MoveAbsoluteVelocity_PV      :=  Velocity;                  
                        MC_MoveAbsoluteAcceleration_PV  :=  Acceleration;              
                        MC_MoveAbsoluteDeceleration_PV  :=  Deceleration;              
                        MC_MoveAbsoluteJerk_PV          :=  Jerk;                      
                        MC_MoveAbsoluteDirection_PV     :=  Direction;                                         
                        _State := UINT#351;
                    END_IF;
                END_IF;
                IF _State = UINT#351 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#551, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#551;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit0  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit1  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit2  := FALSE;
                    IF  NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2 THEN
                        _State := UINT#352;
                    END_IF;
                END_IF;      
                IF _State = UINT#352 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#552, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#552;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF  _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND
                        _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                       _State := UINT#353;
                    END_IF;                
                END_IF;     
                IF _State = UINT#353 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#553, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#553;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;     
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt  := TRUE;
                    IF TRUE THEN
                       _State := UINT#354;
                    END_IF;                
                END_IF;                                              
                //Executing movement
                IF _State = UINT#354 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#554, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#554;
                    END_IF;                     
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := NOT _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck;
                    IF TRUE THEN      
                        _State := UINT#355;
                    END_IF;    
                END_IF;
                IF _State = UINT#355 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#555, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#555;
                    END_IF;                     
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue = _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck THEN      
                        _State := UINT#356;
                    END_IF;    
                END_IF;                
                IF _State = UINT#356 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#556, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#556;
                    END_IF;                     
                    IF _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill AND _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition THEN      
                        _State := UINT#357;
                    END_IF;    
                END_IF;
                IF _State = UINT#357 THEN
                    Done := TRUE;            
                    MC_MoveAbsoluteCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#358 THEN
                    CommandAborted := TRUE;            
                    AxoMoveAbsolute_Task.Abort();          
                END_IF;         
                IF _State = UINT#359 THEN
                    MC_MoveAbsoluteCycle := ULINT#0;     
                    Error := TRUE;    
                    AxoMoveAbsolute_Task.ThrowWhen(TRUE);          
                END_IF;         

                IF _State>=UINT#350 AND _State<UINT#357 THEN
                    IF MC_MoveAbsoluteContinuousUpdate_SV AND (
                        MC_MoveAbsolutePosition_PV      <>  Position OR                  
                        MC_MoveAbsoluteVelocity_PV      <>  Velocity OR                  
                        MC_MoveAbsoluteAcceleration_PV  <>  Acceleration OR              
                        MC_MoveAbsoluteDeceleration_PV  <>  Deceleration OR              
                        MC_MoveAbsoluteJerk_PV          <>  Jerk OR                      
                        MC_MoveAbsoluteDirection_PV     <>  Direction ) THEN
                        IF TRUE THEN
                            _State := UINT#350;
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#358;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_MoveAbsoluteErrorID = DINT#0 THEN
                            MC_MoveAbsoluteErrorID := TO_DINT(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#359;
                    ELSIF _AxisReference^.Data.Cycle <> MC_MoveAbsoluteCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#358;
                    END_IF;                  
                END_IF;   

                THIS.CallTimers(TRUE,FALSE);
                THIS.AxoMoveAbsolute_Task.ThrowWhen(_errorTimer.output );
                THIS.AxoMoveAbsolute_Task.ThrowWhen(THIS.AxoMoveAbsolute_Task.Duration >= DriveConfig.TaskTimeout AND DriveConfig.TaskTimeout > T#0s ,'AxoMoveAbsolute_Task timeout.');                
                DriveStatus.Action.Id := _State;    
            END_IF;

            IF THIS.AxoMoveAbsolute_Task.DoneReached() AND _State>=UINT#350 AND _State<=UINT#359 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_MoveAbsoluteErrorID := DINT#0;
                _State := UINT#0;
            END_IF;

            IF THIS.AxoMoveAbsolute_Task.RestoreTriggered() AND _State>=UINT#350 AND _State<=UINT#359 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_MoveAbsoluteErrorID := DINT#0;
                MC_MoveAbsoluteCycle := ULINT#0;     
                _State := UINT#0;
                MC_MoveAbsoluteExecute_PV := FALSE;
            END_IF;                     
            ErrorID := MC_MoveAbsoluteErrorID;
            MC_MoveAbsoluteExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method  commands a controlled motion of a specified distance relative to the set position at the time of the execution.
        ///<summary>
        VAR INTERNAL
            MC_MoveRelativeExecute_PV					: 	BOOL;				//Execute - previous value
            MC_MoveRelativeErrorID					    : 	DINT;
            MC_MoveRelativeCycle					    : 	ULINT;
            MC_MoveRelativeContinuousUpdate_SV          :   BOOL;
            MC_MoveRelativeDistance_PV                  :   LREAL;                                          
            MC_MoveRelativeVelocity_PV                  :   LREAL;                    
            MC_MoveRelativeAcceleration_PV              :   LREAL;                    
            MC_MoveRelativeDeceleration_PV              :   LREAL;                                
            MC_MoveRelativeJerk_PV                      :   LREAL;                     
        END_VAR
        METHOD PUBLIC OVERRIDE MC_MoveRelative 
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   DINT;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1500, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1500;
                RETURN;
            END_IF;

            IF THIS.AxoMoveRelative_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_MoveRelative;
            END_IF;

            IF Execute AND NOT MC_MoveRelativeExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_MoveRelativeCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                Messenger.ActivateOnCondition(ULINT#1501, Execute AND Velocity <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1502, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1503, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1504, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);
    
                IF NOT ContinuousUpdate THEN
                    MC_MoveRelativeContinuousUpdate_SV := FALSE;
                END_IF;

                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_MoveRelativeErrorID := DINT#0;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl:= FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := TRUE;      
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange := TRUE;                            
                    MC_MoveRelativeContinuousUpdate_SV := ContinuousUpdate;
                    _State := UINT#360;
                END_IF;
                IF _State = UINT#360 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#560, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#560;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;   
                    IF Velocity > 0 AND Acceleration > 0 AND Deceleration >0 AND Jerk > 0 THEN
                        _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0 :=         TO_DINT(Distance        *   ScalingConstantRequiredPosition);
                        _AxisReference^.Outputs.CommandVelocity_S_0_0259_0_0 :=         TO_DINT(Velocity        *   ScalingConstantRequiredVelocity     * _AxisReference^.Data.OverrideVelocityFactor);
                        _AxisReference^.Outputs.CommandAcceleration_S_0_0260_0_0 :=     TO_DINT(Acceleration    *   ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0 :=    TO_DINT(Deceleration    *   ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);                        
                        _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0 :=             TO_DINT(Jerk            *   ScalingConstantRequiredJerk         * _AxisReference^.Data.OverrideJerkFactor);           
                        MC_MoveRelativeDistance_PV      :=  Distance;                  
                        MC_MoveRelativeVelocity_PV      :=  Velocity;                  
                        MC_MoveRelativeAcceleration_PV  :=  Acceleration;              
                        MC_MoveRelativeDeceleration_PV  :=  Deceleration;              
                        MC_MoveRelativeJerk_PV          :=  Jerk;   
                        _State := UINT#361;
                    END_IF;
                END_IF;
                IF _State = UINT#361 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#561, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#561;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit0  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit1  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit2  := FALSE;
                    IF  NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2 THEN
                        _State := UINT#362;
                    END_IF;
                END_IF;
                IF _State = UINT#362 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#562, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#562;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF  _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND
                        _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                       _State := UINT#363;
                    END_IF;                
                END_IF;     
                IF _State = UINT#363 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#563, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#563;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;     
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt  := TRUE;
                    IF TRUE THEN
                       _State := UINT#364;
                    END_IF;                
                END_IF;             
                //Executing movement
                IF _State = UINT#364 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#564, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#564;
                    END_IF;                     
                    Busy := TRUE;            
                    Active := TRUE;    
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := NOT _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck;
                    IF TRUE THEN      
                        _State := UINT#365;
                    END_IF;    
                END_IF;
                IF _State = UINT#365 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#565, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#565;
                    END_IF;                     
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue = _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck THEN      
                        _State := UINT#366;
                    END_IF;    
                END_IF;                
                IF _State = UINT#366 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#566, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#566;
                    END_IF;                     
                    IF _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill AND _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition THEN      
                        _State := UINT#367;
                    END_IF;    
                END_IF;
                IF _State = UINT#367 THEN
                    Done := TRUE;            
                    MC_MoveRelativeCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#368 THEN
                    CommandAborted := TRUE;            
                    AxoMoveRelative_Task.Abort();          
                END_IF;         
                IF _State = UINT#369 THEN
                    MC_MoveRelativeCycle := ULINT#0;     
                    Error := TRUE;    
                    AxoMoveRelative_Task.ThrowWhen(TRUE);          
                END_IF;         
                
                IF _State>=UINT#360 AND _State<UINT#367 THEN
                    IF MC_MoveRelativeContinuousUpdate_SV AND (
                        MC_MoveRelativeDistance_PV      <>  Distance OR                  
                        MC_MoveRelativeVelocity_PV      <>  Velocity OR                  
                        MC_MoveRelativeAcceleration_PV  <>  Acceleration OR              
                        MC_MoveRelativeDeceleration_PV  <>  Deceleration OR              
                        MC_MoveRelativeJerk_PV          <>  Jerk ) THEN
                        IF TRUE THEN    
                            _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0 :=         TO_DINT(Distance        *   ScalingConstantRequiredPosition);
                            _AxisReference^.Outputs.CommandVelocity_S_0_0259_0_0 :=         TO_DINT(Velocity        *   ScalingConstantRequiredVelocity     * _AxisReference^.Data.OverrideVelocityFactor);
                            _AxisReference^.Outputs.CommandAcceleration_S_0_0260_0_0 :=     TO_DINT(Acceleration    *   ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0 :=    TO_DINT(Deceleration    *   ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);                        
                            _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0 :=             TO_DINT(Jerk            *   ScalingConstantRequiredJerk         * _AxisReference^.Data.OverrideJerkFactor);           
                            MC_MoveRelativeDistance_PV      :=  Distance;                  
                            MC_MoveRelativeVelocity_PV      :=  Velocity;                  
                            MC_MoveRelativeAcceleration_PV  :=  Acceleration;              
                            MC_MoveRelativeDeceleration_PV  :=  Deceleration;              
                            MC_MoveRelativeJerk_PV          :=  Jerk;    
                            _State := UINT#361;
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#368;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_MoveRelativeErrorID = DINT#0 THEN
                            MC_MoveRelativeErrorID := TO_DINT(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#369;
                    ELSIF _AxisReference^.Data.Cycle <> MC_MoveRelativeCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#368;
                    END_IF;                  
                END_IF;   

                THIS.CallTimers(TRUE,FALSE);
                THIS.AxoMoveRelative_Task.ThrowWhen(_errorTimer.output );
                THIS.AxoMoveRelative_Task.ThrowWhen(THIS.AxoMoveRelative_Task.Duration >= DriveConfig.TaskTimeout AND DriveConfig.TaskTimeout > T#0s ,'AxoMoveRelative_Task timeout.');                
                DriveStatus.Action.Id := _State; 
            END_IF;

            IF THIS.AxoMoveRelative_Task.DoneReached() AND _State>=UINT#360 AND _State<=UINT#369 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_MoveRelativeErrorID := DINT#0;
                // MC_MoveRelativeCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;

            IF THIS.AxoMoveRelative_Task.RestoreTriggered() AND _State>=UINT#360 AND _State<=UINT#369 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_MoveRelativeErrorID := DINT#0;
                MC_MoveRelativeCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;     
            ErrorID := MC_MoveRelativeErrorID;
            MC_MoveRelativeExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a controlled motion of a specified relative distance additional to the most recent 
        /// commanded position in the axis_State ‘DiscreteMotion’. The most recent commanded position may be the result of a 
        /// previous MC_MoveAdditive motion which was aborted. If the method is activated in the axis_State ‘ContinuousMotion’, the
        /// specified relative distance is added to the set position at the time of the execution.
        ///<summary>
        VAR INTERNAL
            MC_MoveAdditiveExecute_PV					: 	BOOL;				//Execute - previous value
            MC_MoveAdditiveErrorID					    : 	DINT;
            MC_MoveAdditiveCycle					    : 	ULINT;
            MC_MoveAdditiveContinuousUpdate_SV          :   BOOL;
            MC_MoveAdditiveDistance_PV                  :   LREAL;                                          
            MC_MoveAdditiveVelocity_PV                  :   LREAL;                    
            MC_MoveAdditiveAcceleration_PV              :   LREAL;                    
            MC_MoveAdditiveDeceleration_PV              :   LREAL;                                
            MC_MoveAdditiveJerk_PV                      :   LREAL;   
        END_VAR
        METHOD PUBLIC OVERRIDE MC_MoveAdditive
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Distance        :   LREAL;                      //  Relative distance for the motion (in technical unit [u]                             
                Velocity        :   LREAL;                      //  Value of the maximum ‘Velocity’ (not necessarily reached) [u/s].
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       // Commanded distance reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   DINT;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1510, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1510;
                RETURN;
            END_IF;

            IF Execute AND NOT MC_MoveAdditiveExecute_PV THEN
                _State := UINT#0;  //TODO check if this casues the issue with two move relative movements???
            END_IF;

            IF Execute THEN 	
                Messenger.ActivateOnCondition(ULINT#1511, Execute AND Velocity <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1512, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1513, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1514, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);
    
                IF NOT ContinuousUpdate THEN
                    MC_MoveAdditiveContinuousUpdate_SV := FALSE;
                END_IF;

                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;   
                    MC_MoveAdditiveErrorID := DINT#0;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl:= FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange := TRUE;      
                    MC_MoveAdditiveContinuousUpdate_SV := ContinuousUpdate;                    
                    IF Velocity > 0 AND Acceleration > 0 AND Deceleration >0 AND Jerk > 0 THEN
                        MC_MoveAdditiveDistance_PV      :=  Distance;                  
                        MC_MoveAdditiveVelocity_PV      :=  Velocity;                  
                        MC_MoveAdditiveAcceleration_PV  :=  Acceleration;              
                        MC_MoveAdditiveDeceleration_PV  :=  Deceleration;              
                        MC_MoveAdditiveJerk_PV          :=  Jerk;   
                        IF _AxisReference^.Status.CurrentMotionTaskId = eAxoMotionTaskId#Axo_MoveAbsolute THEN
                            AxoMoveAbsolute_Task.Abort();
                            _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := FALSE;      
                            _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0 :=         TO_DINT((MC_MoveAbsolutePosition_PV + Distance) * ScalingConstantRequiredPosition);
                            _AxisReference^.Outputs.CommandVelocity_S_0_0259_0_0 :=         TO_DINT(Velocity        *   ScalingConstantRequiredVelocity         * _AxisReference^.Data.OverrideVelocityFactor);
                            _AxisReference^.Outputs.CommandAcceleration_S_0_0260_0_0 :=     TO_UINT(Acceleration    *   ScalingConstantRequiredAcceleration     * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0 :=    TO_UINT(Deceleration    *   ScalingConstantRequiredDeceleration     * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0 :=             TO_DINT(Jerk            *   ScalingConstantRequiredJerk             * _AxisReference^.Data.OverrideJerkFactor);           
                        ELSE
                            _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := TRUE;      
                            _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0 :=         TO_DINT((Distance)      *   ScalingConstantRequiredPosition);
                            _AxisReference^.Outputs.CommandVelocity_S_0_0259_0_0 :=         TO_DINT(Velocity        *   ScalingConstantRequiredVelocity         * _AxisReference^.Data.OverrideVelocityFactor);
                            _AxisReference^.Outputs.CommandAcceleration_S_0_0260_0_0 :=     TO_UINT(Acceleration    *   ScalingConstantRequiredAcceleration     * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0 :=    TO_UINT(Deceleration    *   ScalingConstantRequiredDeceleration     * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0 :=             TO_DINT(Jerk            *   ScalingConstantRequiredJerk             * _AxisReference^.Data.OverrideJerkFactor);           
                        END_IF;
                        IF _AxisReference^.Status.CurrentMotionTaskId = eAxoMotionTaskId#Axo_MoveRelative THEN
                            AxoMoveRelative_Task.Abort();
                        END_IF;
                        _AxisReference^.Status.CurrentMotionTaskId := eAxoMotionTaskId#Axo_MoveAdditive;
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                        MC_MoveAdditiveCycle := _AxisReference^.Data.Cycle ;
                        _State := UINT#371;
                    END_IF;
                END_IF;
                IF _State = UINT#370 THEN
                    _State := UINT#371;
                END_IF;
                IF _State = UINT#371 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#571, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#571;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit0  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit1  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit2  := FALSE;
                    IF  NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2 THEN
                        _State := UINT#372;
                    END_IF;
                END_IF;
                IF _State = UINT#372 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#572, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#572;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF  _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND
                        _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                       _State := UINT#373;
                    END_IF;                
                END_IF;               
                IF _State = UINT#373 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#573, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#573;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;     
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt  := TRUE;
                    IF TRUE THEN
                       _State := UINT#374;
                    END_IF;
                END_IF;
                IF _State = UINT#374 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#574, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#574;
                    END_IF;                     
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := NOT _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck;
                    IF TRUE THEN      
                        _State := UINT#375;
                    END_IF;   
                END_IF;
                IF _State = UINT#375 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#575, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#575;
                    END_IF;                     
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue = _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.PositionCommandAck THEN      
                        _State := UINT#376;
                    END_IF;  
                END_IF;
                IF _State = UINT#376 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#576, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#576;
                    END_IF;                     
                    IF _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.DriveStandstill AND _AxisReference^.Inputs.SignalStatusWord_S_0_0144_0_0.InTargetPosition THEN      
                        _State := UINT#377;
                    END_IF;    
                END_IF;
                IF _State = UINT#377 THEN
                    Done := TRUE;            
                    MC_MoveAdditiveCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#378 THEN
                    CommandAborted := TRUE;       
                    AxoMoveAdditive_Task.Abort();               
                END_IF;         
                IF _State = UINT#379 THEN
                    MC_MoveAdditiveCycle := ULINT#0;     
                    AxoMoveAdditive_Task.ThrowWhen(TRUE);               
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#370 AND _State<UINT#377 THEN
                    IF MC_MoveAdditiveContinuousUpdate_SV AND (
                        MC_MoveAdditiveDistance_PV      <>  Distance OR                  
                        MC_MoveAdditiveVelocity_PV      <>  Velocity OR                  
                        MC_MoveAdditiveAcceleration_PV  <>  Acceleration OR              
                        MC_MoveAdditiveDeceleration_PV  <>  Deceleration OR              
                        MC_MoveAdditiveJerk_PV          <>  Jerk ) THEN
                        IF TRUE THEN 
                            IF NOT _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative THEN
                                _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0 :=_AxisReference^.Outputs.CommandPosition_S_0_0282_0_0  + TO_DINT((Distance - MC_MoveAdditiveDistance_PV) * ScalingConstantRequiredPosition);
                            ELSE
                                _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0 := TO_DINT((Distance) * ScalingConstantRequiredPosition) - _AxisReference^.Inputs.ActualPosition_S_0_0386_0_0;
                            END_IF;
                            _AxisReference^.Outputs.CommandVelocity_S_0_0259_0_0 :=         TO_DINT(Velocity        *   ScalingConstantRequiredVelocity     * _AxisReference^.Data.OverrideVelocityFactor);
                            _AxisReference^.Outputs.CommandAcceleration_S_0_0260_0_0 :=     TO_UINT(Acceleration    *   ScalingConstantRequiredAcceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0 :=    TO_UINT(Deceleration    *   ScalingConstantRequiredDeceleration * _AxisReference^.Data.OverrideAccelerationFactor);
                            _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0 :=             TO_UINT(Jerk            *   ScalingConstantRequiredJerk         * _AxisReference^.Data.OverrideJerkFactor);           
                            MC_MoveAdditiveDistance_PV      :=  Distance;                  
                            MC_MoveAdditiveVelocity_PV      :=  Velocity;                  
                            MC_MoveAdditiveAcceleration_PV  :=  Acceleration;              
                            MC_MoveAdditiveDeceleration_PV  :=  Deceleration;              
                            MC_MoveAdditiveJerk_PV          :=  Jerk;   
                            _State := UINT#371; 
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#378;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_MoveAdditiveErrorID = DINT#0 THEN
                            MC_MoveAdditiveErrorID := TO_DINT(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#379;
                    ELSIF _AxisReference^.Data.Cycle <> MC_MoveAdditiveCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#378;
                    END_IF;                  
                END_IF;   
                THIS.CallTimers(TRUE,FALSE);
                THIS.AxoMoveAdditive_Task.ThrowWhen(_errorTimer.output );
                THIS.AxoMoveAdditive_Task.ThrowWhen(THIS.AxoMoveAdditive_Task.Duration >= DriveConfig.TaskTimeout AND DriveConfig.TaskTimeout > T#0s ,'AxoMoveAdditive_Task timeout.');                
                DriveStatus.Action.Id := _State; 
            END_IF;

            IF THIS.AxoMoveAdditive_Task.DoneReached() AND _State>=UINT#370 AND _State<=UINT#379 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_MoveAdditiveErrorID := DINT#0;
                // MC_MoveAdditiveCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;

            IF THIS.AxoMoveAdditive_Task.RestoreTriggered() AND _State>=UINT#370 AND _State<=UINT#379 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_MoveAdditiveErrorID := DINT#0;
                MC_MoveAdditiveCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;     

            ErrorID := MC_MoveAdditiveErrorID;
            MC_MoveAdditiveExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method commands a never ending controlled motion at a specified velocity.
        ///<summary>
        VAR INTERNAL
            MC_MoveVelocityExecute_PV					: 	BOOL;				//Execute - previous value
            MC_MoveVelocityErrorID					    : 	WORD;
            MC_MoveVelocityCycle					    : 	ULINT;
            MC_MoveVelocityContinuousUpdate_SV          :   BOOL;
            MC_MoveVelocityVelocity_PV                  :   LREAL;                    
            MC_MoveVelocityAcceleration_PV              :   LREAL;                    
            MC_MoveVelocityDeceleration_PV              :   LREAL;                                
            MC_MoveVelocityJerk_PV                      :   LREAL;                     
            MC_MoveVelocityDirection_PV                 :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;        
        END_VAR
        METHOD PUBLIC OVERRIDE MC_MoveVelocity
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Velocity        :   LREAL;                      //  Value of the maximum velocity [u/s]. Can be a signed value.
                Acceleration    :   LREAL;                      //  Value of the ‘Acceleration’ (always positive) (increasing energy of the motor) [u/s2]
                Deceleration    :   LREAL;                      //  Value of the ‘Deceleration’ (always positive) (decreasing energy of the motor) [u/s2]                
                Jerk            :   LREAL;                      //  Value of the ‘Jerk’ [u/s3]
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1-of-3 values: PositiveDirection, NegativeDirection, and CurrentDirection. Note: shortest way not applicable)
            END_VAR
            VAR_OUTPUT
                InVelocity      :   BOOL;                       // Commanded velocity reached
                Busy            :   BOOL;                       // The method is not finished and new output values are to be expected
                Active          :   BOOL;                       // Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       // ‘Command’ is aborted by another command
                Error           :   BOOL;                       // Signals that an error has occurred within the method
                ErrorID         :   DINT;                       // Error identification           
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
                Velocity_   :   LREAL;                     
                Direction_  :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;     
                VelocityWindowPerCent     :   LREAL := LREAL#5.0;
                VelocityWindowMin         :   LREAL;
                VelocityWindowMax         :   LREAL;                                    
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1520, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1520;
                RETURN;
            END_IF;

            IF THIS.AxoMoveVelocity_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_MoveVelocity;
            END_IF;

            IF Execute AND NOT MC_MoveVelocityExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_MoveVelocityCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                Messenger.ActivateOnCondition(ULINT#1521,Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection AND Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection, eAxoMessageCategory#ProgrammingError);

                IF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection THEN
                    Velocity_ := Velocity;
                ELSIF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection THEN
                    Velocity_ := -1 * Velocity;
                ELSE
                    RETURN;
                END_IF;
    
                IF Velocity_> 0 THEN 
                    Direction_ := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;
                ELSE
                    Direction_ := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection;
                END_IF;
                         
                Messenger.ActivateOnCondition(ULINT#1522, Execute AND Velocity = 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1523, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1524, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1525, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);

                IF NOT ContinuousUpdate THEN
                    MC_MoveVelocityContinuousUpdate_SV := FALSE;
                END_IF;

                IF _State = UINT#0 THEN
                    Busy    := TRUE;            
                    Active  := TRUE;          
                    MC_MoveVelocityErrorID := WORD#16#0000;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit0 := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit1 := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit2 := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn := FALSE;
                    // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ClearError := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SwitchToCM := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SwitchTo0M := TRUE;
                    // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                    // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;                    

                    MC_MoveVelocityContinuousUpdate_SV := ContinuousUpdate;
                    _State := UINT#380;
                END_IF;
                IF _State = UINT#380 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF Velocity <> 0 AND Acceleration > 0 AND Deceleration >0 AND Jerk > 0 THEN
                        _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0        :=  TO_DINT(0.0             *   ScalingConstantRequiredPosition);
                        _AxisReference^.Outputs.CommandVelocity_S_0_0259_0_0        :=  TO_DINT(Velocity_       *   ScalingConstantRequiredVelocity     *   _AxisReference^.Data.OverrideVelocityFactor);
                        _AxisReference^.Outputs.CommandAcceleration_S_0_0260_0_0    :=  TO_DINT(Acceleration    *   ScalingConstantRequiredAcceleration *   _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0   :=  TO_DINT(Deceleration    *   ScalingConstantRequiredDeceleration *   _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0            :=  TO_DINT(Jerk            *   ScalingConstantRequiredJerk         *   _AxisReference^.Data.OverrideJerkFactor);           

                        MC_MoveVelocityVelocity_PV      :=  Velocity_;                  
                        MC_MoveVelocityAcceleration_PV  :=  Acceleration;              
                        MC_MoveVelocityDeceleration_PV  :=  Deceleration;              
                        MC_MoveVelocityJerk_PV          :=  Jerk;                      
                        MC_MoveVelocityDirection_PV     :=  Direction_;                                         
                        _State := UINT#381;
                    END_IF;
                END_IF;
                IF _State = UINT#381 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#581, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#581;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit0  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit1  := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit2  := FALSE;
                    IF  NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2 THEN
                        _State := UINT#382;
                    END_IF;
                END_IF;
                IF _State = UINT#382 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#582, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#582;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF  _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND
                        _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                       _State := UINT#383;
                    END_IF;                
                END_IF;                  
                IF _State = UINT#383 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#583, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#583;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := TRUE;
                    IF TRUE THEN //NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.CommandProcessingStatus THEN
                        _State := UINT#384;
                    END_IF;
                END_IF;
                IF _State = UINT#384 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#584, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#584;
                    END_IF; 
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF Direction_ = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection THEN
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := TRUE;
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    ELSIF Direction_ = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection THEN
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := TRUE;
                    END_IF;

                    IF  NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InStandstill THEN
                        _State := UINT#385;
                    END_IF;
                END_IF;               
                IF _State = UINT#385 THEN
                    IF TRUE THEN      
                        _State := UINT#386;
                    END_IF;    
                END_IF;
                IF Direction_ = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection  THEN
                    VelocityWindowMax := Velocity_ + (Velocity_ * VelocityWindowPerCent / REAL#100.0);
                    VelocityWindowMin := Velocity_ - (Velocity_ * VelocityWindowPerCent / REAL#100.0);
                ELSE
                    VelocityWindowMax := Velocity_ - (Velocity_ * VelocityWindowPerCent / REAL#100.0);
                    VelocityWindowMin := Velocity_ + (Velocity_ * VelocityWindowPerCent / REAL#100.0);
                END_IF;
                InVelocity := ActualVelocity >= VelocityWindowMin AND ActualVelocity <= VelocityWindowMax;                            
                IF _State = UINT#386 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#586, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#586;
                    END_IF;                     
                    IF InVelocity AND NOT MC_MoveVelocityContinuousUpdate_SV THEN
                        _State := UINT#387;
                    END_IF;    
                END_IF;
                IF _State = UINT#387 THEN
                    MC_MoveVelocityCycle := ULINT#0;
                END_IF;         
                IF _State = UINT#388 THEN
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    CommandAborted := TRUE;            
                    AxoMoveVelocity_Task.Abort();          
                END_IF;         
                IF _State = UINT#389 THEN
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    MC_MoveVelocityCycle := ULINT#0;     
                    Error := TRUE;    
                    AxoMoveVelocity_Task.ThrowWhen(TRUE);          
                END_IF;         
                
                IF _State>=UINT#380 AND _State<UINT#387 THEN
                    IF MC_MoveVelocityContinuousUpdate_SV AND (
                        MC_MoveVelocityVelocity_PV      <>  Velocity_ OR                  
                        MC_MoveVelocityAcceleration_PV  <>  Acceleration OR              
                        MC_MoveVelocityDeceleration_PV  <>  Deceleration OR              
                        MC_MoveVelocityJerk_PV          <>  Jerk OR                      
                        MC_MoveVelocityDirection_PV     <>  Direction_ ) THEN
                        IF TRUE THEN 
                            _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange := TRUE;
                            _State := UINT#380;
                        END_IF;   
                    END_IF;                       
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#388;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_MoveVelocityErrorID = WORD#0 THEN
                            MC_MoveVelocityErrorID := TO_WORD(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#389;
                    ELSIF _AxisReference^.Data.Cycle <> MC_MoveVelocityCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#388;
                    END_IF;                  
                END_IF;         
                THIS.CallTimers(TRUE,FALSE);
                THIS.AxoMoveVelocity_Task.ThrowWhen(_errorTimer.output );
                THIS.AxoMoveVelocity_Task.ThrowWhen(THIS.AxoMoveVelocity_Task.Duration >= DriveConfig.TaskTimeout AND DriveConfig.TaskTimeout > T#0s ,'AxoMoveVelocity_Task timeout.');                
                DriveStatus.Action.Id := _State; 
            ELSE
                InVelocity := FALSE;
            END_IF;
            IF THIS.AxoMoveVelocity_Task.DoneReached() AND _State>=UINT#380 AND _State<=UINT#389 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                MC_MoveVelocityErrorID := WORD#0;
                _State := UINT#0;
            END_IF;            
            IF THIS.AxoMoveVelocity_Task.RestoreTriggered() AND _State>=UINT#380 AND _State<=UINT#389 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                MC_MoveVelocityErrorID := WORD#0;
                _State := UINT#0;
                MC_MoveVelocityCycle := ULINT#0;     
            END_IF;     
            ErrorID := TO_DINT(MC_MoveVelocityErrorID);
            MC_MoveVelocityExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method continuously exerts a torque or force of the specified magnitude. This magnitude is 
        /// approached using a defined ramp (‘TorqueRamp’), and the method sets the ‘InTorque’ output if the 
        /// commanded torque level is reached. This method is applicable for force and torque. When there is no external
        /// load, force is applicable. Positive torque is in the positive direction of velocity.
        ///<summary>
        VAR INTERNAL
            MC_TorqueControlExecute_PV					: 	BOOL;				//Execute - previous value
            MC_TorqueControlErrorID					    : 	DINT;
            MC_TorqueControlCycle					    : 	ULINT;
            MC_TorqueControlContinuousUpdate_SV         :   BOOL;
            MC_TorqueControlTorque_PV                   :   LREAL;                    
            MC_TorqueControlTorqueRamp_PV               :   LREAL;                    
            MC_TorqueControlPositionLimit_PV            :   LREAL;                    
            MC_TorqueControlVelocity_PV                 :   LREAL;                    
            MC_TorqueControlAcceleration_PV             :   LREAL;                    
            MC_TorqueControlDeceleration_PV             :   LREAL;                                
            MC_TorqueControlJerk_PV                     :   LREAL;                     
            MC_TorqueControlDirection_PV                :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;        
        END_VAR
        METHOD PUBLIC OVERRIDE MC_TorqueControl
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start the motion at rising edge
                ContinuousUpdate:   BOOL;                       //  Activate ‘ContinuousUpdate’ - target parameters should be changed during movement
                Torque          :   LREAL;                      //  Value of the torque (Torque or force in technical unit [u])
                TorqueRamp      :   LREAL;                      //  The maximum time derivative of the set value of the torque or force (in technical unit per sec. [u/s]) 
                PositionLimit   :   LREAL;                      //  Position limit
                Velocity        :   LREAL;                      //  Absolute value of the maximum velocity.
                Acceleration    :   LREAL;                      //  Value of the maximum acceleration (acceleration is applicable with same sign of torque and velocity)
                Deceleration    :   LREAL;                      //  Value of the maximum deceleration (deceleration is applicable with opposite signs of torque and velocity)
                Jerk            :   LREAL;                      //  Value of the maximum jerk
                Direction       :   AXOpen.Components.Abstractions.Drives.eAxoDriveDirection;         //  Enum type (1 of 2 values: PositiveDirection, NegativeDirection or CurrentDirection). Specifies the direction of the torque. (Note: Torque input can be signed value).            
            END_VAR
            VAR_OUTPUT
                InTorque        :   BOOL;                       //  Setpoint value of torque or force equals the commandedvalue
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Active          :   BOOL;                       //  Indicates that the method has control on the axis
                CommandAborted  :   BOOL;                       //  ‘Command’ is aborted by another command
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification             
            END_VAR
            VAR 
                _AxisReference          :   REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
                Torque_                 :   LREAL;
                PositiveDirection_      :   BOOL;
                TorqueWindowPerCent     :   LREAL := LREAL#5.0;
                TorqueWindowMin         :   LREAL;
                TorqueWindowMax         :   LREAL;                
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1530, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1530;
                RETURN;
            END_IF;

            IF THIS.AxoTorqueControl_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_TorqueControl;
            END_IF;

            IF Execute AND NOT MC_TorqueControlExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_TorqueControlCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 
                Messenger.ActivateOnCondition(ULINT#1531,Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection AND Direction <> AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1532, Execute AND Velocity <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1533, Execute AND Acceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1534, Execute AND Deceleration <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1535, Execute AND Jerk <= 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1536, Execute AND Torque = 0, eAxoMessageCategory#ProgrammingError);
                Messenger.ActivateOnCondition(ULINT#1537, Execute AND TorqueRamp <= 0, eAxoMessageCategory#ProgrammingError);
                
                IF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection THEN
                    Torque_ := Torque;
                ELSIF Direction = AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#NegativeDirection THEN
                    Torque_ := -1 * Torque;
                ELSE
                    RETURN;
                END_IF; 
                PositiveDirection_ := Torque_ > 0;                        
    
                IF NOT ContinuousUpdate THEN
                    MC_TorqueControlContinuousUpdate_SV := FALSE;
                END_IF;

                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    MC_TorqueControlErrorID := DINT#0;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn := FALSE;
                    // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ClearError := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SwitchToCM := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SwitchTo0M := TRUE;
                    // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                    // _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;                    
                    MC_TorqueControlContinuousUpdate_SV := ContinuousUpdate;
                    _State := UINT#390;
                END_IF;
                IF _State = UINT#390 THEN
                    Busy := TRUE;            
                    Active := TRUE;          
                    IF Velocity > 0 AND Acceleration > 0 AND Deceleration > 0 AND Jerk > 0 AND Torque <> 0 AND TorqueRamp > 0 THEN
                        _AxisReference^.Outputs.CommandTorque_S_0_0080_0_0          :=  TO_INT(Torque_          *   ScalingConstantRequiredTorque);
                        _AxisReference^.Outputs.CommandPosition_S_0_0282_0_0        :=  TO_DINT(PositionLimit   *   ScalingConstantRequiredPosition);
                        _AxisReference^.Outputs.CommandVelocity_S_0_0259_0_0        :=  TO_DINT(Velocity        *   ScalingConstantRequiredVelocity     *   _AxisReference^.Data.OverrideVelocityFactor);
                        _AxisReference^.Outputs.CommandAcceleration_S_0_0260_0_0    :=  TO_DINT(Acceleration    *   ScalingConstantRequiredAcceleration *   _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Outputs.CommandDecceleration_S_0_0359_0_0   :=  TO_DINT(Deceleration    *   ScalingConstantRequiredDeceleration *   _AxisReference^.Data.OverrideAccelerationFactor);
                        _AxisReference^.Outputs.CommandJerk_S_0_0193_0_0            :=  TO_DINT(Jerk            *   ScalingConstantRequiredJerk         *   _AxisReference^.Data.OverrideJerkFactor);           

                        MC_TorqueControlPositionLimit_PV :=  PositionLimit;                  
                        MC_TorqueControlVelocity_PV      :=  Velocity;                  
                        MC_TorqueControlAcceleration_PV  :=  Acceleration;              
                        MC_TorqueControlDeceleration_PV  :=  Deceleration;              
                        MC_TorqueControlJerk_PV          :=  Jerk;                      
                        MC_TorqueControlDirection_PV     :=  Direction;                                         
                        MC_TorqueControlTorque_PV        :=  Torque;                      
                        MC_TorqueControlTorqueRamp_PV    :=  TorqueRamp;    
                        IF PositiveDirection_ AND THIS.ActualPosition >= MC_TorqueControlPositionLimit_PV THEN
                            _State := UINT#399;
                            Messenger.Activate(         UINT#1538, eAxoMessageCategory#ProgrammingError);
                            MC_TorqueControlErrorID :=  DINT#1538;
                        ELSIF NOT PositiveDirection_ AND THIS.ActualPosition <= MC_TorqueControlPositionLimit_PV THEN
                            _State := UINT#399;
                            Messenger.Activate(         UINT#1539, eAxoMessageCategory#ProgrammingError);
                            MC_TorqueControlErrorID :=  DINT#1539;
                        ELSE
                            _State := UINT#391;
                        END_IF;                              
                    END_IF;                    
                END_IF;
                //Writing Torque/force control: Ramp value (0x2838:01 / S-0-0822 / --)
                IF _State = UINT#391 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#591;
                    END_IF;                    
                    Busy := TRUE;            
                    Active := TRUE;          
                    _word :=  TO_WORD(TO_INT(TorqueRamp));
                    _data2[0] := _word.%B0;
                    _data2[1] := _word.%B1;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#822,
                                    length      :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data2);
                        _State := UINT#392;
                    ElSIF _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data2);
                        Messenger.Activate(             UINT#1540, eAxoMessageCategory#ProgrammingError);
                        MC_WriteRealParameterErrorID := WORD#1540;
                        _State := UINT#399;
                    END_IF;
                END_IF;
                //Writing Torque/force control: Ramp time (0x2838:02 / S-0-0823 / --)
                IF _State = UINT#392 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#592, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#592;
                    END_IF;                    
                    Busy := TRUE;            
                    Active := TRUE;          
                    _word :=  TO_WORD(TO_INT(REAL#1.0));
                    _data2[0] := _word.%B0;
                    _data2[1] := _word.%B1;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#823,
                                    length      :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data2);
                        _State := UINT#393;
                    ElSIF _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data2);
                        Messenger.Activate(             UINT#1541, eAxoMessageCategory#ProgrammingError);
                        MC_WriteRealParameterErrorID := WORD#1541;
                        _State := UINT#399;
                    END_IF;
                END_IF;
                //Writing Torque/force control: High velocity limit value (0x60C9:00 / P-0-0421.0.3 / P-0-2249)
                IF _State = UINT#393 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#593, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#593;
                    END_IF;                    
                    Busy := TRUE;            
                    Active := TRUE;          
                    _dword :=  TO_DWORD(TO_DINT(ABS(Velocity) * ScalingConstantRequiredVelocity * _AxisReference^.Data.OverrideVelocityFactor));
                    _data4[0] := _dword.%B0;
                    _data4[1] := _dword.%B1;
                    _data4[2] := _dword.%B2;
                    _data4[3] := _dword.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#6345,
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#394;
                    ElSIF _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data4);
                        Messenger.Activate(             UINT#1542, eAxoMessageCategory#ProgrammingError);
                        MC_WriteRealParameterErrorID := WORD#1542;
                        _State := UINT#399;
                    END_IF;
                END_IF;       
                //Writing Torque/force control: Low velocity limit value (0x60C8:00 / P-0-0421.0.4 / P-0-2250)
                IF _State = UINT#394 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#594, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#594;
                    END_IF;                    
                    Busy := TRUE;            
                    Active := TRUE;          
                    _dword :=  TO_DWORD(TO_DINT(-1.0 * ABS(Velocity) * ScalingConstantRequiredVelocity * _AxisReference^.Data.OverrideVelocityFactor));
                    _data4[0] := _dword.%B0;
                    _data4[1] := _dword.%B1;
                    _data4[2] := _dword.%B2;
                    _data4[3] := _dword.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#6346,
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#395;
                    ElSIF _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data4);
                        Messenger.Activate(             UINT#1543, eAxoMessageCategory#ProgrammingError);
                        MC_WriteRealParameterErrorID := WORD#1543;
                        _State := UINT#399;
                    END_IF;
                END_IF;                            
                //Executing movement
                IF _State = UINT#395 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#595, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#595;
                    END_IF;                         
                    Busy := TRUE;            
                    Active := TRUE;          
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := TRUE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit0 := TRUE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit1 := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.CommandOperationModeBit2 := FALSE;
                    IF      _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit0 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit1 AND
                        NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ActualOperatingModeBit2 THEN
                        _State := UINT#396;
                    END_IF; 
                END_IF;
                IF PositiveDirection_  THEN
                    TorqueWindowMax := Torque_ + (Torque_ * TorqueWindowPerCent / REAL#100.0);
                    TorqueWindowMin := Torque_ - (Torque_ * TorqueWindowPerCent / REAL#100.0);
                ELSE
                    TorqueWindowMax := Torque_ - (Torque_ * TorqueWindowPerCent / REAL#100.0);
                    TorqueWindowMin := Torque_ + (Torque_ * TorqueWindowPerCent / REAL#100.0);
                END_IF;
                InTorque := ActualTorque >= TorqueWindowMin AND ActualTorque <= TorqueWindowMax;            
                IF _State = UINT#396 THEN
                    IF InTorque AND NOT MC_TorqueControlContinuousUpdate_SV THEN      
                        _State := UINT#397;
                    END_IF;    
                END_IF;
                IF _State = UINT#397 THEN
                    MC_TorqueControlCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#398 THEN
                    CommandAborted := TRUE;            
                    AxoTorqueControl_Task.Abort();          
                END_IF;         
                IF _State = UINT#399 THEN
                    MC_TorqueControlCycle := ULINT#0;     
                    Error := TRUE;    
                    AxoTorqueControl_Task.ThrowWhen(TRUE);          
                END_IF;         

                IF (_State>=UINT#395 AND _State <= UINT#397) THEN
                    IF  (    PositiveDirection_ AND ActualPosition > PositionLimit) OR
                        (NOT PositiveDirection_ AND ActualPosition < PositionLimit) THEN
                        Messenger.Activate(         UINT#1542, eAxoMessageCategory#ProgrammingError);
                        MC_TorqueControlErrorID :=  DINT#1542;
                        _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := FALSE;
                        _State := UINT#399;
                    END_IF;
                END_IF;
                
                IF _State>=UINT#390 AND _State<UINT#397 THEN
                    IF MC_TorqueControlContinuousUpdate_SV AND (
                        MC_TorqueControlTorque_PV        <>  Torque OR                  
                        MC_TorqueControlTorqueRamp_PV    <>  TorqueRamp OR                  
                        MC_TorqueControlPositionLimit_PV <>  PositionLimit OR                  
                        MC_TorqueControlVelocity_PV      <>  Velocity OR                  
                        MC_TorqueControlAcceleration_PV  <>  Acceleration OR              
                        MC_TorqueControlDeceleration_PV  <>  Deceleration OR              
                        MC_TorqueControlJerk_PV          <>  Jerk OR                      
                        MC_TorqueControlDirection_PV     <>  Direction ) THEN
                        IF TRUE THEN    
                            _State := UINT#390;
                        END_IF;   
                    END_IF;   
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#398;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_TorqueControlErrorID = DINT#0 THEN
                            MC_TorqueControlErrorID := TO_DINT(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#399;
                    ELSIF _AxisReference^.Data.Cycle <> MC_TorqueControlCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#398;
                    END_IF;                  
                END_IF;   
            ELSE
                InTorque := FALSE;
            END_IF;

            IF THIS.AxoTorqueControl_Task.DoneReached() AND _State>=UINT#390 AND _State<=UINT#399 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_TorqueControlErrorID := DINT#0;
                // MC_TorqueControlCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;

            IF THIS.AxoTorqueControl_Task.RestoreTriggered() AND _State>=UINT#390 AND _State<=UINT#399 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_TorqueControlErrorID := DINT#0;
                MC_TorqueControlCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;     

            ErrorID := MC_TorqueControlErrorID;
            MC_TorqueControlExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method shifts the coordinate system of an axis by manipulating both the set-point position as well as the
        /// actual position of an axis with the same value without any movement caused. (Re-calibration with same following error). 
        /// This can be used for instance for a reference situation. This method can also be used during motion without changing 
        /// the commanded position, which is now positioned in the shifted coordinate system.
        ///<summary>
        VAR INTERNAL
            MC_SetPositionExecute_PV				: 	BOOL;				//Execute - previous value
            MC_SetPositionErrorID					: 	DINT;
            MC_SetPositionCycle					    : 	ULINT;						
            MC_SetPositionActualPosition            : 	LINT;						
            MC_SetPositionPowerStatusPV             : 	BOOL;						
        END_VAR  
        METHOD PUBLIC OVERRIDE MC_SetPosition
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Start setting position in axis
                Position        :   LREAL;                       //  Position unit [u] (Means ‘Distance’ if ‘Relative’= TRUE)
                Relative        :   BOOL;                       //  ‘Relative’ distance if True, ‘Absolute’ position if False (= Default)
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Position’ has new value
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification             
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1550, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1550;
                RETURN;
            END_IF;

            IF THIS.AxoSetPosition_Task.StartTriggered() THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_SetPosition;
            END_IF;

            IF Execute AND NOT MC_SetPositionExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_SetPositionCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_SetPositionErrorID := DINT#0;
                    DriveStatus.Error.Id :=  UINT#0;                    
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.IPOSYNC := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := FALSE;      
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ClearError := FALSE;
                    MC_SetPositionPowerStatusPV := _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 AND _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0;
                    _State := UINT#400;
                END_IF;
                // Power off
                IF _State = UINT#400 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#600, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#600;
                    END_IF;
                    Busy := TRUE;            
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveHalt := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable := FALSE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn := FALSE;
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 THEN
                        _State := UINT#401;
                        RETURN;
                    END_IF;
                END_IF;                    
                // Reseting InReference flag 
                IF _State = UINT#401 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#601, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#601;
                    END_IF;
                    Busy := TRUE;            
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := TRUE;
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference THEN
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                        _State := UINT#402;
                        RETURN;
                    END_IF;
                END_IF;                
                //Writing Homing configuration ENC_1: Home offset (0x607C:00 / S-0-0052 / --)
                IF _State = UINT#402 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#602, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#602;
                    END_IF;                    
                    Busy := TRUE;            
                    _dword :=  TO_DWORD(TO_DINT(Position * ScalingConstantRequiredPosition));
                    _data4[0] := _dword.%B0;
                    _data4[1] := _dword.%B1;
                    _data4[2] := _dword.%B2;
                    _data4[3] := _dword.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#52,
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#403;
                    ElSIF _WriteRecord.error THEN 
                        Messenger.Activate( UINT#1551, eAxoMessageCategory#ProgrammingError);
                        MC_HomeErrorID :=   DINT#1551;
                        _WriteRecord(request := FALSE, record := _data4);
                        _State := UINT#609;
                    END_IF;
                END_IF;
                IF _State = UINT#403 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#603, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#603;
                    END_IF; 
                    Busy := TRUE;            
                    _WriteRecord(request := FALSE, record := _data4);
                    IF NOT _WriteRecord.busy AND NOT _WriteRecord.done AND NOT _WriteRecord.error  THEN
                        _State := UINT#404;
                    END_IF;
                END_IF;
                IF _State = UINT#404 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#604, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#604;
                    END_IF; 
                    Busy := TRUE;            
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := TRUE;
                    IF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.InReference THEN
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;
                        IF MC_SetPositionPowerStatusPV THEN
                            _State := UINT#405;
                        ELSE
                            _State := UINT#407;
                        END_IF;
                    END_IF;
                END_IF;    
                IF _State = UINT#405 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#605, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#605;
                    END_IF; 
                    Busy := TRUE;            
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable := TRUE;
                    _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn := TRUE;
                    IF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;
                        _State := UINT#407;
                    END_IF;
                END_IF;   
                IF _State = UINT#407 THEN
                    Done := TRUE;            
                    MC_SetPositionCycle := ULINT#0;     
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                END_IF;    
                IF _State = UINT#408 THEN
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    MC_SetPositionCycle := ULINT#0;     
                    AxoSetPosition_Task.Abort();    
                END_IF;         
                IF _State = UINT#409 THEN
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    MC_SetPositionCycle := ULINT#0;     
                    AxoSetPosition_Task.ThrowWhen(TRUE);    
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#400 AND _State<UINT#407 THEN
                    IF (*NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 OR*) NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                        _State := UINT#408;
                    ELSIF _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_SetPositionErrorID = DINT#0 THEN
                            MC_SetPositionErrorID := TO_DINT(_AxisReference^.Inputs.DiagnosticMessage_S_0_0390_0_0);
                        END_IF;
                        _State := UINT#409;
                    ELSIF _AxisReference^.Data.Cycle <> MC_SetPositionCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#408;
                    END_IF;                  
                END_IF;  
                THIS.CallTimers(TRUE,FALSE);
                THIS.AxoSetPosition_Task.ThrowWhen(_errorTimer.output );
                THIS.AxoSetPosition_Task.ThrowWhen(THIS.AxoHome_Task.Duration >= DriveConfig.TaskTimeout AND DriveConfig.TaskTimeout > T#0s ,'AxoSetPosition_Task timeout.');                
                DriveStatus.Action.Id := _State;    
            END_IF;

            IF THIS.AxoSetPosition_Task.DoneReached() AND _State>=UINT#400 AND _State<=UINT#409 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_SetPositionErrorID := DINT#0;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                _State := UINT#0;
            END_IF;
            IF THIS.AxoSetPosition_Task.RestoreTriggered() AND _State>=UINT#400 AND _State<=UINT#409 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_SetPositionErrorID := DINT#0;
                MC_SetPositionCycle := ULINT#0;     
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.SetAbsPositionFunction := FALSE;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.CancelReferencePoint := FALSE;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
            _State := UINT#0;
            END_IF;     

            ErrorID := MC_SetPositionErrorID;
            MC_SetPositionExecute_PV := Execute;
         END_METHOD

        ///<summary>
        /// This method sets the values of override for the whole axis, and all functions that are working on that axis. The override
        /// parameters contribute as a factor to the calculation of the commanded velocity, acceleration and jerk of the motion.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_SetOverride
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  If SET, it writes the value of the override factor continuously. If RESET it should keep the last value.
                VelocityFactor  :   LREAL;                      //  New override factor for the velocity
                AccelerationFactor:   LREAL;                    //  New override factor for the acceleration/deceleration
                JerkFactor      :   LREAL;                      //  New override factor for the jer            
            END_VAR
            VAR_OUTPUT
                Enabled         :   BOOL;                       //  Signals that the override factor(s) is (are) set successfully
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification             
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;
            
            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1570, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1570;
                RETURN;
            END_IF;

            Messenger.ActivateOnCondition(ULINT#1571, Enable AND  (VelocityFactor <= 0.0 OR  VelocityFactor >= 2.0), eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#1572, Enable AND  (AccelerationFactor <= 0.0 OR  AccelerationFactor > 1.0), eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#1573, Enable AND  (JerkFactor <= 0.0 OR JerkFactor > 1.0), eAxoMessageCategory#ProgrammingError);

            IF Enable THEN
                Busy := TRUE;
                IF VelocityFactor <= 0.0 OR  VelocityFactor >= 2.0 OR AccelerationFactor <= 0.0 OR  AccelerationFactor > 1.0 OR JerkFactor <= 0.0 OR  JerkFactor > 1.0 THEN
                    Error := TRUE;
                ELSE             
                    _AxisReference^.Data.OverrideVelocityFactor := VelocityFactor;  
                    _AxisReference^.Data.OverrideAccelerationFactor := AccelerationFactor;
                    _AxisReference^.Data.OverrideJerkFactor := JerkFactor;    
                    Enabled	:= TRUE;
                END_IF;
            ELSE  
                _AxisReference^.Data.OverrideVelocityFactor := 1.0;  
                _AxisReference^.Data.OverrideAccelerationFactor := 1.0;
                _AxisReference^.Data.OverrideJerkFactor := 1.0;    
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter. The returned Value has to be converted to Real
        /// if necessary. If not possible, the vendor has to supply a vendor specific method to read the parameter.
        ///<summary>
        VAR INTERNAL 
            MC_ReadParameterEnable_PV       : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadParameterErrorID         : 	DINT;
            MC_ReadParameterCycle			: 	ULINT;
            MC_ReadParameterValue			: 	LINT;
            MC_ReadParameterValid			: 	BOOL;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                Value           :   LINT;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1580, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1580;
                RETURN;
            END_IF;
            
            IF Enable AND NOT MC_ReadParameterEnable_PV AND _State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadParameter;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadParameterErrorID := DINT#0;         
                    _State := UINT#410;
                END_IF;
                IF _State = UINT#410 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#610, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#610;
                    END_IF;
                    Busy := TRUE;            
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  ParameterNumber,
                                    maxLength   :=  UINT#8,
                                    record      :=  _data8);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _lword.%B0   :=  _data8[0];
                        _lword.%B1   :=  _data8[1];
                        _lword.%B2   :=  _data8[2];
                        _lword.%B3   :=  _data8[3];
                        _lword.%B4   :=  _data8[4];
                        _lword.%B5   :=  _data8[5];
                        _lword.%B6   :=  _data8[6];
                        _lword.%B7   :=  _data8[7];
                        MC_ReadParameterValid := TRUE;
                        MC_ReadParameterValue :=TO_LINT(_lword);                        
                        _State := UINT#411;
                    END_IF;
                    IF _ReadRecord.error THEN 
                        _ReadRecord(request := FALSE, record := _data8);
                        Messenger.Activate(         UINT#1581, eAxoMessageCategory#ProgrammingError);
                        MC_ReadParameterErrorID :=  DINT#1581;
                        _State := UINT#419;
                    END_IF;                    
                END_IF;
                IF _State = UINT#411 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#611, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#611;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(request := FALSE, record := _data8);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#410;
                    END_IF;
                END_IF;
                IF _State = UINT#419 THEN
                    Error := TRUE;    
                END_IF;         
                IF _State>=UINT#410 AND _State<UINT#417 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#419;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadParameterEnable_PV AND _State>=UINT#410 AND _State<=UINT#419 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadParameterErrorID := DINT#0;
                MC_ReadParameterCycle := ULINT#0;  
                MC_ReadParameterValid := FALSE;
                MC_ReadParameterValue := LINT#0;   
                _ReadRecord(request := FALSE, record := _data8);
                _State := UINT#0;
            END_IF;     

            ErrorID := MC_ReadParameterErrorID;
            Valid := MC_ReadParameterValid;
            Value := MC_ReadParameterValue;
            MC_ReadParameterEnable_PV := Enable;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype REAL.
        ///<summary>
        VAR INTERNAL
            MC_ReadRealParameterEnable_PV       : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadRealParameterErrorID         : 	DINT;
            MC_ReadRealParameterCycle			: 	ULINT;
            MC_ReadRealParameterValue			: 	REAL;
            MC_ReadRealParameterValid			: 	BOOL;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadRealParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                Value           :   REAL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1590, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1590;
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadRealParameterEnable_PV AND _State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadRealParameter;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadRealParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadRealParameterErrorID := DINT#0;
                    _State := UINT#420;
                END_IF;
                IF _State = UINT#420 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#620, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#620;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  ParameterNumber,
                                    maxLength   :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _dword.%B0   :=  _data4[0];
                        _dword.%B1   :=  _data4[1];
                        _dword.%B2   :=  _data4[2];
                        _dword.%B3   :=  _data4[3];
                        MC_ReadRealParameterValid := TRUE;
                        MC_ReadRealParameterValue :=TO_REAL(TO_DINT(_dword));                        
                        _State := UINT#621;
                    END_IF;
                    IF _ReadRecord.error THEN 
                        _ReadRecord(request := FALSE, record := _data4);
                        Messenger.Activate(             UINT#1591, eAxoMessageCategory#ProgrammingError);
                        MC_ReadRealParameterErrorID :=  DINT#1591;
                        _State := UINT#629;
                    END_IF;
                END_IF;
                IF _State = UINT#421 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#621, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#621;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(request := FALSE, record := _data4);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#420;
                    END_IF;
                END_IF;               
                IF _State = UINT#429 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#420 AND _State<UINT#427 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadRealParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#429;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadRealParameterEnable_PV AND _State>=UINT#420 AND _State<=UINT#429 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadRealParameterErrorID := DINT#0;
                MC_ReadRealParameterCycle := ULINT#0;  
                MC_ReadRealParameterValid := FALSE;
                MC_ReadRealParameterValue := REAL#0.0;   
                _State := UINT#0;
            END_IF;     

            ErrorID := MC_ReadRealParameterErrorID;
            Valid := MC_ReadRealParameterValid;
            Value := MC_ReadRealParameterValue;
            MC_ReadRealParameterEnable_PV := Enable;
        END_METHOD

        ///<summary>
        /// This method returns the value of a vendor specific parameter with datatype BOOL.
        ///<summary>
        VAR INTERNAL 
            MC_ReadBoolParameterEnable_PV       : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadBoolParameterErrorID         : 	WORD;
            MC_ReadBoolParameterCycle			: 	ULINT;
            MC_ReadBoolParameterValue			: 	BOOL;
            MC_ReadBoolParameterValid			: 	BOOL;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                ParameterNumber :   DINT;                       //  Number of the parameter. One can also use symbolic parameter names which are declared as VAR CONST.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                Value           :   BOOL;                       //  Value of the specified parameter in the datatype, as specified by the vendor
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            RETURN;

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1600, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1600;
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadBoolParameterEnable_PV AND _State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadBoolParameter;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadBoolParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadBoolParameterErrorID := WORD#16#0000;
                    _State := UINT#430;
                END_IF;
                IF _State = UINT#430 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#630, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#630;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  ParameterNumber,
                                    maxLength   :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        MC_ReadBoolParameterValid := TRUE;
                        MC_ReadBoolParameterValue := _data2[0].%X0;                        
                        _State := UINT#431;
                    END_IF;
                    IF _ReadRecord.error THEN 
                        _ReadRecord(request := FALSE, record := _data2);
                        Messenger.Activate(             UINT#1601, eAxoMessageCategory#ProgrammingError);
                        MC_ReadBoolParameterErrorID :=  WORD#1601;
                        _State := UINT#439;
                    END_IF;
                END_IF;
                IF _State = UINT#431 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#631, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#631;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(request := FALSE, record := _data2);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#430;
                    END_IF;
                END_IF;               
                IF _State = UINT#439 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#430 AND _State<UINT#437 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadBoolParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#439;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadBoolParameterEnable_PV AND _State>=UINT#430 AND _State<=UINT#439 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadBoolParameterErrorID := WORD#0;
                MC_ReadBoolParameterCycle := ULINT#0;  
                MC_ReadBoolParameterValid := FALSE;
                MC_ReadBoolParameterValue := FALSE;   
                _State := UINT#0;
            END_IF;     

            ErrorID := TO_DINT(MC_ReadBoolParameterErrorID);
            Valid := MC_ReadBoolParameterValid;
            Value := MC_ReadBoolParameterValue;
            MC_ReadBoolParameterEnable_PV := Enable;

        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter.
        ///<summary>
        VAR INTERNAL
            MC_WriteParameterExecute_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_WriteParameterErrorID        : 	WORD;
            MC_WriteParameterCycle			: 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   LINT;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1610, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1610;
                RETURN;
            END_IF;

            IF THIS.AxoWriteParameter_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_WriteParameter;
            END_IF;

            IF Execute AND NOT MC_WriteParameterExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_WriteParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                IF _State = UINT#0 THEN
                    Busy := TRUE;           
                    THIS.CallTimers(FALSE);
                    DriveStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    _State := UINT#440;
                END_IF;
                IF _State = UINT#440 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#640, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#640;
                    END_IF;                    
                    Busy := TRUE;            
                    _lword :=  TO_LWORD(Value);
                    _data8[0] := _lword.%B0;
                    _data8[1] := _lword.%B1;
                    _data8[2] := _lword.%B2;
                    _data8[3] := _lword.%B3;
                    _data8[4] := _lword.%B4;
                    _data8[5] := _lword.%B5;
                    _data8[6] := _lword.%B6;
                    _data8[7] := _lword.%B7;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  ParameterNumber,
                                    length      :=  UINT#8,
                                    record      :=  _data8);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#441;
                    ElSIF _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data8);
                        Messenger.Activate(         UINT#1611, eAxoMessageCategory#ProgrammingError);
                        MC_WriteParameterErrorID := WORD#1611;
                        _State := UINT#449;
                    END_IF;
                END_IF;
                IF _State = UINT#441 THEN
                    _WriteRecord(request := FALSE, record := _data8);
                    IF NOT _WriteRecord.busy AND NOT _WriteRecord.done AND NOT _WriteRecord.error  THEN
                        _State := UINT#447;
                    END_IF;
                END_IF;
                IF _State = UINT#447 THEN
                    Done := TRUE;
                    MC_WriteParameterCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#449 THEN
                    MC_WriteParameterCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#440 AND _State<UINT#447 THEN
                    IF _AxisReference^.Data.Cycle <> MC_WriteParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#449;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF THIS.AxoWriteParameter_Task.DoneReached() AND _State>=UINT#440 AND _State<=UINT#449 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_WriteParameterErrorID := WORD#0;
                // MC_WriteParameterCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;

            IF THIS.AxoWriteParameter_Task.RestoreTriggered() AND _State>=UINT#440 AND _State<=UINT#449 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_WriteParameterErrorID := WORD#0;
                MC_WriteParameterCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;     

            ErrorID := TO_DINT(MC_WriteParameterErrorID);
            MC_WriteParameterExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type Real.
        ///<summary>
        VAR INTERNAL
            MC_WriteRealParameterExecute_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_WriteRealParameterErrorID        : 	WORD;
            MC_WriteRealParameterCycle			: 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteRealParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   REAL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1620, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1620;
                RETURN;
            END_IF;

            IF THIS.AxoWriteRealParameter_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_WriteRealParameter;
            END_IF;

            IF Execute AND NOT MC_WriteRealParameterExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_WriteRealParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    _State := UINT#450;
                END_IF;
                IF _State = UINT#450 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#650, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#650;
                    END_IF;                    
                    Busy := TRUE;            
                    _dword :=  TO_DWORD(TO_DINT(Value));
                    _data4[0] := _dword.%B0;
                    _data4[1] := _dword.%B1;
                    _data4[2] := _dword.%B2;
                    _data4[3] := _dword.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  ParameterNumber,
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#451;
                    ElSIF _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data4);
                        Messenger.Activate(             UINT#1621, eAxoMessageCategory#ProgrammingError);
                        MC_WriteRealParameterErrorID := WORD#1621;
                        _State := UINT#459;
                    END_IF;
                END_IF;
                IF _State = UINT#451 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#651, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#651;
                    END_IF;                    
                    Busy := TRUE;            
                    _WriteRecord(request := FALSE, record := _data4);
                    IF NOT _WriteRecord.busy AND NOT _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#457;
                    END_IF;
                END_IF;               
                IF _State = UINT#457 THEN
                    Done := TRUE;
                    MC_WriteRealParameterCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#459 THEN
                    MC_WriteRealParameterCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#450 AND _State<UINT#457 THEN
                    IF _AxisReference^.Data.Cycle <> MC_WriteRealParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#459;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF THIS.AxoWriteRealParameter_Task.DoneReached() AND _State>=UINT#450 AND _State<=UINT#459 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_WriteRealParameterErrorID := WORD#0;
                // MC_WriteRealParameterCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;

            IF THIS.AxoWriteRealParameter_Task.RestoreTriggered() AND _State>=UINT#450 AND _State<=UINT#459 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_WriteRealParameterErrorID := WORD#0;
                MC_WriteRealParameterCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;     

            ErrorID := TO_DINT(MC_WriteRealParameterErrorID);
            MC_WriteRealParameterExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method modifies the value of a vendor specific parameter of type BOOL.
        ///<summary>
        VAR INTERNAL
            MC_WriteBoolParameterExecute_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_WriteBoolParameterErrorID        : 	WORD;
            MC_WriteBoolParameterCycle			: 	ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteBoolParameter
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the parameter at rising edge
                ParameterNumber :   DINT;                       //  Number of the parameter (correspondence between number andparameter is specified in the table above)
                Value           :   BOOL;                       //  New value of the specified parameter
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Parameter successfully written
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1630, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1630;
                RETURN;
            END_IF;

            IF THIS.AxoWriteBoolParameter_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_WriteBoolParameter;
            END_IF;

            IF Execute AND NOT MC_WriteBoolParameterExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_WriteBoolParameterCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    _State := UINT#460;
                END_IF;
                IF _State = UINT#460 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#660, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#660;
                    END_IF;                    
                    Busy := TRUE;            
                    _dword :=  TO_DWORD(TO_DINT(Value));
                    _data2[0].%X0 := Value;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  ParameterNumber,
                                    length      :=  UINT#2,
                                    record      :=  _data2);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#461;
                    ElSIF _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data2);
                        Messenger.Activate(             UINT#1631, eAxoMessageCategory#ProgrammingError);
                        MC_WriteBoolParameterErrorID := WORD#1631;
                        _State := UINT#469;
                    END_IF;
                END_IF;
                IF _State = UINT#461 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#661, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#661;
                    END_IF;                    
                    Busy := TRUE;            
                    _WriteRecord(request := FALSE, record := _data2);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#467;
                    END_IF;
                END_IF;               
                IF _State = UINT#467 THEN
                    Done := TRUE;
                    MC_WriteBoolParameterCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#469 THEN
                    MC_WriteBoolParameterCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#460 AND _State<UINT#467 THEN
                    IF _AxisReference^.Data.Cycle <> MC_WriteBoolParameterCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#469;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF THIS.AxoWriteBoolParameter_Task.DoneReached() AND _State>=UINT#460 AND _State<=UINT#469 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_WriteBoolParameterErrorID := WORD#0;
                // MC_WriteBoolParameterCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;

            IF THIS.AxoWriteBoolParameter_Task.RestoreTriggered() AND _State>=UINT#460 AND _State<=UINT#469 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_WriteBoolParameterErrorID := WORD#0;
                MC_WriteBoolParameterCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;     

            ErrorID := TO_DINT(MC_WriteBoolParameterErrorID);
            MC_WriteBoolParameterExecute_PV := Execute;
        END_METHOD

        ///<summary>
        /// This method gives access to the value of the input, referenced by the datatype MC_INPUT_REF. 
        /// It provides the value of the referenced input (BOOL).
        ///<summary>
        VAR INTERNAL
            MC_ReadDigitalInputEnable_PV        : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadDigitalInputErrorID          : 	WORD;
            MC_ReadDigitalInputCycle			: 	ULINT;
            MC_ReadDigitalInputValue			: 	BOOL;
            MC_ReadDigitalInputValid			: 	BOOL;					
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadDigitalInput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the selected input signal continuously while enabled
                InputNumber     :   INT;                        //  Selects the input. Can be part of MC_INPUT_REF, if only one single input is referenced.                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                Value           :   BOOL;                       //  The value of the selected input signal
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1640, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1640;
                RETURN;
            END_IF;

            IF(InputNumber < 0 OR InputNumber >256) THEN   //  TODO check the min max input number
                Messenger.Activate(     UINT#1641, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1641;
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadDigitalInputEnable_PV AND _State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadDigitalInput;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadDigitalInputCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadDigitalInputErrorID := WORD#16#0000;         
                    _State := UINT#470;
                END_IF;
                IF _State = UINT#470 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#670, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#670;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#4403, //P-0-0307.0.0  16#1000 + 307 = 4096+307=4403
                                    maxLength   :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _dword.%B0   :=  _data4[0];
                        _dword.%B1   :=  _data4[1];
                        _dword.%B2   :=  _data4[2];
                        _dword.%B3   :=  _data4[3];
                        MC_ReadDigitalInputValid := TRUE;
                        MC_ReadDigitalInputValue := System.BitAccess.GetBit(_dword, TO_USINT(InputNumber));
                        _State := UINT#471;
                    END_IF;
                    IF _ReadRecord.error THEN 
                        _ReadRecord(request := FALSE, record := _data4);
                        Messenger.Activate(             UINT#1642, eAxoMessageCategory#ProgrammingError);
                        MC_ReadDigitalInputErrorID :=   WORD#1642;
                        _State := UINT#479;
                    END_IF;
                END_IF;
                IF _State = UINT#471 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#671, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#671;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(request := FALSE, record := _data4);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#470;
                    END_IF;
                END_IF;               
                IF _State = UINT#479 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#470 AND _State<UINT#477 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadDigitalInputCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#479;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadDigitalInputEnable_PV AND _State>=UINT#470 AND _State<=UINT#479 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadDigitalInputErrorID := WORD#0;
                MC_ReadDigitalInputCycle := ULINT#0;  
                MC_ReadDigitalInputValid := FALSE;
                MC_ReadDigitalInputValue := FALSE;   
                _State := UINT#0;
            END_IF;     

            ErrorID := TO_DINT(MC_ReadDigitalInputErrorID);
            Valid := MC_ReadDigitalInputValid;
            Value := MC_ReadDigitalInputValue;
            MC_ReadDigitalInputEnable_PV := Enable;	          
        END_METHOD

        ///<summary>
        /// This method provides access to the value of a digital output, referenced by the datatype MC_OUTPUT_REF. 
        /// It provides the value of the referenced output (BOOL).
        ///<summary>
        VAR INTERNAL
            MC_ReadDigitalOutputEnable_PV        : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadDigitalOutputErrorID          : 	WORD;
            MC_ReadDigitalOutputCycle			: 	ULINT;
            MC_ReadDigitalOutputValue			: 	BOOL;
            MC_ReadDigitalOutputValid			: 	BOOL;					
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the selected output signal continuously while enabled
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                Value           :   BOOL;                       //  The value of the selected output signal
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1650, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1650;
                RETURN;
            END_IF;

            IF(OutputNumber < 0 OR OutputNumber >256) THEN   //  TODO check the min max input number
                Messenger.Activate(     UINT#1651, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1651;
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadDigitalOutputEnable_PV AND _State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadDigitalOutput;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadDigitalOutputCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Enable THEN 	
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    MC_ReadDigitalOutputErrorID := WORD#16#0000;         
                    _State := UINT#480;
                END_IF;
                IF _State = UINT#480 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#680, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#680;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#4409, //P-0-0313.0.0  16#1000 + 313 = 4096+313=4409
                                    maxLength   :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        _dword.%B0   :=  _data4[0];
                        _dword.%B1   :=  _data4[1];
                        _dword.%B2   :=  _data4[2];
                        _dword.%B3   :=  _data4[3];
                        MC_ReadDigitalOutputValid := TRUE;
                        MC_ReadDigitalOutputValue := System.BitAccess.GetBit(_dword, TO_USINT(OutputNumber));
                        _State := UINT#481;
                    END_IF;
                    IF _ReadRecord.error THEN 
                        _ReadRecord(request := FALSE, record := _data4);
                        Messenger.Activate(             UINT#1652, eAxoMessageCategory#ProgrammingError);
                        MC_ReadDigitalOutputErrorID :=  WORD#1652;
                        _State := UINT#489;
                    END_IF;
                END_IF;
                IF _State = UINT#481 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#681, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#681;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(request := FALSE, record := _data4);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#480;
                    END_IF;
                END_IF;               
                IF _State = UINT#489 THEN
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#480 AND _State<UINT#487 THEN
                    IF _AxisReference^.Data.Cycle <> MC_ReadDigitalOutputCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#489;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF NOT Enable AND MC_ReadDigitalOutputEnable_PV AND _State>=UINT#480 AND _State<=UINT#489 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadDigitalOutputErrorID := WORD#0;
                MC_ReadDigitalOutputCycle := ULINT#0;  
                MC_ReadDigitalOutputValid := FALSE;
                MC_ReadDigitalOutputValue := FALSE;   
                _State := UINT#0;
            END_IF;     

            ErrorID := TO_DINT(MC_ReadDigitalOutputErrorID);
            Valid := MC_ReadDigitalOutputValid;
            Value := MC_ReadDigitalOutputValue;
            MC_ReadDigitalOutputEnable_PV := Enable;	          
        END_METHOD

        ///<summary>
        /// This method writes a value to the output referenced by the argument ‘Output’ once (with rising edge of Execute)
        ///<summary>
        VAR INTERNAL
            MC_WriteDigitalOutputExecute_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_WriteDigitalOutputErrorID        : 	WORD;
            MC_WriteDigitalOutputCycle			: 	ULINT;
            MC_WriteDigitalOutputParameterPV    : 	DWORD;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_WriteDigitalOutput
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Write the value of the selected output
                OutputNumber    :   INT;                        //  Selects the output. Can be part of MC_OUTPUT_REF, if only one single output is referenced.                
                Value           :   BOOL;                       //  The value of the selected output signal
                ExecutionMode   :   AXOpen.Components.Abstractions.Drives.eAxoExecutionMode;          //  Defines the chronological sequence of the method.              
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  Writing of the output signal value is done
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected.
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference  :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
                Valid_          :   BOOL;
                Error_          :   BOOL;
                ErrorID_        :   WORD; 
            END_VAR

            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1660, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1660;
                RETURN;
            END_IF;

            IF(OutputNumber < 0 OR OutputNumber >256) THEN   //  TODO check the min max input number
                Messenger.Activate(     UINT#1661, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1661;
                RETURN;
            END_IF;

            IF THIS.AxoWriteDigitalOutput_Task.StartTriggered()  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_WriteDigitalOutput;
            END_IF;

            IF Execute AND NOT MC_WriteDigitalOutputExecute_PV AND _State = UINT#0 THEN
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_WriteDigitalOutputCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            IF Execute THEN 	
                IF _State = UINT#0 THEN
                    Busy := TRUE;            
                    _State := UINT#490;
                END_IF;
                IF _State = UINT#490 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#690, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#690;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(    request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#4409, //P-0-0313.0.0  16#1000 + 313 = 4096+313=4409
                                    maxLength   :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _ReadRecord.busy AND _ReadRecord.valid AND NOT _ReadRecord.error THEN 
                        MC_WriteDigitalOutputParameterPV.%B0   :=  _data4[0];
                        MC_WriteDigitalOutputParameterPV.%B1   :=  _data4[1];
                        MC_WriteDigitalOutputParameterPV.%B2   :=  _data4[2];
                        MC_WriteDigitalOutputParameterPV.%B3   :=  _data4[3];
                        _State := UINT#491;
                    END_IF;
                    IF  _ReadRecord.error THEN 
                        Messenger.Activate(             UINT#1662, eAxoMessageCategory#ProgrammingError);
                        MC_WriteDigitalOutputErrorID := WORD#1662;
                        _State := UINT#499;
                    END_IF;
                END_IF;
                IF _State = UINT#491 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#691, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#691;
                    END_IF;                    
                    Busy := TRUE;            
                    _ReadRecord(request := FALSE, record := _data8);
                    IF NOT _ReadRecord.busy AND NOT _ReadRecord.valid AND NOT _ReadRecord.error  THEN
                        _State := UINT#492;
                    END_IF;
                END_IF; 
                IF _State = UINT#492 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#692, eAxoMessageCategory#Warning);
                        DriveStatus.Error.Id := UINT#692;
                    END_IF;                    
                    Busy := TRUE;   
                    MC_WriteDigitalOutputParameterPV := System.BitAccess.SetBit(value := MC_WriteDigitalOutputParameterPV,bitValue := Value,index := TO_USINT(OutputNumber));         
                    _State := UINT#493;
                END_IF;               
                IF _State = UINT#493 THEN
                    Busy := TRUE;            
                    _data4[0] := MC_WriteDigitalOutputParameterPV.%B0;
                    _data4[1] := MC_WriteDigitalOutputParameterPV.%B1;
                    _data4[2] := MC_WriteDigitalOutputParameterPV.%B2;
                    _data4[3] := MC_WriteDigitalOutputParameterPV.%B3;
                    _WriteRecord(   request     :=  TRUE,
                                    id          :=  TO_WORD(AxisRefExt.HWIDs.HW_S_0_0134_0_0),
                                    index       :=  DINT#4409, //P-0-0313.0.0  16#1000 + 313 = 4096+313=4409
                                    length      :=  UINT#4,
                                    record      :=  _data4);
                    IF NOT _WriteRecord.busy AND _WriteRecord.done AND NOT _WriteRecord.error THEN 
                        _State := UINT#494;
                    ElSIF _WriteRecord.error THEN 
                        _WriteRecord(request := FALSE, record := _data4);
                        Messenger.Activate(         UINT#1663, eAxoMessageCategory#ProgrammingError);
                        MC_WriteParameterErrorID := WORD#1663;
                        _State := UINT#499;
                    END_IF;
                END_IF;
                IF _State = UINT#494 THEN
                    _WriteRecord(request := FALSE, record := _data4);
                    IF NOT _WriteRecord.busy AND NOT _WriteRecord.done AND NOT _WriteRecord.error  THEN
                        _State := UINT#497;
                    END_IF;
                END_IF;                
                
                IF _State = UINT#497 THEN
                    Done := TRUE;
                    MC_WriteDigitalOutputCycle := ULINT#0;     
                END_IF;         
                IF _State = UINT#499 THEN
                    MC_WriteDigitalOutputCycle := ULINT#0;     
                    Error := TRUE;    
                END_IF;         
                
                IF _State>=UINT#490 AND _State<UINT#497 THEN
                    IF _AxisReference^.Data.Cycle <> MC_WriteDigitalOutputCycle THEN
                        _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
                        _State := UINT#499;
                    END_IF;                  
                END_IF;   
            END_IF;

            IF THIS.AxoWriteDigitalOutput_Task.DoneReached() AND _State>=UINT#490 AND _State<=UINT#499 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_Done;
                MC_WriteDigitalOutputErrorID := WORD#0;
                // MC_WriteDigitalOutputCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;

            IF THIS.AxoWriteDigitalOutput_Task.RestoreTriggered() AND _State>=UINT#490 AND _State<=UINT#499 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_WriteDigitalOutputErrorID := WORD#0;
                MC_WriteDigitalOutputCycle := ULINT#0;     
                _State := UINT#0;
            END_IF;     

            ErrorID := TO_DINT(MC_WriteDigitalOutputErrorID);
            MC_WriteDigitalOutputExecute_PV := Execute;

        END_METHOD

        ///<summary>
        /// This method returns the actual position.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualPosition 
             VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                Position        :   LREAL;                       //  New absolute position (in axis’ unit [u])
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1670, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1670;
                RETURN;
            END_IF;

            IF Enable THEN
                Valid := TRUE;
                Position := THIS.ActualPosition;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual velocity as long as ‘Enable’ is set. ‘Valid’ is true when the 
        /// dataoutput ‘Velocity’ is valid. If ‘Enable’ is Reset, the data loses its validity, and all outputs are reset,
        /// no matter if new data is available.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualVelocity
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                Velocity        :   LREAL;                       //  The value of the actual velocity (in axis’ unit [u/s])
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1680, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1680;
                RETURN;
            END_IF;

            IF Enable THEN
                Valid := TRUE;
                Velocity := THIS.ActualVelocity;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns the value of the actual torque or force as long as ‘Enable’ is set. ‘Valid’ is true when the
        /// data-output ‘Torque’ is valid. If ‘Enable’ is Reset, the data loses its validity, and ‘Valid’ is also reset, 
        /// no matter if new data is available.        
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadActualTorque
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                Torque          :   LREAL;                       //  The value of the actual torque or force (in technical units)
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1690, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1690;
                RETURN;
            END_IF;

            IF Enable THEN
                Valid := TRUE;
                Torque := THIS.ActualTorque;
            END_IF;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the_State diagram of the axis
        ///<summary>
        VAR INTERNAL
            MC_ReadStatusEnable_PV				: 	BOOL := FALSE;		//Enable - previous value                                                    
            MC_ReadStatusDone_PV				:	BOOL := FALSE;		//Done - previous value                                                      
            MC_ReadStatusStateNumber			: 	INT; 				//Call number of the method MC_ReadRealParameter                             
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadStatus
            VAR_INPUT
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable              :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid               :   BOOL;                       //  A valid output is available at the method
                Busy                :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error               :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID             :   DINT;                       //  Error identification
                ErrorStop           :   BOOL;                       //  See_State diagram
                Disabled            :   BOOL;                       //  See_State diagram
                Stopping            :   BOOL;                       //  See_State diagram
                Homing              :   BOOL;                       //  See_State diagram
                Standstill          :   BOOL;                       //  See_State diagram
                DiscreteMotion      :   BOOL;                       //  See_State diagram
                ContinuousMotion     :   BOOL;                       //  See_State diagram
                SynchronizedMotion  : BOOL;                       //  See_State diagram
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1700, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1700;
                RETURN;
            END_IF;
            
            // IF Enable THEN
            //     THIS.UpdateInputs(_AxisReference^);         
            //     Valid := TRUE;
            //     Error                   := _AxisReference^.Telegram111_In.ZSW1.faultPresent;
            //     ErrorID                 := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
            //     ErrorStop               := DriveState = AXOpen.Components.Drives.eAxoDriveState#ErrorStop;;                         
            //     Disabled                := DriveState = AXOpen.Components.Drives.eAxoDriveState#Disabled;
            //     Stopping                := DriveState = AXOpen.Components.Drives.eAxoDriveState#Stopping;
            //     Homing                  := DriveState = AXOpen.Components.Drives.eAxoDriveState#Homing;
            //     Standstill              := DriveState = AXOpen.Components.Drives.eAxoDriveState#Standstill;
            //     DiscreteMotion          := DriveState = AXOpen.Components.Drives.eAxoDriveState#DiscreteMotion;
            //     ContinuousMotion        := DriveState = AXOpen.Components.Drives.eAxoDriveState#ContinuousMotion;
            //     SynchronizedMotion      := DriveState = AXOpen.Components.Drives.eAxoDriveState#SynchronizedMotion;
            // END_IF;
        END_METHOD

        ///<summary>
        /// This method returns in detail the status of the axis with respect to the motion currently in progress. 
        ///<summary>
        VAR INTERNAL
            MC_ReadMotionStateEnable_PV     : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadMotionStateErrorID       : 	WORD;
            MC_ReadMotionStateCycle			: 	ULINT;
            MC_ReadMotionStateValue			: 	LINT;
            MC_ReadMotionStateValid			: 	BOOL;					
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadMotionState
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
                Source          :   AXOpen.Components.Abstractions.Drives.eAxoSource;                 //  Defines the source of the relevant data: CommandedValue;SetValue, ActualValue.
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                ConstantVelocity:   BOOL;                       //  Velocity is constant. Velocity may be 0. For the actual value a window is applicable (window is vendor specific)
                Accelerating    :   BOOL;                       //  Increasing the absolute value of the velocity
                Decelerating    :   BOOL;                       //  Decreasing the absolute value of the velocity
                DirectionPositive:  BOOL;                       //  Signals that the position is increasing
                DirectionNegative:  BOOL;                       //  Signals that the position is decreasing
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1710, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1710;
                RETURN;
            END_IF;

            // IF Enable THEN
            //     THIS.UpdateInputs(_AxisReference^);         
            //     Valid := TRUE;
            //     Error                   := _AxisReference^.Telegram111_In.ZSW1.faultPresent;
            //     ErrorID                 := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
            //     ConstantVelocity        := FALSE;
            //     Accelerating            := _AxisReference^.Telegram111_In.ZSW1.axisAccelerates;
            //     Decelerating            := _AxisReference^.Telegram111_In.ZSW1.axisDecelerates;
            //     DirectionPositive       := _AxisReference^.Telegram111_In.POS_ZSW2.%X4;
            //     DirectionNegative       := _AxisReference^.Telegram111_In.POS_ZSW2.%X5;
            //  END_IF;
        END_METHOD

        ///<summary>
        /// This method reads information concerning an axis, like modes, inputs directly related to the axis, 
        /// and certain status information.
        ///<summary>
        METHOD PUBLIC OVERRIDE MC_ReadAxisInfo
            VAR_INPUT
                AxisRef             :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable              :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid               :   BOOL;                       //  A valid output is available at the method
                Busy                :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error               :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID             :   DINT;                       //  Error identification
                HomeAbsSwitch       :   BOOL;                       //  Digital home switch input is active
                LimitSwitchPos      :   BOOL;                       //  Positive hardware end switch is active
                LimitSwitchNeg      :   BOOL;                       //  Negative hardware end switch is active
                Simulation          :   BOOL;                       //  Axis is in simulation mode (e.g. motor is simulated)
                CommunicationReady  :   BOOL;                       //  “Network” is initialized and ready for communication
                ReadyForPowerOn     :   BOOL;                       //  Drive is ready to be enabled (power on)
                PowerOn             :   BOOL;                       //  If TRUE shows that the power stage is switched ON
                IsHomed             :   BOOL;                       //  The absolute reference position is known for the axis (axis is homed)
                AxisWarning         :   BOOL;                       //  Warning(s) on the axis is present
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1720, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1720;
                RETURN;
            END_IF;

            // IF Enable THEN
            //     THIS.UpdateInputs(_AxisReference^);         
            //     Valid := TRUE;
            //     Error                   := _AxisReference^.Telegram111_In.ZSW1.faultPresent;
            //     ErrorID                 := TO_WORD(_AxisReference^.Telegram111_In.Fault_Code);
            //     HomeAbsSwitch           := FALSE;
            //     LimitSwitchPos          := _AxisReference^.Telegram111_In.POS_ZSW1.%X9;
            //     LimitSwitchNeg          := _AxisReference^.Telegram111_In.POS_ZSW1.%X8;
            //     Simulation              := FALSE;          
            //     CommunicationReady      := FALSE;
            //     ReadyForPowerOn         := _AxisReference^.Telegram111_In.ZSW1.readyForSwitchOn;
            //     PowerOn                 := _AxisReference^.Telegram111_In.ZSW1.operationEnabled;
            //     IsHomed                 := _AxisReference^.Telegram111_In.ZSW1.homePosSet;
            //     AxisWarning             := _AxisReference^.Telegram111_In.ZSW1.warningActive;
            // END_IF;
        END_METHOD

        ///<summary>
        /// This method presents general axis errors not relating to the methods. 
        /// (for instance axis errors, drive errors, communication errors)
        ///<summary>
        VAR INTERNAL
            MC_ReadAxisErrorEnable_PV        : 	BOOL := FALSE;		//Enable - previous value
            MC_ReadAxisErrorErrorID          : 	WORD;
            MC_ReadAxisErrorCycle			: 	ULINT;
            MC_ReadAxisErrorValue			: 	LINT;
            MC_ReadAxisErrorValid			: 	BOOL;					
            LastMessageCode :   ULINT;
        END_VAR
        METHOD PUBLIC OVERRIDE MC_ReadAxisError
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Enable          :   BOOL;                       //  Get the value of the parameter continuously while enabled
            END_VAR
            VAR_OUTPUT
                Valid           :   BOOL;                       //  A valid output is available at the method
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
                AxisErrorID     :   DWORD;                      //  The value of the axis error. These values are vendor specific
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
                _category  :   AXOpen.Messaging.eAxoMessageCategory;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1730, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1730;
                RETURN;
            END_IF;

            IF Enable AND NOT MC_ReadAxisErrorEnable_PV AND _State = UINT#0 THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_ReadAxisError;
                _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle + ULINT#2;
                MC_ReadAxisErrorCycle := _AxisReference^.Data.Cycle ;
            END_IF;

            // IF Enable THEN 	
            //     THIS.UpdateInputs(_AxisReference^);         
            //     IF _State = UINT#0 THEN
            //         Busy := TRUE;            
            //         MC_ReadAxisErrorErrorID := WORD#16#0000;         
            //         Parametrization.Inputs.Enable := FALSE;
            //         _State := UINT#310;
            //     END_IF;
            //     IF _State = UINT#310 THEN
            //         Busy := TRUE;            
            //         Parametrization.Inputs.Enable := TRUE;
            //         Parametrization.Inputs.ReadWrite   := FALSE;
            //         Parametrization.Inputs.ParameterNo := 12306;
            //         Parametrization.Inputs.Subindex    := 0;
            //         Parametrization.Inputs.AxisNo  := BYTE#1;
            //         Parametrization.Inputs.HardwareId  := _AxisReference^.Data.hwIdModuleAccessPoint;
            //         IF Parametrization.Outputs.Done AND NOT Parametrization.Outputs.Error THEN
            //             MC_ReadAxisErrorValid := TRUE;
            //             MC_ReadAxisErrorValue := Parametrization.Outputs.ValueReadLINT;
            //             _State := UINT#311;
            //         END_IF;
            //         IF Parametrization.Outputs.Error THEN 
            //             Messenger.Activate(         UINT#1731, eAxoMessageCategory#ProgrammingError);
            //             MC_ReadAxisErrorErrorID :=  WORD#1731;
            //             _State := UINT#319;
            //         END_IF;
            //     END_IF;
            //     IF _State = UINT#311 THEN
            //         Busy := TRUE;            
            //         Parametrization.Inputs.Enable := FALSE;
            //         Parametrization.Inputs.ReadWrite   := FALSE;
            //         IF  NOT Parametrization.Outputs.Done THEN
            //             _State := UINT#310;
            //         END_IF;
            //     END_IF;               
            //     IF _State = UINT#319 THEN
            //         Error := TRUE;    
            //     END_IF;         
                
            //     IF _State>=UINT#310 AND _State<UINT#317 THEN
            //         IF _AxisReference^.Data.Cycle <> MC_ReadAxisErrorCycle THEN
            //             _AxisReference^.Data.Cycle := _AxisReference^.Data.Cycle - ULINT#1;
            //             _State := UINT#319;
            //         END_IF;                  
            //     END_IF;  
            //     THIS.UpdateOutputs(_AxisReference^);          
            // END_IF;

            IF NOT Enable AND MC_ReadAxisErrorEnable_PV  THEN
                _AxisReference^.Status.CurrentMotionTaskId := AXOpen.Components.Drives.eAxoMotionTaskId#Axo_None;
                MC_ReadAxisErrorErrorID := WORD#0;
                MC_ReadAxisErrorCycle := ULINT#0;  
                MC_ReadAxisErrorValid := FALSE;
                MC_ReadAxisErrorValue := LINT#0;   
                _State := UINT#0;
            END_IF;     

            ErrorID := TO_DINT(MC_ReadAxisErrorErrorID);
            Valid := MC_ReadAxisErrorValid;
            MC_ReadAxisErrorEnable_PV := Enable;	          

            Messenger.ActivateOnCondition(LastMessageCode,Enable AND Valid AND LastMessageCode = TO_ULINT(MC_ReadAxisErrorValue), eAxoMessageCategory#Error);
            // IF NOT Messenger.IsActive THEN
            IF Messenger.MessengerState = eAxoMessengerState#Idle THEN
                LastMessageCode := TO_ULINT(MC_ReadAxisErrorValue);
            END_IF;
        END_METHOD

        ///<summary>
        /// This method makes the transition from the_State ‘ErrorStop’ to ‘Standstill’ or ‘Disabled’ by resetting all 
        /// internal axis-related errors – it does not affect the output of the other methods.
        ///<summary>
        VAR INTERNAL
            MC_ResetState       : 	UINT := UINT#0;
            MC_ResetPower_PV    : 	BOOL := FALSE;	
        END_VAR    
        METHOD PUBLIC OVERRIDE MC_Reset
            VAR_INPUT
                AxisRef         :   AXOpen.Components.Abstractions.Drives.IAxoAxisReference;
                Execute         :   BOOL;                       //  Resets all internal axis-related error
            END_VAR
            VAR_OUTPUT
                Done            :   BOOL;                       //  ‘Standstill’ or ‘Disabled’_State is reached
                Busy            :   BOOL;                       //  The method is not finished and new output values are to be expected
                Error           :   BOOL;                       //  Signals that an error has occurred within the method
                ErrorID         :   DINT;                       //  Error identification
            END_VAR
            VAR 
                _AxisReference :  REF_TO AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisReference;
            END_VAR
            
            _AxisReference ?= AxisRef;

            IF(_AxisReference = NULL) THEN
                Messenger.Activate(     UINT#1740, eAxoMessageCategory#ProgrammingError);
                DriveStatus.Error.Id := UINT#1740;
                RETURN;
            END_IF;

            IF Execute THEN
                IF Execute AND MC_ResetState = UINT#0 THEN
                    IF AxoPower_Task.IsSwitchedOn() OR 
                       _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable OR
                       _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn THEN
                         MC_ResetPower_PV := TRUE;
                    END_IF;
                    IF MC_ResetPower_PV THEN
                        MC_ResetState   := UINT#1;
                    ELSE
                        MC_ResetState   := UINT#10;
                    END_IF;
                END_IF;

                IF MC_ResetState = UINT#1 THEN
                    Busy := TRUE;
                    THIS.AxoPower_Task.Manual();
                    THIS.AxoPower_Task.SwitchOff();
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable := FALSE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn := FALSE;
                    IF THIS.AxoPower_Task.IsSwitchedOff() THEN
                        MC_ResetState := UINT#10;
                    END_IF;                
                END_IF;                

                IF MC_ResetState = UINT#10 THEN
                    IF MC_ResetPower_PV THEN
                        THIS.AxoPower_Task.Manual();
                        THIS.AxoPower_Task.SwitchOff();
                    END_IF;
                    Done            := FALSE;
                    Busy            := TRUE;
                    Error           := FALSE;
                    ErrorID         := UINT#0;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AcceptanceOfPositioningCommandValue := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.HomingControl := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.AbsoluteRelative := FALSE;      
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ImmediateChange := TRUE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogPositive := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.JogNegative := FALSE;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ClearError := TRUE;
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        MC_ResetState := UINT#20;    
                    END_IF;
                END_IF;

                IF MC_ResetState = UINT#20 THEN
                    Done            := FALSE;
                    Busy            := TRUE;
                    Error           := FALSE;
                    ErrorID         := UINT#0;
                    _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ClearError := FALSE;
                    IF NOT _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.DriveErrorZKL1 THEN
                        IF MC_ResetPower_PV THEN
                            MC_ResetState   := UINT#21;
                        ELSE
                            MC_ResetState   := UINT#30;
                        END_IF; 
                    END_IF;
                END_IF;     

                IF MC_ResetState = UINT#21 THEN
                    THIS.AxoPower_Task.Manual();
                    THIS.AxoPower_Task.SwitchOn();
                    Busy := TRUE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveEnable := TRUE;
                    // _AxisReference^.Outputs.DriveControlWord_S_0_0134_0_0.DriveOn := TRUE;
                    // IF THIS.AxoPower_Task.IsSwitchedOn() AND 
                    //     _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit0 AND
                    //     _AxisReference^.Inputs.DriveStatusWord_S_0_0135_0_0.ReadyForOperationBit1 THEN
                    //     MC_ResetState := UINT#30;
                    // END_IF;                
                    IF THIS.AxoPower_Task.IsSwitchedOn() THEN
                        MC_ResetState := UINT#30;
                    END_IF;                

                END_IF;   

                IF MC_ResetState = UINT#30 THEN
                    MC_ResetPower_PV := FALSE;
                    Done            := TRUE;
                    Busy            := FALSE;
                    Error           := FALSE;
                    ErrorID         := UINT#0;
                END_IF;              
            END_IF;
            IF NOT Execute THEN
                Done := FALSE;
                Error:=FALSE;
                ErrorID := DINT#0;
                Busy := FALSE;
                _AxisReference^.Outputs.SignalControlWord_S_0_0145_0_0.ClearError := FALSE;
                MC_ResetState := UINT#0;
            END_IF;
        END_METHOD

        METHOD PUBLIC OVERRIDE Restore
            MC_HomeExecute_PV					:= FALSE;
            MC_HomeErrorID					    := DINT#0;
            MC_HomeCycle					    := ULINT#0;
            MC_StopExecute_PV					:= FALSE;
            MC_StopErrorID					    := DINT#0;
            MC_StopCycle					    := ULINT#0;
            MC_HaltExecute_PV					:= FALSE;
            MC_HaltErrorID					    := DINT#0;
            MC_HaltCycle					    := ULINT#0;
            MC_MoveAbsoluteExecute_PV			:= FALSE;
            MC_MoveAbsoluteErrorID				:= DINT#0;
            MC_MoveAbsoluteCycle				:= ULINT#0;
            MC_MoveAbsoluteContinuousUpdate_SV  := FALSE;
            MC_MoveAbsolutePosition_PV          := LREAL#0.0;                                          
            MC_MoveAbsoluteVelocity_PV          := LREAL#0.0;                    
            MC_MoveAbsoluteAcceleration_PV      := LREAL#0.0;                    
            MC_MoveAbsoluteDeceleration_PV      := LREAL#0.0;                                
            MC_MoveAbsoluteJerk_PV              := LREAL#0.0;                     
            MC_MoveAbsoluteDirection_PV         := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#CurrentDirection;        
            MC_MoveRelativeExecute_PV			:= FALSE;
            MC_MoveRelativeErrorID				:= DINT#0;
            MC_MoveRelativeCycle				:= ULINT#0;
            MC_MoveRelativeContinuousUpdate_SV  := FALSE;
            MC_MoveRelativeDistance_PV          := LREAL#0.0;                                        
            MC_MoveRelativeVelocity_PV          := LREAL#0.0;                  
            MC_MoveRelativeAcceleration_PV      := LREAL#0.0;                  
            MC_MoveRelativeDeceleration_PV      := LREAL#0.0;                              
            MC_MoveRelativeJerk_PV              := LREAL#0.0;
            MC_MoveAdditiveExecute_PV			:= FALSE;
            MC_MoveAdditiveErrorID				:= DINT#0;
            MC_MoveAdditiveCycle				:= ULINT#0;
            MC_MoveAdditiveContinuousUpdate_SV  := FALSE;
            MC_MoveAdditiveDistance_PV          := LREAL#0.0;                                       
            MC_MoveAdditiveVelocity_PV          := LREAL#0.0;                 
            MC_MoveAdditiveAcceleration_PV      := LREAL#0.0;                 
            MC_MoveAdditiveDeceleration_PV      := LREAL#0.0;                             
            MC_MoveAdditiveJerk_PV              := LREAL#0.0;
            MC_MoveVelocityExecute_PV			:= FALSE;
            MC_MoveVelocityErrorID				:= WORD#0;
            MC_MoveVelocityCycle				:= ULINT#0;
            MC_MoveVelocityContinuousUpdate_SV  := FALSE;
            MC_MoveVelocityVelocity_PV          := LREAL#0.0;               
            MC_MoveVelocityAcceleration_PV      := LREAL#0.0;               
            MC_MoveVelocityDeceleration_PV      := LREAL#0.0;                           
            MC_MoveVelocityJerk_PV              := LREAL#0.0;                
            MC_MoveVelocityDirection_PV         := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#CurrentDirection;        
            MC_TorqueControlExecute_PV			:= FALSE;
            MC_TorqueControlErrorID				:= DINT#0;
            MC_TorqueControlCycle				:= ULINT#0;
            MC_TorqueControlContinuousUpdate_SV := FALSE;
            MC_TorqueControlTorque_PV           := LREAL#0.0;            
            MC_TorqueControlTorqueRamp_PV       := LREAL#0.0;            
            MC_TorqueControlPositionLimit_PV    := LREAL#0.0;            
            MC_TorqueControlVelocity_PV         := LREAL#0.0;            
            MC_TorqueControlAcceleration_PV     := LREAL#0.0;            
            MC_TorqueControlDeceleration_PV     := LREAL#0.0;                        
            MC_TorqueControlJerk_PV             := LREAL#0.0;             
            MC_TorqueControlDirection_PV        := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#CurrentDirection;        
            MC_SetPositionExecute_PV			:= FALSE;
            MC_SetPositionErrorID				:= DINT#0;
            MC_SetPositionCycle					:= ULINT#0;					
            MC_SetPositionActualPosition        := LINT#0;
            MC_ReadParameterEnable_PV           := FALSE;
            MC_ReadParameterErrorID             := DINT#0;
            MC_ReadParameterCycle			    := ULINT#0;
            MC_ReadParameterValue			    := LINT#0;
            MC_ReadParameterValid			    := FALSE;
            MC_ReadRealParameterEnable_PV       := FALSE;
            MC_ReadRealParameterErrorID         := DINT#0;
            MC_ReadRealParameterCycle			:= ULINT#0;
            MC_ReadRealParameterValue			:= REAL#0.0;
            MC_ReadRealParameterValid			:= FALSE;
            MC_ReadBoolParameterEnable_PV       := FALSE;
            MC_ReadBoolParameterErrorID         := WORD#0;
            MC_ReadBoolParameterCycle			:= ULINT#0;
            MC_ReadBoolParameterValue			:= FALSE;
            MC_ReadBoolParameterValid			:= FALSE;
            MC_WriteParameterExecute_PV         := FALSE;
            MC_WriteParameterErrorID            := WORD#0;
            MC_WriteParameterCycle			    := ULINT#0;
            MC_WriteRealParameterExecute_PV     := FALSE;
            MC_WriteRealParameterErrorID        := WORD#0;
            MC_WriteRealParameterCycle			:= ULINT#0;
            MC_WriteBoolParameterExecute_PV     := FALSE;
            MC_WriteBoolParameterErrorID        := WORD#0;
            MC_WriteBoolParameterCycle			:= ULINT#0;
            MC_ReadDigitalInputEnable_PV        := FALSE;
            MC_ReadDigitalInputErrorID          := WORD#0;
            MC_ReadDigitalInputCycle			:= ULINT#0;
            MC_ReadDigitalInputValue			:= FALSE;
            MC_ReadDigitalInputValid			:= FALSE;
            MC_ReadDigitalOutputEnable_PV       := FALSE;
            MC_ReadDigitalOutputErrorID         := WORD#0;
            MC_ReadDigitalOutputCycle			:= ULINT#0;
            MC_ReadDigitalOutputValue			:= FALSE;
            MC_ReadDigitalOutputValid			:= FALSE;
            MC_WriteDigitalOutputExecute_PV     := FALSE;
            MC_WriteDigitalOutputErrorID        := WORD#0;
            MC_WriteDigitalOutputCycle			:= ULINT#0;
            MC_ReadStatusEnable_PV				:= FALSE;                                                    
            MC_ReadStatusDone_PV				:= FALSE;                                                    
            MC_ReadStatusStateNumber			:= INT#0;
            MC_ReadMotionStateEnable_PV         := FALSE;
            MC_ReadMotionStateErrorID           := WORD#0;
            MC_ReadMotionStateCycle			    := ULINT#0;
            MC_ReadMotionStateValue			    := LINT#0;
            MC_ReadMotionStateValid			    := FALSE;
            MC_ReadAxisErrorEnable_PV           := FALSE;
            MC_ReadAxisErrorErrorID             := WORD#0;
            MC_ReadAxisErrorCycle			    := ULINT#0;
            MC_ReadAxisErrorValue			    := LINT#0;
            MC_ReadAxisErrorValid			    := FALSE;				
            LastMessageCode                     := ULINT#0;
            MC_ResetState                       := UINT#0;
            AxisRefExt.Data.Cycle               := ULINT#0;
            _State                              := UINT#0;
            DriveStatus.Action.Id := UINT#0;
            DriveStatus.Error.Id  := UINT#0;
            Messenger.Restore();
            TaskMessenger.Restore();

            //AxoPower_Task.Restore();
            AxoStop_Task.Restore();
            AxoHalt_Task.Restore();
            AxoHome_Task.Restore();
            AxoMoveAbsolute_Task.Restore();
            AxoMoveRelative_Task.Restore();
            AxoMoveAdditive_Task.Restore();
            AxoMoveVelocity_Task.Restore();
            AxoTorqueControl_Task.Restore();
            AxoSetPosition_Task.Restore();
            AxoSetOverride_Task.SwitchOff();
            AxoReadParameter_Task.SwitchOff();
            AxoReadRealParameter_Task.SwitchOff();
            AxoReadBoolParameter_Task.SwitchOff();
            AxoWriteParameter_Task.Restore();
            AxoWriteRealParameter_Task.Restore();
            AxoWriteBoolParameter_Task.Restore();
            AxoReadDigitalInput_Task.SwitchOff();
            AxoReadDigitalOutput_Task.SwitchOff();
            AxoWriteDigitalOutput_Task.Restore();
            AxoReadActualPosition_Task.SwitchOff();
            AxoReadActualVelocity_Task.SwitchOff();
            AxoReadActualTorque_Task.SwitchOff();
            AxoReadStatus_Task.SwitchOff();
            AxoReadMotionState_Task.SwitchOff();
            AxoReadAxisInfo_Task.SwitchOff();
            AxoReadAxisError_Task.SwitchOff();
            AxoReset_Task.Restore();
            AxoJogPositive.RemoteSwitchOn := FALSE;
            AxoJogPositive.StartMotion := FALSE;
            AxoJogPositive.StopMotion := FALSE;
            AxoJogNegative.RemoteSwitchOn := FALSE;
            AxoJogNegative.StartMotion := FALSE;
            AxoJogNegative.StopMotion := FALSE;
            
            // AxisRefExt.Outputs.CommandPosition_S_0_0282_0_0 := DINT#0;
            // AxisRefExt.Outputs.CommandVelocity_S_0_0259_0_0 := DINT#0;
            // AxisRefExt.Outputs.CommandAcceleration_S_0_0260_0_0 := DINT#0;
            // AxisRefExt.Outputs.CommandDecceleration_S_0_0359_0_0 := DINT#0;
            // AxisRefExt.Outputs.CommandTorque_S_0_0080_0_0 := INT#0;

            SUPER.Restore();

            RestoreTask.DoneWhen(TRUE);
        END_METHOD
        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND DriveConfig.InfoTime > LT#0S ,DriveConfig.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND DriveConfig.ErrorTime > LT#0S , DriveConfig.ErrorTime);
        END_METHOD
        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal_1 : BOOL;
                signal_2 : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal_1 AND DriveConfig.InfoTime > LT#0S ,DriveConfig.InfoTime);
            _errorTimer.OnDelay(THIS, signal_2 AND DriveConfig.ErrorTime > LT#0S , DriveConfig.ErrorTime);
        END_METHOD
    END_CLASS
END_NAMESPACE

