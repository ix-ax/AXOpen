USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;

{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        AxoCmmtAsPtP_ : AXOpen.Components.Festo.Drives.AxoCmmtAsPtP;     
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC                
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          

        manualControl   :   BOOL;
        Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        //<Initialization>        
        AxoCmmtAsPtP_.Run(parent                :=  THIS,
                          refTelegram111_In     :=  REF(PlcInputs^.cmmtas_docu_DO_SERVO_1_Siemens_telegram_111_PZD_12_12),
                          refTelegram750_In     :=  REF(PlcInputs^.cmmtas_docu_DO_SERVO_1_Siemens_telegram_750_PZD_4_1),
                          refTelegram111_Out    :=  REF(PlcOutputs^.cmmtas_docu_DO_SERVO_1_Siemens_telegram_111_PZD_12_12),
                          refTelegram750_Out    :=  REF(PlcOutputs^.cmmtas_docu_DO_SERVO_1_Siemens_telegram_750_PZD_4_1),
                          MAP_HW_ID             :=  HwIdentifiers#cmmtas_docu_Module_Access_Point,
                          Enable                :=  Enable);

        //</Initialization>

    //    THIS.UseInSequencer();
    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..30] OF AXOpen.Core.AxoStep;
    END_VAR

    VAR PRIVATE
        _Valid : BOOL;
        _BoolValue  : BOOL;
        _DintValue  : DINT;
        _RealValue  : REAL;
        _i          : INT;
    END_VAR
    // METHOD PRIVATE UseInSequencer   

    //     Sequencer.Initialize(THIS);
    //     Sequencer.Open();
    //     Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

    //     _i := 0;
    //     IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
    //         manualControl := FALSE;
    //         IF(AxoCmmtAsPtP_.RestoreTask.Invoke().IsDone()) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
    //         IF(AxoCmmtAsPtP_.AxoReset().IsDone()) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
    //         Enable := TRUE;
    //         EnablePositive := TRUE;
    //         EnableNegative := TRUE;
    //         IF(AxoCmmtAsPtP_.AxoPower_Status) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Drive homming')) THEN
    //         IF(AxoCmmtAsPtP_.AxoHome(  Position        :=  LREAL#5.0,
    //                                     HommingMode     :=  INT#551,
    //                                     Velocity        :=  LREAL#1.0,
    //                                     Acceleration    :=  LREAL#50.0,
    //                                     Deceleration    :=  LREAL#50.0
    //                                     ).IsDone()) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    
        
    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
    //         IF(AxoCmmtAsPtP_.ActualPosition >=4.9 AND  AxoCmmtAsPtP_.ActualPosition <=5.1) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Set position')) THEN
    //         IF(AxoCmmtAsPtP_.AxoSetPosition(Position :=  LREAL#0.0).IsDone()) THEN                
    //             Sequencer.MoveNext();       
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
    //         IF(AxoCmmtAsPtP_.ActualPosition >=-0.1 AND  AxoCmmtAsPtP_.ActualPosition <=0.1) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
    //         IF(AxoCmmtAsPtP_.AxoMoveAbsolute(  Position        :=  LREAL#5.0,
    //                                             Velocity        :=  LREAL#10.0,
    //                                             Acceleration    :=  LREAL#50.0,
    //                                             Deceleration    :=  LREAL#50.0,
    //                                             Jerk            :=  LREAL#50.0
    //                                             ).IsDone()) THEN                
    //             Sequencer.MoveNext();     
    //             AxoCmmtAsPtP_.AxoMoveAbsolute_Task.Restore();    
    //             RETURN;       
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
    //         IF(AxoCmmtAsPtP_.ActualPosition >=4.9 AND  AxoCmmtAsPtP_.ActualPosition <=5.1) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Move additive')) THEN
    //         AxoCmmtAsPtP_.AxoMoveAbsolute(  Position           :=  LREAL#10.0,
    //                                             Velocity        :=  LREAL#10.0,
    //                                             Acceleration    :=  LREAL#50.0,
    //                                             Deceleration    :=  LREAL#50.0,
    //                                             Jerk            :=  LREAL#50.0
    //                                             );
    //         IF AxoCmmtAsPtP_.ActualPosition > 6.0 THEN
    //             AxoCmmtAsPtP_.AxoMoveAdditive(  Distance        :=  LREAL#5.0,
    //                                                 Velocity        :=  LREAL#1.0,
    //                                                 Acceleration    :=  LREAL#50.0,
    //                                                 Deceleration    :=  LREAL#50.0,
    //                                                 Jerk            :=  LREAL#50.0
    //                                                 );
    //         END_IF;                                                
    //         IF(AxoCmmtAsPtP_.AxoMoveAdditive_Task.IsDone()) THEN                
    //                 Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
    //         IF(AxoCmmtAsPtP_.ActualPosition >=14.9 AND  AxoCmmtAsPtP_.ActualPosition <=15.1) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Move relative')) THEN
    //         IF(AxoCmmtAsPtP_.AxoMoveRelative(  Distance        :=  LREAL#-5.0,
    //                                             Velocity        :=  LREAL#10.0,
    //                                             Acceleration    :=  LREAL#50.0,
    //                                             Deceleration    :=  LREAL#50.0,
    //                                             Jerk            :=  LREAL#50.0
    //                                             ).IsDone()) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
    //         IF(AxoCmmtAsPtP_.ActualPosition >=9.9 AND  AxoCmmtAsPtP_.ActualPosition <=10.1) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
    //         AxoCmmtAsPtP_.AxoReadDigitalInput(Enable := TRUE, InputNumber := 4 , Valid=> _Valid, Value => _BoolValue);
    //         IF(_Valid AND _BoolValue) THEN                
    //             Sequencer.MoveNext();                
    //             AxoCmmtAsPtP_.AxoReadDigitalInput(Enable :=FALSE);
    //         END_IF;   
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
    //         AxoCmmtAsPtP_.AxoMoveVelocity(  Velocity        :=  LREAL#2.0,
    //                                             Acceleration    :=  LREAL#50.0,
    //                                             Deceleration    :=  LREAL#50.0,
    //                                             Jerk            :=  LREAL#50.0,
    //                                             Direction       :=  eAxoDriveDirection#NegativeDirection,
    //                                             InVelocity      => _BoolValue);
    //         IF(_BoolValue) THEN                
    //             Sequencer.MoveNext();         
    //             AxoCmmtAsPtP_.AxoMoveVelocity_Task.Restore();
    //             RETURN;       
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Halt')) THEN
    //         IF(AxoCmmtAsPtP_.AxoHalt(  Deceleration    :=  LREAL#50.0,
    //                                     Jerk            :=  LREAL#50.0
    //                                     ).IsDone()) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    
        
    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
    //         AxoCmmtAsPtP_.AxoMoveVelocity(  Velocity        :=  LREAL#2.0,
    //                                             Acceleration    :=  LREAL#50.0,
    //                                             Deceleration    :=  LREAL#50.0,
    //                                             Jerk            :=  LREAL#50.0,
    //                                             Direction       :=  eAxoDriveDirection#NegativeDirection,
    //                                             InVelocity      => _BoolValue);
    //         IF(_BoolValue) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
    //         AxoCmmtAsPtP_.AxoReadDigitalInput(Enable := TRUE, InputNumber := 4 , Valid=> _Valid, Value => _BoolValue);
    //         IF(_Valid AND NOT _BoolValue) THEN                
    //             Sequencer.MoveNext();                
    //             AxoCmmtAsPtP_.AxoReadDigitalInput(Enable :=FALSE);
    //         END_IF;   
    //     END_IF;  


    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
    //         Enable := FALSE;
    //         EnablePositive := TRUE;
    //         EnableNegative := TRUE;
    //         IF(NOT AxoCmmtAsPtP_.AxoPower_Status) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
    //         AxoCmmtAsPtP_.AxoReset();
    //         Sequencer.MoveNext();                
    //     END_IF;

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
    //         Enable := TRUE;
    //         EnablePositive := TRUE;
    //         EnableNegative := TRUE;
    //         IF(AxoCmmtAsPtP_.AxoPower_Status) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Jog')) THEN
    //         manualControl := TRUE;
    //         AxoCmmtAsPtP_.AxoJogPositive.RemoteSwitchOn := TRUE;
    //         AxoCmmtAsPtP_.AxoJog_Velocity      :=  LREAL#1.0;
    //         AxoCmmtAsPtP_.AxoJog_Acceleration  :=  LREAL#5.0;
    //         AxoCmmtAsPtP_.AxoJog_Deceleration  :=  LREAL#5.0;
    //         AxoCmmtAsPtP_.AxoJog_Jerk          :=  LREAL#10.0;
    //         AxoCmmtAsPtP_.AxoJog_Direction     :=  AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;

    //         IF(AxoCmmtAsPtP_.ActualPosition > 0) THEN                
    //             Sequencer.MoveNext();                
    //             AxoCmmtAsPtP_.AxoJogPositive.RemoteSwitchOn := FALSE;
    //             manualControl := FALSE;
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Torque control')) THEN
    //         AxoCmmtAsPtP_.AxoTorqueControl(Torque          := LREAL#9.5 ,
    //                                         Velocity        :=  LREAL#50.0,
    //                                         Acceleration    :=  LREAL#50.0,
    //                                         Deceleration    :=  LREAL#50.0,
    //                                         Jerk            :=  LREAL#50.0,
    //                                         Direction       :=  eAxoDriveDirection#PositiveDirection,
    //                                         InTorque      => _BoolValue);
    //         IF(_BoolValue) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
    //         IF(AxoCmmtAsPtP_.ActualPosition >=10.0) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Stop')) THEN
    //         AxoCmmtAsPtP_.AxoStop(  Deceleration    :=  LREAL#50.0,
    //                                     Jerk            :=  LREAL#50.0,
    //                                     Done      => _BoolValue);
    //         IF(_BoolValue) THEN                
    //             Sequencer.MoveNext();   
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Release stop')) THEN
    //         AxoCmmtAsPtP_.AxoStop_Task.Restore();
    //         IF(AxoCmmtAsPtP_.AxoStop_Task.IsReady()) THEN                
    //             Sequencer.MoveNext();   
    //         END_IF;    
    //     END_IF;    

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
    //         IF(AxoCmmtAsPtP_.AxoMoveAbsolute(  Position        :=  LREAL#0.0,
    //                                             Velocity        :=  LREAL#50.0,
    //                                             Acceleration    :=  LREAL#50.0,
    //                                             Deceleration    :=  LREAL#50.0,
    //                                             Jerk            :=  LREAL#50.0
    //                                             ).IsDone()) THEN                
    //             Sequencer.MoveNext();     
    //         END_IF;    
    //     END_IF; 

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
    //         Enable := FALSE;
    //         EnablePositive := FALSE;
    //         EnableNegative := FALSE;
    //         IF(NOT AxoCmmtAsPtP_.AxoPower_Status) THEN                
    //             Sequencer.CompleteSequence();                
    //         END_IF;    
    //     END_IF;

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
    //         IF(AxoCmmtAsPtP_.AxoReset().IsDone()) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;

    //     _i := _i + 1;
    //     IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
    //         IF(AxoCmmtAsPtP_.RestoreTask.Invoke().IsDone()) THEN                
    //             Sequencer.MoveNext();                
    //         END_IF;    
    //     END_IF;
    // END_METHOD
    //</Usage>
END_CLASS
