USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_3 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        Dataman_300 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;     
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
            Dataman_300.ActivateManualControl();
            //</DatamanManualControl>
        END_IF;

        //<Initialization>        
        Dataman_300.Run(parent                     :=  THIS,  
                        hwID                       :=  HwIdentifiers#reader_st2,
                        refAcquisitionControl      :=  REF(PlcOutputs^.reader_st2_Acquisition_Control_1),
                        refAcquisitionStatus       :=  REF(PlcInputs^.reader_st2_Acquisition_Status_1),
                        refResultsControl          :=  REF(PlcOutputs^.reader_st2_Results_Control_1),
                        refResultsStatus           :=  REF(PlcInputs^.reader_st2_Results_Status_1),
                        refSoftEventControl        :=  REF(PlcOutputs^.reader_st2_Soft_Event_Control_1),
                        refSoftEventStatus         :=  REF(PlcInputs^.reader_st2_Soft_Event_Control_1),
                        refResultData              :=  REF(PlcInputs^.reader_st2_Result_Data_64_bytes_1),
                        refUserData                :=  REF(PlcOutputs^.reader_st2_User_Data_64_bytes_1));
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
            IF(Dataman_300.ClearResultData().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;  

        IF(Steps[1].Execute(Sequencer, 'Change job')) THEN
            IF(Dataman_300.Read().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[2].Execute(Sequencer, 'Evaluate data')) THEN
            _ResultData := Dataman_300.ResultData;
            Sequencer.MoveNext();                
        END_IF;       
  

    END_METHOD
    
    //</Usage>
END_CLASS
