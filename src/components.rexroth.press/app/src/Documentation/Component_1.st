USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        AxoSmartFunctionKit : AXOpen.Components.Rexroth.Press.AxoSmartFunctionKit_v_4_x_x;             
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;      
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            AxoSmartFunctionKit.ActivateManualControl();
        END_IF;

        //<Initialization>        
        AxoSmartFunctionKit.Run(parent              :=  THIS,                             
                                hwID                :=  HwIdentifiers#SFK4P_1,
                                hwIdParamCh_IDN     :=  HwIdentifiers#SFK4P_1_ParamCh_IDN,
                                hwIdInput_24_Words  :=  HwIdentifiers#SFK4P_1_Input_24_Words,
                                hwIdOutput_21_Words :=  HwIdentifiers#SFK4P_1_Output_21_Words);

        AxoSmartFunctionKit.Config.InfoTime := T#10s;             
        AxoSmartFunctionKit.Config.ErrorTime := T#30s;             
        AxoSmartFunctionKit.Config.IpAddress := '10.10.10.240';             
        AxoSmartFunctionKit.Config.CurveExportLocation := 'D:\Export';             
        //</Initialization>

       THIS.UseInSequencer();
    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..10] OF AXOpen.Core.AxoStep;
        {#ix-attr:[CompilerOmits()]} 
        Request : AXOpen.Components.Rexroth.Press.AxoSmartFunctionKitRequest_v_4_x_x; 
    END_VAR

    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode:= eAxoSequenceMode#RunOnce;

        IF(Steps[0].Execute(Sequencer, 'SFK RESTORE')) THEN
            //-------------------------------------    
                ActivateManualControl := FALSE;
                AxoSmartFunctionKit.Restore();
                Sequencer.MoveNext();                
            //-------------------------------------
        END_IF;
        
        
        IF(Steps[1].Execute(Sequencer, 'SFK RESET')) THEN
            //-------------------------------------
                Request.Command := AXOpen.Components.Rexroth.Press.eAxoSmartFunctionKitCommand_v_4_x_x#ClearError; 

                IF AxoSmartFunctionKit.RunCommand(REF(Request)).IsDone() THEN
                    AxoSmartFunctionKit.Restore();
                    Sequencer.MoveNext();                
                END_IF;
            //-------------------------------------
        END_IF;

        IF(Steps[2].Execute(Sequencer, 'SFK STOP MOVEMENT')) THEN
            //-------------------------------------
                Request.Command := AXOpen.Components.Rexroth.Press.eAxoSmartFunctionKitCommand_v_4_x_x#StopMovement; 

                IF AxoSmartFunctionKit.RunCommand(REF(Request)).IsDone() THEN
                    AxoSmartFunctionKit.Restore();
                    Sequencer.MoveNext();                
                END_IF;
            //-------------------------------------
        END_IF;

        IF(Steps[3].Execute(Sequencer, 'SFK HOME')) THEN
            //-------------------------------------
                Request.Command := AXOpen.Components.Rexroth.Press.eAxoSmartFunctionKitCommand_v_4_x_x#StartHoming; 

                IF AxoSmartFunctionKit.RunCommand(REF(Request)).IsDone() THEN
                    AxoSmartFunctionKit.Restore();
                    Sequencer.MoveNext();                
                END_IF;
            //-------------------------------------
        END_IF;
        
        IF(Steps[4].Execute(Sequencer, 'SFK SET PROGRAM')) THEN
            //-------------------------------------
                Request.Command     :=  AXOpen.Components.Rexroth.Press.eAxoSmartFunctionKitCommand_v_4_x_x#SetProgramActive; 
                Request.ProgramId   :=  2; 

                IF AxoSmartFunctionKit.RunCommand(REF(Request)).IsDone() THEN
                    AxoSmartFunctionKit.Restore();
                    Sequencer.MoveNext();                
                END_IF;
            //-------------------------------------
        END_IF;

        IF(Steps[5].Execute(Sequencer, 'SFK SET SERIAL ID')) THEN
            //-------------------------------------
                Request.Command         :=  AXOpen.Components.Rexroth.Press.eAxoSmartFunctionKitCommand_v_4_x_x#StartProgram; 
                Request.SerialNumber    :=  System.Strings.Concat('Test_',System.Strings.ToString(THIS.GetContext().OpenCycleCount())); 

                Sequencer.MoveNext();                
            //-------------------------------------
        END_IF;
        
        IF(Steps[6].Execute(Sequencer, 'SFK START PROGRAM')) THEN
            //-------------------------------------
        
                IF AxoSmartFunctionKit.RunCommand(REF(Request)).IsDone() THEN
                    AxoSmartFunctionKit.Restore();
                    Sequencer.MoveNext();                
                END_IF;
            //-------------------------------------
        END_IF;
        
        IF(Steps[7].Execute(Sequencer, 'GET RESULTS')) THEN
            //-------------------------------------
            IF AxoSmartFunctionKit.GetResults().IsDone() THEN
                AxoSmartFunctionKit.Restore();
                Sequencer.MoveNext();                
            END_IF;
            //-------------------------------------
        END_IF;
        
        IF(Steps[8].Execute(Sequencer, 'EXPORT CURVE')) THEN
            //-------------------------------------
            IF AxoSmartFunctionKit.ExportCurve().IsDone() THEN
                AxoSmartFunctionKit.Restore();
                Sequencer.MoveNext();                
            END_IF;
            //-------------------------------------
        END_IF;
        
        IF(Steps[9].Execute(Sequencer, 'SEQUENCE DONE')) THEN
            //-------------------------------------
            Sequencer.CompleteSequence();          
            //-------------------------------------	
        END_IF;
            
    END_METHOD
    
    //</Usage>
END_CLASS