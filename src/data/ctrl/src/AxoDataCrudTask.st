USING AXOpen.Core;

NAMESPACE AXOpen.Data

    CLASS AxoDataCrudTask
        EXTENDS AxoDataExchangeTask
        VAR PUBLIC
            CrudOperation : eCrudOperation;
        END_VAR

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
        eCrudOperation : (Create, Read, Update, Delete);
    END_TYPE

END_NAMESPACE
