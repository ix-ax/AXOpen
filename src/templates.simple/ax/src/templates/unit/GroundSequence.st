NAMESPACE axosimple.UnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
    
    ///<summary>
    /// Provides ground mode sequence.
    ///</summary>
    {#ix-set:AttributeName = "<#GROUND#>"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC GroundSequence
        EXTENDS AXOpen.Core.AxoSequencerContainer
        IMPLEMENTS IModeContainer
        VAR PUBLIC
            Steps : ARRAY[0..20] OF AXOpen.Core.AxoStep;      
            MoveToWork : AXOpen.Core.AxoTask;
        END_VAR
        VAR PRIVATE
            Objs : REF_TO axosimple.UnitTemplate.UnitObjects;
            Components : REF_TO axosimple.UnitTemplate.Components;

            ProcessDataManager : REF_TO axosimple.UnitTemplate.ProcessDataManager;
            ProcessSettingsManager : REF_TO axosimple.UnitTemplate.FragmentProcessDataManger;
            TechnologySettingsManager : REF_TO axosimple.UnitTemplate.TechnologyDataManager;
            
            PersistentSettingsManager : REF_TO AxoDataPersistentExchange;

            _currentId : STRING;

            techSetttingsId : STRING;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _parent : AXOpen.Core.IAxoObject;
                _unitObjects : REF_TO axosimple.UnitTemplate.UnitObjects;
            END_VAR     

            IF Objs = NULL THEN 
                Objs := _unitObjects;
                
                Components := Objs^.Components;
                ProcessDataManager := Objs^.ProcessData;
                ProcessSettingsManager := Objs^.ProcessSettings;
                TechnologySettingsManager := Objs^.TechnologySettings;
                PersistentSettingsManager := Objs^.Global^.PersistentData;
            END_IF;

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
            
            IF (Steps[0].Execute(THIS, TRUE, '<#RESTORE#>')) THEN
                //------------------------------------------------------- 
                    TechnologySettingsManager^.Restore(); 
                    ProcessSettingsManager^.Restore(); 
                    ProcessDataManager^.Restore();

                    THIS.MoveNext();  
                //-------------------------------------------------------
            END_IF;

            IF (Steps[1].Execute(THIS, TRUE, '<#READ PERSISTENT SETTINGS#>')) THEN
                //------------------------------------------------------- 
                CASE TO_INT( THIS.GetMicroStepValue()) OF
                    0 : 
                        IF PersistentSettingsManager^.InvokeRead(THIS,'UnitTemplate') THEN 
                            THIS.SetMicroStepValue(UINT#10);
                        END_IF;
                    10 : 
                        IF PersistentSettingsManager^.IsReadDone(THIS) THEN 
                                THIS.MoveNext(); 
                        END_IF;  
                    ELSE
                        THIS.SetMicroStepValue(UINT#0);
                END_CASE;
                //-------------------------------------------------------
            END_IF;

            IF (Steps[5].Execute(THIS, TRUE, '<#READ TECHNOLOGY SETTINS#>')) THEN
                //------------------------------------------------------- 
                IF CurrentStep.IsFirstEntryToStep() THEN 

                    IF Objs^.Global^.TechnologySettings^.Common.Entity.DataEntityId <> '' THEN
                       techSetttingsId := Objs^.Global^.TechnologySettings^.Common.Entity.DataEntityId; // TAKE GLOGAL TECHNOLOGY SETTINGS ID

                    ELSIF Objs^.TechnologySettings^.Shared.Entity.DataEntityId <> '' THEN // TAKE LAST LOADED FOR STATION
                        techSetttingsId := Objs^.TechnologySettings^.Shared.Entity.DataEntityId;

                    ELSIF Objs^.LastTechnologySettings <> '' THEN // TAKE LAST LOADED FROM PERSISTENT
                        techSetttingsId := Objs^.LastTechnologySettings;
                    ELSE
                        Objs^.LastTechnologySettings := 'default'; // FORCE DEFAULT VALUE 
                        techSetttingsId := Objs^.LastTechnologySettings;
                    END_IF;
                    
                    IF Objs^.Global^.TechnologySettings^.Common.Entity.DataEntityId = Objs^.TechnologySettings^.Shared.Entity.DataEntityId then 
                        //THIS.MoveNext(); // you can skip loading...
                        ;
                    end_if;

                else
                    IF(TechnologySettingsManager^.Read( techSetttingsId ).IsDone()) THEN
                        THIS.MoveNext(); 
                    END_IF; 
                END_IF;
                //-------------------------------------------------------
            END_IF;
                
            IF (Steps[3].Execute(THIS, TRUE, '<#DO SOMETHING#>')) THEN
                //-------------------------------------------------------
                IF CurrentStep.Duration > TIME#2s THEN                         
                    THIS.MoveNext();
                END_IF;
                //-------------------------------------------------------
            END_IF;

            IF (Steps[19].Execute(THIS, TRUE, '<#SAVE DATA#>')) THEN
                //-------------------------------------------------------
                CASE TO_INT( THIS.GetMicroStepValue()) OF
                    0 : 
                        IF ProcessDataManager^.Shared.Entity.DataEntityId <> '' THEN 
                            _currentId := ProcessDataManager^.Shared.Entity.DataEntityId;
                            THIS.SetMicroStepValue(UINT#10);

                        ELSE // FIST RUN OR WITHOUT DATA
                            THIS.MoveNext();
                        END_IF;

                    10 : // update part as a corrupted a interrupted
                        ProcessDataManager^.Shared.Entity.WasReset := true;
                        IF ProcessDataManager^.Update(_currentId).IsDone() THEN 
                                THIS.MoveNext(); 
                        END_IF;  
                    ELSE
                        THIS.SetMicroStepValue(UINT#0);
                END_CASE;
                //-------------------------------------------------------
            END_IF;
           
            // This will close the sequence and will return to the first step.
            THIS.Close(Steps[20]);
        END_METHOD
    END_CLASS
END_NAMESPACE    
