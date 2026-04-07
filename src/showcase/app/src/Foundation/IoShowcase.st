USING AXOpen.Core;

// Showcase examples for AXOpen.Io — demonstrates hardware diagnostics
// (AxoHwDiag), IO component monitoring, and record access tools.
NAMESPACE AXOpen.Showcase.Io

    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            _hwDiagDoc : HwDiagDoc;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            _hwDiagDoc.Run(_rootObject);
        END_METHOD
    END_CLASS

    // Demonstrates hardware diagnostics and IO component patterns.
    {S7.extern=ReadWrite}
    CLASS PUBLIC HwDiagDoc EXTENDS AXOpen.Core.AxoObject
        //<IoDeclarations>
        VAR PUBLIC
            _hwDiag : AXOpen.Io.AxoHwDiag;
            _hwDiagConfig : AXOpen.Io.AxoHwDiag_Config;
            _recordAccessTool : AXOpen.Io.AxoRecordAccessTool;
        END_VAR
        //</IoDeclarations>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            //<HwDiagConfiguration>
            // Configure diagnostic timing thresholds.
            _hwDiagConfig.InfoTime := LTIME#1000ms;
            _hwDiagConfig.ErrorTime := LTIME#5000ms;
            _hwDiagConfig.TaskTimeout := LTIME#10000ms;
            //</HwDiagConfiguration>

            //<HwDiagRun>
            // Run the hardware diagnostics component.
            // In a real application, pass the hardware ID of the device to monitor.
            _hwDiag.Run(inParent := inParent);
            //</HwDiagRun>

            //<RecordAccessRun>
            // Record access tool for reading/writing PROFINET device records.
            _recordAccessTool.Run(inParent := inParent);
            //</RecordAccessRun>
        END_METHOD
    END_CLASS

END_NAMESPACE
