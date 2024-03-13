USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING System.Strings;
USING System.Serialization;
USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoIOLink_RF200Device EXTENDS AXOpen.Core.AxoComponent
        VAR PRIVATE
            _infoTimer                  :   AXOpen.Timers.OnDelayTimer;
            _infoTime                   :   LTIME := LT#2S;
            _errorTimer                 :   AXOpen.Timers.OnDelayTimer;
            _errorTime                  :   LTIME := LT#5S;
            _blink                      :   AXOpen.Timers.AxoBlinker;
            _context                    :   IAxoContext;
            _someTaskIsActive           :   BOOL;

            _HW_ID                      :	WORD    :=  WORD#16#0;     
            _portAddr                   :	INT     :=  INT#0;     
            _version                    :	USINT   :=  USINT#11;    

            _switchAntenna              :   AxoIOLink_RF200_SwitchAntenna;
            _readTag                    :   AxoIOLink_RF200_ReadTag;
            _writeTag                   :   AxoIOLink_RF200_WriteTag;
            
            _switchAntenna_execute      :   BOOL    :=  FALSE;    
            _switchAntenna_antennaState :   BOOL    :=  FALSE;
            _switchAntenna_done         :   BOOL    :=  FALSE;
            _switchAntenna_busy         :   BOOL    :=  FALSE;
            _switchAntenna_error        :   BOOL    :=  FALSE;
            _switchAntenna_status       :   DWORD   :=  DWORD#16#0;
            _switchAntenna_presence     :   BOOL    :=  FALSE;        



            _readTag_execute            :   BOOL    :=  FALSE;    
            _readTag_addrTag            :	WORD    :=  WORD#16#0;      
            _readTag_length             :	WORD    :=  WORD#16#1C;   
            _readTag_Data               :   AxoByteArray256;
            _readTag_done               :   BOOL    :=  FALSE;        
            _readTag_busy               :   BOOL    :=  FALSE;        
            _readTag_error              :   BOOL    :=  FALSE;        
            _readTag_status             :   DWORD   :=  DWORD#16#0;
            _readTag_presence           :   BOOL    :=  FALSE;         
            _readBuffer                 :   ARRAY[0..255] OF BYTE;

            _writeTag_execute           :   BOOL    :=  FALSE;          
            _writeTag_addrTag           :   WORD    :=  WORD#16#0;      
            _writeTag_length            :   WORD    :=  WORD#16#1C;
            _writeTag_Data              :   AxoByteArray256;
            _writeTag_done              :   BOOL    :=  FALSE;        
            _writeTag_busy              :   BOOL    :=  FALSE;        
            _writeTag_error             :   BOOL    :=  FALSE;        
            _writeTag_status            :   DWORD   :=  DWORD#16#0;
            _writeTag_presence          :   BOOL    :=  FALSE;         
            _writeBuffer                :   ARRAY[0..255] OF BYTE;

            _error                      :   BOOL    :=  FALSE;  
            _messageCode                :   ULINT   :=  ULINT#0;
            _lastMessageCode            :   ULINT   :=  ULINT#0;
        END_VAR

        VAR PUBLIC //HEADER
            {#ix-attr:[ComponentHeader()]}
            Debug   :   ULINT;
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Read tag#>"}
            ReadTagTask : AxoTask;     
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Read tag length#>"}
            ReadTag_Length   : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Read tag address#>"}
            ReadTag_addrTag         : WORD;

            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Data read from tag#>"}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:DisplayFormat = "string"}
            ReadTag_Data    : AxoByteArray256;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write tag#>"}
            WriteTagTask : AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write tag lenghth#>"}
            WriteTag_Length   : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write tag address#>"}
            WriteTag_addrTag  : WORD;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Data to write to tag#>"}
            {#ix-set:DisplayFormat = "string"}
            WriteTag_Data    : AxoByteArray256;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;            
        END_VAR
        
        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   Axo_IdentDevice_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            ReaderStatus        :   AxoIOLink_RF200Device_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Progress#>"}
            _progress           :   INT := 0;
        END_VAR

        VAR PUBLIC //HardwareDiagnostics
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent      : IAxoObject;
                HW_ID       :	WORD    :=  WORD#16#0;      //	Logic IO address of the IO-Link Master
                portAddr    :	INT     :=  INT#0;          //  Start address of port
                version     :	USINT   :=  USINT#11;       //	IO-Link version of the reader; 11: IO-Link V1.1, 10: IO-Link V1.0
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,HW_ID = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                ReaderStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF HW_ID = WORD#0 THEN
                ReaderStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _HW_ID      :=  HW_ID;
            _portAddr   :=  portAddr;
            _version    :=  version;

            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent      :   IAxoContext;
                HW_ID       :	WORD    :=  WORD#16#0;      //	Logic IO address of the IO-Link Master
                portAddr    :	INT     :=  INT#0;          //  Start address of port
                version     :	USINT   :=  USINT#11;       //	IO-Link version of the reader; 11: IO-Link V1.1, 10: IO-Link V1.0
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,HW_ID = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                ReaderStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF HW_ID = WORD#0 THEN
                ReaderStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _HW_ID      :=  HW_ID;
            _portAddr   :=  portAddr;
            _version    :=  version;

            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD

        METHOD PRIVATE Execute 
            VAR 
                i               :   INT;
            END_VAR

            THIS.Open();



            _switchAntenna.Run( execute         :=      _switchAntenna_execute,     
                                antennaState    :=      _switchAntenna_antennaState,
                                hwID            :=      _HW_ID,        
                                portAddr        :=      _portAddr,    
                                version         :=      _version,     
                                done            =>      _switchAntenna_done,              
                                busy            =>      _switchAntenna_busy,              
                                error           =>      _switchAntenna_error,            
                                status          =>      _switchAntenna_status,          
                                presence        =>      _switchAntenna_presence);

            _readTag.Run(   execute     :=  _readTag_execute,
                            addrTag     :=  _readTag_addrTag,
                            length      :=  _readTag_length,
                            hwID        :=  _HW_ID,        
                            portAddr    :=  _portAddr,    
                            version     :=  _version,
                            identData   :=  REF(_readBuffer),
                            done        =>  _readTag_done,
                            busy        =>  _readTag_busy,
                            error       =>  _readTag_error,
                            status      =>  _readTag_status,
                            presence    =>  _readTag_presence);
 
            _writeTag.Run(  execute     :=  _writeTag_execute,
                            addrTag     :=  _writeTag_addrTag,
                            length      :=  _writeTag_length,
                            hwID        :=  _HW_ID,        
                            portAddr    :=  _portAddr,    
                            version     :=  _version,
                            identData   :=  REF(_writeBuffer),
                            done        =>  _writeTag_done,
                            busy        =>  _writeTag_busy,
                            error       =>  _writeTag_error,
                            status      =>  _writeTag_status,
                            presence    =>  _writeTag_presence);

            ReaderStatus.Antenna_status     :=  _switchAntenna_status;
            ReaderStatus.ReadTag_status     :=  _readTag_status;
            ReaderStatus.WriteTag_status    :=  _writeTag_status;
             
            Messenger.ActivateOnCondition(TO_ULINT(DWORD#16#FEFE0001),_readTag_status = DWORD#16#FEFE0001, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(TO_ULINT(DWORD#16#FEFE0002),_writeTag_status = DWORD#16#FEFE0002, eAxoMessageCategory#ProgrammingError);

            _error := FALSE;
            IF _switchAntenna_error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(_switchAntenna_status);
                END_IF;
            ELSIF _readTag_error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(_readTag_status);
                END_IF;
            ELSIF _writeTag_error THEN
                _error := TRUE;
                IF _messageCode = ULINT#0 THEN
                    _messageCode := TO_ULINT(_writeTag_status);
                END_IF;
            END_IF;

   
            Messenger.ActivateOnCondition(_messageCode, _error AND _messageCode = _lastMessageCode ,eAxoMessageCategory#Error);

            IF NOT Messenger.IsActive THEN
                IF _error THEN
                    _lastMessageCode := _messageCode;
                    RETURN;
                ELSE
                    _messageCode := ULINT#0;
                END_IF;                          
            END_IF;                          

            //*******************************************
            _context := THIS.GetContext();

            _infoTime := Config.InfoTime;
            _errorTime := Config.ErrorTime;

            //*************INITIALIZATION****************
            RestoreTask.Initialize(THIS);
            ReadTagTask.Initialize(THIS);
            WriteTagTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            //*******************************************
            //********************Diagnostics************        
            HardwareDiagnosticsTask.Run(_HW_ID);
            //*******************************************

            //*************RESTORE***********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //*******************************************

            //*************ReadTask**********************
            ReadTagTask.IsDisabled := FALSE;
            IF ReadTagTask.StartTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,ReadTagTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ReadTagTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadTagTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    ReaderStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _switchAntenna_execute := FALSE;
                    _readTag_execute := FALSE;
                    _writeTag_execute := FALSE;
                    FOR i := INT#0 TO INT#255 DO
                        _readTag_Data.Data[i] := BYTE#0;
                    END_FOR;
                    _readTag_Data.ToggleDataChangedFlag();
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#500, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#500;
                    END_IF;

                    _switchAntenna_execute      :=  TRUE;     
                    _switchAntenna_antennaState :=  TRUE;

                    IF _switchAntenna_done THEN
                        THIS.CallTimers(FALSE);
                        _progress:=301;                    
                    END_IF;
                    ReadTagTask.ThrowWhen(_switchAntenna_error,'Error when switching the antena On' );
                END_IF;

                IF _progress = 301 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#501, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#501;
                    END_IF;

                    _switchAntenna_execute      :=  FALSE;     

                    IF( NOT _switchAntenna_done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=302;                           
                     END_IF;   
                END_IF;
                
                IF _progress = 302 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#502, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#502;
                    END_IF;

                    IF(_switchAntenna_presence) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=303;                           
                     END_IF;   
                END_IF;
                
                IF _progress = 303 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#503, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#503;
                    END_IF;

                    _readTag_execute := TRUE;

                    IF(_readTag_done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=304;                           
                     END_IF;   
                     ReadTagTask.ThrowWhen(_readTag_error,'Error reading tag');
                    END_IF;

                IF _progress = 304 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#504, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#504;
                    END_IF;

                    FOR i := 0 TO TO_INT(_readTag_length) - INT#1 DO
                        _readTag_Data.Data[i] := _readBuffer[i];
                    END_FOR;

                    _readTag_execute           :=  FALSE;

                    IF NOT _readTag_done THEN
                        THIS.CallTimers(FALSE);
                        _progress:=305;                    
                    END_IF;             
                END_IF;
                
                IF _progress = 305 THEN  
                    _readTag_Data.ToggleDataChangedFlag();
                    ReadTagTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;

                THIS.CallTimers(TRUE);
                ReadTagTask.ThrowWhen(_errorTimer.output );
                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ReadTagTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#101;
                ReaderStatus.Error.Id :=  UINT#0;
            ELSIF ReadTagTask.ErrorOccured() THEN
                ReaderStatus.Action.Id :=  UINT#800;
                ReaderStatus.Error.Id  :=  UINT#800;
            ELSIF ReadTagTask.AbortTriggered()THEN
                ReaderStatus.Action.Id :=  UINT#801;
                ReaderStatus.Error.Id  :=  UINT#801;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#800,ReadTagTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#801,ReadTagTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ReadTagTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ReadTagTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                ReaderStatus.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //*******************************************

 
            //***********WriteTask***********************
            WriteTagTask.IsDisabled := FALSE;
            IF WriteTagTask.StartTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,WriteTagTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,WriteTagTask.IsDone(), eAxoMessageCategory#Info);
            IF WriteTagTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    ReaderStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _switchAntenna_execute := FALSE;
                    _readTag_execute := FALSE;
                    _writeTag_execute := FALSE;
                    _progress := 320;
                END_IF;
                
                IF _progress = 320 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#520, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#520;
                    END_IF;

                    FOR i := INT#0 TO TO_INT(_writeTag_length) - INT#1 DO
                        _writeBuffer[i] := _writeTag_Data.Data[i];
                    END_FOR;

                    _switchAntenna_execute      :=  TRUE;     
                    _switchAntenna_antennaState :=  TRUE;

                    IF _switchAntenna_done THEN
                        THIS.CallTimers(FALSE);
                        _progress:=321;                    
                    END_IF;
                    WriteTagTask.ThrowWhen(_switchAntenna_error,'Error when switching the antena On' );
                END_IF;

                IF _progress = 321 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#521, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#521;
                    END_IF;

                    _switchAntenna_execute      :=  FALSE;     

                    IF( NOT _switchAntenna_done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=322;                           
                     END_IF;   
                END_IF;
                
                IF _progress = 322 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#522, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#522;
                    END_IF;

                    IF(_switchAntenna_presence) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=323;                           
                     END_IF;   
                END_IF;
                
                IF _progress = 323 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#523, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#523;
                    END_IF;

                    _writeTag_execute := TRUE;

                    IF(_writeTag_done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=324;                           
                     END_IF;   
                     WriteTagTask.ThrowWhen(_writeTag_error,'Error writing tag');
                    END_IF;

                IF _progress = 324 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#524, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#524;
                    END_IF;

                    _writeTag_execute           :=  FALSE;

                    IF NOT _writeTag_done THEN
                        THIS.CallTimers(FALSE);
                        _progress:=325;                    
                    END_IF;             
                END_IF;

                IF _progress = 325 THEN	
                    WriteTagTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                WriteTagTask.ThrowWhen(_errorTimer.output);
                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF WriteTagTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#121;
                ReaderStatus.Error.Id :=  UINT#0;
            ELSIF WriteTagTask.ErrorOccured() THEN
                ReaderStatus.Action.Id :=  UINT#820;
                ReaderStatus.Error.Id  :=  UINT#820;
            ELSIF WriteTagTask.AbortTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#821;
                ReaderStatus.Error.Id  :=  UINT#821;
            END_IF;         
            Messenger.ActivateOnCondition(ULINT#820,WriteTagTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#821,WriteTagTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,WriteTagTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF WriteTagTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 339  THEN
                ReaderStatus.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;   
            //*******************************************
                        

            //*******************************************
            THIS.Close();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            _readTag_addrTag    :=  ReadTag_addrTag;
            _readTag_Length     :=  ReadTag_Length;
            ReadTag_Data        :=  _readTag_Data;
            _writeTag_Data      :=  WriteTag_Data;
            _writeTag_addrTag   :=  WriteTag_addrTag;
            _writeTag_Length    :=  WriteTag_Length;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            ReadTagTask.Restore();      
            WriteTagTask.Restore();
            ReaderStatus.Action.Id :=  UINT#50;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD        
    
        ///<summary>
        /// Reads the data from the transponder into the array of byte.        
        ///</summary>
        METHOD PUBLIC ReadTag : IAxoTaskState
            VAR_INPUT
                Address     :   WORD;
                Length      :   WORD;
                Data        :   REF_TO AxoByteArray256;
            END_VAR
            VAR
                _i              :   INT;
            END_VAR

            IF Data = NULL THEN RETURN; END_IF;

            _readTag_addrTag    :=  Address; 
            _readTag_Length     :=  Length; 

            IF ReadTagTask.IsFirstExecutionCycle() THEN
                FOR _i := INT#0 TO INT#255 DO
                    Data^.Data[_i] := BYTE#0;
                END_FOR;
            END_IF;

            ReadTag := ReadTagTask.Invoke();

            IF ReadTagTask.DoneReached() THEN
                FOR _i := INT#0 TO TO_INT(Length) - INT#1 DO
                    Data^.Data[_i] := _readTag_Data.Data[_i];
                END_FOR;
            END_IF;
        END_METHOD

        ///<summary>
        /// Reads the data from the transponder into the string.        
        ///</summary>
        METHOD PUBLIC ReadTag : IAxoTaskState
            VAR_INPUT
                Address     :   WORD;
                Length      :   WORD;
            END_VAR
            VAR_OUTPUT
                Data            :   STRING;
            END_VAR
            VAR
                _i              :   INT;
                _data           :   ARRAY[0..255] OF BYTE;
            END_VAR

            _readTag_addrTag    :=  Address; 
            _readTag_Length     :=  Length; 

            IF ReadTagTask.IsFirstExecutionCycle() THEN
                Data := '';
             END_IF;

            ReadTag := ReadTagTask.Invoke();

            IF ReadTagTask.DoneReached() THEN
                _data[0]    :=  TO_BYTE(Length);
                FOR _i := INT#1 TO TO_INT(Length)  DO
                    _data[_i] := _readTag_Data.Data[_i - INT#1];
                END_FOR;
                Deserialize(UINT#0,_data,Data);
            END_IF;
        END_METHOD

        ///<summary>
        /// Writes the data from the array of byte into the transponder.
        ///</summary>
        METHOD PUBLIC WriteTag : IAxoTaskState
            VAR_INPUT
                Data        :   REF_TO AxoByteArray256;
                Address     :   WORD;
                Lenght      :   WORD;
            END_VAR

            IF Data = NULL THEN RETURN; END_IF;

            _writeTag_Data      :=  Data^; 
            _writeTag_addrTag   :=  Address; 
            _writeTag_Length    :=  Lenght; 

            WriteTag := WriteTagTask.Invoke();
        END_METHOD

        ///<summary>
        /// Writes the data from the string into the transponder.
        ///</summary>
        METHOD PUBLIC WriteTag : IAxoTaskState
            VAR_INPUT
                Data            :   STRING;
                Address         :   WORD;
            END_VAR
            VAR
                _i              :   INT;
                _data           :   ARRAY[0..256] OF BYTE;
            END_VAR
            Serialize(UINT#0,Data,_data);
            FOR _i := INT#0 TO LengthOf(Data) DO
                _writeTag_Data.Data[_i] := _data[_i + INT#1];
            END_FOR;

            _writeTag_addrTag   :=  Address; 
            _writeTag_length  :=  TO_WORD(LengthOf(Data)); 

            WriteTag := WriteTagTask.Invoke();
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , _infoTime);
            _errorTimer.OnDelay(THIS, signal , _errorTime );
        END_METHOD
    END_CLASS
END_NAMESPACE