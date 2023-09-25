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

            ProcessDataManager : REF_TO ProcessDataManger;

            SettingSourceData : REF_TO FragmentProcessData;

            SettingSourceManager : AXOpen.DATA.IAxoDataExchange;

            StationName : REF_TO STRING;

            LastGeneratedId : STRING;

            EntityHeader : REF_TO SharedProductionData;
            ProcessData  : REF_TO FragmentProcessData;
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
            Components          := _components;
            ProcessDataManager  := _processDataManager;
            StationName         := _StationName;
            SettingSourceData   := _SettingSourceData;
            SettingSourceManager := _SettingSourceManager;

            EntityHeader := REF(ProcessDataManager^.Shared.Set);
            ProcessData := REF(ProcessDataManager^.DataManger.Set);

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
            IF (Components = NULL OR ProcessDataManager = NULL) THEN
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

            IF (Steps[1].Execute(THIS, TRUE, 'COPY DATA AND GENERATE ID')) THEN
                //-------------------------------------------------------            
                THIS.CreateId();
                
                ProcessData^ :=  SettingSourceData^;
                EntityHeader^.EntityResult.Result := AXOpen.Inspectors.eOverallResult#NoAction;


                THIS.SetScrewDefaultValues( 
                    PassTime := TIME#150ms,
                    Res    := ProcessData^.Res_Screw_0,
                    Tor    := ProcessData^.Tor_Screw_0,
                    Ang    := ProcessData^.Ang_Screw_0,
                    XCo    := ProcessData^.XCo_Screw_0,
                    YCo    := ProcessData^.YCo_Screw_0
                );

                THIS.SetScrewDefaultValues( 
                    PassTime := TIME#200ms,
                    Res    := ProcessData^.Res_Screw_1,
                    Tor    := ProcessData^.Tor_Screw_1,
                    Ang    := ProcessData^.Ang_Screw_1,
                    XCo    := ProcessData^.XCo_Screw_1,
                    YCo    := ProcessData^.YCo_Screw_1
                );

                THIS.SetScrewDefaultValues( 
                    PassTime := TIME#300ms,
                    Res    := ProcessData^.Res_Screw_2,
                    Tor    := ProcessData^.Tor_Screw_2,
                    Ang    := ProcessData^.Ang_Screw_2,
                    XCo    := ProcessData^.XCo_Screw_2,
                    YCo    := ProcessData^.YCo_Screw_2
                );

                THIS.SetScrewDefaultValues( 
                    PassTime := TIME#400ms,
                    Res    := ProcessData^.Res_Screw_3,
                    Tor    := ProcessData^.Tor_Screw_3,
                    Ang    := ProcessData^.Ang_Screw_3,
                    XCo    := ProcessData^.XCo_Screw_3,
                    YCo    := ProcessData^.YCo_Screw_3
                );

                THIS.SetScrewDefaultValues( 
                    PassTime := TIME#500ms,
                    Res    := ProcessData^.Res_Screw_4,
                    Tor    := ProcessData^.Tor_Screw_4,
                    Ang    := ProcessData^.Ang_Screw_4,
                    XCo    := ProcessData^.XCo_Screw_4,
                    YCo    := ProcessData^.YCo_Screw_4
                );

                THIS.RestCheckResult(Res := ProcessData^.Camera_0, FailTime := TIME#300ms, PassTime := TIME#200ms);
                THIS.RestCheckResult(Res := ProcessData^.Camera_1, FailTime := TIME#300ms, PassTime := TIME#200ms);

                THIS.RestCheckResult(Res := ProcessData^.Reader_0, FailTime := TIME#300ms, PassTime := TIME#200ms);
                THIS.RestCheckResult(Res := ProcessData^.Reader_1, FailTime := TIME#300ms, PassTime := TIME#200ms);

                THIS.RestCheckResult(Res := ProcessData^.Traca__0, FailTime := TIME#300ms, PassTime := TIME#200ms);
                THIS.RestCheckResult(Res := ProcessData^.Traca__1, FailTime := TIME#300ms, PassTime := TIME#200ms);

                ProcessDataManager^.Restore();

                ProcessData^.CounterDelay := ProcessData^.CounterDelay + ULINT#100;

                THIS.MoveNext();
                //-------------------------------------------------------            
            END_IF;

            IF (Steps[2].Execute(THIS, TRUE, 'ProcessData-Create')) THEN
                //-------------------------------------------------------            
                IF (ProcessDataManager^.CreateOrUpdate(LastGeneratedId).IsDone()) THEN
                    THIS.MoveNext();
                    ProcessDataManager^.Restore();
                END_IF;
                //-------------------------------------------------------
            END_IF;


            IF (Steps[3].Execute(THIS, TRUE, 'ProcessData-Read')) THEN
                //-------------------------------------------------------            
                IF (ProcessDataManager^.Read(LastGeneratedId).IsDone()) THEN
                    THIS.MoveNext();
                    ProcessDataManager^.Restore();
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

                    IF CurrentStep.Duration > TIME#1S THEN 
                        THIS.MoveNext(); 
                    END_IF;
                //-------------------------------------------------------
            END_IF; 


            IF (Steps[7].Execute(THIS, TRUE, 'SOM OPERATIONS..' )) THEN
                //-------------------------------------------------------  
                    Components^.Camera_0.Trigger();
                    Components^.Camera_1.Trigger();

                    IF CurrentStep.Duration > TIME#1S THEN 
                        THIS.MoveNext(); 
                    END_IF;
                //-------------------------------------------------------
            END_IF; 

            THIS.Screwins_1Screw_Steps(StepIndex := 10,
                    Res    := ProcessData^.Res_Screw_0,
                    Tor    := ProcessData^.Tor_Screw_0,
                    Ang    := ProcessData^.Ang_Screw_0,
                    XCo    := ProcessData^.XCo_Screw_0,
                    YCo    := ProcessData^.YCo_Screw_0
            );

            THIS.Screwins_1Screw_Steps(StepIndex := 20,
                    Res    := ProcessData^.Res_Screw_1,
                    Tor    := ProcessData^.Tor_Screw_1,
                    Ang    := ProcessData^.Ang_Screw_1,
                    XCo    := ProcessData^.XCo_Screw_1,
                    YCo    := ProcessData^.YCo_Screw_1
            );


            THIS.Screwins_1Screw_Steps(StepIndex := 30,
                    Res    := ProcessData^.Res_Screw_2,
                    Tor    := ProcessData^.Tor_Screw_2,
                    Ang    := ProcessData^.Ang_Screw_2,
                    XCo    := ProcessData^.XCo_Screw_2,
                    YCo    := ProcessData^.YCo_Screw_2
            );

            THIS.Screwins_1Screw_Steps(StepIndex := 40,
                    Res    := ProcessData^.Res_Screw_3,
                    Tor    := ProcessData^.Tor_Screw_3,
                    Ang    := ProcessData^.Ang_Screw_3,
                    XCo    := ProcessData^.XCo_Screw_3,
                    YCo    := ProcessData^.YCo_Screw_3
            );

            IF (Steps[50].Execute(THIS, TRUE, 'ALL CYLINDER STOP, DONE' )) THEN
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

                        IF CurrentStep.Duration > TIME#1S THEN 
                            THIS.MoveNext(); 
                        END_IF; 

                    END_IF;
                //-------------------------------------------------------
            END_IF; 

            IF (Steps[52].Execute(THIS, TRUE, 'ALL PISTONS TO WORKPOS' )) THEN
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

                    IF CurrentStep.Duration > TIME#1S THEN 
                        THIS.MoveNext(); 
                    END_IF;
                //-------------------------------------------------------
            END_IF; 

            THIS.Screwins_1Screw_Steps(StepIndex := 60,
                    Res    := ProcessData^.Res_Screw_4,
                    Tor    := ProcessData^.Tor_Screw_4,
                    Ang    := ProcessData^.Ang_Screw_4,
                    XCo    := ProcessData^.XCo_Screw_4,
                    YCo    := ProcessData^.YCo_Screw_4
            );


            IF (Steps[72].Execute(THIS, TRUE, 'RESET CAMERA' )) THEN
                //-------------------------------------------------------  
                    // Components^.Camera_0.ChangeJob('1').IsDone();
                    // Components^.Camera_1.ChangeJob('1').IsDone();

                    IF CurrentStep.Duration > TIME#1S THEN 
                        THIS.MoveNext(); 
                        ProcessData^.CounterDelay := ProcessData^.CounterDelay + ULINT#5000;
                    END_IF;
                //-------------------------------------------------------
            END_IF; 

            
            IF (Steps[75].Execute(THIS, TRUE, 'Update data to db')) THEN
                //-------------------------------------------------------            
                IF (ProcessDataManager^.Update(LastGeneratedId).IsDone()) THEN
                    THIS.MoveNext();
                    ProcessDataManager^.Restore();
                END_IF;
                //-------------------------------------------------------
            END_IF;

            IF (Steps[76].Execute(THIS, TRUE, 'Delay' )) THEN
                //-------------------------------------------------------  
                    IF CurrentStep.Duration > TIME#5S THEN 
                        THIS.MoveNext(); 
                    END_IF;
                //-------------------------------------------------------
            END_IF; 
            
            // This will close the sequence and will return to the first step.
            THIS.Close(Steps[80]);
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
            END_VAR

                IF (Steps[StepIndex + 0].Execute(THIS, TRUE, 'SCREWING')) THEN
                    //-------------------------------------------------------            
                    IF CurrentStep.Duration > TIME#1S THEN 
                        THIS.MoveNext(); 
                        ProcessData^.CounterDelay := ProcessData^.CounterDelay + ULINT#1;
                    END_IF;
                    //-------------------------------------------------------
                END_IF;

                IF (Steps[StepIndex + 1].Execute(THIS, TRUE, 'Inspect-Res')) THEN
                    //-------------------------------------------------------
                    Res.WithCoordinator(THIS).Inspect(THIS,false  ).UpdateComprehensiveResult( EntityHeader^.EntityResult ).OnFail().CarryOn();
                    //-------------------------------------------------------
                END_IF;

                IF (Steps[StepIndex + 2].Execute(THIS, TRUE, 'Inspect-Tor')) THEN
                    //-------------------------------------------------------
                    Tor.WithCoordinator(THIS).Inspect(THIS, 1      ).UpdateComprehensiveResult( EntityHeader^.EntityResult ).OnFail().CarryOn();
                    //-------------------------------------------------------
                END_IF;

                IF (Steps[StepIndex + 3].Execute(THIS, TRUE, 'Inspect-Ang')) THEN
                    //-------------------------------------------------------
                    Ang.WithCoordinator(THIS).Inspect(THIS,2      ).UpdateComprehensiveResult( EntityHeader^.EntityResult ).OnFail().CarryOn();
                    //-------------------------------------------------------
                END_IF;

                IF (Steps[StepIndex + 4].Execute(THIS, TRUE, 'Inspect-X')) THEN
                    //-------------------------------------------------------
                    XCo.WithCoordinator(THIS).Inspect(THIS,3     ).UpdateComprehensiveResult( EntityHeader^.EntityResult ).OnFail().CarryOn();
                    //-------------------------------------------------------
                END_IF;

                IF (Steps[StepIndex + 5].Execute(THIS, TRUE, 'Inspect -Y')) THEN
                    //-------------------------------------------------------
                    YCo.WithCoordinator(THIS).Inspect(THIS,4     ).UpdateComprehensiveResult( EntityHeader^.EntityResult ).OnFail().CarryOn();
                    //-------------------------------------------------------
                END_IF;
                
        END_METHOD   

        METHOD INTERNAL SetScrewDefaultValues
            VAR_INPUT
                PassTime : TIME;
            END_VAR
            VAR_IN_OUT
                Res : AXOpen.Inspectors.AxoDigitalInspector;
                Tor : AXOpen.Inspectors.AxoAnalogueInspector;
                Ang : AXOpen.Inspectors.AxoAnalogueInspector;
                XCo : AXOpen.Inspectors.AxoAnalogueInspector;
                YCo : AXOpen.Inspectors.AxoAnalogueInspector;
            END_VAR;
         
           THIS.RestCheckResult(Res := Res, FailTime := PassTime + TIME#200ms, PassTime := PassTime);
           THIS.RestCheckResult(Res := Tor, FailTime := PassTime + TIME#200ms, PassTime := PassTime);
           THIS.RestCheckResult(Res := Ang, FailTime := PassTime + TIME#200ms, PassTime := PassTime);
           THIS.RestCheckResult(Res := XCo, FailTime := PassTime + TIME#200ms, PassTime := PassTime);
           THIS.RestCheckResult(Res := YCo, FailTime := PassTime + TIME#200ms, PassTime := PassTime);
        END_METHOD

        METHOD INTERNAL CreateId
            LastGeneratedId := Concat(StationName^, '_', ToString(THIS.GetContext().OpenCycleCount()));
        END_METHOD

        METHOD INTERNAL RestCheckResult
            VAR_INPUT
                FailTime : TIME;
                PassTime : TIME;
            END_VAR
            VAR_IN_OUT
                Res : AXOpen.Inspectors.AxoDigitalInspector;
            END_VAR;
         
            Res.Data()^.NumberOfAllowedRetries := UINT#10;

            Res.Data()^.FailTime := FailTime;
            Res.Data()^.PassTime := PassTime;
            Res.Data()^.Result :=  AXOpen.Inspectors.eInspectorResult#NoAction;;
        END_METHOD

        METHOD INTERNAL RestCheckResult
            VAR_INPUT
                FailTime : TIME;
                PassTime : TIME;
            END_VAR
            VAR_IN_OUT
                Res : AXOpen.Inspectors.AxoAnalogueInspector;
            END_VAR;
         
            Res.Data()^.NumberOfAllowedRetries := UINT#10;
            Res.Data()^.RequiredMin := -100.0;
            Res.Data()^.RequiredMax := 100.0;

            Res.Data()^.FailTime := FailTime;
            Res.Data()^.PassTime := PassTime;
            Res.Data()^.Result :=  AXOpen.Inspectors.eInspectorResult#NoAction;;
        END_METHOD

        METHOD INTERNAL RestCheckResult
            VAR_INPUT
                FailTime : TIME;
                PassTime : TIME;
            END_VAR
            VAR_IN_OUT
                Res : AXOpen.Inspectors.AxoDataInspector;
            END_VAR;
         
            Res.Data()^.NumberOfAllowedRetries := UINT#10;
            Res.Data()^.DetectedStatus := 'NotDetected';

            Res.Data()^.FailTime := FailTime;
            Res.Data()^.PassTime := PassTime;
            Res.Data()^.Result :=  AXOpen.Inspectors.eInspectorResult#NoAction;
        END_METHOD





    END_CLASS
END_NAMESPACE
