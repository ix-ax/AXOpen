USING AXOpen.Core;
NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    CLASS Component_3 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            Component : AXOpen.Components.Keyence.Vision.Axo_IV3;             
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC              
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;         
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR    

            SUPER.Run(inParent);

            IF ActivateManualControl THEN
                Component.ActivateManualControl();
            END_IF;

            //<Initialization>     
            Component.Run(      parent                                          :=   THIS,
                                hwID                                            :=   HwIdentifiers#iv3_1_HwID);
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _OverAllResult  : BOOL;
            _ResultData  :  ARRAY[0..20] OF UINT;
        END_VAR

        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                Component.Restore();
                Sequencer.MoveNext();                
            END_IF;    

            IF(Steps[1].Execute(Sequencer, 'Change program')) THEN
                IF(Component.ChangeProgram(UINT#0).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Trigger')) THEN
                IF(Component.Trigger().IsDone()) THEN                       
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'Access the result data')) THEN
                _OverAllResult := Component.Inputs.DeviceResultBits_1.OverallJudgmentOK;
                // The meaning of the result data changes with the type of the control, 
                // so it must be evaluated individually in the production code
                _ResultData[0] := Component.Inputs.ToolResult_1.MatchingRate;
                _ResultData[1] := Component.Inputs.ToolResult_1.MatchingRateMAX;
                _ResultData[2] := Component.Inputs.ToolResult_1.MatchingRateMIN;
                _ResultData[3] := Component.Inputs.ToolResult_1.LowerThreshold;
                _ResultData[4] := Component.Inputs.ToolResult_1.UpperThreshold;
                _ResultData[5] := Component.Inputs.ToolResult_1.DecimalPointPosition;
                _ResultData[6] := Component.Inputs.ToolResult_1.Data_1;
                _ResultData[7] := Component.Inputs.ToolResult_1.Data_2;
                _ResultData[8] := Component.Inputs.ToolResult_1.Data_3;
                Sequencer.CompleteSequence();                               
            END_IF;   

        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE