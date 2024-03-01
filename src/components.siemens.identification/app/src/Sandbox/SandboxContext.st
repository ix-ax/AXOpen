USING  AXOpen.Components.SIEM.Identification;
USING System.Serialization;
USING System.Strings;


{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        run_1   :   BOOL;
        run_2   :   BOOL;
    END_VAR

    VAR PUBLIC
        _manualControl             :   BOOL;
        {#ix-attr:[CompilerOmits()]}
        _rf186_1_hardwareConfig: ARRAY[1..16] OF BYTE := [BYTE#16#04,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#0A,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#25,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#01,BYTE#16#00,BYTE#16#01]; //default data for RF260R 
        
        rf186_1 : AXOpen.Components.SIEM.Identification.Axo_IdentDevice;          
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        IF run_1 AND NOT run_2 THEN
            rf186_1.Config.HardwareConfig := _rf186_1_hardwareConfig;

            rf186_1.Run(parent      :=  THIS,
                        HW_ID       :=  HwIdentifiers#rf186c_Reader_1,
                        API         :=  DWORD#16#5B00,	
                        SLOT 		:=  WORD#2,
                        SUB_SLOT 	:=  WORD#1,
                        CM_CHANNEL  :=  UINT#1);

            IF(_manualControl) THEN
                rf186_1.ActivateManualControl();
            END_IF;   
        END_IF;   

        IF NOT run_1 and run_2 THEN
            THIS.Main2();
        END_IF;
    END_METHOD

    VAR PUBLIC
        rf186_2_init            :   BOOL;
        rf186_2_init_PV         :   BOOL;	
        rf186_2_execute         :   BOOL;	
        rf186_2_execute_PV      :   BOOL;	
        rf186_2_repeatCommand   :   BOOL;
        rf186_2_softReset       :   BOOL;
        rf186_2_cmdsel          :   UINT;
        rf186_2_done            :   BOOL;
        rf186_2_busy            :   BOOL;
        rf186_2_error           :   BOOL;
        rf186_2_warning         :   BOOL;
        rf186_2_status          :   DWORD;
        rf186_2_write           :   STRING;
        rf186_2_read            :   STRING;
        
        rf186_2 : AXOpen.Components.SIEM.Identification.Axo_IdentProfile;          
        Connect_RF188C_CH01: Axo_IID_HW_CONNECT;
        {#ix-attr:[CompilerOmits()]} 
        aCommands: ARRAY[1..10] OF Axo_IID_CMD_STRUCT;
        {#ix-attr:[CompilerOmits()]} 
        aDataReset: ARRAY[1..16] OF BYTE;
        {#ix-attr:[CompilerOmits()]} 
        aDataRx: ARRAY[1..2000] OF BYTE;
        {#ix-attr:[CompilerOmits()]} 
        aDataTx: ARRAY[1..2000] OF BYTE;
        Command: Axo_IID_CMD_STRUCT;

    END_VAR

    METHOD PROTECTED Main2

        VAR       
            i                   : INT;
            _data       :   ARRAY[0..255] OF BYTE;
        END_VAR

        //===================================================================== 
        //Define profinet parameters 
        //=====================================================================
        Connect_RF188C_CH01.HW_ID       := HwIdentifiers#rf186c_Reader_1;   //HW IO of the reader  !!! not the CM
        Connect_RF188C_CH01.CM_CHANNEL  := UINT#1;
        Connect_RF188C_CH01.API         := DWORD#16#5B00;
        Connect_RF188C_CH01.SLOT        := WORD#2;       //2-for channel 1, 3-channel 2
        Connect_RF188C_CH01.SUB_SLOT    := WORD#1;
        //===================================================================== 
        //Define iid aCommands 
        //=====================================================================
        // Command 1 - Reset Reader 
        aCommands[1].CMD := eAxo_IID_COMMANDS#eWriteConfig;
        aCommands[1].CONFIG := BYTE#16#03;
        aCommands[1].LEN_DATA := WORD#16#10;

        // Command 2 - Readerstatus RF200 
        aCommands[2].CMD := eAxo_IID_COMMANDS#eReaderStatus;
        aCommands[2].ATTRIBUTES := BYTE#16#81;

        // Command 3 - Transponderstatus RF200 
        aCommands[3].CMD := eAxo_IID_COMMANDS#eTagStatus;
        aCommands[3].ATTRIBUTES := BYTE#16#83;

        // Command 4 - Read 10 Byte 
        aCommands[4].CMD := eAxo_IID_COMMANDS#eRead;
        // aCommands[4].LEN_DATA := WORD#16#A0;
        aCommands[4].ADDR_TAG := DWORD#16#0;
        aCommands[4].OFFSETBUFFER := UINT#0; 

        // Command 5 - Write 10 Byte 
        aCommands[5].CMD := eAxo_IID_COMMANDS#eWrite;
        // aCommands[5].LEN_DATA := WORD#16#A;
        aCommands[5].ADDR_TAG := DWORD#16#0;
        aCommands[5].OFFSETBUFFER := UINT#0; 

        // Command 6 - Read UID 
        aCommands[6].CMD := eAxo_IID_COMMANDS#eRead;
        aCommands[6].LEN_DATA := WORD#16#8;
        aCommands[6].ADDR_TAG := DWORD#16#FFF0;
        aCommands[6].OFFSETBUFFER := UINT#0; 

        //===================================================================== 
        //Define reset data for RF200 Reader and RF200 transponder 
        //=====================================================================
        aDataReset[1]  := BYTE#16#04;
        aDataReset[2]  := BYTE#16#00;
        aDataReset[3]  := BYTE#16#00;
        aDataReset[4]  := BYTE#16#00;
        aDataReset[5]  := BYTE#16#00;
        aDataReset[6]  := BYTE#16#0A;
        aDataReset[7]  := BYTE#16#00;
        aDataReset[8]  := BYTE#16#00;
        aDataReset[9]  := BYTE#16#00;
        aDataReset[10] := BYTE#16#25;
        aDataReset[11] := BYTE#16#00;
        aDataReset[12] := BYTE#16#00;
        aDataReset[13] := BYTE#16#00;
        aDataReset[14] := BYTE#16#01;
        aDataReset[15] := BYTE#16#00;
        aDataReset[16] := BYTE#16#01;

        //===================================================================== 
        //copy reset data when a reset command is executed 
        //=====================================================================
        IF (*rf186_1_init AND NOT	rf186_1_init_PV AND *) rf186_2_cmdsel = UINT#1 THEN 	
            FOR i := 1 TO 16 DO
                aDataTX[i] := aDataReset[i];
            END_FOR;
        END_IF;

        //===================================================================== 
        //clear receiveData buffer before executing command) 
        //=====================================================================
        IF rf186_2_execute AND NOT	rf186_2_execute_PV THEN 	
            FOR i := 1 TO 2000 DO
                aDataRX[i] := BYTE#0;
            END_FOR;
        END_IF;

        //===================================================================== 
        //copy read data when a read command is selected 
        //=====================================================================
        IF rf186_2_cmdsel = UINT#4 THEN 	
            Deserialize(UINT#1, aDataRX, rf186_2_read);
            aCommands[4].LEN_DATA :=TO_WORD(LengthOf(rf186_2_write)+INT#1); // as the actual length of string needs to be read as well
            IF aCommands[4].LEN_DATA <= WORD#1 THEN aCommands[4].LEN_DATA := WORD#40; END_IF;
        END_IF;

        //===================================================================== 
        //copy UID data when a UID read command is selected 
        //=====================================================================
        IF rf186_2_cmdsel = UINT#6 THEN 	
            _data[0] :=TO_BYTE(INT#8);
            FOR i := INT#1 TO INT#8 DO
                _data[i] := aDataRX[i];
            END_FOR;
            Deserialize(UINT#1, _data, rf186_2_read);
        END_IF;

        //===================================================================== 
        //copy write data when a write command is selected 
        //=====================================================================
        IF rf186_2_cmdsel = UINT#5 THEN 	
            Serialize(UINT#1, rf186_2_write, aDataTX);
            aCommands[5].LEN_DATA :=TO_WORD(LengthOf(rf186_2_write)+INT#1); // as the actual length of string needs to be sent as well
        END_IF;

        //===================================================================== 
        //call Ident_Profile 
        //=====================================================================
        rf186_2_execute_PV  :=  rf186_2_execute;
        rf186_2_init_PV :=  rf186_2_init;     
        IF rf186_2_cmdsel >= UINT#1 AND rf186_2_cmdsel <= UINT#10 THEN
            Command :=  aCommands[rf186_2_cmdsel];
        END_IF;
        
        rf186_2.Run(Execute         :=  rf186_2_execute,
                    RepeatCommand   :=  rf186_2_repeatCommand,
                    SoftReset       :=  rf186_2_softReset,
                    Init            :=  rf186_2_init,
                    refHwConnect    :=  REF( Connect_RF188C_CH01), 
                    refCmd          :=  REF(Command),   
                    refTx           :=  REF(aDataTx),
                    refRx           :=  REF(aDataRx),
                    Done            =>  rf186_2_done,
                    Busy            =>  rf186_2_busy,
                    Error           =>  rf186_2_error,
                    Warning         =>  rf186_2_warning,
                    Status          =>  rf186_2_status);
             
    END_METHOD

END_CLASS



