NAMESPACE AXOpen.Core
    ///<summary>
    /// Implementation of IAxoTaskState interface representing a satisfied task state given a specific status provided by `Satisfy` method.
    ///</summary>
    CLASS PUBLIC TaskStateSatisfied IMPLEMENTS IAxoTaskState
        VAR PUBLIC
            Status : eAxoTaskState;
            ErrorDetails : STRING[254];
        END_VAR
            
        ///<summary>
        /// Sets the task state to the provided status and returns the current instance.    
        /// </summary>
        METHOD PUBLIC Satisfy : IAxoTaskState
            VAR_INPUT
                inStatus : eAxoTaskState;
            END_VAR
            Status := inStatus;
            Satisfy := THIS;
        END_METHOD

        ///<summary>
        /// Gets true when the task is ready.
        ///</summary>
        METHOD PUBLIC IsReady : BOOL 
            IsReady := Status = eAxoTaskState#Ready; 
        END_METHOD   

        ///<summary>
        /// Gets true when the task is done.
        ///</summary>
        METHOD PUBLIC IsDone : BOOL 
            IsDone := Status = eAxoTaskState#Done ; 
        END_METHOD
                    
        ///<summary>
        /// Gets true when the task is busy/executing.
        ///</summary>
        METHOD PUBLIC IsBusy : BOOL 
            IsBusy := Status = eAxoTaskState#Busy; 
        END_METHOD
            
        ///<summary>
        /// Gets true when the task is aborted.
        ///</summary>
        METHOD PUBLIC IsAborted : BOOL 
            IsAborted := Status = eAxoTaskState#Aborted; 
        END_METHOD
            
        ///<summary>
        /// Gets true when the task has error.
        ///</summary>
        METHOD PUBLIC HasError : BOOL 
            HasError := Status = eAxoTaskState#Error; 
        END_METHOD   
    
        ///<summary>
        /// Gets the current status of the task.
        /// </summary>
        METHOD PUBLIC GetErrorDetails : STRING[254]
            GetErrorDetails := ErrorDetails;
        END_METHOD
    END_CLASS
END_NAMESPACE