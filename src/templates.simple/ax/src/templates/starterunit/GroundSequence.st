NAMESPACE axosimple.StarterUnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
    
    ///<summary>
    /// Provides ground mode sequence.
    ///</summary>
    {#ix-set:AttributeName = "<#GROUND#>"}
    CLASS PUBLIC GroundSequence
        EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            Steps : ARRAY[0..20] OF AxoStep;      
            MoveToWork : AxoTask;
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
        METHOD PROTECTED OVERRIDE Main
            // IF (Components = NULL OR ProcessData = NULL) THEN
            //     RETURN;
            // END_IF;
            // This sequecner executes the steps in cycles from top to bottom
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.
            // This sets the sequence to run once (top-botton) and stops with done after closing.
            THIS.SequenceMode := eAxoSequenceMode#RunOnce;

            // This is more verbose but also more versatile way of executing step logic.
            IF (Steps[0].Execute(THIS, TRUE, '<#GET ID#>')) THEN
            //------------------------------------------------------- 
                    _currentId := '1'; 
                    THIS.MoveNext(); 
            //-------------------------------------------------------
            END_IF;
            
            IF (Steps[1].Execute(THIS, TRUE, '<#GET DATA#>')) THEN
            //-------------------------------------------------------                    
                IF(ProcessData^.CreateOrUpdate(_currentId).IsDone()) THEN
                    THIS.MoveNext();                                   
                END_IF;    
            //-------------------------------------------------------
            END_IF;

            IF (Steps[2].Execute(THIS, TRUE, '<#DO SOMETHING#>')) THEN
                //-------------------------------------------------------                         
                    THIS.MoveNext();
                //-------------------------------------------------------
            END_IF;
           
            IF (Steps[19].Execute(THIS, TRUE, '<#SAVE DATA#>')) THEN
                //-------------------------------------------------------
                                        
                    IF(ProcessData^.Update(_currentId).IsDone()) THEN
                        THIS.MoveNext();                                   
                    END_IF;    
                //-------------------------------------------------------
            END_IF;
           
            // This will close the sequence and will return to the first step.
            THIS.Close(Steps[20]);
        END_METHOD
    END_CLASS
END_NAMESPACE    