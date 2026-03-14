NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module keyence_iv3/CommandControl
	        keyence_iv3_CommandControl_Output AT %B135 : keyence_iv3_CommandControl_Output_Layout;

	        // Module keyence_sr_1000/CompletionClearControl
	        keyence_sr_1000_CompletionClearControl_Output AT %B279 : keyence_sr_1000_CompletionClearControl_Output_Layout;

	        // Module keyence_sr_1000/LatchAndErrorClearControl
	        keyence_sr_1000_LatchAndErrorClearControl_Output AT %B281 : keyence_sr_1000_LatchAndErrorClearControl_Output_Layout;

	        // Module keyence_sr_1000/OperationInstructionControl
	        keyence_sr_1000_OperationInstructionControl_Output AT %B280 : keyence_sr_1000_OperationInstructionControl_Output_Layout;

	        // Module keyence_sr_1000/ParameterBank
	        keyence_sr_1000_ParameterBank_Output AT %B277 : keyence_sr_1000_ParameterBank_Output_Layout;

	        // Module keyence_sr_1000/UserData_128
	        keyence_sr_1000_UserData_128_Output AT %B147 : keyence_sr_1000_UserData_128_Output_Layout;

	        // Module keyence_sr_750/CompletionClearControl
	        keyence_sr_750_CompletionClearControl_Output AT %B132 : keyence_sr_750_CompletionClearControl_Output_Layout;

	        // Module keyence_sr_750/LatchAndErrorClearControl
	        keyence_sr_750_LatchAndErrorClearControl_Output AT %B134 : keyence_sr_750_LatchAndErrorClearControl_Output_Layout;

	        // Module keyence_sr_750/OperationInstructionControl
	        keyence_sr_750_OperationInstructionControl_Output AT %B133 : keyence_sr_750_OperationInstructionControl_Output_Layout;

	        // Module keyence_sr_750/ParameterBank
	        keyence_sr_750_ParameterBank_Output AT %B130 : keyence_sr_750_ParameterBank_Output_Layout;

	        // Module keyence_sr_750/UserData_128
	        keyence_sr_750_UserData_128_Output AT %B0 : keyence_sr_750_UserData_128_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

