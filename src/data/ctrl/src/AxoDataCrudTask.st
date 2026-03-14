USING AXOpen.Core;

NAMESPACE AXOpen.Data

    ///<summary>
    /// Provides remote execution for CRUD operations.    
    /// > [!NOTE]
    /// > This is an extension of <see cref="AxoTask"/>task see the documentatio for details about implementation in .NET.
    /// </summary>
    {#ix-set:AttributeName = "<#Data operation#>"}     
    {S7.extern=ReadWrite}
    CLASS AxoDataCrudTask EXTENDS AxoRemoteTask IMPLEMENTS IAxoDataCrudTaskEntityExistState      
        VAR PUBLIC
            ///<summary>
            /// Gets or sets the type of CRUD operation to be perfomed.            
            /// </summary>
            CrudOperation : eCrudOperation;
            _EntityId : STRING[254];
            _exist : BOOL;            
        END_VAR

        VAR PRIVATE
            _LastCrudOperation : eCrudOperation;
            _LastDataEntityIdentifier : STRING[254];
        END_VAR
        ///<summary>
        /// Invokes this task.
        /// </summary>
        /// <param name="identifier">Data entity identifier</param>
        /// <param name="operation">Operation to perfom.</param>
        METHOD PUBLIC Invoke : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
                operation : eCrudOperation;
            END_VAR

            // This may produce unwanted side effects if the task is invoked with different parameters while it is running.
            // It may prevent done state to be provided upstream to the caller.
            IF SUPER.IsDone() THEN
                IF (_LastDataEntityIdentifier   <> identifier OR 
                    _LastCrudOperation          <> operation ) THEN
                    SUPER.Restore();                    
                END_IF;
            END_IF;

            IF SUPER.IsReady() THEN
                _EntityId := identifier;
                CrudOperation := operation;
            END_IF;

            _LastDataEntityIdentifier   := _EntityId;
            _LastCrudOperation          := CrudOperation;

            Invoke := SUPER.Invoke();
        END_METHOD
      
        METHOD PUBLIC Exist : BOOL
            Exist := _exist;
        END_METHOD

    END_CLASS

    TYPE
        eCrudOperation : (Create, Read, Update, Delete, CreateOrUpdate, EntityExist);
    END_TYPE   
END_NAMESPACE
