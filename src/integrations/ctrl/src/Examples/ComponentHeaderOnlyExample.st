using ix.framework.core;

{#ix-attr:[Container(Layout.Stack)]}
{#ix-set:AttributeName = "Component with header only example"}
CLASS PUBLIC ComponentHeaderOnlyExample EXTENDS IxComponent 
    METHOD PROTECTED OVERRIDE Restore: IIxTask 
        // Some logic for Restore could be placed here.
        // For Example:
        valueReal := REAL#0.0;
        valueDint := DINT#0;
    END_METHOD

    METHOD PROTECTED OVERRIDE ManualControl
        // Some logic for manual control could be placed here.
        ;
    END_METHOD

    // Main method of the `IxComponent` that needs to be called inside the `IxContext` cyclically.
    METHOD PUBLIC Run
        // Declaration of the input and output variables.
        // In the case of "hardware-related" `IxComponent`, 
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
        valueReal : REAL; 
        {#ix-attr:[ComponentHeader()]}        
        {#ix-set:AttributeName = "Dint sum value"}
        valueDint : DINT; 
    END_VAR
END_CLASS

