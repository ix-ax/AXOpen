NAMESPACE axosimple.StarterUnitTemplate
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
        EXTENDS AXOpen.Core.AxoSequencerContainer IMPLEMENTS IModeContainer
        VAR PUBLIC
            Steps : ARRAY[0..100] OF AXOpen.Core.AxoStep;      
            MoveToWork : AXOpen.Core.AxoTask;
        END_VAR
        VAR PRIVATE
            Objs : REF_TO axosimple.StarterUnitTemplate.UnitObjects;
            Components : REF_TO axosimple.StarterUnitTemplate.Components;
            ProcessData : REF_TO axosimple.StarterUnitTemplate.ProcessDataManager;
            ProcessSettings : REF_TO axosimple.StarterUnitTemplate.FragmentProcessDataManger;
            TechnologySettings : REF_TO axosimple.StarterUnitTemplate.TechnologyDataManager;

            PersistentSettings : REF_TO AxoDataPersistentExchange;

            _currentId : STRING;
            techSetttingsId : STRING;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _parent : AXOpen.Core.IAxoObject;
                _unitObjects : REF_TO axosimple.StarterUnitTemplate.UnitObjects;
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
                taskState : AXOpen.Core.IAxoTaskState;
                forIterator : INT;
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
                TechnologySettings^.Restore(); 
                ProcessSettings^.Restore(); 
                ProcessData^.Restore();
                
                THIS.MoveNext();
                //-------------------------------------------------------
            END_IF;

            IF (Steps[1].Execute(THIS, TRUE, '<#READ PERSISTENT SETTINGS#>')) THEN
                //------------------------------------------------------- 
                IF CurrentStep.IsFirstEntryToStep() THEN 
                    ;// some special initialization 
                END_IF;

                CASE TO_INT( THIS.GetMicroStepValue()) OF
                    0 : 
                        IF PersistentSettings^.InvokeEntityExist(THIS ,'') THEN 
                            THIS.SetMicroStepValue(UINT#10);
                        END_IF;

                    10 : 
                        IF PersistentSettings^.IsEntityExistDone(THIS) THEN 
                            IF PersistentSettings^.EntityExistResult() THEN 
                                THIS.SetMicroStepValue(UINT#40); // default data exist
                            ELSE
                                THIS.SetMicroStepValue(UINT#20); // no data exist
                            END_IF;
                        END_IF;

                    20 :  
                        IF PersistentSettings^.InvokeUpdateAll(THIS) THEN // data not exist -> udate all to DB
                            THIS.SetMicroStepValue(UINT#30);
                        END_IF;

                    30:    
                        IF PersistentSettings^.IsUpdateAllDone(THIS) THEN
                            THIS.SetMicroStepValue(UINT#40); // all was updated to DB
                        END_IF;

                    40 : 
                        IF PersistentSettings^.InvokeRead(THIS, '') THEN // read default group
                            THIS.SetMicroStepValue(UINT#50);
                        END_IF;
                    50 : 
                        IF PersistentSettings^.IsReadDone(THIS) THEN 
                                THIS.MoveNext(); // just default group was readed
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
                    IF(TechnologySettings^.Read( techSetttingsId ).IsDone()) THEN
                        THIS.MoveNext(); 
                    END_IF; 
                END_IF;
                //-------------------------------------------------------
            END_IF;
                   
            
            FOR forIterator := 6 TO 98 BY 1 DO
                IF (Steps[forIterator].Execute(THIS, TRUE,Concat('DO SOMETHING -G-',ToString(forIterator)) )) THEN
                    //-------------------------------------------------------                
                    IF CurrentStep.Duration > TIME#25ms THEN                         
                        THIS.MoveNext();
                    END_IF;                
                    //-------------------------------------------------------
                END_IF;
            END_FOR;
                      

            IF (Steps[99].Execute(THIS, TRUE, '<#SAVE DATA#>')) THEN
                //-------------------------------------------------------
                CASE TO_INT( THIS.GetMicroStepValue()) OF
                    0 : 
                        IF ProcessData^.Shared.Entity.DataEntityId <> '' THEN 
                            _currentId := ProcessData^.Shared.Entity.DataEntityId;
                            THIS.SetMicroStepValue(UINT#10);

                        ELSE // FIST RUN OR WITHOUT DATA
                            THIS.MoveNext();
                        END_IF;

                    10 : // update part as a corrupted a interrupted
                        ProcessData^.Shared.Entity.WasReset := true;
                        IF ProcessData^.Update(_currentId).IsDone() THEN 
                                THIS.MoveNext(); 
                        END_IF;  
                    ELSE
                        THIS.SetMicroStepValue(UINT#0);
                END_CASE;
                //-------------------------------------------------------
            END_IF;
           
            // This will close the sequence and will return to the first step.
            THIS.Close(Steps[100]);
        END_METHOD
    END_CLASS
END_NAMESPACE    
