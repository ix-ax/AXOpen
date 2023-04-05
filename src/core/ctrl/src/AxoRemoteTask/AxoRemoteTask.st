NAMESPACE AXOpen.Core
    ///<summary>
    /// Provides a mechanism to exectute a logic from the PLC in an .NET environment.   
    ///<remarks>
    ///> [!IMPORTANT]
    ///> The deferred execution in .NET envornment is not hard-real time nor deterministic.
    ///</remarks>    
    ///</summary>            
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
        END_VAR
        
        METHOD PUBLIC OVERRIDE Execute : BOOL
            Execute := SUPER.Execute();            

            IF(Execute) THEN
                SUPER.ThrowWhen(NOT IsInitialized, 'THE REMOTE TASK IS NOT INITIALIZED');     
                SUPER.ThrowWhen(HasRemoteException, ErrorDetails);           
                SUPER.DoneWhen(StartSignature = DoneSignature);       
                IsBeingCalledCounter := IsBeingCalledCounter + 1;     
            END_IF;                

          
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