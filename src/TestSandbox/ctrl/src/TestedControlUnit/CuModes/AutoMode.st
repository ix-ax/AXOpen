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


            ComprehensiveResult: AXOpen.Inspectors.AxoComprehensiveResult;

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
            
            IF (Steps[0].Execute(THIS, TRUE, 'INIT')) THEN
                //-------------------------------------------------------   
                    THIS.MoveNext(); // <- This will move to the next step in the sequence.
                //-------------------------------------------------------
            END_IF;

            IF (Steps[1].Execute(THIS, TRUE, 'Generating Id')) THEN
                //-------------------------------------------------------            
                LastGeneratedId[0] := Concat(StationName^, '_', ToString(THIS.GetContext().OpenCycleCount()));
                THIS.MoveNext();
                ProcessData^.Restore();
                //-------------------------------------------------------            
            END_IF;

            IF (Steps[2].Execute(THIS, TRUE, 'ProcessData-Create')) THEN
                //-------------------------------------------------------            
                IF (ProcessData^.CreateOrUpdate(LastGeneratedId[0]).IsDone()) THEN
                    THIS.MoveNext();
                    ProcessData^.Restore();
                END_IF;
                //-------------------------------------------------------
            END_IF;


            IF (Steps[3].Execute(THIS, TRUE, 'ProcessData-Read')) THEN
                //-------------------------------------------------------            
                IF (ProcessData^.Read(LastGeneratedId[0]).IsDone()) THEN
                    THIS.MoveNext();
                    ProcessData^.Restore();
                END_IF;
                //-------------------------------------------------------
            END_IF;

            IF (Steps[4].Execute(THIS, TRUE, 'ALL CYLINDER STOP, START' )) THEN
                //-------------------------------------------------------  
                    Components^.Cylinder_0.Stop();
                    Components^.Cylinder_1.Stop();
                    Components^.Cylinder_2.Stop();
                    Components^.Cylinder_3.Stop();
                    Components^.Cylinder_4.Stop();
                    Components^.Cylinder_5.Stop();
                    Components^.Cylinder_6.Stop();
                    Components^.Cylinder_7.Stop();
                    Components^.Cylinder_8.Stop();
                    Components^.Cylinder_9.Stop();

                    THIS.MoveNext(); 
                //-------------------------------------------------------
            END_IF; 

             IF (Steps[5].Execute(THIS, TRUE, 'ALL CYLINDER STOP, DONE' )) THEN
                //-------------------------------------------------------  
                    
                    IF Components^.Cylinder_0.Stop().IsDone() AND
                       Components^.Cylinder_1.Stop().IsDone() AND
                       Components^.Cylinder_2.Stop().IsDone() AND
                       Components^.Cylinder_3.Stop().IsDone() AND
                       Components^.Cylinder_4.Stop().IsDone() AND
                       Components^.Cylinder_5.Stop().IsDone() AND
                       Components^.Cylinder_6.Stop().IsDone() AND
                       Components^.Cylinder_7.Stop().IsDone() AND
                       Components^.Cylinder_8.Stop().IsDone() AND
                       Components^.Cylinder_9.Stop().IsDone() THEN

                    THIS.MoveNext(); 

                    END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[6].Execute(THIS, TRUE, 'ALL PISTONS TO WORKPOS' )) THEN
                //-------------------------------------------------------  
                    Components^.Cylinder_0.MoveToWork();
                    Components^.Cylinder_1.MoveToWork();
                    Components^.Cylinder_2.MoveToWork();
                    Components^.Cylinder_3.MoveToWork();
                    Components^.Cylinder_4.MoveToWork();
                    Components^.Cylinder_5.MoveToWork();
                    Components^.Cylinder_6.MoveToWork();
                    Components^.Cylinder_7.MoveToWork();
                    Components^.Cylinder_8.MoveToWork();
                    Components^.Cylinder_9.MoveToWork();

                    THIS.MoveNext(); 
                //-------------------------------------------------------
            END_IF; 


            IF (Steps[7].Execute(THIS, TRUE, 'ALL CHECKS RESTORE' )) THEN
                //-------------------------------------------------------  
                    SettingSourceData^.Res_Screw_0.Data()^.FailTime := TIME#700ms;
                    SettingSourceData^.Tor_Screw_0.Data()^.FailTime := TIME#700ms;
                    SettingSourceData^.Ang_Screw_0.Data()^.FailTime := TIME#700ms;
                    SettingSourceData^.XCo_Screw_0.Data()^.FailTime := TIME#700ms;
                    SettingSourceData^.YCo_Screw_0.Data()^.FailTime := TIME#700ms;
                    SettingSourceData^.Res_Screw_0.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Tor_Screw_0.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Ang_Screw_0.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.XCo_Screw_0.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.YCo_Screw_0.Data()^.PassTime := TIME#100ms;


                    SettingSourceData^.Res_Screw_1.Data()^.FailTime := TIME#600ms;
                    SettingSourceData^.Tor_Screw_1.Data()^.FailTime := TIME#600ms;
                    SettingSourceData^.Ang_Screw_1.Data()^.FailTime := TIME#600ms;
                    SettingSourceData^.XCo_Screw_1.Data()^.FailTime := TIME#600ms;
                    SettingSourceData^.YCo_Screw_1.Data()^.FailTime := TIME#600ms;
                    SettingSourceData^.Res_Screw_1.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Tor_Screw_1.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Ang_Screw_1.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.XCo_Screw_1.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.YCo_Screw_1.Data()^.PassTime := TIME#100ms;

                    SettingSourceData^.Res_Screw_2.Data()^.FailTime := TIME#500ms;
                    SettingSourceData^.Tor_Screw_2.Data()^.FailTime := TIME#500ms;
                    SettingSourceData^.Ang_Screw_2.Data()^.FailTime := TIME#500ms;
                    SettingSourceData^.XCo_Screw_2.Data()^.FailTime := TIME#500ms;
                    SettingSourceData^.YCo_Screw_2.Data()^.FailTime := TIME#500ms;
                    SettingSourceData^.Res_Screw_2.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Tor_Screw_2.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Ang_Screw_2.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.XCo_Screw_2.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.YCo_Screw_2.Data()^.PassTime := TIME#100ms;

                    SettingSourceData^.Res_Screw_3.Data()^.FailTime := TIME#400ms;
                    SettingSourceData^.Tor_Screw_3.Data()^.FailTime := TIME#400ms;
                    SettingSourceData^.Ang_Screw_3.Data()^.FailTime := TIME#400ms;
                    SettingSourceData^.XCo_Screw_3.Data()^.FailTime := TIME#400ms;
                    SettingSourceData^.YCo_Screw_3.Data()^.FailTime := TIME#400ms;
                    SettingSourceData^.Res_Screw_3.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Tor_Screw_3.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Ang_Screw_3.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.XCo_Screw_3.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.YCo_Screw_3.Data()^.PassTime := TIME#100ms;

                    SettingSourceData^.Res_Screw_4.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Tor_Screw_4.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Ang_Screw_4.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.XCo_Screw_4.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.YCo_Screw_4.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Res_Screw_4.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Tor_Screw_4.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.Ang_Screw_4.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.XCo_Screw_4.Data()^.PassTime := TIME#100ms;
                    SettingSourceData^.YCo_Screw_4.Data()^.PassTime := TIME#100ms;

                    SettingSourceData^.Traca__0.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Traca__0.Data()^.PassTime := TIME#100ms;

                    SettingSourceData^.Traca__1.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Traca__1.Data()^.PassTime := TIME#100ms;

                    SettingSourceData^.Reader_0.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Reader_0.Data()^.PassTime := TIME#100ms;

                    SettingSourceData^.Reader_1.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Reader_1.Data()^.PassTime := TIME#100ms;


                    SettingSourceData^.Camera_0.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Camera_0.Data()^.PassTime := TIME#100ms;


                    SettingSourceData^.Camera_1.Data()^.FailTime := TIME#300ms;
                    SettingSourceData^.Camera_1.Data()^.PassTime := TIME#100ms;

                    THIS.MoveNext(); 
                //-------------------------------------------------------
            END_IF; 

            THIS.Screwins_1Screw_Steps(StepIndex := 8,
                    Res    := SettingSourceData^.Res_Screw_0,
                    Tor    := SettingSourceData^.Tor_Screw_0,
                    Ang    := SettingSourceData^.Ang_Screw_0,
                    XCo    := SettingSourceData^.XCo_Screw_0,
                    YCo    := SettingSourceData^.YCo_Screw_0
            );

            THIS.Screwins_1Screw_Steps(StepIndex := 10,
                    Res    := SettingSourceData^.Res_Screw_1,
                    Tor    := SettingSourceData^.Tor_Screw_1,
                    Ang    := SettingSourceData^.Ang_Screw_1,
                    XCo    := SettingSourceData^.XCo_Screw_1,
                    YCo    := SettingSourceData^.YCo_Screw_1
            );


            THIS.Screwins_1Screw_Steps(StepIndex := 12,
                    Res    := SettingSourceData^.Res_Screw_2,
                    Tor    := SettingSourceData^.Tor_Screw_2,
                    Ang    := SettingSourceData^.Ang_Screw_2,
                    XCo    := SettingSourceData^.XCo_Screw_2,
                    YCo    := SettingSourceData^.YCo_Screw_2
            );

            THIS.Screwins_1Screw_Steps(StepIndex := 14,
                    Res    := SettingSourceData^.Res_Screw_3,
                    Tor    := SettingSourceData^.Tor_Screw_3,
                    Ang    := SettingSourceData^.Ang_Screw_3,
                    XCo    := SettingSourceData^.XCo_Screw_3,
                    YCo    := SettingSourceData^.YCo_Screw_3
            );

            IF (Steps[16].Execute(THIS, TRUE, 'ALL CYLINDER STOP, DONE' )) THEN
                //-------------------------------------------------------  
                    
                    IF Components^.Cylinder_0.Stop().IsDone() AND
                       Components^.Cylinder_1.Stop().IsDone() AND
                       Components^.Cylinder_2.Stop().IsDone() AND
                       Components^.Cylinder_3.Stop().IsDone() AND
                       Components^.Cylinder_4.Stop().IsDone() AND
                       Components^.Cylinder_5.Stop().IsDone() AND
                       Components^.Cylinder_6.Stop().IsDone() AND
                       Components^.Cylinder_7.Stop().IsDone() AND
                       Components^.Cylinder_8.Stop().IsDone() AND
                       Components^.Cylinder_9.Stop().IsDone() THEN

                    THIS.MoveNext(); 

                    END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[17].Execute(THIS, TRUE, 'ALL PISTONS TO WORKPOS' )) THEN
                //-------------------------------------------------------  
                    Components^.Cylinder_0.MoveToHome();
                    Components^.Cylinder_1.MoveToHome();
                    Components^.Cylinder_2.MoveToHome();
                    Components^.Cylinder_3.MoveToHome();
                    Components^.Cylinder_4.MoveToHome();
                    Components^.Cylinder_5.MoveToHome();
                    Components^.Cylinder_6.MoveToHome();
                    Components^.Cylinder_7.MoveToHome();
                    Components^.Cylinder_8.MoveToHome();
                    Components^.Cylinder_9.MoveToHome();

                    THIS.MoveNext(); 
                //-------------------------------------------------------
            END_IF; 

            THIS.Screwins_1Screw_Steps(StepIndex := 18,
                    Res    := SettingSourceData^.Res_Screw_4,
                    Tor    := SettingSourceData^.Tor_Screw_4,
                    Ang    := SettingSourceData^.Ang_Screw_4,
                    XCo    := SettingSourceData^.XCo_Screw_4,
                    YCo    := SettingSourceData^.YCo_Screw_4
            );


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


        METHOD INTERNAL Screwins_1Screw_Steps
             VAR_INPUT
                StepIndex : INT;
            END_VAR

            VAR_IN_OUT
                Res : AXOpen.Inspectors.AxoDigitalInspector;
                Tor : AXOpen.Inspectors.AxoAnalogueInspector;
                Ang : AXOpen.Inspectors.AxoAnalogueInspector;
                XCo : AXOpen.Inspectors.AxoAnalogueInspector;
                YCo : AXOpen.Inspectors.AxoAnalogueInspector;
            END_VAR;

                IF (Steps[StepIndex + 0].Execute(THIS, TRUE, 'Cleaning checks')) THEN
                    //-------------------------------------------------------            
                    Res.Data()^.FailTime := TIME#700ms;
                    Tor.Data()^.FailTime := TIME#700ms;
                    Ang.Data()^.FailTime := TIME#700ms;
                    XCo.Data()^.FailTime := TIME#700ms;
                    YCo.Data()^.FailTime := TIME#700ms;

                    Res.Data()^.PassTime := TIME#100ms;
                    Tor.Data()^.PassTime := TIME#100ms;
                    Ang.Data()^.PassTime := TIME#100ms;
                    XCo.Data()^.PassTime := TIME#100ms;
                    YCo.Data()^.PassTime := TIME#100ms;

                    THIS.MoveNext();
                    //-------------------------------------------------------
                END_IF;

                IF (Steps[StepIndex + 1].Execute(THIS, TRUE, 'Screw Inspect')) THEN
                    //-------------------------------------------------------
                    Res.WithCoordinator(THIS).Inspect(THIS,false  ).UpdateComprehensiveResult(ComprehensiveResult).OnFail().CarryOn();
                    Tor.WithCoordinator(THIS).Inspect(THIS,0      ).UpdateComprehensiveResult(ComprehensiveResult).OnFail().CarryOn();
                    Ang.WithCoordinator(THIS).Inspect(THIS,0      ).UpdateComprehensiveResult(ComprehensiveResult).OnFail().CarryOn();
                    XCo.WithCoordinator(THIS).Inspect(THIS,0      ).UpdateComprehensiveResult(ComprehensiveResult).OnFail().CarryOn();
                    YCo.WithCoordinator(THIS).Inspect(THIS,0      ).UpdateComprehensiveResult(ComprehensiveResult).OnFail().CarryOn();

                    //-------------------------------------------------------
                END_IF;
        END_METHOD

        METHOD INTERNAL SetScrewDefaultValues
            VAR_INPUT
                FailTime : TIME;
            END_VAR
            VAR_IN_OUT
                Res : AXOpen.Inspectors.AxoDigitalInspector;
                Tor : AXOpen.Inspectors.AxoAnalogueInspector;
                Ang : AXOpen.Inspectors.AxoAnalogueInspector;
                XCo : AXOpen.Inspectors.AxoAnalogueInspector;
                YCo : AXOpen.Inspectors.AxoAnalogueInspector;
            END_VAR;
         
            Res.Data()^.FailTime := TIME#700ms;
            Tor.Data()^.FailTime := TIME#700ms;
            Ang.Data()^.FailTime := TIME#700ms;
            XCo.Data()^.FailTime := TIME#700ms;
            YCo.Data()^.FailTime := TIME#700ms;

            Res.Data()^.PassTime := TIME#100ms;
            Tor.Data()^.PassTime := TIME#100ms;
            Ang.Data()^.PassTime := TIME#100ms;
            XCo.Data()^.PassTime := TIME#100ms;
            YCo.Data()^.PassTime := TIME#100ms;
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
