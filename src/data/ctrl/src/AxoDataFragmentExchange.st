USING AXOpen.Core;

NAMESPACE AXOpen.Data    
    CLASS PUBLIC AxoDataFragmentExchange EXTENDS AxoObject IMPLEMENTS IAxoDataExchange               
        VAR PUBLIC           
            Operation : AxoDataCrudTask;
        END_VAR   
                
        METHOD PUBLIC Create : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR 
            Create := Operation.Invoke(Identifier, eCrudOperation#Create);       
        END_METHOD       
        
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR  
            Read := Operation.Invoke(Identifier, eCrudOperation#Read);             
        END_METHOD 
    
        METHOD PUBLIC Update : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR  
            Update := Operation.Invoke(Identifier, eCrudOperation#Read);        
        END_METHOD 
    
        METHOD PUBLIC Delete : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            Delete := Operation.Invoke(Identifier, eCrudOperation#Read);         
        END_METHOD 
    
        METHOD PUBLIC Restore  
            Operation.Restore();      
        END_METHOD    
    END_CLASS 
END_NAMESPACE
