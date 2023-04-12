USING AXOpen.Core;

NAMESPACE AXOpen.Data 
    CLASS DataExchange EXTENDS AXOpen.Core.AxoObject IMPLEMENTS IDataExchange
        VAR PUBLIC
           {#ix-set:AttributeName =  "<#Create#>"} 
           CreateTask  : DataExchangeTask; 
           {#ix-set:AttributeName =  "<#Read#>"} 
           ReadTask    : DataExchangeTask;
           {#ix-set:AttributeName =  "<#Update#>"} 
           UpdateTask  : DataExchangeTask;
           {#ix-set:AttributeName =  "<#Delete#>"} 
           DeleteTask  : DataExchangeTask;
        END_VAR
        
        METHOD PRIVATE Run
            CreateTask.Initialize(THIS);            
            ReadTask.Initialize(THIS);
            UpdateTask.Initialize(THIS);
            DeleteTask.Initialize(THIS);
            
            CreateTask.Execute();
            ReadTask.Execute();
            UpdateTask.Execute();
            DeleteTask.Execute();
        END_METHOD    

        METHOD PUBLIC Run 
            VAR_INPUT
                Parent : IAxoObject;
            END_VAR    
            THIS.Initialize(Parent);
            THIS.Run();
        END_METHOD

        METHOD PUBLIC Run 
            VAR_INPUT
                Context : IAxoContext;
            END_VAR    
            THIS.Initialize(Context);
            THIS.Run();
        END_METHOD

        METHOD PUBLIC Create : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            Create := CreateTask.Invoke(Identifier);
        END_METHOD       
        
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            Read := ReadTask.Invoke(Identifier);
        END_METHOD 

        METHOD PUBLIC Update : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            Update := UpdateTask.Invoke(Identifier);
        END_METHOD 

        METHOD PUBLIC Delete : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            Delete := DeleteTask.Invoke(Identifier);
        END_METHOD 

        METHOD PUBLIC Restore
            CreateTask.Restore();            
            ReadTask.Restore();
            UpdateTask.Restore();
            DeleteTask.Restore();
        END_METHOD    
    END_CLASS    
END_NAMESPACE