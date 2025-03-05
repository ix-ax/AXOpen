USING AXOpen.Core;
NAMESPACE AXOpen.Components.Desoutter.Tightening
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl      :   BOOL;
             _rootObject        :   AxoObject;
             {#ix-attr:[Container(Layout.Stack)]}
             _testScrewdriver   :   AXOpen.Components.Desoutter.Tightening.AxoCVIC_II;
        END_VAR


        METHOD PROTECTED OVERRIDE Main  
            RETURN;
            THIS.InitializeRootObject(_rootObject);
            IF(_manualControl) THEN            
                _testScrewdriver.ActivateManualControl();
            END_IF;   

            _testScrewdriver.Run(   parent                  :=  _rootObject,
                                    hwID                   := HwIdentifiers#wp462_t1_rh_deso_HwID,
                                    hwId_Input_1_byte_1    := HwIdentifiers#wp462_t1_rh_deso_Input_1_byte_1_Input_1_byte_HwID,
                                    hwId_Input_1_byte_2    := HwIdentifiers#wp462_t1_rh_deso_Input_1_byte_2_Input_1_byte_HwID,
                                    hwId_Input_2_word_1    := HwIdentifiers#wp462_t1_rh_deso_Input_2_word_1_Input_2_word_HwID,
                                    hwId_Input_1_word_1    := HwIdentifiers#wp462_t1_rh_deso_Input_1_word_1_Input_1_word_HwID,
                                    hwId_Input_2_word_2    := HwIdentifiers#wp462_t1_rh_deso_Input_2_word_2_Input_2_word_HwID,
                                    hwId_Input_1_word_2    := HwIdentifiers#wp462_t1_rh_deso_Input_1_word_2_Input_1_word_HwID,
                                    hwId_Output_1_byte_1   := HwIdentifiers#wp462_t1_rh_deso_Output_1_byte_1_Output_1_byte_HwID,
                                    hwId_Output_1_byte_2   := HwIdentifiers#wp462_t1_rh_deso_Output_1_byte_2_Output_1_byte_HwID);       

            
        END_METHOD
    END_CLASS
END_NAMESPACE        