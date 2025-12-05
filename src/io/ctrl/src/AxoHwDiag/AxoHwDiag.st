USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;
USING Siemens.Simatic.Diagnostics.Hardware;

NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoHwDiag EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader("")]}
            {#ix-set:AttributeName = "<#UpdateDiagnostics#>"}
            UpdateDiagnosticTask : AXOpen.Core.AxoTask;            
            {#ix-attr:[ComponentHeader("")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentHeader("")]}
            {#ix-attr:[ReadOnly()]}
            Progress       :   INT;
        END_VAR

        VAR PUBLIC // DIAGNOSTIC SUBSYSTEM
            {#ix-attr:[ComponentDetails("Diagnostics")]}
            {#ix-attr:[ReadOnly()]}
            AxoHwDiagDetails : AxoHwDiagDetails;
        END_VAR


        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoHwDiag_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoHwDiag_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PRIVATE
            _progress       :   INT;
            _infoTimer      :   AXOpen.Timers.OnDelayTimer;
            _errorTimer     :   AXOpen.Timers.OnDelayTimer;

            _initCheckDone          :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
 
            _blink                  :   AXOpen.Timers.AxoBlinker;   
 
            _loIndex                :   INT := -1;
            _hiIndex                :   INT := -1;
            _currentHwID            :   UINT;
            _currentIndex           :   INT := -1;
            _plcIndex               :   INT := -1;
            _plcHwId                :   UINT;
            _ioSystemIndex          :   INT := -1;
            _ioSystemHwId           :   UINT;
            _ioSystemNumber         :   UINT;
            _stationIndex           :   INT := -1;
            _stationHwId            :   UINT;
            _stationNumber          :   UINT;
            _moduleIndex            :   INT := -1;
            _moduleHwId             :   UINT;
            _slotNumber             :   UINT;
            _subModuleIndex         :   INT := -1;
            _subModuleHwId          :   UINT;
            _subSlotNumber          :   UINT;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent    :   IAxoObject;
                hwIDsList   :   ARRAY[*] OF UINT;
            END_VAR
            VAR
                diagSubInfo : Siemens.Simatic.Diagnostics.Hardware.SubordinateDiagnosticDetails;            
                diagInfo : Siemens.Simatic.Diagnostics.Hardware.DiagnosticDetails;            
            END_VAR

            SUPER.Run(inParent);

            Messenger.Serve(THIS);
            
            Progress := _progress;

            IF NOT _initCheckDone THEN
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                IF LOWER_BOUND(hwIDsList,1) <> DINT#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;

                _loIndex    :=  TO_INT(LOWER_BOUND(hwIDsList,1));
                _hiIndex    :=  TO_INT(UPPER_BOUND(hwIDsList,1));
    
                IF _hiIndex - _loIndex <= INT#1 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                _initCheckDone    := TRUE;
            END_IF;            
          
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            UpdateDiagnosticTask.Run(THIS);

            //****************************************
    
   
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
            

            //*************UpdateDiagnosticTask***************
            UpdateDiagnosticTask.SetIsDisabled(FALSE);
            IF UpdateDiagnosticTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,UpdateDiagnosticTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,UpdateDiagnosticTask.IsDone(), eAxoMessageCategory#Info);
            IF UpdateDiagnosticTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                // UpdateDiagnosticTask running: , waiting for the accessibility to the HwIdList
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
                        
                    _plcIndex               :=   INT#-1;
                    _plcHwId                :=   UINT#0;
                    _ioSystemIndex          :=   INT#-1;
                    _ioSystemHwId           :=   UINT#0;
                    _ioSystemNumber         :=   UINT#0;
                    _stationIndex           :=   INT#-1;
                    _stationHwId            :=   UINT#0;
                    _stationNumber          :=   UINT#0;
                    _moduleIndex            :=   INT#-1;
                    _moduleHwId             :=   UINT#0;
                    _slotNumber             :=   UINT#0;
                    _subModuleIndex         :=   INT#-1;
                    _subModuleHwId          :=   UINT#0;
                    _subSlotNumber          :=   UINT#0;

                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.HardwareID                                   :=  UINT#0;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode                     :=  GetDiagnosticsReturnCode#Unknown;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateState                             :=  ComponentState#Unknown;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Good                      :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Disabled                  :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired       :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded       :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Error                     :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible             :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable      :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable        :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.NetworkError              :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.HardwareError             :=  FALSE;
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.DiagnosticsEnabled                           :=  FALSE;    
    
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.HardwareID                              :=  UINT#0;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode                :=  GetDiagnosticsReturnCode#Unknown;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateState                        :=  ComponentState#Unknown;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.Good                 :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.Disabled             :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired  :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded  :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.Error                :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible        :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable   :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.NetworkError         :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.HardwareError        :=  FALSE;
                    AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.DiagnosticsEnabled                      :=  FALSE;    

                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.HardwareID                               :=  UINT#0;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode                 :=  GetDiagnosticsReturnCode#Unknown;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateState                         :=  ComponentState#Unknown;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Good                  :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Disabled              :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired   :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded   :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Error                 :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible         :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable  :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable    :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.NetworkError          :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.HardwareError         :=  FALSE;
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.DiagnosticsEnabled                       :=  FALSE;    

                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.HardwareID                                :=  UINT#0;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode                  :=  GetDiagnosticsReturnCode#Unknown;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateState                          :=  ComponentState#Unknown;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  FALSE;
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;    

                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.HardwareID                             :=  UINT#0;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode               :=  GetDiagnosticsReturnCode#Unknown;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateState                       :=  ComponentState#Unknown;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Good                :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Disabled            :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Error               :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible       :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable:=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable  :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.NetworkError        :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.HardwareError       :=  FALSE;
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.DiagnosticsEnabled                     :=  FALSE;    

                    IF _currentIndex = -1 THEN
                        _currentIndex := 0;
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering PLC-ReadSlotFromHardwareID running
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
    
                    _currenthwID    := hwIDsList[_currentIndex];                                                      
                    _retval := ReadSlotFromHardwareID(hardwareID := _currenthwID, geoAddr :=_geoAddr);  
                    IF _retval = WORD#0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    ELSIF _retval = WORD#16#8090 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering PLC-comparing GeoAddr details
                IF _progress = 302 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;
    
                    IF _geoAddr.HardwareType = UINT#2 AND _geoAddr.AreaID = UINT#0 AND _geoAddr.IOSystem = UINT#0 AND
                        _geoAddr.Station = UINT#0 AND _geoAddr.Slot = UINT#0 AND _geoAddr.Subslot = UINT#0 THEN
                        _plcHwId    :=  _currentHwID;
                        _plcIndex   :=  _currentIndex;
                        _currentIndex := _currentIndex + 1;
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering PLC-check maximal index
                IF _progress = 303 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#503;
                    END_IF;

                    _currentIndex := _currentIndex + 1;

                    IF _currentIndex > _hiIndex THEN
                        UpdateDiagnosticTask.ThrowWhen(TRUE);
                        _currentIndex := -1;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress - 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , cleaning all diagnostics results
                IF _progress = 304 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#504;
                    END_IF;
                   IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the PLC system
                IF _progress = 305 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#505;
                    END_IF;

                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_plcHwId, diagInfo);
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.HardwareID                :=  _plcHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateState                          :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress + 1; // Continue checking subordinary system  
                        ELSE     
                            _progress := 330;           // Jump to the end as the PLC itself has an issue
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the PLC sub system
                IF _progress = 306 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#506, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#506;
                    END_IF;

                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_plcHwId, diagSubInfo);
                    AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.HardwareID                :=  _plcHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := 340;   // TODO jump to the end, as no error is present on PLC itself nor in lower level component
                        ELSE     
                            _progress := 307;
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering IoSystem-ReadSlotFromHardwareID running
                IF _progress = 307 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#507, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#507;
                    END_IF;
    
                    _currenthwID    := hwIDsList[_currentIndex];                                                      
                    _retval := ReadSlotFromHardwareID(hardwareID := _currenthwID, geoAddr :=_geoAddr);  
                    IF _retval = WORD#0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    ELSIF _retval = WORD#16#8090 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering IoSystem-comparing GeoAddr details
                IF _progress = 308 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#508, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#508;
                    END_IF;
    
                    IF _geoAddr.HardwareType = UINT#1 AND _geoAddr.AreaID >= UINT#1 AND _geoAddr.AreaID <= UINT#3 AND
                        _geoAddr.Station = UINT#0 AND _geoAddr.Slot = UINT#0 AND _geoAddr.Subslot = UINT#0 THEN
                        _ioSystemHwId    :=  _currentHwID;
                        _ioSystemIndex   :=  _currentIndex;
                        _ioSystemNumber  :=  _geoAddr.IOSystem;
                        _currentIndex := _currentIndex + 1;
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering IoSystem-check maximal index
                IF _progress = 309 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#509, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#509;
                    END_IF;

                    _currentIndex := _currentIndex + 1;

                    IF _currentIndex > _hiIndex THEN
                        UpdateDiagnosticTask.ThrowWhen(TRUE);
                        _currentIndex := -1;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress - 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the IoSystem system
                IF _progress = 310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
    
                    AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_ioSystemHwId, diagInfo);
                    AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.HardwareID                :=  _ioSystemHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateState                          :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress + 1; // Continue checking subordinary system  
                        ELSE     
                            _progress := 330;           // Jump to the end as the IoSystem itself has an issue
                        END_IF;
                    END_IF;
                END_IF;                
                // UpdateDiagnosticTask running: , get diagnostics of the IoSystem sub system
                IF _progress = 311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;
    
                    AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_ioSystemHwId, diagSubInfo);
                    AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.HardwareID                :=  _ioSystemHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.IoSystemSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress - 4;   // Continue searching the next IOsystem as current one does not contain any error nor any of its subordinary items
                        ELSE     
                            _progress := _progress + 1;
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Station-ReadSlotFromHardwareID running
                IF _progress = 312 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    _currenthwID    := hwIDsList[_currentIndex];                                                      
                    _retval := ReadSlotFromHardwareID(hardwareID := _currenthwID, geoAddr :=_geoAddr);  
                    IF _retval = WORD#0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    ELSIF _retval = WORD#16#8090 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Station-comparing GeoAddr details
                IF _progress = 313 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    IF _geoAddr.HardwareType = UINT#2 AND _geoAddr.AreaID = UINT#1 AND _geoAddr.IOSystem = _ioSystemNumber AND
                        _geoAddr.Station > UINT#0 AND _geoAddr.Slot = UINT#0 AND _geoAddr.Subslot = UINT#0 THEN
                        _stationHwId    :=  _currentHwID;
                        _stationIndex   :=  _currentIndex;
                        _stationNumber  :=  _geoAddr.Station;
                        _currentIndex := _currentIndex + 1;
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Station-check maximal index
                IF _progress = 314 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#514;
                    END_IF;
    
                    _currentIndex := _currentIndex + 1;

                    IF _currentIndex > _hiIndex THEN
                        UpdateDiagnosticTask.ThrowWhen(TRUE);
                        _currentIndex := -1;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress - 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the Station system               
                IF _progress = 315 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#515;
                    END_IF;
    
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_stationHwId, diagInfo);
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.HardwareID                :=  _stationHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateState                          :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress + 1; // Continue checking subordinary system  
                        ELSE     
                            _progress := 330;           // Jump to the end as the Station itself has an issue
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the Station sub system               
                IF _progress = 316 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#516;
                    END_IF;
    
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_stationHwId, diagSubInfo);
                    AxoHwDiagDetails.StationSubSystemDiagnosticDetails.HardwareID                :=  _stationHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.StationSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress - 4;   // Continue searching the next Station as current one does not contain any error nor any of its subordinary items
                        ELSE     
                            _progress := _progress + 1;
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Module-ReadSlotFromHardwareID running
                IF _progress = 317 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#517;
                    END_IF;
    
                    _currenthwID    := hwIDsList[_currentIndex];                                                      
                    _retval := ReadSlotFromHardwareID(hardwareID := _currenthwID, geoAddr :=_geoAddr);  
                    IF _retval = WORD#0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    ELSIF _retval = WORD#16#8090 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Module-comparing GeoAddr details
                IF _progress = 318 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#518;
                    END_IF;
    
                    IF _geoAddr.HardwareType = UINT#4 AND _geoAddr.AreaID = UINT#1 AND _geoAddr.IOSystem = _ioSystemNumber AND
                        _geoAddr.Station=_stationNumber AND _geoAddr.Slot > UINT#0 AND _geoAddr.Subslot = UINT#0 THEN
                        _moduleHwId    :=  _currentHwID;
                        _moduleIndex   :=  _currentIndex;
                        _slotNumber  :=  _geoAddr.Slot;
                        _currentIndex := _currentIndex + 1;
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Module-check maximal index
                IF _progress = 319 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#519, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#519;
                    END_IF;

                    _currentIndex := _currentIndex + 1;

                    IF _currentIndex > _hiIndex THEN
                        UpdateDiagnosticTask.ThrowWhen(TRUE);
                        _currentIndex := -1;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress - 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the Module system               
                IF _progress = 320 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#520;
                    END_IF;
    
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_moduleHwId, diagInfo);
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.HardwareID                :=  _moduleHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateState                          :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  false;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress + 1; // Continue checking subordinary system  
                        ELSE     
                            _progress := 330;           // Jump to the end as the Module itself has an issue
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the Module sub system               
                IF _progress = 321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;
    
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_moduleHwId, diagSubInfo);
                    AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.HardwareID                :=  _moduleHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress - 4;   // Continue searching the next Module as current one does not contain any error nor any of its subordinary items
                        ELSE     
                            _progress := _progress + 1;
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Submodule-ReadSlotFromHardwareID running
                IF _progress = 322 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#522;
                    END_IF;
    
                    _currenthwID    := hwIDsList[_currentIndex];                                                      
                    _retval := ReadSlotFromHardwareID(hardwareID := _currenthwID, geoAddr :=_geoAddr);  
                    IF _retval = WORD#0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    ELSIF _retval = WORD#16#8090 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Submodule-comparing GeoAddr details
                IF _progress = 323 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#523;
                    END_IF;
    
                    IF _geoAddr.HardwareType = UINT#5 AND _geoAddr.AreaID = UINT#1 AND _geoAddr.IOSystem = _ioSystemNumber AND
                        _geoAddr.Station=_stationNumber AND _geoAddr.Slot = _slotNumber AND _geoAddr.Subslot > UINT#0 THEN
                        _submoduleHwId    :=  _currentHwID;
                        _submoduleIndex   :=  _currentIndex;
                        _subSlotNumber  :=  _geoAddr.Subslot;
                        _currentIndex := _currentIndex + 1;
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering Submodule-check maximal index
                IF _progress = 324 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#524;
                    END_IF;

                    _currentIndex := _currentIndex + 1;

                    IF _currentIndex > _hiIndex THEN
                        return;
                        UpdateDiagnosticTask.ThrowWhen(TRUE);
                        _currentIndex := -1;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := _progress - 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the Submodule system               
                IF _progress = 325 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
    
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_moduleHwId, diagInfo);
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.HardwareID                :=  _submoduleHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateState                          :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  false;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress + 1; // Continue checking subordinary system  
                        ELSE     
                            _progress := 330;           // Jump to the end as the SubModule itself has an issue
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the SubModule sub system               
                IF _progress = 326 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#526;
                    END_IF;
    
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_moduleHwId, diagSubInfo);
                    AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.HardwareID                :=  _submoduleHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            _progress := _progress - 4;   // Continue searching the next SubModule as current one does not contain any error nor any of its subordinary items
                        ELSE     
                            _progress := _progress + 1;
                        END_IF;
                    END_IF;
                END_IF;

                IF _progress = 327 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#527;
                    END_IF;
                    // Should never get into this step
                END_IF;
                
                IF _progress = 330 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#530;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 340;
                    END_IF;
                END_IF;
                
                IF _progress = 340 THEN
                    UpdateDiagnosticTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                UpdateDiagnosticTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                UpdateDiagnosticTask.ThrowWhen(UpdateDiagnosticTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'UpdateDiagnosticTask timeout.');                
            END_IF;
            IF UpdateDiagnosticTask.DoneReached() THEN
                _currentIndex := -1;
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF UpdateDiagnosticTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF UpdateDiagnosticTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,UpdateDiagnosticTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,UpdateDiagnosticTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,UpdateDiagnosticTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF UpdateDiagnosticTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 379  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            IF UpdateDiagnosticTask.RestoreTriggered() THEN
                THIS.Restore();
            END_IF;            
            //**************************************************            
        END_METHOD

        METHOD PUBLIC UpdateDiagnostic : IAxoTaskState
            UpdateDiagnostic := UpdateDiagnosticTask.Invoke(THIS);
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

            UpdateDiagnosticTask.Restore();

            // HardwareDiagnosticsTask.Restore();

            Status.Action.Id := UINT#50;
            RestoreTask.DoneWhen(TRUE);
            _plcIndex               :=   INT#-1;
            _plcHwId                :=   UINT#0;
            _ioSystemIndex          :=   INT#-1;
            _ioSystemHwId           :=   UINT#0;
            _ioSystemNumber         :=   UINT#0;
            _stationIndex           :=   INT#-1;
            _stationHwId            :=   UINT#0;
            _stationNumber          :=   UINT#0;
            _moduleIndex            :=   INT#-1;
            _moduleHwId             :=   UINT#0;
            _slotNumber             :=   UINT#0;
            _subModuleIndex         :=   INT#-1;
            _subModuleHwId          :=   UINT#0;
            _subSlotNumber          :=   UINT#0;

            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.HardwareID                                :=  UINT#0;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.GetDiagnosticsReturnCode                  :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateState                          :=  ComponentState#Unknown;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  FALSE;
            AxoHwDiagDetails.PLCSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;    

            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.HardwareID                                :=  UINT#0;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.GetDiagnosticsReturnCode                  :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateState                          :=  ComponentState#Unknown;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  FALSE;
            AxoHwDiagDetails.IOSystemSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;    

            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.HardwareID                                :=  UINT#0;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.GetDiagnosticsReturnCode                  :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateState                          :=  ComponentState#Unknown;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  FALSE;
            AxoHwDiagDetails.StationSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;    

            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.HardwareID                                :=  UINT#0;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode                  :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateState                          :=  ComponentState#Unknown;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Good                   :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Disabled               :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired    :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded    :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.Error                  :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible          :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable   :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable     :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.NetworkError           :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.SubordinateIOState.HardwareError          :=  FALSE;
            AxoHwDiagDetails.ModuleSubSystemDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;    

            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.HardwareID                             :=  UINT#0;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.GetDiagnosticsReturnCode               :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateState                       :=  ComponentState#Unknown;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Good                :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Disabled            :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceRequired :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.MaintenanceDemanded :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.Error               :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.NotAccessible       :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.DiagnosticsAvailable:=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.IODataNotAvailable  :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.NetworkError        :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.SubordinateIOState.HardwareError       :=  FALSE;
            AxoHwDiagDetails.SubModuleSubSystemDiagnosticDetails.DiagnosticsEnabled                     :=  FALSE;    

            _currentIndex := -1;
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




