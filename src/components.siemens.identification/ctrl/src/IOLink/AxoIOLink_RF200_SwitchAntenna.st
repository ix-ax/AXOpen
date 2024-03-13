USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Timers;
USING Siemens.Simatic.S71500.DistributedIO;
USING System.Timer;
USING System.Strings;
USING System.Serialization;


NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoIOLink_RF200_SwitchAntenna 
        VAR PRIVATE
            statExecuteReq      :	BOOL    :=  FALSE;                          //  State of execute input of last cycle
            statAntStatus       :	BYTE    :=  BYTE#16#0;                      //  Status Byte of antenna
            statState           :	UINT    :=  UINT#0;                         //  Main State Machine Index
            statAnt             :	ARRAY[0..UPPER_BOUND_IO_FIELD] OF BYTE;     //  Received buffer of Antenna data
            statSent            :	ARRAY[0..UPPER_BOUND_IO_FIELD] OF BYTE;     //  Sent buffer for Antenna
            statPresence        :	BOOL    :=  FALSE;                          //  Presence bit. Transponder on field
            statBusy            :	BOOL    :=  FALSE;                          //  TRUE: Job active
            statIoPartError     :	BOOL    :=  FALSE;                          //  TRUE: data in process image is invalid
            statIoPartStatus    :	DWORD   :=  DWORD#16#0;                     //	Status for IO access
            statIOsize          :	INT     :=  INT#0;                          //  Size of the IO-Link Master PII
        END_VAR

        VAR CONSTANT 
            IOL_V10                         :	USINT   :=  USINT#10;       //  Identifier IO-Link version 1.0
            IOL_V11                         :	USINT   :=  USINT#11;       //  Identifier IO-Link version 1.1
            LEN_DATA_V10                    :	USINT   :=  USINT#8;        //  Length of user data for IO-Link version 1.0
            LEN_DATA_V11                    :	USINT   :=  USINT#32;       //  Length of user data for IO-Link version 1.1
            UPPER_BOUND_IO_FIELD            :	USINT   :=  USINT#31;       //  Upper bound of Input and Output fields
            STATE_IDLE                      :	UINT    :=  UINT#0;         //  State Machine - Idle State
            STATE_ANTENNA_ON                :	UINT    :=  UINT#1;         //  State Machine - Switch Antenna on
            STATE_ANTENNA_OFF               :	UINT    :=  UINT#2;         //  State Machine - Switch Antenna off
            STATE_READY                     :	UINT    :=  UINT#3;         //  State Machine - Job done
            STATUS_ERROR_IDENT_BLOCK        :	WORD    :=  WORD#16#0001;   //  Error Identification for block internal faults
            STATUS_ERROR_IDENT_RFID         :	WORD    :=  WORD#16#0011;   //  Error Identification for RFID reader faults
            STATUS_NO_JOB                   :	WORD    :=  WORD#16#0000;   //  No job requested
            STATUS_ERROR_TAG_HAS_LEFT       :	WORD    :=  WORD#16#8101;   //  Error - the RFID tag has left the reader
            STATUS_ERROR_STILL_ACTIVE       :	WORD    :=  WORD#16#8102;   //  Error - block still busy, no further request possible
            STATUS_ERROR_LENGTH             :	WORD    :=  WORD#16#8104;   //  Error - requested length is less than 0
            CMD_ANTENNA_ON                  :	BYTE    :=  BYTE#16#00;     //  Command to switsch antenna on
            CMD_ANTENNA_OFF                 :	BYTE    :=  BYTE#16#10;     //  Command to switsch antenna off
            INDEX_ANT_STATUS                :	USINT   :=  USINT#0;        //  Index in Antenna DataField - Status
            INDEX_RFID_ERROR                :	USINT   :=  USINT#1;        //  Index in Antenna DataField - Error
            INDEX_SEND_CMD                  :	USINT   :=  USINT#0;        //  Index in Send DataField - Command

        END_VAR

        METHOD PUBLIC Run
            VAR_INPUT
                execute     :	BOOL    :=  FALSE;          //  Execute function
                antennaState:	BOOL    :=  FALSE;          //  TRUE: activate antenna, FALSE: deactivate antenna
                hwID        :	WORD    :=  WORD#16#0;      //  Hardware identifier of IO-Link communication module
                portAddr    :	INT     :=  INT#0;          //  Start address of port
                version     :	USINT   :=  IOL_V11;        //	IO-Link version of the reader; 11: IO-Link V1.1, 10: IO-Link V1.0
            END_VAR         

            VAR_OUTPUT          
                done        :	BOOL;       //  TRUE: job done
                busy        :	BOOL;       //  TRUE: Job active
                error       :	BOOL;       //  TRUE: Error has occured
                status      :	DWORD;      //  Error Status
                presence    :	BOOL;       //  TRUE: Transponder on field
            END_VAR

            VAR_TEMP 
                tempDone	:   BOOL;   //  Auxiliary tag for done output
                tempError	:   BOOL;   //  Auxiliary tag for error output
                tempStatus  :   DWORD;  //  Auxiliary tag for status output
                            
                tempWord    :   WORD;
                tempData    :   ARRAY[0..255]   OF BYTE;         
                tempIndex   :   INT;    
                
            END_VAR

            // INFO HEADER
            //===============================================================================
            // Siemens / (c)Copyright 2022
            //-------------------------------------------------------------------------------
            // Title:            LIOLink_RF200_SwitchAntenna
            // Function:         Switches the antenna of SIMATIC RF200 readers via IO-Link
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
            // 01.01.00 | 01.12.2016 | Online Support         | Upgrade to TIA Portal V14
            // 02.00.00 | 01.09.2017 | Online Support         | Upgrade to TIA Portal V14 SP1
            //                                                | Implementation of Programming styleguide
            //                                                | Added support for IO-Link V1.1 readers
            // 02.01.00 | 01.12.2017 | Online Support         | Bug fixes and performance improvements
            // 02.02.00 | 01.03.2020 | Online Support         | Upgrade to TIA Portal V16
            // 02.03.00 | 22.09.2020 | Online Support         | Integrated FB into LIOLink library
            //                                                | Renamed FB to LIOLink_RF200_SwitchAntenna
            //                                                | Combined FBs for IO-Link V1.0 and V1.1
            //                                                | Minor bug fixes
            // 02.04.00 | 04.10.2022 | SUP SPH                | Optimization
            //===============================================================================
        
            // Check version
            IF version = IOL_V11 THEN                               //determine IO-Link reader version (1.0/1.1) to set offset
                statIOsize := LEN_DATA_V11;
            ELSE
                statIOsize := LEN_DATA_V10;
            END_IF;
        
            // Get PII

            tempWord := Siemens.Simatic.S71500.DistributedIO.ReadData(hwID,tempData);
            FOR tempIndex := 0 TO statIOsize - INT#1 DO
                statAnt[tempIndex]   :=  tempData[tempIndex + portAddr];
            END_FOR;
                        
            statAntStatus := statAnt[INDEX_ANT_STATUS];    //status byte
            statPresence := statAntStatus.%X5;    //Presence bit. Transponder on field
        
            // Check antenna status
            IF statAnt[INDEX_RFID_ERROR] <> BYTE#0 AND statBusy THEN
                tempStatus.%W0 := TO_WORD(statAnt[INDEX_RFID_ERROR]);    //error_BLK
                tempStatus.%W1 := STATUS_ERROR_IDENT_RFID;                    //identifier rfid errors
                statBusy := false;
                tempDone := false;
                tempError := TRUE;
                statState := STATE_IDLE;
            END_IF;
        
            // Check execute
            // Idle
                IF NOT execute THEN
                    tempDone := false;
                    tempError := false;
                    tempStatus := DWORD#0;
                END_IF;
            
            // Job executed
                IF execute AND execute <> statExecuteReq THEN //Positive Edge for antenna on
                    statBusy := TRUE;                              //Block active
                    tempDone := FALSE;                             //reset all output parameters
                    tempError := FALSE;
                    tempStatus := STATUS_NO_JOB;
                    IF antennaState THEN                          //if antenna then activate the ANTENNA_ON process
                        statState := STATE_ANTENNA_ON;
                    ELSIF NOT antennaState THEN                   //if not antenna then activate the ANTENNA_OFF process 
                        statState := STATE_ANTENNA_OFF;
                    END_IF;
                    
                END_IF;
            statExecuteReq := execute;
        
        // State machine
            CASE statState OF
                STATE_IDLE:
                    ;
                    
                STATE_ANTENNA_ON:  //Antenna_on
                    //Antenna on process
                    statAntStatus.%X4 := false;                        //Reset Byte 0, bit 4
                    statSent[INDEX_SEND_CMD] := CMD_ANTENNA_ON;

                    FOR tempIndex := INT#0 TO statIOsize - INT#1 DO
                        tempData[tempIndex + portAddr] := statSent[tempIndex];
                    END_FOR;
                    //TODO solve overwriting the outputs in case of several RFID header used with one IOLink master 
                    //when SETIO_PART equivalent function is available in AX
                    tempWord := Siemens.Simatic.S71500.DistributedIO.WriteData(hwID,tempData);

                    IF NOT statIoPartError AND statAnt[INDEX_RFID_ERROR] = BYTE#0 THEN
                        statState := STATE_READY;
                    ELSIF statIoPartError THEN
                        tempError := true;
                        statBusy := FALSE;
                        tempStatus.%W0 :=TO_WORD(statIoPartStatus);//error_BLK
                        tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;                    //identifier block errors
                        statState := STATE_IDLE;
                    END_IF;
                    
                STATE_ANTENNA_OFF:
                    //Antenna off process
                    statAntStatus.%X4 := true;                         //set Byte 0, bit 4
                    statSent[INDEX_SEND_CMD] := CMD_ANTENNA_OFF;

                    FOR tempIndex := INT#0 TO statIOsize - INT#1 DO
                        tempData[tempIndex + portAddr] := statSent[tempIndex];
                    END_FOR;
                    //TODO solve overwriting the outputs in case of several RFID header used with one IOLink master 
                    //when SETIO_PART equivalent function is available in AX
                    tempWord := Siemens.Simatic.S71500.DistributedIO.WriteData(hwID,tempData);

                    IF NOT statIoPartError AND statAnt[INDEX_RFID_ERROR] = BYTE#0 THEN
                        IF statAntStatus = CMD_ANTENNA_OFF THEN    //if status_byte=1610 then antenna off
                            statState := STATE_READY;
                        END_IF;
                    ELSIF statIoPartError THEN
                        tempError := true;
                        statBusy := FALSE;
                        tempStatus.%W0 := TO_WORD(statIoPartStatus);    //error_BLK
                        tempStatus.%W1 := STATUS_ERROR_IDENT_BLOCK;   //identifier block errors
                        statState := STATE_IDLE;
                    END_IF;
                    
                STATE_READY:
                    tempDone := true;
                    statBusy := FALSE;
                    statState := STATE_IDLE;
                ELSE
                    statState := STATE_IDLE;
            END_CASE;
        
            // Update output interface 
            done := tempDone;
            busy := statBusy;
            error := tempError;
            status := tempStatus;
            presence := statPresence;
        END_METHOD
    END_CLASS
END_NAMESPACE
