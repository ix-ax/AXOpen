USING AXOpen.Core;
USING  AXOpen.Components.SIEM.Identification;
USING System.Serialization;
USING System.Strings;


{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC                
        IOlinkReader : AXOpen.Components.SIEM.Identification.AxoIOLink_RF200Device;          
        IdentProfileReader : AXOpen.Components.SIEM.Identification.Axo_IdentDevice;        
        Mode    :   UINT;  
        Start   :   ULINT;
        Stop   :   ULINT;
        Duration   :   ULINT;
        NumberOfCycles  : UINT  := UINT#10;
        CurrentNumberOfCycles   : UINT;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        IF Mode = UINT#0 THEN
            RETURN;
        END_IF;
        IF Mode = UINT#1 THEN
                IOlinkReader.Run(  parent      :=  THIS,
                                    HW_ID       :=  HwIdentifiers#et200sp_CM_4xIO_Link_V2_2_144I_128O_1_CM_4xIO_Link_V2_2_144I_128O_HwID, 
                                    portAddr    :=  INT#0,
                                    version     :=  USINT#11);

                                    THIS.IolinkSequence();
        END_IF;

        IF Mode = UINT#2 THEN
            IdentProfileReader.Run(parent      :=  THIS,
                                    HW_ID       :=  HwIdentifiers#rf186c_Reader_1__Reader__HwID,
                                    API         :=  DWORD#16#5B00,	
                                    SLOT 		:=  WORD#2,
                                    SUB_SLOT 	:=  WORD#1,
                                    CM_CHANNEL  :=  UINT#1);

            THIS.IdentProfileSequence();
        END_IF;

    END_METHOD
 
    VAR PUBLIC                       
        Sequencer   :   AxoSequencer;       
        Steps       :   ARRAY[0..10] OF AXOpen.Core.AxoStep;
        WriteData   :   STRING  :=  'My_very_first_attempt_to_use_RF2xx_via_IO-Link_interface';
        ReadData    :   STRING;
    END_VAR

    METHOD PRIVATE IolinkSequence   
        //6ES7 155-6AU01-0BN0 + 6ES7 137-6BD00-0BA0 + 6GT2 821-4BC32 
        //  1ms task, VI11, 32bytes in /32 bytes out +PQI
        // 100 RW cycles of 56 chcracter long string
        // 39850 ms

        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
        
        IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
            IOlinkReader.Restore();
            Sequencer.MoveNext();     
            CurrentNumberOfCycles := UINT#0;
            Start   :=  THIS.OpenCycleCount();
            Stop    :=  ULINT#0;
            Duration :=  ULINT#0;
            WriteData  :=  'My_very_first_attempt_to_use_RF2xx_via_IO-Link_interface';
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Write Tag')) THEN
            IF(IOlinkReader.WriteTag(WriteData,WORD#0).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[2].Execute(Sequencer, 'Read Tag')) THEN
            IF(IOlinkReader.ReadTag(WORD#0,TO_WORD(LengthOf(WriteData)),ReadData).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[3].Execute(Sequencer, 'Compare')) THEN
            IF(ReadData=WriteData) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[4].Execute(Sequencer, 'Restore')) THEN
            CurrentNumberOfCycles := CurrentNumberOfCycles + UINT#1;
            Stop   :=  THIS.OpenCycleCount();
            Duration   := Stop - Start;

            IF CurrentNumberOfCycles >= NumberOfCycles THEN
                Sequencer.MoveNext();     
            ELSE
                Sequencer.RequestStep(Steps[1]) ;
            END_IF; 
        END_IF;

        IF(Steps[5].Execute(Sequencer, 'Restore')) THEN
            IOlinkReader.Restore();
            Sequencer.MoveNext();      
        END_IF;

        IF(Steps[6].Execute(Sequencer, 'SEQUENCE DONE')) THEN
            Sequencer.CompleteSequence();          
        END_IF;

    END_METHOD
    

    METHOD PRIVATE IdentProfileSequence   
        //  6GT2 002-0JE20 + RF260R
        //  1ms task
        // 100 RW cycles of 56 chcracter long string
        // 61350 ms at 19.2kBd
        // 19950 ms at 57.6kBd 
        // at 115.2 kBd does not work, NFI wfy

        
        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
        
        IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
            IdentProfileReader.Restore();
            Sequencer.MoveNext();      
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Reset reader')) THEN
            IF(IdentProfileReader.ResetReader().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[2].Execute(Sequencer, 'Restore')) THEN
            IdentProfileReader.Restore();
            Sequencer.MoveNext();     
            CurrentNumberOfCycles := UINT#0;
            Start       :=  THIS.OpenCycleCount();
            Stop        :=  ULINT#0;
            Duration    :=  ULINT#0;
            WriteData  :=  'My_very_first_attempt_to_use_RF2xx_via_Ident_Profile1234';
        END_IF;

        IF(Steps[3].Execute(Sequencer, 'Write')) THEN
            IF(IdentProfileReader.Write(WriteData,WORD#0).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[4].Execute(Sequencer, 'Read')) THEN
            IF(IdentProfileReader.Read(DWORD#0,TO_UINT(LengthOf(WriteData)),UINT#0,ReadData).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[5].Execute(Sequencer, 'Compare')) THEN
            IF(ReadData=WriteData) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[6].Execute(Sequencer, 'Restore')) THEN
            CurrentNumberOfCycles := CurrentNumberOfCycles + UINT#1;
            Stop   :=  THIS.OpenCycleCount();
            Duration   := Stop - Start;

            IF CurrentNumberOfCycles >= NumberOfCycles THEN
                Sequencer.MoveNext();     
            ELSE
                Sequencer.RequestStep(Steps[3]) ;
            END_IF; 
        END_IF;

        IF(Steps[7].Execute(Sequencer, 'Restore')) THEN
            IOlinkReader.Restore();
            Sequencer.MoveNext();      
        END_IF;

        IF(Steps[8].Execute(Sequencer, 'SEQUENCE DONE')) THEN
            Sequencer.CompleteSequence();          
        END_IF;

    END_METHOD

END_CLASS
