USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING Siemens.Simatic.Diagnostics.Hardware;
USING Siemens.Simatic.DistributedIO;

NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoRecordAccessTool EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Hardware ID#>"}
            hardwareID	                :   UINT;	                

            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Read index#>"}
            rdIndex	                :   UINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Read subindex#>"}
            rdSubIndex	                :   UINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Read length#>"}
            rdLength	                :   UINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Data read#>"}
            rdData	                :   AxoRecordAccessData;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Read record#>"}
            ReadRecordTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Write index#>"}
            wrIndex	                :   UINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Write subindex#>"}
            wrSubIndex	                :   UINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Write length#>"}
            wrLenght	                :   UINT;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Data read#>"}
            wrData	                :   AxoRecordAccessData;	                
            {#ix-attr:[ComponentDetails("Records")]}
            {#ix-set:AttributeName = "<#Write record#>"}
            WriteRecordTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PRIVATE
            writeRecord : WriteRecord;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent    :   IAxoObject;
            END_VAR
            IF (inParent = NULL) THEN 
                RETURN; 
            END_IF;
            SUPER.Run(inParent);    
        END_METHOD

        METHOD PRIVATE Execute
            VAR_INPUT
                hwID    :   UINT;
            END_VAR
            // VAR
            //     diagInfo : Siemens.Simatic.S71500.Diagnostics.Hardware.DiagnosticDetails;            
            // END_VAR
;

            // IF UpdateHardwareDiagnosticsTask.Execute(THIS) THEN
            //     GetDiagnosticsReturnCode := GetDiagnostics(hwID, diagInfo);
            //     UpdateHardwareDiagnosticsTask.DoneWhen(UpdateHardwareDiagnosticsTask.Duration >= T#250ms AND GetDiagnosticsReturnCode=GetDiagnosticsReturnCode#NoError);
            //     UpdateHardwareDiagnosticsTask.ThrowWhen(UpdateHardwareDiagnosticsTask.Duration >= T#250ms AND GetDiagnosticsReturnCode<>GetDiagnosticsReturnCode#NoError);
            // END_IF;

            // IF UpdateHardwareDiagnosticsTask.DoneReached() THEN
            //     diagnosticDetails.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation   :=  diagInfo.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation;    
            //     diagnosticDetails.ComponentStateDetail.HardwareComponentState.TransferNotPermitted      :=  diagInfo.ComponentStateDetail.HardwareComponentState.TransferNotPermitted;       
            //     diagnosticDetails.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable      :=  diagInfo.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable;       
            //     diagnosticDetails.ComponentStateDetail.HardwareComponentState.MaintenanceRequired       :=  diagInfo.ComponentStateDetail.HardwareComponentState.MaintenanceRequired;        
            //     diagnosticDetails.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded       :=  diagInfo.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded;        
            //     diagnosticDetails.ComponentStateDetail.HardwareComponentState.Error                     :=  diagInfo.ComponentStateDetail.HardwareComponentState.Error;                      
            //     diagnosticDetails.ComponentStateDetail.HardwareComponentState.ComponentAvailability     :=  diagInfo.ComponentStateDetail.HardwareComponentState.ComponentAvailability;
            //     diagnosticDetails.ComponentStateDetail.HardwareComponentState.ReplacementState          :=  diagInfo.ComponentStateDetail.HardwareComponentState.ReplacementState;

            //     diagnosticDetails.ComponentStateDetail.PlcState.ModuleDisabled                          :=  diagInfo.ComponentStateDetail.PlcState.ModuleDisabled;             
            //     diagnosticDetails.ComponentStateDetail.PlcState.ConfigurationInRunActive                :=  diagInfo.ComponentStateDetail.PlcState.ConfigurationInRunActive;   
            //     diagnosticDetails.ComponentStateDetail.PlcState.InputNotAvailable                       :=  diagInfo.ComponentStateDetail.PlcState.InputNotAvailable;          
            //     diagnosticDetails.ComponentStateDetail.PlcState.OutputNotAvailable                      :=  diagInfo.ComponentStateDetail.PlcState.OutputNotAvailable;         
            //     diagnosticDetails.ComponentStateDetail.PlcState.DiagnosticsBufferOverflow               :=  diagInfo.ComponentStateDetail.PlcState.DiagnosticsBufferOverflow;  
            //     diagnosticDetails.ComponentStateDetail.PlcState.DiagnosticsNotAvailable                 :=  diagInfo.ComponentStateDetail.PlcState.DiagnosticsNotAvailable;    
            //     diagnosticDetails.ComponentStateDetail.PlcState.PartialDeviceFailure                    :=  diagInfo.ComponentStateDetail.PlcState.PartialDeviceFailure;       

            //     diagnosticDetails.ComponentState                                                        :=  diagInfo.ComponentState;
                
            //     diagnosticDetails.IoState.Good                                                          :=  diagInfo.IoState.Good;                     
            //     diagnosticDetails.IoState.Disabled                                                      :=  diagInfo.IoState.Disabled;                 
            //     diagnosticDetails.IoState.MaintenanceRequired                                           :=  diagInfo.IoState.MaintenanceRequired;      
            //     diagnosticDetails.IoState.MaintenanceDemanded                                           :=  diagInfo.IoState.MaintenanceDemanded;      
            //     diagnosticDetails.IoState.Error                                                         :=  diagInfo.IoState.Error;                    
            //     diagnosticDetails.IoState.NotAccessible                                                 :=  diagInfo.IoState.NotAccessible;            
            //     diagnosticDetails.IoState.DiagnosticsAvailable                                          :=  diagInfo.IoState.DiagnosticsAvailable;     
            //     diagnosticDetails.IoState.IODataNotAvailable                                            :=  diagInfo.IoState.IODataNotAvailable;       
            //     diagnosticDetails.IoState.NetworkError                                                  :=  diagInfo.IoState.NetworkError;             
            //     diagnosticDetails.IoState.HardwareError                                                 :=  diagInfo.IoState.HardwareError;            

            //     diagnosticDetails.OperatingState                                                        :=  diagInfo.OperatingState;
            // END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            ReadRecordTask.Restore();
            WriteRecordTask.Restore();
        END_METHOD        
    END_CLASS
END_NAMESPACE
