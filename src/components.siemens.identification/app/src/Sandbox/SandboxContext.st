USING  AXOpen.Components.Siemens.Identification;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        bInit           : BOOL;
        rf186_1_init    : BOOL;
        rf186_1_init_PV : BOOL;	
        rf186_1_execute : BOOL;	
        rf186_1_execute_PV : BOOL;	
        rf186_1_nCmdsel     : UINT;
        
        rf186_1 : AXOpen.Components.Siemens.Identification.Axo_IdentProfile;          
        Connect_RF188C_CH01: Axo_IID_HW_CONNECT;
        {#ix-attr:[CompilerOmits()]} 
        aCommands: ARRAY[1..10] OF Axo_IID_CMD_STRUCT;
        {#ix-attr:[CompilerOmits()]} 
        aDataReset: ARRAY[1..16] OF BYTE;
        {#ix-attr:[CompilerOmits()]} 
        aDataRx: ARRAY[1..2000] OF BYTE;
        {#ix-attr:[CompilerOmits()]} 
        aDataTx: ARRAY[1..2000] OF BYTE;

    END_VAR

    METHOD PROTECTED OVERRIDE Main

        VAR       
            i                   : INT;
        END_VAR

        //===================================================================== 
        //Define profinet parameters 
        //=====================================================================
        Connect_RF188C_CH01.CM_CHANNEL := UINT#1;
        // Connect_RF188C_CH01.AMS_NET_ID := '5.95.59.37.2.1';
        // Connect_RF188C_CH01.Port := 4099;
        Connect_RF188C_CH01.HW_ID := HwIdentifiers#rf188c_Reader_1;
        Connect_RF188C_CH01.API := DWORD#16#5B00;
        Connect_RF188C_CH01.SLOT := WORD#2;
        Connect_RF188C_CH01.SUB_SLOT := WORD#1;

        //===================================================================== 
        //Define iid aCommands 
        //=====================================================================
        // Command 1 - Reset Reader 
        aCommands[1].CMD := eAxo_IID_COMMANDS#eWriteConfig;
        aCommands[1].CONFIG := BYTE#16#03;
        aCommands[1].LEN_DATA := WORD#16#10;

        // Command 2 - Readerstatus RF300 
        aCommands[2].CMD := eAxo_IID_COMMANDS#eReaderStatus;
        aCommands[2].ATTRIBUTES := BYTE#16#81;

        // Command 3 - Transponderstatus RF300 
        aCommands[3].CMD := eAxo_IID_COMMANDS#eTagStatus;
        aCommands[3].ATTRIBUTES := BYTE#16#04;

        // Command 4 - Read 10 Byte 
        aCommands[4].CMD := eAxo_IID_COMMANDS#eRead;
        aCommands[4].LEN_DATA := WORD#16#A;
        aCommands[4].ADDR_TAG := DWORD#16#0;
        aCommands[4].OFFSETBUFFER := UINT#0; 

        // Command 5 - Write 10 Byte 
        aCommands[5].CMD := eAxo_IID_COMMANDS#eWrite;
        aCommands[5].LEN_DATA := WORD#16#A;
        aCommands[5].ADDR_TAG := DWORD#16#0;
        aCommands[5].OFFSETBUFFER := UINT#0; 

        // Command 6 - Read UID 
        aCommands[6].CMD := eAxo_IID_COMMANDS#eRead;
        aCommands[6].LEN_DATA := WORD#16#8;
        aCommands[6].ADDR_TAG := DWORD#16#FFF0;
        aCommands[6].OFFSETBUFFER := UINT#0; 

        //===================================================================== 
        //Define reset data for RF300 Reader and RF300 transponder 
        //=====================================================================
        aDataReset[1]  := BYTE#16#4;
        aDataReset[2]  := BYTE#16#0;
        aDataReset[3]  := BYTE#16#0;
        aDataReset[4]  := BYTE#16#0;
        aDataReset[5]  := BYTE#16#0;
        aDataReset[6]  := BYTE#16#A;
        aDataReset[7]  := BYTE#16#0;
        aDataReset[8]  := BYTE#16#0;
        aDataReset[9]  := BYTE#16#0;
        aDataReset[10] := BYTE#16#25;
        aDataReset[11] := BYTE#16#2;
        aDataReset[12] := BYTE#16#0;
        aDataReset[13] := BYTE#16#0;
        aDataReset[14] := BYTE#16#1;
        aDataReset[15] := BYTE#16#0;
        aDataReset[16] := BYTE#16#0;

        //===================================================================== 
        //copy reset data when a reset command is executed 
        //=====================================================================


        IF rf186_1_init AND NOT	rf186_1_init_PV AND rf186_1_nCmdsel = UINT#1 THEN 	
            // MEMCPY(destAddr := ADR(aDataTX[1]), srcAddr := ADR(aDataReset[1]), n := 16);	
            FOR i := 1 TO 16 DO
                aDataTX[i] := aDataReset[i];
            END_FOR;
        END_IF;

        //===================================================================== 
        //clear receiveData buffer before executing command) 
        //=====================================================================
        IF rf186_1_execute AND NOT	rf186_1_execute_PV THEN 	
            // MEMSET(destAddr := ADR(aDataTx[1]),fillByte := 16#00,n := 2000);
            FOR i := 1 TO 2000 DO
                aDataTX[i] := BYTE#0;
            END_FOR;
        END_IF;

        //===================================================================== 
        //call Ident_Profile 
        //=====================================================================
        rf186_1.Run(bExecute    :=  rf186_1_execute,
                    bInit       :=  rf186_1_init,
                    nCmdsel     :=  rf186_1_nCmdsel,
                    stHwConnect :=  Connect_RF188C_CH01, 
                    aCmdRef     :=  aCommands,
                    aTxRef      :=  aDataTx,
                    aRxRef      :=  aDataRx);

        rf186_1_execute_PV  :=  rf186_1_execute;
        rf186_1_init_PV :=  rf186_1_init;                    
        
        IF(_manualControl) THEN
            ;
        END_IF;    
    END_METHOD
END_CLASS
