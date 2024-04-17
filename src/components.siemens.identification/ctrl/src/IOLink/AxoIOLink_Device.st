USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Timers;
USING Siemens.Simatic.S71500.DistributedIO;
USING System.Timer;

NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoIOLink_Device 
        VAR PRIVATE
            statExecuteOld          :	BOOL    :=  FALSE;          //  Old value of 'execute' input for edge detection
            statDone                :	BOOL    :=  FALSE;          //  Static value for output 'done'
            statBusy                :	BOOL    :=  FALSE;          //  Static value for output 'busy'
            statError               :	BOOL    :=  FALSE;          //  Static value for output 'error'
            statStatus              :	WORD    :=  WORD#16#7000;	//  Static value for output 'status'
            statPollingPeriod       :	TIME    :=	T#100MS;        //	Static value for input 'pollingPeriod'
            statHwID                :	WORD    :=  WORD#0;         //  Static value for input 'hwID'
            statHwIDprevious        :	WORD    :=  WORD#0;         //  Static value for input 'hwID' from the previous execute 
            statReadWrite           :	BOOL    :=  FALSE;          //  Static value for input 'readWrite'
            statCap                 :	UINT    :=  UINT#0;         //  Static value for input 'cap'
            statTimeout             :	TIME    :=	T#0MS;          //	Static value for input 'timeout'
            statLen                 :	UINT    :=  UINT#0;         //  Length of data to be written to device
            statSubfunctionStatus   :	DWORD   :=  DWORD#0;        //  Status of WRREC/RDREC or error code from IO-Link Master (%W1: IO-Link Master error, %W0: ISDU error)
            statFBErrorState        :	DINT    :=  DINT#0;         //	State in the state machine of the block where the error occurred
            statFBState             :	DINT    :=  DINT#0;         //	State in the state machine of the FB
            statEmptyDiagnostics    :	AxoIOLink_typeDiagnostics;  //  Empty diagnostics information (for initialization purposes only)
            instRdRec               :	ReadRecord;                 //  System function "read data record"
            instWrRec               :	WriteRecord;                //  System function "write data record"
            instPoll                :	Pulse;  		            //  poll rate read data record
            instMonitor             :	OnDelay;                    //  request monitoring time
            statRead                :	ARRAY[0..239] OF BYTE   := [BYTE#16#08,BYTE#16#0,BYTE#16#FE,BYTE#16#4A,236(BYTE#0)];             //  data area for reading data
            statWrite               :	ARRAY[0..239] OF BYTE   := [BYTE#16#08,BYTE#16#0,BYTE#16#FE,BYTE#16#4A,236(BYTE#0)];             //  data area for writing data
            statDiagnostics         :	AxoIOLink_typeDiagnostics;
            statReadLen             :	INT;                       

        END_VAR

        VAR CONSTANT 
            MODE_READ                   :	BOOL    :=	FALSE;              //  Mode to read data
            MODE_WRITE                  :	BOOL    :=	TRUE;               //  Mode to write data
            MAX_PORT                    :	USINT   :=  USINT#63;           //  Max. possible port
            MAX_INDEX                   :	UINT    :=  UINT#32767;         //  Max. possible index
            INDEX_PORT_FUNC             :	UINT    :=  UINT#65535;         //  Index to address port functions
            MAX_SUBINDEX                :	USINT   :=  USINT#255;          //  Max. possible subindex
            MAX_DATA                    :	USINT	:=  USINT#232;          //  Max. size of data to be transferred
            UPPER_LIMIT                 :	DINT    :=  DINT#231;           //  Upper limit of data to be transferred
            FB_STATE_NO_PROCESSING      :	DINT    :=  DINT#0;             //  FB state: No processing
            FB_STATE_WRITE              :	DINT    :=  DINT#1;             //  FB state: Write data record
            FB_STATE_POLL               :	DINT    :=  DINT#2;             //  FB state: Wait and poll for response
            FB_STATE_READ_CAP           :	DINT    :=  DINT#3;             //  FB state: Read cap
            IOL_HEADER                  :	UINT    :=  UINT#65098;         //  Header IO-Link
            LEN_HEADER                  :	USINT   :=  USINT#8;            //  Length of header
            CONTROL_WRITE               :	BYTE    :=  BYTE#16#02;         //  Write data record
            CONTROL_READ                :	BYTE    :=  BYTE#16#03;         //  Read data record
            STATUS_EXECUTION_FINISHED   :	WORD    :=  WORD#16#0000;       //  Execution finished without errors
            STATUS_NO_CALL              :	WORD    :=  WORD#16#7000;       //  No job being currently processed
            STATUS_FIRST_CALL           :	WORD    :=  WORD#16#7001;       //  First call after incoming new job (rising edge 'execute')
            STATUS_SUBSEQUENT_CALL      :	WORD    :=  WORD#16#7002;       //  Subsequent call during active processing without further details
            SUB_STATUS_NO_ERROR         :	WORD    :=  WORD#16#0000;       //  No error occured in subfunction call
            ERR_WRONG_PORT              :	WORD    :=  WORD#16#8201;       //  Error: wrong port
            ERR_WRONG_INDEX             :	WORD    :=  WORD#16#8202;       //  Error: wrong index
            ERR_WRONG_SUBINDEX          :	WORD    :=  WORD#16#8203;       //  Error: wrong subindex
            ERR_WRONG_LENGTH            :	WORD    :=  WORD#16#8205;       //  Error: wrong length for write data record
            ERR_IO_LINK                 :	WORD    :=  WORD#16#8401;       //  Error: IO-Link master returned error code, see "diagnostics"
            ERR_INCONSISTENT_DATA       :	WORD    :=  WORD#16#8402;       //  Error: Read data record doesn't match request
            ERR_REQUEST_TIMEOUT         :	WORD    :=  WORD#16#8403;       //  Error: Request timed out
            ERR_UNDEFINED_STATE         :	WORD    :=  WORD#16#8600;       //  Error: due to an undefined state in state machine
            ERR_WRREC                   :	WORD    :=  WORD#16#8601;       //  Error: WRREC encountered an error, see "diagnostics"
            ERR_RDREC                   :	WORD    :=  WORD#16#8602;       //  Error: RDREC encountered an error, see "diagnostics"
            STATUS_MASK                 :	DWORD   :=  DWORD#16#00FF_FF00; //  Mask to filter error codes
            STATUS_RESOURCE_BUSY        :	DWORD   :=  DWORD#16#0080_C200; //  Status from WRREC/RDREC: Resource is busy
            INDEX_CAP_IOLINK            :	WORD    :=  WORD#16#B000;       //  Index of the data record for IOLM_Info. Only IO-Link-Masters with CAP=16#B000 support this call.
            CAP_LEGACY                  :	WORD    :=  WORD#16#00E3;       //  Siemens (old) Standard CAP: 227
            CAP_STANDARD                :	WORD    :=  WORD#16#B400;       //  IO-Link Standard CAP: 16#B400
            STATUS_RDREC_VALID          :	BYTE    :=  BYTE#16#00;         //  Status Code of RDREC in cased of no error occurs
            BITMASK_ERR_RDREC_B3        :	BYTE    :=  BYTE#16#DE;         //  Status Code of RDREC in case of an error when reading a data record
            BITMASK_ERR_RDREC_B2        :	BYTE    :=  BYTE#16#80;         //  Status Code of RDREC in case of an error when reading a data record - Error according to IEC 61158-6
            BITMASK_ERR_RDREC_B1        :	BYTE    :=  BYTE#16#B0;         //  Status Code of RDREC in case of an error when reading a data record - invalid index (cap)
        END_VAR

        METHOD PUBLIC Run
            VAR_INPUT
                execute         :	BOOL    :=  FALSE;                  //	Request to execute function
                hwID            :	WORD    :=  WORD#0;                 //	Hardware identifier of IO-Link master module or first sub module
                cap             :	INT     :=  INT#0;                  //	Client Access Point (CAP) 0xB400 or 0x00E3 (227)
                readWrite       :	BOOL    :=  FALSE;                  //	FALSE: read-mode, TRUE: write-mode
                port            :	INT     :=  INT#0;                  //  Port on IO-Link master module
                index           :	INT     :=  INT#0;                  //  Address parameter index (IO-Link device); 0..32767: IOL-D; 65535: port functions
                subindex        :	INT     :=  INT#0;                  //  Address parameter subindex (IO-Link device); 0: full record; 1-255: single parameter
                writeLen        :	INT     :=  INT#0;                  //  Length of writing data (net data); 1..232
                timeout         :	TIME    :=	T#20S;                  //	Time after which the request is aborted
                pollingPeriod   :	TIME    :=	T#100MS;                //	Time period of polling
                record	        :   REF_TO Array[*] OF BYTE;            //  Data area for reading/writing data (max. 232 byte)
                diagnostics     :	REF_TO  AxoIOLink_typeDiagnostics;	//  Diagnostics information of FB
            END_VAR         

            VAR_OUTPUT          
                done        :	BOOL;                                   //  TRUE: FB processing successfully completed
                busy        :	BOOL;                                   //  TRUE: FB is active and new output values can be expected.
                error       :	BOOL;                                   //  FALSE: No error / TRUE: An error occurred during the execution of the FB.
                status      :	WORD;                                   //  16#0000-16#7FFF: Status of the FB / 16#8000-16#FFFF: Error identification (see following table)
                readLen     :	INT;                                    //  Length of read data record (number of bytes)
            END_VAR

            VAR_TEMP 
                tempExecute         :	BOOL;							//	Temporary value for input 'execute'
                tempHwID            :	WORD;							//	Temporary value for input 'hwID'
                tempPort            :	INT;							//	Temporary value for input 'port'
                tempIndex           :	INT;							//	Temporary value for input 'index'
                tempSubindex        :	INT;							//	Temporary value for input 'subindex'
                tempIndexCounter    :	DINT;							//	run tag for counting loops
                i                   :   INT;
            END_VAR

           
            IF record = NULL THEN
                // TODO some message
                RETURN;
            END_IF;
            
            IF diagnostics = NULL THEN
                // TODO some message
                RETURN;
            END_IF;

            //===============================================================================
            // Siemens / (c)Copyright 2023
            //-------------------------------------------------------------------------------
            // Title:            LIOLink_Device
            // Function:         Acyclically reads or writes data records from and to IO-Link devices
            // Library:          LIOLink
            // Author:           Siemens Industry Online Support
            // Tested with:      CPU 1513-1 PN FW 2.8
            // Engineering:      TIA Portal V16
            // Restrictions:     S7-1200/1500
            // Requirements:     --
            //-------------------------------------------------------------------------------
            // Change log table:
            // Version  | Date       | Expert in charge       | Changes applied
            //----------|------------|------------------------|------------------------------
            // 02.00.00 | 30.09.2013 | Online Support         | First release for TIA Portal V12 SP1 as IO_LINK_CALL
            // 02.01.00 | 14.03.2014 | Online Support         | Upgrade to TIA Portal V13
            //                                                | Upgrade of system function 'WRREC' from V1.0 to V1.1
            // 03.00.00 | 28.02.2015 | SUP Applications       | Upgrade to TIA Portal V13 SP1
            //                                                | Renamed FB to IO_LINK_DEVICE 
            // 03.01.00 | 15.09.2015 | SUP Applications       | Change of #IOL_INDEX AND #Port lower boundry to 0 and improved behaviour when called in cyclic OBs with > 100 ms
            // 04.00.00 | 01.09.2020 | Online Support         | Implemented Programming styleguide for S7-1200/1500 and PLCopen
            //                                                | Renamed FB to LIOLink_Device 
            // 05.00.00 | 28.02.2023 | SUP SPH                | Added Polling Time as predefined input
            //                                                | #record is changed to a variable array (Array[*])
            //                                                | Changed CAP as predefined variable, added functionality to automatically find CAP of IO-Link-Masters from SIEMENS                                               
            //===============================================================================
            // TRIGGERING
            tempExecute := execute; // Work with temporary value / create process image
            
            IF (tempExecute = TRUE) AND (statExecuteOld = FALSE) // Check if FB is triggered
                AND (statStatus = STATUS_NO_CALL)
            THEN
                    // First call; initialize FB
                    statDone := FALSE;
                    statBusy := TRUE;
                    statError := FALSE;
                    statStatus := STATUS_FIRST_CALL;
                    statSubfunctionStatus := SUB_STATUS_NO_ERROR;
                    statFBErrorState := 0;
                    statDiagnostics := statEmptyDiagnostics;
                    statReadLen := 0;
                    
                    // Initialize data area
                    statRead[0] := BYTE#16#0;
                    statRead[6] := BYTE#16#0;
                    statRead[5] := BYTE#16#0;
                    statRead[7] := BYTE#16#0;
                    tempIndexCounter := 0; // initialize loop counter      
                    FOR tempIndexCounter := 0 TO UPPER_LIMIT + 8 DO
                        statWrite[tempIndexCounter] := BYTE#16#0;
                        statRead[tempIndexCounter] := BYTE#16#0;
                    END_FOR;
                
                    // Copy input variables to temporary variables
                    tempHwID := hwID;
                    statReadWrite := readWrite;
                    statTimeout := timeout;
                    statPollingPeriod := pollingPeriod;
                    tempPort := port;
                    tempIndex := index;
                    tempSubindex := subindex;
                
                    // setup call header
                    statWrite[0] := TO_BYTE(tempPort);
                    // setup IOL header 
                    statWrite[6] := TO_BYTE(tempIndex);
                    statWrite[5] := TO_BYTE(SHR(TO_WORD(tempIndex), UINT#8));
                    statWrite[7] := TO_BYTE(tempSubindex);
                    
                    // BODY (data max. 232 Byte, Array 0..231 of Byte) 
                    IF statReadWrite = MODE_WRITE THEN // Write data record requested, copy data from "record"
                        statWrite[4] := CONTROL_WRITE;
                        statLen := TO_UINT(writeLen) + LEN_HEADER; // data length header + data = IO-Link write data record
                        // copy "record" to working area
                        FOR tempIndexCounter := 8 TO writeLen - 7 DO
                            statWrite[tempIndexCounter] := record^[tempIndexCounter];
                        END_FOR;
                    ELSE // Read data record requested
                        // Empty record array
                        FOR i := 0 TO MAX_DATA DO
                            record^[0] := BYTE#0;
                        END_FOR;
                        statWrite[4] := CONTROL_READ;
                        statLen := LEN_HEADER; // data length only header = IO-Link read data record
                    END_IF;
                
                    // Check parameters
                    IF (tempPort < 0) OR (tempPort > MAX_PORT) THEN
                        statStatus := ERR_WRONG_PORT;
                    ELSIF (tempIndex < 0) OR (TO_UINT(tempIndex) > MAX_INDEX AND TO_UINT(tempIndex) <> INDEX_PORT_FUNC) THEN
                        statStatus := ERR_WRONG_INDEX;
                    ELSIF (tempSubindex < 0) OR (tempSubindex > MAX_SUBINDEX) THEN
                        statStatus := ERR_WRONG_SUBINDEX;
                    ELSIF statReadWrite = MODE_WRITE AND (writeLen < 1 OR writeLen > MAX_DATA) THEN
                        statStatus := ERR_WRONG_LENGTH;
                    END_IF;
                    //save the hwID from the previous execute
                    statHwIDprevious := statHwID;
                    
                    IF statStatus = STATUS_FIRST_CALL THEN // Parameters OK
                        IF cap <> 0 THEN
                            statCap := TO_UINT(cap);
                            statFBState := FB_STATE_WRITE;
                        ELSIF (statCap <> TO_UINT(CAP_STANDARD) AND statCap <> TO_UINT(CAP_LEGACY)) OR (statHwIDprevious <> tempHwID) THEN // check if new device is connected => hwID changed
                            statFBState := FB_STATE_READ_CAP;
                        ELSE
                            statFBState := FB_STATE_WRITE;
                        END_IF;
                    END_IF;
                    // save current hwID
                    statHwID := tempHwID;
               
            ELSIF (statStatus = STATUS_FIRST_CALL) THEN
                statStatus := STATUS_SUBSEQUENT_CALL;
            END_IF;
            
            // Edge detection 'execute' input
            statExecuteOld := tempExecute;
        
            // STATE_MACHINE
            CASE statFBState OF
                FB_STATE_NO_PROCESSING:
                        ; // No processing active
                    
                FB_STATE_READ_CAP:
                        // To find out CAP of IO-Link Master, data record with Index 16#B000 is read. If this reading was successful
                        // then CAP is 16#B400 (based on IO-Link Standard). If the reading was not successful and the status of RDREC
                        // is 16#DE80_B0xx, then CAP is 16#00E3 (227, based on Siemens Old Standard for IO-Link Masters).
                        
                        instRdRec(record := statRead);
                        
                        IF (instRdRec.BUSY = FALSE) THEN
                            IF (instRdRec.VALID = FALSE) AND (instRdRec.ERROR = FALSE) THEN
                                IF instRdRec.request = FALSE THEN
                                    // call read record with Index 16#B000
                                    instRdRec.request := true;
                                    instRdRec.ID := statHwID;
                                    instRdRec.INDEX := TO_UINT(INDEX_CAP_IOLINK);
                                    instRdRec.maxLength := UINT#0;
                                    statFBState := FB_STATE_READ_CAP;
                                END_IF;
                            ELSIF instRdRec.VALID = TRUE THEN
                                instRdRec.request := FALSE;
                                // if status of RDREC is valid then CAP is 16#B400 (CAP_STANDARD)
                                IF instRdRec.STATUS.%B3 = STATUS_RDREC_VALID THEN
                                    statCap := TO_UINT(CAP_STANDARD);
                                END_IF;
                                statFBState := FB_STATE_WRITE;
                            ELSE
                                // if RDREC is in error state and Status is 16#DE80_B0xx then CAP is 227 (CAP_Legacy)
                                IF (instRdRec.STATUS.%B3 = BITMASK_ERR_RDREC_B3) AND (instRdRec.STATUS.%B2 = BITMASK_ERR_RDREC_B2) AND (instRdRec.STATUS.%B1 = BITMASK_ERR_RDREC_B1) THEN
                                    statCap := TO_UINT(CAP_LEGACY);
                                    statFBState := FB_STATE_WRITE;
                                ELSE
                                    statStatus := ERR_RDREC;
                                    statSubfunctionStatus := instRdRec.STATUS;
                                    statCap := UINT#0; //clear CAP if an error occurs
                                END_IF;
                            END_IF;
                        ELSE
                            instRdRec.request := FALSE;
                            IF instRdRec.ERROR = TRUE THEN
                                statStatus := ERR_RDREC;
                                statSubfunctionStatus := instRdRec.STATUS;
                                statCap := UINT#0; //clear CAP if an error occurs
                            END_IF;
                        END_IF;
                        
                        instRdRec(RECORD := statRead);
                    
                FB_STATE_WRITE:
                        // To read data records, the IO-Link master modules needs to know which port is required. Therefore it is necessary
                        // to send at first a request via write data record (header, 8 byte). As response the IO-Link master module will 
                        // send the required data record.
                        
                        instWrRec(request := TRUE,
                                   id := statHwID,
                                   index := statCap,
                                   length := statLen,
                                   record := statWrite);
                        
                        IF instWrRec.ERROR THEN
                            IF (instWrRec.STATUS AND STATUS_MASK) = STATUS_RESOURCE_BUSY THEN
                                instWrRec(request := FALSE,record := statWrite); // Reset request
                            ELSE
                                statStatus := ERR_WRREC;
                                statSubfunctionStatus := instWrRec.STATUS;
                                statFBErrorState := statFBState;
                            END_IF;
                        ELSIF instWrRec.DONE = TRUE THEN
                            instWrRec(request := FALSE,record := statWrite); // Reset requeset
                            
                            statFBState := FB_STATE_POLL;
                        END_IF;
                    
                FB_STATE_POLL: // wait and poll for response
                        instPoll(signal := TRUE,
                                  duration := statPollingPeriod);
                        
                        // read data record on falling edge
                        instRdRec(request := NOT instPoll.output,
                                   id := statHwID,
                                   index := statCap,
                                   maxLength := UINT#0, // read all data available,
                                   record := statRead);
                        
                        IF instRdRec.ERROR = TRUE THEN
                            IF (instRdRec.STATUS AND STATUS_MASK) = STATUS_RESOURCE_BUSY THEN
                                // Reset requests and try again
                                instPoll(signal := FALSE,duration := statPollingPeriod);
                                
                                instRdRec(request := FALSE,record := statRead);
                            ELSE
                                statStatus := ERR_RDREC;
                                statSubfunctionStatus := instRdRec.STATUS;
                                statFBErrorState := statFBState;
                            END_IF;
                        ELSIF instRdRec.VALID THEN
                            IF // check the response wether it matches the request (compare PORT, INDEX and SUBINDEX)
                                (statWrite[0] <> statRead[0])    
                                OR (statWrite[5] <> statRead[5]) 
                                OR (statWrite[6] <> statRead[6]) 
                                OR (statWrite[7] <> statRead[7]) 
                            THEN // read data record doesn't match the request
                                statStatus := ERR_INCONSISTENT_DATA;  // output status no consistent data
                            ELSIF statRead[4] = BYTE#16#80 THEN // check the response for IO-Link errors
                                // State 0x80 = IOL_CALL_RES PDU shows IO-Link error detect
                                statStatus := ERR_IO_LINK;
                                statSubfunctionStatus.%B3 := statRead[8]; // IO-Link master error code
                                statSubfunctionStatus.%B2 := statRead[9]; // IO-Link master error code
                                statSubfunctionStatus.%B1 := statRead[10]; // ISDU error code
                                statSubfunctionStatus.%B0 := statRead[11]; // ISDU additional code
                                statFBErrorState := statFBState;
                            ELSE // read data is valid
                                IF statReadWrite = MODE_READ THEN
                                    statReadLen := TO_INT(instRdRec.length - LEN_HEADER);
                                    // only data will be output
                                    FOR tempIndexCounter := 0 TO TO_INT(instRdRec.length - TO_UINT(LEN_HEADER) - UINT#1) DO
                                        record^[tempIndexCounter] := statRead[tempIndexCounter + DINT#8];
                                    END_FOR;
                                END_IF;
                                
                                // Reset requests
                                instRdRec(request := FALSE,record := statRead);
                                
                                instPoll(signal := FALSE,duration := statPollingPeriod);
                                
                                statStatus := STATUS_EXECUTION_FINISHED;  // request finished
                            END_IF;
                        END_IF;
                    
                ELSE // Undefined state in state machine reached
                        statStatus := ERR_UNDEFINED_STATE;
            END_CASE;
        
            //  MONITORING
            instMonitor(signal := statBusy,duration := statTimeout);
            
            IF instMonitor.output THEN
                statStatus := ERR_REQUEST_TIMEOUT; // request time out
            END_IF;
        
            // OUTPUTS
            // Write outputs
            IF (statStatus = STATUS_EXECUTION_FINISHED) AND (statDone = FALSE) THEN // Execution finished without errors, available only for one cycle
                    statDone := TRUE;
                    statBusy := FALSE;
                    statError := FALSE;
                    // execution aborted --> set state no processing
                    statFBState := FB_STATE_NO_PROCESSING;
                
            ELSIF (statStatus.%X15 = TRUE) AND (statError = FALSE) THEN // Error occurred (statStatus is 16#8000 to 16#FFFF), Error status is true only for one cycle (the second last cycle)
                    statDone := FALSE;
                    statBusy := FALSE;
                    statError := TRUE;
                    statCap := UINT#0; //Reset statcap, if error occurs, get cap has to be performed again
                    // Write diagnostics
                    statDiagnostics.status := statStatus;
                    statDiagnostics.subfunctionStatus := statSubfunctionStatus;
                    statDiagnostics.stateNumber := statFBErrorState;
                    // Call instructions with FALSE to be ready for next job
                    instWrRec(request := FALSE,record := statWrite);
                    
                    instRdRec(request := FALSE,record := statRead);
                    
                    instPoll(signal := FALSE,duration := statPollingPeriod);
                    
                    // execution aborted --> set state no processing
                    statFBState := FB_STATE_NO_PROCESSING;
                
            ELSIF (tempExecute = FALSE) AND ((statDone = TRUE) OR (statError = TRUE)) THEN // Reset outputs, Last cycle
                    statDone := FALSE;
                    statBusy := FALSE;
                    statError := FALSE;
                    statStatus := STATUS_NO_CALL;
                    statReadLen := 0;
            END_IF;
            
                done := statDone;
                busy := statBusy;
                error := statError;
                status := statStatus;
                readLen := statReadLen;
                diagnostics^ := statDiagnostics;
                //ENO := NOT statError;
        END_METHOD
    END_CLASS
END_NAMESPACE
