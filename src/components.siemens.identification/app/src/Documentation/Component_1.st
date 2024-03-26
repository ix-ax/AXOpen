USING AXOpen.Core;
USING AXOpen.Components.SIEM.Identification;
USING System.Strings;

{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        IdentProfileReader : AXOpen.Components.SIEM.Identification.Axo_IdentDevice;          
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC         
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
        //Data used for reset sequence
        //The reader must be reseted after each PLC startup
        //For different reader type/family change the reset data according to manual
        //Manual Entry ID: 109793329, Entry date: 02/18/2021
        //Document ID number:	C79000-G8976-C387-06
        //Link: https://cache.industry.siemens.com/dl/files/329/109793329/att_1054102/v1/FH_Ident-Profil_76_en-US.pdf
        //Chapter: 3.5 Programming the Ident profile
        //Page: 80+
        {#ix-attr:[CompilerOmits()]} 
        ExampleReader_hardwareConfig: ARRAY[0..15] OF BYTE := [BYTE#16#04,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#0A,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#25,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#01,BYTE#16#00,BYTE#16#01]; //default data for RF260R 
        DoNotRun    :   BOOL    :=  FALSE;
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        IF DoNotRun THEN
            RETURN;
        END_IF;

        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            IdentProfileReader.ActivateManualControl();
        END_IF;

        //<Initialization>        
        IdentProfileReader.Config.HardwareConfig.Data := ExampleReader_hardwareConfig;


        //For different reader type/family change the CM_CHANNEL, API, SLOT, SUB_SLOT according to application example
        //Application example Entry ID: 109807653, Entry date: 04/21/2022
        //Link: https://cache.industry.siemens.com/dl/files/653/109807653/att_1101693/v2/109807653_Simatic_Ident_Profinet_Beckhoff_DOC_V10_en.pdf
        //Chapter: 2.3.6.2 CM_CHANNEL, API, SLOT, SUB_SLOT
        //Page: 18
        //  Commented out due to issue with downloading when RF186C is used and configered using HWC
        // IdentProfileReader.Run(parent      :=  THIS,
        //             HW_ID       :=  HwIdentifiers#rf186c_Reader_1__Reader__HwID,
        //             API         :=  DWORD#16#5B00,	
        //             SLOT 		:=  WORD#2,
        //             SUB_SLOT 	:=  WORD#1,
        //             CM_CHANNEL  :=  UINT#1);
        
        //</Initialization>
        
       THIS.UseInSequencer();

    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer   :   AxoSequencer;       
        Steps       :   ARRAY[0..9] OF AXOpen.Core.AxoStep;
        WriteData   :   STRING  :=  'Abcdefgh65421';
        ReadData    :   STRING;
    END_VAR

    
    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
        
        IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
            ActivateManualControl := FALSE;
            IdentProfileReader.Restore();
            Sequencer.MoveNext();      
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Reset reader')) THEN
            IF(IdentProfileReader.ResetReader().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[2].Execute(Sequencer, 'Write')) THEN
            IF(IdentProfileReader.Write(WriteData,DWORD#0,UINT#0).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[3].Execute(Sequencer, 'Read')) THEN
            IF(IdentProfileReader.Read(DWORD#0,TO_UINT(LengthOf(WriteData)),UINT#0,ReadData).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[4].Execute(Sequencer, 'Compare')) THEN
            IF(ReadData=WriteData) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[5].Execute(Sequencer, 'SoftReset')) THEN
            IF(IdentProfileReader.SoftReset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;      
        END_IF;       

        IF(Steps[6].Execute(Sequencer, 'Reset reader')) THEN
            IF(IdentProfileReader.ResetReader().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;   
        
        IF(Steps[7].Execute(Sequencer, 'Restore')) THEN
            ActivateManualControl := FALSE;
            IdentProfileReader.Restore();
            Sequencer.MoveNext();      
        END_IF;

        IF(Steps[8].Execute(Sequencer, 'SEQUENCE DONE')) THEN
            Sequencer.CompleteSequence();          
        END_IF;

    END_METHOD

    //</Usage>
END_CLASS
