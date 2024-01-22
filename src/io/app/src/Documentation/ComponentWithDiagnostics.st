USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS ComponentWithDiagnostics EXTENDS AXOpen.Core.AxoComponent
    VAR PUBLIC                
        {#ix-attr:[Container(Layout.Stack)]}
        {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
        {#ix-set:AttributeName = "<#Update diagnostics#>"}
        HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
    END_VAR

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoObject;
            _hwID : UINT;
        END_VAR    

        THIS.Initialize(parent);

        HardwareDiagnosticsTask.Initialize(THIS);

        HardwareDiagnosticsTask.Run(_hwID);        
    END_METHOD


    METHOD PUBLIC OVERRIDE Restore
        HardwareDiagnosticsTask.Restore();
    END_METHOD

    METHOD PROTECTED OVERRIDE ManualControl
        ;
    END_METHOD
END_CLASS
