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
            Steps : ARRAY[0..40] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _Valid : BOOL;
            _BoolValue  : BOOL;
            _DintValue  : DINT;
            _RealValue  : REAL;
            ReadDigitalInput_Valid : BOOL;
            ReadDigitalInput_Value : BOOL;                
            MoveVelocity_InVelocity : BOOL;                
            MoveTorque_InTorque : BOOL;                
            Stop_Done : BOOL;                
        END_VAR
        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

            IF(Steps[2].Execute(Sequencer, TRUE, 'Restore')) THEN
                manualControl := FALSE;
                Enable := FALSE;
                EnablePositive := FALSE;
                EnableNegative := FALSE;
                CtrlXdrive.Restore();   
                Sequencer.MoveNext();                
                RETURN;
            END_IF;

            IF(Steps[3].Execute(Sequencer, TRUE, 'Reset drive')) THEN
                IF(CtrlXdrive.AxoReset().IsDone()) THEN                
                    Sequencer.MoveNext();  
                    RETURN;              
                END_IF;    
            END_IF;

            IF(Steps[4].Execute(Sequencer, TRUE, 'Enable drive')) THEN
                Enable := TRUE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(CtrlXdrive.AxoPower_Status) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[5].Execute(Sequencer, TRUE, 'Drive homming')) THEN
                IF(CtrlXdrive.AxoHome(   Position        :=  LREAL#5.0,
                                                            HommingMode     :=  INT#551,  // Negative hardware limit switch with zero pulse
                                                            Velocity        :=  LREAL#10.0,
                                                            Acceleration    :=  LREAL#1500.0,
                                                            Deceleration    :=  LREAL#1500.0
                                                            ).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;           
                END_IF;    
            END_IF;    

            IF(Steps[6].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=4.9 AND  CtrlXdrive.ActualPosition <=5.1) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[7].Execute(Sequencer, TRUE, 'Set position')) THEN
                IF(CtrlXdrive.AxoSetPosition(Position :=  LREAL#0.0).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;         
                END_IF;    
            END_IF;    

            IF(Steps[8].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=-0.1 AND  CtrlXdrive.ActualPosition <=0.1) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[9].Execute(Sequencer, TRUE, 'Move absolute')) THEN
                IF(CtrlXdrive.AxoMoveAbsolute(  ContinuousUpdate := FALSE,
                                                                    Position        :=  LREAL#5.0,
                                                                    Velocity        :=  LREAL#5.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    ).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;              
                END_IF;    
            END_IF;    

            IF(Steps[10].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=4.9 AND  CtrlXdrive.ActualPosition <=5.1) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[11].Execute(Sequencer, TRUE, 'Move absolute')) THEN
                    CtrlXdrive.AxoMoveAbsolute(  ContinuousUpdate := FALSE,
                                                                    Position        :=  LREAL#10.0,
                                                                    Velocity        :=  LREAL#1.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    );
                IF CtrlXdrive.ActualPosition > 6.0 THEN
                    // CtrlXdrive.Restore();   // commented out as we need to keep it moving after exiting this step
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    
     
            IF(Steps[12].Execute(Sequencer, TRUE, 'Move additive')) THEN
                IF CtrlXdrive.AxoMoveAdditive(   ContinuousUpdate := FALSE,
                                                                    Distance        :=  LREAL#5.0,
                                                                    Velocity        :=  LREAL#5.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    ).IsDone() THEN
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[13].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=14.9 AND  CtrlXdrive.ActualPosition <=15.1) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[14].Execute(Sequencer, TRUE, 'Move relative')) THEN
                IF(CtrlXdrive.AxoMoveRelative(   ContinuousUpdate := FALSE,
                                                                    Distance        :=  LREAL#-5.0,
                                                                    Velocity        :=  LREAL#5.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    ).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;           
                END_IF;    
            END_IF;    

            IF(Steps[15].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=9.9 AND  CtrlXdrive.ActualPosition <=10.1) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[16].Execute(Sequencer, TRUE, 'Read digital input')) THEN
                CtrlXdrive.AxoReadDigitalInput(Enable := TRUE, InputNumber := 3 , Valid=> ReadDigitalInput_Valid, Value => ReadDigitalInput_Value); // Negative limit switch
                IF(ReadDigitalInput_Valid AND ReadDigitalInput_Value) THEN        
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;                 
                END_IF;   
            END_IF;    

            IF(Steps[17].Execute(Sequencer, TRUE, 'Stop reading digital input')) THEN
                CtrlXdrive.AxoReadDigitalInput(Enable := FALSE, InputNumber := 3 , Valid=> ReadDigitalInput_Valid, Value => ReadDigitalInput_Value); // Negative limit switch
                IF(NOT ReadDigitalInput_Valid AND NOT ReadDigitalInput_Value) THEN        
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;                 
                END_IF;   
            END_IF;   
            
            IF(Steps[18].Execute(Sequencer, TRUE, 'Move velocity')) THEN
                CtrlXdrive.AxoMoveVelocity(  ContinuousUpdate := FALSE,
                                                                Velocity        :=  LREAL#2.0,
                                                                Acceleration    :=  LREAL#1500.0,
                                                                Deceleration    :=  LREAL#1500.0,
                                                                Jerk            :=  LREAL#150000.0,
                                                                Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                                InVelocity      =>  MoveVelocity_InVelocity);
                IF MoveVelocity_InVelocity THEN 
                    MoveVelocity_InVelocity := FALSE;   
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();         
                    RETURN;            
                END_IF;    
            END_IF;    

            IF(Steps[19].Execute(Sequencer, TRUE, 'Halt')) THEN
                IF(CtrlXdrive.AxoHalt(   Deceleration    :=  LREAL#1500.0,
                                                            Jerk            :=  LREAL#150000.0
                                                            ).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    
            
            IF(Steps[20].Execute(Sequencer, TRUE, 'Move velocity')) THEN
                CtrlXdrive.AxoMoveVelocity(  ContinuousUpdate := FALSE,
                                                                Velocity        :=  LREAL#2.0,
                                                                Acceleration    :=  LREAL#1500.0,
                                                                Deceleration    :=  LREAL#1500.0,
                                                                Jerk            :=  LREAL#150000.0,
                                                                Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                                InVelocity      =>  MoveVelocity_InVelocity);
                IF MoveVelocity_InVelocity THEN 
                    MoveVelocity_InVelocity := FALSE;   
                    // CtrlXdrive.Restore();  // commented out as we need to keep it moving after exiting this step
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[21].Execute(Sequencer, TRUE, 'Read digital input')) THEN
                CtrlXdrive.AxoReadDigitalInput(Enable := TRUE, InputNumber := 3 , Valid=> ReadDigitalInput_Valid, Value => ReadDigitalInput_Value); // Negative limit switch
                IF(ReadDigitalInput_Valid AND NOT ReadDigitalInput_Value) THEN                
                    CtrlXdrive.AxoReadDigitalInput(Enable :=FALSE);
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;   
            END_IF;  

            IF(Steps[22].Execute(Sequencer, TRUE, 'Stop reading digital input')) THEN
                CtrlXdrive.AxoReadDigitalInput(Enable := FALSE, InputNumber := 3 , Valid=> ReadDigitalInput_Valid, Value => ReadDigitalInput_Value); // Negative limit switch
                IF(NOT ReadDigitalInput_Valid AND NOT ReadDigitalInput_Value) THEN        
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;   
            END_IF;   

            IF(Steps[23].Execute(Sequencer, TRUE, 'Disable drive')) THEN
                Enable := FALSE;
                EnablePositive := FALSE;
                EnableNegative := FALSE;
                IF(NOT CtrlXdrive.AxoPower_Status) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[24].Execute(Sequencer, TRUE, 'Restore')) THEN
                CtrlXdrive.Restore();   
                Sequencer.MoveNext();      
                RETURN;          
            END_IF;

            IF(Steps[25].Execute(Sequencer, TRUE, 'Reset drive')) THEN
                IF(CtrlXdrive.AxoReset().IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;            

            IF(Steps[26].Execute(Sequencer, TRUE, 'Enable drive')) THEN
                Enable := TRUE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(CtrlXdrive.AxoPower_Status) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[27].Execute(Sequencer, TRUE, 'Jog')) THEN
                manualControl := TRUE;
                CtrlXdrive.AxoJogPositive.RemoteSwitchOn := TRUE;
                CtrlXdrive.AxoJog_Velocity      :=  LREAL#10.0;
                CtrlXdrive.AxoJog_Acceleration  :=  LREAL#1500.0;
                CtrlXdrive.AxoJog_Deceleration  :=  LREAL#1500.0;
                CtrlXdrive.AxoJog_Jerk          :=  LREAL#150000.0;
                CtrlXdrive.AxoJog_Direction     :=  AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;

                IF(CtrlXdrive.ActualPosition > 1.0) THEN                
                    CtrlXdrive.AxoJogPositive.RemoteSwitchOn := FALSE;
                END_IF;    
                IF( CtrlXdrive.ActualPosition > 1.0 AND 
                    CtrlXdrive.DriveState = AXOpen.Components.Drives.eAxoDriveState#Standstill AND
                    CtrlXdrive.AxoHalt_Task.IsDone()) THEN                
                    manualControl := FALSE;
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;   
            END_IF;    

            IF(Steps[28].Execute(Sequencer, TRUE, 'Torque control')) THEN
                CtrlXdrive.AxoTorqueControl( ContinuousUpdate := FALSE,
                                                                Torque    := LREAL#0.015,
                                                                TorqueRamp      :=  LREAL#1.0,
                                                                PositionLimit   :=  LREAL#50.0,
                                                                Velocity        :=  LREAL#50.0,
                                                                Acceleration    :=  LREAL#1500.0,
                                                                Deceleration    :=  LREAL#1500.0,
                                                                Jerk            :=  LREAL#150000.0,
                                                                Direction       :=  eAxoDriveDirection#PositiveDirection,
                                                                InTorque        =>  MoveTorque_InTorque);
                IF MoveTorque_InTorque THEN                
                    MoveTorque_InTorque := FALSE; 
                    // CtrlXdrive.Restore();    // commented out as we need to stay in torque up to reach the position 10.0
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[29].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(CtrlXdrive.ActualPosition >=10.0) THEN   
                    CtrlXdrive.Restore();          
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[30].Execute(Sequencer, TRUE, 'Stop')) THEN
                CtrlXdrive.AxoStop(  Deceleration    :=  LREAL#1500.0,
                                                        Jerk            :=  LREAL#150000.0,
                                                        Done            => Stop_Done);
                IF(Stop_Done) THEN 
                    Stop_Done := FALSE;               
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[31].Execute(Sequencer, TRUE, 'Release stop')) THEN
                CtrlXdrive.AxoStop_Task.Restore();
                IF(CtrlXdrive.AxoStop_Task.IsReady()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[32].Execute(Sequencer, TRUE, 'Move absolute')) THEN
                IF(CtrlXdrive.AxoMoveAbsolute(   ContinuousUpdate := FALSE,
                                                                    Position        :=  LREAL#0.0,
                                                                    Velocity        :=  LREAL#10.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    ).IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF; 

            IF(Steps[33].Execute(Sequencer, TRUE, 'Disable drive')) THEN
                Enable := FALSE;
                EnablePositive := FALSE;
                EnableNegative := FALSE;
                IF(NOT CtrlXdrive.AxoPower_Status) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[34].Execute(Sequencer, TRUE, 'Reset drive')) THEN
                IF(CtrlXdrive.AxoReset().IsDone()) THEN                
                    CtrlXdrive.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[35].Execute(Sequencer, TRUE, 'Restore')) THEN
                CtrlXdrive.Restore();   
                Sequencer.CompleteSequence();
            END_IF;

        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE