USING AXOpen.Core;
USING AXOpen.Components.SIEM.Identification;
USING System.Strings;

{S7.extern=ReadWrite}
CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        IOlinkReader : AXOpen.Components.SIEM.Identification.AxoIOLink_RF200Device;          
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC         
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            IOlinkReader.ActivateManualControl();
        END_IF;

        //<Initialization>        

        IOlinkReader.Run(   parent      :=  THIS,
                            HW_ID       :=  WORD#274,//HwIdentifiers#et200sp_CM_4xIO_Link_V2_2_144I_128O_1_CM_4xIO_Link_V2_2_144I_128O_HwID, 
                            portAddr    :=  INT#0,
                            version     :=  USINT#11);
        
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

        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
        
        IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
            ActivateManualControl := FALSE;
            IOlinkReader.Restore();
            Sequencer.MoveNext();      
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
            ActivateManualControl := FALSE;
            IOlinkReader.Restore();
            Sequencer.MoveNext();      
        END_IF;

        IF(Steps[5].Execute(Sequencer, 'SEQUENCE DONE')) THEN
            Sequencer.CompleteSequence();          
        END_IF;

    END_METHOD
    
    //</Usage>
END_CLASS
