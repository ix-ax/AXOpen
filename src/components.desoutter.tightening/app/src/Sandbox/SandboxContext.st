{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        {#ix-attr:[Container(Layout.Stack)]}
        _testScrewdriver  : AXOpen.Components.Desoutter.Tightening.AxoCVIC_II;
    END_VAR


    METHOD PROTECTED OVERRIDE Main  
        RETURN;

        IF(_manualControl) THEN            
            _testScrewdriver.ActivateManualControl();
        END_IF;   

        _testScrewdriver.Run(   parent                  :=  THIS,
                                hwID                   := HwIdentifiers#wp462_t1_rh_deso,
                                hwId_Input_1_byte_1    := HwIdentifiers#wp462_t1_rh_deso_Input_1_byte_1,
                                hwId_Input_1_byte_2    := HwIdentifiers#wp462_t1_rh_deso_Input_1_byte_2,
                                hwId_Input_2_word_1    := HwIdentifiers#wp462_t1_rh_deso_Input_2_word_1,
                                hwId_Input_1_word_1    := HwIdentifiers#wp462_t1_rh_deso_Input_1_word_1,
                                hwId_Input_2_word_2    := HwIdentifiers#wp462_t1_rh_deso_Input_2_word_2,
                                hwId_Input_1_word_2    := HwIdentifiers#wp462_t1_rh_deso_Input_1_word_2,
                                hwId_Output_1_byte_1   := HwIdentifiers#wp462_t1_rh_deso_Output_1_byte_1,
                                hwId_Output_1_byte_2   := HwIdentifiers#wp462_t1_rh_deso_Output_1_byte_2);       

        
    END_METHOD
END_CLASS
          