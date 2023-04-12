USING AXOpen.Core;

NAMESPACE AXOpen.Data 
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

        METHOD Restore        
        END_METHOD    
    END_INTERFACE
END_NAMESPACE    