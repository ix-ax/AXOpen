USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;

{S7.extern=ReadWrite}
CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        AxoCmmtAsHwId : AXOpen.Components.Festo.Drives.AxoCmmtAsHwId;     
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
            AxoCmmtAsHwId.ActivateManualControl();
        END_IF;  

        //<Initialization>        
        AxoCmmtAsHwId.Run(  parent                :=  THIS,
                            hwID                  :=  HwIdentifiers#cmmtas_PN_IO_Interface,
                            hwIdTelegram111_In    :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12,
                            hwIdTelegram750_In    :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1,
                            hwIdTelegram111_Out   :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12,
                            hwIdTelegram750_Out   :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1,
                            MAP_HW_ID             :=  HwIdentifiers#cmmtas_DO_SERVO_1_Module_Access_Point,
                            Enable                := Enable,
                            EnablePositive        := EnablePositive,
                            EnableNegative        := EnableNegative);
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

        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

        _i := 0;
        IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
            manualControl := FALSE;
            Enable := FALSE;
            EnablePositive := FALSE;
            EnableNegative := FALSE;
            AxoCmmtAsHwId.Restore();             
            Sequencer.MoveNext();                
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
            IF(AxoCmmtAsHwId.AxoReset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
            Enable := TRUE;
            EnablePositive := TRUE;
            EnableNegative := TRUE;
            IF(AxoCmmtAsHwId.AxoPower_Status) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Drive homming')) THEN
            IF(AxoCmmtAsHwId.AxoHome(  Position        :=  LREAL#0.005,
                                        HommingMode     :=  INT#-17,
                                        Velocity        :=  LREAL#0.01,
                                        Acceleration    :=  LREAL#1.0,
                                        Deceleration    :=  LREAL#1.0
                                        ).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    
        
        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoCmmtAsHwId.ActualPosition >=0.0049 AND  AxoCmmtAsHwId.ActualPosition <=0.0051) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Set position')) THEN
            IF(AxoCmmtAsHwId.AxoSetPosition(Position :=  LREAL#0.0).IsDone()) THEN                
                Sequencer.MoveNext();       
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoCmmtAsHwId.ActualPosition >=-0.0001 AND  AxoCmmtAsHwId.ActualPosition <=0.0001) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
            IF(AxoCmmtAsHwId.AxoMoveAbsolute(  Position        :=  LREAL#0.005,
                                                Velocity        :=  LREAL#0.3,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();     
                AxoCmmtAsHwId.AxoMoveAbsolute_Task.Restore();    
                RETURN;       
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoCmmtAsHwId.ActualPosition >=0.0049 AND  AxoCmmtAsHwId.ActualPosition <=0.0051) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move additive')) THEN
            AxoCmmtAsHwId.AxoMoveAbsolute(  Position           :=  LREAL#0.010,
                                                Velocity        :=  LREAL#0.3,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0
                                                );
            IF AxoCmmtAsHwId.ActualPosition > 0.006 THEN
                AxoCmmtAsHwId.AxoMoveAdditive(  Distance        :=  LREAL#0.005,
                                                    Velocity        :=  LREAL#0.1,
                                                    Acceleration    :=  LREAL#1.0,
                                                    Deceleration    :=  LREAL#1.0,
                                                    Jerk            :=  LREAL#500.0
                                                    );
            END_IF;                                                
            IF(AxoCmmtAsHwId.AxoMoveAdditive_Task.IsDone()) THEN                
                    Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoCmmtAsHwId.ActualPosition >=0.0149 AND  AxoCmmtAsHwId.ActualPosition <=0.0151) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move relative')) THEN
            IF(AxoCmmtAsHwId.AxoMoveRelative(  Distance        :=  LREAL#-0.0050,
                                                Velocity        :=  LREAL#0.10,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoCmmtAsHwId.ActualPosition >=0.0099 AND  AxoCmmtAsHwId.ActualPosition <=0.0101) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
            AxoCmmtAsHwId.AxoReadDigitalInput(Enable := TRUE, InputNumber := 2 , Valid=> _Valid, Value => _BoolValue);
            IF(_Valid AND _BoolValue) THEN                
                Sequencer.MoveNext();                
                AxoCmmtAsHwId.AxoReadDigitalInput(Enable :=FALSE);
            END_IF;   
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
            AxoCmmtAsHwId.AxoMoveVelocity(  Velocity        :=  LREAL#0.01,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0,
                                                Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                InVelocity      => _BoolValue);
            IF(_BoolValue) THEN                
                Sequencer.MoveNext();         
                AxoCmmtAsHwId.AxoMoveVelocity_Task.Restore();
                RETURN;       
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Halt')) THEN
            IF(AxoCmmtAsHwId.AxoHalt(  Deceleration    :=  LREAL#1.0,
                                        Jerk            :=  LREAL#500.0
                                        ).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    
        
        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move velocity')) THEN
            AxoCmmtAsHwId.AxoMoveVelocity(  Velocity        :=  LREAL#0.01,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0,
                                                Direction       :=  eAxoDriveDirection#PositiveDirection,
                                                InVelocity      => _BoolValue);
            IF(_BoolValue) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Read digital input')) THEN
            AxoCmmtAsHwId.AxoReadDigitalInput(Enable := TRUE, InputNumber := 2 , Valid=> _Valid, Value => _BoolValue);
            IF(_Valid AND _BoolValue) THEN                
                Sequencer.MoveNext();                
                AxoCmmtAsHwId.AxoReadDigitalInput(Enable :=FALSE);
            END_IF;   
        END_IF;  


        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
            Enable := FALSE;
            EnablePositive := TRUE;
            EnableNegative := TRUE;
            IF(NOT AxoCmmtAsHwId.AxoPower_Status) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
            AxoCmmtAsHwId.AxoReset();
            Sequencer.MoveNext();                
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Enable drive')) THEN
            Enable := TRUE;
            EnablePositive := TRUE;
            EnableNegative := TRUE;
            IF(AxoCmmtAsHwId.AxoPower_Status) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Jog')) THEN
            manualControl := TRUE;
            AxoCmmtAsHwId.AxoJogPositive.RemoteSwitchOn := AxoCmmtAsHwId.ActualPosition <= 0.02;
            AxoCmmtAsHwId.AxoJog_Velocity      :=  LREAL#0.01;
            AxoCmmtAsHwId.AxoJog_Acceleration  :=  LREAL#1.0;
            AxoCmmtAsHwId.AxoJog_Deceleration  :=  LREAL#1.0;
            AxoCmmtAsHwId.AxoJog_Jerk          :=  LREAL#100.0;
            AxoCmmtAsHwId.AxoJog_Direction     :=  AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;

            IF(AxoCmmtAsHwId.ActualPosition > 0.02) THEN                
                AxoCmmtAsHwId.AxoJogPositive.RemoteSwitchOn := FALSE;
            END_IF;    
            IF(AxoCmmtAsHwId.ActualPosition > 0.02 AND AxoCmmtAsHwId.AxoHalt_Done) THEN                
                Sequencer.MoveNext();                
                manualControl := FALSE;
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Torque control')) THEN
            AxoCmmtAsHwId.AxoTorqueControl(     Torque          := LREAL#0.6 ,
                                            TorqueRamp      := LREAL#1.0 ,
                                            PositionLimit   :=  LREAL#0.100,
                                            Velocity        :=  LREAL#1.0,
                                            Acceleration    :=  LREAL#1.0,
                                            Deceleration    :=  LREAL#1.0,
                                            Jerk            :=  LREAL#500.0,
                                            Direction       :=  eAxoDriveDirection#PositiveDirection,
                                            InTorque      => _BoolValue);
            IF(_BoolValue) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
            IF(AxoCmmtAsHwId.ActualPosition >=0.0021) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Stop')) THEN
            AxoCmmtAsHwId.AxoStop(  Deceleration    :=  LREAL#1.0,
                                        Jerk            :=  LREAL#500.0,
                                        Done      => _BoolValue);
            IF(_BoolValue) THEN                
                Sequencer.MoveNext();   
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Release stop')) THEN
            AxoCmmtAsHwId.AxoStop_Task.Restore();
            IF(AxoCmmtAsHwId.AxoStop_Task.IsReady()) THEN                
                Sequencer.MoveNext();   
            END_IF;    
        END_IF;    

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
            IF(AxoCmmtAsHwId.AxoMoveAbsolute(  Position        :=  LREAL#0.0,
                                                Velocity        :=  LREAL#0.5,
                                                Acceleration    :=  LREAL#1.0,
                                                Deceleration    :=  LREAL#1.0,
                                                Jerk            :=  LREAL#500.0
                                                ).IsDone()) THEN                
                Sequencer.MoveNext();     
            END_IF;    
        END_IF; 

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Disable drive')) THEN
            Enable := FALSE;
            EnablePositive := FALSE;
            EnableNegative := FALSE;
            IF(NOT AxoCmmtAsHwId.AxoPower_Status) THEN                
                Sequencer.CompleteSequence();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
            IF(AxoCmmtAsHwId.AxoReset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        _i := _i + 1;
        IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
            AxoCmmtAsHwId.Restore();
            Sequencer.CompleteSequence(); 
        END_IF;
    END_METHOD
    // </Usage>
END_CLASS
