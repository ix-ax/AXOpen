USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.S71500.Hardware.Utilities;
USING System.Serialization;

NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    CLASS Axo_CS351_compact EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#OK#>"}
            OK : BOOL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#NOK#>"}
            NOK : BOOL;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Results#>"}
            Results  :   Axo_CS351_compact_Results;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Progress#>"}
            {#ix-attr:[ReadOnly()]}
            Progress : INT;            
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Program number (manual)#>"}
            ProgramNoManual : BYTE;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#IDcode (manual)#>"}
            IDcodeManual : STRING[64];
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Automatic start manual#>"}
            AutomaticStartManual : BOOL;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#DisableTask#>"}
            DisableTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#EnableTask#>"}
            EnableTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#DisableClockwiseTask#>"}
            DisableClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#EnableClockwiseTask#>"}
            EnableClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#DisableCounterClockwiseTask#>"}
            DisableCounterClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#EnableCounterClockwiseTask#>"}
            EnableCounterClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ResetFaultTask#>"}
            ResetFaultTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ResetResultsTask#>"}
            ResetResultsTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SetScrewingProgramTask#>"}
            SetScrewingProgramTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#GetScrewingResultsTask#>"}
            GetScrewingResultsTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ScrewClockwiseTask#>"}
            ScrewClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ScrewCounterClockwiseTask#>"}
            ScrewCounterClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#RunAutomatTask#>"}
            RunAutomatTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   Axo_CS351_compact_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   Axo_CS351_compact_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  Axo_CS351_compact_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   Axo_CS351_compact_Out;

        END_VAR    

        VAR PUBLIC // HARDWARE DIAGNOSTICS TASK
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PRIVATE
            _hwID           :   WORD;
            _hwID_1         :   WORD;
            _hwID_2         :   WORD;
            _hwID_3         :   WORD;
            _hwID_4         :   WORD;
            _hwID_5         :   WORD;
            _hwID_6         :   WORD;
            _hwID_7         :   WORD;
            _hwID_8         :   WORD;
            _hwID_9         :   WORD;
            _hwID_10        :   WORD;
            _hwID_11        :   WORD;
            _hwID_12        :   WORD;
            _hwID_13        :   WORD;
            _hwID_14        :   WORD;
            _hwID_15        :   WORD;
            _hwID_16        :   WORD;
            _hwID_17        :   WORD;
            _hwID_18        :   WORD;
            _hwID_19        :   WORD;
            _hwID_20        :   WORD;
            _hwID_21        :   WORD;
            _hwID_22        :   WORD;
            _hwID_23        :   WORD;
            _hwID_24        :   WORD;
            _hwID_25        :   WORD;
            _hwID_26        :   WORD;
            _progress       :   INT;
            _infoTimer      :   AXOpen.Timers.OnDelayTimer;
            _errorTimer     :   AXOpen.Timers.OnDelayTimer;
            _returnValue    :   WORD;
            _data_in4w      :   ARRAY[0..3] OF WORD;
            _data_out4w     :   ARRAY[0..3] OF WORD;
            _data_out2w     :   ARRAY[0..1] OF WORD;
            _word           :   WORD;
            _dword          :   DWORD;

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _startAddress           :   UDINT;
            _bytesCount             :   UINT;
            _blink                  :   AXOpen.Timers.AxoBlinker;   
            _programNo              :   BYTE;
            _IDcode                 :   ARRAY[0..63] OF BYTE;
            _automaticStart         :   BOOL;
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT; 
        END_VAR

        // Temporary workaround due to hwc station number issue
        METHOD PUBLIC Run
            VAR_INPUT
                parent  : IAxoObject;
                hwID    :   WORD;
                hwID_1  :   WORD;
                hwID_2  :   WORD;
                hwID_3  :   WORD;
                hwID_4  :   WORD;
                hwID_5  :   WORD;
                hwID_6  :   WORD;
                hwID_7  :   WORD;
                hwID_8  :   WORD;
                hwID_9  :   WORD;
                hwID_10 :   WORD;
                hwID_11 :   WORD;
                hwID_12 :   WORD;
                hwID_13 :   WORD;
                hwID_14 :   WORD;
                hwID_15 :   WORD;
                hwID_16 :   WORD;
                hwID_17 :   WORD;
                hwID_18 :   WORD;
                hwID_19 :   WORD;
                hwID_20 :   WORD;
                hwID_21 :   WORD;
                hwID_22 :   WORD;
                hwID_23 :   WORD;
                hwID_24 :   WORD;
                hwID_25 :   WORD;
                hwID_26 :   WORD;
            END_VAR
            _hwID               :=  hwID   ;
            _hwID_1             :=  hwID_1 ;
            _hwID_2             :=  hwID_2 ;
            _hwID_3             :=  hwID_3 ;
            _hwID_4             :=  hwID_4 ;
            _hwID_5             :=  hwID_5 ;
            _hwID_6             :=  hwID_6 ;
            _hwID_7             :=  hwID_7 ;
            _hwID_8             :=  hwID_8 ;
            _hwID_9             :=  hwID_9 ;
            _hwID_10            :=  hwID_10;
            _hwID_11            :=  hwID_11;
            _hwID_12            :=  hwID_12;
            _hwID_13            :=  hwID_13;
            _hwID_14            :=  hwID_14;
            _hwID_15            :=  hwID_15;
            _hwID_16            :=  hwID_16;
            _hwID_17            :=  hwID_17;
            _hwID_18            :=  hwID_18;
            _hwID_19            :=  hwID_19;
            _hwID_20            :=  hwID_20;
            _hwID_21            :=  hwID_21;
            _hwID_22            :=  hwID_22;
            _hwID_23            :=  hwID_23;
            _hwID_24            :=  hwID_24;
            _hwID_25            :=  hwID_25;
            _hwID_26            :=  hwID_26;
            _initHwCheckDone    :=  TRUE;
            THIS.Run(parent,hwID);
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent  : IAxoObject;
                hwID    :   WORD;
            END_VAR
            
            Progress := _progress;

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
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_1 :=  TO_WORD(_outHwid);                                         

                IF _hwID_1 = WORD#0 THEN
                    Messenger.Activate(UINT#703,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#703;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#704,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#704;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#705,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#705;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#706,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#706;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#707,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#707;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#708,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#708;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_1 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1301,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1301;
                    RETURN;
                END_IF;

                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_2 :=  TO_WORD(_outHwid);                                         

                IF _hwID_2 = WORD#0 THEN
                    Messenger.Activate(UINT#709,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#709;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#710,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#710;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#711,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#711;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#712,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#712;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#713,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#713;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#714,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#714;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_2 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1302,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1302;
                    RETURN;
                END_IF;

                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_3 :=  TO_WORD(_outHwid);                                         

                IF _hwID_3 = WORD#0 THEN
                    Messenger.Activate(UINT#715,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#715;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#717,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#717;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#718,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#718;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#719,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#719;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#720,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#720;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_3 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1303,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1303;
                    RETURN;
                END_IF;

                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_4 :=  TO_WORD(_outHwid);                                         

                IF _hwID_4 = WORD#0 THEN
                    Messenger.Activate(UINT#721,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#721;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#722,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#722;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#723,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#723;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#724,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#724;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#725,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#725;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_4 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1304,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1304;
                    RETURN;
                END_IF;

                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_5 :=  TO_WORD(_outHwid);                                         

                IF _hwID_5 = WORD#0 THEN
                    Messenger.Activate(UINT#727,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#727;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#728,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#728;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#729,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#729;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#730,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#730;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#731,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#731;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#732,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#732;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_5 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1305,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1305;
                    RETURN;
                END_IF;

                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_6 :=  TO_WORD(_outHwid);                                         

                IF _hwID_6 = WORD#0 THEN
                    Messenger.Activate(UINT#733,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#733;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#734,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#734;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#735,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#735;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#737,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#737;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#738,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#738;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_6 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1306,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1306;
                    RETURN;
                END_IF;

                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_7 :=  TO_WORD(_outHwid);                                         

                IF _hwID_7 = WORD#0 THEN
                    Messenger.Activate(UINT#739,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#739;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#740,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#740;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#741,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#741;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#742,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#742;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#743,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#743;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#744,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#744;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_7 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1307,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1307;
                    RETURN;
                END_IF;

                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_8 :=  TO_WORD(_outHwid);                                         

                IF _hwID_8 = WORD#0 THEN
                    Messenger.Activate(UINT#745,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#745;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#747,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#747;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#748,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#748;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#749,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#749;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#750,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#750;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_8 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1308,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1308;
                    RETURN;
                END_IF;

                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_9 :=  TO_WORD(_outHwid);                                         

                IF _hwID_9 = WORD#0 THEN
                    Messenger.Activate(UINT#751,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#751;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#752,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#752;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#753,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#753;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#754,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#754;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#755,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#755;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_9 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#4 THEN
                    Messenger.Activate(UINT#1309,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1309;
                    RETURN;
                END_IF;

                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_10 :=  TO_WORD(_outHwid);                                         

                IF _hwID_10 = WORD#0 THEN
                    Messenger.Activate(UINT#757,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#757;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#758,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#758;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#759,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#759;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#760,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#760;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#761,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#761;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#762,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#762;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_10 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1310,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1310;
                    RETURN;
                END_IF;
                //******************Slot 11*****************//
                _geoAddr.Slot   :=  UINT#11;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_11 :=  TO_WORD(_outHwid);                                         

                IF _hwID_11 = WORD#0 THEN
                    Messenger.Activate(UINT#763,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#763;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#764,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#764;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#765,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#765;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#767,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#767;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#768,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#768;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_11 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1311,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1311;
                    RETURN;
                END_IF;
                //******************Slot 12*****************//
                _geoAddr.Slot   :=  UINT#12;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_12 :=  TO_WORD(_outHwid);                                         

                IF _hwID_12 = WORD#0 THEN
                    Messenger.Activate(UINT#769,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#769;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#770,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#770;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#771,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#771;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#772,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#772;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#773,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#773;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#774,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#774;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_12 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1312,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1312;
                    RETURN;
                END_IF;

                //******************Slot 13*****************//
                _geoAddr.Slot   :=  UINT#13;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_13 :=  TO_WORD(_outHwid);                                         

                IF _hwID_13 = WORD#0 THEN
                    Messenger.Activate(UINT#775,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#775;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#777,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#777;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#778,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#778;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#779,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#779;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#780,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#780;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_13 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1313,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1313;
                    RETURN;
                END_IF;

                //******************Slot 14*****************//
                _geoAddr.Slot   :=  UINT#14;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_14 :=  TO_WORD(_outHwid);                                         

                IF _hwID_14 = WORD#0 THEN
                    Messenger.Activate(UINT#781,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#781;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#782,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#782;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#783,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#783;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#784,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#784;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#785,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#785;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#786;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_14 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1314,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1314;
                    RETURN;
                END_IF;

                //******************Slot 15*****************//
                _geoAddr.Slot   :=  UINT#15;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_15 :=  TO_WORD(_outHwid);                                         

                IF _hwID_15 = WORD#0 THEN
                    Messenger.Activate(UINT#787,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#787;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#788,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#788;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#789,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#789;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#790,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#790;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#791,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#791;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#792,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#792;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_15 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1315,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1315;
                    RETURN;
                END_IF;

                //******************Slot 16*****************//
                _geoAddr.Slot   :=  UINT#16;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_16 :=  TO_WORD(_outHwid);                                         

                IF _hwID_16 = WORD#0 THEN
                    Messenger.Activate(UINT#793,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#793;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#794,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#794;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#795,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#795;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#796,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#796;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#797,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#797;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#798,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#798;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_16 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1316,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1316;
                    RETURN;
                END_IF;

                //******************Slot 17*****************//
                _geoAddr.Slot   :=  UINT#17;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_17 :=  TO_WORD(_outHwid);                                         

                IF _hwID_17 = WORD#0 THEN
                    Messenger.Activate(UINT#799,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#799;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#800,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#800;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#801,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#801;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#802,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#802;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#803,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#803;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#804,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#804;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_17 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1317,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1317;
                    RETURN;
                END_IF;

                //******************Slot 18*****************//
                _geoAddr.Slot   :=  UINT#18;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_18 :=  TO_WORD(_outHwid);                                         

                IF _hwID_18 = WORD#0 THEN
                    Messenger.Activate(UINT#805,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#805;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#806,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#806;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#807,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#807;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#808,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#808;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#809,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#809;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#810,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#810;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_18 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1318,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1318;
                    RETURN;
                END_IF;

                //******************Slot 19*****************//
                _geoAddr.Slot   :=  UINT#19;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_19 :=  TO_WORD(_outHwid);                                         

                IF _hwID_19 = WORD#0 THEN
                    Messenger.Activate(UINT#811,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#811;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#812,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#812;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#813,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#813;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#814,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#814;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#815,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#815;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#816,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#816;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_19 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1319,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1319;
                    RETURN;
                END_IF;

                //******************Slot 20*****************//
                _geoAddr.Slot   :=  UINT#20;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_20 :=  TO_WORD(_outHwid);                                         

                IF _hwID_20 = WORD#0 THEN
                    Messenger.Activate(UINT#817,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#817;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#818,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#818;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#819,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#819;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#820,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#820;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#821,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#821;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#822,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#822;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_20 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1320,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1320;
                    RETURN;
                END_IF;

                //******************Slot 21*****************//
                _geoAddr.Slot   :=  UINT#21;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_21 :=  TO_WORD(_outHwid);                                         

                IF _hwID_21 = WORD#0 THEN
                    Messenger.Activate(UINT#823,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#823;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#824,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#824;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#825,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#825;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#826,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#826;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#827,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#827;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#828,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#828;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_21 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1321,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1321;
                    RETURN;
                END_IF;
                
                //******************Slot 22*****************//
                _geoAddr.Slot   :=  UINT#22;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_22 :=  TO_WORD(_outHwid);                                         

                IF _hwID_22 = WORD#0 THEN
                    Messenger.Activate(UINT#829,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#829;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#830,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#830;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#831,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#831;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#832,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#832;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#833,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#833;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#834,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#834;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_22 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1322,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1322;
                    RETURN;
                END_IF;

                //******************Slot 23*****************//
                _geoAddr.Slot   :=  UINT#23;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_23 :=  TO_WORD(_outHwid);                                         

                IF _hwID_23 = WORD#0 THEN
                    Messenger.Activate(UINT#835,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#835;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#836,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#836;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#837,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#837;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#838,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#838;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#839,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#839;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#840,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#840;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_23 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1323,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1323;
                    RETURN;
                END_IF;

                //******************Slot 24*****************//
                _geoAddr.Slot   :=  UINT#24;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_24 :=  TO_WORD(_outHwid);                                         

                IF _hwID_24 = WORD#0 THEN
                    Messenger.Activate(UINT#841,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#841;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#842,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#842;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#843,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#843;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#844,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#844;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#845,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#845;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#846,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#846;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_24 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1324,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1324;
                    RETURN;
                END_IF;

                //******************Slot 25*****************//
                _geoAddr.Slot   :=  UINT#25;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_25 :=  TO_WORD(_outHwid);                                         

                IF _hwID_25 = WORD#0 THEN
                    Messenger.Activate(UINT#847,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#847;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#848,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#848;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#849,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#849;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#850,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#850;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#851,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#851;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#852,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#852;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_25 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#1325,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1325;
                    RETURN;
                END_IF;

                //******************Slot 26*****************//
                _geoAddr.Slot   :=  UINT#26;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_26 :=  TO_WORD(_outHwid);                                         

                IF _hwID_26 = WORD#0 THEN
                    Messenger.Activate(UINT#853,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#853;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#854,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#854;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#855,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#855;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#856,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#856;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#857,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#857;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#858,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#858;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwID_26 , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 THEN
                    Messenger.Activate(UINT#1326,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1326;
                    RETURN;
                END_IF;

                // _hwID       :=  hwID;
                // _hwID_1     :=  hwID_1; 
                // _hwID_2     :=  hwID_2; 
                // _hwID_3     :=  hwID_3; 
                // _hwID_4     :=  hwID_4; 
                // _hwID_5     :=  hwID_5; 
                // _hwID_6     :=  hwID_6; 
                // _hwID_7     :=  hwID_7; 
                // _hwID_8     :=  hwID_8; 
                // _hwID_9     :=  hwID_9; 
                // _hwID_10    :=  hwID_10;
                // _hwID_11    :=  hwID_11;
                // _hwID_12    :=  hwID_12;
                // _hwID_13    :=  hwID_13;
                // _hwID_14    :=  hwID_14;
                // _hwID_15    :=  hwID_15;
                // _hwID_16    :=  hwID_16;
                // _hwID_17    :=  hwID_17;
                // _hwID_18    :=  hwID_18;
                // _hwID_19    :=  hwID_19;
                // _hwID_20    :=  hwID_20;
                // _hwID_21    :=  hwID_21; 
                // _hwID_22    :=  hwID_22; 
                // _hwID_23    :=  hwID_23; 
                // _hwID_24    :=  hwID_24; 
                // _hwID_25    :=  hwID_25; 
                // _hwID_26    :=  hwID_26; 

                IF parent = NULL THEN
                    Messenger.Activate(UINT#860,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#860;
                    RETURN;
                END_IF;

                IF _hwID  = WORD#0 THEN
                    Messenger.Activate(UINT#861,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#861;
                    RETURN;
                END_IF;
            
                IF _hwID_1  = WORD#0 THEN
                    Messenger.Activate(UINT#862,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#862;
                    RETURN;
                END_IF;
            
                IF _hwID_2  = WORD#0 THEN
                    Messenger.Activate(UINT#863,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#863;
                    RETURN;
                END_IF;
            
                IF _hwID_3  = WORD#0 THEN
                    Messenger.Activate(UINT#864,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#864;
                    RETURN;
                END_IF;

                IF _hwID_4  = WORD#0 THEN
                    Messenger.Activate(UINT#865,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#865;
                    RETURN;
                END_IF;
            
                IF _hwID_5  = WORD#0 THEN
                    Messenger.Activate(UINT#866,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#866;
                    RETURN;
                END_IF;
            
                IF _hwID_6  = WORD#0 THEN
                    Messenger.Activate(UINT#867,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#867;
                    RETURN;
                END_IF;
            
                IF _hwID_7  = WORD#0 THEN
                    Messenger.Activate(UINT#868,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#868;
                    RETURN;
                END_IF;
            
                IF _hwID_8  = WORD#0 THEN
                    Messenger.Activate(UINT#869,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#869;
                    RETURN;
                END_IF;
            
                IF _hwID_9  = WORD#0 THEN
                    Messenger.Activate(UINT#870,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#870;
                    RETURN;
                END_IF;

                IF _hwID_10  = WORD#0 THEN
                    Messenger.Activate(UINT#871,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#871;
                    RETURN;
                END_IF;
            
                IF _hwID_11  = WORD#0 THEN
                    Messenger.Activate(UINT#872,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#872;
                    RETURN;
                END_IF;
            
                IF _hwID_12  = WORD#0 THEN
                    Messenger.Activate(UINT#873,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#873;
                    RETURN;
                END_IF;
            
                IF _hwID_13  = WORD#0 THEN
                    Messenger.Activate(UINT#874,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#874;
                    RETURN;
                END_IF;
            
                IF _hwID_14  = WORD#0 THEN
                    Messenger.Activate(UINT#875,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#875;
                    RETURN;
                END_IF;
            
                IF _hwID_15  = WORD#0 THEN
                    Messenger.Activate(UINT#876,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#876;
                    RETURN;
                END_IF;

                IF _hwID_16  = WORD#0 THEN
                    Messenger.Activate(UINT#877,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#877;
                    RETURN;
                END_IF;
            
                IF _hwID_17  = WORD#0 THEN
                    Messenger.Activate(UINT#878,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#878;
                    RETURN;
                END_IF;
            
                IF _hwID_18  = WORD#0 THEN
                    Messenger.Activate(UINT#879,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#879;
                    RETURN;
                END_IF;
            
                IF _hwID_19  = WORD#0 THEN
                    Messenger.Activate(UINT#880,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#880;
                    RETURN;
                END_IF;
            
                IF _hwID_20  = WORD#0 THEN
                    Messenger.Activate(UINT#881,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#881;
                    RETURN;
                END_IF;

                IF _hwID_21  = WORD#0 THEN
                    Messenger.Activate(UINT#882,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#882;
                    RETURN;
                END_IF;
            
                IF _hwID_22  = WORD#0 THEN
                    Messenger.Activate(UINT#883,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#883;
                    RETURN;
                END_IF;
            
                IF _hwID_23  = WORD#0 THEN
                    Messenger.Activate(UINT#884,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#884;
                    RETURN;
                END_IF;

                IF _hwID_24  = WORD#0 THEN
                    Messenger.Activate(UINT#885,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#885;
                    RETURN;
                END_IF;
            
                IF _hwID_25  = WORD#0 THEN
                    Messenger.Activate(UINT#886,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#886;
                    RETURN;
                END_IF;
            
                IF _hwID_26  = WORD#0 THEN
                    Messenger.Activate(UINT#887,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#887;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs ******************************
            //  Slot 10 Input_4_word_1
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_10 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            Inputs.ProgramNoAck                 :=  _data_in4w[0].%B1;        //  0

            Inputs.Ready                        :=  _data_in4w[0].%X0;        //  1
            Inputs.NoFault                      :=  _data_in4w[0].%X1;
            Inputs.InCycle                      :=  _data_in4w[0].%X2;
            Inputs.InCycleCcw                   :=  _data_in4w[0].%X3;
            Inputs.CycleComplete                :=  _data_in4w[0].%X4;
            Inputs.OK                           :=  _data_in4w[0].%X5;
            Inputs.NOK                          :=  _data_in4w[0].%X6;
            Inputs.ToolButton                   :=  _data_in4w[0].%X7;

            Inputs.CcwSelect                    :=  _data_in4w[1].%X8;        //  2
            Inputs.StartButton                  :=  _data_in4w[1].%X9;
            Inputs.TrigOut                      :=  _data_in4w[1].%X10;
            Inputs.TorqueHigh                   :=  _data_in4w[1].%X11;
            Inputs.TorqueLow                    :=  _data_in4w[1].%X12;
            Inputs.AngleHigh                    :=  _data_in4w[1].%X13;
            Inputs.AngleLow                     :=  _data_in4w[1].%X14;
            Inputs.CcwLockAck                   :=  _data_in4w[1].%X15;

            Inputs.EnableAck                    :=  _data_in4w[1].%X0;        //  3
            Inputs.ActiveEnableAck              :=  _data_in4w[1].%X1;
            Inputs.CwLockAck                    :=  _data_in4w[1].%X2;
            Inputs.CwAck                        :=  _data_in4w[1].%X3;
            Inputs.CcwAck                       :=  _data_in4w[1].%X4;
            Inputs.ES_LED_GreenAck              :=  _data_in4w[1].%X5;
            Inputs.ES_LED_YellowAck             :=  _data_in4w[1].%X6;
            Inputs.ES_LED_RedAck                :=  _data_in4w[1].%X7;

            Inputs.Result                       :=  _data_in4w[2].%B1;        //  4
            Inputs.IDcode[0]                    :=  _data_in4w[2].%B0;        //  5
            Inputs.IDcode[1]                    :=  _data_in4w[3].%B1;        //  6
            Inputs.IDcode[2]                    :=  _data_in4w[3].%B0;        //  7

            //  Slot 11 Input_4_word_2
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_11 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            Inputs.IDcode[3]                    :=  _data_in4w[0].%B1;        //  8
            Inputs.IDcode[4]                    :=  _data_in4w[0].%B0;        //  9
            Inputs.IDcode[5]                    :=  _data_in4w[1].%B1;        //  10
            Inputs.IDcode[6]                    :=  _data_in4w[1].%B0;        //  11
            Inputs.IDcode[7]                    :=  _data_in4w[2].%B1;        //  12
            Inputs.IDcode[8]                    :=  _data_in4w[2].%B0;        //  13
            Inputs.IDcode[9]                    :=  _data_in4w[3].%B1;        //  14
            Inputs.IDcode[10]                   :=  _data_in4w[3].%B0;        //  15

            //  Slot 12 Input_4_word_3
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_12 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1203, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1203;
                RETURN;
            END_IF;

            Inputs.IDcode[11]                   :=  _data_in4w[0].%B1;        //  16
            Inputs.IDcode[12]                   :=  _data_in4w[0].%B0;        //  17
            Inputs.IDcode[13]                   :=  _data_in4w[1].%B1;        //  18
            Inputs.IDcode[14]                   :=  _data_in4w[1].%B0;        //  19
            Inputs.IDcode[15]                   :=  _data_in4w[2].%B1;        //  20
            Inputs.IDcode[16]                   :=  _data_in4w[2].%B0;        //  21
            Inputs.IDcode[17]                   :=  _data_in4w[3].%B1;        //  22
            Inputs.IDcode[18]                   :=  _data_in4w[3].%B0;        //  23

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_13 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1204, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1204;
                RETURN;
            END_IF;

            //  Slot 13 Input_4_word_4
            Inputs.IDcode[19]                   :=  _data_in4w[0].%B1;        //  24
            Inputs.IDcode[20]                   :=  _data_in4w[0].%B0;        //  25
            Inputs.IDcode[21]                   :=  _data_in4w[1].%B1;        //  26
            Inputs.IDcode[22]                   :=  _data_in4w[1].%B0;        //  27
            Inputs.IDcode[23]                   :=  _data_in4w[2].%B1;        //  28
            Inputs.IDcode[24]                   :=  _data_in4w[2].%B0;        //  29
            Inputs.IDcode[25]                   :=  _data_in4w[3].%B1;        //  30
            Inputs.IDcode[26]                   :=  _data_in4w[3].%B0;        //  31

            //  Slot 14 Input_4_word_5
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_14 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1205, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1205;
                RETURN;
            END_IF;

            Inputs.IDcode[27]                   :=  _data_in4w[0].%B1;        //  32
            Inputs.IDcode[28]                   :=  _data_in4w[0].%B0;        //  33
            Inputs.IDcode[29]                   :=  _data_in4w[1].%B1;        //  34
            Inputs.IDcode[30]                   :=  _data_in4w[1].%B0;        //  35
            Inputs.IDcode[31]                   :=  _data_in4w[2].%B1;        //  36
            Inputs.IDcode[32]                   :=  _data_in4w[2].%B0;        //  37
            Inputs.IDcode[33]                   :=  _data_in4w[3].%B1;        //  38
            Inputs.IDcode[34]                   :=  _data_in4w[3].%B0;        //  39

            //  Slot 15 Input_4_word_6
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_15 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1206, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1206;
                RETURN;
            END_IF;

            Inputs.IDcode[35]                   :=  _data_in4w[0].%B1;        //  40
            Inputs.IDcode[36]                   :=  _data_in4w[0].%B0;        //  41
            Inputs.IDcode[37]                   :=  _data_in4w[1].%B1;        //  42
            Inputs.IDcode[38]                   :=  _data_in4w[1].%B0;        //  43
            Inputs.IDcode[39]                   :=  _data_in4w[2].%B1;        //  44
            Inputs.IDcode[40]                   :=  _data_in4w[2].%B0;        //  45
            Inputs.IDcode[41]                   :=  _data_in4w[3].%B1;        //  46
            Inputs.IDcode[42]                   :=  _data_in4w[3].%B0;        //  47

            //  Slot 16 Input_4_word_7
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_16 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1207, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1207;
                RETURN;
            END_IF;

            Inputs.IDcode[43]                   :=  _data_in4w[0].%B1;        //  48
            Inputs.IDcode[44]                   :=  _data_in4w[0].%B0;        //  49
            Inputs.IDcode[45]                   :=  _data_in4w[1].%B1;        //  50
            Inputs.IDcode[46]                   :=  _data_in4w[1].%B0;        //  51
            Inputs.IDcode[47]                   :=  _data_in4w[2].%B1;        //  52
            Inputs.IDcode[48]                   :=  _data_in4w[2].%B0;        //  53
            Inputs.IDcode[49]                   :=  _data_in4w[3].%B1;        //  54
            Inputs.IDcode[50]                   :=  _data_in4w[3].%B0;        //  55

            //  Slot 17 Input_4_word_8
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_17 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1208, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1208;
                RETURN;
            END_IF;

            Inputs.IDcode[51]                   :=  _data_in4w[0].%B1;        //  56
            Inputs.IDcode[52]                   :=  _data_in4w[0].%B0;        //  57
            Inputs.IDcode[53]                   :=  _data_in4w[1].%B1;        //  58
            Inputs.IDcode[54]                   :=  _data_in4w[1].%B0;        //  59
            Inputs.IDcode[55]                   :=  _data_in4w[2].%B1;        //  60
            Inputs.IDcode[56]                   :=  _data_in4w[2].%B0;        //  61
            Inputs.IDcode[57]                   :=  _data_in4w[3].%B1;        //  62
            Inputs.IDcode[58]                   :=  _data_in4w[3].%B0;        //  63

            //  Slot 18 Input_4_word_9
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_18 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1209, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1209;
                RETURN;
            END_IF;

            Inputs.IDcode[59]                   :=  _data_in4w[0].%B1;        //  64
            Inputs.IDcode[60]                   :=  _data_in4w[0].%B0;        //  65
            Inputs.IDcode[61]                   :=  _data_in4w[1].%B1;        //  66
            Inputs.IDcode[62]                   :=  _data_in4w[1].%B0;        //  67
            Inputs.IDcode[63]                   :=  _data_in4w[2].%B1;        //  68
            
            _dword.%B0                          :=  _data_in4w[2].%B0;        //  69
            _dword.%B1                          :=  _data_in4w[3].%B1;        //  70
            _dword.%B2                          :=  _data_in4w[3].%B0;        //  71

            //  Slot 19 Input_4_word_10
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_19 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1210, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1210;
                RETURN;
            END_IF;

            _dword.%B3                          :=  _data_in4w[0].%B1;        //  72
            Inputs.CnoSE                        :=  TO_UDINT(_dword);              
            Inputs.ProgramNo                    :=  _data_in4w[0].%B0;        //  73
            _dword.%B0                          :=  _data_in4w[1].%B1;        //  74
            _dword.%B1                          :=  _data_in4w[1].%B0;        //  75
            _dword.%B2                          :=  _data_in4w[2].%B1;        //  76
            _dword.%B3                          :=  _data_in4w[2].%B0;        //  77
            Inputs.TorqueMin                    :=  TO_REAL(_dword) / REAL#100000.0;
            _dword.%B0                          :=  _data_in4w[3].%B1;        //  78
            _dword.%B1                          :=  _data_in4w[3].%B0;        //  79

            // Slot 20 Input_4_word_11
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_20 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1211, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1211;
                RETURN;
            END_IF;  

            _dword.%B2                           :=  _data_in4w[0].%B1;        //  80
            _dword.%B3                           :=  _data_in4w[0].%B0;        //  81
            Inputs.Torque                        :=  TO_REAL(_dword) / REAL#100000.0;
            _dword.%B0                           :=  _data_in4w[1].%B1;        //  82
            _dword.%B1                           :=  _data_in4w[1].%B0;        //  83
            _dword.%B2                           :=  _data_in4w[2].%B1;        //  84
            _dword.%B3                           :=  _data_in4w[2].%B0;        //  85
            Inputs.TorqueMax                     :=  TO_REAL(_dword) / REAL#100000.0;
            _dword.%B0                           :=  _data_in4w[3].%B1;        //  86
            _dword.%B1                           :=  _data_in4w[3].%B0;        //  87

            // Slot 21 Input_4_word_12
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_21 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1212, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1212;
                RETURN;
            END_IF;  

            _dword.%B2                           :=  _data_in4w[0].%B1;        //  88
            _dword.%B3                           :=  _data_in4w[0].%B0;        //  89
            Inputs.AngleMin                      :=  TO_REAL(_dword) / REAL#100000.0;
            _dword.%B0                           :=  _data_in4w[1].%B1;        //  90
            _dword.%B1                           :=  _data_in4w[1].%B0;        //  91
            _dword.%B2                           :=  _data_in4w[2].%B1;        //  92
            _dword.%B3                           :=  _data_in4w[2].%B0;        //  93
            Inputs.Angle                         :=  TO_REAL(_dword) / REAL#100000.0;
            _dword.%B0                           :=  _data_in4w[3].%B1;        //  94
            _dword.%B1                           :=  _data_in4w[3].%B0;        //  95

            // Slot 22 Input_4_word_13
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_22 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1213, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1213;
                RETURN;
            END_IF;  
            _dword.%B2                           :=  _data_in4w[0].%B1;        //  96
            _dword.%B3                           :=  _data_in4w[0].%B0;        //  97
            Inputs.AngleMax                      :=  TO_REAL(_dword) / REAL#100000.0;
            Inputs.ErrorCode                     :=  _data_in4w[1];            //  98 - 99
            Inputs.ErrorClass                    :=  _data_in4w[2];            //  100 - 101 

            // Slot 23 Input_4_word_14
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_23 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1214, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1214;
                RETURN;
            END_IF;  

            // Slot 24 Input_4_word_15
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_24 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1215, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1215;
                RETURN;
            END_IF;  

            // Slot 25 Input_4_word_16
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_25 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1216, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1216;
                RETURN;
            END_IF;  

            // Slot 26 Input_2_word_1
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwID_26 ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1217, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1217;
                RETURN;
            END_IF;  

            //*************INITIALIZATION*********************
            RestoreTask.Run(THIS);
            DisableTask.Run(THIS);
            EnableTask.Run(THIS);
            DisableClockwiseTask.Run(THIS);
            EnableClockwiseTask.Run(THIS);
            DisableCounterClockwiseTask.Run(THIS);
            EnableCounterClockwiseTask.Run(THIS);
            ResetFaultTask.Run(THIS);
            ResetResultsTask.Run(THIS);
            SetScrewingProgramTask.Run(THIS);
            GetScrewingResultsTask.Run(THIS);
            ScrewClockwiseTask.Run(THIS);
            ScrewCounterClockwiseTask.Run(THIS);
            RunAutomatTask.Run(THIS);
   
            //************************************************
            _blink.Blink(THIS, T#500ms,T#500ms);
            //********************Diagnostics*****************        
            HardwareDiagnosticsTask.Run(THIS,_hwID);
            //************************************************
    
            //*************RESTORE****************************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //************************************************
            
    
            //*************DisableTask************************
            DisableTask.SetIsDisabled(FALSE);
            IF DisableTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,DisableTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,DisableTask.IsDone(), eAxoMessageCategory#Info);
            IF DisableTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
    
                IF _progress = 300 THEN                                                                                     // DisableTask running
                    TaskMessenger.ActivateOnCondition(ULINT#500, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#500;
                    END_IF;
                    Outputs.Enable := FALSE;

                    IF NOT Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                
                IF _progress = 301 THEN                                                                                     // DisableTask finished
                    DisableTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                DisableTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                DisableTask.ThrowWhen(DisableTask.Duration >= Config.ErrorTime ,'DisableTask error.');
            END_IF;
            IF DisableTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF DisableTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#900;
                Status.Error.Id  :=  UINT#900;
            ELSIF DisableTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#901;
                Status.Error.Id  :=  UINT#901;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#900,DisableTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#901,DisableTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,DisableTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF DisableTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 304  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************

            //*************EnableTask***************************
            EnableTask.SetIsDisabled(FALSE);
            IF EnableTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#105;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#105,EnableTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#106,EnableTask.IsDone(), eAxoMessageCategory#Info);
            IF EnableTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 305;
                END_IF;
                
                IF _progress = 305 THEN                                                                                     // EnableTask running
                    
                    TaskMessenger.ActivateOnCondition(ULINT#505, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#505;
                    END_IF;
    
                    Outputs.Enable := TRUE;

                    IF Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                
                IF _progress = 306 THEN                                                                                     // EnableTask finished
                    EnableTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                EnableTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                EnableTask.ThrowWhen(EnableTask.Duration >= Config.ErrorTime ,'EnableTask error.');
            END_IF;
            IF EnableTask.DoneReached() THEN
                Status.Action.Id :=  UINT#106;
                Status.Error.Id :=  UINT#0;
            ELSIF EnableTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#905;
                Status.Error.Id  :=  UINT#905;
            ELSIF EnableTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#906;
                Status.Error.Id  :=  UINT#906;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#905,EnableTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#906,EnableTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#107,EnableTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF EnableTask.RestoreTriggered() AND _progress >= 305 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#107;
                _progress := 0;
            END_IF;
            //**************************************************
        
            //*************DisableClockwiseTask*****************
            DisableClockwiseTask.SetIsDisabled(FALSE);
            IF DisableClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,DisableClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,DisableClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF DisableClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
    
                IF _progress = 310 THEN                                                                                     // DisableClockwiseTask running
                    TaskMessenger.ActivateOnCondition(ULINT#510, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#510;
                    END_IF;
    
                    Outputs.CwAnd := FALSE;
                    Outputs.CwLock := TRUE;

                    IF Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
    
                IF _progress = 311 THEN                                                                                     // DisableClockwiseTask finished
                    DisableClockwiseTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                DisableClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                DisableClockwiseTask.ThrowWhen(DisableClockwiseTask.Duration >= Config.ErrorTime ,'DisableClockwiseTask error.');
            END_IF;
            IF DisableClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF DisableClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#910;
                Status.Error.Id  :=  UINT#910;
            ELSIF DisableClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#911;
                Status.Error.Id  :=  UINT#911;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#910,DisableClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#911,DisableClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,DisableClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF DisableClockwiseTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 314  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************EnableClockwiseTask******************
            EnableClockwiseTask.SetIsDisabled(FALSE);
            IF EnableClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#115;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#115,EnableClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#116,EnableClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF EnableClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 315;
                END_IF;
                
                IF _progress = 315 THEN                                                                                     // EnableClockwiseTask running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#515, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#515;
                    END_IF;
                    
                    Outputs.CwAnd := TRUE;
                    Outputs.CwLock := FALSE;
                    
                    IF NOT Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN                                                                                     // EnableClockwiseTask running: , <add the detailed description of the current action 10>
                    EnableClockwiseTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                EnableClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                EnableClockwiseTask.ThrowWhen(EnableClockwiseTask.Duration >= Config.ErrorTime ,'EnableClockwiseTask error.');
            END_IF;
            IF EnableClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#116;
                Status.Error.Id :=  UINT#0;
            ELSIF EnableClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#915;
                Status.Error.Id  :=  UINT#915;
            ELSIF EnableClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#916;
                Status.Error.Id  :=  UINT#916;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#915,EnableClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#916,EnableClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#117,EnableClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF EnableClockwiseTask.RestoreTriggered() AND _progress >= 315 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#117;
                _progress := 0;
            END_IF;
            //**************************************************

            //*************DisableCounterClockwiseTask**********
            DisableCounterClockwiseTask.SetIsDisabled(FALSE);
            IF DisableCounterClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,DisableCounterClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,DisableCounterClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF DisableCounterClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
    
                IF _progress = 320 THEN                                                                                     // DisableCounterClockwiseTask running
                    TaskMessenger.ActivateOnCondition(ULINT#520, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#520;
                    END_IF;

                    Outputs.CcwAnd := FALSE;
                    Outputs.CcwLock := TRUE;
                    
                    IF Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
                
                IF _progress = 321 THEN                                                                                     // DisableCounterClockwiseTask finished
                    DisableCounterClockwiseTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                DisableCounterClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                DisableCounterClockwiseTask.ThrowWhen(DisableCounterClockwiseTask.Duration >= Config.ErrorTime ,'DisableCounterClockwiseTask error.');
            END_IF;
            IF DisableCounterClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF DisableCounterClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#920;
                Status.Error.Id  :=  UINT#920;
            ELSIF DisableCounterClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#921;
                Status.Error.Id  :=  UINT#921;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#920,DisableCounterClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#921,DisableCounterClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,DisableCounterClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF DisableCounterClockwiseTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 324  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //**************************************************
   
            //*************EnableCounterClockwiseTask***********
            EnableCounterClockwiseTask.SetIsDisabled(FALSE);
            IF EnableCounterClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#125;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#125,EnableCounterClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#126,EnableCounterClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF EnableCounterClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 325;
                END_IF;
    
                IF _progress = 325 THEN                                                                                     // EnableCounterClockwiseTask running
                    TaskMessenger.ActivateOnCondition(ULINT#525, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#525;
                    END_IF;
    
                    Outputs.CcwAnd := TRUE;
                    Outputs.CcwLock := FALSE;

                    IF NOT Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN                                                                                     // EnableCounterClockwiseTask finished
                    EnableCounterClockwiseTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                EnableCounterClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                EnableCounterClockwiseTask.ThrowWhen(EnableCounterClockwiseTask.Duration >= Config.ErrorTime ,'EnableCounterClockwiseTask error.');
            END_IF;
            IF EnableCounterClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#126;
                Status.Error.Id :=  UINT#0;
            ELSIF EnableCounterClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#925;
                Status.Error.Id  :=  UINT#925;
            ELSIF EnableCounterClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#926;
                Status.Error.Id  :=  UINT#926;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#925,EnableCounterClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#926,EnableCounterClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#127,EnableCounterClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF EnableCounterClockwiseTask.RestoreTriggered() AND _progress >= 325 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#127;
                _progress := 0;
            END_IF;
            //**************************************************
            
            //*************ResetFaultTask***********************
            ResetFaultTask.SetIsDisabled(FALSE);
            IF ResetFaultTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#130,ResetFaultTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,ResetFaultTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetFaultTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
    
                IF _progress = 330 THEN                                                                                     // ResetFaultTask running
                    TaskMessenger.ActivateOnCondition(ULINT#530, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#530;
                    END_IF;
    
                    Outputs.ResetFault := NOT Inputs.NoFault AND _blink.output;

                    IF Inputs.NoFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
    
                IF _progress = 331 THEN                                                                                     // ResetFaultTask finished
                    TaskMessenger.ActivateOnCondition(ULINT#531, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#531;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN                                                                                     // ResetFaultTask running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#532, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#532;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;
                
                IF _progress = 333 THEN                                                                                     // ResetFaultTask running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#533, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#533;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN                                                                                     // ResetFaultTask running: , <add the detailed description of the current action 5>
                    ResetFaultTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ResetFaultTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ResetFaultTask.ThrowWhen(ResetFaultTask.Duration >= Config.ErrorTime ,'ResetFaultTask error.');
            END_IF;
            IF ResetFaultTask.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetFaultTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#930;
                Status.Error.Id  :=  UINT#930;
            ELSIF ResetFaultTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#931;
                Status.Error.Id  :=  UINT#931;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#930,ResetFaultTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#931,ResetFaultTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,ResetFaultTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetFaultTask.RestoreTriggered() AND _progress >= 330 AND _progress <= 334  THEN
                Status.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ResetResultsTask*********************
            ResetResultsTask.SetIsDisabled(FALSE);
            IF ResetResultsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#135;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#135,ResetResultsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#136,ResetResultsTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetResultsTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 335;
                END_IF;
    
                IF _progress = 335 THEN                                                                                     // ResetResultsTask running
                    TaskMessenger.ActivateOnCondition(ULINT#535, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#535;
                    END_IF;

                    Outputs.ResetResults := Inputs.CycleComplete AND _blink.output;
                    IF NOT Inputs.CycleComplete THEN
                        Outputs.ResetResults := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN                                                                                     // ResetResultsTask finished
                    ResetResultsTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ResetResultsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ResetResultsTask.ThrowWhen(ResetResultsTask.Duration >= Config.ErrorTime ,'ResetResultsTask error.');
            END_IF;
            IF ResetResultsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#136;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetResultsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#935;
                Status.Error.Id  :=  UINT#935;
            ELSIF ResetResultsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#936;
                Status.Error.Id  :=  UINT#936;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#935,ResetResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#936,ResetResultsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#137,ResetResultsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetResultsTask.RestoreTriggered() AND _progress >= 335 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#137;
                _progress := 0;
            END_IF;
            //**************************************************
            
            //*************SetScrewingProgramTask***************
            SetScrewingProgramTask.SetIsDisabled(FALSE);
            IF SetScrewingProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#140,SetScrewingProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,SetScrewingProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF SetScrewingProgramTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
    
                IF _progress = 340 THEN                                                                                     // SetScrewingProgramTask running: checking actual screwing program number
                    TaskMessenger.ActivateOnCondition(ULINT#540, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#540;
                    END_IF;

                    IF _programNo <> Inputs.ProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
    
                IF _progress = 341 THEN                                                                                     // SetScrewingProgramTask running: checking required screwing program number
                    TaskMessenger.ActivateOnCondition(ULINT#541, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#541;
                    END_IF;
                    IF _programNo>=BYTE#0 AND _programNo<=BYTE#99 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    ELSE
                        Messenger.Activate(ULINT#1100,eAxoMessageCategory#ProgrammingError);
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN                                                                                     // SetScrewingProgramTask running: waiting for the device to be ready
                    TaskMessenger.ActivateOnCondition(ULINT#542, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#542;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN                                                                                     // SetScrewingProgramTask running: waiting for the program to be set
                    TaskMessenger.ActivateOnCondition(ULINT#544, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#544;
                    END_IF;
    
                    Outputs.ProgramNo := _programNo;

                    IF Inputs.ProgramNoAck = Outputs.ProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN                                                                                     // SetScrewingProgramTask finished
                    SetScrewingProgramTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                SetScrewingProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                SetScrewingProgramTask.ThrowWhen(SetScrewingProgramTask.Duration >= Config.ErrorTime ,'SetScrewingProgramTask error.');
            END_IF;
            IF SetScrewingProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF SetScrewingProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#940;
                Status.Error.Id  :=  UINT#940;
            ELSIF SetScrewingProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#941;
                Status.Error.Id  :=  UINT#941;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#940,SetScrewingProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#941,SetScrewingProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,SetScrewingProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SetScrewingProgramTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 344  THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************GetScrewingResultsTask*******************
            GetScrewingResultsTask.SetIsDisabled(FALSE);
            IF GetScrewingResultsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#150,GetScrewingResultsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,GetScrewingResultsTask.IsDone(), eAxoMessageCategory#Info);
            IF GetScrewingResultsTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;
    
                IF _progress = 350 THEN                                                                                     // GetScrewingResultsTask running
                    TaskMessenger.ActivateOnCondition(ULINT#550, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#550;
                    END_IF;
    
                    Results.Result := Inputs.Result;
                    Results.IDcode.Data := Inputs.IDcode;
                    Results.CnoSE := Inputs.CnoSE;		
                    Results.ProgramNo := Inputs.ProgramNo;		
                    Results.TorqueMin := Inputs.TorqueMin;			
                    Results.Torque := Inputs.Torque;		
                    Results.TorqueMax := Inputs.TorqueMax;		
                    Results.AngleMin := Inputs.AngleMin;		
                    Results.Angle := Inputs.Angle;		
                    Results.AngleMax := Inputs.AngleMax;			
                    Results.ErrorCode := Inputs.ErrorCode;
                    Results.ErrorClass := Inputs.ErrorClass;

                    Results.IDcode.ToggleDataChangedFlag();

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
    
                IF _progress = 351 THEN                                                                                     // GetScrewingResultsTask finished
                    GetScrewingResultsTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                GetScrewingResultsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                GetScrewingResultsTask.ThrowWhen(GetScrewingResultsTask.Duration >= Config.ErrorTime ,'GetScrewingResultsTask error.');
            END_IF;
            IF GetScrewingResultsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF GetScrewingResultsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#950;
                Status.Error.Id  :=  UINT#950;
            ELSIF GetScrewingResultsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#951;
                Status.Error.Id  :=  UINT#951;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#950,GetScrewingResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#951,GetScrewingResultsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,GetScrewingResultsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF GetScrewingResultsTask.RestoreTriggered() AND _progress >= 350 AND _progress <= 359  THEN
                Status.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ScrewClockwiseTask*******************
            ScrewClockwiseTask.SetIsDisabled(FALSE);
            IF ScrewClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#160;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#160,ScrewClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,ScrewClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF ScrewClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;
    
                IF _progress = 360 THEN                                                                                     // ScrewClockwiseTask running: waiting for the device to be ready
                    TaskMessenger.ActivateOnCondition(ULINT#560, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#560;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
    
                IF _progress = 361 THEN                                                                                     // ScrewClockwiseTask running: enabling device
                    TaskMessenger.ActivateOnCondition(ULINT#561, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#561;
                    END_IF;
    
                    Outputs.Enable := TRUE;
                    Outputs.ActiveEnable := TRUE;
                    IF Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;
                
                IF _progress = 362 THEN                                                                                     // ScrewClockwiseTask running: enabling device
                    TaskMessenger.ActivateOnCondition(ULINT#562, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#562;
                    END_IF;
    
                    Outputs.Enable := TRUE;
                    Outputs.ActiveEnable := TRUE;

                    IF Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;
                
                IF _progress = 363 THEN                                                                                     // ScrewClockwiseTask running: enabling screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#563, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#563;
                    END_IF;

                    Outputs.CwAnd := TRUE;
                    Outputs.CwLock := FALSE;

                    IF NOT Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 364;
                    END_IF;
                END_IF;
                
                IF _progress = 364 THEN                                                                                     // ScrewClockwiseTask running: starting screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#564, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#564;
                    END_IF;
    
                    Outputs.StartClockwise := TRUE;
                    
                    IF Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 365;
                    END_IF;
                END_IF;
                
                IF _progress = 365 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#565, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#565;
                    END_IF;
                    IF _automaticStart THEN
                        Outputs.StartClockwise := TRUE;
                    END_IF;		
                    IF Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;
                
                IF _progress = 366 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#566, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#566;
                    END_IF;

                    IF _automaticStart THEN
                        Outputs.StartClockwise := TRUE;
                    END_IF;
                    
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 367;
                    END_IF;
                END_IF;
                
                IF _progress = 367 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#567, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#567;
                    END_IF;

                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF NOT Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 368;
                    END_IF;
                END_IF;
                
                IF _progress = 368 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#568, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#568;
                    END_IF;

                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF NOT Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 369;
                    END_IF;
                END_IF;
                
                IF _progress = 369 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#569, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#569;
                    END_IF;

                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 370;
                    END_IF;
                END_IF;
    
                IF _progress = 370 THEN                                                                                     // ScrewClockwiseTask running: disabling screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#570, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#570;
                    END_IF;
    
                    Outputs.CwAnd := FALSE;
                    Outputs.CwLock := TRUE;

                    IF Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;
    
                IF _progress = 371 THEN                                                                                     // ScrewClockwiseTask running: disabling screwing counterclockwise
                    TaskMessenger.ActivateOnCondition(ULINT#571, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#571;
                    END_IF;
    
                    Outputs.CcwAnd := FALSE;
                    Outputs.CcwLock := TRUE;
                    
                   IF Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 372;
                    END_IF;
                END_IF;
                
                IF _progress = 372 THEN                                                                                     // ScrewClockwiseTask finished
                    ScrewClockwiseTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ScrewClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ScrewClockwiseTask.ThrowWhen(ScrewClockwiseTask.Duration >= Config.ErrorTime ,'ScrewClockwiseTask error.');
            END_IF;
            IF ScrewClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#161;
                Status.Error.Id :=  UINT#0;
            ELSIF ScrewClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#960;
                Status.Error.Id  :=  UINT#960;
            ELSIF ScrewClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#961;
                Status.Error.Id  :=  UINT#961;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#960,ScrewClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#961,ScrewClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,ScrewClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ScrewClockwiseTask.RestoreTriggered() AND _progress >= 360 AND _progress <= 379  THEN
                Status.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;
            //*****************************************************            
    
            //*************ScrewCounterClockwiseTask***************
            ScrewCounterClockwiseTask.SetIsDisabled(FALSE);
            IF ScrewCounterClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#180,ScrewCounterClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,ScrewCounterClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF ScrewCounterClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
    
                IF _progress = 380 THEN                                                                                     // ScrewCounterClockwiseTask running: waiting for the device to be ready
                    TaskMessenger.ActivateOnCondition(ULINT#580, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#580;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;
    
                IF _progress = 381 THEN                                                                                     // ScrewCounterClockwiseTask running: enabling device
                    TaskMessenger.ActivateOnCondition(ULINT#581, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#581;
                    END_IF;
    
                    Outputs.Enable := TRUE;
                    Outputs.ActiveEnable := TRUE;
                    IF Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN                                                                                     // ScrewCounterClockwiseTask running: enabling device
                    TaskMessenger.ActivateOnCondition(ULINT#582, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#582;
                    END_IF;
    
                    Outputs.Enable := TRUE;
                    Outputs.ActiveEnable := TRUE;
                    IF Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN                                                                                     // ScrewCounterClockwiseTask running: enabling screwing counterclockwise
                    TaskMessenger.ActivateOnCondition(ULINT#583, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#583;
                    END_IF;
    
                    Outputs.CcwAnd := TRUE;
                    Outputs.CcwLock := FALSE;
                    IF NOT Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;
                
                IF _progress = 384 THEN                                                                                     // ScrewCounterClockwiseTask running: enabling screwing counterclockwise
                    TaskMessenger.ActivateOnCondition(ULINT#584, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#584;
                    END_IF;
    
                    IF _automaticStart THEN
                        Outputs.StartCounterClockwise := TRUE;
                    END_IF;
                    IF Inputs.InCycleCcw THEN
                        THIS.CallTimers(FALSE);
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise
                    TaskMessenger.ActivateOnCondition(ULINT#585, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#585;
                    END_IF;
    
                    Outputs.StartCounterClockwise := TRUE;
                    IF Inputs.InCycleCcw THEN
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;
                
                IF _progress = 386 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise
                    TaskMessenger.ActivateOnCondition(ULINT#586, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#586;
                    END_IF;
    
                    Outputs.StartCounterClockwise := TRUE;
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#587, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#587;
                    END_IF;
    
                    Outputs.StartCounterClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF NOT Inputs.InCycleCcw THEN
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                
                IF _progress = 388 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#588, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#588;
                    END_IF;
    
                    Outputs.StartCounterClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF NOT Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
                
                IF _progress = 389 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#589, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#589;
                    END_IF;
    
                    Outputs.StartCounterClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 390;
                    END_IF;
                END_IF;
    
                IF _progress = 390 THEN                                                                                     // ScrewCounterClockwiseTask running: disabling screwing counterclockwise
                    TaskMessenger.ActivateOnCondition(ULINT#590, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#590;
                    END_IF;
    
                    Outputs.CcwAnd := FALSE;
                    Outputs.CcwLock := TRUE;
                    IF Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
    
                IF _progress = 391 THEN                                                                                     // ScrewCounterClockwiseTask running: disabling screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#591, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#591;
                    END_IF;
    
                    Outputs.CwAnd := FALSE;
                    Outputs.CwLock := TRUE;
                    IF Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN                                                                                     // ScrewCounterClockwiseTask finished
                    ScrewCounterClockwiseTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ScrewCounterClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ScrewCounterClockwiseTask.ThrowWhen(ScrewCounterClockwiseTask.Duration >= Config.ErrorTime ,'ScrewCounterClockwiseTask error.');
            END_IF;
            IF ScrewCounterClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF ScrewCounterClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#980;
                Status.Error.Id  :=  UINT#980;
            ELSIF ScrewCounterClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#981;
                Status.Error.Id  :=  UINT#981;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#980,ScrewCounterClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#981,ScrewCounterClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,ScrewCounterClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ScrewCounterClockwiseTask.RestoreTriggered() AND _progress >= 380 AND _progress <= 399  THEN
                Status.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************RunAutomatTask***********************
            RunAutomatTask.SetIsDisabled(FALSE);
            IF RunAutomatTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#200;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#200,RunAutomatTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,RunAutomatTask.IsDone(), eAxoMessageCategory#Info);
            IF RunAutomatTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;
    
                IF _progress = 400 THEN                                                                                     // RunAutomatTask running: initialization
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#600;
                    END_IF;

                    OK := FALSE;
                    NOK := FALSE;

                    Outputs.IDcode := _IDcode;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 401;
                    END_IF;
                END_IF;
    
                IF _progress = 401 THEN                                                                                     // RunAutomatTask running: reseting fault
                    TaskMessenger.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#601;
                    END_IF;
    
                    Outputs.ResetFault := NOT Inputs.NoFault AND _blink.output;
                    IF Inputs.NoFault THEN
                        Outputs.ResetFault := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN                                                                                     // RunAutomatTask running: reseting fault
                    TaskMessenger.ActivateOnCondition(ULINT#602, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#602;
                    END_IF;
    
                    Outputs.ResetFault := NOT Inputs.NoFault AND _blink.output;
                    IF Inputs.Ready THEN
                        Outputs.ResetFault := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN                                                                                     // RunAutomatTask running: checking the actual screwing program number
                    TaskMessenger.ActivateOnCondition(ULINT#603, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#603;
                    END_IF;

                    IF _programNo <> Inputs.ProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 404;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN                                                                                     // RunAutomatTask running: checking the required screwing program number
                    TaskMessenger.ActivateOnCondition(ULINT#604, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#604;
                    END_IF;
    
                    IF _programNo>=BYTE#0 AND _programNo<=BYTE#99 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 405;
                    ELSE
                        Messenger.Activate(ULINT#1100,eAxoMessageCategory#ProgrammingError);
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN                                                                                     // RunAutomatTask running: waiting for the device to be ready
                    TaskMessenger.ActivateOnCondition(ULINT#605, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#605;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN                                                                                     // RunAutomatTask running: waiting for the screwing program to be set
                    TaskMessenger.ActivateOnCondition(ULINT#606, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#606;
                    END_IF;
    
                    Outputs.ProgramNo := _programNo;

                    IF Inputs.ProgramNoAck = Outputs.ProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN                                                                                     // RunAutomatTask running: enabling device
                    TaskMessenger.ActivateOnCondition(ULINT#607, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#607;
                    END_IF;
                    Outputs.Enable := TRUE;

                    IF Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN                                                                                     // RunAutomatTask running: reseting previous results
                    TaskMessenger.ActivateOnCondition(ULINT#608, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#608;
                    END_IF;
    
                    Outputs.ResetResults := Inputs.CycleComplete AND _blink.output;
                    IF NOT Inputs.CycleComplete THEN
                        Outputs.ResetResults := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN                                                                                     // RunAutomatTask running: enabling device
                    TaskMessenger.ActivateOnCondition(ULINT#609, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#609;
                    END_IF;

                    Outputs.ActiveEnable := TRUE;
                    IF Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 410;
                    END_IF;
                END_IF;
    
                IF _progress = 410 THEN                                                                                     // RunAutomatTask running: enabling screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#610;
                    END_IF;
    
                    Outputs.CwAnd := TRUE;
                    Outputs.CwLock := FALSE;
                    IF NOT Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 411;
                    END_IF;
                END_IF;
    
                IF _progress = 411 THEN                                                                                     // RunAutomatTask running: starting screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#611;
                    END_IF;
    
                    Outputs.StartClockwise := TRUE;
                    IF Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN                                                                                     // RunAutomatTask running: screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#612;
                    END_IF;

                    IF _automaticStart THEN
                        Outputs.StartClockwise := TRUE;
                    END_IF;
                    IF Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN                                                                                     // RunAutomatTask running: screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#613;
                    END_IF;
    
                    IF _automaticStart THEN
                        Outputs.StartClockwise := TRUE;
                    END_IF;
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN                                                                                     // RunAutomatTask running: screwing clockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#614;
                    END_IF;
    
                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    IF NOT Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN                                                                                     // RunAutomatTask running: screwing clockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#615;
                    END_IF;
                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    IF NOT Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN                                                                                     // RunAutomatTask running: screwing clockwise finished
                    TaskMessenger.ActivateOnCondition(ULINT#616, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#616;
                    END_IF;
                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN                                                                                     // RunAutomatTask running: disabling screwing clockwise
                    TaskMessenger.ActivateOnCondition(ULINT#617, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#617;
                    END_IF;
                    Outputs.CwAnd := FALSE;
                    Outputs.CwLock := TRUE;
                    IF Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN                                                                                     // RunAutomatTask running: disabling screwing counterclockwise
                    TaskMessenger.ActivateOnCondition(ULINT#618, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#618;
                    END_IF;
                    Outputs.CcwAnd := FALSE;
                    Outputs.CcwLock := TRUE;
                    IF Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 419;
                    END_IF;
                END_IF;
                
                IF _progress = 419 THEN                                                                                     // RunAutomatTask running: getting results
                    TaskMessenger.ActivateOnCondition(ULINT#618, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#618;
                    END_IF;

                    Results.Result := Inputs.Result;
                    Results.IDcode.Data := Inputs.IDcode;
                    Results.CnoSE := Inputs.CnoSE;		
                    Results.ProgramNo := Inputs.ProgramNo;		
                    Results.TorqueMin := Inputs.TorqueMin;			
                    Results.Torque := Inputs.Torque;		
                    Results.TorqueMax := Inputs.TorqueMax;		
                    Results.AngleMin := Inputs.AngleMin;		
                    Results.Angle := Inputs.Angle;		
                    Results.AngleMax := Inputs.AngleMax;			
                    Results.ErrorCode := Inputs.ErrorCode;
                    Results.ErrorClass := Inputs.ErrorClass;

                    Results.IDcode.ToggleDataChangedFlag();

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 420;
                    END_IF;
                END_IF;
    
                IF _progress = 420 THEN                                                                                     // RunAutomatTask running: evaluating results
                    TaskMessenger.ActivateOnCondition(ULINT#620, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#620;
                    END_IF;
    
                    OK := Inputs.OK AND NOT Inputs.NOK;
                    NOK := NOT Inputs.OK OR Inputs.NOK;
                    IF OK OR NOK THEN
                        THIS.CallTimers(FALSE);
                        _progress := 421;
                    END_IF;
                END_IF;
    
                IF _progress = 421 THEN                                                                                     // RunAutomatTask running: disabling
                    TaskMessenger.ActivateOnCondition(ULINT#621, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#621;
                    END_IF;
    
                    Outputs.Enable := FALSE;

                    IF NOT Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 422;
                    END_IF;
                END_IF;
                
                IF _progress = 422 THEN                                                                                     // RunAutomatTask finished
                    RunAutomatTask.DoneWhen(TRUE);
                END_IF;
                 
                THIS.CallTimers(TRUE);
                
                RunAutomatTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                RunAutomatTask.ThrowWhen(RunAutomatTask.Duration >= Config.ErrorTime ,'RunAutomatTask error.');
            END_IF;
            IF RunAutomatTask.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF RunAutomatTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#1000;
                Status.Error.Id  :=  UINT#1000;
            ELSIF RunAutomatTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#1001;
                Status.Error.Id  :=  UINT#1001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#1000,RunAutomatTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#1001,RunAutomatTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,RunAutomatTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF RunAutomatTask.RestoreTriggered() AND _progress >= 400 AND _progress <= 439  THEN
                Status.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //**************************************************

            //***********Update outputs ****************
            // Slot 1 Output_4_word_1
            _data_out4w[0].%B1        :=      Outputs.ProgramNo;                      //  0

            _data_out4w[0].%X0        :=      Outputs.Enable;                         //  1
            _data_out4w[0].%X1        :=      Outputs.ResetFault;
            _data_out4w[0].%X2        :=      Outputs.StartClockwise;
            _data_out4w[0].%X3        :=      Outputs.StartCounterClockwise;
            _data_out4w[0].%X4        :=      Outputs.ResetResults;
            _data_out4w[0].%X5        :=      Outputs.NokAck;
            _data_out4w[0].%X6        :=      Outputs.UsrIn1;
            _data_out4w[0].%X7        :=      Outputs.UsrIn2;
            
            _data_out4w[1].%X8        :=      Outputs.ES_LED_Green;                   //  2
            _data_out4w[1].%X9        :=      Outputs.ES_LED_Yellow;
            _data_out4w[1].%X10       :=      Outputs.ES_LED_Red;
            _data_out4w[1].%X11       :=      Outputs.ActiveEnable;
            _data_out4w[1].%X12       :=      Outputs.CcwLock;
            _data_out4w[1].%X13       :=      Outputs.CwLock;
            _data_out4w[1].%X14       :=      Outputs.CwAnd;
            _data_out4w[1].%X15       :=      Outputs.CcwAnd;

            _data_out4w[2].%B1        :=      Outputs.IDcode[0];                      //  4
            _data_out4w[2].%B0        :=      Outputs.IDcode[1];                      //  5
            _data_out4w[3].%B1        :=      Outputs.IDcode[2];                      //  6
            _data_out4w[3].%B0        :=      Outputs.IDcode[3];                      //  7

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_1,_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1221, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1221;
                RETURN;
            END_IF;
            
            // Slot 2 Output_4_word_2
            _data_out4w[0].%B1        :=      Outputs.IDcode[4];                      //  8
            _data_out4w[0].%B0        :=      Outputs.IDcode[5];                      //  9
            _data_out4w[1].%B1        :=      Outputs.IDcode[6];                      //  10
            _data_out4w[1].%B0        :=      Outputs.IDcode[7];                      //  11
            _data_out4w[2].%B1        :=      Outputs.IDcode[8];                      //  12
            _data_out4w[2].%B0        :=      Outputs.IDcode[9];                      //  13
            _data_out4w[3].%B1        :=      Outputs.IDcode[10];                     //  14
            _data_out4w[3].%B0        :=      Outputs.IDcode[11];                     //  15

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_2,_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1222, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1222;
                RETURN;
            END_IF;

            // Slot 3 Output_4_word_3
            _data_out4w[0].%B1        :=      Outputs.IDcode[12];                     //  16
            _data_out4w[0].%B0        :=      Outputs.IDcode[13];                     //  17
            _data_out4w[1].%B1        :=      Outputs.IDcode[14];                     //  18
            _data_out4w[1].%B0        :=      Outputs.IDcode[15];                     //  19
            _data_out4w[2].%B1        :=      Outputs.IDcode[16];                     //  20
            _data_out4w[2].%B0        :=      Outputs.IDcode[17];                     //  21
            _data_out4w[3].%B1        :=      Outputs.IDcode[18];                     //  22
            _data_out4w[3].%B0        :=      Outputs.IDcode[19];                     //  23

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_3,_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1223, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1223;
                RETURN;
            END_IF;

            // Slot 4 Output_4_word_4
            _data_out4w[0].%B1        :=      Outputs.IDcode[20];                     //  24
            _data_out4w[0].%B0        :=      Outputs.IDcode[21];                     //  25
            _data_out4w[1].%B1        :=      Outputs.IDcode[22];                     //  26
            _data_out4w[1].%B0        :=      Outputs.IDcode[23];                     //  27
            _data_out4w[2].%B1        :=      Outputs.IDcode[24];                     //  28
            _data_out4w[2].%B0        :=      Outputs.IDcode[25];                     //  29
            _data_out4w[3].%B1        :=      Outputs.IDcode[26];                     //  30
            _data_out4w[3].%B0        :=      Outputs.IDcode[27];                     //  31

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_4,_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1224, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1224;
                RETURN;
            END_IF;
            
            // Slot 5 Output_4_word_5
            _data_out4w[0].%B1        :=      Outputs.IDcode[28];                     //  32
            _data_out4w[0].%B0        :=      Outputs.IDcode[29];                     //  33
            _data_out4w[1].%B1        :=      Outputs.IDcode[30];                     //  34
            _data_out4w[1].%B0        :=      Outputs.IDcode[31];                     //  35
            _data_out4w[2].%B1        :=      Outputs.IDcode[32];                     //  36
            _data_out4w[2].%B0        :=      Outputs.IDcode[33];                     //  37
            _data_out4w[3].%B1        :=      Outputs.IDcode[34];                     //  38
            _data_out4w[3].%B0        :=      Outputs.IDcode[35];                     //  39

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_5,_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1225, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1225;
                RETURN;
            END_IF;
            
            // Slot 6 Output_4_word_6
            _data_out4w[0].%B1        :=      Outputs.IDcode[36];                     //  40
            _data_out4w[0].%B0        :=      Outputs.IDcode[37];                     //  41
            _data_out4w[1].%B1        :=      Outputs.IDcode[38];                     //  42
            _data_out4w[1].%B0        :=      Outputs.IDcode[39];                     //  43
            _data_out4w[2].%B1        :=      Outputs.IDcode[40];                     //  44
            _data_out4w[2].%B0        :=      Outputs.IDcode[41];                     //  45
            _data_out4w[3].%B1        :=      Outputs.IDcode[42];                     //  46
            _data_out4w[3].%B0        :=      Outputs.IDcode[43];                     //  47

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_6,_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1226, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1226;
                RETURN;
            END_IF;
            
            // Slot 7 Output_4_word_7
            _data_out4w[0].%B1        :=      Outputs.IDcode[44];                     //  48
            _data_out4w[0].%B0        :=      Outputs.IDcode[45];                     //  49
            _data_out4w[1].%B1        :=      Outputs.IDcode[46];                     //  50
            _data_out4w[1].%B0        :=      Outputs.IDcode[47];                     //  51
            _data_out4w[2].%B1        :=      Outputs.IDcode[48];                     //  52
            _data_out4w[2].%B0        :=      Outputs.IDcode[49];                     //  53
            _data_out4w[3].%B1        :=      Outputs.IDcode[50];                     //  54
            _data_out4w[3].%B0        :=      Outputs.IDcode[51];                     //  55

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_7,_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1227, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1227;
                RETURN;
            END_IF;
            
            // Slot 8 Output_4_word_8
            _data_out4w[0].%B1        :=      Outputs.IDcode[52];                     //  56
            _data_out4w[0].%B0        :=      Outputs.IDcode[53];                     //  57
            _data_out4w[1].%B1        :=      Outputs.IDcode[54];                     //  58
            _data_out4w[1].%B0        :=      Outputs.IDcode[55];                     //  59
            _data_out4w[2].%B1        :=      Outputs.IDcode[56];                     //  60
            _data_out4w[2].%B0        :=      Outputs.IDcode[57];                     //  61
            _data_out4w[3].%B1        :=      Outputs.IDcode[58];                     //  62
            _data_out4w[3].%B0        :=      Outputs.IDcode[59];                     //  63

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_8,_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1228, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1228;
                RETURN;
            END_IF;
            
            // Slot 9 Output_2_word_1
            _data_out2w[0].%B1        :=      Outputs.IDcode[60];                     //  64
            _data_out2w[0].%B0        :=      Outputs.IDcode[61];                     //  65
            _data_out2w[1].%B1        :=      Outputs.IDcode[62];                     //  66
            _data_out2w[1].%B0        :=      Outputs.IDcode[63];                     //  67

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_9,_data_out2w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1229, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1229;
                RETURN;
            END_IF;
            //******************************************      

        END_METHOD

        METHOD PUBLIC Disable : IAxoTaskState
            Disable := DisableTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC Enable : IAxoTaskState
            Enable := EnableTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC DisableClockwise : IAxoTaskState
            DisableClockwise := DisableClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC EnableClockwise : IAxoTaskState
            EnableClockwise := EnableClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC DisableCounterClockwise : IAxoTaskState
            DisableCounterClockwise := DisableCounterClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC EnableCounterClockwise : IAxoTaskState
            EnableCounterClockwise := EnableCounterClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ResetFault : IAxoTaskState
            ResetFault := ResetFaultTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ResetResults : IAxoTaskState
            ResetResults := ResetResultsTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC SetScrewingProgram : IAxoTaskState
            VAR_INPUT
                ProgramNo : BYTE;
            END_VAR
            _programNo  :=  ProgramNo;
            SetScrewingProgram := SetScrewingProgramTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC GetScrewingResults : IAxoTaskState
            GetScrewingResults := GetScrewingResultsTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ScrewClockwise : IAxoTaskState
            VAR_INPUT
                AutomaticStart : BOOL;
            END_VAR
            _automaticStart := AutomaticStart;
            ScrewClockwise := ScrewClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ScrewCounterClockwise : IAxoTaskState
            VAR_INPUT
                AutomaticStart : BOOL;
            END_VAR
            _automaticStart := AutomaticStart;
            ScrewCounterClockwise := ScrewCounterClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC RunAutomat : IAxoTaskState
            VAR_INPUT
                ProgramNo : BYTE;
                IDcode : STRING[64];
                AutomaticStart : BOOL;
            END_VAR
            VAR
               _data : ARRAY[0..64] OF BYTE;
               _i   :   UINT;
            END_VAR
            Serialize(UDINT#0, IDcode, _data);
            _programNo  :=  ProgramNo;
            FOR _i := UINT#1 TO UINT#64 DO
                _IDcode[_i - UINT#1] := _data[_i];
            END_FOR;
            _automaticStart := AutomaticStart;
            RunAutomat := RunAutomatTask.Invoke(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            VAR
                _data : ARRAY[0..64] OF BYTE;
                _i   :   UINT;
             END_VAR
             Serialize(UDINT#0, IDcodeManual, _data);
             _programNo  :=  ProgramNoManual;
             FOR _i := UINT#1 TO UINT#64 DO
                 _IDcode[_i - UINT#1] := _data[_i];
             END_FOR;
             _automaticStart := AutomaticStartManual;
            THIS._isManuallyControllable := TRUE;
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
            _returnValue    :=   WORD#0;

            _data_in4w[0] := WORD#0;
            _data_in4w[1] := WORD#0;
            _data_in4w[2] := WORD#0;
            _data_in4w[3] := WORD#0;

            _data_out4w[0] := WORD#0;
            _data_out4w[1] := WORD#0;
            _data_out4w[2] := WORD#0;
            _data_out4w[3] := WORD#0;

            _data_out2w[0] := WORD#0;
            _data_out2w[1] := WORD#0;

            _word           :=   WORD#0;
            _dword          :=   DWORD#0;

            DisableTask.Restore();
            EnableTask.Restore();
            DisableClockwiseTask.Restore();
            EnableClockwiseTask.Restore();
            DisableCounterClockwiseTask.Restore();
            EnableCounterClockwiseTask.Restore();
            ResetFaultTask.Restore();
            ResetResultsTask.Restore();
            SetScrewingProgramTask.Restore();
            GetScrewingResultsTask.Restore();

            ScrewClockwiseTask.Restore();
            ScrewCounterClockwiseTask.Restore();
            RunAutomatTask.Restore();
            HardwareDiagnosticsTask.Restore();

            Status.Action.Id := UINT#50;
            RestoreTask.DoneWhen(TRUE);

        END_METHOD        

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal , Config.ErrorTime);
        END_METHOD
    END_CLASS
END_NAMESPACE
