PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;

		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
    END_VAR
    // CopyInputs();

    // sandbox.PlcInputs := REF(PlcInputs); 
    // sandbox.PlcOutputs := REF(PlcOutputs);

    sandbox.Run();    
    sandbox.InjectRtc(_rtc);
    
    // documentation.componentOne.PlcInputs := REF(PlcInputs); 
    // documentation.componentOne.PlcOutputs := REF(PlcOutputs);
    // documentation.componentTwo.PlcInputs := REF(PlcInputs); 
    // documentation.componentTwo.PlcOutputs := REF(PlcOutputs);
    // documentation.Run();
    // documentation.InjectRtc(_rtc);
 
    // CopyOutputs();  
END_PROGRAM
