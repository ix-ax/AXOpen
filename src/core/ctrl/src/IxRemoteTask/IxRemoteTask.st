NAMESPACE ix.framework.core
    ///<summary>
    /// Provides a mechanism to exectute a logic from the PLC in an .NET environment.   
    ///<remarks>
    ///> [!IMPORTANT]
    ///> The deferred execution in .NET envornment is not hard-real time nor deterministic.
    ///</remarks>    
    ///</summary>            
    CLASS PUBLIC IxRemoteTask EXTENDS IxTask
        VAR PUBLIC
            ///<summary>
            /// Remote system's done signature. 
            /// When `StartSignature` and `DoneSignature` equal the task is considered executed on the remote system.
            ///</summary>           
            DoneSignature : ULINT;
                      
            ///<summary>
            /// When not empty indicates that the remote task produced an exeption. 
            /// Will contain the limited information about the exception. 
            /// More details should be found in <see cref="RemoteExecutionException"/> property
            /// of the corresponding twin object.     
            ///</summary> 
            ExceptionMessage : STRING[254];

            ///<summary>
            /// Indicates whether this instance's remote procedure is initialized.            
            ///</summary> 
            ///<remarks>When the remote task is not initialized, but the execution is invoked, task enters error state.</remarks>
            IsInitialized : BOOL;
        END_VAR
        
        METHOD PUBLIC OVERRIDE Execute : BOOL
            Execute := SUPER.Execute();            

            IF(Execute) THEN
                SUPER.ThrowWhen(ExceptionMessage <> '' OR NOT IsInitialized);            
                SUPER.DoneWhen(StartSignature = DoneSignature);            
            END_IF;    
        END_METHOD  
        
        
        ///<summary>
        /// DoneWhen does not have effect on IxRemoteTask. Completion of the task is handled by the remote part.
        ///</summary>         
        METHOD PUBLIC OVERRIDE DoneWhen             
            VAR_INPUT
                Condition : BOOL;
            END_VAR
            ;
        END_METHOD

        ///<summary>
        /// ThrowWhen does not have effect on IxRemoteTask. Completion of the task is handled by the remote part.
        ///</summary>   
        METHOD PUBLIC OVERRIDE ThrowWhen
            VAR_INPUT
                HasErrorState : BOOL;
            END_VAR
            ;
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