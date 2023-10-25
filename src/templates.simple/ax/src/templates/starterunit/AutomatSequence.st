
NAMESPACE axosimple.StarterUnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
    
    ///<summary>
    /// Provides automatic mode sequence.
    ///</summary>
    {#ix-set:AttributeName = "<#AUTOMAT#>"}
    CLASS PUBLIC AutomatSequence
        EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            Steps : ARRAY[0..25] OF AxoStep;           
        END_VAR
        VAR PRIVATE
            Components : REF_TO Components;
            ProcessData : REF_TO ProcessDataManager; 
            _currentId : STRING;           
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _components : REF_TO Components;               
                _processData : REF_TO ProcessDataManager;
                _parent : IAxoObject;
            END_VAR
            Components := _components;
            ProcessData := _processData;
            SUPER.Run(_parent);
        END_METHOD
        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>

        METHOD OVERRIDE Main
            IF (Components = NULL OR ProcessData = NULL) THEN
                RETURN;
            END_IF;
            // This sequecner executes the steps in cycles from top to bottom
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.
            // This sets the sequence to run in cycles (top-botton-top and again).
            THIS.SequenceMode := eAxoSequenceMode#Cyclic;

            
            IF (Steps[0].Execute(THIS, TRUE, '<#LOAD PROCESS SETTINGS#>')) THEN
            //-------------------------------------------------------
                IF(ProcessData^.CreateOrUpdate('1').IsDone()) THEN
                    THIS.MoveNext();
                END_IF;    
            //-------------------------------------------------------
            END_IF;
                       
            IF(Steps[1].Execute(THIS, TRUE, 'RETRIEVE DATA')) THEN
            //-------------------------------------------------------
                IF(ProcessData^.Create(_currentId).IsDone()) THEN
                    THIS.MoveNext();
                END_IF;     
            //-------------------------------------------------------
            END_IF;    
                      
            // This will close the sequence and will return to the first step.
            THIS.Close(Steps[25]);
        END_METHOD
    END_CLASS

END_NAMESPACE
    