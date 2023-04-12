USING AXOpen.Core;
USING AXOpen.Data;
USING ix.framework.probers;

NAMESPACE IntegrationLightDirect    
    CLASS DataExchangeLightTestsContext EXTENDS AxoContext
        VAR PUBLIC
            DM : IDataExchange;
            CreateTest : DataCreateTest;
            ReadTest : DataReadTest;
            UpdateTest : DataUpdateTest;     
            DeleteTest : DataDeleteTest;       
        END_VAR 
      
        METHOD PUBLIC InjectDM
            VAR_INPUT
                iDM : IDataExchange;
            END_VAR    
            DM := iDM;
        END_METHOD    

        METHOD PROTECTED OVERRIDE Main
            CreateTest.InjectManger(DM);
            CreateTest.Run(THIS);

            ReadTest.InjectManger(DM);
            ReadTest.Run(THIS);

            DeleteTest.InjectManger(DM);
            DeleteTest.Run(THIS);

            UpdateTest.InjectManger(DM);
            UpdateTest.Run(THIS);
                    
        END_METHOD    
    END_CLASS

    

    CLASS DataCreateTest EXTENDS ProberWithCompletedCondition
        VAR PUBLIC   
            Manager : IDataExchange;         
            Identifier : STRING[254];
        END_VAR           
        METHOD PROTECTED OVERRIDE Test : BOOL  
            VAR
                _taskState : IAxoTaskState;
            END_VAR                                    
            IF(Manager <> NULL) THEN
                _taskState := Manager.Create(Identifier);                                                
                THIS.ThrowWhen(_taskState.HasError(), _taskState.GetErrorDetails());                
                Test := _taskState.IsDone();                
            END_IF;    
        END_METHOD      
     
        METHOD OVERRIDE OnRestore                       
            SUPER.OnRestore();            
            IF(Manager <> NULL) THEN
                 Manager.Restore();
            END_IF;     
        END_METHOD

        METHOD PUBLIC InjectManger
            VAR_INPUT
                Injectee : IDataExchange;      
            END_VAR    
            Manager := Injectee;
        END_METHOD    
    END_CLASS
   
    CLASS DataReadTest EXTENDS ProberWithCompletedCondition
        VAR PUBLIC   
            Manager : IDataExchange;         
            Identifier : STRING[254];
        END_VAR           
        METHOD PROTECTED OVERRIDE Test : BOOL  
            VAR
                _taskState : IAxoTaskState;
            END_VAR                                    
            IF(Manager <> NULL) THEN
                _taskState := Manager.Read(Identifier);                                                
                THIS.ThrowWhen(_taskState.HasError(), _taskState.GetErrorDetails());                
                Test := _taskState.IsDone();                
            END_IF;    
        END_METHOD      
     
        METHOD OVERRIDE OnRestore                       
            SUPER.OnRestore();            
            IF(Manager <> NULL) THEN
                 Manager.Restore();
            END_IF;     
        END_METHOD

        METHOD PUBLIC InjectManger
            VAR_INPUT
                Injectee : IDataExchange;      
            END_VAR    
            Manager := Injectee;
        END_METHOD    
    END_CLASS

    CLASS DataUpdateTest EXTENDS ProberWithCompletedCondition
        VAR PUBLIC   
            Manager : IDataExchange;         
            Identifier : STRING[254];
        END_VAR           
        METHOD PROTECTED OVERRIDE Test : BOOL  
            VAR
                _taskState : IAxoTaskState;
            END_VAR                                    
            IF(Manager <> NULL) THEN
                _taskState := Manager.Update(Identifier);                                                
                THIS.ThrowWhen(_taskState.HasError(), _taskState.GetErrorDetails());                
                Test := _taskState.IsDone();                
            END_IF;    
        END_METHOD      
     
        METHOD OVERRIDE OnRestore                       
            SUPER.OnRestore();            
            IF(Manager <> NULL) THEN
                 Manager.Restore();
            END_IF;     
        END_METHOD

        METHOD PUBLIC InjectManger
            VAR_INPUT
                Injectee : IDataExchange;      
            END_VAR    
            Manager := Injectee;
        END_METHOD    
    END_CLASS

    CLASS DataDeleteTest EXTENDS ProberWithCompletedCondition
        VAR PUBLIC   
            Manager : IDataExchange;         
            Identifier : STRING[254];
        END_VAR           
        METHOD PROTECTED OVERRIDE Test : BOOL  
            VAR
                _taskState : IAxoTaskState;
            END_VAR                                    
            IF(Manager <> NULL) THEN
                _taskState := Manager.Delete(Identifier);                                                
                THIS.ThrowWhen(_taskState.HasError(), _taskState.GetErrorDetails());                
                Test := _taskState.IsDone();                
            END_IF;    
        END_METHOD      
     
        METHOD OVERRIDE OnRestore                       
            SUPER.OnRestore();            
            IF(Manager <> NULL) THEN
                 Manager.Restore();
            END_IF;     
        END_METHOD

        METHOD PUBLIC InjectManger
            VAR_INPUT
                Injectee : IDataExchange;      
            END_VAR    
            Manager := Injectee;
        END_METHOD    
    END_CLASS

    CLASS DataManager EXTENDS AXOpen.Data.DataExchange 
        VAR PUBLIC     
            {#ix-attr:[DataEntityAttribute]}         
            _data       : DataSet;
        END_VAR          
    END_CLASS    
    
    CLASS DataSet EXTENDS AXOpen.Data.DataEntity
        VAR PUBLIC
            SomeData : STRING;
        END_VAR 
    END_CLASS  
    
END_NAMESPACE

 