USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Timers;
USING Siemens.Simatic.S71500.DistributedIO;
USING System.Timer;
USING System.Strings;
USING System.Serialization;


NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoIOLink_RF200_WriteTag 
        VAR PRIVATE 
            instTonR                :	TimeAccumulator;                                //  Tag has left antenna field detection timer
            statState               :	INT     :=  INT#0;                              //	Main State Machine Index
            statTimerIn             :	BOOL    :=  FALSE;                              //  Tag has left antenna field detection timer - Start Tag
            statTimerR              :	BOOL    :=  FALSE;                              //  Tag has left antenna field detection timer - Reset Tag
            statTimerPt             :	TIME    :=  DETECTION_TIME_TAG_OFF_FIELD;       //  Tag has left antenna field detection timer - Detection time
            statStatusByte          :	BYTE    :=  BYTE#16#0;                          //  First received Byte from process image
            statDat                 :	ARRAY[0..UPPER_BOUND_IO_FIELD] OF BYTE;         //  Sent data
            statRecDat              :	ARRAY[0..UPPER_BOUND_IO_FIELD] OF BYTE;         //  Received data
            statPresence            :	BOOL    :=  FALSE;                              //  TRUE: Transponder on field
            statExecuteReq          :	BOOL    :=  FALSE;                              //  State of execute input of last cycle
            statLength              :	DINT    :=  DINT#0;                             //  Length of read Data
            statAddr                :	WORD    :=  WORD#16#0;                          //  Address of Tag
            statWriteOffset         :	INT     :=  INT#0;                              //  Data offset for write function
            statPresenceFf          :	BOOL    :=  FALSE;                              //  Transpnder status of last cycle
            statWriteData           :	ARRAY[0..UPPER_BOUND_MAX_DATA_FIELD] OF BYTE;   //  Data to write to tag
            statDiffToIOsizeNetto   :	INT     :=  INT#0;                              //  Difference to full IO size
            statBytemove            :	INT     :=  INT#0;                              //  Shift value for data
            statDone                :	BOOL    :=  FALSE;                              //  TRUE: job done
            statBusy                :	BOOL    :=  FALSE;                              //  FALSE: no job, TRUE: job in progress
            statError               :	BOOL    :=  FALSE;                              //  FALSE: no error, TRUE: error
            statIoPartError         :	BOOL    :=  FALSE;                              //  TRUE: data in process image is invalid
            statIoPartStatus        :	DWORD   :=  DWORD#16#0;                         //  Status for IO access
            statReturnMoveBlkVar    :	INT     :=  INT#0;                              //  Return Value of Block Move
            statIOsize              :	USINT   :=  USINT#0;                            //  Size of the IO-Link Master PII
            statIOsizeNetto         :	USINT   :=  USINT#0;                            //  Size of the IO-Link Master PAE without header
            statIdentDataLowIndex   :   INT     :=  INT#0;
            statIdentDataHighIndex  :   INT     :=  INT#0;
        END_VAR

        VAR CONSTANT 
            IOL_V10                         :	USINT   :=  USINT#10;       //  Identifier IO-Link version 1.0
            IOL_V11                         :	USINT   :=  USINT#11;       //  Identifier IO-Link version 1.1
            LEN_DATA_V10                    :	USINT   :=  USINT#8;        //  Length of user data for IO-Link version 1.0
            LEN_DATA_V11                    :	USINT   :=  USINT#32;       //  Length of user data for IO-Link version 1.1
            UPPER_BOUND_IO_FIELD            :	USINT   :=  USINT#31;       //  Upper bound of Input and Output fields
            UPPER_BOUND_MAX_DATA_FIELD      :	UINT    :=  UINT#1999;      //  Upper bound of the data field of a RFID Tag
            DATA_HEADER_SIZE                :	USINT   :=  USINT#4;    	//  IO-Link Header Size for version 1.0 and 1.1
            STATUS_ERROR_IDENT_BLOCK        :	WORD    :=  WORD#16#0001;   //  Error Identification for block internal faults
            STATUS_ERROR_IDENT_RFID         :	WORD    :=  WORD#16#0011;   //  Error Identification for RFID reader faults
            STATUS_NO_JOB                   :	WORD    :=  WORD#16#0000;   //  No job requested
            STATUS_ERROR_TAG_HAS_LEFT       :	WORD    :=  WORD#16#8101;   //  Error - the RFID tag has left the reader
            STATUS_ERROR_STILL_ACTIVE       :	WORD    :=  WORD#16#8102;   //  Error - block still busy, no further request possible
            STATUS_ERROR_LENGTH             :	WORD    :=  WORD#16#8104;   //  Error - requested length is less than 0
            STATE_IDLE                      :	INT     :=  INT#0;          //  State Machine - Idle State
            STATE_WRITE                     :	INT     :=  INT#2;          //  State Machine - Read Tag
            STATE_TELEGRAM                  :	INT     :=  INT#1;          //  State Machine - Prepare telegram
            STATE_ERROR                     :	INT     :=  INT#3;          //  State Machine - Error State
            DETECTION_TIME_TAG_OFF_FIELD    :	TIME    :=  T#5S;           //  Tag has left antenna field detection time
            CMD_WRITE                       :	BYTE    :=  BYTE#16#01;     //  Command to read data
            CMD_RESET                       :	BYTE    :=  BYTE#16#00;     //  Command to reset
            INDEX_CMD                       :	USINT   :=  USINT#0;        //  Index in DataField - Command
            INDEX_RFID_ERROR                :	USINT   :=  USINT#1;        //  Index in DataField - Error
            INDEX_ADDR_HIGH                 :	USINT   :=  USINT#2;        //  Index in DataField - Address High Byte
            INDEX_ADDR_LOW                  :	USINT   :=  USINT#3;        //  Index in DataField - Address Low Byte
            INDEX_SOURCE_DATA               :	DINT    :=  DINT#4;         //  Index in Data Field - Start of netto Data
            INDEX_REC_STATUS                :	DINT    :=  DINT#0;         //  Index in Received DataField - Status
        END_VAR

        METHOD PUBLIC Run
            VAR_INPUT
                execute     :	BOOL    :=  FALSE;          //  Execute function
                addrTag     :	WORD    :=  WORD#16#0;      //  Start address of data on tag
                length      :	WORD    :=  WORD#16#0;      //  Length of data to be written
                hwID        :	WORD    :=  WORD#16#0;      //  Hardware identifier of IO-Link communication module
                portAddr    :	INT     :=  INT#0;          //  Start address of port
                version     :	USINT   :=  IOL_V11;        //	IO-Link version of the reader; 11: IO-Link V1.1, 10: IO-Link V1.0
                identData   :   REF_TO  ARRAY[*]OF BYTE;    //  Received tag identification data
            END_VAR         

            VAR_OUTPUT          
                done        :	BOOL;       //  TRUE: job done
                busy        :	BOOL;       //  FALSE: no job, TRUE: job in progress
                error       :	BOOL;       //  FALSE: no error, TRUE: error
                status      :	DWORD;      //  Error Status
                presence    :	BOOL;       //  Tag on antenna field
           
            END_VAR

            VAR_TEMP 
                tempStatus  :   DWORD;  //  Auxiliary tag for status output
                tempWord    :   WORD;
                tempIndex   :   INT;       
                tempHWData  :   ARRAY[0..255]   OF BYTE;         
            END_VAR

            IF identData = NULL THEN
                // TODO some message
                error := TRUE;
                status  := DWORD#16#FEFE0002;
                RETURN;
            END_IF;

            statIdentDataLowIndex := TO_INT(LOWER_BOUND(identData^, 1));
            statIdentDataHighIndex := TO_INT(UPPER_BOUND(identData^, 1));
                    
            
            // INFO HEADER
            //===============================================================================
            // Siemens / (c)Copyright 2022
            //-------------------------------------------------------------------------------
            // Title:            LIOLink_RF200_WriteTag
            // Function:         Writes tags on SIMATIC RF200 readers via IO-Link
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
            // 01.00.00 | 01.03.2015 | Online Support         | First release
            // 01.01.00 | 01.12.2016 | Online Support         | Upgrade to TIA Portal V14
            // 02.00.00 | 01.09.2017 | Online Support         | Upgrade to TIA Portal V14 SP1
            //                                                | Implementation of Programming styleguide
            //                                                | Added support for IO-Link V1.1 readers
            // 02.01.00 | 01.12.2017 | Online Support         | Bug fixes and performance improvements
            // 02.02.00 | 01.03.2020 | Online Support         | Upgrade to TIA Portal V16
            // 02.03.00 | 22.09.2020 | Online Support         | Integrated FB into LIOLink library
            //                                                | Renamed FB to LIOLink_RF200_WriteTag
            //                                                | Combined FBs for IO-Link V1.0 and V1.1
            //                                                | Minor bug fixes
            // 02.04.00 | 04.10.2022 | SUP SPH                | Optimization                                               
            //===============================================================================
            
            // Check version
            IF version = IOL_V11 THEN   //determine IO-Link reader version (1.0/1.1) to set offsets
                statIOsize := LEN_DATA_V11;
                statIOsizeNetto := LEN_DATA_V11 - DATA_HEADER_SIZE;
            ELSE
                statIOsize := LEN_DATA_V10;
                statIOsizeNetto := LEN_DATA_V10 - DATA_HEADER_SIZE;
            END_IF;
        
            // Get PII
            // read data from process image
            tempWord := Siemens.Simatic.S71500.DistributedIO.ReadData(hwID,tempHWData);
            statIoPartStatus := tempWord;
            statIoPartError := tempWord > WORD#0;

            FOR tempIndex := 0 TO statIOsize - INT#1 DO
                statRecDat[tempIndex]   :=  tempHWData[tempIndex + portAddr];
            END_FOR;
            
            statStatusByte := statRecDat[INDEX_REC_STATUS];    //Status Byte
            statPresence := statStatusByte.%X5;   //Presence bit. Transponder on field
        
            // Check execute
            // Idle
                IF NOT execute THEN
                    statDone := false;
                    statBusy := false;
                    statError := false;
                    tempStatus := STATUS_NO_JOB;
                END_IF;
            
            statDiffToIOsizeNetto := TO_INT(length) MOD statIOsizeNetto;
            // Job requested
                IF execute AND execute <> statExecuteReq THEN    //Positive edge for reading of data
                    IF NOT statBusy THEN
                        statAddr := addrTag;    //Transpoder Adress
                        statLength := TO_DINT(length);   //Length of read Data
                        statState := STATE_WRITE;
                        statBusy := TRUE;
                        statDone := FALSE;   //reset all the output parameters                                   
                        statError := FALSE;
                        tempStatus := STATUS_NO_JOB;
                        statWriteOffset := 0;
                        statBytemove := 0;
                        //next step >> send write command
                    ELSE
                        tempStatus.%W0 := STATUS_ERROR_STILL_ACTIVE;    //block is still active
                        tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;   //Error identifier for block errors
                        statState := STATE_ERROR;
                    END_IF;
                    IF length < TO_WORD(statIOsizeNetto) THEN
                        tempStatus.%W0 := STATUS_ERROR_LENGTH;    //length too short
                        tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;   //identifier rfid errors
                        tempStatus := tempStatus;
                        statState := STATE_ERROR;
                    END_IF;
                END_IF;
            statExecuteReq := execute;
        
            // Tag presence detection
            IF NOT statPresence AND statPresence <> statPresenceFf THEN    //the tag has left the antenna  field
                IF NOT statDone THEN
                    statTimerIn := true;   //wait 5 sec
                    statTimerR := false;
                END_IF;
            END_IF;
            statPresenceFf := statPresence;
            IF statPresence THEN
                statTimerR := true;
                statTimerIn := false;
            END_IF;
        
            // State machine
            CASE statState OF
                STATE_IDLE:
                    statWriteOffset := 0;    //offset of puffer must be reseted
                    statBusy := false;
                    statTimerIn := false;
                    
                STATE_WRITE:
                    IF statLength > 0 THEN
                        statDat[INDEX_CMD] := CMD_WRITE;   //Set write command
                        statDat[INDEX_ADDR_HIGH] := statAddr.%B1;    //Adr-H
                        statDat[INDEX_ADDR_LOW] := statAddr.%B0;   //Adr-L

                        FOR tempIndex := INT#0 TO statIdentDataHighIndex - statIdentDataLowIndex - INT#1 DO
                            statWriteData[tempIndex] := identData^[tempIndex + statIdentDataLowIndex];
                        END_FOR;                               
                                                    
                        FOR tempIndex := INT#0 TO TO_INT(statIOsizeNetto) - INT#1 DO
                            statDat[INDEX_SOURCE_DATA + tempIndex]  :=  statWriteData[statWriteOffset - statBytemove + tempIndex];
                        END_FOR;                              
                        //Just statIOsizeNetto Bytes are reserved for every transfer
                    END_IF;
                    IF NOT statIoPartError THEN
                        statState := STATE_TELEGRAM;    //Telegram: Edit the read data
                    END_IF;
                    
                STATE_TELEGRAM:
                    IF statLength > 0 THEN   //Only when length of data>0 can continue  
                        IF statStatusByte.%X6 THEN   //IF RFID error has occured
                            tempStatus.%W0 := statRecDat[INDEX_RFID_ERROR];
                            tempStatus.%W1 := STATUS_ERROR_IDENT_RFID;    //Error identifier for RFID errors
                            statState := STATE_ERROR;
                        END_IF;
                        
                        //-------------------------- write command is ready------------------------------------------------//
                        IF statStatusByte.%X7 AND statStatusByte.%X0 THEN
                            IF statRecDat[INDEX_ADDR_HIGH] = statAddr.%B1 AND statRecDat[INDEX_ADDR_LOW] = statAddr.%B0 THEN //received ADR must be ==sent ADR
                                
                                IF NOT statIoPartError THEN
                                    IF statStatusByte.%X7 AND NOT statStatusByte.%X6 THEN
                                        statLength := statLength - statIOsizeNetto;
                                        IF statDiffToIOsizeNetto <> 0 AND statLength < statIOsizeNetto THEN
                                            statBytemove := statIOsizeNetto - statDiffToIOsizeNetto;
                                        END_IF;
                                        //if len is not dividable with statIOsizeNetto the adr offset has to be changed that the last (length < statIOsizeNetto) command is done right
                                        statWriteOffset := statWriteOffset + statIOsizeNetto;                                   //offset must be changed
                                        statAddr := TO_WORD(TO_INT(statAddr) + TO_INT(statIOsizeNetto) - statBytemove);     //Change the ADR on Transponder(statIOsizeNetto Bytes)       
                                        statState := STATE_WRITE;                      //Start a new write command
                                    ELSE
                                        statState := STATE_IDLE;
                                    END_IF;
                                ELSE
                                    tempStatus.%W0 := TO_WORD(statIoPartStatus);    //Error has to BLKMOV occured
                                    tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;   //functions-Error identifier
                                    statState := STATE_ERROR;
                                END_IF;
                            END_IF;
                        END_IF;
                        
                        FOR tempIndex := INT#0 TO statIOsize - INT#1 DO
                            tempHWData[tempIndex + portAddr] := statDat[tempIndex];
                        END_FOR;
                        //TODO solve overwriting the outputs in case of several RFID header used with one IOLink master 
                        //when SETIO_PART equivalent function is available in AX
                        tempWord := Siemens.Simatic.S71500.DistributedIO.WriteData(hwID,tempHWData);
                        statIoPartStatus := tempWord;
                        statIoPartError := tempWord > WORD#0;

                        IF statIoPartError THEN
                            tempStatus.%W0 := TO_WORD(statIoPartStatus);   //Error has to BLKMOV occured
                            tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;   //functions-Error identifier
                            statState := STATE_ERROR;
                        END_IF;
                        
                    ELSE
                        statState := STATE_IDLE;
                        statBusy := false;
                        statDone := TRUE;
                        
                        //Reset write command
                        statDat[INDEX_CMD] := CMD_RESET;
                        
                        FOR tempIndex := INT#0 TO statIOsize - INT#1 DO
                            tempHWData[tempIndex + portAddr] := statDat[tempIndex];
                        END_FOR;
                        //TODO solve overwriting the outputs in case of several RFID header used with one IOLink master 
                        //when SETIO_PART equivalent function is available in AX
                        tempWord := Siemens.Simatic.S71500.DistributedIO.WriteData(hwID,tempHWData);
                        statIoPartStatus := tempWord;
                        statIoPartError := tempWord > WORD#0;            
                    END_IF;
                    
                STATE_ERROR:
                    statError := TRUE;
                    statBusy := false;
                    statDone := false;
                    statTimerIn := false;
                    statTimerR := true;
                    statState := STATE_IDLE;
                    
                    //Reset write command
                    statDat[INDEX_CMD] := CMD_RESET;
                    
                    FOR tempIndex := INT#0 TO statIOsize - INT#1 DO
                        tempHWData[tempIndex + portAddr] := statDat[tempIndex];
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
            instTonR(signal := statTimerIn,   //this timer will start, if the tag has left the antenna field
                      reset := statTimerR,
                      duration := statTimerPt);
            IF instTonR.output THEN   //error has occured. No tag on field during the 5 sec.
                tempStatus.%W0 := STATUS_ERROR_TAG_HAS_LEFT;  //tag has left the field
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
