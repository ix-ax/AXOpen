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

        VAR PUBLIC // DIAGNOSTICS DETAILS
            {#ix-attr:[ComponentDetails("Diagnostics details")]}
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
          
            //*************INITIALIZATION*********************
            RestoreTask.Run(THIS);
            UpdateDiagnosticTask.Run(THIS);
            //************************************************
    
   
            //*************RESTORE****************************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //************************************************

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
                // UpdateDiagnosticTask running: , cleaning all diagnostics results
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
                        
                    THIS.ClearDiagResult();

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , waiting for the accessibility to the HwIdList
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
                    IF _currentIndex = -1 THEN
                        _currentIndex := 0;                        
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering PLC-ReadSlotFromHardwareID running
                IF _progress = 302 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;
    
                    _currenthwID    :=  hwIDsList[_currentIndex];                                                      
                    _retval         :=  ReadSlotFromHardwareID(hardwareID := _currenthwID, geoAddr :=_geoAddr);  
                    IF _retval = WORD#0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    ELSIF _retval = WORD#16#8090 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 2;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , discovering PLC-comparing GeoAddr details
                IF _progress = 303 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#503;
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
                IF _progress = 304 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#504;
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
                // UpdateDiagnosticTask running: , get diagnostics of the PLC system
                IF _progress = 305 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#505;
                    END_IF;

                    AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_plcHwId, diagInfo);
                    AxoHwDiagDetails.PLCDiagnosticDetails.HardwareID                :=  _plcHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.PLCDiagnosticDetails.State                                    :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Good                  :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Disabled              :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.MaintenanceRequired   :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.MaintenanceDemanded   :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Error                 :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.NotAccessible         :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.DiagnosticsAvailable  :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.IODataNotAvailable    :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.NetworkError          :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.HardwareError         :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.PLCDiagnosticDetails.DiagnosticsEnabled                       :=  FALSE;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.PLCDiagnosticDetails.State = ComponentState#Good THEN
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

                    AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_plcHwId, diagSubInfo);
                    AxoHwDiagDetails.PLCDiagnosticDetails.HardwareID                :=  _plcHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.PLCDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.PLCDiagnosticDetails.IOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.PLCDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.PLCDiagnosticDetails.SubordinateState = ComponentState#Good THEN
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
    
                    AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_ioSystemHwId, diagInfo);
                    AxoHwDiagDetails.IoSystemDiagnosticDetails.HardwareID                :=  _ioSystemHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.State                                   :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Good                 :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Disabled             :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.MaintenanceRequired  :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.MaintenanceDemanded  :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Error                :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.NotAccessible        :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.DiagnosticsAvailable :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.IODataNotAvailable   :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.NetworkError         :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.HardwareError        :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.DiagnosticsEnabled                      :=  FALSE;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.IoSystemDiagnosticDetails.State = ComponentState#Good THEN
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
    
                    AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_ioSystemHwId, diagSubInfo);
                    AxoHwDiagDetails.IoSystemDiagnosticDetails.HardwareID                :=  _ioSystemHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.SubordinateState                        :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Good                 :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Disabled             :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.MaintenanceRequired  :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.MaintenanceDemanded  :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Error                :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.NotAccessible        :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.DiagnosticsAvailable :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.IODataNotAvailable   :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.NetworkError         :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.HardwareError        :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.IoSystemDiagnosticDetails.DiagnosticsEnabled                      :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.IoSystemDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            AxoHwDiagDetails.IoSystemDiagnosticDetails.SubordinateState :=  ComponentState#Unknown;      
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
    
                    AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_stationHwId, diagInfo);
                    AxoHwDiagDetails.StationDiagnosticDetails.HardwareID                :=  _stationHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.StationDiagnosticDetails.State                                    :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.Good                  :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.Disabled              :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.MaintenanceRequired   :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.MaintenanceDemanded   :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.Error                 :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.NotAccessible         :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.DiagnosticsAvailable  :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.IODataNotAvailable    :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.NetworkError          :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.HardwareError         :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.StationDiagnosticDetails.DiagnosticsEnabled                       :=  FALSE;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.StationDiagnosticDetails.State = ComponentState#Good THEN
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
    
                    AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_stationHwId, diagSubInfo);
                    AxoHwDiagDetails.StationDiagnosticDetails.HardwareID                :=  _stationHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.StationDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.StationDiagnosticDetails.IOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.StationDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.StationDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            AxoHwDiagDetails.StationDiagnosticDetails.SubordinateState :=  ComponentState#Unknown;      
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
    
                    AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_moduleHwId, diagInfo);
                    AxoHwDiagDetails.ModuleDiagnosticDetails.HardwareID                :=  _moduleHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.ModuleDiagnosticDetails.State                                     :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Good                   :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Disabled               :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.MaintenanceRequired    :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.MaintenanceDemanded    :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Error                  :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.NotAccessible          :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.DiagnosticsAvailable   :=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.IODataNotAvailable     :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.NetworkError           :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.HardwareError          :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.ModuleDiagnosticDetails.DiagnosticsEnabled                        :=  false;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.ModuleDiagnosticDetails.State = ComponentState#Good THEN
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
    
                    AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_moduleHwId, diagSubInfo);
                    AxoHwDiagDetails.ModuleDiagnosticDetails.HardwareID                :=  _moduleHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.ModuleDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.ModuleDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.ModuleDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            AxoHwDiagDetails.ModuleDiagnosticDetails.SubordinateState :=  ComponentState#Unknown;      
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
    
                    AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_moduleHwId, diagInfo);
                    AxoHwDiagDetails.SubModuleDiagnosticDetails.HardwareID                :=  _submoduleHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.State                                  :=  diagInfo.ComponentState;      
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Good                :=  diagInfo.IOState.Good;                     
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Disabled            :=  diagInfo.IOState.Disabled;                 
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.MaintenanceRequired :=  diagInfo.IOState.MaintenanceRequired;      
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.MaintenanceDemanded :=  diagInfo.IOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Error               :=  diagInfo.IOState.Error;                    
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.NotAccessible       :=  diagInfo.IOState.NotAccessible;            
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.DiagnosticsAvailable:=  diagInfo.IOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.IODataNotAvailable  :=  diagInfo.IOState.IODataNotAvailable;       
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.NetworkError        :=  diagInfo.IOState.NetworkError;             
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.HardwareError       :=  diagInfo.IOState.HardwareError;            
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.DiagnosticsEnabled                     :=  false;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.SubModuleDiagnosticDetails.State = ComponentState#Good THEN
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
    
                    AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(_moduleHwId, diagSubInfo);
                    AxoHwDiagDetails.SubModuleDiagnosticDetails.HardwareID                :=  _submoduleHwId;

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.SubordinateState                          :=  diagSubInfo.SubordinateState;      
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Good                   :=  diagSubInfo.SubordinateIOState.Good;                     
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Disabled               :=  diagSubInfo.SubordinateIOState.Disabled;                 
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.MaintenanceRequired    :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.MaintenanceDemanded    :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Error                  :=  diagSubInfo.SubordinateIOState.Error;                    
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.NotAccessible          :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.DiagnosticsAvailable   :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.IODataNotAvailable     :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.NetworkError           :=  diagSubInfo.SubordinateIOState.NetworkError;             
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.HardwareError          :=  diagSubInfo.SubordinateIOState.HardwareError;            
                        AxoHwDiagDetails.SubModuleDiagnosticDetails.DiagnosticsEnabled                        :=  diagSubInfo.DiagnosticsEnabled;
                        THIS.CallTimers(FALSE);
                        IF AxoHwDiagDetails.SubModuleDiagnosticDetails.SubordinateState = ComponentState#Good THEN
                            AxoHwDiagDetails.SubModuleDiagnosticDetails.SubordinateState :=  ComponentState#Unknown;      
                            _progress := _progress - 4;   // Continue searching the next SubModule as current one does not contain any error nor any of its subordinary items
                        ELSE     
                            _progress := _progress + 1;
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , should never get into this step             
                IF _progress = 327 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#527;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , at least one error present              
                IF _progress = 330 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#530;
                    END_IF;
                    //Error present on submodule
                    IF _subModuleIndex >INT#-1 AND _subModuleHwId > UINT#0 THEN
                        AxoHwDiagDetails.FaultyItemDetails.HardwareID := _subModuleHwId;
                    //Error present on module
                    ELSIF _moduleIndex >INT#-1 AND _moduleHwId > UINT#0 THEN
                        AxoHwDiagDetails.FaultyItemDetails.HardwareID := _moduleHwId;
                    //Error present on station
                    ELSIF _stationIndex >INT#-1 AND _stationHwId > UINT#0 THEN
                        AxoHwDiagDetails.FaultyItemDetails.HardwareID := _stationHwId;
                    //Error present on iosystem
                    ELSIF _ioSystemIndex >INT#-1 AND _ioSystemHwId > UINT#0 THEN
                        AxoHwDiagDetails.FaultyItemDetails.HardwareID := _ioSystemHwId;
                    //Error present on plc
                    ELSIF _plcIndex >INT#-1 AND _plcHwId > UINT#0 THEN
                        AxoHwDiagDetails.FaultyItemDetails.HardwareID := _plcHwId;
                    END_IF;
    
                    IF AxoHwDiagDetails.FaultyItemDetails.HardwareID > UINT#0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask running: , get diagnostics of the faulty item               
                IF _progress = 331 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#531;
                    END_IF;
    
                    AxoHwDiagDetails.FaultyItemDetails.GetDiagnosticsReturnCode  :=  GetDiagnostics(AxoHwDiagDetails.FaultyItemDetails.HardwareID, diagInfo);

                    UpdateDiagnosticTask.ThrowWhen( AxoHwDiagDetails.FaultyItemDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR AxoHwDiagDetails.FaultyItemDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);

                    IF AxoHwDiagDetails.FaultyItemDetails.GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation      :=  diagInfo.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.TransferNotPermitted         :=  diagInfo.ComponentStateDetail.HardwareComponentState.TransferNotPermitted;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable         :=  diagInfo.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.MaintenanceRequired          :=  diagInfo.ComponentStateDetail.HardwareComponentState.MaintenanceRequired;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded          :=  diagInfo.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.Error                        :=  diagInfo.ComponentStateDetail.HardwareComponentState.Error;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.ComponentAvailability        :=  diagInfo.ComponentStateDetail.HardwareComponentState.ComponentAvailability;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.ReplacementState	            :=  diagInfo.ComponentStateDetail.HardwareComponentState.ReplacementState;  
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.Good                                        :=  diagInfo.IOState.Good;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.Disabled                                    :=  diagInfo.IOState.Disabled;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.MaintenanceRequired                         :=  diagInfo.IOState.MaintenanceRequired;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.MaintenanceDemanded                         :=  diagInfo.IOState.MaintenanceDemanded;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.Error                                       :=  diagInfo.IOState.Error;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.NotAccessible                               :=  diagInfo.IOState.NotAccessible;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.DiagnosticsAvailable                        :=  diagInfo.IOState.DiagnosticsAvailable;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.IODataNotAvailable                          :=  diagInfo.IOState.IODataNotAvailable;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.NetworkError                                :=  diagInfo.IOState.NetworkError;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.HardwareError                               :=  diagInfo.IOState.HardwareError;
                        AxoHwDiagDetails.FaultyItemDetails.ComponentState                                                           :=  diagInfo.ComponentState;
                        AxoHwDiagDetails.FaultyItemDetails.OperatingState                                                           :=	diagInfo.OperatingState;	
                        THIS.CallTimers(FALSE);
                        IF TRUE THEN
                            _progress := _progress + 1;
                        END_IF;
                    END_IF;
                END_IF;
                // UpdateDiagnosticTask done: , error present                              
                IF _progress = 332 THEN
                    UpdateDiagnosticTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;                
                // UpdateDiagnosticTask done: , none error present                              
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
            Status.Action.Id    :=  UINT#0;
            Status.Error.Id     :=  UINT#0;
            _progress           :=  INT#0;
            _retVal             :=  WORD#0;
            _currentIndex       :=  -1;

            UpdateDiagnosticTask.Restore();

            Status.Action.Id := UINT#50;
            RestoreTask.DoneWhen(TRUE);
            THIS.ClearDiagResult();
        END_METHOD        

        METHOD PRIVATE ClearDiagResult
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

            AxoHwDiagDetails.PLCDiagnosticDetails.HardwareID                                    :=  UINT#0;
            AxoHwDiagDetails.PLCDiagnosticDetails.GetDiagnosticsReturnCode                      :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.PLCDiagnosticDetails.State                                         :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.PLCDiagnosticDetails.SubordinateState                              :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Good                                  :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Disabled                              :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.MaintenanceRequired                   :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.MaintenanceDemanded                   :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.Error                                 :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.NotAccessible                         :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.DiagnosticsAvailable                  :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.IODataNotAvailable                    :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.NetworkError                          :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.IOState.HardwareError                         :=  FALSE;
            AxoHwDiagDetails.PLCDiagnosticDetails.DiagnosticsEnabled                            :=  FALSE;    

            AxoHwDiagDetails.IoSystemDiagnosticDetails.HardwareID                               :=  UINT#0;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.GetDiagnosticsReturnCode                 :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.State                                    :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.SubordinateState                         :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Good                             :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Disabled                         :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.MaintenanceRequired              :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.MaintenanceDemanded              :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.Error                            :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.NotAccessible                    :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.DiagnosticsAvailable             :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.IODataNotAvailable               :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.NetworkError                     :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.IOState.HardwareError                    :=  FALSE;
            AxoHwDiagDetails.IoSystemDiagnosticDetails.DiagnosticsEnabled                       :=  FALSE;    

            AxoHwDiagDetails.StationDiagnosticDetails.HardwareID                                :=  UINT#0;
            AxoHwDiagDetails.StationDiagnosticDetails.GetDiagnosticsReturnCode                  :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.StationDiagnosticDetails.State                                     :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.StationDiagnosticDetails.SubordinateState                          :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.Good                              :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.Disabled                          :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.MaintenanceRequired               :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.MaintenanceDemanded               :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.Error                             :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.NotAccessible                     :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.DiagnosticsAvailable              :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.IODataNotAvailable                :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.NetworkError                      :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.IOState.HardwareError                     :=  FALSE;
            AxoHwDiagDetails.StationDiagnosticDetails.DiagnosticsEnabled                        :=  FALSE;    

            AxoHwDiagDetails.ModuleDiagnosticDetails.HardwareID                                 :=  UINT#0;
            AxoHwDiagDetails.ModuleDiagnosticDetails.GetDiagnosticsReturnCode                   :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.ModuleDiagnosticDetails.State                                      :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.ModuleDiagnosticDetails.SubordinateState                           :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Good                               :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Disabled                           :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.MaintenanceRequired                :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.MaintenanceDemanded                :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.Error                              :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.NotAccessible                      :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.DiagnosticsAvailable               :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.IODataNotAvailable                 :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.NetworkError                       :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.IOState.HardwareError                      :=  FALSE;
            AxoHwDiagDetails.ModuleDiagnosticDetails.DiagnosticsEnabled                         :=  FALSE;    

            AxoHwDiagDetails.SubModuleDiagnosticDetails.HardwareID                              :=  UINT#0;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.GetDiagnosticsReturnCode                :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.State                                   :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.SubordinateState                        :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Good                            :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Disabled                        :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.MaintenanceRequired             :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.MaintenanceDemanded             :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.Error                           :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.NotAccessible                   :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.DiagnosticsAvailable            :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.IODataNotAvailable              :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.NetworkError                    :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.IOState.HardwareError                   :=  FALSE;
            AxoHwDiagDetails.SubModuleDiagnosticDetails.DiagnosticsEnabled                      :=  FALSE;    

            AxoHwDiagDetails.FaultyItemDetails.HardwareID                                                               :=	UINT#0;
            AxoHwDiagDetails.FaultyItemDetails.GetDiagnosticsReturnCode                                                 :=  GetDiagnosticsReturnCode#Unknown;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation      :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.TransferNotPermitted         :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable         :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.MaintenanceRequired          :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded          :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.Error                        :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.ComponentAvailability        :=  AxoHwDiagComponentAvailability#Unknown;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.HardwareComponentState.ReplacementState	            :=  AxoHwDiagReplacementState#Unknown;  
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.Good                                        :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.Disabled                                    :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.MaintenanceRequired                         :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.MaintenanceDemanded                         :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.Error                                       :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.NotAccessible                               :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.DiagnosticsAvailable                        :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.IODataNotAvailable                          :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.NetworkError                                :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentStateDetail.IOState.HardwareError                               :=  FALSE;
            AxoHwDiagDetails.FaultyItemDetails.ComponentState                                                           :=  AxoHwDiagComponentState#Unknown;
            AxoHwDiagDetails.FaultyItemDetails.OperatingState                                                           :=	AxoHwDiagOperatingState#Unknown;	
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




