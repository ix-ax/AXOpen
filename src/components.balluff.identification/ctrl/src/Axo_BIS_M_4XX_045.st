USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING System.Strings;
USING System.Serialization;

NAMESPACE AXOpen.Components.Balluff.Identification
    {S7.extern=ReadWrite}
    CLASS Axo_BIS_M_4XX_045 EXTENDS AXOpen.Core.AxoComponent
        VAR PRIVATE
            _infoTimer                  :   AXOpen.Timers.OnDelayTimer;
            _infoTime                   :   LTIME := LT#2S;
            _errorTimer                 :   AXOpen.Timers.OnDelayTimer;
            _errorTime                  :   LTIME := LT#5S;
            _blink                      :   AXOpen.Timers.AxoBlinker;
            _context                    :   IAxoContext;
            _someTaskIsActive           :   BOOL;
            _hwID                       :   WORD;
            _hwId_BISM                  :   WORD;
            _readAddress                :   WORD;
            _readNumberOfBytes          :   WORD;
            _writeAddress               :   WORD;
            _writeNumberOfBytes         :   WORD;
            _writeData                  :   STRING;
            _writeCharCharacter         :   BYTE;
            _writeCharAddress           :   WORD;
            _writeCharNumberOfBytes     :   WORD;
            _CommandDesignator          :   BYTE;
            _StartAddress               :   WORD;	

            _NumberOfBytes              :   WORD;
            _LastTogleBitValue          :   BOOL;
            _ReadWriteData              :   STRING;

            _buffersCountToRead         :   INT;		
            _readedBuffersCount         :   INT;		
            _lenghtInLastReadedBuffer   :   INT;		
            _sendingCommandHeader       :   BOOL;     
            
            _RestCharacter              :   STRING[1]  := '$R';

            _DataToWrite                :   STRING;
            _DataToWriteArr             :   ARRAY[0..255] OF BYTE;
            _SendDataIndex              :   INT;

            _singleLoopIndex            :   INT;
            _endIndex                   :   INT;

            _codeTagPresent_PV          :   BOOL;   
            _power_PV                   :   BOOL;   

        END_VAR

        VAR PUBLIC //HEADER

        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;            

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Read#>"}
            ReadTask : AxoTask;     
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Read address#>"}
            ReadAddress         : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Number of bytes to read#>"}
            ReadNumberOfBytes   : WORD;
   
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write#>"}
            WriteTask : AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write address#>"}
            WriteAddress : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Data to write#>"}
            WriteData    : STRING;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Reset communication#>"}
            ResetCommunicationTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Reset reader#>"}
            ResetReaderTask : AxoTask;     

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Write char to memory#>"}
            WriteCharToMemoryTask : AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Character to write to memory#>"}
            WriteCharCharacter       : BYTE;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Address to write#>"}
            WriteCharAddress         : WORD;
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Number of bytes to write#>"}
            WriteCharNumberOfBytes   : WORD;
        END_VAR
        
        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   Axo_BIS_M_4XX_045_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            ReaderStatus        :   Axo_BIS_M_4XX_045_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
            _progress           :   INT := 0;
        END_VAR

        VAR PUBLIC //Hardware signals
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   Axo_BIS_M_4XX_045_State;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   Axo_BIS_M_4XX_045_Control;
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
                hwID            :   WORD;   
                hwId_BISM       :   WORD;   //  Hardware Id of the reader 
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwId_BISM = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                ReaderStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwId_BISM = WORD#0 THEN
                ReaderStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _hwID            :=  hwID           ;
            _hwId_BISM  :=  hwId_BISM;

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
                hwID            :   WORD;   
                hwId_BISM       :   WORD;   //  Hardware Id of the reader 
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwId_BISM = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                ReaderStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwId_BISM = WORD#0 THEN
                ReaderStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _hwID       :=  hwID;
            _hwId_BISM  :=  hwId_BISM;

            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD

        METHOD PRIVATE Execute 
            VAR 
                _dword          :   DWORD;
                _data           :   ARRAY[0..9] OF BYTE; 
                returnValue     :   WORD;
                _tempString_8   :   STRING[8];
                i               :   INT;
                _index          :   INT;
            END_VAR

            THIS.Open();

            //***********UPDATE**INPUTS******************
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_BISM ,_data);
            Messenger.ActivateOnCondition(ULINT#703,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                ReaderStatus.Error.Id := UINT#703;
                RETURN;
            END_IF;

            Inputs.BitHeader1_CodeTagPresent    := _data[0].%X0;
            Inputs.BitHeader1_JobAccepted       := _data[0].%X1;
            Inputs.BitHeader1_JobEnd            := _data[0].%X2;
            Inputs.BitHeader1_JobError          := _data[0].%X3;
            Inputs.BitHeader1_Reserve0          := _data[0].%X4;
            Inputs.BitHeader1_ToggleBit         := _data[0].%X5;
            Inputs.BitHeader1_HeadFailure       := _data[0].%X6;
            Inputs.BitHeader1_Power             := _data[0].%X7;

            Inputs.Data[0]                      := _data[1];
            Inputs.Data[1]                      := _data[2];
            Inputs.Data[2]                      := _data[3];
            Inputs.Data[3]                      := _data[4];
            Inputs.Data[4]                      := _data[5];
            Inputs.Data[5]                      := _data[6];
            Inputs.Data[6]                      := _data[7];
            Inputs.Data[7]                      := _data[8];

            Inputs.BitHeader2_CodeTagPresent    := _data[9].%X0;
            Inputs.BitHeader2_JobAccepted       := _data[9].%X1;
            Inputs.BitHeader2_JobEnd            := _data[9].%X2;
            Inputs.BitHeader2_JobError          := _data[9].%X3;
            Inputs.BitHeader2_Reserve0          := _data[9].%X4;
            Inputs.BitHeader2_ToggleBit         := _data[9].%X5;
            Inputs.BitHeader2_HeadFailure       := _data[9].%X6;
            Inputs.BitHeader2_Power             := _data[9].%X7;

            IF Inputs.BitHeader2_CodeTagPresent AND NOT _codeTagPresent_PV THEN
                _data[0]    :=  BYTE#8;
                Deserialize(UINT#0,_data,ReaderStatus.UID);
            ELSIF NOT Inputs.BitHeader2_CodeTagPresent AND _codeTagPresent_PV THEN
                ReaderStatus.UID := '';
            END_IF;
            _codeTagPresent_PV  :=   Inputs.BitHeader2_CodeTagPresent;
            
            IF Inputs.BitHeader2_Power AND NOT _power_PV THEN
                ReaderStatus.VersionHighByte := Inputs.Data[0];
                ReaderStatus.VersionLowByte := Inputs.Data[4];
            END_IF;
            _power_PV  :=   Inputs.BitHeader2_Power;
        

            //*******************************************
            _context := THIS.GetContext();

            _infoTime := Config.InfoTime;
            _errorTime := Config.ErrorTime;

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            ReadTask.Initialize(THIS);
            WriteTask.Initialize(THIS);
            ResetCommunicationTask.Initialize(THIS);
            ResetReaderTask.Initialize(THIS);
            WriteCharToMemoryTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(_hwID);
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
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#500, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#500;
                    END_IF;

                    IF Inputs.BitHeader1_CodeTagPresent THEN
                        THIS.CallTimers(FALSE);
                        _progress:=301;                    
                    END_IF;
                END_IF;

                IF _progress = 301 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#501, _infoTimer.output AND Inputs.BitHeader1_JobAccepted, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#502, _infoTimer.output AND Inputs.BitHeader1_JobEnd, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#503, _infoTimer.output AND Inputs.BitHeader1_ToggleBit, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF Inputs.BitHeader1_JobAccepted THEN
                            ReaderStatus.Error.Id := UINT#501;
                        ELSIF Inputs.BitHeader1_JobEnd THEN
                            ReaderStatus.Error.Id := UINT#502;
                        ELSIF Inputs.BitHeader1_ToggleBit THEN
                            ReaderStatus.Error.Id := UINT#503;
                        END_IF;
                    END_IF;
                    _CommandDesignator              :=  BYTE#16#0;
                    _StartAddress                   :=  WORD#16#0;
                    _NumberOfBytes                  :=  WORD#16#0;
                    Outputs.BitHeader1_Job          :=  FALSE;
                    Outputs.BitHeader1_ToggleBit    :=  FALSE;
                    _LastTogleBitValue              :=  FALSE;		
                    _ReadWriteData                  :=  '';
            

                    IF(NOT Inputs.BitHeader1_JobAccepted 
                        AND NOT Inputs.BitHeader1_JobEnd
                        AND NOT Inputs.BitHeader1_ToggleBit) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=304;                           
                         // ------- compute couts buffer to read	----
                         _lenghtInLastReadedBuffer := TO_INT( _readNumberOfBytes) MOD INT#8;
                         _buffersCountToRead :=  TO_INT( _readNumberOfBytes) / INT#8;
                         _readedBuffersCount :=  INT#0 ;
                         
                         IF _lenghtInLastReadedBuffer <> INT#0 THEN
                            _buffersCountToRead :=  _buffersCountToRead + INT#1;
                         END_IF;
                         //--------------------------------------
                     END_IF;   
                END_IF;
                
                IF _progress = 304 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#504, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#504;
                    END_IF;

		            // Set job datas
		            _sendingCommandHeader := TRUE; 
		            _CommandDesignator := BYTE#16#01; //  16#00 -nothing, 16#01 - read, 16#02 - write				
		            _StartAddress := _readAddress;
		            _NumberOfBytes := _readNumberOfBytes;
		            Outputs.BitHeader1_Job := TRUE; // set AV
		            IF Inputs.BitHeader1_JobEnd THEN	
                        THIS.CallTimers(FALSE);
                        _progress:=305;                    
                    END_IF;
                END_IF;
                
                IF _progress = 305 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#505, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#505;
                    END_IF;

                    IF Inputs.BitHeader1_JobAccepted THEN
                        _LastTogleBitValue := Inputs.BitHeader1_ToggleBit;
                        THIS.CallTimers(FALSE);
                        _progress:=306;                    
                    END_IF;
                END_IF;
                
                IF _progress = 306 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#506, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#506;
                    END_IF;
                    _data[0] := BYTE#8;
                    Deserialize(UINT#0, _data , _tempString_8);
                    _ReadWriteData  :=	Concat(_ReadWriteData,_tempString_8);
                    _readedBuffersCount := _readedBuffersCount + INT#1 ;
                    _LastTogleBitValue :=Inputs.BitHeader1_ToggleBit;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress:=307;                    
                    END_IF;             
                END_IF;
                
                IF _progress = 307 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#507, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#507;
                    END_IF;

                    Outputs.BitHeader1_ToggleBit := NOT Outputs.BitHeader1_ToggleBit;
          
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress:=308;                    
                    END_IF;             

                END_IF;
                
                IF _progress = 308 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#508, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#508;
                    END_IF;

		
                    IF(_LastTogleBitValue <> Inputs.BitHeader1_ToggleBit) THEN						
                        _progress := 306;			
                    END_IF;
                    
                    IF(_readedBuffersCount  >= _buffersCountToRead ) THEN	
                        IF _lenghtInLastReadedBuffer <> INT#0 THEN
                            //_ReadWriteData :=	StartOf(_ReadWriteData, _buffersCountToRead * INT#8 - INT#8 + _lenghtInLastReadedBuffer);
                            _ReadWriteData :=	StartOf(_ReadWriteData, TO_INT(_readNumberOfBytes));
                        END_IF;
                        THIS.CallTimers(FALSE);
                        _progress:=309; 
                    END_IF;
                END_IF;
                
                IF _progress = 309 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#509, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#509;
                    END_IF;

                    i := PositionOf(_ReadWriteData,_RestCharacter);
                    IF i > INT#0 THEN
                        _ReadWriteData :=	StartOf(_ReadWriteData, i);
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress:=310;                    
                    END_IF;             
                  
                END_IF;
                
                IF _progress = 310 THEN  
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

 
            //***********WriteTask*******
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

                    IF Inputs.BitHeader1_CodeTagPresent THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#521, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#521;
                    END_IF;

                    _DataToWrite := '';
                    _DataToWrite := _writeData;
                    
                    _index := LengthOf(_DataToWrite);
                            
                    FOR i := _index TO TO_INT(Config.RfidCodeSize) - 1 DO // add at the end rest characters...
                        _DataToWrite := CONCAT(_DataToWrite, _RestCharacter);
                    END_FOR; 
            
                        
                    _index := LengthOf(_DataToWrite); // against computation of lenght..
                    _writeNumberOfBytes := TO_WORD(_index);

                    Serialize(UINT#0,_DataToWrite,_DataToWriteArr);

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress:=322;                    
                    END_IF;             
                END_IF;
              
                IF _progress = 322 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#522, _infoTimer.output AND Inputs.BitHeader1_JobAccepted, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#523, _infoTimer.output AND Inputs.BitHeader1_JobEnd, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#524, _infoTimer.output AND Inputs.BitHeader1_ToggleBit, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF Inputs.BitHeader1_JobAccepted THEN
                            ReaderStatus.Error.Id := UINT#522;
                        ELSIF Inputs.BitHeader1_JobEnd THEN
                            ReaderStatus.Error.Id := UINT#523;
                        ELSIF Inputs.BitHeader1_ToggleBit THEN
                            ReaderStatus.Error.Id := UINT#524;
                        END_IF;
                    END_IF;                    

                    // Clean up
                    _SendDataIndex := 1;
                    _CommandDesignator := BYTE#16#0;
                    _StartAddress := WORD#16#0;
                    _NumberOfBytes := WORD#16#0;
                    Outputs.BitHeader1_Job := FALSE;
                    // Outputs.BitHeader1_ToggleBit := FALSE;
                    
                    IF(NOT Inputs.BitHeader1_JobAccepted 
                        AND NOT Inputs.BitHeader1_JobEnd
                        AND NOT Inputs.BitHeader1_ToggleBit) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;

                IF _progress = 325 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#525, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#525;
                    END_IF;

                    // Set job datas
		            _CommandDesignator := BYTE#16#02; //  16#00 -nothing, 16#01 - read, 16#02 - write		 
                    _SendingCommandHeader := TRUE;
 
		            _StartAddress := _writeAddress;
		
		            _NumberOfBytes := _writeNumberOfBytes;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress:=326;                    
                    END_IF;             

                END_IF;	

                IF _progress = 326 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#526, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#526;
                    END_IF;

                    Outputs.BitHeader1_Job := TRUE;
		
                    IF(Inputs.BitHeader1_JobAccepted) THEN
                        _CommandDesignator := BYTE#16#0;
                        _SendingCommandHeader := FALSE;
                        THIS.CallTimers(FALSE);
                         _progress := 327;
                    END_IF;
                END_IF;	
	
                IF _progress = 327 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#527, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#527;
                    END_IF;
	
                    _singleLoopIndex := 0;
                    _endIndex := _SendDataIndex + 7; 

                    IF(_endIndex > TO_INT(_writeNumberOfBytes)) THEN
                       _endIndex := TO_INT(_writeNumberOfBytes);
                    END_IF;
                    
                    FOR i := _SendDataIndex TO _endIndex BY 1 DO
                        Outputs.Data[_singleLoopIndex] := _DataToWriteArr[_SendDataIndex];
                        _SendDataIndex := _SendDataIndex + 1; 
                        _singleLoopIndex := _singleLoopIndex + 1;
                    END_FOR; 

                    _LastTogleBitValue := Inputs.BitHeader1_ToggleBit;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress:=328;                    
                    END_IF;             
                END_IF;

                IF _progress = 328 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#528, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#528;
                    END_IF;
	
                    Outputs.BitHeader1_ToggleBit := NOT Outputs.BitHeader1_ToggleBit;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress:=329;                    
                    END_IF;             
                END_IF;

                IF _progress = 329 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#529, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#529;
                    END_IF;
	
                    IF _LastTogleBitValue <> Inputs.BitHeader1_ToggleBit THEN
                        _progress := 326;
                    END_IF;
                    
                    IF(Inputs.BitHeader1_JobEnd) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 330;
                    END_IF;
                END_IF;

                IF _progress = 330 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#530, _infoTimer.output AND Inputs.BitHeader1_JobAccepted, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#531, _infoTimer.output AND Inputs.BitHeader1_JobError, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF Inputs.BitHeader1_JobAccepted THEN
                            ReaderStatus.Error.Id := UINT#530;
                        ELSIF Inputs.BitHeader1_JobError THEN
                            ReaderStatus.Error.Id := UINT#531;
                        END_IF;
                    END_IF; 
	
                    Outputs.BitHeader1_Job := FALSE;
                    
                    IF(NOT Inputs.BitHeader1_JobAccepted AND NOT Inputs.BitHeader1_JobError) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;

                IF _progress = 332 THEN	
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
                        
            //****ResetCommunicationTask*****
            ResetCommunicationTask.IsDisabled := FALSE;
            IF ResetCommunicationTask.StartTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#140;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#140,ResetCommunicationTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,ResetCommunicationTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetCommunicationTask.Execute() THEN
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
                    WriteCharToMemoryTask.Restore();
                    ResetReaderTask.Restore();

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;

                IF _progress = 341 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#541, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#541;
                    END_IF;

                    Outputs.BitHeader1_Job := FALSE; // ResetSet AV 
                    Outputs.BitHeader1_GroundState := FALSE; // ResetSet AV 
                    Outputs.BitHeader1_HeadOnOff := FALSE; // ResetSet AV 
                    Outputs.BitHeader1_ToggleBit := NOT Outputs.BitHeader1_ToggleBit; // ResetSet gogle bit 
                    _CommandDesignator := BYTE#16#00; // 16#01 - read, 16#02 - write
                    _SendingCommandHeader := FALSE; 

                    // clear sent data
                    FOR i:=0 TO 7 BY 1 DO 
                        Outputs.Data[i] := BYTE#16#00;
                    END_FOR;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 0;
                        ResetCommunicationTask.DoneWhen(TRUE);
                    END_IF;
                END_IF;
                
	            THIS.CallTimers(TRUE);
                ResetCommunicationTask.ThrowWhen(_errorTimer.output);
                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ResetCommunicationTask.IsFirstExecutionCycle() THEN
                ;
            END_IF;
            IF ResetCommunicationTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#141;
                ReaderStatus.Error.Id :=  UINT#0;
            ELSIF ResetCommunicationTask.ErrorOccured() THEN
                ReaderStatus.Action.Id :=  UINT#840;
                ReaderStatus.Error.Id  :=  UINT#840;
            ELSIF ResetCommunicationTask.AbortTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#841;
                ReaderStatus.Error.Id  :=  UINT#841;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#840,ResetCommunicationTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#841,ResetCommunicationTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,ResetCommunicationTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetCommunicationTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349  THEN
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

                    Outputs.BitHeader1_GroundState := TRUE; // set GR
                    // clear data
                    _CommandDesignator := BYTE#16#00; //  16#00 -nothing, 16#01 - read, 16#02 - write
                    _SendingCommandHeader := FALSE; 
                    _StartAddress := WORD#0;
                    _NumberOfBytes := WORD#0; 
                    
                    FOR	i := 0 TO 7 BY 1 DO 
                        Outputs.Data[i] := BYTE#16#00;		
                    END_FOR;
                    
                    _ReadWriteData := '';

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;

                IF _progress = 351 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#551, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#551;
                    END_IF;

                    Outputs.BitHeader1_GroundState := TRUE;

                    IF NOT Inputs.BitHeader1_Power THEN		//wait for delete BB - Power				
                         THIS.CallTimers(FALSE);
                        _progress := 352;
                    END_IF;
                END_IF;
              
                IF _progress = 352 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#552, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#552;
                    END_IF;

                    Outputs.BitHeader1_GroundState := FALSE;

                    IF Inputs.BitHeader1_Power THEN		//wait for delete BB - Power				
                        THIS.CallTimers(FALSE);
                        _progress := 353;
                    END_IF;
                END_IF;
              
                IF _progress = 353 THEN	
                    ResetReaderTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                ResetReaderTask.ThrowWhen(_errorTimer.output);
                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ResetReaderTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#141;
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
  
            //***********WriteCharToMemoryTask**************
            WriteCharToMemoryTask.IsDisabled := FALSE;
            IF WriteCharToMemoryTask.StartTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#160;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#160,WriteCharToMemoryTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,WriteCharToMemoryTask.IsDone(), eAxoMessageCategory#Info);
            IF WriteCharToMemoryTask.Execute() THEN
                IF _progress = 0 THEN
                    ReaderStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;
                
                IF _progress = 360 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#560, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#560;
                    END_IF;

                    IF Inputs.BitHeader1_CodeTagPresent THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
                
                IF _progress = 361 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#561, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#561;
                    END_IF;
                    
                    Outputs.BitHeader1_Job := TRUE; // set AV
                    _CommandDesignator := BYTE#16#32; //  16#00 -nothing, 16#01 - read, 16#02 - write, 16#32 - fill memory by value
                    _SendingCommandHeader := TRUE; 
                    
                    _StartAddress := _writeCharAddress;
                    _NumberOfBytes := _writeCharNumberOfBytes; 
                    
                    Outputs.Data[5] := _writeCharCharacter; // clear the rest of Sending data
                    Outputs.Data[6] := BYTE#16#00; // clear the rest of Sending data
                    Outputs.Data[7] := BYTE#16#00; // clear the rest of Sending data

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;

                IF _progress = 362 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#562, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#562;
                    END_IF;
                                        
                    IF Inputs.BitHeader1_JobAccepted THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;

                    IF Inputs.BitHeader1_JobError THEN
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;

                IF _progress = 363 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#563, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#563;
                    END_IF;
                            
                    IF Inputs.BitHeader1_JobEnd THEN
                        Outputs.BitHeader1_Job := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 364;
                    END_IF;
                END_IF;
                
                IF _progress = 364 THEN
                    _progress := 0;
                    WriteCharToMemoryTask.DoneWhen(TRUE);
                END_IF;		

                IF _progress = 366 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#566, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#566;
                    END_IF;

                    Outputs.BitHeader1_Job := FALSE; // ResetSet AV 
                    _CommandDesignator := BYTE#16#00; // 16#01 - read, 16#02 - write
                    _SendingCommandHeader := FALSE; 

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress:=367;
                    END_IF;
                END_IF;	
                
                IF _progress = 367 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#567, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#567;
                    END_IF;

                    IF NOT Inputs.BitHeader1_JobAccepted THEN
                        THIS.CallTimers(FALSE);
                        _progress:=368;
                    END_IF;
                END_IF;	

                IF _progress = 368 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#568, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        ReaderStatus.Error.Id := UINT#568;
                    END_IF;

                    IF NOT Inputs.BitHeader1_JobError THEN
                        THIS.CallTimers(FALSE);
                        _progress:=369;
                    END_IF;
                END_IF;	

                IF _progress = 369 THEN
                    _progress := 0;
                    WriteCharToMemoryTask.ThrowWhen(TRUE);
                END_IF;	

                THIS.CallTimers(TRUE);
                
                WriteCharToMemoryTask.ThrowWhen(_errorTimer.output);

                ReaderStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF WriteCharToMemoryTask.IsFirstExecutionCycle() THEN
                ;
            END_IF;
            IF WriteCharToMemoryTask.DoneReached() THEN
                ReaderStatus.Action.Id :=  UINT#161;
                ReaderStatus.Error.Id :=  UINT#0;
            ELSIF WriteCharToMemoryTask.ErrorOccured() THEN
                ReaderStatus.Action.Id :=  UINT#860;
                ReaderStatus.Error.Id  :=  UINT#860;
            ELSIF WriteCharToMemoryTask.AbortTriggered() THEN
                ReaderStatus.Action.Id :=  UINT#861;
                ReaderStatus.Error.Id  :=  UINT#861;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#860,WriteCharToMemoryTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#861,WriteCharToMemoryTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,WriteCharToMemoryTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF WriteCharToMemoryTask.RestoreTriggered() AND _progress >= 360 AND _progress <= 369 THEN
                ReaderStatus.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;  
            //*******************************************

            //***********UPDATE**OUTPUTS*****************
            _data[0].%X0	     := Outputs.BitHeader1_Job;     
            _data[0].%X1	     := Outputs.BitHeader1_Reserve0;    
            _data[0].%X2         := Outputs.BitHeader1_GroundState; 
            _data[0].%X3         := Outputs.BitHeader1_Reserve1;
            _data[0].%X4         := Outputs.BitHeader1_Reserve2;   
            _data[0].%X5         := Outputs.BitHeader1_HeadOnOff; 
            _data[0].%X6         := Outputs.BitHeader1_ToggleBit;    
            _data[0].%X7	     := Outputs.BitHeader1_Reserve3;    

            _data[1]             := Outputs.Data[0];    
            _data[2]     	     := Outputs.Data[1];    
            _data[3]    	     := Outputs.Data[2];    
            _data[4]    	     := Outputs.Data[3];    
            _data[5]    	     := Outputs.Data[4];    
            _data[6]    	     := Outputs.Data[5];    
            _data[7]     	     := Outputs.Data[6];    
            _data[8]    	     := Outputs.Data[7];    

            IF _sendingCommandHeader THEN
                _data[1] := _CommandDesignator;
            END_IF;
            
            IF _CommandDesignator = BYTE#16#01 OR _CommandDesignator = BYTE#16#02 OR _CommandDesignator = BYTE#16#32 THEN // read or write data...
                _data[2] := _StartAddress.%B0;
                _data[3] := _StartAddress.%B1;
                _data[4] := _NumberOfBytes.%B0;
                _data[5] := _NumberOfBytes.%B1;
            ELSE
                _data[2] := Outputs.Data[1];
                _data[3] := Outputs.Data[2];
                _data[4] := Outputs.Data[3];
                _data[5] := Outputs.Data[4];
            END_IF;

            _data[6] :=  Outputs.Data[5];
            _data[7] :=  Outputs.Data[6];
            _data[8] :=  Outputs.Data[7];
 
            _data[9]            :=  _data[0];

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwId_BISM,_data);
            Messenger.ActivateOnCondition(ULINT#704,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                ReaderStatus.Error.Id := UINT#704;
                RETURN;
            END_IF;
            //*******************************************
            THIS.Close();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            _readAddress                :=  ReadAddress;
            _readNumberOfBytes          :=  ReadNumberOfBytes;
            _writeAddress               :=  WriteAddress;
            _writeData                  :=  WriteData;
            _writeCharCharacter         :=  WriteCharCharacter;
            _writeCharAddress           :=  WriteCharAddress;
            _writeCharNumberOfBytes     :=  WriteCharNumberOfBytes;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            ReadTask.Restore();      
            WriteTask.Restore();
            ResetCommunicationTask.Restore();
            ResetReaderTask.Restore();         
            WriteCharToMemoryTask.Restore();
            ReaderStatus.Action.Id :=  UINT#50;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD        
    
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                Address         : WORD;
                NumberOfBytes   : WORD;
            END_VAR
            _readAddress       := Address; 
            _readNumberOfBytes := NumberOfBytes; 
            Read := ReadTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC Write : IAxoTaskState
            VAR_INPUT
                Address : WORD;
                Data    : STRING;
            END_VAR
            _writeAddress   := Address; 
            _writeData      := Data; 

            Write := WriteTask.Invoke();
        END_METHOD

        METHOD PUBLIC ResetCommunication : IAxoTaskState
            ResetCommunication := ResetCommunicationTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC ResetReader : IAxoTaskState
            ResetReader := ResetReaderTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC WriteCharToMemory : IAxoTaskState
            VAR_INPUT
                character       : BYTE;
                Address         : WORD;
                NumberOfBytes   : WORD;
            END_VAR

            _writeCharCharacter         :=  character;
            _writeCharAddress           :=  Address;       
            _writeCharNumberOfBytes     :=  NumberOfBytes; 

            WriteCharToMemory := WriteCharToMemoryTask.Invoke();
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