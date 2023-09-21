NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;

    ///<summary>
    /// Provides automatic mode sequence.
    ///</summary>
    {#ix-set:AttributeName = "<#AUTOMAT#>"}
    CLASS PUBLIC AutomatSequence
        EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            Steps : ARRAY[0..80] OF AxoStep;
        END_VAR
        VAR PRIVATE
            Components : REF_TO Components;
            ProcessData : REF_TO ProcessDataManger;
            SettingSourceData : REF_TO FragmentProcessData;
            SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
            StationName : REF_TO STRING;
            Ids : ITestIdGenerator;
            LastGeneratedId : ARRAY[0..80] OF STRING;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _parent : IAxoObject;
                _components : REF_TO Components;
                _processData : REF_TO ProcessDataManger;
                _SettingSourceData : REF_TO FragmentProcessData;
                _SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
                _ids : ITestIdGenerator;
                _StationName : REF_TO STRING;
            END_VAR
            Components := _components;
            ProcessData := _processData;
            StationName := _StationName;
            Ids := _ids;
            SettingSourceData := _SettingSourceData;
            SettingSourceManager := _SettingSourceManager;
            SUPER.Run(_parent);
        END_METHOD
        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>

        METHOD OVERRIDE Main
            VAR
                ForIndex : INT;
            END_VAR
            ;
            IF (Components = NULL OR ProcessData = NULL) THEN
                RETURN;
            END_IF;
            
            // This sequecner executes the steps in cycles from top to bottom
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.
            // This sets the sequence to run in cycles (top-botton-top and again).
            //THIS.SequenceMode := eAxoSequenceMode#Cyclic;
            // IF (Steps[1].Execute(THIS, TRUE, 'reading produced')) THEN
            //     //-------------------------------------------------------            
            //         IF (ProcessData^.Read('produced').IsDone()) THEN 
            //             THIS.MoveNext(); 
            //             ProcessData^.Restore();
            //         END_IF;
            //     //-------------------------------------------------------
            // END_IF;
            // IF (Steps[2].Execute(THIS, TRUE, 'continue')) THEN
            //     THIS.MoveNext(); 
            // END_IF;

            FOR ForIndex := 1 TO 14 DO
                THIS.CallStepsReadCreateUpdate(5 * ForIndex, ForIndex);
            END_FOR;

            // This will close the sequence and will return to the first step.
            THIS.Close(Steps[80]);
        END_METHOD

        METHOD INTERNAL DataStep
            VAR_INPUT
                StepIndex : INT;
                IdIndex : INT;
                operation : INT; // create 10, read 20, update 30 delete 40
            END_VAR

            CASE operation OF
                10:
                    IF (Steps[StepIndex].Execute(THIS, TRUE, 'creating')) THEN
                        //IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', creating ', LastGeneratedId[IdIndex] ))) THEN
                        //-------------------------------------------------------            
                        IF (ProcessData^.CreateOrUpdate(LastGeneratedId[IdIndex]).IsDone()) THEN
                            THIS.MoveNext();
                            ProcessData^.Restore();
                        END_IF;
                        //-------------------------------------------------------
                    END_IF;
                20:
                    IF (Steps[StepIndex].Execute(THIS, TRUE, 'reading')) THEN
                        // IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', reading ', LastGeneratedId[IdIndex] ))) THEN
                        //-------------------------------------------------------            
                        IF (ProcessData^.Read(LastGeneratedId[IdIndex]).IsDone()) THEN
                            THIS.MoveNext();
                            ProcessData^.Restore();
                        END_IF;
                        //-------------------------------------------------------
                    END_IF;
                30:
                    IF (Steps[StepIndex].Execute(THIS, TRUE, 'updating')) THEN
                        // IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', updating ', LastGeneratedId[IdIndex] ))) THEN
                        //-------------------------------------------------------            
                        IF (ProcessData^.Update(LastGeneratedId[IdIndex]).IsDone()) THEN
                            THIS.MoveNext();
                            ProcessData^.Restore();
                        END_IF;
                        //-------------------------------------------------------
                    END_IF;
                40:
                    IF (Steps[StepIndex].Execute(THIS, TRUE, 'deleting')) THEN
                        //IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', deleting ', LastGeneratedId[IdIndex] ))) THEN
                        //-------------------------------------------------------            
                        IF (ProcessData^.Delete(LastGeneratedId[IdIndex]).IsDone()) THEN
                            THIS.MoveNext();
                            ProcessData^.Restore();
                        END_IF;
                        //-------------------------------------------------------
                    END_IF;
            END_CASE;
        END_METHOD

        METHOD INTERNAL CreateId
            VAR_INPUT
                StepIndex : INT;
                IdIndex : INT;
            END_VAR
            IF (Steps[StepIndex].Execute(THIS, TRUE, 'Generating Id : ')) THEN
                //IF (Steps[StepIndex].Execute(THIS, TRUE, Concat('Step ', ToString(StepIndex),', Generating Id on index: ', ToString( IdIndex) ))) THEN
                LastGeneratedId[IdIndex] := Concat(StationName^, '_', ToString(THIS.GetContext().OpenCycleCount()));
                THIS.MoveNext();
            END_IF;
        END_METHOD

        METHOD INTERNAL CallStepsReadCreateUpdate
            VAR_INPUT
                FromStepIndex : INT;
                IdIndex : INT;
            END_VAR
            THIS.CreateId((FromStepIndex + 0), IdIndex); // generate id
            THIS.DataStep((FromStepIndex + 1), IdIndex, 10); // create...
            THIS.DataStep((FromStepIndex + 2), IdIndex, 20); // read...
            THIS.DataStep((FromStepIndex + 3), IdIndex, 30); // update...

            // THIS.DataStep((FromStepIndex + 4), IdIndex, 40); // delete...

        END_METHOD
    END_CLASS

END_NAMESPACE
