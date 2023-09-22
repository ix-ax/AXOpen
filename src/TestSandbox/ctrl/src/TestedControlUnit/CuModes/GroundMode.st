NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;
    USING AXOpen.Inspectors;

    ///<summary>
    /// Provides ground mode sequence.
    ///</summary>
    {#ix-set:AttributeName = "<#GROUND#>"}
    CLASS PUBLIC GroundSequence
        EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            Steps : ARRAY[0..20] OF AxoStep;
        END_VAR
        VAR PRIVATE
            Components : REF_TO Components;
            ProcessDataManager : REF_TO ProcessDataManger;
            SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
            SettingSourceData : REF_TO FragmentProcessData;
            StationName : REF_TO STRING;
            
            EntityHeader : REF_TO SharedProductionData;
            ProcessData  : REF_TO FragmentProcessData;

            LastGeneratedId : STRING;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _parent : IAxoObject;
                _components : REF_TO Components;
                _processDataManager : REF_TO ProcessDataManger;
                _SettingSourceData : REF_TO FragmentProcessData;
                _SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
                _StationName : REF_TO STRING;
            END_VAR
            Components := _components;
            ProcessDataManager := _processDataManager;
            SettingSourceData := _SettingSourceData;
            SettingSourceManager := _SettingSourceManager;
            StationName := _StationName;

           EntityHeader := REF(ProcessDataManager^.Shared.Set);
           ProcessData := REF(ProcessDataManager^.DataManger.Set);

            SUPER.Run(_parent);
        END_METHOD
        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>

        METHOD PROTECTED OVERRIDE Main
            IF (Components = NULL OR ProcessDataManager = NULL) THEN
                RETURN;
            END_IF;

            // This sequecner executes the steps in cycles from top to botton
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.
            // This sets the sequence to run once (top-botton) and stops with done after closing.
            THIS.SequenceMode := eAxoSequenceMode#RunOnce;
          
            IF (Steps[0].Execute(THIS, TRUE, 'NACITANIE NASTAVENI-process_set')) THEN
                //-------------------------------------------------------   
                ;
                IF (SettingSourceManager.Read('process_set').IsDone()) THEN // <- waits for the task to be done.
                    THIS.MoveNext(); // <- This will move to the next step in the sequence.
                END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[1].Execute(THIS, TRUE, 'Restore Piston 0' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_0.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

              
            IF (Steps[2].Execute(THIS, TRUE, 'Restore Piston 1' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_1.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[3].Execute(THIS, TRUE, 'Restore Piston 2' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_2.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            
            IF (Steps[4].Execute(THIS, TRUE, 'Restore Piston 1' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_3.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            
            IF (Steps[5].Execute(THIS, TRUE, 'Restore Piston 1' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_4.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            
            IF (Steps[6].Execute(THIS, TRUE, 'Restore Piston 5' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_5.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            
            IF (Steps[7].Execute(THIS, TRUE, 'Restore Piston 6' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_6.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

          
            IF (Steps[8].Execute(THIS, TRUE, 'Restore Piston 7' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_7.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[9].Execute(THIS, TRUE, 'Restore Piston 8' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_8.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[10].Execute(THIS, TRUE, 'Restore Piston 9' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Cylinder_9.Stop().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[11].Execute(THIS, TRUE, 'Reader_0' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Reader_0.ClearResultData().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[12].Execute(THIS, TRUE, 'Reader_1' )) THEN
                //-------------------------------------------------------   
                    IF (Components^.Reader_1.ClearResultData().IsDone()) THEN THIS.MoveNext(); END_IF;
                //-------------------------------------------------------
            END_IF; 

             IF (Steps[13].Execute(THIS, TRUE, 'Copy process data' )) THEN
                //-------------------------------------------------------  
                    THIS.ProcessData^ := SettingSourceData^;
                    LastGeneratedId := Concat('process_set', '_', ToString(THIS.GetContext().OpenCycleCount()));
                    THIS.MoveNext(); 
                //-------------------------------------------------------
            END_IF; 



            // IF (Steps[13].Execute(THIS, TRUE, 'Camera_0' )) THEN
            //     //-------------------------------------------------------   
            //         IF (Components^.Camera_0.Restore().IsDone()) THEN THIS.MoveNext(); END_IF;
            //     //-------------------------------------------------------
            // END_IF; 

            // IF (Steps[14].Execute(THIS, TRUE, 'Camera_1' )) THEN
            //     //-------------------------------------------------------   
            //         IF (Components^.Camera_0.Restore().IsDone()) THEN THIS.MoveNext(); END_IF;
            //     //-------------------------------------------------------
            // END_IF; 


            THIS.Close(Steps[20]);

        END_METHOD

    END_CLASS

END_NAMESPACE
