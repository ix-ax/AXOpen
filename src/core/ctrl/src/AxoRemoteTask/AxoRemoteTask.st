NAMESPACE AXOpen.Core
    ///<summary>
    /// Provides a mechanism to exectute a logic from the PLC in an .NET environment.   
    ///<remarks>
    ///> [!IMPORTANT]
    ///> The deferred execution in .NET envornment is not hard-real time nor deterministic.
    ///</remarks>    
    ///</summary>            
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoRemoteTask EXTENDS AxoTask
        VAR PUBLIC
            ///<summary>
            /// Remote system's done signature. 
            /// When `StartSignature` and `DoneSignature` equal the task is considered executed on the remote system.
            ///</summary>           
            DoneSignature : ULINT;
                              
            ///<summary>
            /// Indicates whether this instance's remote procedure is initialized.            
            ///</summary> 
            ///<remarks>When the remote task is not initialized, but the execution is invoked, task enters error state.</remarks>
            IsInitialized : BOOL;

            HasRemoteException : BOOL;

            IsBeingCalledCounter : INT;
            // {#ix-set:MessageText = "<#Remote task is not initialized by remote partner.#>"}
            // {#ix-set:Help = "<#Make sure the remote application that should handle this remote request is running and is available in the network.#>"}
            // TaskNotInitialized : AXOpen.Messaging.Static.AxoMessenger;

            // {#ix-set:MessageText = "<#During the execution or remote task an error occured.#> |[[1]RemoteExceptionDetails]|"}
            // {#ix-set:Help = "<#Check detail of this remote task for more information about the problem.#>"}
            // TaskHasRemoteException : AXOpen.Messaging.Static.AxoMessenger;


            {#ix-set:AttributeName = "<#RemoteTaskMessenger#>"}
            {#ix-set:PlcTextList =  "[1]:'<#Remote task is not initialized by remote partner.#>':'<#Make sure the remote application that should handle this remote request is running and is available to the controller.#>'';
                                    '[2]:'<#During the execution or remote task an error occured.#> |[[1]RemoteExceptionDetails]|':'<#Check detail of this remote task for more information about the problem.#>'"}
            _remoteTaskMessenger : AXOpen.Messaging.Static.AxoMessenger;

        END_VAR
        
        METHOD PUBLIC OVERRIDE Execute : BOOL
            VAR_INPUT 
                inParent : IAxoObject;
            END_VAR
            Execute := SUPER.Execute(inParent);            
            
            _remoteTaskMessenger.Serve(THIS);

            IF(Execute) THEN                
                _remoteTaskMessenger.ActivateOnCondition(UINT#1,NOT IsInitialized, AXOpen.Messaging.eAxoMessageCategory#Warning);
                //SUPER.ThrowWhen(NOT IsInitialized, 'THE REMOTE TASK IS NOT INITIALIZED');     
                SUPER.ThrowWhen(HasRemoteException, ErrorDetails);                                
                SUPER.DoneWhen(StartSignature = DoneSignature);     
                IsBeingCalledCounter := IsBeingCalledCounter + 1;                       
            END_IF;                
                                    
            _remoteTaskMessenger.ActivateOnCondition(UINT#2,HasRemoteException, AXOpen.Messaging.eAxoMessageCategory#Error).RequireAcknowledgement();        
        END_METHOD  
                      
        
        METHOD PUBLIC OVERRIDE Restore : IAxoTaskState
            SUPER.Restore();
            HasRemoteException := FALSE;
        END_METHOD    

        // Internal use only!
        METHOD INTERNAL GetStartSignature : ULINT
            GetStartSignature := StartSignature;    
        END_METHOD  

        // Internal use only!
        METHOD INTERNAL SetDoneSignature
            DoneSignature := StartSignature;    
        END_METHOD   
    END_CLASS
END_NAMESPACE    
