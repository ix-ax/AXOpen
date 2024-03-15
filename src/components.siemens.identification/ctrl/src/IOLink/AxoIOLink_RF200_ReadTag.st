USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Timers;
USING Siemens.Simatic.S71500.DistributedIO;
USING System.Timer;
USING System.Strings;
USING System.Serialization;


NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoIOLink_RF200_ReadTag 
        VAR PRIVATE
            statPae                 :	ARRAY[0..UPPER_BOUND_NETTO_IO_FIELD] OF BYTE;       //  Partly recived identification data vie Process image
            statStatusByte          :	BYTE    :=  BYTE#0;                                 //  RF200 Tag reader status byte
            statPresence            :	BOOL    :=  FALSE;                                  //  TRUE: Transponder on field
            statState               :	INT     :=  INT#0;	                                //  Main State Machine Index
            statAddr                :	WORD    :=  WORD#0;                                 //  Start address of data on tag
            statOffset              :	INT     :=  INT#0;	                                //  Buffer offset
            statExecuteReq          :	BOOL    :=  FALSE;                                  //  Execute function memory
            statLength              :	DINT    :=  DINT#0;	                                //  Length of read data
            statDat                 :	ARRAY[0..UPPER_BOUND_IO_FIELD] OF BYTE;             //	Data to Send
            statRecDat              :	ARRAY[0..UPPER_BOUND_IO_FIELD] OF BYTE;             //	Data Received
            statAddrOffset          :	INT     :=  INT#0;	                                //  Start adress of port
            statPresenceFF          :	BOOL    :=  FALSE;                                  //  TRUE: Transponder on field
            instTonrTime            :	TimeAccumulator;                                    //  Tag has left antenna field detection timer
            statTimerIn             :	BOOL    :=  FALSE;                                  //  Tag has left antenna field detection timer - Start Tag
            statTimerR              :	BOOL    :=  FALSE;                                  //  Tag has left antenna field detection timer - Reset Tag
            statTimerPt             :	TIME	:=  DETECTION_TIME_TAG_OFF_FIELD;           //  Tag has left antenna field detection timer - Detection time
            statReadData            :	ARRAY[0..UPPER_BOUND_MAX_DATA_FIELD] OF BYTE;		//  Received tag identification data
            statCountCopyPae        :	DINT    :=  DINT#0;	                                //  Length of current next data part in process image
            statBusy                :	BOOL    :=  FALSE;                                  //  TRUE: FB is not finished and new output values can be expected
            statDone                :	BOOL    :=  FALSE;                                  //  TRUE: Commanded functionality has been completed successfully
            statError               :	BOOL    :=  FALSE;                                  //  TRUE: Commanded functionality has been canceled with error
            statReturnMoveBlkVar    :	INT     :=  INT#0;	                                //  Return Value PAE copy function
            statDiffToIOsizeNetto   :	INT     :=  INT#0;	                                //  Difference between requested length and PAE
            statIoPartError         :	BOOL    :=  FALSE;                                  //  TRUE: data in process image is invalid
            statIoPartStatus        :	DWORD   :=  DWORD#0;                                //  Status for IO access
            statIOsize              :	USINT   :=  USINT#0;	                            //  Size of the IO-Link Master PII
            statIOsizeNetto         :	USINT   :=  USINT#0;	                            //  Size of the IO-Link Master PAE without header
            statIdentDataLowIndex   :   INT     :=  INT#0;
            statIdentDataHighIndex  :   INT     :=  INT#0;
        END_VAR

        VAR CONSTANT 
            IOL_V10                         :	USINT   :=  USINT#10;       //  Identifier IO-Link version 1.0
            IOL_V11                         :	USINT   :=  USINT#11;       //  Identifier IO-Link version 1.1
            LEN_DATA_V10                    :	USINT   :=  USINT#8;        //  Length of user data for IO-Link version 1.0
            LEN_DATA_V11                    :	USINT   :=  USINT#32;       //  Length of user data for IO-Link version 1.1
            UPPER_BOUND_IO_FIELD            :	USINT   :=  USINT#31;       //  Upper bound of Input and Output fields
            UPPER_BOUND_NETTO_IO_FIELD      :	USINT   :=  USINT#27;       //  Upper bound of Input and Output fields without header
            UPPER_BOUND_MAX_DATA_FIELD      :	UINT    :=  UINT#1999;      //  Upper bound of the data field of a RFID Tag
            DATA_HEADER_SIZE                :	USINT   :=  USINT#4;        //  IO-Link Header Size for version 1.0 and 1.1
            CMD_READ                        :	BYTE    :=  BYTE#16#02;     //  Command to read data
            CMD_RESET                       :	BYTE    :=  BYTE#16#00;     //  Command to reset
            MIN_LENGTH_V10                  :	WORD    :=  WORD#16#0004;   //  Minimal Lenght of requested tag information
            MIN_LENGTH_V11                  :	WORD    :=  WORD#16#001C;   //  Minimal Lenght of requested tag information
            STATUS_ERROR_IDENT_BLOCK        :	WORD    :=  WORD#16#0001;   //  Error Identification for block internal faults
            STATUS_ERROR_IDENT_RFID         :	WORD    :=  WORD#16#0011;   //  Error Identification for RFID reader faults
            STATUS_NO_JOB                   :	WORD    :=  WORD#16#0000;   //  No job requested
            STATUS_ERROR_TAG_HAS_LEFT       :	WORD    :=  WORD#16#8101;   //  Error - the RFID tag has left the reader
            STATUS_ERROR_STILL_ACTIVE       :	WORD    :=  WORD#16#8102;   //  Error - block still busy, no further request possible
            STATUS_ERROR_LENGTH             :	WORD    :=  WORD#16#8104;   //  Error - requested length is less than 0
            STATE_IDLE                      :	INT     :=  INT#0;          //  State Machine - Idle State
            STATE_READ                      :	INT     :=  INT#2;          //  State Machine - Read Tag
            STATE_TELEGRAM                  :	INT     :=  INT#1;          //  State Machine - Prepare telegram
            STATE_ERROR                     :	INT     :=  INT#3;          //  State Machine - Error State
            DETECTION_TIME_TAG_OFF_FIELD    :	TIME    :=  T#5S;           //  Tag has left antenna field detection time
            INDEX_CMD                       :	USINT   :=  USINT#0;        //  Index in DataField - Command
            INDEX_RFID_ERROR                :	USINT   :=  USINT#1;        //  Index in DataField - Error
            INDEX_ADDR_HIGH                 :	USINT   :=  USINT#2;        //  Index in DataField - Address High Byte
            INDEX_ADDR_LOW                  :	USINT   :=  USINT#3;        //  Index in DataField - Address Low Byte
            INDEX_SOURCE_DATA               :	DINT    :=  DINT#4;         //  Index in Data Field - Start of netto Data

        END_VAR

        METHOD PUBLIC Run
            VAR_INPUT
                execute     :	BOOL    :=  FALSE;          //  Request job (on rising edge)
                addrTag     :	WORD    :=  WORD#16#0;      //  Start address of data on tag
                length      :	WORD    :=  WORD#16#0;      //	Length of data to be read
                hwID        :	WORD    :=  WORD#16#0;      //	Logic IO address of the IO-Link Master
                portAddr    :	INT     :=  INT#0;          //  Start address of port
                version     :	USINT   :=  IOL_V11;        //	IO-Link version of the reader; 11: IO-Link V1.1, 10: IO-Link V1.0
                identData   :   REF_TO  ARRAY[*]OF BYTE;    //  Received tag identification data
            END_VAR         

            VAR_OUTPUT          
                done        :	BOOL;       //  FALSE: data invalid, TRUE: data valid
                busy        :	BOOL;       //  FALSE: no job, TRUE: job in progress
                error       :	BOOL;       //  FALSE: no error, TRUE: error
                status      :	DWORD;      //  Error status
                presence    :	BOOL;       //  TRUE: Transponder on field
            END_VAR

            VAR_TEMP 
                tempStatus  :   DWORD;  //  Auxiliary tag for status output
                tempWord    :   WORD;
                tempIndex   :   INT;       
                tempHWData  :   ARRAY[0..255] OF BYTE;         
            END_VAR

            
            IF identData = NULL THEN
                // TODO some message
                error := TRUE;
                status  := DWORD#16#FEFE0001;
                RETURN;
            END_IF;

            statIdentDataLowIndex := TO_INT(LOWER_BOUND(identData^, 1));
            statIdentDataHighIndex := TO_INT(UPPER_BOUND(identData^, 1));
                    
            
            // INFO HEADER
            //===============================================================================
            // Siemens / (c)Copyright 2022
            //-------------------------------------------------------------------------------
            // Title:            LIOLink_RF200_ReadTag
            // Function:         Reads tags from SIMATIC RF200 readers via IO-Link
            // Library:          LIOLink
            // Author:           Siemens Industry Online Support
            // Tested with:      CPU 1513-1 PN FW 2.8
            // Engineering:      TIA Portal V16
            // Restrictions:     --
            // Requirements:     --
            //-------------------------------------------------------------------------------
            // Change log table:
            // Version  | Date       | Expert in charge       | Changes applied
            //----------|------------|------------------------|------------------------------
            // 01.00.00 | 01.07.2013 | Online Support         | First release
            // 01.01.00 | 01.12.2016 | Online Support         | Upgraded to TIA Portal V14
            // 02.00.00 | 01.09.2017 | Online Support         | Upgraded to TIA Portal V14 SP1
            //                                                | Implemented Programming styleguide
            //                                                | Added support for IO-Link V1.1 readers
            // 02.01.00 | 01.12.2017 | Online Support         | Bug fixes and performance improvements
            // 02.02.00 | 01.03.2020 | Online Support         | Upgraded to TIA Portal V16
            // 02.03.00 | 22.09.2020 | Online Support         | Integrated FB into LIOLink library
            //                                                | Renamed FB to LIOLink_RF200_ReadTag
            //                                                | Combined FBs for IO-Link V1.0 and V1.1
            //                                                | Minor bug fixes
            // 02.04.00 | 29.06.2022 | Online Support         | Minor bug fixes     
            // 02.05.00 | 30.09.2022 | SUP SPH                | Optimization     
            //===============================================================================

            // Check version
            //determine IO-Link reader version (1.0/1.1) to set offsets
            IF version = IOL_V11 THEN
                statIOsize := LEN_DATA_V11;
                statIOsizeNetto := LEN_DATA_V11 - DATA_HEADER_SIZE;
            ELSE
                statIOsize := LEN_DATA_V10;
                statIOsizeNetto := LEN_DATA_V10 - DATA_HEADER_SIZE;
            END_IF;
        
            // Get PII
            statAddrOffset := portAddr;   //start adress of port
            
            // Read PII
            tempWord := Siemens.Simatic.S71500.DistributedIO.ReadData(hwID,tempHWData);
            statIoPartStatus := tempWord;
            statIoPartError := tempWord > WORD#0;

            FOR tempIndex := 0 TO statIOsize - INT#1 DO
                statRecDat[tempIndex]   :=  tempHWData[tempIndex + statAddrOffset];
            END_FOR;
            
            statStatusByte := statRecDat[0];    //Status Byte
            statPresence := statStatusByte.%X5;   //Presence bit. Transponder on field
        
            // Check execute
            // Idle
                IF NOT execute THEN
                    statDone    :=  false;
                    statBusy    :=  false;
                    statError   :=  false;
                    tempStatus  :=  STATUS_NO_JOB;
                END_IF;
            
            // Job requested
                //Positive edge for reading of data
                IF execute AND execute <> statExecuteReq THEN
                    IF NOT statBusy THEN
                        statAddr := addrTag;    //Transpoder Address
                        statDiffToIOsizeNetto := TO_INT(length) MOD statIOsizeNetto;
                        statLength := TO_DINT(length);   //Length of read Dat
                        statBusy := TRUE;
                        statDone := FALSE;
                        statError := FALSE;
                        tempStatus := STATUS_NO_JOB;
                        statOffset := 0;   //offset of puffer must be reseted
                        statState := STATE_READ;    //next step >> send read command
                        statCountCopyPae := 0;

                        FOR tempIndex := statIdentDataLowIndex TO statIdentDataHighIndex DO
                            identData^[tempIndex] := BYTE#0;
                        END_FOR;
                    ELSE
                        tempStatus.%W0 := STATUS_ERROR_STILL_ACTIVE;                       //block is still active
                        tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;                        //Error identifier for block errors
                        statState := STATE_ERROR;
                    END_IF;
                    IF length < WORD#0 OR (length < MIN_LENGTH_V11 AND version = IOL_V11) OR (length < MIN_LENGTH_V10 AND version = IOL_V10) THEN
                        tempStatus.%W0 := STATUS_ERROR_LENGTH;                             //length too short
                        tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;                        //identifier rfid errors
                        statState := STATE_ERROR;
                    END_IF;
                END_IF;
            statExecuteReq := execute;
        
        // Tag presence detection
            IF NOT statPresence AND statPresence <> statPresenceFF THEN   //the tag has left the antenna  field
                IF NOT statDone THEN
                    statTimerIn := true;   //wait 5 sec
                    statTimerR := false;
                END_IF;
            END_IF;
            statPresenceFF := statPresence;
            IF statPresence THEN
                statTimerR := true;
                statTimerIn := false;
            END_IF;
        
        // State machine
            CASE statState OF
                STATE_IDLE:
                    statBusy := false;
                    statTimerIn := false;
                    
                STATE_READ:
                    IF statLength > 0 THEN
                        statDat[INDEX_CMD] := CMD_READ;    //Set read command
                        statDat[INDEX_ADDR_HIGH] := statAddr.%B1;    //Adr-H
                        statDat[INDEX_ADDR_LOW] := statAddr.%B0;   //Adr-L
                    END_IF;
                    
                    IF NOT statIoPartError THEN
                        statState := STATE_TELEGRAM;    //Telegram: Edit the read data
                    END_IF;
                    
                STATE_TELEGRAM:
                    IF statLength > 0 THEN   //Only when length of data>0 can continue  
                        IF statStatusByte.%X6 THEN   //IF RFID error has occured
                            tempStatus.%W0 := statRecDat[INDEX_RFID_ERROR];    //error_RFID
                            tempStatus.%W1 := STATUS_ERROR_IDENT_RFID;    //Error identifier for RFID errors
                            statState := STATE_ERROR;
                        END_IF;
                        
                        //-------------------------- read command is ready------------------------------------------------//
                        IF statStatusByte.%X7 AND statStatusByte.%X1 THEN
                            IF statRecDat[INDEX_ADDR_HIGH] = statAddr.%B1
                                AND statRecDat[INDEX_ADDR_LOW] = statAddr.%B0
                            THEN //received ADR must be ==sent ADR

                                FOR tempIndex := INT#0 TO TO_INT(statIOsizeNetto) - INT#1 DO
                                    statPae[tempIndex]  :=  statRecDat[tempIndex + INDEX_SOURCE_DATA];
                                END_FOR;                                                                          
                                
                                IF NOT statIoPartError THEN
                                    IF statCountCopyPae = 0 THEN    //copy the statIOsizeNet Bytes in 
                                        IF statLength >= statIOsizeNetto THEN
                                            IF statLength <> TO_DINT(length) THEN
                                                statAddr := TO_WORD(TO_INT(statAddr) + statIOsizeNetto);
                                            END_IF;
                                            statState := STATE_READ;
                                            statCountCopyPae := statIOsizeNetto;
                                        ELSE
                                            IF statStatusByte.%X7 AND NOT statStatusByte.%X6 THEN
                                                IF statDiffToIOsizeNetto <> 0 THEN
                                                    statCountCopyPae := statDiffToIOsizeNetto;
                                                    statAddr := TO_WORD(TO_INT(statAddr) + statIOsizeNetto);
                                                    statState := STATE_READ;
                                                ELSE
                                                    statCountCopyPae := statIOsizeNetto;
                                                END_IF;
                                            ELSE
                                                statState := STATE_IDLE;
                                            END_IF;
                                        END_IF;
                                    ELSE
                                        FOR tempIndex := INT#0 TO TO_INT(statCountCopyPae) - INT#1 DO
                                            statReadData[tempIndex + statOffset]  :=  statPae[tempIndex];
                                        END_FOR;                                                                          
                                        
                                        IF statReturnMoveBlkVar = 0 THEN
                                            statCountCopyPae := 0;
                                            statOffset := statOffset + statIOsizeNetto;
                                            statLength := statLength - statIOsizeNetto;
                                        END_IF;
                                    END_IF;
                                ELSE
                                    tempStatus.%W0 := TO_WORD(statIoPartStatus); //Error has to BLKMOV occured
                                    tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;   //functions-Error identifier
                                    statState := STATE_ERROR;
                                END_IF;
                            END_IF;
                        END_IF;

                        FOR tempIndex := INT#0 TO statIOsize - INT#1 DO
                            tempHWData[tempIndex + statAddrOffset] := statDat[tempIndex];
                        END_FOR;
                        //TODO solve overwriting the outputs in case of several RFID header used with one IOLink master 
                        //when SETIO_PART equivalent function is available in AX
                        tempWord := Siemens.Simatic.S71500.DistributedIO.WriteData(hwID,tempHWData);
                        statIoPartStatus := tempWord;
                        statIoPartError := tempWord > WORD#0;
                        
                        IF statIoPartError THEN
                            tempStatus.%W0 := TO_WORD(statIoPartStatus);    //Error has to BLKMOV occured
                            tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;   //functions-Error identifier
                            statState := STATE_ERROR;
                        END_IF;
                        
                    ELSE

                        FOR tempIndex := INT#0 TO statIdentDataHighIndex - statIdentDataLowIndex - INT#1 DO
                            identData^[tempIndex + statIdentDataLowIndex]  :=  statReadData[tempIndex];
                        END_FOR;                               
                            
                        statState := STATE_IDLE;
                        statBusy := false;
                        statDone := true;
                        
                        //Reset read command
                        statDat[INDEX_CMD] := CMD_RESET;

                        FOR tempIndex := INT#0 TO statIOsize - INT#1 DO
                            tempHWData[tempIndex + statAddrOffset] := statDat[tempIndex];
                        END_FOR;
                        //TODO solve overwriting the outputs in case of several RFID header used with one IOLink master 
                        //when SETIO_PART equivalent function is available in AX
                        tempWord := Siemens.Simatic.S71500.DistributedIO.WriteData(hwID,tempHWData);
                        statIoPartStatus := tempWord;
                        statIoPartError := tempWord > WORD#0;
                    END_IF;
                    
                STATE_ERROR:
                    statBusy := false;
                    statDone := false;
                    statError := true;
                    statTimerIn := false;
                    statTimerR := true;
                    statState := STATE_IDLE;
                    
                    //Reset read command
                    statDat[INDEX_CMD] := CMD_RESET;

                    FOR tempIndex := INT#0 TO statIOsize - INT#1 DO
                        tempHWData[tempIndex + statAddrOffset] := statDat[tempIndex];
                    END_FOR;
                    //TODO solve overwriting the outputs in case of several RFID header used with one IOLink master 
                    //when SETIO_PART equivalent function is available in AX
                    tempWord := Siemens.Simatic.S71500.DistributedIO.WriteData(hwID,tempHWData);
                    statIoPartStatus := tempWord;
                    statIoPartError := tempWord > WORD#0;
                ELSE
                    statState := STATE_IDLE;
            END_CASE;
        
            // Detection timer
            instTonrTime(signal := statTimerIn,   //this timer will start, if the tag has left the antenna field
                          reset := statTimerR,
                          duration := statTimerPt);
            IF instTonrTime.output THEN   //error has occured. No tag on field during the 5 sec.
                tempStatus.%W0 := STATUS_ERROR_TAG_HAS_LEFT;    //tag has left the field
                tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;   //identifier rfid errors
                statState := STATE_ERROR;
            END_IF;
        
            // Update output interface 
            done := statDone;
            busy := statBusy;
            error := statError;
            status := tempStatus;
            presence := statPresence;
        END_METHOD
    END_CLASS
END_NAMESPACE
