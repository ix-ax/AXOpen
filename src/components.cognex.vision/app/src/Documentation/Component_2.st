USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        testDataman : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;     
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;              
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            //<DatamanManualControl>
            testDataman.ActivateManualControl();
            //</DatamanManualControl>
        END_IF;

        //<Initialization>        
        testDataman.Run(parent                     :=  THIS,  
                        hwID                       :=  HwIdentifiers#_10a1,
                        refAcquisitionControl      :=  REF(PlcOutputs^._10a1_Acquisition_Control_1),
                        refAcquisitionStatus       :=  REF(PlcInputs^._10a1_Acquisition_Status_1),
                        refResultsControl          :=  REF(PlcOutputs^._10a1_Results_Control_1),
                        refResultsStatus           :=  REF(PlcInputs^._10a1_Results_Status_1),
                        refSoftEventControl        :=  REF(PlcOutputs^._10a1_Soft_Event_Control_1),
                        refSoftEventStatus         :=  REF(PlcInputs^._10a1_Soft_Event_Control_1),
                        refResultData              :=  REF(PlcInputs^._10a1_Result_Data_128_bytes_1),
                        refUserData                :=  REF(PlcOutputs^._10a1_User_Data_128_bytes_1));
        //</Initialization>

       THIS.UseInSequencer();
    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..4] OF AXOpen.Core.AxoStep;
    END_VAR

    VAR PRIVATE
        _ResultData  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman_ResultData;
    END_VAR

    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
        Sequencer.Open();

        
        IF(Steps[0].Execute(Sequencer, 'Clear result data')) THEN
            IF(testDataman.ClearResultData().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;  

        IF(Steps[1].Execute(Sequencer, 'Change job')) THEN
            IF(testDataman.Read().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[2].Execute(Sequencer, 'Evaluate data')) THEN
            _ResultData := testDataman.ResultData;
            Sequencer.MoveNext();                
        END_IF;       
  

    END_METHOD
    
    //</Usage>
END_CLASS
