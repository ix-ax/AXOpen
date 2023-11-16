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
            Objs : REF_TO UnitObjects;
            Components : REF_TO Components;
            ProcessData : REF_TO ProcessDataManager;
            ProcessSettings : REF_TO FragmentProcessDataManger;
            TechnologySettings : REF_TO TechnologyDataManager;
            PersistentSettings : REF_TO AxoDataPersistentExchange;

            _currentId : STRING;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _parent : IAxoObject;
                _unitObjects : REF_TO UnitObjects;
            END_VAR     

            IF Objs = NULL THEN 
                Objs := _unitObjects;
                
                Components := Ref(Objs^.Components);
                ProcessData := Objs^.ProcessData;
                ProcessSettings := Objs^.ProcessSettings;
                TechnologySettings := Objs^.TechnologySettings;
                PersistentSettings := Objs^.Global^.PersistentData;
            END_IF;

            SUPER.Run(_parent);
        END_METHOD

        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>
        METHOD PROTECTED OVERRIDE Main
            VAR
                taskState :IAxoTaskState;
            END_VAR;
            // IF (Components = NULL OR ProcessData = NULL) THEN
            //     RETURN;
            // END_IF;
            // This sequecner executes the steps in cycles from top to bottom
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.
            // This sets the sequence to run once (top-botton) and stops with done after closing.
            THIS.SequenceMode := eAxoSequenceMode#RunOnce;

            // This is more verbose but also more versatile way of executing step logic.
            IF (Steps[0].Execute(THIS, TRUE, '<#RESTORE#>')) THEN
                //------------------------------------------------------- 
                PersistentSettings^.Restore(); 
                ProcessData^.Restore();
                
                ProcessData^.Shared.Entity.WasReset := true;
                _currentId := 'lastPartId'; // just for simulation
                //-------------------------------------------------------
            END_IF;

            IF (Steps[1].Execute(THIS, TRUE, '<#CHECK IF EXIST PERSISTENT SETTINGS#>')) THEN
                //------------------------------------------------------- 
                IF(PersistentSettings^.EntityExist('default').IsDone()) THEN
                    IF PersistentSettings^.Operation._exist THEN 
                        THIS.RequestStep(Steps[3]);
                    ELSE
                        THIS.MoveNext(); 
                    END_IF;
                END_IF;    
                //-------------------------------------------------------
            END_IF;

            IF (Steps[2].Execute(THIS, TRUE, '<#UPDATE PERSISTENT SETTINGS#>')) THEN
                //------------------------------------------------------- 
                IF(PersistentSettings^.Update().IsDone()) THEN
                    THIS.MoveNext(); 
                END_IF;    
                //-------------------------------------------------------
            END_IF;

            IF (Steps[3].Execute(THIS, TRUE, '<#READ PERSISTENT SETTINGS#>')) THEN
                //------------------------------------------------------- 
                IF(PersistentSettings^.Read().IsDone()) THEN
                    THIS.MoveNext(); 
                END_IF;    
                //-------------------------------------------------------
            END_IF;

            IF (Steps[4].Execute(THIS, TRUE, '<#READ TECHNOLOGY SETTINS#>')) THEN
                //------------------------------------------------------- 
                IF(TechnologySettings^.Read( Objs^.LastTechnologySettings ).IsDone()) THEN
                    THIS.MoveNext(); 
                END_IF;    
                //-------------------------------------------------------
            END_IF;
                          
            IF (Steps[5].Execute(THIS, TRUE, '<#DO SOMETHING#>')) THEN
                //-------------------------------------------------------
                IF CurrentStep.Duration > TIME#2s THEN                         
                    THIS.MoveNext();
                END_IF;
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