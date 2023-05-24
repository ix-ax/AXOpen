USING AXOpen.Core;
USING AXOpen.Core;
USING AXOpen.Core;

NAMESPACE AXOpen.Data    
    CLASS PUBLIC AxoDataFragmentExchange EXTENDS AxoDataExchangeBase IMPLEMENTS IAxoDataExchange               
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
            Update := Operation.Invoke(Identifier, eCrudOperation#Update);        
        END_METHOD 
    
        METHOD PUBLIC Delete : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            Delete := Operation.Invoke(Identifier, eCrudOperation#Delete);         
        END_METHOD 
    
        METHOD PUBLIC Restore  
            Operation.Restore();      
        END_METHOD 
        
        METHOD PUBLIC Run 
            VAR_INPUT
                context : IAxoContext;
            END_VAR
            THIS.Initialize(context);
            Operation.Initialize(THIS);
            Operation.Execute();
        END_METHOD

        METHOD PUBLIC Run 
            VAR_INPUT
                parent : IAxoObject;
            END_VAR
            THIS.Initialize(parent);
            Operation.Initialize(THIS);
            Operation.Execute();
        END_METHOD

    END_CLASS 
END_NAMESPACE
