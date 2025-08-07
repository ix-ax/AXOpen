USING AXOpen.Core;
USING AXOpen.Components.Siem.Identification;
USING System.Strings;
USING System.Serialization;

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
            TestTagUID : ARRAY[0..7] OF BYTE := [BYTE#224,BYTE#8,BYTE#1,BYTE#215,BYTE#229,BYTE#70,BYTE#94,BYTE#82];         
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
            Steps       :   ARRAY[0..11] OF AXOpen.Core.AxoStep;
            WriteData   :   STRING  :=  'My_very_first_attempt_to_use_RF340Rwith_RF186C_using_cyclic_communication_tag_field_10lenght100bytes';
            ReadData    :   STRING;
        END_VAR

        METHOD PRIVATE UseInSequencer   
            VAR
                _index      :   UINT;
                _is_equal   :   BOOL;
                _data       :   ARRAY[0..128] OF BYTE;     
                _offset     :   UDINT;    
            END_VAR
            
            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            
            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                ActivateManualControl := FALSE;
                RF340R.Restore();
                Sequencer.MoveNext();      
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Reset')) THEN
                IF(RF340R.Reset().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       
            
            IF(Steps[2].Execute(Sequencer, 'ReadUID')) THEN
                IF(RF340R.ReadUID().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'Compare UID')) THEN
                _is_equal := TRUE;
                FOR _index := UINT#0 TO UINT#7 BY UINT#1 DO
                    IF DataBuffer[_index] <> TestTagUID[_index] THEN
                        _is_equal := FALSE;
                    END_IF;    
                END_FOR;
                IF(_is_equal) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;          

            //  Tag with ID 10 and length 100 has to be already defined using WBM
            IF(Steps[4].Execute(Sequencer, 'WriteTagField: 10, length 100')) THEN
                //*******************************************************************************************//
                // Serialization of the string to the array of bytes to get out its length at the _data[0]
                    _offset := Serialize(UDINT#0, WriteData, _data);
                    FOR _index := UINT#0 TO TO_UINT(_offset) - UINT#1 BY UINT#1 DO
                        DataBuffer[_index] := _data[_index + UINT#1];
                    END_FOR;
                //*******************************************************************************************//
                IF(RF340R.WriteTagField(TagField := UINT#10, TagFieldLength := UINT#100).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            //  Tag with ID 10 and length 100 has to be already defined using WBM
            IF(Steps[5].Execute(Sequencer, 'ReadTagField: 10')) THEN
                IF(RF340R.ReadTagField(TagField := UINT#10).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF; 
            END_IF;       

            IF(Steps[6].Execute(Sequencer, 'Compare TagField')) THEN
                //*******************************************************************************************//
                // Deserialization of the string from the array of bytes to get its length at the _data[0]
                _data[0] := BYTE#100;
                FOR _index := UINT#0 TO UINT#127 BY UINT#1 DO
                    _data[_index + UINT#1] := DataBuffer[_index];
                END_FOR;
                
                _offset := Deserialize(UDINT#0,_data, ReadData );
                //*******************************************************************************************//
                IF(ReadData = WriteData) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[7].Execute(Sequencer, 'Write: address: 10, length 8')) THEN
                DataBuffer[0] := BYTE#10;
                DataBuffer[1] := BYTE#20;
                DataBuffer[2] := BYTE#30;
                DataBuffer[3] := BYTE#40;
                DataBuffer[4] := BYTE#50;
                DataBuffer[5] := BYTE#60;
                DataBuffer[6] := BYTE#70;
                DataBuffer[7] := BYTE#80;
                IF(RF340R.Write(Address := UDINT#10, Length := UINT#8).IsDone()) THEN                
                    DataBuffer[0] := BYTE#0;
                    DataBuffer[1] := BYTE#0;
                    DataBuffer[2] := BYTE#0;
                    DataBuffer[3] := BYTE#0;
                    DataBuffer[4] := BYTE#0;
                    DataBuffer[5] := BYTE#0;
                    DataBuffer[6] := BYTE#0;
                    DataBuffer[7] := BYTE#0;
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;      

            IF(Steps[8].Execute(Sequencer, 'Read: address: 10, length 8')) THEN
                IF(RF340R.Read(Address := UDINT#10, Length := UINT#8).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;      

            IF(Steps[9].Execute(Sequencer, 'Compare')) THEN
                _is_equal :=    DataBuffer[0] = BYTE#10 AND
                                DataBuffer[1] = BYTE#20 AND
                                DataBuffer[2] = BYTE#30 AND
                                DataBuffer[3] = BYTE#40 AND
                                DataBuffer[4] = BYTE#50 AND
                                DataBuffer[5] = BYTE#60 AND
                                DataBuffer[6] = BYTE#70 AND
                                DataBuffer[7] = BYTE#80;
                IF _is_equal THEN
                    Sequencer.MoveNext();      
                END_IF;    
            END_IF;      

            IF(Steps[10].Execute(Sequencer, 'Restore')) THEN
                ActivateManualControl := FALSE;
                RF340R.Restore();
                Sequencer.MoveNext();      
            END_IF;

            IF(Steps[11].Execute(Sequencer, 'SEQUENCE DONE')) THEN
                Sequencer.CompleteSequence();          
            END_IF;
        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE