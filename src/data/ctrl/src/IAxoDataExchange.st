USING AXOpen.Core;

NAMESPACE AXOpen.Data
    ///<summary>
    /// Provides abastaction for data exchange.      
    /// </summary>   
    INTERFACE IAxoDataExchange        
        METHOD Create : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD       
        
        METHOD Read : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD 

        METHOD Update : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD 

        METHOD Delete : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD 

        METHOD EntityExist : IAxoEntityExistTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD 

        METHOD CreateOrUpdate : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD 

        METHOD Restore        
        END_METHOD 
        
        METHOD Run 
            VAR_INPUT
                context : IAxoContext;
            END_VAR
            
        END_METHOD

        METHOD Run 
            VAR_INPUT
                parent : IAxoObject;
            END_VAR            
        END_METHOD
    END_INTERFACE
END_NAMESPACE    
