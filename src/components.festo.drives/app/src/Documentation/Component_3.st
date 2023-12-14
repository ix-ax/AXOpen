USING AXOpen.Components.Abstractions.Drives;
USING AXOpen.Core;

{S7.extern=ReadWrite}
CLASS Component_3 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        AxoCmmtAs : AXOpen.Components.Festo.Drives.AxoCmmtAs;     
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC                
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          

        run_            :   BOOL := FALSE;
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

        IF NOT run_ THEN
            RETURN;
        END_IF;

        THIS.Initialize(parent);

        IF(manualControl) THEN            
            AxoCmmtAs.ActivateManualControl();
        END_IF;  

        //<Initialization>        
        AxoCmmtAs.Run(  parent                :=  THIS,
                            refTelegram111_In     :=  REF(PlcInputs^.cmmtas_test_DO_SERVO_1_Siemens_telegram_111_PZD_12_12),
                            refTelegram750_In     :=  REF(PlcInputs^.cmmtas_test_DO_SERVO_1_Siemens_telegram_750_PZD_4_1),
                            refTelegram111_Out    :=  REF(PlcOutputs^.cmmtas_test_DO_SERVO_1_Siemens_telegram_111_PZD_12_12),
                            refTelegram750_Out    :=  REF(PlcOutputs^.cmmtas_test_DO_SERVO_1_Siemens_telegram_750_PZD_4_1),
                            MAP_HW_ID             :=  HwIdentifiers#cmmtas_test_Module_Access_Point,
                            Enable                := Enable,
                            EnablePositive        := EnablePositive,
                            EnableNegative        := EnableNegative);
        //</Initialization>
        THIS.UseInSequencer();

    END_METHOD
    
    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..16] OF AXOpen.Core.AxoStep;
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

        // _i := 0;
        // IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
        //     manualControl := FALSE;
        //     // IF(AxoCmmtAsPtP_.ComponentRestore().IsDone()) THEN   

        //     //            IF(AxoCmmtAsPtP_.Restore_Task.Invoke().IsDone()) THEN   
        //     AxoCmmtAs.Restore();
        //         Sequencer.MoveNext();                
        //     // END_IF;    
        // END_IF;

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
        //     IF(AxoCmmtAs.Reset().IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Drive homming')) THEN
        //     IF(AxoCmmtAs.Home().IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;    
        
        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
        //     IF(AxoCmmtAs.ActualPosition >=-0.1 AND  AxoCmmtAs.ActualPosition <=0.1) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
        //     IF(AxoCmmtAs.MoveAbsolute(Position := LREAL#5.0 , Velocity := LREAL#10.0).IsDone()) THEN                
        //         Sequencer.MoveNext();     
        //         AxoCmmtAs.MoveAbsolute_Task.Restore();    
        //         RETURN;       
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
        //     IF(AxoCmmtAs.ActualPosition >=4.9 AND  AxoCmmtAs.ActualPosition <=5.1) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Move relative')) THEN
        //     IF(AxoCmmtAs.MoveRelative(Distance := LREAL#5.0 , Velocity := LREAL#10.0).IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Check position')) THEN
        //     IF(AxoCmmtAs.ActualPosition >=9.9 AND  AxoCmmtAs.ActualPosition <=10.1) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Jog positive')) THEN
        //     manualControl := TRUE;
        //     AxoCmmtAs.JogPositive_Task.RemoteSwitchOn := TRUE;

        //     IF(AxoCmmtAs.ActualPosition > 21.0) THEN                
        //         Sequencer.MoveNext();                
        //         AxoCmmtAs.JogPositive_Task.RemoteSwitchOn := FALSE;
        //         manualControl := FALSE;
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Jog negative')) THEN
        //     manualControl := TRUE;
        //     AxoCmmtAs.JogNegative_Task.RemoteSwitchOn := TRUE;

        //     IF(AxoCmmtAs.ActualPosition < 20.0) THEN                
        //         Sequencer.MoveNext();                
        //         AxoCmmtAs.JogNegative_Task.RemoteSwitchOn := FALSE;
        //         manualControl := FALSE;
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Stop')) THEN
        //     IF (AxoCmmtAs.Stop().IsDone()) THEN
        //         Sequencer.MoveNext();   
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Travel to fixed stop')) THEN
        //     _TaskState := AxoCmmtAs.TravelToFixStop(Position := LREAL#100.0 , Velocity := LREAL#5.0 , Torque := LREAL#0.5);
        //     Steps[_i].ThrowWhen(_TaskState.HasError());
        //     IF _TaskState.IsDone() OR _TaskState.HasError() THEN
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Reset drive')) THEN
        //     IF(AxoCmmtAs.Reset().IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Move absolute')) THEN
        //     IF(AxoCmmtAs.MoveAbsolute(Position := LREAL#0.0 , Velocity := LREAL#20.0).IsDone()) THEN                
        //         Sequencer.MoveNext();     
        //     END_IF;    
        // END_IF; 

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Drive homming')) THEN
        //     IF(AxoCmmtAs.Home().IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;    

        // _i := _i + 1;
        // IF(Steps[_i].Execute(Sequencer, 'Restore')) THEN
        //     manualControl := FALSE;
        //     IF(AxoCmmtAs.Restore_Task.Invoke().IsDone()) THEN                
        //         Sequencer.CompleteSequence();                
        //     END_IF;    
        // END_IF;
    END_METHOD
    // </Usage>
END_CLASS
