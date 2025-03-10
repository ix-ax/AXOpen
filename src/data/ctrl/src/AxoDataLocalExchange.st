NAMESPACE AXOpen.Data 
    USING AXOpen.Core;
          
    ///<summary>
    /// Base class for any exchangable data in <see cref="AxoDataExchange"/>.  
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC ABSTRACT AxoDataLocalExchange EXTENDS AxoObject IMPLEMENTS IAxoDataExchange                 
        VAR  PROTECTED                              
            operation : eCrudOperation;                              
            dataExchangeTask : AxoTask; 
        END_VAR
                                                           
        METHOD PUBLIC ABSTRACT Create : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR

            
        END_METHOD
    
        METHOD PUBLIC ABSTRACT Read : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR

            
        END_METHOD
    
        METHOD PUBLIC ABSTRACT Update : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR

            
        END_METHOD
    
        METHOD PUBLIC ABSTRACT Delete : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR

            
        END_METHOD
    
        METHOD PUBLIC ABSTRACT EntityExist : IAxoEntityExistTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR

            
        END_METHOD
    
        METHOD PUBLIC ABSTRACT CreateOrUpdate : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR

            
        END_METHOD
    
        METHOD PUBLIC Restore
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE  