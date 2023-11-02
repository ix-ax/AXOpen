
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
            TechnologySettings : REF_TO TechnologyDataManager;
            EntireProcessSettings    :REF_TO axosimple.ProcessData;
            EntireProcessData    :REF_TO axosimple.ProcessData;
            _currentId : STRING;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _components         : REF_TO Components;
                _processData        : REF_TO ProcessDataManager;
                _technologySettings : REF_TO TechnologyDataManager;
                _entireProcessSettings    :REF_TO axosimple.ProcessData;
                _entireProcessData    :REF_TO axosimple.ProcessData;
                _parent             : IAxoObject;
            END_VAR  

            Components      := _components;
            ProcessData     := _processData;
            TechnologySettings  := _technologySettings;
            EntireProcessSettings     := _entireProcessSettings;
            EntireProcessData     := _entireProcessData;
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

            
            IF (Steps[0].Execute(THIS, TRUE, '<#COPY ENTIRE PROCESS SETTINGS#>')) THEN
                //-------------------------------------------------------
                _currentId := 'newProducedPart';
                THIS.MoveNext(); 

                EntireProcessData^ := EntireProcessSettings^; // copy entire data for new part
                ProcessData^.Shared.Entity := EntireProcessData^.Entity.Entity; // copy shared entity header data to local manager
                //ProcessData^.DataManger.Payload := EntireProcessData^.StarterUnitTemplate.PayLoad;     // copy station data to lacal data manager
                //-------------------------------------------------------
            END_IF;

            IF (Steps[1].Execute(THIS, TRUE, '<#CREATE ENTIRE DATA#>')) THEN
                //-------------------------------------------------------
                IF (EntireProcessData^.CreateOrUpdate(_currentId).IsDone()) THEN 
                    THIS.MoveNext(); 
                END_IF;
                //-------------------------------------------------------
            END_IF;
            
            IF (Steps[2].Execute(THIS, TRUE, '<#DO SOMETHING#>')) THEN
                //-------------------------------------------------------                
                IF CurrentStep.Duration > TIME#2s THEN                         
                    THIS.MoveNext();
                END_IF;                
                //-------------------------------------------------------
            END_IF;


            IF (Steps[20].Execute(THIS, TRUE, '<#UPDATE DATA#>')) THEN
                //-------------------------------------------------------
                IF (ProcessData^.Update(_currentId).IsDone()) THEN // UPDATE LOCAL DATA 
                    THIS.MoveNext(); 
                END_IF;
                //-------------------------------------------------------
            END_IF;    
                      
            // This will close the sequence and will return to the first step.
            THIS.Close(Steps[25]);
        END_METHOD
    END_CLASS

END_NAMESPACE
    