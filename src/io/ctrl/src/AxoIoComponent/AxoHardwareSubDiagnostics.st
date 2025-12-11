USING AXOpen.Core;
USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING Siemens.Simatic.Diagnostics.Hardware;

NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoHardwareSubDiagnostics EXTENDS AXOpen.Core.AxoTask 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Hardware ID#>"}
            {#ix-attr:[ReadOnly()]}
            hardwareID	                :   UINT;	                //  Input	Hardware identifier of the component.
            {#ix-set:AttributeName = "<#Diagnostics return code#>"}
            {#ix-attr:[ReadOnly()]}
            GetDiagnosticsReturnCode    :   GetDiagnosticsReturnCode;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Diagnostics sub details#>"}
            {#ix-attr:[ReadOnly()]}
            diagnosticSubDetails	        :   SubordinateDiagnosticDetails;	    //  Diagnostic information of the addressed hardware component.
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
            VAR
                diagSubInfo : Siemens.Simatic.Diagnostics.Hardware.SubordinateDiagnosticDetails;            
            END_VAR
                   
            
            IF SUPER.Execute(inParent) THEN
                GetDiagnosticsReturnCode := GetDiagnostics(hwID, diagSubInfo);

                IF GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                    diagnosticSubDetails.SubordinateState                                                                 :=  diagSubInfo.SubordinateState;      

                    diagnosticSubDetails.SubordinateIOState.Good                                                          :=  diagSubInfo.SubordinateIOState.Good;                     
                    diagnosticSubDetails.SubordinateIOState.Disabled                                                      :=  diagSubInfo.SubordinateIOState.Disabled;                 
                    diagnosticSubDetails.SubordinateIOState.MaintenanceRequired                                           :=  diagSubInfo.SubordinateIOState.MaintenanceRequired;      
                    diagnosticSubDetails.SubordinateIOState.MaintenanceDemanded                                           :=  diagSubInfo.SubordinateIOState.MaintenanceDemanded;      
                    diagnosticSubDetails.SubordinateIOState.Error                                                         :=  diagSubInfo.SubordinateIOState.Error;                    
                    diagnosticSubDetails.SubordinateIOState.NotAccessible                                                 :=  diagSubInfo.SubordinateIOState.NotAccessible;            
                    diagnosticSubDetails.SubordinateIOState.DiagnosticsAvailable                                          :=  diagSubInfo.SubordinateIOState.DiagnosticsAvailable;     
                    diagnosticSubDetails.SubordinateIOState.IODataNotAvailable                                            :=  diagSubInfo.SubordinateIOState.IODataNotAvailable;       
                    diagnosticSubDetails.SubordinateIOState.NetworkError                                                  :=  diagSubInfo.SubordinateIOState.NetworkError;             
                    diagnosticSubDetails.SubordinateIOState.HardwareError                                                 :=  diagSubInfo.SubordinateIOState.HardwareError;            

                    diagnosticSubDetails.DiagnosticsEnabled:=  diagSubInfo.DiagnosticsEnabled;
                END_IF;

                SUPER.DoneWhen(Duration >= T#500ms AND GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError);
                SUPER.ThrowWhen(Duration >= T#2s OR GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);
            END_IF;

            IF SUPER.StartTriggered() OR SUPER.RestoreTriggered() THEN
                hardwareID                                                                              :=  hwID;
                GetDiagnosticsReturnCode                                                                :=  GetDiagnosticsReturnCode#Unknown;

                diagnosticSubDetails.SubordinateState                                                 :=  ComponentState#Unknown;
                
                diagnosticSubDetails.SubordinateIOState.Good                                                          :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.Disabled                                                      :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.MaintenanceRequired                                           :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.MaintenanceDemanded                                           :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.Error                                                         :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.NotAccessible                                                 :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.DiagnosticsAvailable                                          :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.IODataNotAvailable                                            :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.NetworkError                                                  :=  FALSE;
                diagnosticSubDetails.SubordinateIOState.HardwareError                                                 :=  FALSE;

                diagnosticSubDetails.DiagnosticsEnabled                                                               :=  FALSE;    
            END_IF;
        END_METHOD
    END_CLASS
END_NAMESPACE
