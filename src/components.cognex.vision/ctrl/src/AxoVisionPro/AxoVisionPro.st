USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.S71500.Hardware.Utilities;
USING Siemens.Simatic.S71500.MemoryAccess;
USING AXOpen.Timers;

NAMESPACE AXOpen.Components.Cognex.Vision
    {S7.extern=ReadWrite}
    CLASS AxoVisionPro EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER

        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#Hard reset all cameras#>"}
            HardResetAllCamerasTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC // TEMPLATE TASKS

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
            Config  :   AxoVisionPro_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoVisionPro_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  AxoVisionPro_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoVisionPro_Out;
        END_VAR    

        VAR PUBLIC // HARDWARE DIAGNOSTICS TASK
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PRIVATE
            _hwID                       :   WORD;
            _hwID_SystemControl         :   WORD;
            _hwID_Engine_Control_1      :   WORD;
            _hwID_Engine_Control_2      :   WORD;
            _hwID_Engine_Control_3      :   WORD;
            _hwID_Engine_Control_4      :   WORD;
            _hwID_User_Data_240_bytes_1 :   WORD;
            _hwID_User_Data_240_bytes_2 :   WORD;
            _hwID_User_Data_240_bytes_3 :   WORD;
            _hwID_User_Data_240_bytes_4 :   WORD;
            _hwID_User_Data_240_bytes_5 :   WORD;
            _hwID_User_Data_64_bytes_1  :   WORD;
            _hwID_Results_240_bytes_1   :   WORD;
            _hwID_Results_240_bytes_2   :   WORD;
            _hwID_Results_240_bytes_3   :   WORD;
            _hwID_Results_240_bytes_4   :   WORD;
            _hwID_Results_240_bytes_5   :   WORD;
            _hwID_Results_64_bytes_1    :   WORD;
            _hwID_18        :   WORD;
            _hwID_19        :   WORD;
            _hwID_20        :   WORD;
            _progress       :   INT;
            _infoTimer      :   AXOpen.Timers.OnDelayTimer;
            _errorTimer     :   AXOpen.Timers.OnDelayTimer;
            _returnValue    :   WORD;
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
            _startAddress           :   UDINT;
            _bytesCount             :   UINT;
            _Clock_1Hz               :   AxoBlinker;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent      :   IAxoObject;
                hwID        :   WORD;
                CameraNo    :   UINT;
            END_VAR
			VAR_TEMP 
                // ComponentName_temp : WString[50];
                SeparatorPos : Int;
                inputsAddress : UDInt;
                inputsCount : UInt;
                outputsAddress : UDInt;
                outputsCount : UInt;
                retValRdAddr : Int;
                i : Int;
                BitOffset : Int;
                LogGeoData_retval : WORD;
                _tmpWord : WORD;
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
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_SystemControl :=  TO_WORD(_outHwid);                                         

                IF _hwID_SystemControl = WORD#0 THEN
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
                
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Engine_Control_1 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Engine_Control_1 = WORD#0 THEN
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

                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Engine_Control_2 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Engine_Control_2 = WORD#0 THEN
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

                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Engine_Control_3 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Engine_Control_3 = WORD#0 THEN
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

                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Engine_Control_4 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Engine_Control_4 = WORD#0 THEN
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

                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_User_Data_240_bytes_1 :=  TO_WORD(_outHwid);                                         

                IF _hwID_User_Data_240_bytes_1 = WORD#0 THEN
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

                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_User_Data_240_bytes_2 :=  TO_WORD(_outHwid);                                         

                IF _hwID_User_Data_240_bytes_2 = WORD#0 THEN
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

                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_User_Data_240_bytes_3 :=  TO_WORD(_outHwid);                                         

                IF _hwID_User_Data_240_bytes_3 = WORD#0 THEN
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

                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_User_Data_240_bytes_4 :=  TO_WORD(_outHwid);                                         

                IF _hwID_User_Data_240_bytes_4 = WORD#0 THEN
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

                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_User_Data_240_bytes_5 :=  TO_WORD(_outHwid);                                         

                IF _hwID_User_Data_240_bytes_5 = WORD#0 THEN
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

                //******************Slot 11*****************//
                _geoAddr.Slot   :=  UINT#11;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_User_Data_64_bytes_1 :=  TO_WORD(_outHwid);                                         

                IF _hwID_User_Data_64_bytes_1 = WORD#0 THEN
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

                //******************Slot 12*****************//
                _geoAddr.Slot   :=  UINT#12;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Results_240_bytes_1 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Results_240_bytes_1 = WORD#0 THEN
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

                //******************Slot 13*****************//
                _geoAddr.Slot   :=  UINT#13;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Results_240_bytes_2 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Results_240_bytes_2 = WORD#0 THEN
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

                //******************Slot 14*****************//
                _geoAddr.Slot   :=  UINT#14;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Results_240_bytes_3 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Results_240_bytes_3 = WORD#0 THEN
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

                //******************Slot 15*****************//
                _geoAddr.Slot   :=  UINT#15;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Results_240_bytes_4 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Results_240_bytes_4 = WORD#0 THEN
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

                //******************Slot 16*****************//
                _geoAddr.Slot   :=  UINT#16;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Results_240_bytes_5 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Results_240_bytes_5 = WORD#0 THEN
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

                //******************Slot 17*****************//
                _geoAddr.Slot   :=  UINT#17;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwID_Results_64_bytes_1 :=  TO_WORD(_outHwid);                                         

                IF _hwID_Results_64_bytes_1 = WORD#0 THEN
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

                _hwID       :=  hwID;

                IF parent = NULL THEN
                    Messenger.Activate(UINT#830,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#830;
                    RETURN;
                END_IF;

                IF _hwID  = WORD#0 THEN
                    Messenger.Activate(UINT#831,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#831;
                    RETURN;
                END_IF;
            
                IF _hwID_SystemControl  = WORD#0 THEN
                    Messenger.Activate(UINT#832,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#832;
                    RETURN;
                END_IF;
            
                IF _hwID_Engine_Control_1  = WORD#0 THEN
                    Messenger.Activate(UINT#833,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#833;
                    RETURN;
                END_IF;
            
                IF _hwID_Engine_Control_2  = WORD#0 THEN
                    Messenger.Activate(UINT#834,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#834;
                    RETURN;
                END_IF;

                IF _hwID_Engine_Control_3  = WORD#0 THEN
                    Messenger.Activate(UINT#835,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#835;
                    RETURN;
                END_IF;
            
                IF _hwID_Engine_Control_4  = WORD#0 THEN
                    Messenger.Activate(UINT#836,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#836;
                    RETURN;
                END_IF;
            
                IF _hwID_User_Data_240_bytes_1  = WORD#0 THEN
                    Messenger.Activate(UINT#837,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#837;
                    RETURN;
                END_IF;
            
                IF _hwID_User_Data_240_bytes_2  = WORD#0 THEN
                    Messenger.Activate(UINT#838,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#838;
                    RETURN;
                END_IF;
            
                IF _hwID_User_Data_240_bytes_3  = WORD#0 THEN
                    Messenger.Activate(UINT#839,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#839;
                    RETURN;
                END_IF;
            
                IF _hwID_User_Data_240_bytes_4  = WORD#0 THEN
                    Messenger.Activate(UINT#840,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#840;
                    RETURN;
                END_IF;

                IF _hwID_User_Data_240_bytes_5  = WORD#0 THEN
                    Messenger.Activate(UINT#841,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#841;
                    RETURN;
                END_IF;
            
                IF _hwID_User_Data_64_bytes_1  = WORD#0 THEN
                    Messenger.Activate(UINT#842,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#842;
                    RETURN;
                END_IF;
            
                IF _hwID_Results_240_bytes_1  = WORD#0 THEN
                    Messenger.Activate(UINT#843,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#843;
                    RETURN;
                END_IF;
            
                IF _hwID_Results_240_bytes_2  = WORD#0 THEN
                    Messenger.Activate(UINT#844,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#844;
                    RETURN;
                END_IF;
            
                IF _hwID_Results_240_bytes_3  = WORD#0 THEN
                    Messenger.Activate(UINT#845,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#845;
                    RETURN;
                END_IF;
            
                IF _hwID_Results_240_bytes_4  = WORD#0 THEN
                    Messenger.Activate(UINT#846,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#846;
                    RETURN;
                END_IF;

                IF _hwID_Results_240_bytes_5  = WORD#0 THEN
                    Messenger.Activate(UINT#847,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#847;
                    RETURN;
                END_IF;
            
                IF _hwID_Results_64_bytes_1  = WORD#0 THEN
                    Messenger.Activate(UINT#848,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#848;
                    RETURN;
                END_IF;

                Config.HWIDs.HW_System := TO_UINT(_hwID_SystemControl );     
                Config.HWIDs.HW_Engine_1 := TO_UINT(_hwID_Engine_Control_1);     
                Config.HWIDs.HW_Engine_2 := TO_UINT(_hwID_Engine_Control_2);     
                Config.HWIDs.HW_Engine_3 := TO_UINT(_hwID_Engine_Control_3);     
                Config.HWIDs.HW_Engine_4 := TO_UINT(_hwID_Engine_Control_4);     
                Config.HWIDs.HW_UserData_1 := TO_UINT(_hwID_User_Data_240_bytes_1);   
                Config.HWIDs.HW_UserData_2 := TO_UINT(_hwID_User_Data_240_bytes_2); 
                Config.HWIDs.HW_UserData_3 := TO_UINT(_hwID_User_Data_240_bytes_3); 
                Config.HWIDs.HW_UserData_4 := TO_UINT(_hwID_User_Data_240_bytes_4); 
                Config.HWIDs.HW_UserData_5 := TO_UINT(_hwID_User_Data_240_bytes_5); 
                Config.HWIDs.HW_UserData_6 := TO_UINT(_hwID_User_Data_64_bytes_1); 
                Config.HWIDs.HW_Results_1 := TO_UINT(_hwID_Results_240_bytes_1);    
                Config.HWIDs.HW_Results_2 := TO_UINT(_hwID_Results_240_bytes_2);  
                Config.HWIDs.HW_Results_3 := TO_UINT(_hwID_Results_240_bytes_3);  
                Config.HWIDs.HW_Results_4 := TO_UINT(_hwID_Results_240_bytes_4);  
                Config.HWIDs.HW_Results_5 := TO_UINT(_hwID_Results_240_bytes_5);  
                Config.HWIDs.HW_Results_6 := TO_UINT(_hwID_Results_64_bytes_1);  

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs **************

			Config.CameraNo := CameraNo;

			IF Config.CameraNo < UINT#1 THEN
                Messenger.Activate(UINT#881, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#881;
                RETURN;
            END_IF;

            IF Config.CameraNo > UINT#8 THEN
                Messenger.Activate(UINT#882, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#882;
                RETURN;
            END_IF;

			retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_System),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount);//(LADDR := Component.HW.HW_System, PIADDR => inputsAddress, PICount => inputsCount, PQADDR => outputsAddress, PQCount => outputsCount);
			
			CASE CameraNo OF
				UINT#1:
					inputsAddress := inputsAddress + UDINT#8;
					BitOffset := 0;
			
				UINT#2:
					inputsAddress := inputsAddress + UDINT#8;
					BitOffset := 4;
			
				UINT#3:
					inputsAddress := inputsAddress + UDINT#9;
					BitOffset := 0;
			
				UINT#4:
					inputsAddress := inputsAddress + UDINT#9;
					BitOffset := 4;
			
				UINT#5:
					inputsAddress := inputsAddress + UDINT#10;
					BitOffset := 0;
			
				UINT#6:
					inputsAddress := inputsAddress + UDINT#10;
					BitOffset := 4;
			
				UINT#7:
					inputsAddress := inputsAddress + UDINT#11;
					BitOffset := 0;
			
				UINT#8:
					inputsAddress := inputsAddress + UDINT#11;
					BitOffset := 4;
			END_CASE;

            ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := BitOffset, value => Inputs.Status.SoftEvent.ResetAck );
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := (BitOffset + INT#1),value => Inputs.Status.SoftEvent.DataHandlerDone);	
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := (BitOffset + INT#2),value => Inputs.Status.SoftEvent.TriggerAck);		
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := (BitOffset + INT#3),value => Inputs.Status.SoftEvent.Reserve);		

            retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_System),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#0, value => Inputs.Status.SystemReady);
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#1, value => Inputs.Status.SystemBusy); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#7, value => Inputs.Status.Online); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#5, value => Inputs.Status.JobLoadComplete); 
			//nacitanie user dat pre kontrolu.. ci a ako to nastavili ine kamery. 
			ReadMemory(area := ReadArea#Input, byteOffset := TO_DINT(inputsAddress) + DINT#4, value => _tmpWord ); 
			Inputs.Status.CurentJobID := TO_UINT(_tmpWord);
			Inputs.Status.ReadDataLockerJobID := (Inputs.Status.CurentJobID / UINT#10); //celociselne delenie.. nech Zistim ktora kamera obsadila read data buffer.
			
			retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_Engine_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#5, value => Inputs.Status.ResultValid); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + DINT#4, value => _tmpWord);
			Inputs.Status.ID_Inspection:= TO_INT(_tmpWord);
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + DINT#1, bitOffset := INT#0, value => Inputs.Status.SetUserDataAck); 
			
			//nacitanie user dat pre kontrolu.. ci a ako to nastavili ine kamery. 
			retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_UserData_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
			
			ReadMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), value => _tmpWord);
			Inputs.Status.UserDataJobID:= TO_UINT(_tmpWord);

			Inputs.Status.UserDataLockerJobID := (Inputs.Status.UserDataJobID / UINT#10); //celociselne delenie.. nech Zistim ktora kamera obsadila user data buffer.
			ReadMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#1, value => Inputs.Status.UserDataLockerIdOperation);
		
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            HardResetAllCamerasTask.Run(THIS);
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
            HardwareDiagnosticsTask.Run(THIS,_hwID);
            //****************************************
    
            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
            
    
            //*************HardResetAllCamerasTask**************
            HardResetAllCamerasTask.SetIsDisabled(FALSE);
            IF HardResetAllCamerasTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,HardResetAllCamerasTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,HardResetAllCamerasTask.IsDone(), eAxoMessageCategory#Info);
            IF HardResetAllCamerasTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
    
                IF _progress = 300 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#500, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#500;
                    END_IF;
                    		
                    Outputs.Control.SoftEvent.Trigger := FALSE;
                    Outputs.Control.SoftEvent.DataHandlerAck := FALSE;
                    Outputs.Control.SetUserdata := FALSE;
                    Outputs.Control.InitiateJobLoad := FALSE;
                    Outputs.Control.InspectionResultsAck := FALSE;
               
                    retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_UserData_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 

                    WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress),value:= BYTE#0);
                    WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#1,value:= BYTE#0);
                    WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2,value:= BYTE#0);
                    Outputs.Control.JobLoadID := 0;
                    
                    retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_System),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    
                    WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#4, value:= FALSE);

                    
                    retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_System),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    
                    WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2,value:= WORD#0);
                    
                    retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_Engine_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    
                    WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#1, value:= FALSE);                    

                    IF Inputs.Status.CurentJobID > UINT#0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    ELSE
                        _progress := 309;
                    END_IF;
                END_IF;
    
                IF _progress = 301 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#501, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#501;
                    END_IF;
    
                    _Clock_1Hz.Blink(THIS,TIME#500MS,TIME#500MS);
                    WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#4, value:= _Clock_1Hz.output);

                    IF Inputs.Status.CurentJobID = UINT#0  THEN
                        WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#4, value:= FALSE);
                        THIS.CallTimers(FALSE);
                        _progress := 309;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#502, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#502;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#503, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#503;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                
                IF _progress = 304 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#504, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#504;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                
                IF _progress = 305 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#505, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#505;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                
                IF _progress = 306 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#506, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#506;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 307;
                    END_IF;
                END_IF;
                
                IF _progress = 307 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#507, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#507;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 308;
                    END_IF;
                END_IF;
                
                IF _progress = 308 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#508, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#508;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 309;
                    END_IF;
                END_IF;
                
                IF _progress = 309 THEN                                                                                     // HardResetAllCamerasTask running: , <add the detailed description of the current action 10>
                    HardResetAllCamerasTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                HardResetAllCamerasTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                HardResetAllCamerasTask.ThrowWhen(HardResetAllCamerasTask.Duration >= Config.ErrorTime ,'HardResetAllCamerasTask error.');
            END_IF;
            IF HardResetAllCamerasTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF HardResetAllCamerasTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#900;
                Status.Error.Id  :=  UINT#900;
            ELSIF HardResetAllCamerasTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#901;
                Status.Error.Id  :=  UINT#901;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#900,HardResetAllCamerasTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#901,HardResetAllCamerasTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,HardResetAllCamerasTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF HardResetAllCamerasTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
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
    
                IF _progress = 310 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#510, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#510;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
    
                IF _progress = 311 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#511, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#511;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#512, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#512;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#513, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#513;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#514, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#514;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#515, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#515;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#516, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#516;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;
                
                IF _progress = 317 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#517, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#517;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;
                
                IF _progress = 318 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#518, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#518;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 319;
                    END_IF;
                END_IF;
                
                IF _progress = 319 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_2.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_2.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_2.ThrowWhen(TemplateTask_10steps_2.Duration >= Config.ErrorTime ,'TemplateTask_10steps_2 error.');
            END_IF;
            IF TemplateTask_10steps_2.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_2.ErrorOccured() THEN
                Status.Action.Id :=  UINT#910;
                Status.Error.Id  :=  UINT#910;
            ELSIF TemplateTask_10steps_2.AbortTriggered()THEN
                Status.Action.Id :=  UINT#911;
                Status.Error.Id  :=  UINT#911;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#910,TemplateTask_10steps_2.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#911,TemplateTask_10steps_2.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 320 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#520, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#520;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
    
                IF _progress = 321 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#521, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#521;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                
                IF _progress = 322 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#522, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#522;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                
                IF _progress = 323 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#523, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#523;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                
                IF _progress = 324 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#524, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#524;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#525, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#525;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#526, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#526;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
                
                IF _progress = 327 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#527, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#527;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    END_IF;
                END_IF;
                
                IF _progress = 328 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#528, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#528;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 329;
                    END_IF;
                END_IF;
                
                IF _progress = 329 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_3.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_3.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_3.ThrowWhen(TemplateTask_10steps_3.Duration >= Config.ErrorTime ,'TemplateTask_10steps_3 error.');
            END_IF;
            IF TemplateTask_10steps_3.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_3.ErrorOccured() THEN
                Status.Action.Id :=  UINT#920;
                Status.Error.Id  :=  UINT#920;
            ELSIF TemplateTask_10steps_3.AbortTriggered()THEN
                Status.Action.Id :=  UINT#921;
                Status.Error.Id  :=  UINT#921;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#920,TemplateTask_10steps_3.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#921,TemplateTask_10steps_3.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 330 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#530, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#530;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
    
                IF _progress = 331 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#531, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#531;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#532, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#532;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;
                
                IF _progress = 333 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#533, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#533;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#534, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#534;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 335 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#535, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#535;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#536, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#536;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 337;
                    END_IF;
                END_IF;
                
                IF _progress = 337 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#537, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#537;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 338;
                    END_IF;
                END_IF;
                
                IF _progress = 338 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#538, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#538;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 339;
                    END_IF;
                END_IF;
                
                IF _progress = 339 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_4.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_4.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_4.ThrowWhen(TemplateTask_10steps_4.Duration >= Config.ErrorTime ,'TemplateTask_10steps_4 error.');
            END_IF;
            IF TemplateTask_10steps_4.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_4.ErrorOccured() THEN
                Status.Action.Id :=  UINT#930;
                Status.Error.Id  :=  UINT#930;
            ELSIF TemplateTask_10steps_4.AbortTriggered()THEN
                Status.Action.Id :=  UINT#931;
                Status.Error.Id  :=  UINT#931;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#930,TemplateTask_10steps_4.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#931,TemplateTask_10steps_4.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 340 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#540, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#540;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;
    
                IF _progress = 341 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#541, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#541;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#542, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#542;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#544, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#544;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#544, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#544;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    END_IF;
                END_IF;
                
                IF _progress = 345 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#545, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#545;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 346;
                    END_IF;
                END_IF;
                
                IF _progress = 346 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#546, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#546;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 347;
                    END_IF;
                END_IF;
                
                IF _progress = 347 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#547, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#547;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 348;
                    END_IF;
                END_IF;
                
                IF _progress = 348 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#548, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#548;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 349;
                    END_IF;
                END_IF;
                
                IF _progress = 349 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_5.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_5.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_5.ThrowWhen(TemplateTask_10steps_5.Duration >= Config.ErrorTime ,'TemplateTask_10steps_5 error.');
            END_IF;
            IF TemplateTask_10steps_5.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_5.ErrorOccured() THEN
                Status.Action.Id :=  UINT#940;
                Status.Error.Id  :=  UINT#940;
            ELSIF TemplateTask_10steps_5.AbortTriggered()THEN
                Status.Action.Id :=  UINT#941;
                Status.Error.Id  :=  UINT#941;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#940,TemplateTask_10steps_5.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#941,TemplateTask_10steps_5.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 350 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#550, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#550;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
    
                IF _progress = 351 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#551, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#551;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 352;
                    END_IF;
                END_IF;
                
                IF _progress = 352 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#552, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#552;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 353 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#553, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#553;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 354;
                    END_IF;
                END_IF;
                
                IF _progress = 354 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#554, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#554;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 355;
                    END_IF;
                END_IF;
                
                IF _progress = 355 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#555, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#555;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 356;
                    END_IF;
                END_IF;
                
                IF _progress = 356 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#556, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#556;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 357;
                    END_IF;
                END_IF;
                
                IF _progress = 357 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#557, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#557;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 358;
                    END_IF;
                END_IF;
                
                IF _progress = 358 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#558, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#558;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 359;
                    END_IF;
                END_IF;
                
                IF _progress = 359 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_6.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_6.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_6.ThrowWhen(TemplateTask_10steps_6.Duration >= Config.ErrorTime ,'TemplateTask_10steps_6 error.');
            END_IF;
            IF TemplateTask_10steps_6.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_6.ErrorOccured() THEN
                Status.Action.Id :=  UINT#950;
                Status.Error.Id  :=  UINT#950;
            ELSIF TemplateTask_10steps_6.AbortTriggered()THEN
                Status.Action.Id :=  UINT#951;
                Status.Error.Id  :=  UINT#951;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#950,TemplateTask_10steps_6.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#951,TemplateTask_10steps_6.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 360 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#560, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#560;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
    
                IF _progress = 361 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#561, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#561;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;
                
                IF _progress = 362 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#562, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#562;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;
                
                IF _progress = 363 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#563, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#563;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 364;
                    END_IF;
                END_IF;
                
                IF _progress = 364 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#564, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#564;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 365;
                    END_IF;
                END_IF;
                
                IF _progress = 365 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#565, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#565;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;
                
                IF _progress = 366 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#566, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#566;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 367;
                    END_IF;
                END_IF;
                
                IF _progress = 367 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#567, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#567;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 368;
                    END_IF;
                END_IF;
                
                IF _progress = 368 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#568, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#568;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 369;
                    END_IF;
                END_IF;
                
                IF _progress = 369 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 10>
                    TaskMessenger.ActivateOnCondition(ULINT#569, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#569;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 370;
                    END_IF;
                END_IF;
    
                IF _progress = 370 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 11>
                    TaskMessenger.ActivateOnCondition(ULINT#570, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#570;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;
    
                IF _progress = 371 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 12>
                    TaskMessenger.ActivateOnCondition(ULINT#571, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#571;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 372;
                    END_IF;
                END_IF;
                
                IF _progress = 372 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 13>
                    TaskMessenger.ActivateOnCondition(ULINT#572, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#572;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 373;
                    END_IF;
                END_IF;
                
                IF _progress = 373 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 14>
                    TaskMessenger.ActivateOnCondition(ULINT#573, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#573;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 374;
                    END_IF;
                END_IF;
                
                IF _progress = 374 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 15>
                    TaskMessenger.ActivateOnCondition(ULINT#574, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#574;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 375;
                    END_IF;
                END_IF;
                
                IF _progress = 375 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 16>
                    TaskMessenger.ActivateOnCondition(ULINT#575, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#575;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 376;
                    END_IF;
                END_IF;
                
                IF _progress = 376 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 17>
                    TaskMessenger.ActivateOnCondition(ULINT#576, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#576;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 377;
                    END_IF;
                END_IF;
                
                IF _progress = 377 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 18>
                    TaskMessenger.ActivateOnCondition(ULINT#577, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#577;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 378;
                    END_IF;
                END_IF;
                
                IF _progress = 378 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 19>
                    TaskMessenger.ActivateOnCondition(ULINT#578, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#578;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 379;
                    END_IF;
                END_IF;
                
                IF _progress = 379 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_1.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_1.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_1.ThrowWhen(TemplateTask_20steps_1.Duration >= Config.ErrorTime ,'TemplateTask_20steps_1 error.');
            END_IF;
            IF TemplateTask_20steps_1.DoneReached() THEN
                Status.Action.Id :=  UINT#161;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_1.ErrorOccured() THEN
                Status.Action.Id :=  UINT#960;
                Status.Error.Id  :=  UINT#960;
            ELSIF TemplateTask_20steps_1.AbortTriggered()THEN
                Status.Action.Id :=  UINT#961;
                Status.Error.Id  :=  UINT#961;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#960,TemplateTask_20steps_1.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#961,TemplateTask_20steps_1.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 380 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#580, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#580;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;
    
                IF _progress = 381 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#581, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#581;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#582, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#582;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#583, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#583;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;
                
                IF _progress = 384 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#584, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#584;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#585, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#585;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;
                
                IF _progress = 386 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#586, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#586;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#587, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#587;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                
                IF _progress = 388 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#588, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#588;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
                
                IF _progress = 389 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 10>
                    TaskMessenger.ActivateOnCondition(ULINT#589, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#589;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 390;
                    END_IF;
                END_IF;
    
                IF _progress = 390 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 11>
                    TaskMessenger.ActivateOnCondition(ULINT#590, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#590;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
    
                IF _progress = 391 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 12>
                    TaskMessenger.ActivateOnCondition(ULINT#591, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#591;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 13>
                    TaskMessenger.ActivateOnCondition(ULINT#592, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#592;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 393;
                    END_IF;
                END_IF;
                
                IF _progress = 393 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 14>
                    TaskMessenger.ActivateOnCondition(ULINT#593, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#593;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 394;
                    END_IF;
                END_IF;
                
                IF _progress = 394 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 15>
                    TaskMessenger.ActivateOnCondition(ULINT#594, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#594;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 395;
                    END_IF;
                END_IF;
                
                IF _progress = 395 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 16>
                    TaskMessenger.ActivateOnCondition(ULINT#595, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#595;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 396;
                    END_IF;
                END_IF;
                
                IF _progress = 396 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 17>
                    TaskMessenger.ActivateOnCondition(ULINT#596, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#596;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 397;
                    END_IF;
                END_IF;
                
                IF _progress = 397 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 18>
                    TaskMessenger.ActivateOnCondition(ULINT#597, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#597;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 398;
                    END_IF;
                END_IF;
                
                IF _progress = 398 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 19>
                    TaskMessenger.ActivateOnCondition(ULINT#598, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#598;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 399;
                    END_IF;
                END_IF;
                
                IF _progress = 399 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_2.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_2.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_2.ThrowWhen(TemplateTask_20steps_2.Duration >= Config.ErrorTime ,'TemplateTask_20steps_2 error.');
            END_IF;
            IF TemplateTask_20steps_2.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_2.ErrorOccured() THEN
                Status.Action.Id :=  UINT#980;
                Status.Error.Id  :=  UINT#980;
            ELSIF TemplateTask_20steps_2.AbortTriggered()THEN
                Status.Action.Id :=  UINT#981;
                Status.Error.Id  :=  UINT#981;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#980,TemplateTask_20steps_2.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#981,TemplateTask_20steps_2.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 400 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#600;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 401;
                    END_IF;
                END_IF;
    
                IF _progress = 401 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#601;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#602, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#602;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#603, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#603;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 404;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#604, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#604;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 405;
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#605, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#605;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#606, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#606;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#607, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#607;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#608, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#608;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 10>
                    TaskMessenger.ActivateOnCondition(ULINT#609, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#609;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 410;
                    END_IF;
                END_IF;
    
                IF _progress = 410 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 11>
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#610;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 411;
                    END_IF;
                END_IF;
    
                IF _progress = 411 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 12>
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#611;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 13>
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#612;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 14>
                    TaskMessenger.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#613;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 15>
                    TaskMessenger.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#614;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 16>
                    TaskMessenger.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#615;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 17>
                    TaskMessenger.ActivateOnCondition(ULINT#616, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#616;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 18>
                    TaskMessenger.ActivateOnCondition(ULINT#617, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#617;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 19>
                    TaskMessenger.ActivateOnCondition(ULINT#618, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#618;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 419;
                    END_IF;
                END_IF;
                
                IF _progress = 419 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_3.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_3.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_3.ThrowWhen(TemplateTask_20steps_3.Duration >= Config.ErrorTime ,'TemplateTask_20steps_3 error.');
            END_IF;
            IF TemplateTask_20steps_3.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_3.ErrorOccured() THEN
                Status.Action.Id :=  UINT#1000;
                Status.Error.Id  :=  UINT#1000;
            ELSIF TemplateTask_20steps_3.AbortTriggered()THEN
                Status.Action.Id :=  UINT#1001;
                Status.Error.Id  :=  UINT#1001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#1000,TemplateTask_20steps_3.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#1001,TemplateTask_20steps_3.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 420 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#620, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#620;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 421;
                    END_IF;
                END_IF;
    
                IF _progress = 421 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#621, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#621;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 422;
                    END_IF;
                END_IF;
                
                IF _progress = 422 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#622, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#622;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 423;
                    END_IF;
                END_IF;
                
                IF _progress = 423 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#623, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#623;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 424;
                    END_IF;
                END_IF;
                
                IF _progress = 424 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#624, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#624;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 425;
                    END_IF;
                END_IF;
                
                IF _progress = 425 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#625, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#625;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 426;
                    END_IF;
                END_IF;
                
                IF _progress = 426 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#626, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#626;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 427;
                    END_IF;
                END_IF;
                
                IF _progress = 427 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#627, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#627;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 428;
                    END_IF;
                END_IF;
                
                IF _progress = 428 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#628, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#628;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 429;
                    END_IF;
                END_IF;
                
                IF _progress = 429 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 10>
                    TaskMessenger.ActivateOnCondition(ULINT#629, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#629;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 430;
                    END_IF;
                END_IF;
    
                IF _progress = 430 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 11>
                    TaskMessenger.ActivateOnCondition(ULINT#630, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#630;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 431;
                    END_IF;
                END_IF;
    
                IF _progress = 431 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 12>
                    TaskMessenger.ActivateOnCondition(ULINT#631, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#631;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 432;
                    END_IF;
                END_IF;
                
                IF _progress = 432 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 13>
                    TaskMessenger.ActivateOnCondition(ULINT#632, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#632;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 433;
                    END_IF;
                END_IF;
                
                IF _progress = 433 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 14>
                    TaskMessenger.ActivateOnCondition(ULINT#633, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#633;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 434;
                    END_IF;
                END_IF;
                
                IF _progress = 434 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 15>
                    TaskMessenger.ActivateOnCondition(ULINT#634, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#634;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 435;
                    END_IF;
                END_IF;
                
                IF _progress = 435 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 16>
                    TaskMessenger.ActivateOnCondition(ULINT#635, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#635;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 436;
                    END_IF;
                END_IF;
                
                IF _progress = 436 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 17>
                    TaskMessenger.ActivateOnCondition(ULINT#636, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#636;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 437;
                    END_IF;
                END_IF;
                
                IF _progress = 437 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 18>
                    TaskMessenger.ActivateOnCondition(ULINT#637, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#637;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 438;
                    END_IF;
                END_IF;
                
                IF _progress = 438 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 19>
                    TaskMessenger.ActivateOnCondition(ULINT#638, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#638;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 439;
                    END_IF;
                END_IF;
                
                IF _progress = 439 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_4.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_4.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_4.ThrowWhen(TemplateTask_20steps_4.Duration >= Config.ErrorTime ,'TemplateTask_20steps_4 error');
            END_IF;
            IF TemplateTask_20steps_4.DoneReached() THEN
                Status.Action.Id :=  UINT#221;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_4.ErrorOccured() THEN
                Status.Action.Id :=  UINT#1020;
                Status.Error.Id  :=  UINT#1020;
            ELSIF TemplateTask_20steps_4.AbortTriggered()THEN
                Status.Action.Id :=  UINT#1021;
                Status.Error.Id  :=  UINT#1021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#1020,TemplateTask_20steps_4.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#1021,TemplateTask_20steps_4.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 440 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#640, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#640;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 441;
                    END_IF;
                END_IF;
    
                IF _progress = 441 THEN                                                                                     // TemplateTask_20steps_5 running , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#641, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#641;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 442;
                    END_IF;
                END_IF;
                
                IF _progress = 442 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#642, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#642;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 443;
                    END_IF;
                END_IF;
                
                IF _progress = 443 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#643, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#643;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 444;
                    END_IF;
                END_IF;
                
                IF _progress = 444 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#644, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#644;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 445;
                    END_IF;
                END_IF;
                
                IF _progress = 445 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#645, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#645;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 446;
                    END_IF;
                END_IF;
                
                IF _progress = 446 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#646, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#646;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 447;
                    END_IF;
                END_IF;
                
                IF _progress = 447 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#647, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#647;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 448;
                    END_IF;
                END_IF;
                
                IF _progress = 448 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#648, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#648;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 449;
                    END_IF;
                END_IF;
                
                IF _progress = 449 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 10>
                    TaskMessenger.ActivateOnCondition(ULINT#649, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#649;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 450;
                    END_IF;
                END_IF;
    
                IF _progress = 450 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 11>
                    TaskMessenger.ActivateOnCondition(ULINT#650, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#650;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 451;
                    END_IF;
                END_IF;
    
                IF _progress = 451 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 12>
                    TaskMessenger.ActivateOnCondition(ULINT#651, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#651;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 452;
                    END_IF;
                END_IF;
                
                IF _progress = 452 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 13>
                    TaskMessenger.ActivateOnCondition(ULINT#652, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#652;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 453;
                    END_IF;
                END_IF;
                
                IF _progress = 453 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 14>
                    TaskMessenger.ActivateOnCondition(ULINT#653, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#653;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 454;
                    END_IF;
                END_IF;
                
                IF _progress = 454 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 15>
                    TaskMessenger.ActivateOnCondition(ULINT#654, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#654;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 455;
                    END_IF;
                END_IF;
                
                IF _progress = 455 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 16>
                    TaskMessenger.ActivateOnCondition(ULINT#655, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#655;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 456;
                    END_IF;
                END_IF;
                
                IF _progress = 456 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 17>
                    TaskMessenger.ActivateOnCondition(ULINT#656, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#656;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 457;
                    END_IF;
                END_IF;
                
                IF _progress = 457 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 18>
                    TaskMessenger.ActivateOnCondition(ULINT#657, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#657;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 458;
                    END_IF;
                END_IF;
                
                IF _progress = 458 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 19>
                    TaskMessenger.ActivateOnCondition(ULINT#658, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#658;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 459;
                    END_IF;
                END_IF;
                
                IF _progress = 459 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_5.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_5.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_5.ThrowWhen(TemplateTask_20steps_5.Duration >= Config.ErrorTime ,'TemplateTask_20steps_5 error.');
            END_IF;
            IF TemplateTask_20steps_5.DoneReached() THEN
                Status.Action.Id :=  UINT#241;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_5.ErrorOccured() THEN
                Status.Action.Id :=  UINT#1040;
                Status.Error.Id  :=  UINT#1040;
            ELSIF TemplateTask_20steps_5.AbortTriggered()THEN
                Status.Action.Id :=  UINT#1041;
                Status.Error.Id  :=  UINT#1041;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#1040,TemplateTask_20steps_5.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#1041,TemplateTask_20steps_5.IsAborted(), eAxoMessageCategory#Error);
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
    
                IF _progress = 460 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 1>
                    TaskMessenger.ActivateOnCondition(ULINT#660, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#660;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 461;
                    END_IF;
                END_IF;
    
                IF _progress = 461 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 2>
                    TaskMessenger.ActivateOnCondition(ULINT#661, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#661;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 462;
                    END_IF;
                END_IF;
                
                IF _progress = 462 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 3>
                    TaskMessenger.ActivateOnCondition(ULINT#662, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#662;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 463;
                    END_IF;
                END_IF;
                
                IF _progress = 463 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 4>
                    TaskMessenger.ActivateOnCondition(ULINT#663, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#663;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 464;
                    END_IF;
                END_IF;
                
                IF _progress = 464 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 5>
                    TaskMessenger.ActivateOnCondition(ULINT#664, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#664;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 465;
                    END_IF;
                END_IF;
                
                IF _progress = 465 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 6>
                    TaskMessenger.ActivateOnCondition(ULINT#665, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#665;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 466;
                    END_IF;
                END_IF;
                
                IF _progress = 466 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 7>
                    TaskMessenger.ActivateOnCondition(ULINT#666, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#666;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 467;
                    END_IF;
                END_IF;
                
                IF _progress = 467 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 8>
                    TaskMessenger.ActivateOnCondition(ULINT#667, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#667;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 468;
                    END_IF;
                END_IF;
                
                IF _progress = 468 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 9>
                    TaskMessenger.ActivateOnCondition(ULINT#668, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#668;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 469;
                    END_IF;
                END_IF;
                
                IF _progress = 469 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 10>
                    TaskMessenger.ActivateOnCondition(ULINT#669, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#669;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 470;
                    END_IF;
                END_IF;
    
                IF _progress = 470 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 11>
                    TaskMessenger.ActivateOnCondition(ULINT#670, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#670;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 471;
                    END_IF;
                END_IF;
    
                IF _progress = 471 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 12>
                    TaskMessenger.ActivateOnCondition(ULINT#671, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#671;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 472;
                    END_IF;
                END_IF;
                
                IF _progress = 472 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 13>
                    TaskMessenger.ActivateOnCondition(ULINT#672, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#672;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 473;
                    END_IF;
                END_IF;
                
                IF _progress = 473 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 14>
                    TaskMessenger.ActivateOnCondition(ULINT#673, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#673;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 474;
                    END_IF;
                END_IF;
                
                IF _progress = 474 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 15>
                    TaskMessenger.ActivateOnCondition(ULINT#674, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#674;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 475;
                    END_IF;
                END_IF;
                
                IF _progress = 475 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 16>
                    TaskMessenger.ActivateOnCondition(ULINT#675, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#675;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 476;
                    END_IF;
                END_IF;
                
                IF _progress = 476 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 17>
                    TaskMessenger.ActivateOnCondition(ULINT#676, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#676;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 477;
                    END_IF;
                END_IF;
                
                IF _progress = 477 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 18>
                    TaskMessenger.ActivateOnCondition(ULINT#677, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#677;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 478;
                    END_IF;
                END_IF;
                
                IF _progress = 478 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 19>
                    TaskMessenger.ActivateOnCondition(ULINT#678, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#678;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 479;
                    END_IF;
                END_IF;
                
                IF _progress = 479 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_6.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_6.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_6.ThrowWhen(TemplateTask_20steps_6.Duration >= Config.ErrorTime ,'TemplateTask_20steps_6 error.');
            END_IF;
            IF TemplateTask_20steps_6.DoneReached() THEN
                Status.Action.Id :=  UINT#261;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_6.ErrorOccured() THEN
                Status.Action.Id :=  UINT#1060;
                Status.Error.Id  :=  UINT#1060;
            ELSIF TemplateTask_20steps_6.AbortTriggered()THEN
                Status.Action.Id :=  UINT#1061;
                Status.Error.Id  :=  UINT#1061;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#1060,TemplateTask_20steps_6.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#1061,TemplateTask_20steps_6.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#262,TemplateTask_20steps_6.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_6.RestoreTriggered() AND _progress >= 460 AND _progress <= 479  THEN
                Status.Action.Id :=  UINT#262;
                _progress := 0;
            END_IF;
            //******************************************      


            //***********Update outputs ****************
			
			retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_System),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
			
			CASE CameraNo OF
				UINT#1:
					outputsAddress := outputsAddress + UDINT#4;
					BitOffset := 0;
		
				UINT#2:
					outputsAddress := outputsAddress + UDINT#4;
					BitOffset := 4;
		
				UINT#3:
					outputsAddress := outputsAddress + UDINT#5;
					BitOffset := 0;
		
				UINT#4:
					outputsAddress := outputsAddress + UDINT#5;
					BitOffset := 4;
		
				UINT#5:
					outputsAddress := outputsAddress + UDINT#6;
					BitOffset := 0;
		
				UINT#6:
					outputsAddress := outputsAddress + UDINT#6;
					BitOffset := 4;
		
				UINT#7:
					outputsAddress := outputsAddress + UDINT#7;
					BitOffset := 0;
		
				UINT#8:
					outputsAddress := outputsAddress + UDINT#8;
					BitOffset := 4;
			END_CASE;
			
			WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := BitOffset, value:= Outputs.Control.SoftEvent.Reset);
			WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := BitOffset + INT#1, value:= Outputs.Control.SoftEvent.DataHandlerAck);
			WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := BitOffset + INT#2, value:= Outputs.Control.SoftEvent.Trigger);
			WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := BitOffset + INT#3, value:= Outputs.Control.SoftEvent.Reserve);
			
			
			
			IF (Inputs.Status.ReadDataLockerJobID = Config.CameraNo) THEN
				retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_System),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
				WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#4, value:= Outputs.Control.InitiateJobLoad );
				
                _tmpWord := TO_WORD(Outputs.Control.JobLoadID);
				WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2, value:= _tmpWord);

                retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_Engine_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
		        WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#1, value:= Outputs.Control.InspectionResultsAck);
			END_IF;


			IF  (Inputs.Status.UserDataLockerJobID = Config.CameraNo) THEN
				retValRdAddr := ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_Engine_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
				WriteMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#3, value:= Outputs.Control.SetUserdata);
			END_IF;

			// -   User Data [20-1400]: Spolocny buffer pre user data. Vyuziva sa vzdy cely buffer (v jednom CASE moze pristupovat len jedna inspekcia).
			//     o   Byte[0]: cislo inspekcie (camera*10 + ( 0 az 9)), pre ktore su aktualne data v bufferi platne
			//     o   Byte[1]: typ spracovania dat (0 = Undefined, 1 = Zmena jobu/referencie, )
			//     o   Byte[2]: cislo jobu
			//     o   Byte[3-??]: id kusu
           
            (* 
            // _data_out_1[0].%X1                  :=      AxoVisionProOutputStructure_hwID_11.Item1;
            // _data_out_1[0].%X2                  :=      AxoVisionProOutputStructure_hwID_11.Item2;
            // _data_out_1[0].%X3                  :=      AxoVisionProOutputStructure_hwID_11.Item1;
            // _data_out_1[0].%X4                  :=      AxoVisionProOutputStructure_hwID_11.Item2;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_User_Data_64_bytes_1,_data_out_1);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#871, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#871;
                RETURN;
            END_IF;
            

            // _data_out_1[0].%X1                  :=      AxoVisionProOutputStructure_hwID_12.Item1;
            // _data_out_1[0].%X2                  :=      AxoVisionProOutputStructure_hwID_12.Item2;
            // _data_out_1[0].%X3                  :=      AxoVisionProOutputStructure_hwID_12.Item1;
            // _data_out_1[0].%X4                  :=      AxoVisionProOutputStructure_hwID_12.Item2;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_Results_240_bytes_1,_data_out_1);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#872, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#872;
                RETURN;
            END_IF;

            // _data_out_4[1]                     :=      TO_WORD(AxoVisionProOutputStructure_hwID_13.Item1).%B0;
            // _data_out_4[0]                     :=      TO_WORD(AxoVisionProOutputStructure_hwID_13.Item1).%B1;
            // _data_out_4[3]                     :=      TO_WORD(AxoVisionProOutputStructure_hwID_13.Item2).%B0;
            // _data_out_4[2]                     :=      TO_WORD(AxoVisionProOutputStructure_hwID_13.Item2).%B1;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_Results_240_bytes_2,_data_out_4);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#873, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#873;
                RETURN;
            END_IF;

            // _data_out_8[3]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_14.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_14.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_14.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_14.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_14.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_14.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_14.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_14.Item2).%B3;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_Results_240_bytes_3,_data_out_8);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#874, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#874;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_15.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_15.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_15.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_15.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_15.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_15.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_15.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_15.Item2).%B3;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_Results_240_bytes_4,_data_out_8);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#875, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#875;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_16.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_16.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_16.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_16.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_16.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_16.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_16.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_16.Item2).%B3;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_Results_240_bytes_5,_data_out_8);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#876, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#876;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_17.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_17.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_17.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_17.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_17.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_17.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_17.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_17.Item2).%B3;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_Results_64_bytes_1,_data_out_8);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#877, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#877;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_18.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_18.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_18.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_18.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_18.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_18.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_18.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_18.Item2).%B3;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_18,_data_out_8);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#878, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#878;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_19.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_19.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_19.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_19.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_19.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_19.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_19.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_19.Item2).%B3;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_19,_data_out_8);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#879, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#879;
                RETURN;
            END_IF;
            
            // _data_out_8[3]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_20.Item1).%B0;
            // _data_out_8[2]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_20.Item1).%B1;
            // _data_out_8[1]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_20.Item1).%B2;
            // _data_out_8[0]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_20.Item1).%B3;
            // _data_out_8[7]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_20.Item2).%B0;
            // _data_out_8[6]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_20.Item2).%B1;
            // _data_out_8[5]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_20.Item2).%B2;
            // _data_out_8[4]                     :=      TO_DWORD(AxoVisionProOutputStructure_hwID_20.Item2).%B3;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwID_20,_data_out_8);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#880, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#880;
                RETURN;
            END_IF;
            *)
            //******************************************      

        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_1 : IAxoTaskState
            TemplateMethod_10steps_1 := HardResetAllCamerasTask.Invoke(THIS);
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
            _returnValue    :=   WORD#0;

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


            HardResetAllCamerasTask.Restore();
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
            
            _infoTimer.OnDelay(THIS, signal ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal , Config.ErrorTime);
        END_METHOD

    END_CLASS
END_NAMESPACE
