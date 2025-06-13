USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;

NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            CtrlXdrive : AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXsc;      
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC 
            manualControl   :   BOOL;
            Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
            EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    
            
            SUPER.Run(parent);

            IF(manualControl) THEN            
                CtrlXdrive.ActivateManualControl();
            END_IF;   
            //<Initialization>        
            CtrlXdrive.Run(parent               :=  THIS,
                            hwID                :=  HwIdentifiers#AxoCtrlxDriveXsc_HwID,
                            Enable              :=  Enable,
                            EnablePositive      :=  EnablePositive,
                            EnableNegative      :=  EnableNegative);
            //</Initialization>

        THIS.UseInSequencer();
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
        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

            _i := 0;
            IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
                manualControl := FALSE;
                Enable := FALSE;
                EnablePositive := FALSE;
                EnableNegative := FALSE;
                CtrlXdrive.Restore();   
                Sequencer.MoveNext();                
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
                IF(CtrlXdrive.AxoReset().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
                Enable := TRUE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(CtrlXdrive.AxoPower_Status) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Drive homming')) THEN
                IF(CtrlXdrive.AxoHome(  Position        :=  LREAL#5.0,
                                            HommingMode     :=  INT#551,
                                            Velocity        :=  LREAL#1.0,
                                            Acceleration    :=  LREAL#50.0,
                                            Deceleration    :=  LREAL#50.0
                                            ).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    
            
            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=4.9 AND  CtrlXdrive.ActualPosition <=5.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Set position')) THEN
                IF(CtrlXdrive.AxoSetPosition(Position :=  LREAL#0.0).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=-0.1 AND  CtrlXdrive.ActualPosition <=0.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
                IF(CtrlXdrive.AxoMoveAbsolute(  Position        :=  LREAL#5.0,
                                                    Velocity        :=  LREAL#10.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0
                                                    ).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();     
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=4.9 AND  CtrlXdrive.ActualPosition <=5.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move additive')) THEN
                CtrlXdrive.AxoMoveAbsolute(  Position           :=  LREAL#10.0,
                                                    Velocity        :=  LREAL#10.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0
                                                    );
                IF CtrlXdrive.ActualPosition > 6.0 THEN
                    CtrlXdrive.AxoMoveAdditive(  Distance        :=  LREAL#5.0,
                                                        Velocity        :=  LREAL#1.0,
                                                        Acceleration    :=  LREAL#50.0,
                                                        Deceleration    :=  LREAL#50.0,
                                                        Jerk            :=  LREAL#50.0
                                                        );
                END_IF;                                                
                IF(CtrlXdrive.AxoMoveAdditive_Task.IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=14.9 AND  CtrlXdrive.ActualPosition <=15.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move relative')) THEN
                IF(CtrlXdrive.AxoMoveRelative(  Distance        :=  LREAL#-5.0,
                                                    Velocity        :=  LREAL#10.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0
                                                    ).IsDone()) THEN                
                                                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=9.9 AND  CtrlXdrive.ActualPosition <=10.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
                CtrlXdrive.AxoReadDigitalInput(Enable := TRUE, InputNumber := 4 , Valid=> _Valid, Value => _BoolValue);
                IF(_Valid AND _BoolValue) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();                
                    CtrlXdrive.AxoReadDigitalInput(Enable :=FALSE);
                END_IF;   
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
                CtrlXdrive.AxoMoveVelocity(  Velocity        :=  LREAL#2.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0,
                                                    Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                    InVelocity      => _BoolValue);
                IF(_BoolValue) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();         
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Halt')) THEN
                IF(CtrlXdrive.AxoHalt(  Deceleration    :=  LREAL#50.0,
                                            Jerk            :=  LREAL#50.0
                                            ).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    
            
            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
                CtrlXdrive.AxoMoveVelocity(  Velocity        :=  LREAL#2.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0,
                                                    Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                    InVelocity      => _BoolValue);
                IF(_BoolValue) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
                CtrlXdrive.AxoReadDigitalInput(Enable := TRUE, InputNumber := 4 , Valid=> _Valid, Value => _BoolValue);
                IF(_Valid AND NOT _BoolValue) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();                
                    CtrlXdrive.AxoReadDigitalInput(Enable :=FALSE);
                END_IF;   
            END_IF;  


            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
                Enable := FALSE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(NOT CtrlXdrive.AxoPower_Status) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
                CtrlXdrive.AxoReset();
                Sequencer.MoveNext();                
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
                Enable := TRUE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(CtrlXdrive.AxoPower_Status) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Jog')) THEN
                manualControl := TRUE;
                CtrlXdrive.AxoJogPositive.RemoteSwitchOn := TRUE;
                CtrlXdrive.AxoJog_Velocity      :=  LREAL#1.0;
                CtrlXdrive.AxoJog_Acceleration  :=  LREAL#5.0;
                CtrlXdrive.AxoJog_Deceleration  :=  LREAL#5.0;
                CtrlXdrive.AxoJog_Jerk          :=  LREAL#10.0;
                CtrlXdrive.AxoJog_Direction     :=  AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;

                IF(CtrlXdrive.ActualPosition > 0) THEN                
                    Sequencer.MoveNext();                
                    CtrlXdrive.AxoJogPositive.RemoteSwitchOn := FALSE;
                    manualControl := FALSE;
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Torque control')) THEN
                CtrlXdrive.AxoTorqueControl(Torque          := LREAL#9.5 ,
                                                PositionLimit   :=  LREAL#100.0,
                                                Velocity        :=  LREAL#50.0,
                                                Acceleration    :=  LREAL#50.0,
                                                Deceleration    :=  LREAL#50.0,
                                                Jerk            :=  LREAL#50.0,
                                                Direction       :=  eAxoDriveDirection#PositiveDirection,
                                                InTorque      => _BoolValue);
                IF(_BoolValue) THEN                
                    // CtrlXdrive.Restore();    removed due to we want to stay in torque up to reach the position 10.0
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=10.0) THEN   
                    CtrlXdrive.Restore(); // moved here from the prevous step             
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Stop')) THEN
                CtrlXdrive.AxoStop(  Deceleration    :=  LREAL#50.0,
                                            Jerk            :=  LREAL#50.0,
                                            Done      => _BoolValue);
                IF(_BoolValue) THEN                
                    Sequencer.MoveNext();   
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Release stop')) THEN
                CtrlXdrive.AxoStop_Task.Restore();
                IF(CtrlXdrive.AxoStop_Task.IsReady()) THEN                
                    Sequencer.MoveNext();   
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
                IF(CtrlXdrive.AxoMoveAbsolute(  Position        :=  LREAL#0.0,
                                                    Velocity        :=  LREAL#50.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0
                                                    ).IsDone()) THEN                
                                                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();     
                END_IF;    
            END_IF; 

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
                Enable := FALSE;
                EnablePositive := FALSE;
                EnableNegative := FALSE;
                IF(NOT CtrlXdrive.AxoPower_Status) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
                IF(CtrlXdrive.AxoReset().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
                CtrlXdrive.Restore();   
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE