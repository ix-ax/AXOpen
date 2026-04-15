USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING Siemens.Simatic.Diagnostics.Hardware;

NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoIoComponent EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HARDWARE DIAGNOSTICS TASK
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
            {#ix-attr:[ComponentDetails("Hardware sub diagnostics")]}
            {#ix-set:AttributeName = "<#Update sub diagnostics#>"}
            HardwareSubDiagnosticsTask :   AXOpen.Io.AxoHardwareSubDiagnostics;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent    :   IAxoObject;
                hwID        :   UINT;
            END_VAR
            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;
            SUPER.Run(inParent);    
            //********************Diagnostics*********       
            HardwareDiagnosticsTask.Run(THIS,hwID);
            HardwareSubDiagnosticsTask.Run(THIS,hwID);
            //****************************************      
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            HardwareDiagnosticsTask.Restore();
            HardwareSubDiagnosticsTask.Restore();
        END_METHOD        
    END_CLASS
END_NAMESPACE
