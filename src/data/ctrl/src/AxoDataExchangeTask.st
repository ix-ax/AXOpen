USING AXOpen.Core;

NAMESPACE AXOpen.Data
    ///<summary>
    /// Extends AxoRemoteTask for data operation within AxoData    
    /// </summary>  
    CLASS AxoDataExchangeTask
        EXTENDS AXOpen.Core.AxoRemoteTask
        IMPLEMENTS IAxoEntityExistTaskState

        VAR PUBLIC
            DataEntityIdentifier : STRING[254];
            _exist : BOOL;
        END_VAR

        METHOD PUBLIC Invoke : IAxoTaskState
            VAR_INPUT
                
                identifier : STRING[254];
            END_VAR
            DataEntityIdentifier := identifier;
            Invoke := SUPER.Invoke();
        END_METHOD

        METHOD PUBLIC Exist : BOOL
            Exist := _exist;
        END_METHOD

    END_CLASS

    INTERFACE PUBLIC IAxoEntityExistTaskState EXTENDS IAxoTaskState
        METHOD Exist : BOOL END_METHOD
    END_INTERFACE

END_NAMESPACE
