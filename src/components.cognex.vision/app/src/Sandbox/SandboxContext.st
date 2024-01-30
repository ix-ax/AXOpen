USING System.Timer;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Call#>"}
        Call : BOOL;     
        debug : ULINT;    
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
        Insight_7600 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;            
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;              
    END_VAR
    VAR PUBLIC    
        NumberOfCycles : ULINT := ULINT#10;                   
        MaxTime : TIME := TIME#5m;
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..8] OF AXOpen.Core.AxoStep;
        StartTime : LTIME;
        EndTime : LTIME;
        Cycle : ULINT;
        TotalDuration : LTIME; 
        DurationPerCycle : LTIME;

        Timer : OnDelay;        
        RunTimer : BOOL;
    END_VAR
    VAR PRIVATE
        _InspectionResults  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight_ResultData;
    END_VAR


    METHOD PROTECTED OVERRIDE Main
        IF NOT Call THEN
            RETURN;
        END_IF;

        IF(ActivateManualControl) THEN
            Insight_7600.ActivateManualControl();
        END_IF;    

        Insight_7600.Run(parent             :=  THIS,  
                    hwID                    :=  HwIdentifiers#_7600,
                    refAcquisitionControl   :=  REF(PlcOutputs^._7600_Acquisition_Control_1),
                    refAcquisitionStatus    :=  REF(PlcInputs^._7600_Acquisition_Status_1),
                    refInspectionControl    :=  REF(PlcOutputs^._7600_Inspection_Control_1),
                    refInspectionStatus     :=  REF(PlcInputs^._7600_Inspection_Status_1),
                    refCommandControl       :=  REF(PlcOutputs^._7600_Command_Control_1),
                    refCommandStatus        :=  REF(PlcInputs^._7600_Command_Control_1),
                    refSoftEventControl     :=  REF(PlcOutputs^._7600_SoftEvent_Control_1),
                    refSoftEventStatus      :=  REF(PlcInputs^._7600_SoftEvent_Control_1),
                    refResultData           :=  REF(PlcInputs^._7600_Results_64_bytes_1),
                    refUserData             :=  REF(PlcOutputs^._7600_User_Data_64_bytes_1));

       THIS.UseInSequencer();
    END_METHOD



    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
    
        Timer(signal := RunTimer, duration := MaxTime);
    
        IF(Steps[0].Execute(Sequencer, 'Change job')) THEN
            IF(Insight_7600.ChangeJob('jobname.job').IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Start')) THEN
    
            StartTime := Timer.elapsedTime;
            EndTime := StartTime;
            Cycle := ULINT#0;
            TotalDuration := LTIME#0s; 
            DurationPerCycle := LTIME#0s;        
    
            Sequencer.MoveNext();     
        END_IF;

        IF(Steps[2].Execute(Sequencer, 'Trigger')) THEN
            IF(Insight_7600.Trigger().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[3].Execute(Sequencer, 'Evaluate inspection results')) THEN
            _InspectionResults := Insight_7600.InspectionResults;
            Sequencer.MoveNext();                
        END_IF;       

        IF(Steps[4].Execute(Sequencer, 'Clear inspection results')) THEN
            IF(Insight_7600.ClearInspectionResults().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;     

        IF(Steps[5].Execute(Sequencer, 'Repetition')) THEN
            Cycle := Cycle + ULINT#1;
            EndTime :=  Timer.elapsedTime;
            TotalDuration := EndTime - StartTime;
            DurationPerCycle := TotalDuration / Cycle;
            IF(Cycle >= NumberOfCycles) THEN                
                Sequencer.MoveNext(); 
            ELSE
                Sequencer.RequestStep(Steps[2]); 
            END_IF;    
        END_IF;    
    
        IF(Steps[6].Execute(Sequencer, 'End')) THEN
            Sequencer.CompleteSequence();                
        END_IF;

        debug := debug + ULINT#1;
    END_METHOD
END_CLASS
      


