USING AXOpen.Components.Abstractions.Drives;
USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS Axo_IdentProfile 
        VAR
            statLastErrorStatus     :   DWORD :=  DWORD#16#0;               // last error status
            statLastMoveError       :   INT;                                // error of last MOV_BLK
            statChainedStatus       :   DWORD := DWORD#16#0;                // first error status in chain
            statIntStatus           :   DWORD := DWORD#16#0;                // internal status of WRREC and RDREC
            statSaveError           :   BOOL;                               // save error of WRREC and RDREC
            statCI                  :   BYTE  :=  BYTE#16#0;                // command index
            statDataTodo            :   UDINT;                              // rest of data
            statDataOffset          :   UDINT;                              // offset for send data
            statRecvOffset          :   UDINT;                              // offset for recv data
            statBufLen              :   UINT;                               // length of buffer
            statAdb                 :   UINT := UINT#1;                     // tdb: total number of data blocks
            statDbn                 :   UINT := UINT#1;                     // dbn: current data block number
            statTxbuflen            :   UDINT := UDINT#0;                   // length of send-buffer
            statRxbuflen            :   UDINT := UDINT#0;                   // length of receive-buffer
            statPrevExecute         :   BOOL;                               // old flag for execute
            statPrevInit            :   BOOL;                               // old flag for init
            statPrevSReset          :   BOOL;                               // old flag for sreset
            statFurtherTelegram     :   BOOL;                               // helper for fragmented telegrams
            statPduRepeat           :   BOOL;                               // flag for repeat of pdu detection
            statEmptyCycle          :   BOOL;               
            statSize                :   UINT;                               // length of cmd-header
            statPduDetection        :   BOOL;                               // pdu-detection (supported telegram length)
            statCmdSelCounter       :   UINT := UINT#1;                     // internal cmd selector (for chained cmds)
            statChainedCounter      :   UINT := UINT#1;                     // counter for chained commands
            statFixChainedCounter   :   UINT := UINT#1;                     // fix mem counter of chained commands (memory for repeat)
            statSqModified          :   BOOL;                               // sequenznumber modified for repeat command
            // statAdsRdWrt            :   ADSRDWRT;                           // instance of RDREC
            statWRREC               :   WriteRecord;                        // instance of WriteRecord
            statRDREC               :   ReadRecord;                         // instance of WriteRecord
            // statTimeout             :   TON;                                // instance of timer
            statTimeout             :   System.Timer.OnDelay;               // instance of timer
            statCmd                 :   Axo_IID_CMD_STRUCT;                 // actual cmd
            statSaveAdsError        :   BOOL;
            statIntAdsErrId         :   UDINT;
            statLowerBoundTxref     :   DINT;
            statUpperBoundTxref     :   DINT;
            statLowerBoundRxref     :   DINT;
            statUpperBoundRxref     :   DINT;
            statErrorCounter        :   DINT;
        END_VAR

        VAR CONSTANT 
            STATE0                  :   UINT    :=  UINT#0;                 //Initialisation 1 
            STATE1                  :   UINT    :=  UINT#1;                 //Initialisation 2: wait for init_active of device
            STATE2                  :   UINT    :=  UINT#2;                 //Initialisation 3: wait until init_active is dropped and start ADS WRITE
            STATE3                  :   UINT    :=  UINT#3;                 
            STATE4                  :   UINT    :=  UINT#4;                 //build command telegram and start ADS WRITE
            STATE5                  :   UINT    :=  UINT#5;                 //finish ADS WRITE
            STATE6                  :   UINT    :=  UINT#6;                 //wait for acknowledgement (CommandCounter) and start ADS READ
            STATE7                  :   UINT    :=  UINT#7;                 //finish ADS READ and receive data
            STATE8                  :   UINT    :=  UINT#8;                 //Soft reset
            PN_CONFIGRECORD_HEADER_LEN: UINT    :=  UINT#20;
            ADS_TIMEOUT             :   TIME    :=  T#1S;
            ADS_READ                :   WORD    :=  WORD#16#0;  
            ADS_WRITE               :   WORD    :=  WORD#16#1;
            ERRID_DEVICE_BUSY       :   WORD    :=  WORD#16#0000_0708;
        END_VAR
          
        METHOD PUBLIC Run
            VAR_INPUT
                bExecute            :   BOOL;                               // rising edge: start command
                bRepeatCommand      :   BOOL;                               // repeat command
                bSoftReset          :   BOOL;                               // soft reset
                bInit               :   BOOL;                               // init-run
                nCmdsel             :   UINT    :=  UINT#1;                 // selector for executive command
            END_VAR         
            VAR_OUTPUT          
                bDone               :   BOOL;                               // command is done
                bBusy               :   BOOL;                               // command is in work
                bError              :   BOOL;                               // command ended with error
                bWarning            :   BOOL;                               // command ended with warning
                nStatus             :   DWORD   :=  DWORD#0;                // status of warning and error
                bRepeatActive       :   BOOL;                               // repeat command is active
                bErrIreq            :   BOOL;                               // error at communication module
                bTpc                :   BOOL;                               // number of tags has changed
                bTp                 :   BOOL;                               // tag presence
                bUin0               :   BOOL;                               // user-input 0 of the Ident-Unit
                bUin1               :   BOOL;                               // user-input 1 of the Ident-Unit
                bUin2               :   BOOL;                               // user-input 2 of the Ident-Unit
                bUin3               :   BOOL;                               // user-input 3 of the Ident-Unit
                nTrlen              :   DINT;                               // length of send/receive data
            END_VAR
            VAR_IN_OUT
                stHwConnect         : Axo_IID_HW_CONNECT;  
                aCmdref             : ARRAY[1..10] OF Axo_IID_CMD_STRUCT;   // command-buffer
                aTxref              : ARRAY[*] OF BYTE;                     // send-buffer
                aRxref              : ARRAY[*] OF BYTE;                     // receive-buffer
            END_VAR	

            VAR_TEMP 
                tempRaisedExecute   :   BOOL;                               // flag for rising edge of execute
                tempRaisedInit      :   BOOL;                               // flag for rising edge of init
                tempRaisedSreset    :   BOOL;                               // flag for rising edge of sreset
                tempIntError        :   BOOL;                               // helper: internal error
                tempAdress          :   UDINT;                              // helper: i/o address
                tempB               :   BYTE;                               // helper: error flag in acknowledge
                tempLi              :   UDINT;                              // helper_ length
                tempBufoffset       :   UINT;                               // helper: buffer offset
                tempW               :   WORD;                               // helper: interpret single bytes of telegram
                tempI               :   UINT;                               // helper: offset
                tempFinished        :   BOOL;                               // helper: command is finished
                tempTmp             :   UINT;                               // helper: loop variable
                tempMax             :   UINT;                               // helper: pdu size
                tempStatus          :   WORD;                               // helper: mask status
                tempL1              :   UDINT;                              // helper: array_length
                tempL2              :   UDINT;                              // helper: array_length
                tempRetval          :   UINT;                               // helper: return value of timestamp
                tempShift           :   BOOL;                               // helper: shift flag for datatypes
                tempZeroValue       :   BYTE;                               // helper: variable for value zero
                tempWord            :   WORD;
                tempDword           :   DWORD;
                tempAdb             :   UINT;
                tempDbn             :   UINT;
                tempCntDiag         :   UINT;
                tempChar            :   WSTRING;
                tempByte            :   BYTE;
                tempLoop            :   UINT;
                i                   :   INT;
              END_VAR
              
    
            //=============================================================================
            // SIEMENS AG
            // (c)Copyright 2021 All Rights Reserved
            //-----------------------------------------------------------------------------
            // Library: LIID
            // Engineering: TwinCat3
            // Functionality: Manage the connection and the data transfer between IID
            //                Reader and PLC
            // 
            //-----------------------------------------------------------------------------
            // Change log table:
            // Version  Date       Expert        Changes applied
            // 01.00.00 29.03.2021 Manuel Nagel First released version
            //=============================================================================

            // IF __ISVALIDREF(stHWConnect) THEN 

            IF TRUE THEN // TODO Solve Null ref

                IF statPrevExecute <> bExecute THEN
                    tempRaisedExecute := bExecute;
                END_IF;
                IF statPrevInit <> bInit THEN
                    tempRaisedInit := bInit;
                END_IF;
                IF statPrevSReset <> bSoftReset THEN
                    tempRaisedSreset := bSoftReset;
                END_IF;
                
                // Save Inputs 
                statPrevExecute := bExecute;
                statPrevInit := bInit;
                statPrevSReset := bSoftReset;
                
                // reset outputs, if no init or execute or sreset is set 
                IF (NOT bExecute AND NOT bInit AND NOT bSoftReset) AND NOT stHwConnect.STATIC.STATUS_IN_WORK THEN
                    bDone := FALSE;
                    bBusy := FALSE;
                    bError := FALSE;
                    nStatus := DWORD#0;
                END_IF;
                
                // start SRESET 
                IF tempRaisedSreset THEN
                    stHwConnect.STATIC.SRESET_cyc := true;
                    stHwConnect.STATIC.STATUS_IN_WORK := true;
                    // Set Outputs 
                    bDone := FALSE;
                    bBusy := TRUE;
                    bError := FALSE;
                    bWarning := FALSE;
                    nStatus := DWORD#0;
                END_IF;
                
                // Init or  Execute is set; Init can start everytime. Execute (command) only if nothing is working 
                IF (tempRaisedInit AND NOT stHwConnect.STATIC.STATUS_INITIALISATION) OR (tempRaisedExecute AND NOT stHwConnect.STATIC.STATUS_IN_WORK) THEN
                    // Set Outputs 
                    bDone := FALSE;
                    bBusy := TRUE;
                    bError := FALSE;
                    bWarning := FALSE;
                    nStatus := DWORD#0;
                    
                    //reset move_blk_error
                    statLastMoveError := 0;
                    
                    // reset flag for executed initialisation 
                    stHwConnect.STATIC.STATUS_LAST_CMD_INIT := FALSE;
                    
                    // check send and receive buffer and save buffer length		
                    statLowerBoundTxref := LOWER_BOUND(aTxref,1);		
                    statUpperBoundTxref := UPPER_BOUND(aTxref,1);
                    
                    statLowerBoundRxref := LOWER_BOUND(aRxref,1);		
                    statUpperBoundRxref := UPPER_BOUND(aRxref,1);				
                
                    statTxbuflen := TO_UDINT(statUpperBoundTxref - statLowerBoundTxref + 1);  
                    statRxbuflen := TO_UDINT(statUpperBoundRxref - statLowerBoundRxref + 1); 
                    
                    // check cmd_sel 
                    IF nCmdsel > UINT#10 OR nCmdsel < UINT#1 THEN
                        tempIntError := TRUE;
                        statIntStatus := DWORD#16#E7FE0200;
                    END_IF;
                        
                    IF NOT tempIntError THEN
                        // steps for init procedure 
                        IF tempRaisedInit THEN
                            // set status-variables 
                            stHwConnect.STATIC.STATUS_INITIALISATION := true;
                            stHwConnect.STATIC.STATUS_IN_WORK := true;
                            // set flag for executed initialisation 
                            stHwConnect.STATIC.STATUS_LAST_CMD_INIT := true;
                            // raise INIT in cyclic control word 
                            stHwConnect.STATIC.INIT_cyc := tempRaisedInit;
                            // INIT starts in step 0 
                            stHwConnect.STATIC.state := STATE0;
                            // reset index and instruction-set 
                            stHwConnect.STATIC.instruction_set := FALSE;
                            stHwConnect.STATIC.index_set := TRUE;
                            stHwConnect.STATIC.config_value := BYTE#16#4;
                            // reset chain infos
                            statChainedStatus := DWORD#16#0;
                            // drop SRESET 
                            stHwConnect.STATIC.SRESET_active := FALSE;
                            stHwConnect.STATIC.SRESET_cyc := FALSE;
                            // drop internal rpt 
                            stHwConnect.STATIC.RPTCMD_cyc := FALSE;				

                            //Reset WriteRecord request
                            statWRREC(request := FALSE, record := stHwConnect.STATIC.pnConfigRecord.record.buf);
                            //Reset ReadRecord request
                            statRDREC(request := FALSE, record := stHwConnect.STATIC.pnConfigRecord.record.buf);

                            // calculate INDEX for old modules and RF68xR 
                            IF stHwConnect.STATIC.index_set THEN
                                stHwConnect.STATIC.index := TO_UINT(16#B050) - stHwConnect.CM_CHANNEL;
                            ELSE
                                stHwConnect.STATIC.index := stHwConnect.CM_CHANNEL + UINT#100;
                            END_IF;
                        END_IF;

                        // steps for command procedure 
                        IF tempRaisedExecute AND NOT stHwConnect.STATIC.STATUS_IN_WORK THEN
                            // set status-variables 
                            stHwConnect.STATIC.STATUS_INITIALISATION := FALSE;
                            stHwConnect.STATIC.STATUS_IN_WORK := TRUE;
                            
                            //Reset WriteRecord request
                            statWRREC(request := FALSE, record := stHwConnect.STATIC.pnConfigRecord.record.buf);
                            //Reset ReadRecord request
                            statRDREC(request := FALSE, record := stHwConnect.STATIC.pnConfigRecord.record.buf);

                            // calculate INDEX for old modules and RF68xR 
                            IF stHwConnect.STATIC.index_set THEN
                                stHwConnect.STATIC.index := TO_UINT(16#B046) - stHwConnect.CM_CHANNEL;
                            ELSE
                                stHwConnect.STATIC.index := stHwConnect.CM_CHANNEL + UINT#110;
                            END_IF;
                        END_IF;
                        
                        // set variables for repeat command. only if rpt_active of reader is set 
                        IF (stHwConnect.STATIC.RPTCMD_cyc OR stHwConnect.STATIC.RPTCMD_active) AND NOT tempRaisedInit THEN
                            // setup things to receive next acknowledgement sequence 
                            statAdb := UINT#0;
                            // reset timer 
                            statTimeout(signal := FALSE,
                                        duration := stHwConnect.STATIC.timeout_repeat);
                            // start timer 
                            statTimeout(signal := TRUE,
                            duration := stHwConnect.STATIC.timeout_repeat);
                            // remind chained counter
                            statChainedCounter := statFixChainedCounter;
                            statSqModified := FALSE; 
                            // jump to state 6 => wait for acknowledge and read result 
                            stHwConnect.STATIC.state := STATE6;
                        ELSE
                            // reset chained memory if no repeat is started 
                            statFixChainedCounter := UINT#1;
                            statChainedCounter := UINT#1;
                            statSqModified := FALSE; 
                            statCmdSelCounter := nCmdsel;
                            statCmd :=  aCmdref[statCmdSelCounter];
                        
                        END_IF;
                        
                        // check index 
                        IF stHwConnect.STATIC.index < UINT#101 OR stHwConnect.STATIC.index > UINT#118 OR stHwConnect.STATIC.index = UINT#109 OR stHwConnect.STATIC.index = UINT#110 THEN
                            IF stHwConnect.STATIC.index > TO_UINT(16#B04F) OR stHwConnect.STATIC.index < TO_UINT(16#B03E) THEN
                                tempIntError := true;
                                statIntStatus := DWORD#16#E7FE0600;
                            END_IF;
                        END_IF;
                        
                    ELSE
                        //clear command code und attribute for to error buffer
                        statCmd.CMD := eAxo_IID_COMMANDS#eNoCommand;
                        statCmd.ATTRIBUTES := BYTE#16#0;
                    END_IF;
                END_IF;
            
                stHwConnect.STATIC.cyc_status :=  stHwConnect.STATUS_WORD;
                
                // decode input word 
                bUin0 := stHwConnect.STATIC.cyc_status.%X0;
                bUin1 := stHwConnect.STATIC.cyc_status.%X1;
                bUin2 := stHwConnect.STATIC.cyc_status.%X2;
                bUin3 := stHwConnect.STATIC.cyc_status.%X3;
                bErrIreq := stHwConnect.STATIC.cyc_status.%X4;
                //busy                            := hw_connect.Static.cyc_status.%X5;  // optional, not used 
                stHwConnect.STATIC.RPTCMD_active := stHwConnect.STATIC.cyc_status.%X6;
                stHwConnect.STATIC.SRESET_active := stHwConnect.STATIC.cyc_status.%X7;
                bTp := stHwConnect.STATIC.cyc_status.%X8;
                stHwConnect.STATIC.presence := stHwConnect.STATIC.cyc_status.%X8;
                bTpc := stHwConnect.STATIC.cyc_status.%X9;
                // bit 11 reserved                  := hw_connect.Static.cyc_status.%X10; 
                stHwConnect.STATIC.CC_L := stHwConnect.STATIC.cyc_status.%X11;
                stHwConnect.STATIC.CC_H := stHwConnect.STATIC.cyc_status.%X12;
                stHwConnect.STATIC.AC_L := stHwConnect.STATIC.cyc_status.%X13;
                stHwConnect.STATIC.AC_H := stHwConnect.STATIC.cyc_status.%X14;
                stHwConnect.STATIC.init_active := stHwConnect.STATIC.cyc_status.%X15;
                
                // set output for repeat 
                bRepeatActive := stHwConnect.STATIC.RPTCMD_active;
                
                // map RPTCMD if Ident_FB is not in_work 
                IF NOT stHwConnect.STATIC.STATUS_IN_WORK THEN
                    stHwConnect.STATIC.RPTCMD_cyc := bRepeatCommand;
                END_IF;
                
                // build cyclic control word 
                stHwConnect.STATIC.cyc_control := WORD#0;
                // 4/5 reserved 
                stHwConnect.STATIC.cyc_control.%X6 := stHwConnect.STATIC.RPTCMD_cyc;
                stHwConnect.STATIC.cyc_control.%X7 := stHwConnect.STATIC.SRESET_cyc;
                // 9-14 reserved 
                stHwConnect.STATIC.cyc_control.%X15 := stHwConnect.STATIC.INIT_cyc;
                
                stHwConnect.CONTROL_WORD := stHwConnect.STATIC.cyc_control;
                
                // SRESET is set 
                IF stHwConnect.STATIC.SRESET_cyc THEN
                    IF statWRREC.BUSY THEN
                        //Reset WriteRecord request
                        statWRREC(request := FALSE, record := stHwConnect.STATIC.pnConfigRecord.record.buf);
                        RETURN;
                    END_IF;
                    IF statRDREC.BUSY THEN
                        //Reset ReadRecord request
                        statRDREC(request := FALSE, record := stHwConnect.STATIC.pnConfigRecord.record.buf);
                        RETURN;
                    END_IF;

                    // if reader/CM has ack the SRESET with active-bit, reset cyclic SRESET and jump to step 8 
                    IF stHwConnect.STATIC.SRESET_active THEN
                        stHwConnect.STATIC.state := STATE8;
                        stHwConnect.STATIC.SRESET_cyc := false;
                    ELSE
                        // if reader/cm is not finished got out 
                        RETURN;
                    END_IF;
                END_IF;

                // go in statemachine only if Ident_FB is in_work and have no error 
                IF stHwConnect.STATIC.STATUS_IN_WORK AND NOT tempIntError THEN
                    // The loop will only use to jump out at every place if an error occurs 
                    FOR tempTmp := UINT#1 TO UINT#1 DO
                        CASE stHwConnect.STATIC.state OF
                            STATE0: //----------------------Initialisation 1----------------------------
                                // wait if WRREC and RDREC are done 
                                IF statWRREC.BUSY THEN
                                    statWRREC(request := FALSE, record := stHwConnect.STATIC.pnConfigRecord.record.buf);
                                    EXIT;
                                END_IF;
                                IF statRDREC.BUSY THEN
                                    statRDREC(request := FALSE, record := stHwConnect.STATIC.pnConfigRecord.record.buf);
                                    EXIT;
                                END_IF;
                                
                                // reset internal variable 
                                statFurtherTelegram := FALSE;
                                
                                // check CMD validity and command codex 
                                IF (nCmdsel <> UINT#1) OR (statCmd.CMD <> eAxo_IID_COMMANDS#eWriteConfig) THEN
                                    // CMDSEL must be 1 as defined by the IEC standard 
                                    // only WRITE_CONFIG is here allowed 
                                    tempIntError := TRUE;
                                    statIntStatus := DWORD#16#E7FE0100;
                                    EXIT;
                                END_IF;    
                                
                                // reset sequence_number 
                                stHwConnect.STATIC.sequence_number := UINT#0;
                                
                                // reset timer 
                                statTimeout(signal := FALSE,
                                            duration := stHwConnect.STATIC.timeout_reset);
                                // start timer 
                                statTimeout(signal := TRUE,
                                duration := stHwConnect.STATIC.timeout_reset);
                                
                                // set buflen of telegram 
                                stHwConnect.STATIC.buf_max := UINT#240;
                                stHwConnect.STATIC.buf_maxdata := stHwConnect.STATIC.buf_max - stHwConnect.STATIC.buf_header;
                                // first check PDU size 
                                statPduDetection := TRUE;
                                
                                // go to next step 
                                stHwConnect.STATIC.state := STATE1;
                                
                            STATE1: //------------Initialisation 2: wait for init_active of device--------------- 
                                IF stHwConnect.STATIC.init_active = TRUE THEN
                                    // initialize CC variables 
                                    stHwConnect.STATIC.old_CC_H := FALSE;
                                    stHwConnect.STATIC.old_CC_L := FALSE;
                                    
                                    // remember AC_H/AC_L 
                                    stHwConnect.STATIC.old_AC_H := stHwConnect.STATIC.AC_H;
                                    stHwConnect.STATIC.old_AC_L := stHwConnect.STATIC.AC_L;
                                    
                                    // drop INIT 
                                    stHwConnect.STATIC.INIT_cyc := FALSE;
                                    
                                    // go to next step 
                                    stHwConnect.STATIC.state := STATE2;
                                END_IF;
                            STATE2: // --------------Initialisation 3: wait until init_active is dropped ----------
                                IF stHwConnect.STATIC.init_active = FALSE THEN
                                    // and start command processing 
                                    IF (stHwConnect.STATIC.old_CC_H <> stHwConnect.STATIC.CC_H OR stHwConnect.STATIC.old_CC_L <> stHwConnect.STATIC.CC_L) OR statPduRepeat THEN
                                        
                                        // remember command counter 
                                        stHwConnect.STATIC.old_CC_H := stHwConnect.STATIC.CC_H;
                                        stHwConnect.STATIC.old_CC_L := stHwConnect.STATIC.CC_L;
                                        
                                        // Built Telegram 
                                        // 0 - DBL/reserved 
                                        stHwConnect.Static.pnConfigRecord.record.buf[0] := BYTE#0;
                                                                
                                        // 2/3 - SN
                                        stHwConnect.Static.sequence_number := stHwConnect.Static.sequence_number + UINT#1;
                                        tempW   :=  TO_WORD(stHwConnect.Static.sequence_number);
                                        stHwConnect.Static.pnConfigRecord.record.buf[2] := tempW.%B1;
                                        stHwConnect.Static.pnConfigRecord.record.buf[3] := tempW.%B0;
                                        
                                        // 4/5 - CC/CI 
                                        stHwConnect.Static.pnConfigRecord.record.buf[4] := TO_BYTE(statCmd.CMD);
                                        stHwConnect.Static.pnConfigRecord.record.buf[5] := BYTE#65; // A -> PIB to device 
                                        
                                        // 6/7 - ADB 
                                        stHwConnect.Static.pnConfigRecord.record.buf[6] := BYTE#0;
                                        stHwConnect.Static.pnConfigRecord.record.buf[7] := TO_BYTE(1);
                                        
                                        // 8/9 - DBN 
                                        stHwConnect.Static.pnConfigRecord.record.buf[8] := BYTE#0;
                                        stHwConnect.Static.pnConfigRecord.record.buf[9] := TO_BYTE(1);
                                        
                                        // 10 - DBL 
                                        // in PIB version > 1.20 the DBL value must be in Byte 1 and 10 at Config = 4 
                                        stHwConnect.Static.pnConfigRecord.record.buf[10] := BYTE#35;
                                        IF stHwConnect.STATIC.config_value = BYTE#4 THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[1] := BYTE#35;
                                        ELSE
                                            stHwConnect.Static.pnConfigRecord.record.buf[1] := BYTE#0;
                                        END_IF;
                                        
                                        // 11 - Config 
                                        stHwConnect.Static.pnConfigRecord.record.buf[11] := stHwConnect.STATIC.config_value;
                                        
                                        // zero out telegram buffer 
                                        FOR i := 12 TO 1034 DO
                                            stHwConnect.STATIC.pnConfigRecord.record.buf[i] := BYTE#16#00;
                                        END_FOR;

                                        // set offsets for data-buffer 
                                        statBufLen := UINT#46;
                                        statDataTodo := UDINT#0;
                                        statDataOffset := UDINT#0;
                                        statRecvOffset := UDINT#0;
                                        
                                        nTrlen := 0;
                                    
                                        // write packet to the client 									   
                                        stHwConnect.Static.pnConfigRecord.record.nLen := TO_WORD(statBufLen);	
                                        statWRREC.request := TRUE;
                                        // go to next step 
                                        stHwConnect.STATIC.state := STATE5;
                                    END_IF;
                                END_IF;
                                
                            STATE4: //--------------------------------------build command telegram----------------------------------
                                
                                // check command-counter if is a long term telegram 
                                IF statFurtherTelegram OR statChainedCounter > UINT#1 THEN
                                    IF NOT (stHwConnect.STATIC.old_CC_H <> stHwConnect.STATIC.CC_H OR stHwConnect.STATIC.old_CC_L <> stHwConnect.STATIC.CC_L) THEN
                                        EXIT;
                                    END_IF;
                                END_IF;
                                
                                // remember command counter 
                                stHwConnect.STATIC.old_CC_H := stHwConnect.STATIC.CC_H;
                                stHwConnect.STATIC.old_CC_L := stHwConnect.STATIC.CC_L;
                                
                                // steps for first telegram 
                                IF NOT statFurtherTelegram THEN
                                    // initialize TX variables 
                                    statDataTodo := UDINT#0;
                                    statDataOffset := UDINT#0;
                                    // initialize RX variables 
                                    statRecvOffset := UDINT#0;
                                    // simple_read-bit not used because of chained commands 
                                    //simple_read := TRUE;
                                    
                                    // set parameters for all write-commands 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eFormat OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite  OR statCmd.CMD = eAxo_IID_COMMANDS#ePut OR statCmd.CMD = eAxo_IID_COMMANDS#eWriteConfig OR statCmd.CMD = eAxo_IID_COMMANDS#eWriteID THEN
                                        IF TO_UDINT(statCmd.LEN_DATA) > statTxbuflen OR TO_UDINT(statCmd.LEN_DATA) < UDINT#0 THEN
                                            tempIntError := TRUE;
                                            statIntStatus := DWORD#16#E7FE0400;
                                            EXIT;
                                        END_IF;
                                        statDataTodo := TO_UDINT(statCmd.LEN_DATA);
                                        statDataOffset := statCmd.OFFSETBUFFER;
                                    END_IF;
                                    
                                    // check length for read-commands which knows the length before 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eRead THEN
                                        //simple_read-bit NOT used because OF chained commands
                                        //simple_read := FALSE;
                                        IF TO_UDINT(statCmd.LEN_DATA) > statRxbuflen OR TO_UDINT(statCmd.LEN_DATA) < UDINT#0 THEN
                                            tempIntError := true;
                                            statIntStatus := DWORD#16#E7FE0400;
                                            EXIT;
                                        END_IF;
                                    END_IF;
                                    
                                    // check send buffer 
                                    IF statDataTodo <> UDINT#0 THEN
                                        tempLi := statTxbuflen - statDataOffset;
                                        IF statDataTodo > tempLi THEN
                                            tempIntError := true;
                                            statIntStatus := DWORD#16#E7FE0300;
                                            EXIT;
                                        END_IF;
                                    END_IF;
                                END_IF;
                                
                                // set length of cmd_buffer for ext_uhf an normal command 
                                IF stHwConnect.STATIC.instruction_set AND statCmd.CMD <> eAxo_IID_COMMANDS#eInventory AND statCmd.CMD <> eAxo_IID_COMMANDS#eReaderStatus
                                    AND statCmd.CMD <> eAxo_IID_COMMANDS#eWriteConfig AND statCmd.CMD <> eAxo_IID_COMMANDS#eReadConfig THEN
                                    // EXT_UHF 
                                    statCI := BYTE#16#55;
                                    statSize := UINT#78;
                                ELSE
                                    // normal 
                                    statCI := BYTE#16#41;
                                    statSize := UINT#35;
                                END_IF;
                                
                                // build PIB-Header 
                                // 0 - reserved 
                                stHwConnect.Static.pnConfigRecord.record.buf[0] := BYTE#0;
                                
                                // 2/3 - SN 
                                IF NOT statFurtherTelegram THEN
                                    stHwConnect.STATIC.sequence_number := stHwConnect.STATIC.sequence_number + UINT#1;
                                END_IF;
                                
                                tempW   :=  TO_WORD(stHwConnect.Static.sequence_number);
                                stHwConnect.Static.pnConfigRecord.record.buf[2] := tempW.%B1;
                                stHwConnect.Static.pnConfigRecord.record.buf[3] := tempW.%B0;

                                // 4/5 - CC/CI 
                                // set CI for chained commands 
                                IF statCmd.CHAINED AND statCmdSelCounter < UINT#10 THEN 
                                    statCI := TO_BYTE(TO_UINT(statCI) + UINT#16#20);
                                END_IF;
                                stHwConnect.Static.pnConfigRecord.record.buf[4] := TO_BYTE(statCmd.CMD);
                                stHwConnect.Static.pnConfigRecord.record.buf[5] := statCI;
                                
                                // 6/7 - ADB 
                                IF NOT statFurtherTelegram THEN
                                    statAdb := UINT#1;
                                    IF statDataTodo > (stHwConnect.STATIC.buf_maxdata - statSize) THEN
                                        tempLi := statDataTodo - (stHwConnect.STATIC.buf_maxdata - statSize);
                                        statAdb := statAdb + TO_UINT(tempLi / stHwConnect.STATIC.buf_maxdata);
                                        IF (tempLi MOD stHwConnect.STATIC.buf_maxdata) <> UINT#0 THEN
                                            statAdb := statAdb + UINT#1;
                                        END_IF;
                                    END_IF;
                                ELSE
                                    statSize := UINT#0;
                                END_IF;
                                tempW := TO_WORD(statAdb);
                                stHwConnect.Static.pnConfigRecord.record.buf[6] := tempW.%B1;
                                stHwConnect.Static.pnConfigRecord.record.buf[7] := tempW.%B0;
                                // 8/9 - DBN 
                                IF NOT statFurtherTelegram THEN
                                    statDbn := UINT#0;
                                END_IF;
                                statDbn := statDbn + UINT#1;
                                tempW := TO_WORD(statDbn);
                                stHwConnect.Static.pnConfigRecord.record.buf[8] := tempW.%B1;
                                stHwConnect.Static.pnConfigRecord.record.buf[9] := tempW.%B0;

                                // 10 - DBL 
                                IF statDataTodo > (stHwConnect.STATIC.buf_maxdata - statSize) THEN
                                    tempI := stHwConnect.STATIC.buf_maxdata - statSize;
                                ELSE
                                    tempI := TO_UINT(statDataTodo);
                                END_IF;
                                statBufLen := tempI + statSize;
                                // PIB-Spec > 1.20 dbl must be in byte 1 and 0 if pdu > 240 
                                IF stHwConnect.STATIC.buf_max <= UINT#240 THEN
                                    stHwConnect.Static.pnConfigRecord.record.buf[10] := TO_BYTE(statBufLen);
                                    IF stHwConnect.STATIC.config_value = BYTE#4 THEN
                                        stHwConnect.Static.pnConfigRecord.record.buf[1] := TO_BYTE(statBufLen);
                                    ELSE
                                        stHwConnect.Static.pnConfigRecord.record.buf[1] := BYTE#0;
                                    END_IF;
                                ELSIF stHwConnect.STATIC.buf_max > UINT#240 THEN
                                    tempWord := TO_WORD(statBufLen);
                                    stHwConnect.Static.pnConfigRecord.record.buf[0] := tempWord.%B1;
                                    stHwConnect.Static.pnConfigRecord.record.buf[1] := tempWord.%B0;
                                    stHwConnect.Static.pnConfigRecord.record.buf[10] := BYTE#0;
                                END_IF;
                                statBufLen := statBufLen + stHwConnect.STATIC.buf_header;
                                
                                // zero out telegram buffer 
                                FOR i := 11 TO TO_INT(UINT#11 + statSize) DO
                                    stHwConnect.Static.pnConfigRecord.record.buf[i] := BYTE#16#0;
                                END_FOR;

                                // build CMD-Header in first telegram 
                                IF NOT statFurtherTelegram THEN
                                    // save chained counter 
                                    statFixChainedCounter := statChainedCounter;
                                    
                                    // 11 Config 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eWriteConfig THEN
                                        stHwConnect.Static.pnConfigRecord.record.buf[11] := statCmd.CONFIG;
                                    END_IF;
                                    
                                    // parameters for ext_uhf 
                                    IF stHwConnect.STATIC.instruction_set AND statCmd.CMD <> eAxo_IID_COMMANDS#eInventory AND statCmd.CMD <> eAxo_IID_COMMANDS#eReadConfig AND statCmd.CMD <> eAxo_IID_COMMANDS#eWriteConfig THEN
                                        // 11 Mode 
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eEditBlacklist THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[11] := statCmd.EXT_UHF.EDIT_BLACKLIST_MODE;
                                        END_IF;
                                        
                                        // 12 Source 
                                        IF statCmd.CMD <> eAxo_IID_COMMANDS#eEditBlacklist AND statCmd.CMD <> eAxo_IID_COMMANDS#eGetBlacklist THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[12] := TO_BYTE(stHwConnect.CM_CHANNEL);
                                        END_IF;
                                        
                                        // 13 Bank 
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[13] := statCmd.EXT_UHF.MEM_BANK;
                                        END_IF;
                                        
                                        // 14-15 address 
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite  THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[14] := statCmd.ADDR_TAG.%B1;
                                            stHwConnect.Static.pnConfigRecord.record.buf[15] := statCmd.ADDR_TAG.%B0;
                                        END_IF;
                                        
                                        // 16#-17 Length 
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eWriteID OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite  THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[16] := statCmd.LEN_DATA.%B1;
                                            stHwConnect.Static.pnConfigRecord.record.buf[17] := statCmd.LEN_DATA.%B0;
                                        END_IF;
                                        
                                        // 18-19 pswd 
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eWriteID OR statCmd.CMD = eAxo_IID_COMMANDS#eKillTag OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite  OR statCmd.CMD = eAxo_IID_COMMANDS#eLockTagBank THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[18] := statCmd.EXT_UHF.PSWD.%B3;
                                            stHwConnect.Static.pnConfigRecord.record.buf[19] := statCmd.EXT_UHF.PSWD.%B2;
                                            stHwConnect.Static.pnConfigRecord.record.buf[20] := statCmd.EXT_UHF.PSWD.%B1;
                                            stHwConnect.Static.pnConfigRecord.record.buf[21] := statCmd.EXT_UHF.PSWD.%B0;
                                        END_IF;
                                        
                                        // action & mask 
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eLockTagBank THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[22] := statCmd.EXT_UHF.LOCK_TAG_BANK_ACTION.%B1;
                                            stHwConnect.Static.pnConfigRecord.record.buf[23] := statCmd.EXT_UHF.LOCK_TAG_BANK_ACTION.%B0;
                                            stHwConnect.Static.pnConfigRecord.record.buf[24] := statCmd.EXT_UHF.LOCK_TAG_BANK_MASK.%B1;
                                            stHwConnect.Static.pnConfigRecord.record.buf[25] := statCmd.EXT_UHF.LOCK_TAG_BANK_MASK.%B0;
                                        END_IF;
                                        
                                        // 20 idlength 
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eWriteID OR statCmd.CMD = eAxo_IID_COMMANDS#eKillTag OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite  OR statCmd.CMD = eAxo_IID_COMMANDS#eLockTagBank OR statCmd.CMD = eAxo_IID_COMMANDS#eEditBlacklist THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[26] := statCmd.EXT_UHF.LEN_ID;
                                        END_IF;
                                        
                                        // 21 - 83 EPC-ID 
                                        IF statCmd.CMD <> eAxo_IID_COMMANDS#eGetBlacklist AND statCmd.CMD <> eAxo_IID_COMMANDS#eReaderStatus THEN //T0300_04
                                            // MOVE_BLK(IN := statCmd.EPCID_UID[1],
                                            //         COUNT := BYTE_TO_UDINT(statCmd.EXT_UHF.LEN_ID),
                                            //         OUT => hw_connect.Static.pnConfigRecord.record.buf[27]);
                                            
                                            // MEMCPY(destAddr:=ADR(stHwConnect.Static.pnConfigRecord.record.buf[27]) , srcAddr:=ADR(statCmd.EPCID_UID[1]) , n:=statCmd.EXT_UHF.LEN_ID );
                                            FOR i := 1 TO TO_INT(statCmd.EXT_UHF.LEN_ID) DO
                                                stHwConnect.Static.pnConfigRecord.record.buf[26+i] := statCmd.EPCID_UID[i];
                                            END_FOR;
                                        END_IF;
                                    ELSE
                                        // 12-19 UID 
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eFormat OR statCmd.CMD = eAxo_IID_COMMANDS#eTagStatus OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite  THEN
                                            // MOVE_BLK(IN := statCmd.EPCID_UID[1],
                                            //         COUNT := 8,
                                            //         OUT => hw_connect.Static.pnConfigRecord.record.buf[12]);
                                            
                                            // MEMCPY(destAddr:=ADR(stHwConnect.Static.pnConfigRecord.record.buf[12]) , srcAddr:=ADR(statCmd.EPCID_UID[1]) , n:=8 );		 
                                            FOR i := 1 TO 8 DO
                                                stHwConnect.Static.pnConfigRecord.record.buf[11+i] := statCmd.EPCID_UID[i];
                                            END_FOR;
                                        END_IF;
                                        
                                        // 32-33 Length 
                                        IF (statCmd.CMD = eAxo_IID_COMMANDS#ePut OR statCmd.CMD = eAxo_IID_COMMANDS#eFormat OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite  OR statCmd.CMD = eAxo_IID_COMMANDS#eWriteConfig) THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[32] := statCmd.LEN_DATA.%B1;
                                            stHwConnect.Static.pnConfigRecord.record.buf[33] := statCmd.LEN_DATA.%B0;
                                        END_IF;
                                        
                                        // 34-37 StartAddress 
                                        IF (statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite ) THEN
                                            stHwConnect.Static.pnConfigRecord.record.buf[34] := statCmd.ADDR_TAG.%B3;
                                            stHwConnect.Static.pnConfigRecord.record.buf[35] := statCmd.ADDR_TAG.%B2;
                                            stHwConnect.Static.pnConfigRecord.record.buf[36] := statCmd.ADDR_TAG.%B1;
                                            stHwConnect.Static.pnConfigRecord.record.buf[37] := statCmd.ADDR_TAG.%B0;
                                        END_IF;
                                    END_IF;
                                    
                                    // 38 Attributes 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eInventory OR statCmd.CMD = eAxo_IID_COMMANDS#eTagStatus OR statCmd.CMD = eAxo_IID_COMMANDS#eReaderStatus THEN
                                        stHwConnect.Static.pnConfigRecord.record.buf[38] := statCmd.ATTRIBUTES;
                                    END_IF;
                                    
                                    // duration and unit 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eInventory AND stHwConnect.STATIC.instruction_set THEN
                                        stHwConnect.Static.pnConfigRecord.record.buf[12] := TO_BYTE(stHwConnect.CM_CHANNEL);

                                        stHwConnect.Static.pnConfigRecord.record.buf[40] := statCmd.EXT_UHF.INVENTORY_DURATION.%B1;
                                        stHwConnect.Static.pnConfigRecord.record.buf[41] := statCmd.EXT_UHF.INVENTORY_DURATION.%B0;
                                        stHwConnect.Static.pnConfigRecord.record.buf[42] := statCmd.EXT_UHF.INVENTORY_DUR_UNIT.%B1;
                                        stHwConnect.Static.pnConfigRecord.record.buf[43] := statCmd.EXT_UHF.INVENTORY_DUR_UNIT.%B0;                   
                                    END_IF;
                                    
                                    nTrlen := 0;
                                END_IF;
                                
                                // copy Data in buffer 
                                IF statFurtherTelegram THEN
                                    tempBufoffset := stHwConnect.STATIC.buf_header;
                                ELSE
                                    tempBufoffset := stHwConnect.STATIC.buf_header + statSize;
                                END_IF;
                                IF tempI <> UINT#0 THEN
                                    // IF NOT hw_connect.STATIC.STATUS_INITIALISATION THEN
                                        
                                    //     IF TypeOfElements(txref) = Char THEN
                                            
                                    //         FOR tempLoop := 0 TO tempI - 1 DO
                                    //             statLastMoveError := MOVE_BLK_VARIANT(SRC := txref,
                                    //                                                 COUNT := 1,
                                    //                                                 SRC_INDEX := statDataOffset + tempLoop,
                                    //                                                 DEST_INDEX := 0,
                                    //                                                 DEST => tempChar);
                                    //             hw_connect.Static.pnConfigRecord.record.buf[tempBufoffset + tempLoop] := CHAR_TO_BYTE(tempChar);
                                    //         END_FOR;
                                            
                                    //     ELSE
                                            
                                    //         statLastMoveError := MOVE_BLK_VARIANT(SRC := txref,
                                    //                                             COUNT := INT_TO_UDINT(tempI),
                                    //                                             SRC_INDEX := statDataOffset,
                                    //                                             DEST_INDEX := tempBufoffset,
                                    //                                             DEST => hw_connect.STATIC.buf);
                                    //     END_IF;
                                    // ELSE
                                    //     statLastMoveError := MOVE_BLK_VARIANT(SRC := hw_connect.CONFIGURATION.param_buffer,
                                    //                                         COUNT := INT_TO_UDINT(tempI),
                                    //                                         SRC_INDEX := 0,
                                    //                                         DEST_INDEX := tempBufoffset,
                                    //                                         DEST => hw_connect.STATIC.buf);
                                    // END_IF;
                                    // // error at mov_blk 
                                    // IF statLastMoveError <> 0 THEN
                                    //     tempIntError := true;
                                    //     statIntStatus := 16#E7FE0400;
                                    //     EXIT;
                                    // END_IF;
                                
                                    // MEMCPY(
                                    //     destAddr:=ADR(stHwConnect.Static.pnConfigRecord.record.buf[tempBufoffset]) , 
                                    //     srcAddr:=ADR(aTxref[statLowerBoundTxref + TO_DINT(statDataOffset)]) , 
                                    //     n:=TO_UDINT(tempI) );

                                    FOR i := 1 TO TO_INT(tempI) DO
                                        stHwConnect.Static.pnConfigRecord.record.buf[TO_INT(tempBufoffset)+i-INT#1] := aTxref[statLowerBoundTxref + TO_DINT(statDataOffset) + i - 1];
                                    END_FOR;
                                    
                                    
                                END_IF;
                                
                                // save offset for further telegrams 
                                statDataOffset := statDataOffset + tempI;
                                statDataTodo := statDataTodo - tempI;
                                nTrlen := nTrlen + tempI;
                                
                                statFurtherTelegram := false;
                                stHwConnect.STATIC.acyc_active := true;
                                // first call of wrrec 
                                
                                stHwConnect.Static.pnConfigRecord.record.nLen := TO_WORD(statBufLen);	
                                // stHwConnect.Static.pnConfigRecord.nRW := ADS_WRITE;		   
                                // statAdsRdWrt.WRTRD := TRUE;
                                statWRREC.request := TRUE;
                                statWRREC(request := TRUE,
                                        id      :=  stHwConnect.HW_ID,
                                        index   :=  stHwConnect.STATIC.index,
                                        length := statBufLen,
                                        record := stHwConnect.Static.pnConfigRecord.record.buf);

                                // save error till next plc-cycle 
                                statSaveError := statWRREC.ERROR;
                                statIntStatus := statWRREC.STATUS;

                                stHwConnect.STATIC.state := STATE5;
                                
                            STATE5: //------------------------------------finish ADS WRITE--------------------------------------
                                
                                // reset start request
                                statWRREC.request := FALSE; 							   
                                        
                                // error at WRREC 
                                IF statWRREC.error OR statSaveAdsError THEN
                                    stHwConnect.STATIC.acyc_active := false;
                                IF NOT statSaveAdsError THEN
                                        // tempStatus := TO_WORD(statAdsRdWrt.ERRID);
                                        tempStatus := TO_WORD(statWRREC.status); //TODO:from DWORD to WORD ???
                                    ELSE
                                        tempStatus := TO_WORD(statIntAdsErrId);
                                    END_IF;
                                    // repeat if ressources are busy 
                                    IF tempStatus = ERRID_DEVICE_BUSY THEN 
                                        stHwConnect.STATIC.acyc_active := TRUE;
                                        
                                        stHwConnect.Static.pnConfigRecord.record.nLen := TO_WORD(statBufLen);	
                                        stHwConnect.Static.pnConfigRecord.nRW := ADS_WRITE;		   
                                        statWRREC.request := TRUE;							
                                        // statAdsRdWrt.WRTRD := TRUE;							
                                        // statWRREC(REQ := TRUE,
                                        //         ID := WORD_TO_UINT(hw_connect.HW_ID),
                                        //         INDEX := hw_connect.STATIC.index,
                                        //         LEN := INT_TO_UINT(statBufLen),
                                        //         RECORD := hw_connect.STATIC.buf);
                                        statSaveError := statWRREC.error;
                                        statIntStatus := statWRREC.status;                                        
                                        EXIT;
                                    END_IF;
                                    IF statPduDetection AND stHwConnect.STATIC.index_set THEN
                                        // first pdu-detection with PROFINET-index was failed. try again with PROFIBUS-index 
                                        stHwConnect.STATIC.state := STATE2;
                                        stHwConnect.STATIC.index := stHwConnect.CM_CHANNEL + UINT#100;
                                        stHwConnect.STATIC.index_set := FALSE;
                                        statPduRepeat := TRUE;
                                        statSaveError := FALSE;
                                    ELSE
                                        // any other error is occured => go to error_routine 
                                        tempIntError := TRUE;
                                        IF NOT statSaveError THEN
                                            // statIntStatus := statAdsRdWrt.ERRID;
                                            statIntStatus := statWRREC.status;
                                        ELSE
                                            statSaveError := FALSE;
                                        END_IF;
                                        EXIT;
                                    END_IF;
                                    // WRREC was finished wothout errors 
                                // ELSIF statAdsRdWrt.BUSY = FALSE AND NOT statAdsRdWrt.ERR = TRUE THEN
                                ELSIF statWRREC.done AND NOT statWRREC.busy AND NOT statWRREC.error THEN
                                    stHwConnect.STATIC.acyc_active := FALSE;
                                    IF statDataTodo > UDINT#0 THEN
                                        // write next packet of command 
                                        stHwConnect.STATIC.state := STATE4;
                                        statFurtherTelegram := TRUE;
                                    ELSE
                                        // if chained comands => increase internal cmd_selektor and get next command  //MN++++
                                        IF statCmd.CHAINED AND statCmdSelCounter < UINT#100 AND NOT stHwConnect.STATIC.STATUS_INITIALISATION THEN
                                            statCmdSelCounter := statCmdSelCounter + UINT#1;
                                            
                                            statCmd := aCmdref[statCmdSelCounter];
                                            // statLastMoveError := MOVE_BLK_VARIANT(SRC := cmdref,
                                            //                                     COUNT := 1,
                                            //                                     SRC_INDEX := (statCmdSelCounter - 1),
                                            //                                     DEST_INDEX := 0,
                                            //                                     DEST => statCmd);
                                                                                
                                            
                                            // IF statLastMoveError <> 0 THEN
                                            //     tempIntError := true;
                                            //     statIntStatus := 16#E7FE0B00;
                                            //     EXIT;
                                            // END_IF;
                                            
                                            statChainedCounter := statChainedCounter + UINT#1;
                                            stHwConnect.STATIC.state := STATE4;
                                            statFurtherTelegram := false;
                                        ELSE
                                            // setup things to receive acknowledgement 
                                            statAdb := UINT#0;
                                            stHwConnect.STATIC.state := STATE6;
                                        END_IF;
                                    END_IF;
                                END_IF;
                                
                            STATE6://---------------------wait for acknowledgement (CommandCounter) and start ADS READ---------------------------
                                IF stHwConnect.STATIC.old_AC_H <> stHwConnect.STATIC.AC_H OR stHwConnect.STATIC.old_AC_L <> stHwConnect.STATIC.AC_L THEN
                                    // remember acknowledge counter 
                                    stHwConnect.STATIC.old_AC_H := stHwConnect.STATIC.AC_H;
                                    stHwConnect.STATIC.old_AC_L := stHwConnect.STATIC.AC_L;
                                    // set sequence number for repeat command 
                                    IF stHwConnect.STATIC.RPTCMD_active THEN
                                        IF (statChainedCounter = statFixChainedCounter) AND NOT statSqModified THEN //T0300_04 go in only once
                                            stHwConnect.STATIC.sequence_number := stHwConnect.STATIC.sequence_number + statFixChainedCounter;
                                            statSqModified := true;
                                        END_IF;
                                    END_IF;
                                    
                                    // copy over actual command  
                                    statCmd := aCmdref[(statCmdSelCounter - statChainedCounter) + UINT#1];
                                    // IF NOT hw_connect.STATIC.STATUS_INITIALISATION THEN
                                    //     // copy over actual command  
                                    //     statCmd := CMDREF[(statCmdSelCounter - statChainedCounter) + 1];
                                        
                                    //     statLastMoveError := MOVE_BLK_VARIANT(SRC := cmdref,
                                    //                                         COUNT := 1,
                                    //                                         SRC_INDEX := (((statCmdSelCounter - statChainedCounter) + 1) - 1),
                                    //                                         DEST_INDEX := 0,
                                    //                                         DEST => statCmd);
                                                                            
                                    // ELSE
                                        
                                    //     // build Reset command
                                    //     statCmd.CMD := eAxo_IID_COMMANDS#eWriteConfig;
                                    //     statCmd.CONFIG := hw_connect.CONFIGURATION.config_mode;
                                    //     IF hw_connect.CONFIGURATION.config_mode = 3 THEN
                                    //         statCmd.LEN_DATA := 16;
                                    //     ELSE
                                    //         statCmd.LEN_DATA := 0;
                                    //     END_IF;
                                    //     statCmd.ADDR_TAG := 0;
                                    //     statCmd.ATTRIBUTES := 0;
                                    //     statCmd.CHAINED := false;
                                    //     statCmd.EXT_UHF.EDIT_BLACKLIST_MODE := 0;
                                    //     statCmd.EXT_UHF.INVENTORY_DUR_UNIT := 0;
                                    //     statCmd.EXT_UHF.INVENTORY_DURATION := 0;
                                    //     statCmd.EXT_UHF.LEN_ID := 0;
                                    //     statCmd.EXT_UHF.LOCK_TAG_BANK_ACTION := 0;
                                    //     statCmd.EXT_UHF.LOCK_TAG_BANK_MASK := 0;
                                    //     statCmd.EXT_UHF.MEM_BANK := 16#3;
                                    //     statCmd.EXT_UHF.PSWD := 0;
                                        
                                    //     FILL_BLK(IN := TO_BYTE(16#00),
                                    //             COUNT := INT_TO_UINT(62),
                                    //             OUT => statCmd.EPCID_UID[1]);
                                        
                                    // END_IF;
                                    
                                    
                                    
                                    // IF statLastMoveError <> 0 THEN
                                    //     tempIntError := true;
                                    //     statIntStatus := 16#E7FE0B00;
                                    //     EXIT;
                                    // END_IF;
                                   
                                    // got to next step => read answer 
                                    stHwConnect.STATIC.state := STATE7;
                                    
                                    // first call of rdrec 
                                    stHwConnect.STATIC.acyc_active := TRUE;
                                                
                                    stHwConnect.Static.pnConfigRecord.record.nLen := TO_WORD(stHwConnect.STATIC.buf_max);	
                                    stHwConnect.Static.pnConfigRecord.nRW := ADS_READ;		   

                                    statRDREC.request := TRUE;
                                    // statAdsRdWrt.WRTRD := TRUE;
                                    // statRDREC(REQ := TRUE,
                                    //         ID := WORD_TO_UINT(hw_connect.HW_ID),
                                    //         INDEX := hw_connect.STATIC.index,
                                    //         MLEN := INT_TO_UINT(hw_connect.STATIC.buf_max),
                                    //         RECORD := hw_connect.STATIC.buf);
                                    // // save error till next plc-cycle 
                                    // statSaveError := statRDREC.ERROR;
                                    // statIntStatus := statRDREC.STATUS;

                                    statSaveError := statRDREC.error;
                                    statIntStatus := statRDREC.status;
                                    
                                ELSIF stHwConnect.STATIC.RPTCMD_cyc AND NOT stHwConnect.STATIC.RPTCMD_active THEN
                                    // check timeout for repeat support
                                    // Change 03.00.02
                                    statTimeout(signal := FALSE,
                                                duration := stHwConnect.STATIC.timeout_repeat);
                                    
                                    statTimeout(signal := TRUE,
                                    duration := stHwConnect.STATIC.timeout_repeat);
                                    IF statTimeout.output = TRUE THEN
                                        // timeout of repeat 
                                        stHwConnect.STATIC.state := STATE4;
                                        tempIntError := true;
                                        statIntStatus := DWORD#16#E7FE0900;
                                    END_IF;
                                END_IF;
                                
                            STATE7: //---------------------finish RDREC and receive data----------------------------
                                // reset start request
                                statRDREC.request := FALSE; 
                                // statAdsRdWrt.WRTRD := FALSE; 
                                statEmptyCycle := TRUE;
                        
                                
                                // error at RDREC 
                                IF statRDREC.error OR statSaveAdsError THEN
                                    
                                    stHwConnect.STATIC.acyc_active := false;
                                    
                                    IF NOT statSaveAdsError THEN
                                        tempStatus := TO_WORD(statRDREC.status);  // Todo: from DWORD to Word ???
                                    ELSE
                                        tempStatus := TO_WORD(statIntAdsErrId);
                                    END_IF;
                                    // repeat if ressources are busy 
                                    IF tempStatus = ERRID_DEVICE_BUSY AND NOT statEmptyCycle THEN 
                                        stHwConnect.STATIC.acyc_active := TRUE;
                                        
                                        stHwConnect.Static.pnConfigRecord.record.nLen := TO_WORD(stHwConnect.STATIC.buf_max);	
                                        stHwConnect.Static.pnConfigRecord.nRW := ADS_READ;		   
                                        statRDREC.request := TRUE;							
                                        // statAdsRdWrt.WRTRD := TRUE;							
                                        // statWRREC(REQ := TRUE,
                                        //         ID := WORD_TO_UINT(hw_connect.HW_ID),
                                        //         INDEX := hw_connect.STATIC.index,
                                        //         LEN := INT_TO_UINT(statBufLen),
                                        //         RECORD := hw_connect.STATIC.buf);
                                        // statSaveError := statWRREC.ERROR;
                                        // statIntStatus := statWRREC.STATUS;
                                        statSaveError := statRDREC.ERROR;
                                        statIntStatus := statRDREC.STATUS;
                                        EXIT;
                                    END_IF;

                                    
                                    IF statPduDetection = TRUE THEN
                                        // error, PDU detection not supported;
                                        // DO normal write-config 
                                        statPduDetection := FALSE;
                                        statPduRepeat := false;
                                        stHwConnect.STATIC.state := STATE4;
                                        statSaveError := FALSE;
                                        statSaveAdsError := FALSE;
                                    ELSE
                                        // any other error is occured => go to error_routine 
                                        tempIntError := true;
                                        IF NOT statSaveError THEN
                                            statIntStatus := statRDREC.status;
                                            // statIntStatus := statAdsRdWrt.ERRID;
                                        ELSE
                                            statSaveError := FALSE;
                                            statSaveAdsError := FALSE;
                                        END_IF;
                                        EXIT;
                                    END_IF;
                                    // RDREC was finished without errors 
                                // ELSIF NOT statAdsRdWrt.BUSY AND NOT statAdsRdWrt.ERR THEN
                                ELSIF statRDREC.valid AND NOT statRDREC.busy AND NOT statRDREC.error THEN
                                    stHwConnect.STATIC.acyc_active := false;
                                    
                                    // check error byte 
                                    tempB := stHwConnect.Static.pnConfigRecord.record.buf[5];
                                    
                                    // Read ADB to check at error MN++++
                                    tempW.%B0 := stHwConnect.Static.pnConfigRecord.record.buf[7];
                                    tempW.%B1 := stHwConnect.Static.pnConfigRecord.record.buf[6];
                                    tempAdb := TO_UINT(tempW);	

                                    // Read DBN to check at error MN++++
                                    tempW.%B0 := stHwConnect.Static.pnConfigRecord.record.buf[9];
                                    tempW.%B1 := stHwConnect.Static.pnConfigRecord.record.buf[8];
                                    tempDbn := TO_UINT(tempW);	

                                    IF tempB = BYTE#1 THEN
                                        // pib unit response with error 
                                        IF statPduDetection = TRUE THEN
                                            IF stHwConnect.STATIC.config_value = BYTE#4 THEN
                                                // new index will suppport, but not config=4. try again with same index and config=0 
                                                stHwConnect.STATIC.state := STATE0;
                                                stHwConnect.STATIC.config_value := BYTE#0;
                                                stHwConnect.STATIC.INIT_cyc := TRUE;
                                                statPduRepeat := TRUE;
                                                EXIT;
                                            ELSE
                                                // error, PDU detection not supported or PDU detection is finished;
                                                // DO normal write-config 
                                                statPduDetection := FALSE;
                                                statPduRepeat := false;
                                                stHwConnect.STATIC.state := STATE4;
                                                stHwConnect.STATIC.buf_max := UINT#240;
                                                stHwConnect.STATIC.buf_maxdata := stHwConnect.STATIC.buf_max - stHwConnect.STATIC.buf_header;
                                                EXIT;
                                            END_IF;
                                        ELSE
                                            // any other error is occured => go to error_routine 
                                            tempIntError := true;
                                            // save PIB-Status 
                                            tempDword.%B0   := stHwConnect.Static.pnConfigRecord.record.buf[14];
                                            tempDword.%B1   := stHwConnect.Static.pnConfigRecord.record.buf[13];
                                            tempDword.%B2   := stHwConnect.Static.pnConfigRecord.record.buf[12];
                                            tempDword.%B3   := stHwConnect.Static.pnConfigRecord.record.buf[11];
                                            statIntStatus := tempDword;

                                            EXIT;
                                        END_IF;
                                    ELSE
                                        // yeah, anything ok 
                                        IF tempB <> BYTE#0 THEN
                                            // except a tiny warning 
                                            bWarning := TRUE;
                                            statIntStatus := DWORD#16#F0FE0000;
                                            nStatus := statIntStatus OR tempB;
                                        END_IF;
                                        
                                        // check sequence number 
                                        tempW.%B0 := stHwConnect.Static.pnConfigRecord.record.buf[3];
                                        tempW.%B1 := stHwConnect.Static.pnConfigRecord.record.buf[2];
                                        tempI := TO_UINT(tempW);

                                        IF tempI <> ((stHwConnect.STATIC.sequence_number - statChainedCounter) + UINT#1) THEN
                                            // sequenz number don't match 
                                            tempIntError := TRUE;
                                            statIntStatus := DWORD#16#E5FE0200;
                                            EXIT;
                                        END_IF;
                                        
                                        // check command codex 
                                        IF stHwConnect.Static.pnConfigRecord.record.buf[4] <> TO_BYTE(statCmd.CMD) THEN
                                            // command codex dont match 
                                            tempIntError := TRUE;
                                            statIntStatus := DWORD#16#E5FE0A00;
                                            EXIT;
                                        END_IF;
                                        
                                        // PDU-detection: first telegramm of write-config. 
                                        IF statPduDetection = TRUE THEN
                                            // look for supported PDU size 
                                            IF TO_INT(stHwConnect.Static.pnConfigRecord.record.buf[10]) >= 1 AND TO_INT(stHwConnect.Static.pnConfigRecord.record.buf[10]) <= 3 THEN
                                    
                                                aRxref[statLowerBoundRxref + TO_DINT(statRecvOffset)] := stHwConnect.Static.pnConfigRecord.record.buf[11];
                                                
                                                // statLastMoveError := MOVE_BLK_VARIANT(SRC := hw_connect.STATIC.buf,
                                                //                                     COUNT := 1,
                                                //                                     SRC_INDEX := 11,
                                                //                                     DEST_INDEX := statRecvOffset,
                                                //                                     DEST => rxref);
                                                
                                                // // error at mov_blk 
                                                // IF statLastMoveError <> 0 THEN
                                                //     tempIntError := true;
                                                //     statIntStatus := 16#E7FE0400;
                                                //     EXIT;
                                                // END_IF;
                                                
                                                // Config = 0 
                                                IF stHwConnect.STATIC.config_value = BYTE#0 THEN
                                                    nTrlen := 1;
                                                    tempI := TO_UINT(stHwConnect.Static.pnConfigRecord.record.buf[11]);
                                                    tempMax := UINT#240;
                                                    // Config = 4 
                                                ELSIF stHwConnect.STATIC.config_value = BYTE#4 THEN
                                                    aRxref[statLowerBoundRxref + TO_DINT(statRecvOffset) + 1] :=  stHwConnect.Static.pnConfigRecord.record.buf[12]; //aufpassen++++
                                                    
                                                    // statLastMoveError := MOVE_BLK_VARIANT(SRC := hw_connect.STATIC.buf,
                                                    //                                     COUNT := 1,
                                                    //                                     SRC_INDEX := 12,
                                                    //                                     DEST_INDEX := statRecvOffset + 1,
                                                    //                                     DEST => rxref);
                                                    // // error at mov_blk 
                                                    // IF statLastMoveError <> 0 THEN
                                                    //     tempIntError := true;
                                                    //     statIntStatus := 16#E7FE0400;
                                                    //     EXIT;
                                                    // END_IF;
                                                    

                                                    nTrlen := 2;
                                                    tempW.%B0:= stHwConnect.Static.pnConfigRecord.record.buf[12];
                                                    tempW.%B1:= stHwConnect.Static.pnConfigRecord.record.buf[11];
                                                    tempI := TO_UINT(tempW);

                                                    tempMax := UINT#1035;
                                                END_IF;
                                                // check if PDU-size is valid 
                                                IF tempI < UINT#64 OR tempI > tempMax THEN
                                                    IF tempI <> UINT#0 THEN
                                                        tempIntError := TRUE;
                                                        statIntStatus := DWORD#16#E7FE0A00;
                                                        EXIT;
                                                    ELSE
                                                        stHwConnect.STATIC.buf_max := UINT#240;
                                                    END_IF;
                                                ELSE
                                                    stHwConnect.STATIC.buf_max := tempI;
                                                END_IF;
                                            END_IF;
                                            // set user data size 
                                            stHwConnect.STATIC.buf_maxdata := stHwConnect.STATIC.buf_max - stHwConnect.STATIC.buf_header;
                                            
                                            // instruction set detection 
                                            // IF stHwConnect.Static.pnConfigRecord.record.buf[10] = 3 AND ((stHwConnect.Static.pnConfigRecord.record.buf[13] AND 20000_0001) = 1) THEN
                                            IF stHwConnect.Static.pnConfigRecord.record.buf[10] = BYTE#3 AND stHwConnect.Static.pnConfigRecord.record.buf[13].%X0 THEN
                                                // ext_uhf insrtuctions 
                                                stHwConnect.STATIC.instruction_set := TRUE;
                                                
                                                aRxref[statLowerBoundRxref + TO_DINT(statRecvOffset) + 2] := stHwConnect.Static.pnConfigRecord.record.buf[13];
                                                // statLastMoveError := MOVE_BLK_VARIANT(SRC := hw_connect.STATIC.buf,
                                                //                                     COUNT := 1,
                                                //                                     SRC_INDEX := 13,
                                                //                                     DEST_INDEX := statRecvOffset + 2,
                                                //                                     DEST => rxref);
                                                // // error at mov_blk 
                                                // IF statLastMoveError <> 0 THEN
                                                //     tempIntError := true;
                                                //     statIntStatus := 16#E7FE0400;
                                                //     EXIT;
                                                // END_IF;
                                                
                                                nTrlen := 3;
                                            ELSE
                                                // normal instructions 
                                                stHwConnect.STATIC.instruction_set := false;
                                            END_IF;
                                            // do normal write-config 
                                            statDbn := UINT#0;
                                            statPduDetection := FALSE;
                                            stHwConnect.STATIC.state := STATE4;
                                            EXIT;
                                        END_IF;
                                        
                                        // check/process adb 
                                        tempW.%B0   :=  stHwConnect.Static.pnConfigRecord.record.buf[7];
                                        tempW.%B1   :=  stHwConnect.Static.pnConfigRecord.record.buf[6];
            
                                        IF statAdb = UINT#0 THEN
                                            statAdb := TO_UINT(tempW);
                                            // simple_read-bit not used because of chained commands 
                                            // IF simple_read THEN
                                            //     IF adb <> 1 THEN
                                            //         int_error := true;
                                            //         int_status := 16#E5FE0A00;
                                            //         EXIT;
                                            //     END_IF;
                                            // END_IF;
                                        ELSE
                                            tempI := TO_UINT(tempW);
                                            IF statAdb <> tempI THEN
                                                tempIntError := true;
                                                statIntStatus := DWORD#16#E5FE0A00;
                                                EXIT;
                                            END_IF;
                                        END_IF;
                                        
                                        // check dbn, determining next state 
                                        tempW.%B0   := stHwConnect.Static.pnConfigRecord.record.buf[9];
                                        tempW.%B1   := stHwConnect.Static.pnConfigRecord.record.buf[8];
                                        statDbn := TO_UINT(tempW);
                                        
                                        IF statDbn < statAdb THEN
                                            // read next 
                                            tempFinished := false;
                                        ELSIF statDbn = statAdb THEN
                                            // command completed 
                                            tempFinished := true;
                                        ELSE
                                            tempIntError := true;
                                            statIntStatus := DWORD#16#E5FE0500;
                                            EXIT;
                                        END_IF;
                                        
                                        IF statDbn = UINT#1 THEN
                                            // set offset of receive_buffer for first telegram of command 
                                            statRecvOffset := statCmd.OFFSETBUFFER;
                                            IF statCmd.CMD = eAxo_IID_COMMANDS#eInventory THEN
                                                IF statCmd.ATTRIBUTES = BYTE#16#82 OR statCmd.ATTRIBUTES =  BYTE#16#83 OR statCmd.ATTRIBUTES =  BYTE#16#85 OR statCmd.ATTRIBUTES =  BYTE#16#90 OR statCmd.ATTRIBUTES =  BYTE#16#91
                                                    OR statCmd.ATTRIBUTES =  BYTE#16#92 OR statCmd.ATTRIBUTES =  BYTE#16#A0 OR statCmd.ATTRIBUTES =  BYTE#16#A1 THEN
                                                    tempShift := true;
                                                END_IF;
                                            END_IF;
                                            IF statCmd.CMD = eAxo_IID_COMMANDS#eReaderStatus THEN
                                                IF statCmd.ATTRIBUTES =  BYTE#16#A0 OR statCmd.ATTRIBUTES =  BYTE#16#A1 THEN
                                                    tempShift := true;
                                                END_IF;
                                            END_IF;
                                            IF statCmd.CMD = eAxo_IID_COMMANDS#eTagStatus THEN
                                                IF statCmd.ATTRIBUTES =  BYTE#16#04 OR statCmd.ATTRIBUTES =  BYTE#16#82 OR statCmd.ATTRIBUTES =  BYTE#16#83 OR statCmd.ATTRIBUTES =  BYTE#16#84 OR statCmd.ATTRIBUTES =  BYTE#16#85 THEN
                                                    tempShift := true;
                                                END_IF;
                                            END_IF;
                                            IF tempShift THEN
                                                statRecvOffset := statRecvOffset + UDINT#1;
                                                tempZeroValue := BYTE#0;
                                                // IF TypeOfElements(rxref) = Char THEN
                                                //     statLastMoveError := MOVE_BLK_VARIANT(SRC := BYTE_TO_CHAR(tempZeroValue), COUNT := 1, SRC_INDEX := 0, DEST_INDEX := (statRecvOffset - 1), DEST => rxref);
                                                // ELSE
                                                //     statLastMoveError := MOVE_BLK_VARIANT(SRC := tempZeroValue, COUNT := 1, SRC_INDEX := 0, DEST_INDEX := (statRecvOffset - 1), DEST => rxref);
                                                // END_IF;
                                                
                                                aRxref[statLowerBoundRxref + TO_DINT(statRecvOffset) - 1] := tempZeroValue;
                                                
                                                IF statLastMoveError <> 0 THEN
                                                    tempIntError := true;
                                                    statIntStatus := DWORD#16#E7FE0400;
                                                    EXIT;
                                                END_IF;
                                            END_IF;
                                        END_IF;
                                        
                                        // check dbl // if PDU > 240, length is only in byte 0 and 1 
                                        IF stHwConnect.STATIC.buf_max > UINT#240 THEN
                                            tempW.%B0   :=  stHwConnect.Static.pnConfigRecord.record.buf[1];
                                            tempW.%B1   :=  stHwConnect.Static.pnConfigRecord.record.buf[0];
                                            statSize    :=  TO_UINT(tempW);
                                        ELSE
                                            statSize := TO_UINT(stHwConnect.Static.pnConfigRecord.record.buf[10]);
                                        END_IF;
                                        IF statSize > stHwConnect.STATIC.buf_maxdata THEN
                                            // invalid data block length 
                                            tempIntError := true;
                                            statIntStatus := DWORD#16#E5FE0700;
                                            EXIT;
                                        ELSIF statSize > UINT#0 AND statDbn = UINT#1 THEN
                                            // data arrived, first packet -> reset TRLEN 
                                            nTrlen := 0;
                                        END_IF;
                                        
                                        IF statSize > UINT#0 THEN
                                            // recv_offset was adjusted by RXSTART 
                                            tempLi := statRxbuflen - statRecvOffset;
                                            IF statSize > tempLi THEN
                                                // not enough space in buffer 
                                                tempIntError := true;
                                                statIntStatus := DWORD#16#E7FE0400;
                                                EXIT;
                                            ELSE
                                                // anything ok, copy over data 
                                                // MEMCPY(
                                                //     destAddr:=ADR(aRxref[statLowerBoundRxref + UDINT_TO_DINT(statRecvOffset)]) , 
                                                //     srcAddr:=ADR(stHwConnect.Static.pnConfigRecord.record.buf[stHwConnect.STATIC.buf_header]) , 
                                                //     n:=UINT_TO_UDINT(statSize));

                                                FOR i := 1 TO TO_INT(statSize) DO
                                                    aRxref[statLowerBoundRxref + TO_DINT(statRecvOffset) + TO_DINT(i) - DINT#1] := stHwConnect.Static.pnConfigRecord.record.buf[stHwConnect.STATIC.buf_header + TO_UINT(i) - UINT#1];
                                                END_FOR;
                                                    
                                                // IF TypeOfElements(txref) = Char THEN
                                                //     FOR tempLoop := 0 TO statSize - 1 DO
                                                        
                                                //         tempChar := BYTE_TO_CHAR(hw_connect.Static.pnConfigRecord.record.buf[hw_connect.STATIC.buf_header + tempLoop]);
                                                        
                                                //         statLastMoveError := MOVE_BLK_VARIANT(SRC := tempChar,
                                                //                                             COUNT := 1,
                                                //                                             SRC_INDEX := 0,
                                                //                                             DEST_INDEX := statRecvOffset + tempLoop,
                                                //                                             DEST => rxref);
                                                //     END_FOR;
                                                // ELSE
                                                    
                                                //     statLastMoveError := MOVE_BLK_VARIANT(SRC := hw_connect.STATIC.buf,
                                                //                                         COUNT := INT_TO_UDINT(statSize),
                                                //                                         SRC_INDEX := hw_connect.STATIC.buf_header,
                                                //                                         DEST_INDEX := statRecvOffset,
                                                //                                         DEST => rxref);
                                                    
                                                // END_IF;
                                                // // error at mov_blk 
                                                // IF statLastMoveError <> 0 THEN
                                                //     tempIntError := true;
                                                //     statIntStatus := 16#E7FE0400;
                                                //     EXIT;
                                                // END_IF;
                                                
                                                statRecvOffset := statRecvOffset + statSize;
                                                nTrlen := nTrlen + statSize;
                                                // add one to length if a zero-byte was added in buffer 
                                                IF tempShift THEN
                                                    nTrlen := nTrlen + 1;
                                                    tempShift := false;
                                                END_IF;
                                            END_IF;
                                        END_IF;
                                        
                                        // read next telegram 
                                        IF NOT tempFinished THEN
                                            stHwConnect.STATIC.state := STATE6;
                                        ELSE
                                            // -command- complete 
                                            //Change 03.00.02
                                            
                                            // if chained commands => decrease chained counter 
                                            IF statChainedCounter > UINT#1 THEN
                                                statChainedCounter := statChainedCounter - UINT#1;
                                                stHwConnect.STATIC.state := STATE6;
                                                statAdb := UINT#0;
                                                EXIT;
                                            ELSE
                                                stHwConnect.STATIC.state := STATE4;
                                                
                                                // map input RPTCMD to RPTCMD_cyc 
                                                stHwConnect.STATIC.RPTCMD_cyc := bRepeatCommand;
                                                
                                                IF statChainedStatus <> DWORD#0 THEN
                                                    tempIntError := true;
                                                    EXIT;
                                                END_IF;
                                            END_IF;
                                            
                                            // set outputs 
                                            bDone := TRUE;
                                            bBusy := FALSE;
                                            bError := FALSE;
                                            // reset pib-status-variables 
                                            stHwConnect.STATIC.STATUS_IN_WORK := false;
                                            stHwConnect.STATIC.STATUS_INITIALISATION := false;
                                        END_IF;
                                    END_IF;
                                END_IF;
                            STATE8: //---------------------end of soft reset----------------------------
                                IF NOT stHwConnect.STATIC.SRESET_active THEN
                                    // reset command counter 
                                    stHwConnect.STATIC.old_CC_H := FALSE;
                                    stHwConnect.STATIC.old_CC_L := FALSE;
                                    // remember acknowledge counter 
                                    stHwConnect.STATIC.old_AC_H := stHwConnect.STATIC.AC_H;
                                    stHwConnect.STATIC.old_AC_L := stHwConnect.STATIC.AC_L;
                                    // reset chained counter 
                                    statChainedCounter := UINT#1;
                                    statFixChainedCounter := UINT#1;
                                    
                                    // reset status-variables 
                                    stHwConnect.STATIC.STATUS_IN_WORK := FALSE;
                                    stHwConnect.STATIC.STATUS_INITIALISATION := FALSE;
                                    // reset state-variable 
                                    stHwConnect.STATIC.state := STATE4;
                                    
                                    // drop repeat 
                                    stHwConnect.STATIC.RPTCMD_cyc := FALSE;
                                    bRepeatActive := FALSE;
                                    // set outputs 
                                    bDone := TRUE;
                                    bBusy := FALSE;
                                    bError := FALSE;
                                    nStatus := DWORD#0;
                                END_IF;
                                
                            ELSE
                                tempIntError := true;
                                statIntStatus := DWORD#16#E7FE0801;
                        END_CASE;
                    END_FOR;
                END_IF;
                
                // check for timeout of pdu_detection 
                IF statPduDetection THEN
                    statTimeout(signal := TRUE,
                                duration := stHwConnect.STATIC.timeout_reset);
                    IF statTimeout.output = TRUE THEN
                        tempIntError := TRUE;
                        statIntStatus := DWORD#16#E7FE0800;
                    END_IF;
                END_IF;
                
                
                //set pn information 
                stHwConnect.Static.pnConfigRecord.nApi := stHwConnect.API; 
                stHwConnect.Static.pnConfigRecord.nSlot := stHwConnect.SLOT; 
                stHwConnect.Static.pnConfigRecord.nSubslot := stHwConnect.SUB_SLOT; 
                stHwConnect.Static.pnConfigRecord.nNrAr := stHwConnect.AR_NUMBER; 
                stHwConnect.Static.pnConfigRecord.record.nIndex := TO_WORD(stHwConnect.Static.index);

                statWRREC(  id      :=  stHwConnect.HW_ID,
                            index   :=  stHwConnect.STATIC.index,
                            length  :=  TO_UINT(stHwConnect.Static.pnConfigRecord.record.nLen) + PN_CONFIGRECORD_HEADER_LEN, 
                            record	:=  stHwConnect.Static.pnConfigRecord.record.buf);

                statRDREC(  id          :=  stHwConnect.HW_ID,
                            index       :=  stHwConnect.STATIC.index,
                            maxLength  :=  stHwConnect.Static.buf_max, 
                            record	    :=  stHwConnect.Static.pnConfigRecord.record.buf);

                // statAdsRdWrt(
                //             NETID:= stHwConnect.AMS_NET_ID, 
                //             PORT:= stHwConnect.PORT, 
                //             IDXGRP:= 16#0000_F823, 
                //             IDXOFFS:= 16#0000_0000, 
                //             WRITELEN:= stHwConnect.Static.pnConfigRecord.record.nLen + PN_CONFIGRECORD_HEADER_LEN, 
                //             READLEN:= stHwConnect.Static.pnConfigRecord.record.nLen, 
                //             SRCADDR:= ADR(stHwConnect.Static.pnConfigRecord), 
                //             DESTADDR:= ADR(stHwConnect.Static.pnConfigRecord.record.buf), 
                //             // WRTRD:= , 
                //             TMOUT:= ADS_TIMEOUT//, 
                //             // BUSY=> , 
                //             // ERR=> , 
                //             // ERRID=> 
                //             );
                
                statEmptyCycle := FALSE;
                
            // save istantly rising errors for statemachine 
            // statSaveAdsError := statAdsRdWrt.ERR;
            // statIntAdsErrId := statAdsRdWrt.ERRID;
            statSaveAdsError := statWRREC.error OR statRDREC.error;
            IF statWRREC.error THEN
                statIntAdsErrId := TO_UDINT(statWRREC.status);
            ELSIF statRDREC.error THEN
                statIntAdsErrId := TO_UDINT(statRDREC.status);
            ELSE
                statIntAdsErrId := UDINT#0;
            END_IF;
                
                
                // error handling 
                IF tempIntError THEN
                    // if chain is not at the end don't finish the block 
                    IF (statChainedCounter > UINT#16#01) AND (stHwConnect.STATIC.state > UINT#16#05) THEN
                        statChainedCounter := statChainedCounter - UINT#1;
                        stHwConnect.STATIC.state := STATE6;
                        statAdb := UINT#0;
                        // save only first error-status in a chain 
                        IF statChainedStatus = DWORD#16#0 THEN
                            statChainedStatus := statIntStatus;
                        END_IF;
                        //Send all telegrams of one Command  //Change 03.00.01
                        //ELSIF tempDbn < tempAdb AND hw_connect.Static.state = STATE7 THEN //Change 03.00.05
                        //    hw_connect.Static.state := STATE6;
                    ELSE
                        // reset pib-status-variables 
                        stHwConnect.STATIC.STATUS_IN_WORK := false;
                        stHwConnect.STATIC.STATUS_INITIALISATION := false;
                        tempIntError := false;
                        stHwConnect.STATIC.state := STATE4;
                        statPduDetection := false;
                        
                        // if error occured at chain, put the first error-status out
                        IF statChainedStatus <> DWORD#16#0 THEN
                            statIntStatus := statChainedStatus;
                            statChainedStatus := DWORD#16#0;
                        END_IF;
                        
                        // set output variables 
                        bDone := FALSE;
                        bBusy := FALSE;
                        bError := TRUE;
                        nStatus := statIntStatus;
                        
                        // save last status + timestamp 
                        statLastErrorStatus := statIntStatus;

                    END_IF;
                END_IF;
                ELSE
                    statErrorCounter := statErrorCounter + 1; 	
                END_IF;

        END_METHOD
    END_CLASS
END_NAMESPACE
