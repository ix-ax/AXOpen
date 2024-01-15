USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        AxoIndraDrive_ : AXOpen.Components.Rexroth.Drives.AxoIndraDrive;      
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC 
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          

        manualControl   :   BOOL;
        Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
        EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
        EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF(manualControl) THEN            
            AxoIndraDrive_.ActivateManualControl();
        END_IF;   
        //<Initialization>        
        AxoIndraDrive_.Run(parent:=THIS,
                        hwID                :=  TO_UINT(HwIdentifiers#ST3_indradrive_PN_IO),
                        refParameter_In     :=  REF(PlcInputs^.ST3_indradrive_ParamCh_IDN_1 ),
                        refFieldbus_In      :=  REF(PlcInputs^.ST3_indradrive_Input_9_Words_1),
                        refParameter_Out    :=  REF(PlcOutputs^.ST3_indradrive_ParamCh_IDN_1),
                        refFieldbus_Out     :=  REF(PlcOutputs^.ST3_indradrive_Output_13_Words_1),
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

        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

        _i := 0;
        IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
            manualControl := FALSE;
            AxoIndraDrive_.Restore();             
            Sequencer.MoveNext();                
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
            IF(AxoIndraDrive_.AxoReset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
            Enable := TRUE;
            EnablePositive := TRUE;
            EnableNegative := TRUE;
            IF(AxoIndraDrive_.AxoPower_Status) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Drive homming')) THEN
            IF(AxoIndraDrive_.AxoHome(  Position        :=  LREAL#5.0,
                                        HommingMode     :=  INT#551,
                                        Velocity        :=  LREAL#1.0,
                                        Acceleration    :=  LREAL#50.0,
                                        Deceleration    :=  LREAL#50.0
                                        ).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    
        
        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoIndraDrive_.ActualPosition >=4.9 AND  AxoIndraDrive_.ActualPosition <=5.1) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Set position')) THEN
            IF(AxoIndraDrive_.AxoSetPosition(Position :=  LREAL#0.0).IsDone()) THEN                
                Sequencer.MoveNext();       
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoIndraDrive_.ActualPosition >=-0.1 AND  AxoIndraDrive_.ActualPosition <=0.1) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
            IF(AxoIndraDrive_.AxoMoveAbsolute(  Position        :=  LREAL#5.0,
                                                Velocity        :=  LREAL#10.0,
                                                Acceleration    :=  LREAL#50.0,
                                                Deceleration    :=  LREAL#50.0,
                                                Jerk            :=  LREAL#50.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();     
                AxoIndraDrive_.AxoMoveAbsolute_Task.Restore();    
                RETURN;       
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoIndraDrive_.ActualPosition >=4.9 AND  AxoIndraDrive_.ActualPosition <=5.1) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move additive')) THEN
            AxoIndraDrive_.AxoMoveAbsolute(  Position           :=  LREAL#10.0,
                                                Velocity        :=  LREAL#10.0,
                                                Acceleration    :=  LREAL#50.0,
                                                Deceleration    :=  LREAL#50.0,
                                                Jerk            :=  LREAL#50.0
                                                );
            IF AxoIndraDrive_.ActualPosition > 6.0 THEN
                AxoIndraDrive_.AxoMoveAdditive(  Distance        :=  LREAL#5.0,
                                                    Velocity        :=  LREAL#1.0,
                                                    Acceleration    :=  LREAL#50.0,
                                                    Deceleration    :=  LREAL#50.0,
                                                    Jerk            :=  LREAL#50.0
                                                    );
            END_IF;                                                
            IF(AxoIndraDrive_.AxoMoveAdditive_Task.IsDone()) THEN                
                    Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoIndraDrive_.ActualPosition >=14.9 AND  AxoIndraDrive_.ActualPosition <=15.1) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move relative')) THEN
            IF(AxoIndraDrive_.AxoMoveRelative(  Distance        :=  LREAL#-5.0,
                                                Velocity        :=  LREAL#10.0,
                                                Acceleration    :=  LREAL#50.0,
                                                Deceleration    :=  LREAL#50.0,
                                                Jerk            :=  LREAL#50.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoIndraDrive_.ActualPosition >=9.9 AND  AxoIndraDrive_.ActualPosition <=10.1) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
            AxoIndraDrive_.AxoReadDigitalInput(Enable := TRUE, InputNumber := 4 , Valid=> _Valid, Value => _BoolValue);
            IF(_Valid AND _BoolValue) THEN                
                Sequencer.MoveNext();                
                AxoIndraDrive_.AxoReadDigitalInput(Enable :=FALSE);
            END_IF;   
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
            AxoIndraDrive_.AxoMoveVelocity(  Velocity        :=  LREAL#2.0,
                                                Acceleration    :=  LREAL#50.0,
                                                Deceleration    :=  LREAL#50.0,
                                                Jerk            :=  LREAL#50.0,
                                                Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                InVelocity      => _BoolValue);
            IF(_BoolValue) THEN                
                Sequencer.MoveNext();         
                AxoIndraDrive_.AxoMoveVelocity_Task.Restore();
                RETURN;       
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Halt')) THEN
            IF(AxoIndraDrive_.AxoHalt(  Deceleration    :=  LREAL#50.0,
                                        Jerk            :=  LREAL#50.0
                                        ).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    
        
        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
            AxoIndraDrive_.AxoMoveVelocity(  Velocity        :=  LREAL#2.0,
                                                Acceleration    :=  LREAL#50.0,
                                                Deceleration    :=  LREAL#50.0,
                                                Jerk            :=  LREAL#50.0,
                                                Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                InVelocity      => _BoolValue);
            IF(_BoolValue) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
            AxoIndraDrive_.AxoReadDigitalInput(Enable := TRUE, InputNumber := 4 , Valid=> _Valid, Value => _BoolValue);
            IF(_Valid AND NOT _BoolValue) THEN                
                Sequencer.MoveNext();                
                AxoIndraDrive_.AxoReadDigitalInput(Enable :=FALSE);
            END_IF;   
        END_IF;  


        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
            Enable := FALSE;
            EnablePositive := TRUE;
            EnableNegative := TRUE;
            IF(NOT AxoIndraDrive_.AxoPower_Status) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
            AxoIndraDrive_.AxoReset();
            Sequencer.MoveNext();                
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
            Enable := TRUE;
            EnablePositive := TRUE;
            EnableNegative := TRUE;
            IF(AxoIndraDrive_.AxoPower_Status) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Jog')) THEN
            manualControl := TRUE;
            AxoIndraDrive_.AxoJogPositive.RemoteSwitchOn := TRUE;
            AxoIndraDrive_.AxoJog_Velocity      :=  LREAL#1.0;
            AxoIndraDrive_.AxoJog_Acceleration  :=  LREAL#5.0;
            AxoIndraDrive_.AxoJog_Deceleration  :=  LREAL#5.0;
            AxoIndraDrive_.AxoJog_Jerk          :=  LREAL#10.0;
            AxoIndraDrive_.AxoJog_Direction     :=  AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;

            IF(AxoIndraDrive_.ActualPosition > 0) THEN                
                Sequencer.MoveNext();                
                AxoIndraDrive_.AxoJogPositive.RemoteSwitchOn := FALSE;
                manualControl := FALSE;
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Torque control')) THEN
            AxoIndraDrive_.AxoTorqueControl(Torque          := LREAL#9.5 ,
                                            PositionLimit   :=  LREAL#100.0,
                                            Velocity        :=  LREAL#50.0,
                                            Acceleration    :=  LREAL#50.0,
                                            Deceleration    :=  LREAL#50.0,
                                            Jerk            :=  LREAL#50.0,
                                            Direction       :=  eAxoDriveDirection#PositiveDirection,
                                            InTorque      => _BoolValue);
            IF(_BoolValue) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoIndraDrive_.ActualPosition >=10.0) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Stop')) THEN
            AxoIndraDrive_.AxoStop(  Deceleration    :=  LREAL#50.0,
                                        Jerk            :=  LREAL#50.0,
                                        Done      => _BoolValue);
            IF(_BoolValue) THEN                
                Sequencer.MoveNext();   
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Release stop')) THEN
            AxoIndraDrive_.AxoStop_Task.Restore();
            IF(AxoIndraDrive_.AxoStop_Task.IsReady()) THEN                
                Sequencer.MoveNext();   
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
            IF(AxoIndraDrive_.AxoMoveAbsolute(  Position        :=  LREAL#0.0,
                                                Velocity        :=  LREAL#50.0,
                                                Acceleration    :=  LREAL#50.0,
                                                Deceleration    :=  LREAL#50.0,
                                                Jerk            :=  LREAL#50.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();     
            END_IF;    
        END_IF; 

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
            Enable := FALSE;
            EnablePositive := FALSE;
            EnableNegative := FALSE;
            IF(NOT AxoIndraDrive_.AxoPower_Status) THEN                
                Sequencer.CompleteSequence();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
            IF(AxoIndraDrive_.AxoReset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
            AxoIndraDrive_.Restore();
            Sequencer.CompleteSequence(); 
        END_IF;
    END_METHOD
    //</Usage>
END_CLASS
