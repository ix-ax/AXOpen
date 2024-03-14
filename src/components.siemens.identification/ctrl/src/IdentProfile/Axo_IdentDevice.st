USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING System.Strings;
USING System.Serialization;
USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC Axo_IdentDevice EXTENDS AXOpen.Core.AxoComponent
        VAR PRIVATE
            _infoTimer                  :   AXOpen.Timers.OnDelayTimer;
            _infoTime                   :   LTIME := LT#2S;
            _errorTimer                 :   AXOpen.Timers.OnDelayTimer;
            _errorTime                  :   LTIME := LT#5S;
            _blink                      :   AXOpen.Timers.AxoBlinker;
            _context                    :   IAxoContext;
            _someTaskIsActive           :   BOOL;

            _identProfile               :   Axo_IdentProfile;
            _identProfile_Execute       :   BOOL;        
            _identProfile_RepeatCommand :   BOOL;  
            _identProfile_SoftReset     :   BOOL;      
            _identProfile_Init          :   BOOL;           
            _identProfile_HwConnect     :   Axo_IID_HW_CONNECT;   
            _identProfile_Cmd           :   Axo_IID_CMD_STRUCT;         
            _identProfile_Tx            :   ARRAY[0..255] OF BYTE;          
            _identProfile_Rx            :   ARRAY[0..255] OF BYTE;          
            _identProfile_Done          :   BOOL;           
            _identProfile_Busy          :   BOOL;           
            _identProfile_Error         :   BOOL;          
            _identProfile_Warning       :   BOOL;        
            _identProfile_Status        :   DWORD;                     


            _readAddress                :   DWORD;
            _readNumberOfBytes          :   WORD;
            _readBufferOffset           :   UINT;
            _readData                   :   AxoByteArray256;
            _writeAddress               :   DWORD;
            _writeNumberOfBytes         :   WORD;
            _writeBufferOffset          :   UINT;
            _writeData                  :   AxoByteArray256;

            _messageCode                :   ULINT   :=  ULINT#0;
            _lastMessageCode            :   ULINT   :=  ULINT#0;
            _category                   :   eAxoMessageCategory :=  eAxoMessageCategory#Error;
        END_VAR

        VAR PUBLIC //HEADER

        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Read#>"}
            ReadTask : AxoTask;     
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Number of bytes to read#>"}
            ReadNumberOfBytes   : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Read address#>"}
            ReadAddress         : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Read buffer offset#>"}
            ReadBufferOffset: UINT;
            {#ix-attr:[Container(Layout.Wrap)]}

            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Data read#>"}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:DisplayFormat = "string"}
            ReadData    : AxoByteArray256;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write#>"}
            WriteTask : AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Number of bytes to write#>"}
            WriteNumberOfBytes   : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write address#>"}
            WriteAddress : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write buffer offset#>"}
            WriteBufferOffset: UINT;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Data to write#>"}
            {#ix-set:DisplayFormat = "string"}
            WriteData    : AxoByteArray256;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Soft reset#>"}
            SoftResetTask : AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Reset reader#>"}
            ResetReaderTask : AxoTask;   
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
            ReaderStatus        :   Axo_IdentDevice_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
            IdentProfileMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
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
                parent : IAxoObject;
                HW_ID               :   WORD    :=  WORD#16#0; 			//Hardware identifier
                API 				:   DWORD   :=  DWORD#16#0000_5B00; //API number 
                SLOT 				:   WORD    :=  WORD#16#02;  		//Slot number  
                SUB_SLOT 			:   WORD    :=  WORD#16#01; 		//Subslot number 
                CM_CHANNEL 			:   UINT    :=  UINT#1; 		    //channel of communication module	
            END_VAR

            Messenger.Serve(THIS);
            TaskMessenger.Serve(THIS);
            IdentProfileMessenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,HW_ID = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                ReaderStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF HW_ID = WORD#0 THEN
                ReaderStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _identProfile_HwConnect.HW_ID       :=  HW_ID;
            _identProfile_HwConnect.API         :=  API;
            _identProfile_HwConnect.SLOT 	    :=  SLOT;
            _identProfile_HwConnect.SUB_SLOT    :=  SUB_SLOT;
            _identProfile_HwConnect.CM_CHANNEL  :=  CM_CHANNEL;

            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent          :   IAxoContext;
                HW_ID               :   WORD    :=  WORD#16#0; 			//Hardware identifier
                API 				:   DWORD   :=  DWORD#16#0000_5B00; //API number 
                SLOT 				:   WORD    :=  WORD#16#02;  		//Slot number  
                SUB_SLOT 			:   WORD    :=  WORD#16#01; 		//Subslot number 
                CM_CHANNEL 			:   UINT    :=  UINT#1; 		    //channel of communication module	
            END_VAR

            Messenger.Serve(THIS);
            TaskMessenger.Serve(THIS);
            IdentProfileMessenger.Serve(THIS);


            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,HW_ID = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                ReaderStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF HW_ID = WORD#0 THEN
                ReaderStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _identProfile_HwConnect.HW_ID       :=  HW_ID;
            _identProfile_HwConnect.API         :=  API;
            _identProfile_HwConnect.SLOT 	    :=  SLOT;
            _identProfile_HwConnect.SUB_SLOT    :=  SUB_SLOT;
            _identProfile_HwConnect.CM_CHANNEL  :=  CM_CHANNEL;

            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD

        METHOD PRIVATE Execute 
            VAR 
                i               :   INT;
            END_VAR

            THIS.Open();


            _identProfile.Run(  Execute         :=  _identProfile_Execute,
                                RepeatCommand   :=  _identProfile_RepeatCommand,
                                SoftReset       :=  _identProfile_SoftReset,
                                Init            :=  _identProfile_Init,
                                refHwConnect    :=  REF(_identProfile_HwConnect), 
                                refCmd          :=  REF(_identProfile_Cmd),
                                refTx           :=  REF(_identProfile_Tx),
                                refRx           :=  REF(_identProfile_Rx),
                                Done            =>  _identProfile_Done,
                                Busy            =>  _identProfile_Busy,
                                Error           =>  _identProfile_Error,
                                Warning         =>  _identProfile_Warning,
                                Status          =>  _identProfile_Status);
            
            Messenger.ActivateOnCondition(TO_ULINT(DWORD#16#FEFE0001),_identProfile_Status = DWORD#16#FEFE0001, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(TO_ULINT(DWORD#16#FEFE0002),_identProfile_Status = DWORD#16#FEFE0002, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(TO_ULINT(DWORD#16#FEFE0003),_identProfile_Status = DWORD#16#FEFE0003, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(TO_ULINT(DWORD#16#FEFE0004),_identProfile_Status = DWORD#16#FEFE0004, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(TO_ULINT(DWORD#16#FEFE0005),_identProfile_Status = DWORD#16#FEFE0005, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(TO_ULINT(DWORD#16#FEFE0006),_identProfile_Status = DWORD#16#FEFE0006, eAxoMessageCategory#ProgrammingError);

            IF (_identProfile_Error OR _identProfile_Warning ) AND _messageCode = ULINT#0 THEN
                _messageCode := TO_ULINT(_identProfile_Status);
            END_IF;

            _category   :=  eAxoMessageCategory#Error;
            IF _identProfile_Warning AND NOT _identProfile_Error THEN
                _category   :=  eAxoMessageCategory#Warning;
            END_IF;
            IdentProfileMessenger.ActivateOnCondition(_messageCode, (_identProfile_Error OR _identProfile_Warning) AND _messageCode = _lastMessageCode ,_category);
            IF NOT Messenger.IsActive THEN
                IF (_identProfile_Error OR _identProfile_Warning) THEN
                    _lastMessageCode := _messageCode;
                ELSE
                    _messageCode := ULINT#0;
                END_IF;                          
            END_IF;                          

            ReaderStatus.IdentProfile_Status.Id := TO_ULINT(_identProfile_Status);
            //*******************************************
            _context := THIS.GetContext();

            _infoTime := Config.InfoTime;
            _errorTime := Config.ErrorTime;

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            ReadTask.Initialize(THIS);
            WriteTask.Initialize(THIS);
            SoftResetTask.Initialize(THIS);
            ResetReaderTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(_identProfile_HwConnect.HW_ID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************ReadTask************
            ReadTask.IsDisabled := FALSE;
            IF ReadTask.StartTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,ReadTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ReadTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    ReaderStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    FOR i := INT#0 TO INT#255 DO
                        _readData.Data[i] := BYTE#0;
                    END_FOR;
                    _readData.ToggleDataChangedFlag();
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#500, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#500;
                    END_IF;



                    _identProfile_Cmd.CMD           :=  eAxo_IID_COMMANDS#eRead;
                    _identProfile_Cmd.ADDR_TAG      :=  _readAddress;        
                    _identProfile_Cmd.LEN_DATA      :=  _readNumberOfBytes;  
                    _identProfile_Cmd.OFFSETBUFFER  :=  _readBufferOffset;   

                    _identProfile_Execute           :=  FALSE;
                    _identProfile_SoftReset         :=  FALSE;
                    _identProfile_Init              :=  FALSE;

                    IF NOT _identProfile_Busy THEN
                        THIS.CallTimers(FALSE);
                        _progress:=301;                    
                    END_IF;
                END_IF;

                IF _progress = 301 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#501, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#501;
                    END_IF;

                    _identProfile_Execute :=  TRUE;

                    IF( _identProfile_Busy) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=302;                           
                     END_IF;   
                END_IF;
                
                IF _progress = 302 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#502, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#502;
                    END_IF;

                    IF(NOT _identProfile_Busy) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=303;                           
                     END_IF;   
                END_IF;
                
                IF _progress = 303 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#503, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#503;
                    END_IF;

                    ReadTask.ThrowWhen(_identProfile_Error);

                    IF(_identProfile_Done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=304;                           
                     END_IF;   
                END_IF;

                IF _progress = 304 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#504, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#504;
                    END_IF;
  
                    FOR i := 0 TO TO_INT(_readNumberOfBytes) - INT#1 DO
                        _readData.Data[i] := _identProfile_Rx[i];
                    END_FOR;

                    _identProfile_Execute           :=  FALSE;

                    IF NOT  _identProfile_Done THEN
                        THIS.CallTimers(FALSE);
                        _progress:=305;                    
                    END_IF;             
                END_IF;
                
                IF _progress = 305 THEN  
                    _readData.ToggleDataChangedFlag();
                    ReadTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;

                THIS.CallTimers(TRUE);
                ReadTask.ThrowWhen(_errorTimer.output );
                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ReadTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#101;
                ReaderStatus.Error.Id :=  UINT#0;
            ELSIF ReadTask.ErrorOccured() THEN
                ReaderStatus.Action.Id :=  UINT#800;
                ReaderStatus.Error.Id  :=  UINT#800;
            ELSIF ReadTask.AbortTriggered()THEN
                ReaderStatus.Action.Id :=  UINT#801;
                ReaderStatus.Error.Id  :=  UINT#801;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#800,ReadTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#801,ReadTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ReadTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ReadTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                ReaderStatus.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //*******************************************

 
            //***********WriteTask***********************
            WriteTask.IsDisabled := FALSE;
            IF WriteTask.StartTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,WriteTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,WriteTask.IsDone(), eAxoMessageCategory#Info);
            IF WriteTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    ReaderStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;

                IF _progress = 320 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#520, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#520;
                    END_IF;

                    FOR i := INT#0 TO TO_INT(_writeNumberOfBytes) - INT#1 DO
                        _identProfile_Tx[i] := _writeData.Data[i];
                    END_FOR;

                    _identProfile_Cmd.CMD           :=  eAxo_IID_COMMANDS#eWrite;
                    _identProfile_Cmd.LEN_DATA      :=  _writeNumberOfBytes;
                    _identProfile_Cmd.ADDR_TAG      :=  _writeAddress;   
                    _identProfile_Cmd.OFFSETBUFFER  :=  _writeBufferOffset;   
                    
                    _identProfile_Execute           :=  FALSE;
                    _identProfile_SoftReset         :=  FALSE;
                    _identProfile_Init              :=  FALSE;

                    IF NOT _identProfile_Busy THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#521, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#521;
                    END_IF;
                    
                    _identProfile_Execute := TRUE;

                    IF _identProfile_Busy THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;

                IF _progress = 322 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#522, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#522;
                    END_IF;

                    IF(NOT _identProfile_Busy) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=323;                           
                     END_IF;   
                END_IF;
                
                IF _progress = 323 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#523, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#523;
                    END_IF;

                    WriteTask.ThrowWhen(_identProfile_Error);

                    IF(_identProfile_Done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=324;                           
                     END_IF;   
                END_IF;

                IF _progress = 324 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#524, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#524;
                    END_IF;

                    _identProfile_Execute :=  FALSE;
                    
                    IF(NOT _identProfile_Done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=325;                           
                     END_IF;   
                END_IF;

                IF _progress = 325 THEN	
                    WriteTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                WriteTask.ThrowWhen(_errorTimer.output);
                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF WriteTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#121;
                ReaderStatus.Error.Id :=  UINT#0;
            ELSIF WriteTask.ErrorOccured() THEN
                ReaderStatus.Action.Id :=  UINT#820;
                ReaderStatus.Error.Id  :=  UINT#820;
            ELSIF WriteTask.AbortTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#821;
                ReaderStatus.Error.Id  :=  UINT#821;
            END_IF;         
            Messenger.ActivateOnCondition(ULINT#820,WriteTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#821,WriteTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,WriteTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF WriteTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 339  THEN
                ReaderStatus.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;   
            //*******************************************
                        
            //*****************SoftReset*****************
            SoftResetTask.IsDisabled := FALSE;
            IF SoftResetTask.StartTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#140;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#140,SoftResetTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,SoftResetTask.IsDone(), eAxoMessageCategory#Info);
            IF SoftResetTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    ReaderStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;

                IF _progress = 340 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#540, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#540;
                    END_IF;

                    WriteTask.Restore();
                    ReadTask.Restore();		

                    ResetReaderTask.Restore();

                    _identProfile_Execute           :=  FALSE;
                    _identProfile_SoftReset         :=  FALSE;
                    _identProfile_Init              :=  FALSE;

                    IF NOT _identProfile_Busy THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;

                
                IF _progress = 341 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#541, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#541;
                    END_IF;

                    _identProfile_SoftReset         :=  TRUE;

                    IF _identProfile_Busy THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;

                IF _progress = 342 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#542, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#542;
                    END_IF;

                    IF NOT _identProfile_Busy THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;

                IF _progress = 343 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#543, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#543;
                    END_IF;

                    IF _identProfile_Done THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;

                IF _progress = 344 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#544, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#544;
                    END_IF;

                    _identProfile_SoftReset         :=  FALSE;

                    IF NOT _identProfile_Done THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    END_IF;
                END_IF;

                IF _progress = 345 THEN	
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                    SoftResetTask.DoneWhen(TRUE);
                END_IF;
                
	            THIS.CallTimers(TRUE);
                SoftResetTask.ThrowWhen(_errorTimer.output);
                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF SoftResetTask.IsFirstExecutionCycle() THEN
                ;
            END_IF;
            IF SoftResetTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#141;
                ReaderStatus.Error.Id :=  UINT#0;
            ELSIF SoftResetTask.ErrorOccured() THEN
                ReaderStatus.Action.Id :=  UINT#840;
                ReaderStatus.Error.Id  :=  UINT#840;
            ELSIF SoftResetTask.AbortTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#841;
                ReaderStatus.Error.Id  :=  UINT#841;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#840,SoftResetTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#841,SoftResetTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,SoftResetTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SoftResetTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349  THEN
                ReaderStatus.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;  
            //*******************************************

            //***********ResetReaderTask*****************
            ResetReaderTask.IsDisabled := FALSE;
            IF ResetReaderTask.StartTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#150;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#150,ResetReaderTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,ResetReaderTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetReaderTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    ReaderStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;
              
                IF _progress = 350 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#550, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#550;
                    END_IF;

                    FOR i := INT#0 TO INT#15 DO
                        _identProfile_Tx[i] := Config.HardwareConfig.Data[i];
                    END_FOR;
                    
                    _identProfile_Cmd.CMD           :=  eAxo_IID_COMMANDS#eWriteConfig;
                    _identProfile_Cmd.CONFIG        := BYTE#16#03;       
                    _identProfile_Cmd.LEN_DATA      := WORD#16#10;
                    _identProfile_Cmd.OFFSETBUFFER  :=  _readBufferOffset;   
                    
                    _identProfile_Execute           :=  FALSE;
                    _identProfile_SoftReset         :=  FALSE;
                    _identProfile_Init              :=  FALSE;

                    IF NOT _identProfile_Busy THEN
                        THIS.CallTimers(FALSE);
                        _progress:=351;                    
                    END_IF;
                END_IF;
                              
                IF _progress = 351 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#551, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#551;
                    END_IF;

                    _identProfile_Init              :=  TRUE;

                    IF _identProfile_Busy THEN
                        THIS.CallTimers(FALSE);
                        _progress:=352;                    
                    END_IF;
                END_IF;

                IF _progress = 352 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#552, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#552;
                    END_IF;

                    IF(NOT _identProfile_Busy) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=353;                           
                     END_IF;   
                END_IF;
                
                IF _progress = 353 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#553, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#553;
                    END_IF;

                    ReadTask.ThrowWhen(_identProfile_Error);

                    IF(_identProfile_Done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=354;                           
                     END_IF;   
                END_IF;

                IF _progress = 354 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#554, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#554;
                    END_IF;

                    _identProfile_Init :=  FALSE;
                    
                    IF(NOT _identProfile_Done) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=355;                           
                     END_IF;   
                END_IF;

                IF _progress = 355 THEN	
                    ResetReaderTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                ResetReaderTask.ThrowWhen(_errorTimer.output);
                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ResetReaderTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#151;
                ReaderStatus.Error.Id :=  UINT#0;
            ELSIF ResetReaderTask.ErrorOccured() THEN
                ReaderStatus.Action.Id :=  UINT#850;
                ReaderStatus.Error.Id  :=  UINT#850;
            ELSIF ResetReaderTask.AbortTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#851;
                ReaderStatus.Error.Id  :=  UINT#851;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#850,ResetReaderTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#851,ResetReaderTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,ResetReaderTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetReaderTask.RestoreTriggered() AND _progress >= 350 AND _progress <= 359 THEN
                ReaderStatus.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;  
            //*******************************************
            THIS.Close();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            _readAddress                :=  ReadAddress;
            _readNumberOfBytes          :=  ReadNumberOfBytes;
            _readBufferOffset           :=  ReadBufferOffset;
            ReadData                    :=  _readData;
            _writeData                  :=  WriteData;
            _writeAddress               :=  WriteAddress;
            _writeNumberOfBytes         :=  WriteNumberOfBytes;
            _writeBufferOffset          :=  WriteBufferOffset;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            ReadTask.Restore();      
            WriteTask.Restore();
            SoftResetTask.Restore();
            ResetReaderTask.Restore();         
            ReaderStatus.Action.Id :=  UINT#50;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD        
    
        ///<summary>
        /// Reads the data from the transponder into the array of byte.        
        ///</summary>
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                Address         :   DWORD;
                NumberOfBytes   :   WORD;
                BufferOffset    :   UINT;
                Data            :   REF_TO AxoByteArray256;
            END_VAR
            VAR
                _i              :   INT;
            END_VAR

            IF Data = NULL THEN RETURN; END_IF;

            _readAddress        :=  Address; 
            _readNumberOfBytes  :=  NumberOfBytes; 
            _readBufferOffset   :=  BufferOffset;

            IF ReadTask.IsFirstExecutionCycle() THEN
                FOR _i := INT#0 TO INT#255 DO
                    Data^.Data[_i] := BYTE#0;
                END_FOR;
            END_IF;

            Read := ReadTask.Invoke();

            IF ReadTask.DoneReached() THEN
                FOR _i := INT#0 TO TO_INT(NumberOfBytes) - INT#1 DO
                    Data^.Data[_i] := _readData.Data[_i];
                END_FOR;
            END_IF;
        END_METHOD

        ///<summary>
        /// Reads the data from the transponder into the string.        
        ///</summary>
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                Address         :   DWORD;
                NumberOfChars   :   UINT;
                BufferOffset    :   UINT;
            END_VAR
            VAR_OUTPUT
                Data            :   STRING;
            END_VAR
            VAR
                _i              :   INT;
                _data           :   ARRAY[0..255] OF BYTE;
            END_VAR

            _readAddress        :=  Address; 
            _readNumberOfBytes  :=  TO_WORD(NumberOfChars); 
            _readBufferOffset   :=  BufferOffset;

            IF ReadTask.IsFirstExecutionCycle() THEN
                Data := '';
             END_IF;

            Read := ReadTask.Invoke();

            IF ReadTask.DoneReached() THEN
                _data[0]    :=  TO_BYTE(NumberOfChars);
                FOR _i := INT#1 TO TO_INT(NumberOfChars)  DO
                    _data[_i] := _readData.Data[_i - INT#1];
                END_FOR;
                Deserialize(UINT#0,_data,Data);
            END_IF;
        END_METHOD

        ///<summary>
        /// Writes the data from the array of byte into the transponder.
        ///</summary>
        METHOD PUBLIC Write : IAxoTaskState
            VAR_INPUT
                Data            :   REF_TO AxoByteArray256;
                Address         :   DWORD;
                NumberOfBytes   :   WORD;
                BufferOffset    :   UINT;
            END_VAR

            IF Data = NULL THEN RETURN; END_IF;

            _writeData          := Data^; 
            _writeAddress       := Address; 
            _writeNumberOfBytes := NumberOfBytes; 
            _writeBufferOffset  := BufferOffset;

            Write := WriteTask.Invoke();
        END_METHOD

        ///<summary>
        /// Writes the data from the string of byte into the transponder.
        ///</summary>
        METHOD PUBLIC Write : IAxoTaskState
            VAR_INPUT
                Data            :   STRING;
                Address         :   DWORD;
                BufferOffset    :   UINT;
            END_VAR
            VAR
                _i              :   INT;
                _data           :   ARRAY[0..256] OF BYTE;
            END_VAR

            Serialize(UINT#0,Data,_data);
            FOR _i := INT#0 TO LengthOf(Data) DO
                _writeData.Data[_i] := _data[_i + INT#1];
            END_FOR;

            _writeAddress       := Address; 
            _writeNumberOfBytes := TO_WORD(LengthOf(Data)); 
            _writeBufferOffset  := BufferOffset;

            Write := WriteTask.Invoke();
        END_METHOD

        ///<summary>
        /// Soft resets the reader.
        ///</summary>
        METHOD PUBLIC SoftReset : IAxoTaskState
            SoftReset := SoftResetTask.Invoke();
        END_METHOD
    
        ///<summary>
        /// Resets the reader.
        ///</summary>
        METHOD PUBLIC ResetReader : IAxoTaskState
            ResetReader := ResetReaderTask.Invoke();
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