USING AXOpen.Core;

NAMESPACE AxoComponentExamples
//<Implementation>
    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-set:AttributeName = "AxoComponent with header only example"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoComponentHeaderOnlyExample EXTENDS AXOpen.Core.AxoComponent 
        METHOD PUBLIC OVERRIDE Restore
            // Some logic for Restore could be placed here. For Example:
            valueReal := REAL#1.0;
            valueDint := DINT#0;
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            // Some logic for manual control could be placed here.
            ;
        END_METHOD

        // Main method of the `AxoComponent` that must be 
        // called inside the `AxoContext` cyclically.
        METHOD PUBLIC Run
            // Declaration of the input and output variables.
            // In the case of "hardware-related" `AxoComponent`, 
            // these would be the variables linked to the hardware. 
            VAR_INPUT 
                inReal : REAL;
                inDint : DINT;
            END_VAR
            VAR_OUTPUT
                outReal : REAL;
                outDint : DINT;
            END_VAR
            
            // This must be called first.
            SUPER.Open();

            // Place the custom logic here.
            valueReal := valueReal * inReal;
            valueDint := valueDint + inDint;

            outReal := valueReal;
            outDint := valueDint;
        END_METHOD 

        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}        
            {#ix-set:AttributeName = "Real product value"}
            valueReal : REAL := REAL#1.0; 
            {#ix-attr:[ComponentHeader()]}        
            {#ix-set:AttributeName = "Dint sum value"}
            valueDint : DINT:= DINT#0; 
        END_VAR
    END_CLASS
//</Implementation>

//<Using>
   {S7.extern=ReadWrite}
   CLASS ComponentHeaderOnlyExampleContext EXTENDS AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Very simple component example with header only defined"}
            MyComponentWithHeaderOnly : AxoComponentHeaderOnlyExample;  
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  

            inHwReal : REAL := REAL#1.0001;
            inHwDint : DINT := DINT#1;
            outHwReal : REAL;
            outHwDint : DINT;

        END_VAR

        METHOD PROTECTED OVERRIDE Main   
            // The `Initialize()` method must be called before any other method.
            MyComponentWithHeaderOnly.Initialize(THIS);
            // Example of the activation of the manual control. 
            IF ActivateManualControl THEN
                MyComponentWithHeaderOnly.ActivateManualControl();
            END_IF;
            // Calling the main method `Run` with respective input and output variables. 
            MyComponentWithHeaderOnly.Run(inReal :=  inHwReal,
                            inDint :=  inHwDint,
                            outReal => outHwReal,
                            outDint => outHwDint);
        END_METHOD
    END_CLASS
 //</Using>
END_NAMESPACE
