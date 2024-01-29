USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING Siemens.Simatic.S71500.Diagnostics.Hardware;

NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoHardwareDiagnostics EXTENDS AXOpen.Core.AxoTask 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Hardware ID#>"}
            {#ix-attr:[ReadOnly()]}
            hardwareID	                :   WORD;	                //  Input	Hardware identifier of the component.
            {#ix-set:AttributeName = "<#Diagnostics return code#>"}
            {#ix-attr:[ReadOnly()]}
            GetDiagnosticsReturnCode    :   GetDiagnosticsReturnCode;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Diagnostics details#>"}
            {#ix-attr:[ReadOnly()]}
            diagnosticDetails	        :   DiagnosticDetails;	    //  Diagnostic information of the addressed hardware component.
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                hwID    :   WORD;
            END_VAR
            VAR
                diagInfo : Siemens.Simatic.S71500.Diagnostics.Hardware.DiagnosticDetails;            
            END_VAR
                   
            
            IF SUPER.Execute() THEN
                GetDiagnosticsReturnCode := GetDiagnostics(TO_UINT(hwID), diagInfo);

                IF GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError THEN
                    diagnosticDetails.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation   :=  diagInfo.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation;    
                    diagnosticDetails.ComponentStateDetail.HardwareComponentState.TransferNotPermitted      :=  diagInfo.ComponentStateDetail.HardwareComponentState.TransferNotPermitted;       
                    diagnosticDetails.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable      :=  diagInfo.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable;       
                    diagnosticDetails.ComponentStateDetail.HardwareComponentState.MaintenanceRequired       :=  diagInfo.ComponentStateDetail.HardwareComponentState.MaintenanceRequired;        
                    diagnosticDetails.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded       :=  diagInfo.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded;        
                    diagnosticDetails.ComponentStateDetail.HardwareComponentState.Error                     :=  diagInfo.ComponentStateDetail.HardwareComponentState.Error;                      
                    diagnosticDetails.ComponentStateDetail.HardwareComponentState.ComponentAvailability     :=  diagInfo.ComponentStateDetail.HardwareComponentState.ComponentAvailability;    
                    diagnosticDetails.ComponentStateDetail.HardwareComponentState.ReplacementState          :=  diagInfo.ComponentStateDetail.HardwareComponentState.ReplacementState;        
    
                    diagnosticDetails.ComponentStateDetail.PlcState.ModuleDisabled                          :=  diagInfo.ComponentStateDetail.PlcState.ModuleDisabled;             
                    diagnosticDetails.ComponentStateDetail.PlcState.ConfigurationInRunActive                :=  diagInfo.ComponentStateDetail.PlcState.ConfigurationInRunActive;   
                    diagnosticDetails.ComponentStateDetail.PlcState.InputNotAvailable                       :=  diagInfo.ComponentStateDetail.PlcState.InputNotAvailable;          
                    diagnosticDetails.ComponentStateDetail.PlcState.OutputNotAvailable                      :=  diagInfo.ComponentStateDetail.PlcState.OutputNotAvailable;         
                    diagnosticDetails.ComponentStateDetail.PlcState.DiagnosticsBufferOverflow               :=  diagInfo.ComponentStateDetail.PlcState.DiagnosticsBufferOverflow;  
                    diagnosticDetails.ComponentStateDetail.PlcState.DiagnosticsNotAvailable                 :=  diagInfo.ComponentStateDetail.PlcState.DiagnosticsNotAvailable;    
                    diagnosticDetails.ComponentStateDetail.PlcState.PartialDeviceFailure                    :=  diagInfo.ComponentStateDetail.PlcState.PartialDeviceFailure;       
    
                    diagnosticDetails.ComponentState                                                        :=  diagInfo.ComponentState;      
                    
                    diagnosticDetails.IoState.Good                                                          :=  diagInfo.IoState.Good;                     
                    diagnosticDetails.IoState.Disabled                                                      :=  diagInfo.IoState.Disabled;                 
                    diagnosticDetails.IoState.MaintenanceRequired                                           :=  diagInfo.IoState.MaintenanceRequired;      
                    diagnosticDetails.IoState.MaintenanceDemanded                                           :=  diagInfo.IoState.MaintenanceDemanded;      
                    diagnosticDetails.IoState.Error                                                         :=  diagInfo.IoState.Error;                    
                    diagnosticDetails.IoState.NotAccessible                                                 :=  diagInfo.IoState.NotAccessible;            
                    diagnosticDetails.IoState.DiagnosticsAvailable                                          :=  diagInfo.IoState.DiagnosticsAvailable;     
                    diagnosticDetails.IoState.IODataNotAvailable                                            :=  diagInfo.IoState.IODataNotAvailable;       
                    diagnosticDetails.IoState.NetworkError                                                  :=  diagInfo.IoState.NetworkError;             
                    diagnosticDetails.IoState.HardwareError                                                 :=  diagInfo.IoState.HardwareError;            
    
                    diagnosticDetails.OperatingState                                                        :=  diagInfo.OperatingState;
                END_IF;

                SUPER.DoneWhen(Duration >= T#500ms AND GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError);
                SUPER.ThrowWhen(Duration >= T#2s OR GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#HardwareIDInvalid OR GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#OutOfResources);
            END_IF;

            IF SUPER.StartTriggered() THEN
                hardwareID := hwID;
                GetDiagnosticsReturnCode                                                                :=  GetDiagnosticsReturnCode#Unknown;

                diagnosticDetails.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation   :=  FALSE;    
                diagnosticDetails.ComponentStateDetail.HardwareComponentState.TransferNotPermitted      :=  FALSE;    
                diagnosticDetails.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable      :=  FALSE;    
                diagnosticDetails.ComponentStateDetail.HardwareComponentState.MaintenanceRequired       :=  FALSE;    
                diagnosticDetails.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded       :=  FALSE;    
                diagnosticDetails.ComponentStateDetail.HardwareComponentState.Error                     :=  FALSE;    
                diagnosticDetails.ComponentStateDetail.HardwareComponentState.ComponentAvailability     :=  ComponentAvailability#Unknown;    
                diagnosticDetails.ComponentStateDetail.HardwareComponentState.ReplacementState          :=  ReplacementState#Unknown;        

                diagnosticDetails.ComponentStateDetail.PlcState.ModuleDisabled                          :=  FALSE; 
                diagnosticDetails.ComponentStateDetail.PlcState.ConfigurationInRunActive                :=  FALSE; 
                diagnosticDetails.ComponentStateDetail.PlcState.InputNotAvailable                       :=  FALSE; 
                diagnosticDetails.ComponentStateDetail.PlcState.OutputNotAvailable                      :=  FALSE; 
                diagnosticDetails.ComponentStateDetail.PlcState.DiagnosticsBufferOverflow               :=  FALSE; 
                diagnosticDetails.ComponentStateDetail.PlcState.DiagnosticsNotAvailable                 :=  FALSE; 
                diagnosticDetails.ComponentStateDetail.PlcState.PartialDeviceFailure                    :=  FALSE; 

                diagnosticDetails.ComponentState                                                        :=  ComponentState#Unknown;
                
                diagnosticDetails.IoState.Good                                                          :=  FALSE;
                diagnosticDetails.IoState.Disabled                                                      :=  FALSE;
                diagnosticDetails.IoState.MaintenanceRequired                                           :=  FALSE;
                diagnosticDetails.IoState.MaintenanceDemanded                                           :=  FALSE;
                diagnosticDetails.IoState.Error                                                         :=  FALSE;
                diagnosticDetails.IoState.NotAccessible                                                 :=  FALSE;
                diagnosticDetails.IoState.DiagnosticsAvailable                                          :=  FALSE;
                diagnosticDetails.IoState.IODataNotAvailable                                            :=  FALSE;
                diagnosticDetails.IoState.NetworkError                                                  :=  FALSE;
                diagnosticDetails.IoState.HardwareError                                                 :=  FALSE;

                diagnosticDetails.OperatingState                                                        :=  OperatingState#Unknown;    
            END_IF;
        END_METHOD
    END_CLASS
END_NAMESPACE
