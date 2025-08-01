USING AXOpen.Core;
USING AXOpen.Components.Siem.Identification;
USING System.Strings;

NAMESPACE AXOpen.Components.Siem.Identification
    {S7.extern=ReadWrite}
    CLASS Component_4 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            RF340R : AXOpen.Components.Siem.Identification.AxoSimaticIdentCyclic;     
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC         
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;         
            DataBuffer : ARRAY[0..127] OF BYTE;         
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    

            SUPER.Run(parent);

            IF ActivateManualControl THEN
                RF340R.ActivateManualControl();
            END_IF;

            //<Initialization>        

            RF340R.Run( parent      :=  THIS,
                        hwID        :=  HwIdentifiers#rf186c_cyc_HwID,
                        Port        :=  eAxoSimaticIdentCyclic_Port#X22,
                        DataBuffer  :=  DataBuffer);
            
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer   :   AxoSequencer;       
            Steps       :   ARRAY[0..10] OF AXOpen.Core.AxoStep;
            WriteData   :   STRING  :=  'My_very_first_attempt_to_use_RF2xx_via_IO-Link_interface';
            ReadData    :   STRING;
        END_VAR

        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            
            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                ActivateManualControl := FALSE;
                RF340R.Restore();
                Sequencer.MoveNext();      
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Write Tag')) THEN
                IF(RF340R.WriteTagField((*WriteData,WORD#0*)).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[2].Execute(Sequencer, 'Read Tag')) THEN
                IF(RF340R.ReadTagField((*WORD#0,TO_WORD(LengthOf(WriteData)),ReadData*)).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'Compare')) THEN
                IF(ReadData=WriteData) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[4].Execute(Sequencer, 'Restore')) THEN
                ActivateManualControl := FALSE;
                RF340R.Restore();
                Sequencer.MoveNext();      
            END_IF;

            IF(Steps[5].Execute(Sequencer, 'SEQUENCE DONE')) THEN
                Sequencer.CompleteSequence();          
            END_IF;

        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE