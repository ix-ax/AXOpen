USING AXOpen.Core;

NAMESPACE AXOpen.Data

    ///<summary>
    /// Provides remote execution for CRUD operations.    
    /// > [!NOTE]
    /// > This is an extension of <see cref="AxoTask"/>task see the documentatio for details about implementation in .NET.
    /// </summary>
    {#ix-set:AttributeName = "<#Data operation#>"}     
    CLASS AxoDataCrudTask EXTENDS AxoRemoteTask IMPLEMENTS IAxoEntityExistTaskState      
        VAR PUBLIC
            ///<summary>
            /// Gets or sets the type of CRUD operation to be perfomed.            
            /// </summary>
            CrudOperation : eCrudOperation;
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
                operation : eCrudOperation;
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
        eCrudOperation : (Create, Read, Update, Delete, CreateOrUpdate, EntityExist);
    END_TYPE

    INTERFACE PUBLIC IAxoEntityExistTaskState EXTENDS IAxoTaskState
        METHOD Exist : BOOL END_METHOD
    END_INTERFACE

END_NAMESPACE
