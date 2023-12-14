USING AXOpen.Core;
USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoReadWritePROFIdriveParameter EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            Inputs				:	AxoPROFIdriveParametrizationIn;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs				:	AxoPROFIdriveParametrizationOut;
        END_VAR

        VAR PRIVATE
            Enable_PV   :   BOOL;

            Busy_	:   BOOL;
            Done_	:   BOOL;
            Error_	:   BOOL;
            ErrorId_:	DWORD;
            StartTimer : BOOL;
            StartRW : BOOL;

            AxoOnDelatTimer :  AXOpen.Timers.OnDelayTimer;

            RW_Data         :   ARRAY[0..9] OF BYTE;
            WR_Data         :   ARRAY[0..19] OF BYTE;
            RD_Data         :   ARRAY[0..13] OF BYTE;
            RW_Status        :	DWORD;
            WR_Status        :	DWORD;
            RD_Status        :	DWORD;
                
            ReadRecord_     :   ReadRecord;
            WriteRecord_    :   WriteRecord;
            ErrorCounter    :	UINT;

            LengthRead      :	UINT;
            State           :   INT;
            ReqRef          :   BYTE;
            wordhlp         :   WORD;
        END_VAR

        VAR CONSTANT PRIVATE 
            LenHeader	    :   UINT    :=	UINT#4;
            LenRequest	    :   UINT    :=  UINT#6;
            LenWrite	    :   UINT    :=  UINT#16;
            LenRead	        :   UINT    :=  UINT#10;
            PD_Error	    :   DWORD	:=  DWORD#16#4000_0000;
            MaxRetryCounter	:   UINT    :=	UINT#150;

        END_VAR

        METHOD PUBLIC Run
            VAR_INPUT
                parent          :   IAxoObject; 
            END_VAR            

            THIS.Initialize(parent);
            THIS.Execute();

        END_METHOD

        METHOD PUBLIC Run
            VAR_INPUT
                parent          :   IAxoContext; 
            END_VAR            

            THIS.Initialize(parent);
            THIS.Execute();

        END_METHOD

        METHOD PUBLIC Execute
            
            VAR
                _lenght     :   UINT;
                i           :   INT;
                tmpWord     :   WORD;
                tmpSINT     :   SINT;
                tmpINT      :   INT;
                tmpDINT     :   DINT;
                tmpDWORD    :   DWORD;
                tmpLINT     :   LINT;
            END_VAR

                //Check the Inputs
                IF Inputs.HardwareId = WORD#0 THEN
                    Error_ := TRUE;
                    ErrorId_ := DWORD#16#00001010;    //Inputs.HardwareId = 0
                    RETURN;
                END_IF;

                //Timer
                AxoOnDelatTimer.OnDelay(THIS, StartTimer,T#100MS);

                IF AxoOnDelatTimer.output THEN
                    StartRW := TRUE;
                    StartTimer := FALSE;
                END_IF;

                IF State = 0 THEN //Wait for start trigger
                    IF Inputs.Enable AND NOT Enable_PV THEN
                        StartRW := TRUE;
                        State := 10;
                        Outputs.Busy := TRUE;
                    END_IF;
                END_IF;

                IF State = 10 THEN
                    (* ------------------ HEADER --------------------*)
                    //Request reference starts with 1 and will count up 
                    RW_Data[0] := ReqRef;
                    // Requst ID = 1 (Request Parameter)
                    RW_Data[1] := BYTE#1;
                    //Fill the Axis number
                    RW_Data[2] := Inputs.AxisNo;
                    // Single parameter access
                    RW_Data[3] := BYTE#1;
                    (* ------------------ Parameter address ------------*)
                    //Attribute
                    RW_Data[4]:= BYTE#16#10;
                    //ElemNo.
                    RW_Data[5] := BYTE#1;
                    // Assign PNU
                    RW_Data[6] := Inputs.ParameterNo.%B1;
                    RW_Data[7] := Inputs.ParameterNo.%B0;
                    // Assign Subindex
                    RW_Data[8] := Inputs.Subindex.%B1;
                    RW_Data[9] := Inputs.Subindex.%B0;

                    // Lenght of the telegramm to be send
                    _lenght := LenHeader + LenRequest;
                    
                    WriteRecord_(request    :=  StartRW,
                                id          :=  Inputs.HardwareId,
                                index       :=  16#b02e,
                                length      :=  _lenght,
                                record      :=  RW_Data,      
                                status      =>  WR_Status);


                    IF WriteRecord_.DONE THEN
                        ErrorCounter := UINT#0;
                        //delete old response values
                        FOR i := 0 TO 13 DO
                            RD_Data[i] := BYTE#0;
                        END_FOR;
                        
                        IF NOT Inputs.ReadWrite THEN
                            //Read parameter
                            State := 20;
                        ELSE
                            //Write parameter
                            State := 50;
                        END_IF;
                    ELSIF WriteRecord_.ERROR THEN
                        tmpWord := TO_WORD(TO_DINT(WR_Status)/256);
                        wordhlp := tmpWord;
                        //try it again
                        IF ((tmpWord = WORD#16#80A7) OR (tmpWord = WORD#16#80B5) OR (tmpWord = WORD#16#80C0) OR (tmpWord = WORD#16#80C1) OR (tmpWord = WORD#16#80C2)
                            OR (tmpWord = WORD#16#80C3) OR (tmpWord = WORD#16#80C4)) AND (ErrorCounter < MaxRetryCounter) THEN
                            ErrorCounter := ErrorCounter + UINT#1;
                            StartRW := FALSE;
                            StartTimer := TRUE;
                        ELSE
                            State := 70;
                        END_IF;
                        
                    END_IF;
                END_IF;

                IF State = 20 THEN  //Read Parameter
                    // Lenght of the telegramm for reading
                    _lenght := LenHeader + LenRead;
                    
                    ReadRecord_(request     :=  StartRW,
                                id          :=  Inputs.HardwareId,
                                index       :=  16#b02e,
                                maxLength   :=  _lenght,
                                record      :=  RD_Data,      
                                status      =>  RD_Status,
                                length      =>  LengthRead);

                    IF ReadRecord_.VALID AND NOT ReadRecord_.BUSY THEN
                        ErrorCounter := UINT#0;
                        State := 30;
                    ELSIF ReadRecord_.ERROR THEN
                        tmpWord := TO_WORD(TO_DINT(RD_Status) / 256);
                        wordhlp := tmpWord;
                        //try it again
                        IF ((tmpWord = WORD#16#80A7) OR (tmpWord = WORD#16#80B5) OR (tmpWord = WORD#16#80C0) OR (tmpWord = WORD#16#80C1) OR (tmpWord = WORD#16#80C2)
                            OR (tmpWord = WORD#16#80C3) OR (tmpWord = WORD#16#80C4)) AND (ErrorCounter < MaxRetryCounter) THEN
                            ErrorCounter := ErrorCounter + UINT#1;
                            StartRW := FALSE;
                            StartTimer := TRUE;
                        ELSE
                            State := 80;
                        END_IF;
                    END_IF;
                END_IF;

                IF State = 30 THEN //Reading finished successfull

                    CASE TO_INT(RD_Data[4]) OF //Format
                        0:  //reserved
                            Outputs.ValueReadREAL := REAL#0.0;
                            Outputs.ValueReadLINT := LINT#0;
                            Outputs.ValueReadBOOL := FALSE;
                            
                            Outputs.ErrorId := DWORD#16#1001;    //reserved DataType
                            // #Error
                            State := 200;
                            
                        1:  // BOOLEAN 
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := 0;
                            Outputs.ValueReadBOOL := TO_BOOL(RD_Data[6]);
                            
                            // no error
                            State := 100;
                            
                        2:  //SINT8
                            tmpSINT := TO_SINT(RD_Data[6]);
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := (TO_LINT(tmpSINT));
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no error
                            State := 100;
                            
                        3:  //SINT16
                            tmpINT.%B0 := RD_Data[7];
                            tmpINT.%B1 := RD_Data[6];
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := TO_LINT(tmpINT);
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no #Error
                            State := 100;
                            
                        4:  //SINT32
                            tmpDINT.%B0 := RD_Data[9];
                            tmpDINT.%B1 := RD_Data[8];
                            tmpDINT.%B2 := RD_Data[7];
                            tmpDINT.%B3 := RD_Data[6];
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := TO_LINT(tmpDINT);
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no #Error
                            State := 100;
                            
                        5, 65: //USINT8(5) or BYTE(65)
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := (TO_LINT(RD_Data[6]));
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no error
                            State := 100;
                            
                        6, 66: //UINT16(6) or WORD(66)
                            tmpWord.%B0 := RD_Data[7];
                            tmpWord.%B1 := RD_Data[6];
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := TO_LINT(tmpWord);
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no #Error
                            State := 100;
                            
                        7, 67: //UDINT32(7) or DWORD(67)
                            tmpDWord.%B0 := RD_Data[9];
                            tmpDWord.%B1 := RD_Data[8];
                            tmpDWord.%B2 := RD_Data[7];
                            tmpDWord.%B3 := RD_Data[6];
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := TO_LINT(tmpDWord);
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no #Error
                            State := 100;
                            
                        8:  //FLOAT32
                            tmpDWord.%B0 := RD_Data[9];
                            tmpDWord.%B1 := RD_Data[8];
                            tmpDWord.%B2 := RD_Data[7];
                            tmpDWord.%B3 := RD_Data[6];
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := TO_REAL(tmpDWord);
                            Outputs.ValueReadLINT := 0;
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no #Error
                            State := 100;
                            
                        10:  //OctetString
                            tmpINT.%B0 := RD_Data[6];
                            tmpINT.%B1 := RD_Data[7];
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := TO_LINT(tmpINT);
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no #Error
                            State := 100;
                            
                            
                        55, 56:  //LINT, ULINT
                            tmpLINT.%B0 :=RD_Data[13];
                            tmpLINT.%B1 :=RD_Data[12];
                            tmpLINT.%B2 :=RD_Data[11];
                            tmpLINT.%B3 :=RD_Data[10];
                            tmpLINT.%B4 :=RD_Data[9];
                            tmpLINT.%B5 :=RD_Data[8];
                            tmpLINT.%B6 :=RD_Data[7];
                            tmpLINT.%B7 :=RD_Data[6];
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := tmpLINT;
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // no #Error
                            State := 100;
                            
                        68:  //Error
                            tmpDWord.%B0 := RD_Data[7];
                            tmpDWord.%B1 := RD_Data[6];
                            Outputs.ErrorId := tmpDWord OR PD_Error;
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := 0;
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // #Error
                            State := 200;
                            
                        ELSE
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := 0;
                            Outputs.ValueReadBOOL := FALSE;
                            
                            Outputs.ErrorId := DWORD#16#1000;    //unknown DataType
                            // #Error
                            State := 200;
                    END_CASE;
                END_IF;

                IF State = 50 THEN //Write Parameter (First Read dataset then write dataset)
                    // Lenght of the telegramm for reading
                    _lenght := LenHeader + LenRead;

                    ReadRecord_(request     :=  StartRW,
                                id          :=  Inputs.HardwareId,
                                index       :=  16#b02e,
                                maxLength   :=  _lenght,
                                record      :=  RD_Data,      
                                status      =>  RD_Status,
                                length      =>  LengthRead);

                    IF ReadRecord_.VALID AND NOT ReadRecord_.BUSY THEN
                        ErrorCounter := UINT#0;
                        State := 55;
                    ELSIF ReadRecord_.ERROR THEN
                        tmpWord := TO_WORD(TO_DINT(RD_Status)/256);
                        wordhlp := tmpWord;
                        //try it again
                        IF ((tmpWord = WORD#16#80A7) OR (tmpWord = WORD#16#80B5) OR (tmpWord = WORD#16#80C0) OR (tmpWord = WORD#16#80C1) OR (tmpWord = WORD#16#80C2)
                            OR (tmpWord = WORD#16#80C3) OR (tmpWord = WORD#16#80C4)) AND (ErrorCounter < MaxRetryCounter) THEN
                            ErrorCounter := ErrorCounter + UINT#1;
                            StartRW := false;
                            StartTimer := TRUE;
                        ELSE
                            State := 80;
                        END_IF;
                    END_IF;
                END_IF;

                IF State = 55 THEN //Reading finished
                    CASE TO_INT(RD_Data[4]) OF // Format
                        0:  //reserved
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := 0;
                            Outputs.ValueReadBOOL := FALSE;

                            Outputs.ErrorId := DWORD#16#1001;    //reserved DataType
                            // #Error
                            State := 200;
                            
                        1, 2, 3, 4, 5, 6, 7, 8, 55, 56, 65, 66, 67:
                            State := 60;
                            
                        68:  //Error
                            tmpDWord.%B0 := RD_Data[7];
                            tmpDWord.%B1 := RD_Data[6];
                            Outputs.ErrorId := tmpDWord OR PD_Error;
                            
                            //copy the value to the output
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := 0;
                            Outputs.ValueReadBOOL := FALSE;
                            
                            // #Error
                            State := 200;
                            
                        ELSE
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := 0;
                            Outputs.ValueReadBOOL := FALSE;
                            
                            Outputs.ErrorId := DWORD#16#1000;    //unknown DataType
                            // #Error
                            State := 200;
                    END_CASE;
                END_IF;

                IF State = 60 THEN //reading Done from Write request
                    (* ------------------ HEADER --------------------*)
                    //Request reference starts with 1 and will count up 
                    WR_Data[0] := TO_BYTE(TO_INT(ReqRef) + 1);
                    // Requst ID = 2 (Change Parameter)
                    WR_Data[1] := BYTE#2;
                    //Fill the Axis number
                    WR_Data[2] := Inputs.AxisNo;
                    // Single parameter access
                    WR_Data[3] := BYTE#1;
                    (* ------------------ DATA --------------------*)
                    // Attribute
                    WR_Data[4] := BYTE#16#10;
                    // Single Access
                    WR_Data[5] := BYTE#1;
                    // PNU
                    WR_Data[6] := Inputs.ParameterNo.%B1;
                    WR_Data[7] := Inputs.ParameterNo.%B0;
                    // Subindex
                    WR_Data[8] := Inputs.Subindex.%B1;
                    WR_Data[9] := Inputs.Subindex.%B0;
                    //Format
                    WR_Data[10] := RD_Data[4];
                    //No. Values
                    WR_Data[11] := BYTE#1;
                    //erase send buffer
                    FOR i := 12 TO 19 DO
                        WR_Data[i] := BYTE#0;
                    END_FOR;
                    
                    CASE TO_INT(RD_Data[4]) OF //Format
                        0:  //reserved
                            Outputs.ValueReadREAL := 0;
                            Outputs.ValueReadLINT := 0;
                            Outputs.ValueReadBOOL := FALSE;
                            
                            Outputs.ErrorId := DWORD#16#1001;    //reserved DataType
                            // #Error
                            State := 200;
                            
                        1:  //BOOL
                            WR_Data[12] := TO_BYTE(Inputs.ValueWriteBOOL);
                            
                        2, 5, 65:  //SINT8, USINT8, BYTE
                            WR_Data[12] := TO_BYTE(Inputs.ValueWriteLINT);
                            
                        3, 6, 66:  //SINT16, UINT16, WORD
                            WR_Data[12] := Inputs.ValueWriteLINT.%B1;
                            WR_Data[13] := Inputs.ValueWriteLINT.%B0;
                            
                        4, 7, 67: //SINT32, UDINT32, DWORD
                            WR_Data[12] := Inputs.ValueWriteLINT.%B3;
                            WR_Data[13] := Inputs.ValueWriteLINT.%B2;
                            WR_Data[14] := Inputs.ValueWriteLINT.%B1;
                            WR_Data[15] := Inputs.ValueWriteLINT.%B0;
                            
                        8:  //FLOAT32
                            tmpDWORD    :=  TO_DWORD(Inputs.ValueWriteREAL);
                            WR_Data[12] := tmpDWORD.%B3;
                            WR_Data[13] := tmpDWORD.%B2;
                            WR_Data[14] := tmpDWORD.%B1;
                            WR_Data[15] := tmpDWORD.%B0;
                            
                        55, 56:  //SINT64
                            WR_Data[12] := Inputs.ValueWriteLINT.%B7;
                            WR_Data[13] := Inputs.ValueWriteLINT.%B6;
                            WR_Data[14] := Inputs.ValueWriteLINT.%B5;
                            WR_Data[15] := Inputs.ValueWriteLINT.%B4;
                            WR_Data[16] := Inputs.ValueWriteLINT.%B3;
                            WR_Data[17] := Inputs.ValueWriteLINT.%B2;
                            WR_Data[18] := Inputs.ValueWriteLINT.%B1;
                            WR_Data[19] := Inputs.ValueWriteLINT.%B0;
                            
                    END_CASE;
                    
                    //goto the next step
                    State := 61;
                END_IF;

                IF State = 61 THEN //send the write Request
                    // Lenght of the telegramm to be send
                    _lenght := LenHeader + LenWrite;

                    WriteRecord_(request    :=  StartRW,
                                id          :=  Inputs.HardwareId,
                                index       :=  16#b02e,
                                length      :=  _lenght,
                                record      :=  WR_Data,      
                                status      =>  RW_Status);

                    IF WriteRecord_.DONE THEN
                        State := 62;
                    ELSIF WriteRecord_.ERROR THEN
                        tmpWord := TO_WORD(TO_DINT(RW_Status)/256);
                        wordhlp := tmpWord;
                        //try it again
                        IF ((tmpWord = WORD#16#80A7) OR (tmpWord = WORD#16#80B5) OR (tmpWord = WORD#16#80C0) OR (tmpWord = WORD#16#80C1) OR (tmpWord = WORD#16#80C2)
                            OR (tmpWord = WORD#16#80C3) OR (tmpWord = WORD#16#80C4)) AND (ErrorCounter < MaxRetryCounter) THEN
                            ErrorCounter := ErrorCounter + UINT#1;
                            StartRW := FALSE;
                            StartTimer := TRUE;
                        ELSE
                            State := 90;
                        END_IF;
                    END_IF;
                END_IF;

                IF State = 62 THEN //Read the answer of the write request
                    
                    //delete old response values
                    FOR i := 0 TO 13 DO
                        RD_Data[i] := BYTE#0;
                    END_FOR;
                    
                    // Lenght of the telegramm for reading
                    _lenght := LenHeader + LenRead;

                    ReadRecord_(request     :=  StartRW,
                                id          :=  Inputs.HardwareId,
                                index       :=  16#b02e,
                                maxLength   :=  _lenght,
                                record      :=  RD_Data,      
                                status      =>  RD_Status,
                                length      =>  LengthRead);

                    IF ReadRecord_.VALID AND NOT ReadRecord_.BUSY THEN
                        ErrorCounter := UINT#0;
                        State := 63;
                    ELSIF ReadRecord_.ERROR THEN
                        tmpWord := TO_WORD(TO_DINT(RD_Status)/256);
                        wordhlp := tmpWord;
                        //try it again
                        IF ((tmpWord = WORD#16#80A7) OR (tmpWord = WORD#16#80B5) OR (tmpWord = WORD#16#80C0) OR (tmpWord = WORD#16#80C1) OR (tmpWord = WORD#16#80C2)
                            OR (tmpWord = WORD#16#80C3) OR (tmpWord = WORD#16#80C4)) AND (ErrorCounter < MaxRetryCounter) THEN
                            ErrorCounter := ErrorCounter + UINT#1;
                            StartRW := FALSE;
                            StartTimer := TRUE;
                        ELSE
                            State := 80;
                        END_IF;
                    END_IF;
                END_IF;

                IF State = 63 THEN //Reading finished

                    CASE TO_INT(RD_Data[1]) OF //ReqId
                            
                        2:  //positive resonse
                            State := 150;
                            
                        128..130:  //negative response
                            IF RD_Data[4] = BYTE#68 THEN //Format
                                tmpDWord.%B0 := RD_Data[7];
                                tmpDWord.%B1 := RD_Data[6];
                                Outputs.ErrorId := tmpDWord OR PD_Error;
                                
                                // #Error
                                State := 200;
                            ELSE
                                Outputs.ErrorId := DWORD#16#1003; //negative response without error code
                                State := 300;
                            END_IF;
                        ELSE  //undefined response ID
                            Outputs.ErrorId := DWORD#16#1002;
                            State := 300;
                    END_CASE;
                END_IF;

                IF State = 70 THEN // Error while ReadWrite Access
                    Outputs.Done := TRUE;
                    Outputs.Busy := FALSE;
                    Outputs.Error := TRUE;
                    Outputs.ErrorId := WR_Status;
                END_IF;

                IF State = 80 THEN //Error Reading Access
                    Outputs.Done := TRUE;
                    Outputs.Busy := FALSE;
                    Outputs.Error := TRUE;
                    Outputs.ErrorId := RD_Status;
                END_IF;

                IF State = 90 THEN // Error while Write Access
                    Outputs.Done := TRUE;
                    Outputs.Busy := FALSE;
                    Outputs.Error := TRUE;
                    Outputs.ErrorId := RW_Status;
                END_IF;


                IF State = 100 THEN // read successfully
                    Outputs.Done := TRUE;
                    Outputs.Busy := FALSE;
                    Outputs.Error := FALSE;
                END_IF;

                IF State = 150 THEN // write successfully
                    Outputs.Done := TRUE;
                    Outputs.Busy := FALSE;
                    Outputs.Error := FALSE;
                END_IF;

                IF State = 200 THEN //Error while reading
                    Outputs.Done := TRUE;
                    Outputs.Busy := FALSE;
                    Outputs.Error := TRUE;
                    
                    IF State = 300 THEN //Error while writing
                        Outputs.Done := TRUE;
                        Outputs.Busy := FALSE;
                        Outputs.Error := TRUE;
                    END_IF;
                END_IF;

                IF NOT Inputs.Enable THEN
                    State := 0;
                    ReqRef := BYTE#1;
                    Outputs.Done := FALSE;
                    Outputs.Busy := FALSE;
                    Outputs.Error := FALSE;
                    Outputs.ErrorId := DWORD#16#00000000;
                    Outputs.ValueReadBOOL := FALSE;
                    Outputs.ValueReadLINT := 0;
                    Outputs.ValueReadREAL := 0;
                    RD_Status := DWORD#0;
                    ErrorCounter := UINT#0;
                END_IF;

                Enable_PV := Inputs.Enable;

        END_METHOD
    END_CLASS
END_NAMESPACE