USING AXOpen.Core;
NAMESPACE AXOpen.Data
    ///<summary>
    /// Provides remote execution for CRUD operations.    
    /// > [!NOTE]
    /// > This is an extension of <see cref="AxoTask"/>task see the documentation for details about implementation in .NET.
    /// </summary>
    {#ix-set:AttributeName = "<#Data operation#>"}     
    CLASS AxoDataPersistentCurdTask EXTENDS AxOpen.Core.AxoRemoteTask IMPLEMENTS  IAxoEntityExistTaskState      
        VAR PUBLIC
            ///<summary>
            /// Gets or sets the type of CRUD operation to be perfomed.            
            /// </summary>
            CrudOperation : ePersistentOperation;
            DataEntityIdentifier : STRING[254];
            _exist : BOOL;            
        END_VAR

        ///<summary>
        /// Invokes this task.
        /// </summary>
        /// <param name="identifier">Data entity identifier</param>
        /// <param name="operation">Operation to perfom.</param>
        METHOD PUBLIC Invoke : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
                operation : ePersistentOperation;
            END_VAR
            CrudOperation := operation;
            DataEntityIdentifier := identifier;
            Invoke := SUPER.Invoke();
        END_METHOD
      
        METHOD PUBLIC Exist : BOOL
            Exist := _exist;
        END_METHOD

    END_CLASS

    TYPE
        ePersistentOperation : (Read, Update, EntityExist);
    END_TYPE

END_NAMESPACE
