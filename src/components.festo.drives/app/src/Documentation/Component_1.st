USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;

NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            AxoCmmtAs : AXOpen.Components.Festo.Drives.AxoCmmtAs;     
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
            // RETURN;

            SUPER.Run(parent);

            IF(manualControl) THEN            
                AxoCmmtAs.ActivateManualControl();
            END_IF;  

            //<Initialization>        
            AxoCmmtAs.Run(parent            :=  THIS,
                            hwID                  :=    HwIdentifiers#cmmtas_HwID,
                            Enable                :=    Enable,
                            EnablePositive        :=    EnablePositive,
                            EnableNegative        :=    EnableNegative);
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
            _TaskState  :   IAxoTaskState;
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
                AxoCmmtAs.Restore();             
                Sequencer.MoveNext();                
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
                IF(AxoCmmtAs.AxoReset().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
                Enable := TRUE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(AxoCmmtAs.AxoPower_Status) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Drive homming')) THEN
                IF(AxoCmmtAs.AxoHome(  Position        :=  LREAL#5.0,
                                            HommingMode     :=  INT#-17,
                                            Velocity        :=  LREAL#1.0,
                                            Acceleration    :=  LREAL#1500.0,
                                            Deceleration    :=  LREAL#1500.0
                                            ).IsDone()) THEN                
                    Sequencer.MoveNext();                
                    AxoCmmtAs.Restore(); 
                END_IF;    
            END_IF;    
            
            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=4.9 AND  AxoCmmtAs.ActualPosition <=5.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Set position')) THEN
                IF(AxoCmmtAs.AxoSetPosition(Position :=  LREAL#0.0).IsDone()) THEN                
                    Sequencer.MoveNext();       
                    AxoCmmtAs.Restore();             
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=-0.1 AND  AxoCmmtAs.ActualPosition <=0.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
                IF(AxoCmmtAs.AxoMoveAbsolute(  Position        :=  LREAL#5.0,
                                                    Velocity        :=  LREAL#5.0,
                                                    Acceleration    :=  LREAL#1500.0,
                                                    Deceleration    :=  LREAL#1500.0,
                                                    Jerk            :=  LREAL#50.0
                                                    ).IsDone()) THEN                
                    Sequencer.MoveNext();     
                    AxoCmmtAs.Restore();    
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=4.9 AND  AxoCmmtAs.ActualPosition <=5.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move additive')) THEN
                AxoCmmtAs.AxoMoveAbsolute(  Position           :=  LREAL#10.0,
                                                    Velocity        :=  LREAL#5.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0
                                                    );
                IF AxoCmmtAs.ActualPosition > 6.0 THEN
                    AxoCmmtAs.AxoMoveAdditive(  Distance        :=  LREAL#5.0,
                                                        Velocity        :=  LREAL#1.0,
                                                        Acceleration    :=  LREAL#50.0,
                                                        Deceleration    :=  LREAL#50.0,
                                                        Jerk            :=  LREAL#50.0
                                                        );
                END_IF;                                                
                IF(AxoCmmtAs.AxoMoveAdditive_Task.IsDone()) THEN                
                        Sequencer.MoveNext();                
                        AxoCmmtAs.Restore();    
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=14.9 AND  AxoCmmtAs.ActualPosition <=15.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move relative')) THEN
                IF(AxoCmmtAs.AxoMoveRelative(  Distance        :=  LREAL#-5.0,
                                                    Velocity        :=  LREAL#5.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0
                                                    ).IsDone()) THEN                
                    Sequencer.MoveNext();
                    AxoCmmtAs.Restore();    
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=9.9 AND  AxoCmmtAs.ActualPosition <=10.1) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
                AxoCmmtAs.AxoReadDigitalInput(Enable := TRUE, InputNumber := 2 , Valid=> _Valid, Value => _BoolValue);
                IF(_Valid AND _BoolValue) THEN                
                    Sequencer.MoveNext();                
                    AxoCmmtAs.AxoReadDigitalInput(Enable :=FALSE);
                    AxoCmmtAs.Restore();             
                END_IF;   
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
                AxoCmmtAs.AxoMoveVelocity(  Velocity        :=  LREAL#2.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0,
                                                    Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                    InVelocity      => _BoolValue);
                IF(_BoolValue) THEN                
                    Sequencer.MoveNext();         
                    AxoCmmtAs.Restore();    
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Halt')) THEN
                IF(AxoCmmtAs.AxoHalt(   Deceleration    :=  LREAL#50.0,
                                        Jerk           :=  LREAL#50.0
                                        ).IsDone()) THEN                
                    Sequencer.MoveNext();                
                    AxoCmmtAs.Restore();             
                    RETURN;
                END_IF;    
            END_IF;    
            
            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
                AxoCmmtAs.AxoMoveVelocity(  Velocity        :=  LREAL#2.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0,
                                                    Direction       :=  eAxoDriveDirection#PositiveDirection,
                                                    InVelocity      => _BoolValue);
                IF(_BoolValue) THEN                
                    Sequencer.MoveNext();                
                    AxoCmmtAs.Restore();             
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
                AxoCmmtAs.AxoReadDigitalInput(Enable := TRUE, InputNumber := 2 , Valid=> _Valid, Value => _BoolValue);
                IF(_Valid AND _BoolValue) THEN                
                    Sequencer.MoveNext();                
                    AxoCmmtAs.AxoReadDigitalInput(Enable :=FALSE);
                    AxoCmmtAs.Restore();             
                END_IF;   
            END_IF;  

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
                Enable := FALSE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(NOT AxoCmmtAs.AxoPower_Status) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
                AxoCmmtAs.AxoReset();
                Sequencer.MoveNext();                
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
                Enable := TRUE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(AxoCmmtAs.AxoPower_Status) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Jog')) THEN
                manualControl := TRUE;
                AxoCmmtAs.AxoJogPositive.RemoteSwitchOn := TRUE;
                AxoCmmtAs.AxoJog_Velocity      :=  LREAL#1.0;
                AxoCmmtAs.AxoJog_Acceleration  :=  LREAL#5.0;
                AxoCmmtAs.AxoJog_Deceleration  :=  LREAL#5.0;
                AxoCmmtAs.AxoJog_Jerk          :=  LREAL#10.0;
                AxoCmmtAs.AxoJog_Direction     :=  AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;

                IF(AxoCmmtAs.ActualPosition > 0.0) THEN                
                    AxoCmmtAs.AxoJogPositive.RemoteSwitchOn := FALSE;
                END_IF;    
                IF(AxoCmmtAs.ActualPosition > 0.0 AND AxoCmmtAs.DriveState = AXOpen.Components.Drives.eAxoDriveState#Standstill) THEN                
                    Sequencer.MoveNext();                
                    manualControl := FALSE;
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Torque control')) THEN
                AxoCmmtAs.AxoTorqueControl(     Torque          :=  LREAL#0.015,
                                                TorqueRamp      :=  LREAL#1.0,
                                                PositionLimit   :=  LREAL#50.0,
                                                Velocity        :=  LREAL#50.0,
                                                Acceleration    :=  LREAL#50.0,
                                                Deceleration    :=  LREAL#50.0,
                                                Jerk            :=  LREAL#50.0,
                                                Direction       :=  eAxoDriveDirection#PositiveDirection,
                                                InTorque      => _BoolValue);
                IF(_BoolValue) THEN                
                    //AxoCmmtAs.Restore();  //  removed due to we want to stay in torque up to reach the position 10.0  
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=10.0) THEN     
                    AxoCmmtAs.Restore();    // moved here from the previous step              
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Stop')) THEN
                AxoCmmtAs.AxoStop(  Deceleration    :=  LREAL#50.0,
                                            Jerk            :=  LREAL#50.0,
                                            Done      => _BoolValue);
                IF(_BoolValue) THEN                
                    Sequencer.MoveNext();   
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Release stop')) THEN
                AxoCmmtAs.AxoStop_Task.Restore();
                IF(AxoCmmtAs.AxoStop_Task.IsReady()) THEN                
                    Sequencer.MoveNext();   
                END_IF;    
            END_IF;    

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
                IF(AxoCmmtAs.AxoMoveAbsolute(  Position        :=  LREAL#0.0,
                                                    Velocity        :=  LREAL#10.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0
                                                    ).IsDone()) THEN                
                    Sequencer.MoveNext();     
                    AxoCmmtAs.Restore();    
                END_IF;    
            END_IF; 

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
                Enable := FALSE;
                EnablePositive := FALSE;
                EnableNegative := FALSE;
                IF(NOT AxoCmmtAs.AxoPower_Status) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
                IF(AxoCmmtAs.AxoReset().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            _i := _i + 1;
            IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
                AxoCmmtAs.Restore();
                Sequencer.CompleteSequence(); 
            END_IF;
        END_METHOD
        // </Usage>
    END_CLASS
END_NAMESPACE