USING AXOpen.Core;

NAMESPACE ix.framework.data 
    INTERFACE IDataExchange
        METHOD Create : IIxTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD       
        
        METHOD Read : IIxTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD 

        METHOD Update : IIxTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD 

        METHOD Delete : IIxTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR        
        END_METHOD 

        METHOD Restore        
        END_METHOD    
    END_INTERFACE
END_NAMESPACE    