NAMESPACE AXOpen.Data

    ///<summary>
    /// Represents the satisfied state of a data CRUD task entity existence check.
    /// </summary>
    CLASS PUBLIC AxoDataCrudTaskEntityExistsSatisfied EXTENDS AXOpen.Core.AxoTaskStateSatisfied IMPLEMENTS IAxoDataCrudTaskEntityExistState
        VAR PRIVATE
            _exists : BOOL;
        END_VAR    

        ///<summary>
        /// Returns true when the entity exists. Prior to calling this method you should call Satisfy.
        /// </summary>
        METHOD PUBLIC Exist : BOOL 
            Exist := _exists;
            _exists := FALSE;
        END_METHOD

        ///<summary>
        /// Satisfies the task state by setting the existence status.
        /// </summary>
        METHOD PUBLIC Satisfy : IAxoDataCrudTaskEntityExistState
            VAR_INPUT
                inStatus : eAxoTaskState;
                inDoesExist : BOOL;
            END_VAR
            Status := inStatus;
            _exists := inDoesExist;
            Satisfy := THIS;
        END_METHOD
    END_CLASS
END_NAMESPACE