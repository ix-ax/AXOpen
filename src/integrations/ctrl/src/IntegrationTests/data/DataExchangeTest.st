USING ix.framework.core;
USING ix.framework.data;
USING ix.framework.probers;

NAMESPACE IntegrationTests    
    CLASS DataExchangeTestsContext EXTENDS IxContext
        VAR PUBLIC
            Create : DataExchangeCreateTest;
        END_VAR    

        METHOD PROTECTED OVERRIDE Main             
            Create.Initialize(THIS);
            Create.Run();
        END_METHOD
    END_CLASS

    CLASS DataExchangeCreateTest EXTENDS ProberWithCompletedCondition
        VAR PUBLIC
            Manager : DataExchangeManager;
            Identifier : STRING[254];
        END_VAR           
        METHOD PROTECTED OVERRIDE Test : BOOL   
            Manager.Initialize(THIS); 
            Test := Manager.Create(Identifier).IsDone();
            Manager.Run();                    
            THIS.ThrowWhen(Manager.CreateTask.Status = eIxTaskState#Error);
            THIS.FailureDescription := Manager.CreateTask.ExceptionMessage;
        END_METHOD

        METHOD OVERRIDE OnRestore            
            SUPER.OnRestore();
            Manager.Restore();
        END_METHOD
    END_CLASS

    CLASS DataExchangeManager EXTENDS DataExchange 
        VAR PUBLIC              
            _data       : DataSet;
        END_VAR          
    END_CLASS    

    CLASS DataSet EXTENDS DataEntity
        VAR PUBLIC
            SomeData : STRING;
        END_VAR 
    END_CLASS   
END_NAMESPACE