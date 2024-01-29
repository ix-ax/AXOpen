USING AXOpen.Components.Festo.Drives;
USING System.Timer;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        {#ix-attr:[Container(Layout.Wrap)]}
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        _manualControl  : BOOL := TRUE;          
        {#ix-set:AttributeName = "<#Enable drive signal#>"}
        Enable     : BOOL := TRUE;      
        {#ix-set:AttributeName = "<#Enable in positive direction signal#>"}
        EnablePositive : BOOL := TRUE;  
        {#ix-set:AttributeName = "<#Enable in positive negative signal#>"}
        EnableNegative   : BOOL := TRUE;        

        {#ix-attr:[Container(Layout.Stack)]}
        {#ix-set:AttributeName = "<#AxoCmmtAs#>"}
        AxoCmmtAs  : AXOpen.Components.Festo.Drives.AxoCmmtAs;
    END_VAR
    
    VAR PUBLIC    
        NumberOfCycles : ULINT := ULINT#10;                   
        Position1: LREAL := LREAL#0.010;                   
        Position2: LREAL := LREAL#0.015;    
        Velocity : LREAL := LREAL#3.0;                 
        MaxTime : TIME := TIME#5m;
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..15] OF AXOpen.Core.AxoStep;
        StartTime : LTIME;
        EndTime : LTIME;
        Cycle : ULINT;
        TotalDuration : LTIME; 
        DurationPerCycle : LTIME;

        Timer : OnDelay;        
        RunTimer : BOOL;
    END_VAR

    METHOD PROTECTED OVERRIDE Main  

        RETURN;
    
        IF(_manualControl) THEN            
            AxoCmmtAs.ActivateManualControl();
        END_IF;   
        AxoCmmtAs.Run(parent            :=  THIS,
                            hwID                  :=  HwIdentifiers#cmmtas_PN_IO_Interface,
                            hwIdTelegram111       :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12,
                            hwIdTelegram750       :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1,
                            MAP_HW_ID             :=  HwIdentifiers#cmmtas_DO_SERVO_1_Module_Access_Point,
                            Enable                := Enable,
                            EnablePositive        := EnablePositive,
                            EnableNegative        := EnableNegative);
                            
        THIS.UseInSequencer();
                            
    END_METHOD



    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
    
        Timer(signal := RunTimer, duration := MaxTime);
    
        IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
            _manualControl := FALSE;
            Enable := FALSE;
            EnablePositive := FALSE;
            EnableNegative := FALSE;
            AxoCmmtAs.Restore();             
            Sequencer.MoveNext();      
            RunTimer := FALSE;          
            RETURN;
        END_IF;
    
        IF(Steps[1].Execute(Sequencer, 'Reset drive')) THEN
            RunTimer := TRUE;          
            IF(AxoCmmtAs.AxoReset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;
    
        IF(Steps[2].Execute(Sequencer, 'Enable drive')) THEN
            Enable := TRUE;
            EnablePositive := TRUE;
            EnableNegative := TRUE;
            IF(AxoCmmtAs.AxoPower_Status) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;
    
        IF(Steps[3].Execute(Sequencer, 'Drive homming')) THEN
            IF(AxoCmmtAs.AxoHome(  Position        :=  LREAL#0.005,
                                        HommingMode     :=  INT#-17,
                                        Velocity        :=  LREAL#0.01,
                                        Acceleration    :=  LREAL#1.0,
                                        Deceleration    :=  LREAL#1.0
                                        ).IsDone()) THEN                
                Sequencer.MoveNext();    
            END_IF;    
        END_IF;    
    
        IF(Steps[4].Execute(Sequencer, 'Move absolute to start Position2')) THEN
            IF(AxoCmmtAs.AxoMoveAbsolute(   Position        :=  Position2,
                                                Velocity        :=  Velocity,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();     
            END_IF;    
        END_IF;
        
    
        IF(Steps[5].Execute(Sequencer, 'Restore component to be able to trigger next move absolute in the same PLC cycle')) THEN
            AxoCmmtAs.Restore();    
    
            StartTime := Timer.elapsedTime;
            EndTime := StartTime;
            Cycle := ULINT#0;
            TotalDuration := LTIME#0s; 
            DurationPerCycle := LTIME#0s;        
    
            Sequencer.MoveNext();     
        END_IF;
    
        IF(Steps[6].Execute(Sequencer, 'Move absolute to Position1')) THEN
            IF(AxoCmmtAs.AxoMoveAbsolute(   Position        :=  Position1,
                                                Velocity        :=  Velocity,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();     
            END_IF;    
        END_IF;    
    
        IF(Steps[7].Execute(Sequencer, 'Restore component to be able to trigger next move absolute in the same PLC cycle')) THEN
            AxoCmmtAs.Restore();    
            Sequencer.MoveNext();     
        END_IF;
    
        IF(Steps[8].Execute(Sequencer, 'Move absolute to Position1')) THEN
            IF(AxoCmmtAs.AxoMoveAbsolute(   Position        :=  Position2,
                                                Velocity        :=  Velocity,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();     
            END_IF;    
        END_IF;    
    
        IF(Steps[9].Execute(Sequencer, 'Restore component to be able to trigger next move absolute in the same PLC cycle')) THEN
            AxoCmmtAs.Restore();    
            Sequencer.MoveNext();     
        END_IF;
    
        IF(Steps[10].Execute(Sequencer, 'Repetition')) THEN
            Cycle := Cycle + ULINT#1;
            EndTime :=  Timer.elapsedTime;
            TotalDuration := EndTime - StartTime;
            DurationPerCycle := TotalDuration / Cycle;
            IF(Cycle >= NumberOfCycles) THEN                
                Sequencer.MoveNext(); 
            ELSE
                Sequencer.RequestStep(Steps[6]); 
            END_IF;    
        END_IF;    
    
        IF(Steps[11].Execute(Sequencer, 'Disable drive')) THEN
            Enable := FALSE;
            EnablePositive := FALSE;
            EnableNegative := FALSE;
            IF(NOT AxoCmmtAs.AxoPower_Status) THEN                
                Sequencer.CompleteSequence();                
            END_IF;    
        END_IF;
    
        IF(Steps[12].Execute(Sequencer, 'Reset drive')) THEN
            IF(AxoCmmtAs.AxoReset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;
    
        IF(Steps[13].Execute(Sequencer, 'Restore')) THEN
            AxoCmmtAs.Restore();
            Sequencer.CompleteSequence(); 
        END_IF;
    END_METHOD

END_CLASS
      


  