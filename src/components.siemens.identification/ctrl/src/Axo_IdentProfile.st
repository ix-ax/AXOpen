USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC Axo_IdentProfile 
        VAR PUBLIC
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
            statWRREC               :   WriteRecord;                        // instance of WriteRecord
            statRDREC               :   ReadRecord;                         // instance of WriteRecord
            statTimeout             :   System.Timer.OnDelay;               // instance of timer
            statCmd                 :   Axo_IID_CMD_STRUCT;                 // actual cmd
            statSaveAdsError        :   BOOL;
            statIntAdsErrId         :   UDINT;
            statLowerBoundTxref     :   DINT;
            statUpperBoundTxref     :   DINT;
            statLowerBoundRxref     :   DINT;
            statUpperBoundRxref     :   DINT;
            statErrorCounter        :   DINT;
            statSaveWrRecError	    :   BOOL;
            statSaveRdRecError	    :   BOOL;
            statIntWrRecErrId	    :   UDINT;
            statIntRdRecErrId	    :   UDINT;
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
            REC_READ                :   WORD    :=  WORD#16#0;  
            REC_WRITE               :   WORD    :=  WORD#16#1;
            ERRID_DEVICE_BUSY       :   WORD    :=  WORD#16#0000_0708;
        END_VAR

        VAR PRIVATE
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
        METHOD PUBLIC Run
            VAR_INPUT
                Execute            :    BOOL;                               // rising edge: start command
                RepeatCommand      :    BOOL;                               // repeat command
                SoftReset          :    BOOL;                               // soft reset
                Init               :    BOOL;                               // init-run
                refHwConnect       :    REF_TO Axo_IID_HW_CONNECT;  
                refCmd             :    REF_TO Axo_IID_CMD_STRUCT;          // command
                refTx              :    REF_TO ARRAY[*] OF BYTE;            // send-buffer
                refRx              :    REF_TO ARRAY[*] OF BYTE;            // receive-buffer
            END_VAR         
            VAR_OUTPUT          
                Done               :   BOOL;                               // command is done
                Busy               :   BOOL;                               // command is in work
                Error              :   BOOL;                               // command ended with error
                Warning            :   BOOL;                               // command ended with warning
                Status             :   DWORD   :=  DWORD#0;                // status of warning and error
                RepeatActive       :   BOOL;                               // repeat command is active
                ErrIreq            :   BOOL;                               // error at communication module
                Tpc                :   BOOL;                               // number of tags has changed
                Tp                 :   BOOL;                               // tag presence
                Uin0               :   BOOL;                               // user-input 0 of the Ident-Unit
                Uin1               :   BOOL;                               // user-input 1 of the Ident-Unit
                Uin2               :   BOOL;                               // user-input 2 of the Ident-Unit
                Uin3               :   BOOL;                               // user-input 3 of the Ident-Unit
                Trlen              :   DINT;                               // length of send/receive data
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
                rwr                 :   WORD;
                rww                 :   WORD;
                data                :   ARRAY[0..1] OF BYTE;
                i                   :   UINT;
            END_VAR


            Done            :=  bDone;
            Busy            :=  bBusy;
            Error           :=  bError;
            Warning         :=  bWarning;
            Status          :=  nStatus;
            RepeatActive    :=  bRepeatActive;
            ErrIreq         :=  bErrIreq;
            Tpc             :=  bTpc;
            Tp              :=  bTp;
            Uin0            :=  bUin0;
            Uin1            :=  bUin1;
            Uin2            :=  bUin2;
            Uin3            :=  bUin3;
            Trlen           :=  nTrlen;

            IF refHwConnect = NULL THEN
                nStatus := DWORD#16#FEFE0001; // TODO provide message
                statErrorCounter := statErrorCounter + 1;
                RETURN;
            END_IF;
            
            IF refTx = NULL THEN
                nStatus := DWORD#16#FEFE0002; // TODO provide message
                statErrorCounter := statErrorCounter + 1;
                RETURN;
            END_IF;
            
            IF refRx = NULL THEN
                nStatus := DWORD#16#FEFE0003; // TODO provide message
                statErrorCounter := statErrorCounter + 1;
                RETURN;
            END_IF;

            IF refCmd = NULL THEN
                nStatus := DWORD#16#FEFE0004; // TODO provide message
                statErrorCounter := statErrorCounter + 1;
                RETURN;
            END_IF;
            
            IF statPrevExecute <> Execute THEN
                tempRaisedExecute := Execute;
            END_IF;
            IF statPrevInit <> Init THEN
                tempRaisedInit := Init;
            END_IF;
            IF statPrevSReset <> SoftReset THEN
                tempRaisedSreset := SoftReset;
            END_IF;
            
            // Save Inputs 
            statPrevExecute := Execute;
            statPrevInit := Init;
            statPrevSReset := SoftReset;
            
            // reset outputs, if no init or execute or sreset is set 
            IF (NOT Execute AND NOT Init AND NOT SoftReset) AND NOT refHwConnect^.Static.STATUS_IN_WORK THEN
                bDone := false;
                bBusy := false;
                bError := false;
                nStatus := DWORD#0;
            END_IF;
            
            // start SRESET 
            IF tempRaisedSreset THEN
                refHwConnect^.Static.SRESET_cyc := true;
                refHwConnect^.Static.STATUS_IN_WORK := true;
                // Set Outputs 
                bDone := FALSE;
                bBusy := TRUE;
                bError := FALSE;
                bWarning := FALSE;
                nStatus := DWORD#0;
            END_IF;
            
            // Init or  Execute is set; Init can start everytime. Execute (command) only if nothing is working 
            IF (tempRaisedInit AND NOT refHwConnect^.Static.STATUS_INITIALISATION) OR (tempRaisedExecute AND NOT refHwConnect^.Static.STATUS_IN_WORK) THEN
                // Set Outputs 
                bDone := FALSE;
                bBusy := TRUE;
                bError := FALSE;
                bWarning := FALSE;
                nStatus := DWORD#0;
                
                //reset move_blk_error
                statLastMoveError := INT#0;
                
                // reset flag for executed initialisation 
                refHwConnect^.Static.STATUS_LAST_CMD_INIT := false;
                
                // check send and receive buffer and save buffer length     
                statLowerBoundTxref := LOWER_BOUND(refTx^, INT#1);
                statUpperBoundTxref := UPPER_BOUND(refTx^, INT#1);
                
                statLowerBoundRxref := LOWER_BOUND(refRx^, INT#1);
                statUpperBoundRxref := UPPER_BOUND(refRx^, INT#1);
                
                statTxbuflen := TO_UDINT (statUpperBoundTxref - statLowerBoundTxref + 1);
                statRxbuflen := TO_UDINT (statUpperBoundRxref - statLowerBoundRxref + 1);
                
               
                IF NOT tempIntError THEN
                    // steps for init procedure 
                    IF tempRaisedInit THEN
                            // set status-variables 
                            refHwConnect^.Static.STATUS_INITIALISATION := true;
                            refHwConnect^.Static.STATUS_IN_WORK := true;
                            // set flag for executed initialisation 
                            refHwConnect^.Static.STATUS_LAST_CMD_INIT := true;
                            // raise INIT in cyclic control word 
                            refHwConnect^.Static.INIT_cyc := tempRaisedInit;
                            // INIT starts in step 0 
                            refHwConnect^.Static.state := STATE0;
                            // reset index and instruction-set 
                            refHwConnect^.Static.instruction_set := false;
                            refHwConnect^.Static.index_set := true;
                            refHwConnect^.Static.config_value := BYTE#16#4;
                            // reset chain infos
                            statChainedStatus := DWORD#16#0;
                            // drop SRESET 
                            refHwConnect^.Static.SRESET_active := FALSE;
                            refHwConnect^.Static.SRESET_cyc := FALSE;
                            // drop internal rpt 
                            refHwConnect^.Static.RPTCMD_cyc := FALSE;
                            //Reset RDREC and WRREC requests
                            statRDREC.request := FALSE;
                            statWRREC.request := FALSE;
                            
                            // calculate INDEX for old modules and RF68xR 
                            IF refHwConnect^.Static.index_set THEN
                                refHwConnect^.Static.index := TO_UINT(WORD#16#B050) - refHwConnect^.CM_CHANNEL;
                            ELSE
                                refHwConnect^.Static.index := refHwConnect^.CM_CHANNEL + UINT#100;
                            END_IF;
                    END_IF;
                    // steps for command procedure 
                    IF tempRaisedExecute AND NOT refHwConnect^.Static.STATUS_IN_WORK THEN
                            // set status-variables 
                            refHwConnect^.Static.STATUS_INITIALISATION := false;
                            refHwConnect^.Static.STATUS_IN_WORK := TRUE;
                            
                            //Reset RDREC and WRREC requests
                            statRDREC.request := FALSE;
                            statWRREC.request := FALSE;
                            
                            // calculate INDEX for old modules and RF68xR 
                            IF refHwConnect^.Static.index_set THEN
                                refHwConnect^.Static.index := TO_UINT(WORD#16#B046) - refHwConnect^.CM_CHANNEL;
                            ELSE
                                refHwConnect^.Static.index := refHwConnect^.CM_CHANNEL + UINT#110;
                            END_IF;
                    END_IF;
                    
                    // set variables for repeat command. only if rpt_active of reader is set 
                    IF  (refHwConnect^.Static.RPTCMD_cyc OR refHwConnect^.Static.RPTCMD_active) AND NOT tempRaisedInit THEN
                            // setup things to receive next acknowledgement sequence 
                            statAdb := UINT#0;
                            // reset timer 
                            statTimeout(signal := FALSE,
                                         duration := refHwConnect^.Static.timeout_repeat);
                            // start timer 
                            statTimeout(signal := TRUE,
                                         duration := refHwConnect^.Static.timeout_repeat);
                            // remind chained counter
                            statChainedCounter := statFixChainedCounter;
                            statSqModified := FALSE;
                            // jump to state 6 => wait for acknowledge and read result 
                            refHwConnect^.Static.state := STATE6;
                    ELSE
                            // reset chained memory if no repeat is started 
                            statFixChainedCounter := UINT#1;
                            statChainedCounter := UINT#1;
                            statSqModified := FALSE;
                            statCmd := refCmd^;
                        
                    END_IF;
                    
                    // check index 
                    IF refHwConnect^.Static.index < UINT#101 OR refHwConnect^.Static.index > UINT#118 OR refHwConnect^.Static.index = UINT#109 OR refHwConnect^.Static.index = UINT#110 THEN
                            IF refHwConnect^.Static.index > TO_UINT(WORD#16#B04F) OR refHwConnect^.Static.index < TO_UINT(WORD#16#B03E) THEN
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
            
            // Read cyclic data
            // rwr := DPRD_DAT(LADDR := TO_UINT (HwConnect^.HW_ID), RECORD => HwConnect^.Static.cyc_status);
            rwr := Siemens.Simatic.S71500.DistributedIO.ReadData(refHwConnect^.HW_ID , data);
            //TODO add messenger in case of reading error
            IF rwr > WORD#0 THEN
                nStatus := DWORD#16#FEFE0005; 
                RETURN;
            END_IF;

            refHwConnect^.Static.cyc_status.%B0   := data[1]; //TODO check order of bytes
            refHwConnect^.Static.cyc_status.%B1   := data[0];
            
            // decode input word 
            bUin0 := refHwConnect^.Static.cyc_status.%X0;
            bUin1 := refHwConnect^.Static.cyc_status.%X1;
            bUin2 := refHwConnect^.Static.cyc_status.%X2;
            bUin3 := refHwConnect^.Static.cyc_status.%X3;
            bErrIreq := refHwConnect^.Static.cyc_status.%X4;
            //busy                            := hw_connect.Static.cyc_status.%X5;  // optional, not used 
            refHwConnect^.Static.RPTCMD_active := refHwConnect^.Static.cyc_status.%X6;
            refHwConnect^.Static.SRESET_active := refHwConnect^.Static.cyc_status.%X7;
            bTp := refHwConnect^.Static.cyc_status.%X8;
            refHwConnect^.Static.presence := refHwConnect^.Static.cyc_status.%X8;
            bTpc := refHwConnect^.Static.cyc_status.%X9;
            // bit 11 reserved                  := hw_connect.Static.cyc_status.%X10; 
            refHwConnect^.Static.CC_L := refHwConnect^.Static.cyc_status.%X11;
            refHwConnect^.Static.CC_H := refHwConnect^.Static.cyc_status.%X12;
            refHwConnect^.Static.AC_L := refHwConnect^.Static.cyc_status.%X13;
            refHwConnect^.Static.AC_H := refHwConnect^.Static.cyc_status.%X14;
            refHwConnect^.Static.init_active := refHwConnect^.Static.cyc_status.%X15;
            
            // set output for repeat 
            bRepeatActive := refHwConnect^.Static.RPTCMD_active;
            
            // map RPTCMD if Ident_FB is not in_work 
            IF NOT refHwConnect^.Static.STATUS_IN_WORK THEN
                refHwConnect^.Static.RPTCMD_cyc := RepeatCommand;
            END_IF;
            
            // build cyclic control word 
            refHwConnect^.Static.cyc_control := WORD#16#0;
            // 4/5 reserved 
            refHwConnect^.Static.cyc_control.%X6 := refHwConnect^.Static.RPTCMD_cyc;
            refHwConnect^.Static.cyc_control.%X7 := refHwConnect^.Static.SRESET_cyc;
            // 9-14 reserved 
            refHwConnect^.Static.cyc_control.%X15 := refHwConnect^.Static.INIT_cyc;
            
            // Write cyclic data
            // rww := DPWR_DAT(LADDR := TO_UINT( HwConnect^.HW_ID ) , RECORD := HwConnect^.Static.cyc_control);
            data[0] := refHwConnect^.Static.cyc_control.%B1;  //TODO check order of the bytes
            data[1] := refHwConnect^.Static.cyc_control.%B0;
            
            rww := Siemens.Simatic.S71500.DistributedIO.WriteData(refHwConnect^.HW_ID,data);
            // TODO provide messaging in caso of error writing
            IF rww > WORD#0 THEN
                nStatus := DWORD#16#FEFE0006; 
                RETURN;
            END_IF;
                
            // SRESET is set 
            IF refHwConnect^.Static.SRESET_cyc THEN
                // wait till acycl. communication is done 
                IF statWRREC.BUSY THEN
                    statWRREC.request := FALSE;
                    statWRREC(request := FALSE, record := refHwConnect^.Static.pnConfigRecord.record.buf);
                    RETURN;
                END_IF;
                IF statRDREC.BUSY THEN
                    statRDREC.request := FALSE;
                    statRDREC(request := FALSE, record := refHwConnect^.Static.pnConfigRecord.record.buf);
                    RETURN;
                END_IF;
                
                // if reader/CM has ack the SRESET with active-bit, reset cyclic SRESET and jump to step 8 
                IF refHwConnect^.Static.SRESET_active THEN
                    refHwConnect^.Static.state := STATE8;
                    refHwConnect^.Static.SRESET_cyc := false;
                ELSE
                    // if reader/cm is not finished got out 
                    RETURN;
                END_IF;
            END_IF;
            
            
            // go in statemachine only if Ident_FB is in_work and have no error 
            IF refHwConnect^.Static.STATUS_IN_WORK AND NOT tempIntError THEN
                // The loop will only use to jump out at every place if an error occurs 
                FOR tempTmp := UINT#1 TO UINT#1 DO
                    CASE refHwConnect^.Static.state OF
                        STATE0: //----------------------Initialisation 1----------------------------
                            // wait if WRREC and RDREC are done 
                            IF statWRREC.BUSY THEN
                                statWRREC.request := FALSE;
                                statWRREC(request := FALSE, record := refHwConnect^.Static.pnConfigRecord.record.buf);
                                EXIT;
                            END_IF;
                            IF statRDREC.BUSY THEN
                                statRDREC.request := FALSE;
                                statRDREC(request := FALSE, record := refHwConnect^.Static.pnConfigRecord.record.buf);
                                EXIT;
                            END_IF;
                            
                            // reset internal variable 
                            statFurtherTelegram := FALSE;
                            
                            // check CMD validity and command codex 
                            IF (statCmd.CMD <> eAxo_IID_COMMANDS#eWriteConfig) THEN
                                // CMDSEL must be 1 as defined by the IEC standard 
                                // only WRITE_CONFIG is here allowed 
                                tempIntError := TRUE;
                                statIntStatus := DWORD#16#E7FE0100;
                                EXIT;
                            END_IF;
                            
                            // reset sequence_number 
                            refHwConnect^.Static.sequence_number := UINT#0;
                            
                            // reset timer 
                            statTimeout(signal := FALSE,
                                         duration := refHwConnect^.Static.timeout_reset);
                            // start timer 
                            statTimeout(signal := TRUE,
                                         duration := refHwConnect^.Static.timeout_reset);
                            
                            // set buflen of telegram 
                            refHwConnect^.Static.buf_max := UINT#240;
                            refHwConnect^.Static.buf_maxdata := refHwConnect^.Static.buf_max - refHwConnect^.Static.buf_header;
                            // first check PDU size 
                            statPduDetection := TRUE;
                            
                            // go to next step 
                            refHwConnect^.Static.state := STATE1;
                            
                        STATE1: //------------Initialisation 2: wait for init_active of device--------------- 
                            IF refHwConnect^.Static.init_active = TRUE THEN
                                // initialize CC variables 
                                refHwConnect^.Static.old_CC_H := FALSE;
                                refHwConnect^.Static.old_CC_L := FALSE;
                                
                                // remember AC_H/AC_L 
                                refHwConnect^.Static.old_AC_H := refHwConnect^.Static.AC_H;
                                refHwConnect^.Static.old_AC_L := refHwConnect^.Static.AC_L;
                                
                                // drop INIT 
                                refHwConnect^.Static.INIT_cyc := FALSE;
                                
                                // go to next step 
                                refHwConnect^.Static.state := STATE2;
                            END_IF;
                        STATE2: // --------------Initialisation 3: wait until init_active is dropped ----------
                            IF refHwConnect^.Static.init_active = FALSE THEN
                                // and start command processing 
                                IF  (refHwConnect^.Static.old_CC_H <> refHwConnect^.Static.CC_H OR refHwConnect^.Static.old_CC_L <> refHwConnect^.Static.CC_L) OR statPduRepeat THEN
                                    
                                    // remember command counter 
                                    refHwConnect^.Static.old_CC_H := refHwConnect^.Static.CC_H;
                                    refHwConnect^.Static.old_CC_L := refHwConnect^.Static.CC_L;
                                    
                                    // Built Telegram 
                                    // 0 - DBL/reserved 
                                    refHwConnect^.Static.pnConfigRecord.record.buf[0] := BYTE#0;
                                    
                                    // 2/3 - SN
                                    refHwConnect^.Static.sequence_number := refHwConnect^.Static.sequence_number + UINT#1;
                                    
                                    tempW := TO_WORD (refHwConnect^.Static.sequence_number);
                                    refHwConnect^.Static.pnConfigRecord.record.buf[2] := tempW.%B1;
                                    refHwConnect^.Static.pnConfigRecord.record.buf[3] := tempW.%B0;
                                    
                                    
                                    // 4/5 - CC/CI 
                                    refHwConnect^.Static.pnConfigRecord.record.buf[4] := TO_BYTE(statCmd.CMD);
                                    refHwConnect^.Static.pnConfigRecord.record.buf[5] := BYTE#65; // A -> PIB to device 
                                    
                                    // 6/7 - ADB 
                                    refHwConnect^.Static.pnConfigRecord.record.buf[6] := BYTE#0;
                                    refHwConnect^.Static.pnConfigRecord.record.buf[7] := BYTE#1;
                                    
                                    // 8/9 - DBN 
                                    refHwConnect^.Static.pnConfigRecord.record.buf[8] := BYTE#0;
                                    refHwConnect^.Static.pnConfigRecord.record.buf[9] := BYTE#1;
                                    
                                    // 10 - DBL 
                                    // in PIB version > 1.20 the DBL value must be in Byte 1 and 10 at Config = 4 
                                    refHwConnect^.Static.pnConfigRecord.record.buf[10] := BYTE#35;
                                    IF refHwConnect^.Static.config_value = BYTE#4 THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[1] := BYTE#35;
                                    ELSE
                                        refHwConnect^.Static.pnConfigRecord.record.buf[1] := BYTE#0;
                                    END_IF;
                                    
                                    // 11 - Config 
                                    refHwConnect^.Static.pnConfigRecord.record.buf[11] := refHwConnect^.Static.config_value;
                                    
                                    // zero out telegram buffer 
                                    // FILL_BLK(IN := TO_BYTE(16#00),COUNT := 1022,OUT => HwConnect^.Static.pnConfigRecord.record.buf[12]);
                                    FOR i := UINT#12 TO UINT#1034 DO
                                        refHwConnect^.Static.pnConfigRecord.record.buf[i] := BYTE#0;
                                    END_FOR;
                                    
                                    // set offsets for data-buffer 
                                    statBufLen := UINT#46;
                                    statDataTodo := UDINT#0;
                                    statDataOffset := UDINT#0;
                                    statRecvOffset := UDINT#0;
                                    
                                    nTrlen := DINT#0;
                                    
                                    // write packet to the client                                      
                                    refHwConnect^.Static.pnConfigRecord.record.nLen := TO_WORD(statBufLen);
                                    refHwConnect^.Static.pnConfigRecord.nRW := REC_WRITE;
                                    statWRREC.request:= TRUE;
                                    
                                    // go to next step 
                                    refHwConnect^.Static.state := STATE5;
                                END_IF;
                            END_IF;
                            
                        STATE4: //--------------------------------------build command telegram----------------------------------
                            
                            // check command-counter if is a long term telegram 
                            IF statFurtherTelegram OR statChainedCounter > UINT#1 THEN
                                IF NOT  (refHwConnect^.Static.old_CC_H <> refHwConnect^.Static.CC_H OR refHwConnect^.Static.old_CC_L <> refHwConnect^.Static.CC_L) THEN
                                    EXIT;
                                END_IF;
                            END_IF;
                            
                            // remember command counter 
                            refHwConnect^.Static.old_CC_H := refHwConnect^.Static.CC_H;
                            refHwConnect^.Static.old_CC_L := refHwConnect^.Static.CC_L;
                            
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
                                IF statCmd.CMD = eAxo_IID_COMMANDS#eFormat OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite OR statCmd.CMD = eAxo_IID_COMMANDS#ePut OR statCmd.CMD = eAxo_IID_COMMANDS#eWriteConfig OR statCmd.CMD = eAxo_IID_COMMANDS#eWriteID THEN
                                    IF TO_UDINT (statCmd.LEN_DATA) > statTxbuflen OR TO_UDINT (statCmd.LEN_DATA) < UDINT#0 THEN
                                        tempIntError := true;
                                        statIntStatus := DWORD#16#E7FE0400;
                                        EXIT;
                                    END_IF;
                                    statDataTodo := TO_UDINT (statCmd.LEN_DATA);
                                    statDataOffset := statCmd.OFFSETBUFFER;
                                END_IF;
                                
                                // check length for read-commands which knows the length before 
                                IF statCmd.CMD = eAxo_IID_COMMANDS#eRead THEN
                                    //simple_read-bit NOT used because OF chained commands
                                    //simple_read := FALSE;
                                    IF TO_UDINT (statCmd.LEN_DATA) > statRxbuflen OR TO_UDINT (statCmd.LEN_DATA) < UDINT#0 THEN
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
                            
                            // set length of eAxo_IID_COMMANDS#ebuffer for ext_uhf an normal command 
                            IF refHwConnect^.Static.instruction_set AND statCmd.CMD <> eAxo_IID_COMMANDS#eInventory AND statCmd.CMD <> eAxo_IID_COMMANDS#eReaderStatus
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
                            refHwConnect^.Static.pnConfigRecord.record.buf[0] := BYTE#0;
                            
                            // 2/3 - SN 
                            IF NOT statFurtherTelegram THEN
                                refHwConnect^.Static.sequence_number := refHwConnect^.Static.sequence_number + UINT#1;
                            END_IF;
                            
                            tempW := TO_WORD (refHwConnect^.Static.sequence_number);
                            refHwConnect^.Static.pnConfigRecord.record.buf[2] := tempW.%B1;
                            refHwConnect^.Static.pnConfigRecord.record.buf[3] := tempW.%B0;
                            
                            // 4/5 - CC/CI 
                            // set CI for chained commands 
                            IF statCmd.CHAINED AND statCmdSelCounter < UINT#10 THEN
                                statCI := TO_BYTE(TO_UINT (statCI) + UINT#16#20);
                            END_IF;
                            
                            refHwConnect^.Static.pnConfigRecord.record.buf[4] := TO_BYTE(statCmd.CMD);
                            
                            // 
                            refHwConnect^.Static.pnConfigRecord.record.buf[5] := statCI;
                            
                            // 6/7 - ADB 
                            IF NOT statFurtherTelegram THEN
                                statAdb := UINT#1;
                                IF statDataTodo >  (refHwConnect^.Static.buf_maxdata - statSize) THEN
                                    tempLi := statDataTodo -  (refHwConnect^.Static.buf_maxdata - statSize);
                                    statAdb := statAdb + TO_UINT (tempLi / refHwConnect^.Static.buf_maxdata);
                                    IF  (tempLi MOD refHwConnect^.Static.buf_maxdata) <> UINT#0 THEN
                                        statAdb := statAdb + UINT#1;
                                    END_IF;
                                END_IF;
                            ELSE
                                statSize := UINT#0;
                            END_IF;
                            
                            tempW := TO_WORD (statAdb);
                            refHwConnect^.Static.pnConfigRecord.record.buf[6] := tempW.%B1;
                            refHwConnect^.Static.pnConfigRecord.record.buf[7] := tempW.%B0;
                            
                            // 8/9 - DBN 
                            IF NOT statFurtherTelegram THEN
                                statDbn := UINT#0;
                            END_IF;
                            statDbn := statDbn + UINT#1;
                            
                            tempW := TO_WORD (statDbn);
                            refHwConnect^.Static.pnConfigRecord.record.buf[8] := tempW.%B1;
                            refHwConnect^.Static.pnConfigRecord.record.buf[9] := tempW.%B0;
                            
                            // 10 - DBL 
                            IF statDataTodo >  (refHwConnect^.Static.buf_maxdata - statSize) THEN
                                tempI := refHwConnect^.Static.buf_maxdata - statSize;
                            ELSE
                                tempI := TO_UINT (statDataTodo);
                            END_IF;
                            statBufLen := tempI + statSize;
                            // PIB-Spec > 1.20 dbl must be in byte 1 and 0 if pdu > 240 
                            IF refHwConnect^.Static.buf_max <= UINT#240 THEN
                                refHwConnect^.Static.pnConfigRecord.record.buf[10] := TO_BYTE (statBufLen);
                                IF refHwConnect^.Static.config_value = BYTE#4 THEN
                                    refHwConnect^.Static.pnConfigRecord.record.buf[1] := TO_BYTE (statBufLen);
                                ELSE
                                    refHwConnect^.Static.pnConfigRecord.record.buf[1] := BYTE#0;
                                END_IF;
                            ELSIF refHwConnect^.Static.buf_max > UINT#240 THEN
                                tempWord := TO_WORD (statBufLen);
                                
                                tempW := TO_WORD (statBufLen);
                                refHwConnect^.Static.pnConfigRecord.record.buf[0] := tempW.%B1;
                                refHwConnect^.Static.pnConfigRecord.record.buf[1] := tempW.%B0;
                                
                                refHwConnect^.Static.pnConfigRecord.record.buf[10] := BYTE#0;
                            END_IF;
                            statBufLen := statBufLen + refHwConnect^.Static.buf_header;
                            
                            // zero out telegram buffer 
                            // FILL_BLK(IN := TO_BYTE(16#00),
                            //          COUNT := statSize,
                            //          OUT => HwConnect^.Static.pnConfigRecord.record.buf[11]);
                            FOR i := UINT#1 TO statSize DO
                                refHwConnect^.Static.pnConfigRecord.record.buf[i + UINT#10] := BYTE#0;
                            END_FOR;
                            // build CMD-Header in first telegram 
                            IF NOT statFurtherTelegram THEN
                                // save chained counter 
                                statFixChainedCounter := statChainedCounter;
                                
                                // 11 Config 
                                IF statCmd.CMD = eAxo_IID_COMMANDS#eWriteConfig THEN
                                    refHwConnect^.Static.pnConfigRecord.record.buf[11] := statCmd.CONFIG;
                                END_IF;
                                
                                // parameters for ext_uhf 
                                IF refHwConnect^.Static.instruction_set AND statCmd.CMD <> eAxo_IID_COMMANDS#eInventory AND statCmd.CMD <> eAxo_IID_COMMANDS#eReadConfig AND statCmd.CMD <> eAxo_IID_COMMANDS#eWriteConfig THEN
                                    // 11 Mode 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eEditBlacklist THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[11] := statCmd.EXT_UHF.EDIT_BLACKLIST_MODE;
                                    END_IF;
                                    
                                    // 12 Source 
                                    IF statCmd.CMD <> eAxo_IID_COMMANDS#eEditBlacklist AND statCmd.CMD <> eAxo_IID_COMMANDS#eGetBlacklist THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[12] := TO_BYTE (refHwConnect^.CM_CHANNEL);
                                    END_IF;
                                    
                                    // 13 Bank 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[13] := statCmd.EXT_UHF.MEM_BANK;
                                    END_IF;
                                    
                                    // 14-15 address 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite THEN
                                        tempW := TO_WORD (statCmd.ADDR_TAG);
                                        refHwConnect^.Static.pnConfigRecord.record.buf[14] := tempW.%B1;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[15] := tempW.%B0;
                                    END_IF;
                                    
                                    // 16#-17 Length 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eWriteID OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite THEN
                                        tempW := statCmd.LEN_DATA;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[16] := tempW.%B1;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[17] := tempW.%B0;
                                    END_IF;
                                    
                                    // 18-19 pswd 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eWriteID OR statCmd.CMD = eAxo_IID_COMMANDS#eKillTag OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite OR statCmd.CMD = eAxo_IID_COMMANDS#eLockTagBank THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[18] := statCmd.EXT_UHF.PSWD.%B3;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[19] := statCmd.EXT_UHF.PSWD.%B2;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[20] := statCmd.EXT_UHF.PSWD.%B1;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[21] := statCmd.EXT_UHF.PSWD.%B0;
                                    END_IF;
                                    
                                    // action & mask 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eLockTagBank THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[22] := statCmd.EXT_UHF.LOCK_TAG_BANK_ACTION.%B1;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[23] := statCmd.EXT_UHF.LOCK_TAG_BANK_ACTION.%B0;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[24] := statCmd.EXT_UHF.LOCK_TAG_BANK_MASK.%B1;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[25] := statCmd.EXT_UHF.LOCK_TAG_BANK_MASK.%B0;
                                    END_IF;
                                    
                                    // 20 idlength 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eWriteID OR statCmd.CMD = eAxo_IID_COMMANDS#eKillTag OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite OR statCmd.CMD = eAxo_IID_COMMANDS#eLockTagBank OR statCmd.CMD = eAxo_IID_COMMANDS#eEditBlacklist THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[26] := statCmd.EXT_UHF.LEN_ID;
                                    END_IF;
                                    
                                    // 21 - 83 EPC-ID 
                                    IF statCmd.CMD <> eAxo_IID_COMMANDS#eGetBlacklist AND statCmd.CMD <> eAxo_IID_COMMANDS#eReaderStatus THEN //T0300_04
                                        // MOVE_BLK(IN := statCmd.EPCID_UID[1],
                                        //          COUNT := TO_UDINT (statCmd.EXT_UHF.LEN_ID),
                                        //          OUT => HwConnect^.Static.pnConfigRecord.record.buf[27]);
                                        FOR i := UINT#1 TO TO_UINT(statCmd.EXT_UHF.LEN_ID) DO
                                            refHwConnect^.Static.pnConfigRecord.record.buf[i + UINT#26] := statCmd.EPCID_UID[i];
                                        END_FOR;
                                    END_IF;
                                ELSE
                                    // 12-19 UID 
                                    IF statCmd.CMD = eAxo_IID_COMMANDS#eFormat OR statCmd.CMD = eAxo_IID_COMMANDS#eTagStatus OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite THEN
                                        // MOVE_BLK(IN := statCmd.EPCID_UID[1],
                                        //          COUNT := 8,
                                        //          OUT => HwConnect^.Static.pnConfigRecord.record.buf[12]);
                                        FOR i := UINT#1 TO UINT#8 DO
                                            refHwConnect^.Static.pnConfigRecord.record.buf[i + UINT#11] := statCmd.EPCID_UID[i];
                                        END_FOR;                                        
                                    END_IF;
                                    
                                    // 32-33 Length 
                                    IF  (statCmd.CMD = eAxo_IID_COMMANDS#ePut OR statCmd.CMD = eAxo_IID_COMMANDS#eFormat OR statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite OR statCmd.CMD = eAxo_IID_COMMANDS#eWriteConfig) THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[32] := statCmd.LEN_DATA.%B1;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[33] := statCmd.LEN_DATA.%B0;
                                    END_IF;
                                    
                                    // 34-37 StartAddress 
                                    IF  (statCmd.CMD = eAxo_IID_COMMANDS#eRead OR statCmd.CMD = eAxo_IID_COMMANDS#eWrite) THEN
                                        refHwConnect^.Static.pnConfigRecord.record.buf[34] := statCmd.ADDR_TAG.%B3;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[35] := statCmd.ADDR_TAG.%B2;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[36] := statCmd.ADDR_TAG.%B1;
                                        refHwConnect^.Static.pnConfigRecord.record.buf[37] := statCmd.ADDR_TAG.%B0;
                                    END_IF;
                                END_IF;
                                
                                // 38 Attributes 
                                IF statCmd.CMD = eAxo_IID_COMMANDS#eInventory OR statCmd.CMD = eAxo_IID_COMMANDS#eTagStatus OR statCmd.CMD = eAxo_IID_COMMANDS#eReaderStatus THEN
                                    refHwConnect^.Static.pnConfigRecord.record.buf[38] := statCmd.ATTRIBUTES;
                                END_IF;
                                
                                // duration and unit 
                                IF statCmd.CMD = eAxo_IID_COMMANDS#eInventory AND refHwConnect^.Static.instruction_set THEN
                                    refHwConnect^.Static.pnConfigRecord.record.buf[12] := TO_BYTE (refHwConnect^.CM_CHANNEL);
                                    refHwConnect^.Static.pnConfigRecord.record.buf[40] := statCmd.EXT_UHF.INVENTORY_DURATION.%B1;
                                    refHwConnect^.Static.pnConfigRecord.record.buf[41] := statCmd.EXT_UHF.INVENTORY_DURATION.%B0;
                                    refHwConnect^.Static.pnConfigRecord.record.buf[42] := statCmd.EXT_UHF.INVENTORY_DUR_UNIT.%B1;
                                    refHwConnect^.Static.pnConfigRecord.record.buf[43] := statCmd.EXT_UHF.INVENTORY_DUR_UNIT.%B0;
                                END_IF;
                                
                                nTrlen := 0;
                            END_IF;
                            
                            // copy Data in buffer 
                            IF statFurtherTelegram THEN
                                tempBufoffset := refHwConnect^.Static.buf_header;
                            ELSE
                                tempBufoffset := refHwConnect^.Static.buf_header + statSize;
                            END_IF;
                            IF tempI <> UINT#0 THEN
                                // MOVE_BLK(IN := aTxref[statLowerBoundTxref + TO_DINT (statDataOffset)],
                                //          COUNT := TO_UDINT (tempI),
                                //          OUT => HwConnect^.Static.pnConfigRecord.record.buf[tempBufoffset]);
                                FOR i := UINT#1 TO tempI DO
                                    refHwConnect^.Static.pnConfigRecord.record.buf[tempBufoffset + i - UINT#1] := refTx^[statLowerBoundTxref + TO_DINT (statDataOffset) + i - UINT#1];
                                END_FOR;
                            END_IF;
                            
                            // save offset for further telegrams 
                            statDataOffset := statDataOffset + tempI;
                            statDataTodo := statDataTodo - tempI;
                            nTrlen := nTrlen + tempI;
                            
                            statFurtherTelegram := false;
                            refHwConnect^.Static.acyc_active := true;
                            // first call of wrrec 
                            
                            refHwConnect^.Static.pnConfigRecord.record.nLen := TO_WORD(statBufLen);
                            refHwConnect^.Static.pnConfigRecord.nRW := REC_WRITE;
                            
                            statWRREC.request := TRUE;
                            
                            statSaveWrRecError := statWRREC.ERROR;
                            statIntStatus := statWRREC.STATUS;
                            
                            refHwConnect^.Static.state := STATE5;
                            
                        STATE5: //------------------------------------finish WRREC--------------------------------------
                            
                            // reset start request
                            statWRREC.request := FALSE;
                            
                            // error at WRREC 
                            IF statWRREC.ERROR OR statSaveWrRecError THEN
                                refHwConnect^.Static.acyc_active := false;
                                IF NOT statSaveWrRecError THEN
                                    tempStatus := TO_WORD (statWRREC.STATUS);
                                ELSE
                                    tempStatus := TO_WORD (statIntWrRecErrId);
                                END_IF;
                                
                                // repeat if ressources are busy 
                                IF tempStatus = ERRID_DEVICE_BUSY THEN
                                    refHwConnect^.Static.acyc_active := TRUE;
                                    
                                    refHwConnect^.Static.pnConfigRecord.record.nLen := TO_WORD(statBufLen);
                                    refHwConnect^.Static.pnConfigRecord.nRW := REC_WRITE;
                                    
                                    statWRREC.request := TRUE;
                                    
                                    statSaveWrRecError := statWRREC.ERROR;
                                    statIntStatus := statWRREC.STATUS;
                                    
                                    EXIT;
                                END_IF;
                                IF statPduDetection AND refHwConnect^.Static.index_set THEN
                                    // first pdu-detection with PROFINET-index was failed. try again with PROFIBUS-index 
                                    refHwConnect^.Static.state := STATE2;
                                    refHwConnect^.Static.index := refHwConnect^.CM_CHANNEL + UINT#100;
                                    refHwConnect^.Static.index_set := false;
                                    statPduRepeat := true;
                                    statSaveError := false;
                                ELSE
                                    // any other error is occured => go to error_routine 
                                    tempIntError := true;
                                    IF NOT statSaveError THEN
                                        statIntStatus := statWRREC.STATUS;
                                    ELSE
                                        statSaveError := false;
                                    END_IF;
                                    EXIT;
                                END_IF;
                                // WRREC was finished without errors 
                            ELSIF NOT statWRREC.BUSY AND NOT statWRREC.ERROR THEN
                                refHwConnect^.Static.acyc_active := false;
                                IF statDataTodo > UDINT#0 THEN
                                    // write next packet of command 
                                    refHwConnect^.Static.state := STATE4;
                                    statFurtherTelegram := true;
                                ELSE
                                    // if chained comands => increase internal eAxo_IID_COMMANDS#eselektor and get next command  //MN++++
                                    IF statCmd.CHAINED AND statCmdSelCounter < UINT#100 AND NOT refHwConnect^.Static.STATUS_INITIALISATION THEN
                                        statCmdSelCounter := statCmdSelCounter + UINT#1;
                                        
                                        statCmd := refCmd^;
                                        
                                        statChainedCounter := statChainedCounter + UINT#1;
                                        refHwConnect^.Static.state := STATE4;
                                        statFurtherTelegram := false;
                                    ELSE
                                        // setup things to receive acknowledgement 
                                        statAdb := UINT#0;
                                        refHwConnect^.Static.state := STATE6;
                                    END_IF;
                                END_IF;
                            END_IF;
                            
                        STATE6://---------------------wait for acknowledgement (CommandCounter) and start RDREC---------------------------
                            IF refHwConnect^.Static.old_AC_H <> refHwConnect^.Static.AC_H OR refHwConnect^.Static.old_AC_L <> refHwConnect^.Static.AC_L THEN
                                // remember acknowledge counter 
                                refHwConnect^.Static.old_AC_H := refHwConnect^.Static.AC_H;
                                refHwConnect^.Static.old_AC_L := refHwConnect^.Static.AC_L;
                                // set sequence number for repeat command 
                                IF refHwConnect^.Static.RPTCMD_active THEN
                                    IF  (statChainedCounter = statFixChainedCounter) AND NOT statSqModified THEN //T0300_04 go in only once
                                        refHwConnect^.Static.sequence_number := refHwConnect^.Static.sequence_number + statFixChainedCounter;
                                        statSqModified := true;
                                    END_IF;
                                END_IF;
                                
                                // copy over actual command  
                                statCmd := refCmd^;
                                
                                // got to next step => read answer 
                                refHwConnect^.Static.state := STATE7;
                                
                                // first call of rdrec 
                                refHwConnect^.Static.acyc_active := TRUE;
                                
                                refHwConnect^.Static.pnConfigRecord.record.nLen := TO_WORD (refHwConnect^.Static.buf_max);
                                refHwConnect^.Static.pnConfigRecord.nRW := REC_READ;
                                
                                statRDREC.request := TRUE;
                                
                                statSaveError := statRDREC.ERROR;
                                statIntStatus := statRDREC.STATUS;
                                
                            ELSIF refHwConnect^.Static.RPTCMD_cyc AND NOT refHwConnect^.Static.RPTCMD_active THEN
                                // check timeout for repeat support
                                // Change 03.00.02
                                statTimeout(signal := false,
                                             duration := refHwConnect^.Static.timeout_repeat);
                                
                                statTimeout(signal := true,
                                             duration := refHwConnect^.Static.timeout_repeat);
                                IF statTimeout.output = TRUE THEN
                                    // timeout of repeat 
                                    refHwConnect^.Static.state := STATE4;
                                    tempIntError := true;
                                    statIntStatus := DWORD#16#E7FE0900;
                                END_IF;
                            END_IF;
                            
                        STATE7: //---------------------finish RDREC and receive data----------------------------
                            // reset start request
                            statRDREC.request := FALSE;
                            
                            statEmptyCycle := TRUE;
                            
                            
                            // error at RDREC 
                            IF statRDREC.ERROR OR statSaveRdRecError THEN
                                
                                refHwConnect^.Static.acyc_active := false;
                                
                                IF NOT statSaveRdRecError THEN
                                    tempStatus := TO_WORD (statRDREC.STATUS);
                                ELSE
                                    tempStatus := TO_WORD (statIntRdRecErrId);
                                END_IF;
                                
                                // repeat if ressources are busy 
                                IF tempStatus = ERRID_DEVICE_BUSY AND NOT statEmptyCycle THEN
                                    refHwConnect^.Static.acyc_active := TRUE;
                                    
                                    refHwConnect^.Static.pnConfigRecord.record.nLen := TO_WORD (refHwConnect^.Static.buf_max);
                                    refHwConnect^.Static.pnConfigRecord.nRW := REC_READ;
                                    
                                    statRDREC.request := TRUE;
                                    
                                    // save error till next plc-cycle 
                                    statSaveError := statRDREC.ERROR;
                                    statIntStatus := statRDREC.STATUS;
                                    
                                    EXIT;
                                END_IF;
                                
                                
                                IF statPduDetection = TRUE THEN
                                    // error, PDU detection not supported;
                                    // DO normal write-config 
                                    statPduDetection := FALSE;
                                    statPduRepeat := false;
                                    refHwConnect^.Static.state := STATE4;
                                    statSaveError := FALSE;
                                    statSaveWrRecError := FALSE;
                                    statSaveRdRecError := FALSE;
                                ELSE
                                    // any other error is occured => go to error_routine 
                                    tempIntError := true;
                                    IF NOT statSaveError THEN
                                        statIntStatus := statRDREC.STATUS;
                                    ELSE
                                        statSaveError := FALSE;
                                        statSaveWrRecError := FALSE;
                                        statSaveRdRecError := FALSE;
                                    END_IF;
                                    EXIT;
                                END_IF;
                                // RDREC was finished without errors 
                            ELSIF NOT statRDREC.BUSY AND NOT statRDREC.ERROR THEN
                                refHwConnect^.Static.acyc_active := false;
                                
                                // check error byte 
                                tempB := refHwConnect^.Static.pnConfigRecord.record.buf[5];
                                
                                // Read ADB to check at error MN++++
                                tempW := TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[7]);
                                tempW := tempW OR SHL(TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[6]), UINT#8);
                                tempAdb := TO_UINT (tempW);
                                
                                // Read DBN to check at error MN++++
                                tempW := TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[9]);
                                tempW := tempW OR SHL(TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[8]), UINT#8);
                                tempDbn := TO_UINT (tempW);
                                
                                IF tempB = BYTE#1 THEN
                                    // pib unit response with error 
                                    IF statPduDetection = TRUE THEN
                                        IF refHwConnect^.Static.config_value = BYTE#4 THEN
                                            // new index will suppport, but not config=4. try again with same index and config=0 
                                            refHwConnect^.Static.state := STATE0;
                                            refHwConnect^.Static.config_value := BYTE#0;
                                            refHwConnect^.Static.INIT_cyc := true;
                                            statPduRepeat := true;
                                            EXIT;
                                        ELSE
                                            // error, PDU detection not supported or PDU detection is finished;
                                            // DO normal write-config 
                                            statPduDetection := FALSE;
                                            statPduRepeat := false;
                                            refHwConnect^.Static.state := STATE4;
                                            refHwConnect^.Static.buf_max := UINT#240;
                                            refHwConnect^.Static.buf_maxdata := refHwConnect^.Static.buf_max - refHwConnect^.Static.buf_header;
                                            EXIT;
                                        END_IF;
                                    ELSE
                                        // any other error is occured => go to error_routine 
                                        tempIntError := true;
                                        // save PIB-Status 
                                        statIntStatus.%B0 := refHwConnect^.Static.pnConfigRecord.record.buf[14];
                                        statIntStatus.%B1 := refHwConnect^.Static.pnConfigRecord.record.buf[13];
                                        statIntStatus.%B2 := refHwConnect^.Static.pnConfigRecord.record.buf[12];
                                        statIntStatus.%B3 := refHwConnect^.Static.pnConfigRecord.record.buf[11];
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
                                    tempW := TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[3]);
                                    tempW := tempW OR SHL(TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[2]), UINT#8);
                                    tempI := TO_UINT (tempW);
                                    
                                    IF tempI <> ( (refHwConnect^.Static.sequence_number - statChainedCounter) + UINT#1) THEN
                                        // sequence number don't match 
                                        tempIntError := true;
                                        statIntStatus := DWORD#16#E5FE0200;
                                        EXIT;
                                    END_IF;
                                    
                                    // check command codex 
                                    IF refHwConnect^.Static.pnConfigRecord.record.buf[4] <> TO_BYTE(statCmd.CMD) THEN
                                        // command codex dont match 
                                        tempIntError := true;
                                        statIntStatus := DWORD#16#E5FE0A00;
                                        EXIT;
                                    END_IF;
                                    
                                    // PDU-detection: first telegramm of write-config. 
                                    IF statPduDetection = TRUE THEN
                                        // look for supported PDU size 
                                        IF TO_INT (refHwConnect^.Static.pnConfigRecord.record.buf[10]) >= 1 AND TO_INT (refHwConnect^.Static.pnConfigRecord.record.buf[10]) <= 3 THEN
                                            
                                            refRx^[statLowerBoundRxref + TO_DINT (statRecvOffset)] := refHwConnect^.Static.pnConfigRecord.record.buf[11];
                                            
                                            // Config = 0 
                                            IF refHwConnect^.Static.config_value = BYTE#0 THEN
                                                nTrlen := 1;
                                                tempI := TO_UINT (refHwConnect^.Static.pnConfigRecord.record.buf[11]);
                                                tempMax := UINT#240;
                                                // Config = 4 
                                            ELSIF refHwConnect^.Static.config_value = BYTE#4 THEN
                                                refRx^[statLowerBoundRxref + TO_DINT (statRecvOffset) + 1] := refHwConnect^.Static.pnConfigRecord.record.buf[12]; //aufpassen++++
                                                
                                                nTrlen := 2;
                                                tempI := TO_UINT (refHwConnect^.Static.pnConfigRecord.record.buf[12]);
                                                tempI := TO_UINT(TO_WORD (tempI) OR SHL(TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[11]), UINT#8));
                                                tempMax := UINT#1035;
                                            END_IF;
                                            // check if PDU-size is valid 
                                            IF tempI < UINT#64 OR tempI > tempMax THEN
                                                IF tempI <> UINT#0 THEN
                                                    tempIntError := true;
                                                    statIntStatus := DWORD#16#E7FE0A00;
                                                    EXIT;
                                                ELSE
                                                    refHwConnect^.Static.buf_max := UINT#240;
                                                END_IF;
                                            ELSE
                                                refHwConnect^.Static.buf_max := tempI;
                                            END_IF;
                                        END_IF;
                                        // set user data size 
                                        refHwConnect^.Static.buf_maxdata := refHwConnect^.Static.buf_max - refHwConnect^.Static.buf_header;
                                        
                                        // instruction set detection 
                                        // IF HwConnect^.Static.pnConfigRecord.record.buf[10] = BYTE#3 AND ( (HwConnect^.Static.pnConfigRecord.record.buf[13] AND 2#0000_0001) = BYTE#1) THEN
                                        IF refHwConnect^.Static.pnConfigRecord.record.buf[10] = BYTE#3 AND refHwConnect^.Static.pnConfigRecord.record.buf[13].%X0 THEN
                                            // ext_uhf insrtuctions 
                                            refHwConnect^.Static.instruction_set := TRUE;
                                            
                                            refRx^[statLowerBoundRxref + TO_DINT (statRecvOffset) + 2] := refHwConnect^.Static.pnConfigRecord.record.buf[13];
                                            
                                            nTrlen := 3;
                                        ELSE
                                            // normal instructions 
                                            refHwConnect^.Static.instruction_set := false;
                                        END_IF;
                                        // do normal write-config 
                                        statDbn := UINT#0;
                                        statPduDetection := FALSE;
                                        refHwConnect^.Static.state := STATE4;
                                        EXIT;
                                    END_IF;
                                    
                                    // check/process adb 
                                    tempW := TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[7]);
                                    tempW := tempW OR SHL(TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[6]), UINT#8);
                                    
                                    IF statAdb = UINT#0 THEN
                                        statAdb := TO_UINT (tempW);
                                        // simple_read-bit not used because of chained commands 
                                        // IF simple_read THEN
                                        //     IF adb <> 1 THEN
                                        //         int_error := true;
                                        //         int_status := 16#E5FE0A00;
                                        //         EXIT;
                                        //     END_IF;
                                        // END_IF;
                                    ELSE
                                        tempI := TO_UINT (tempW);
                                        IF statAdb <> tempI THEN
                                            tempIntError := true;
                                            statIntStatus := DWORD#16#E5FE0A00;
                                            EXIT;
                                        END_IF;
                                    END_IF;
                                    
                                    // check dbn, determining next state 
                                    tempW := TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[9]);
                                    tempW := tempW OR SHL(TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[8]), UINT#8);
                                    statDbn := TO_UINT (tempW);
                                    
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
                                            IF statCmd.ATTRIBUTES = BYTE#16#82 OR statCmd.ATTRIBUTES = BYTE#16#83 OR statCmd.ATTRIBUTES = BYTE#16#85 OR statCmd.ATTRIBUTES = BYTE#16#90 OR statCmd.ATTRIBUTES = BYTE#16#91
                                                OR statCmd.ATTRIBUTES = BYTE#16#92 OR statCmd.ATTRIBUTES = BYTE#16#A0 OR statCmd.ATTRIBUTES = BYTE#16#A1 THEN
                                                tempShift := true;
                                            END_IF;
                                        END_IF;
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eReaderStatus THEN
                                            IF statCmd.ATTRIBUTES = BYTE#16#A0 OR statCmd.ATTRIBUTES = BYTE#16#A1 THEN
                                                tempShift := true;
                                            END_IF;
                                        END_IF;
                                        IF statCmd.CMD = eAxo_IID_COMMANDS#eTagStatus THEN
                                            IF statCmd.ATTRIBUTES = BYTE#16#04 OR statCmd.ATTRIBUTES = BYTE#16#82 OR statCmd.ATTRIBUTES = BYTE#16#83 OR statCmd.ATTRIBUTES = BYTE#16#84 OR statCmd.ATTRIBUTES = BYTE#16#85 THEN
                                                tempShift := true;
                                            END_IF;
                                        END_IF;
                                        IF tempShift THEN
                                            statRecvOffset := statRecvOffset + UDINT#1;
                                            tempZeroValue := BYTE#0;
        
                                            refRx^[statLowerBoundRxref + TO_DINT (statRecvOffset) - 1] := tempZeroValue;
                                            
                                            IF statLastMoveError <> 0 THEN
                                                tempIntError := true;
                                                statIntStatus := DWORD#16#E7FE0400;
                                                EXIT;
                                            END_IF;
                                        END_IF;
                                    END_IF;
                                    
                                    // check dbl // if PDU > 240, length is only in byte 0 and 1 
                                    IF refHwConnect^.Static.buf_max > UINT#240 THEN
                                        statSize := TO_UINT (refHwConnect^.Static.pnConfigRecord.record.buf[1]);
                                        statSize := TO_UINT(TO_WORD (statSize) OR SHL(TO_WORD (refHwConnect^.Static.pnConfigRecord.record.buf[0]), UINT#8));
                                    ELSE
                                        statSize := TO_UINT (refHwConnect^.Static.pnConfigRecord.record.buf[10]);
                                    END_IF;
                                    IF statSize > refHwConnect^.Static.buf_maxdata THEN
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
                                            // MOVE_BLK(IN:=#HwConnect^.Static.pnConfigRecord.record.buf[HwConnect^.Static.buf_header],
                                            //          COUNT:=TO_UDINT (statSize),
                                            //          OUT=>#aRxref[statLowerBoundRxref + TO_DINT (statRecvOffset)]);
                                            FOR i := UINT#1 TO statSize DO
                                                refRx^[statLowerBoundRxref + TO_DINT (statRecvOffset) + i - INT#1] := refHwConnect^.Static.pnConfigRecord.record.buf[refHwConnect^.Static.buf_header + i - UINT#1];
                                            END_FOR;
                                            
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
                                        refHwConnect^.Static.state := STATE6;
                                    ELSE
                                        // -command- complete 
                                        //Change 03.00.02
                                        
                                        // if chained commands => decrease chained counter 
                                        IF statChainedCounter > UINT#1 THEN
                                            statChainedCounter := statChainedCounter - UINT#1;
                                            refHwConnect^.Static.state := STATE6;
                                            statAdb := UINT#0;
                                            EXIT;
                                        ELSE
                                            refHwConnect^.Static.state := STATE4;
                                            
                                            // map input RPTCMD to RPTeAxo_IID_COMMANDS#ecyc 
                                            refHwConnect^.Static.RPTCMD_cyc := RepeatCommand;
                                            
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
                                        refHwConnect^.Static.STATUS_IN_WORK := false;
                                        refHwConnect^.Static.STATUS_INITIALISATION := false;
                                    END_IF;
                                END_IF;
                            END_IF;
                        STATE8: //---------------------end of soft reset----------------------------
                            IF NOT refHwConnect^.Static.SRESET_active THEN
                                // reset command counter 
                                refHwConnect^.Static.old_CC_H := FALSE;
                                refHwConnect^.Static.old_CC_L := FALSE;
                                // remember acknowledge counter 
                                refHwConnect^.Static.old_AC_H := refHwConnect^.Static.AC_H;
                                refHwConnect^.Static.old_AC_L := refHwConnect^.Static.AC_L;
                                // reset chained counter 
                                statChainedCounter := UINT#1;
                                statFixChainedCounter := UINT#1;
                                
                                // reset status-variables 
                                refHwConnect^.Static.STATUS_IN_WORK := false;
                                refHwConnect^.Static.STATUS_INITIALISATION := false;
                                // reset state-variable 
                                refHwConnect^.Static.state := STATE4;
                                
                                // drop repeat 
                                refHwConnect^.Static.RPTCMD_cyc := false;
                                bRepeatActive := false;
                                // set outputs 
                                bDone := TRUE;
                                bBusy := FALSE;
                                bError := false;
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
                statTimeout(signal := true,
                             duration := refHwConnect^.Static.timeout_reset);
                IF statTimeout.output = TRUE THEN
                    tempIntError := true;
                    statIntStatus := DWORD#16#E7FE0800;
                END_IF;
            END_IF;
            
            
            //set pn information 
            refHwConnect^.Static.pnConfigRecord.nApi := refHwConnect^.API;
            refHwConnect^.Static.pnConfigRecord.nSlot := refHwConnect^.SLOT;
            refHwConnect^.Static.pnConfigRecord.nSubslot := refHwConnect^.SUB_SLOT;
            refHwConnect^.Static.pnConfigRecord.nNrAr := refHwConnect^.AR_NUMBER;
            refHwConnect^.Static.pnConfigRecord.record.nIndex := TO_WORD (refHwConnect^.Static.index);
            
            IF NOT statRDREC.busy THEN
                // statWRREC(ID := TO_UINT (HwConnect^.HW_ID),
                //            INDEX := HwConnect^.Static.index,
                //            LEN := statBufLen,
                //            RECORD := HwConnect^.Static.pnConfigRecord.record.buf);
                statWRREC(  id := refHwConnect^.HW_ID,
                            index := refHwConnect^.Static.index,
                            length := statBufLen,
                            record := refHwConnect^.Static.pnConfigRecord.record.buf);
                // save instantly rising errors for statemachine 
                statSaveWrRecError := statWRREC.ERROR;
                IF statSaveWrRecError THEN
                    statIntWrRecErrId := TO_UDINT(statWRREC.status);
                END_IF;
            END_IF;
            IF NOT statWRREC.busy THEN
                // statRDREC(ID := TO_UINT (HwConnect^.HW_ID),
                //            INDEX := HwConnect^.Static.index,
                //            MLEN := HwConnect^.Static.buf_max,
                //            RECORD := HwConnect^.Static.pnConfigRecord.record.buf);
                statRDREC( id := refHwConnect^.HW_ID,
                           index := refHwConnect^.Static.index,
                           maxLength := refHwConnect^.Static.buf_max,
                           record := refHwConnect^.Static.pnConfigRecord.record.buf);
                
                // save istantly rising errors for statemachine 
                statSaveRdRecError := statRDREC.ERROR;
                IF statSaveRdRecError THEN
                     statIntRdRecErrId := TO_UDINT(statRDREC.status);
                END_IF;
            END_IF;
            
            
            // error handling 
            IF tempIntError THEN
                // if chain is not at the end don't finish the block 
                IF  (statChainedCounter > UINT#16#01) AND  (refHwConnect^.Static.state > UINT#16#05) THEN
                    statChainedCounter := statChainedCounter - UINT#1;
                    refHwConnect^.Static.state := STATE6;
                    statAdb := UINT#0;
                    // save only first error-status in a chain 
                    IF statChainedStatus = DWORD#0 THEN
                        statChainedStatus := statIntStatus;
                    END_IF;
                    //Send all telegrams of one Command  //Change 03.00.01
                    //ELSIF tempDbn < tempAdb AND hw_connect.Static.state = STATE7 THEN //Change 03.00.05
                    //    hw_connect.Static.state := STATE6;
                ELSE
                    // reset pib-status-variables 
                    refHwConnect^.Static.STATUS_IN_WORK := false;
                    refHwConnect^.Static.STATUS_INITIALISATION := false;
                    tempIntError := false;
                    refHwConnect^.Static.state := STATE4;
                    statPduDetection := false;
                    
                    // if error occured at chain, put the first error-status out
                    IF statChainedStatus <> DWORD#0 THEN
                        statIntStatus := statChainedStatus;
                        statChainedStatus := DWORD#0;
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
            
        END_METHOD
    END_CLASS
END_NAMESPACE
