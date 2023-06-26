USING AXOpen.Core;

NAMESPACE AXOpen.Data

    ///<summary>
    /// Provides remote execution for CRUD operations.    
    /// > [!NOTE]
    /// > This is an extension of <see cref="AxoTask"/>task see the documentatio for details about implementation in .NET.
    /// </summary>
    CLASS AxoDataCrudTask
        EXTENDS AxoDataExchangeTask
        VAR PUBLIC
            ///<summary>
            /// Gets or sets the type of CRUD operation to be perfomed.            
            /// </summary>
            CrudOperation : eCrudOperation;
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
            Invoke := SUPER.Invoke(identifier);
        END_METHOD
    END_CLASS

    TYPE
        eCrudOperation : (Create, Read, Update, Delete, EntityExist, CreateOrUpdate);
    END_TYPE

END_NAMESPACE
