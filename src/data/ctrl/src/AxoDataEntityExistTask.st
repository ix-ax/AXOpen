USING AXOpen.Core;

NAMESPACE AXOpen.Data
    ///<summary>
    /// Extends AxoRemoteTask for data operation within AxoData    
    /// </summary>  
    CLASS AxoDataEntityExistTask 
        EXTENDS AxoDataExchangeTask
        IMPLEMENTS IAxoDataEntityExistTask
        VAR PUBLIC
            _exist : BOOL;
        END_VAR

        METHOD PUBLIC Exist : BOOL
            Exist := _exist;
        END_METHOD
    END_CLASS

    INTERFACE PUBLIC IAxoDataEntityExistTask EXTENDS IAxoTaskState
        METHOD Exist : BOOL END_METHOD
    END_INTERFACE

END_NAMESPACE
