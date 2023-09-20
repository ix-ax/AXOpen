NAMESPACE sandboxtest.StandardControlUnit
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
        END_VAR
        VAR PRIVATE
            Components : REF_TO Components;
            ProcessData : REF_TO ProcessDataManger;
            Ids : StandardControlUnit.ITestIdGenerator;
            SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
            SettingSourceData : REF_TO FragmentProcessData;
            StationName : REF_TO STRING;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _parent : IAxoObject;
                _components : REF_TO Components;
                _processData : REF_TO ProcessDataManger;
                _SettingSourceData : REF_TO FragmentProcessData;
                _SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
                _ids : StandardControlUnit.ITestIdGenerator;
                _StationName : REF_TO STRING;
            END_VAR
            Components := _components;
            ProcessData := _processData;
            Ids := _ids;
            SettingSourceData := _SettingSourceData;
            SettingSourceManager := _SettingSourceManager;
            StationName := _StationName;
            SUPER.Run(_parent);
        END_METHOD
        ///<summary>
        /// Contains logic of the steps of this sequence
        ///</summary>

        METHOD PROTECTED OVERRIDE Main
            IF (Components = NULL OR ProcessData = NULL) THEN
                RETURN;
            END_IF;
            // This sequecner executes the steps in cycles from top to botton
            // in the same order they are written in the program
            // Each step in the sequence must can be used only once.
            // This sets the sequence to run once (top-botton) and stops with done after closing.
            THIS.SequenceMode := eAxoSequenceMode#RunOnce;
            //    IF (Steps[0].Execute(THIS, TRUE, 'RESET COMPONENTOV')) THEN
            //     //-------------------------------------------------------   
            //         Ids.InitializeWithPrefix( THIS.StationName^);
            //         THIS.MoveNext(); // <- This will move to the next step in the sequence.
            //     //-------------------------------------------------------
            //     END_IF; 
            IF (Steps[0].Execute(THIS, TRUE, 'NACITANIE NASTAVENI-process_set')) THEN
                //-------------------------------------------------------   
                ;
                //Ids.GetRootRecordName();
                IF (SettingSourceManager.Read('process_set').IsDone()) THEN // <- waits for the task to be done.
                    THIS.MoveNext(); // <- This will move to the next step in the sequence.
                END_IF;
//-------------------------------------------------------
            END_IF;
            // IF (Steps[2].Execute(THIS, TRUE,  Concat('VYTVORENIE ZAZNAMU ',Ids.GetNext() ))) THEN
            //     //-------------------------------------------------------   
            //         IF (THIS.ProcessData^.Create( Ids.GetRootRecordName()).IsDone()) THEN // <- waits for the task to be done.
            //                 THIS.MoveNext(); // <- This will move to the next step in the sequence.
            //         END_IF;
            //     //-------------------------------------------------------
            // END_IF; 
            // IF (Steps[3].Execute(THIS, TRUE,  'KONTROLA VYTVORENIA POSLEDNEHO ZAZNAMU')) THEN
            //     //-------------------------------------------------------   
            //         IF  Ids.Increment() THEN 
            //             THIS.RequestStep(RequestedStep := Steps[2]); 
            //         ELSE
            //             THIS.MoveNext(); 
            //         END_IF;
            //     //-------------------------------------------------------
            // END_IF; 
            THIS.Close(Steps[20]);
        END_METHOD

        METHOD INTERNAL FillProcessData
            VAR_INPUT
                Header : REF_TO SharedProductionData;
                tData : REF_TO FragmentProcessData;
            END_VAR
            Header^.GoesTo := Header^.ComesFrom;
            Header^.ComesFrom := TO_INT(THIS.GetContext().OpenCycleCount());
            tData^.CounterDelay := THIS.GetContext().OpenCycleCount();
// tData^.hierarchy.item_member_property_1.item_member_property_2.myULINT :=  tData^.hierarchy.item_member_property_1.item_member_property_1.myULINT;
// tData^.hierarchy.item_member_property_1.item_member_property_1.myULINT :=  THIS.GetContext().OpenCycleCount();
// tData^.hierarchy.item_member_property_2.item_member_property_2.myULINT :=  tData^.hierarchy.item_member_property_1.item_member_property_1.myULINT;
// tData^.hierarchy.item_member_property_2.item_member_property_1.myULINT :=  THIS.GetContext().OpenCycleCount();
        END_METHOD
    END_CLASS

END_NAMESPACE
