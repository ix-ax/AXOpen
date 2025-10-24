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
                inParent : IAxoObject;
            END_VAR    
            // RETURN;

            SUPER.Run(inParent);

            IF(manualControl) THEN            
                AxoCmmtAs.ActivateManualControl();
            END_IF;  

            //<Initialization>        
            AxoCmmtAs.Run(parent            :=  THIS,
                            hwID                  :=    HwIdentifiers#festo_cmmtas_HwID,
                            Enable                :=    Enable,
                            EnablePositive        :=    EnablePositive,
                            EnableNegative        :=    EnableNegative);
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
            _TaskState  :   IAxoTaskState;
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
                AxoCmmtAs.Restore();   
                Sequencer.MoveNext();                
                RETURN;
            END_IF;

            IF(Steps[3].Execute(Sequencer, TRUE, 'Reset drive')) THEN
                IF(AxoCmmtAs.AxoReset().IsDone()) THEN                
                    Sequencer.MoveNext();  
                    RETURN;              
                END_IF;    
            END_IF;

            IF(Steps[4].Execute(Sequencer, TRUE, 'Enable drive')) THEN
                Enable := TRUE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(AxoCmmtAs.AxoPower_Status) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[5].Execute(Sequencer, TRUE, 'Drive homming')) THEN
                IF(AxoCmmtAs.AxoHome(   Position        :=  LREAL#5.0,
                                                            HommingMode     :=  INT#1,  // Negative hardware limit switch with zero pulse
                                                            Velocity        :=  LREAL#10.0,
                                                            Acceleration    :=  LREAL#1500.0,
                                                            Deceleration    :=  LREAL#1500.0
                                                            ).IsDone()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;           
                END_IF;    
            END_IF;    

            IF(Steps[6].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=4.9 AND  AxoCmmtAs.ActualPosition <=5.1) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[7].Execute(Sequencer, TRUE, 'Set position')) THEN
                IF(AxoCmmtAs.AxoSetPosition(Position :=  LREAL#0.0).IsDone()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;         
                END_IF;    
            END_IF;    

            IF(Steps[8].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=-0.1 AND  AxoCmmtAs.ActualPosition <=0.1) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[9].Execute(Sequencer, TRUE, 'Move absolute')) THEN
                IF(AxoCmmtAs.AxoMoveAbsolute(  ContinuousUpdate := FALSE,
                                                                    Position        :=  LREAL#5.0,
                                                                    Velocity        :=  LREAL#5.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    ).IsDone()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;              
                END_IF;    
            END_IF;    

            IF(Steps[10].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=4.9 AND  AxoCmmtAs.ActualPosition <=5.1) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[11].Execute(Sequencer, TRUE, 'Move absolute')) THEN
                    AxoCmmtAs.AxoMoveAbsolute(  ContinuousUpdate := FALSE,
                                                                    Position        :=  LREAL#10.0,
                                                                    Velocity        :=  LREAL#1.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    );
                IF AxoCmmtAs.ActualPosition > 6.0 THEN
                    // AxoCmmtAs.Restore();   // commented out as we need to keep it moving after exiting this step
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    
     
            IF(Steps[12].Execute(Sequencer, TRUE, 'Move additive')) THEN
                IF AxoCmmtAs.AxoMoveAdditive(   ContinuousUpdate := FALSE,
                                                                    Distance        :=  LREAL#5.0,
                                                                    Velocity        :=  LREAL#5.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    ).IsDone() THEN
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[13].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=14.9 AND  AxoCmmtAs.ActualPosition <=15.1) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[14].Execute(Sequencer, TRUE, 'Move relative')) THEN
                IF(AxoCmmtAs.AxoMoveRelative(   ContinuousUpdate := FALSE,
                                                                    Distance        :=  LREAL#-5.0,
                                                                    Velocity        :=  LREAL#5.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    ).IsDone()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;           
                END_IF;    
            END_IF;    

            IF(Steps[15].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=9.9 AND  AxoCmmtAs.ActualPosition <=10.1) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[16].Execute(Sequencer, TRUE, 'Read digital input')) THEN
                AxoCmmtAs.AxoReadDigitalInput(Enable := TRUE, InputNumber := 38 , Valid=> ReadDigitalInput_Valid, Value => ReadDigitalInput_Value); // 38~~X1C.7  Negative limit switch
                IF(ReadDigitalInput_Valid AND ReadDigitalInput_Value) THEN        
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;                 
                END_IF;   
            END_IF;    

            IF(Steps[17].Execute(Sequencer, TRUE, 'Stop reading digital input')) THEN
                AxoCmmtAs.AxoReadDigitalInput(Enable := FALSE, InputNumber := 38 , Valid=> ReadDigitalInput_Valid, Value => ReadDigitalInput_Value); // 38~~X1C.7  Negative limit switch
                IF(NOT ReadDigitalInput_Valid AND NOT ReadDigitalInput_Value) THEN        
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;                 
                END_IF;   
            END_IF;   
            
            IF(Steps[18].Execute(Sequencer, TRUE, 'Move velocity')) THEN
                AxoCmmtAs.AxoMoveVelocity(  ContinuousUpdate := FALSE,
                                                                Velocity        :=  LREAL#2.0,
                                                                Acceleration    :=  LREAL#1500.0,
                                                                Deceleration    :=  LREAL#1500.0,
                                                                Jerk            :=  LREAL#150000.0,
                                                                Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                                InVelocity      =>  MoveVelocity_InVelocity);
                IF MoveVelocity_InVelocity THEN 
                    MoveVelocity_InVelocity := FALSE;   
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();         
                    RETURN;            
                END_IF;    
            END_IF;    

            IF(Steps[19].Execute(Sequencer, TRUE, 'Halt')) THEN
                IF(AxoCmmtAs.AxoHalt(   Deceleration    :=  LREAL#1500.0,
                                                            Jerk            :=  LREAL#150000.0
                                                            ).IsDone()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    
            
            IF(Steps[20].Execute(Sequencer, TRUE, 'Move velocity')) THEN
                AxoCmmtAs.AxoMoveVelocity(  ContinuousUpdate := FALSE,
                                                                Velocity        :=  LREAL#2.0,
                                                                Acceleration    :=  LREAL#1500.0,
                                                                Deceleration    :=  LREAL#1500.0,
                                                                Jerk            :=  LREAL#150000.0,
                                                                Direction       :=  eAxoDriveDirection#NegativeDirection,
                                                                InVelocity      =>  MoveVelocity_InVelocity);
                IF MoveVelocity_InVelocity THEN 
                    MoveVelocity_InVelocity := FALSE;   
                    // AxoCmmtAs.Restore();  // commented out as we need to keep it moving after exiting this step
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[21].Execute(Sequencer, TRUE, 'Read digital input')) THEN
                AxoCmmtAs.AxoReadDigitalInput(Enable := TRUE, InputNumber := 38 , Valid=> ReadDigitalInput_Valid, Value => ReadDigitalInput_Value); // 38~~X1C.7  Negative limit switch
                IF(ReadDigitalInput_Valid AND NOT ReadDigitalInput_Value) THEN                
                    AxoCmmtAs.AxoReadDigitalInput(Enable :=FALSE);
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;   
            END_IF;  

            IF(Steps[22].Execute(Sequencer, TRUE, 'Stop reading digital input')) THEN
                AxoCmmtAs.AxoReadDigitalInput(Enable := FALSE, InputNumber := 38 , Valid=> ReadDigitalInput_Valid, Value => ReadDigitalInput_Value); // 38~~X1C.7  Negative limit switch
                IF(NOT ReadDigitalInput_Valid AND NOT ReadDigitalInput_Value) THEN        
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;   
            END_IF;   

            IF(Steps[23].Execute(Sequencer, TRUE, 'Disable drive')) THEN
                Enable := FALSE;
                EnablePositive := FALSE;
                EnableNegative := FALSE;
                IF(NOT AxoCmmtAs.AxoPower_Status) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[24].Execute(Sequencer, TRUE, 'Restore')) THEN
                AxoCmmtAs.Restore();   
                Sequencer.MoveNext();      
                RETURN;          
            END_IF;

            IF(Steps[25].Execute(Sequencer, TRUE, 'Reset drive')) THEN
                IF(AxoCmmtAs.AxoReset().IsDone()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;            

            IF(Steps[26].Execute(Sequencer, TRUE, 'Enable drive')) THEN
                Enable := TRUE;
                EnablePositive := TRUE;
                EnableNegative := TRUE;
                IF(AxoCmmtAs.AxoPower_Status) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[27].Execute(Sequencer, TRUE, 'Jog')) THEN
                manualControl := TRUE;
                AxoCmmtAs.AxoJogPositive.RemoteSwitchOn := TRUE;
                AxoCmmtAs.AxoJog_Velocity      :=  LREAL#10.0;
                AxoCmmtAs.AxoJog_Acceleration  :=  LREAL#1500.0;
                AxoCmmtAs.AxoJog_Deceleration  :=  LREAL#1500.0;
                AxoCmmtAs.AxoJog_Jerk          :=  LREAL#150000.0;
                AxoCmmtAs.AxoJog_Direction     :=  AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection;

                IF(AxoCmmtAs.ActualPosition > 1.0) THEN                
                    AxoCmmtAs.AxoJogPositive.RemoteSwitchOn := FALSE;
                END_IF;    
                IF( AxoCmmtAs.ActualPosition > 1.0 AND 
                    AxoCmmtAs.DriveState = AXOpen.Components.Drives.eAxoDriveState#Standstill AND
                    AxoCmmtAs.AxoHalt_Task.IsDone()) THEN                
                    manualControl := FALSE;
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;  
            END_IF;    

            IF(Steps[28].Execute(Sequencer, TRUE, 'Torque control')) THEN
                AxoCmmtAs.AxoTorqueControl( ContinuousUpdate := FALSE,
                                                                Torque    := LREAL#0.1,
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
                    // AxoCmmtAs.Restore();    // commented out as we need to stay in torque up to reach the position 10.0
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[29].Execute(Sequencer, TRUE, 'Check position')) THEN
                IF(AxoCmmtAs.ActualPosition >=10.0) THEN   
                    AxoCmmtAs.Restore();          
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[30].Execute(Sequencer, TRUE, 'Stop')) THEN
                AxoCmmtAs.AxoStop(  Deceleration    :=  LREAL#1500.0,
                                                        Jerk            :=  LREAL#150000.0,
                                                        Done            => Stop_Done);
                IF(Stop_Done) THEN 
                    Stop_Done := FALSE;               
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[31].Execute(Sequencer, TRUE, 'Release stop')) THEN
                AxoCmmtAs.AxoStop_Task.Restore();
                IF(AxoCmmtAs.AxoStop_Task.IsReady()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;    

            IF(Steps[32].Execute(Sequencer, TRUE, 'Move absolute')) THEN
                IF(AxoCmmtAs.AxoMoveAbsolute(   ContinuousUpdate := FALSE,
                                                                    Position        :=  LREAL#0.0,
                                                                    Velocity        :=  LREAL#10.0,
                                                                    Acceleration    :=  LREAL#1500.0,
                                                                    Deceleration    :=  LREAL#1500.0,
                                                                    Jerk            :=  LREAL#150000.0
                                                                    ).IsDone()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF; 

            IF(Steps[33].Execute(Sequencer, TRUE, 'Disable drive')) THEN
                Enable := FALSE;
                EnablePositive := FALSE;
                EnableNegative := FALSE;
                IF(NOT AxoCmmtAs.AxoPower_Status) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[34].Execute(Sequencer, TRUE, 'Reset drive')) THEN
                IF(AxoCmmtAs.AxoReset().IsDone()) THEN                
                    AxoCmmtAs.Restore();   
                    Sequencer.MoveNext();       
                    RETURN;   
                END_IF;    
            END_IF;

            IF(Steps[35].Execute(Sequencer, TRUE, 'Restore')) THEN
                AxoCmmtAs.Restore();   
                Sequencer.CompleteSequence();
            END_IF;

        END_METHOD
        // </Usage>
    END_CLASS
END_NAMESPACE