USING AXOpen.Core;
USING AXOpen.Data;
USING AXOpen.Probers;

NAMESPACE IntegrationLightDirect    
    {S7.extern=ReadWrite}
    CLASS DataExchangeLightTestsContext EXTENDS AxoContext
        VAR PUBLIC
            DM : IAxoDataExchange;
            CreateTest : DataCreateTest;
            ReadTest : DataReadTest;
            UpdateTest : DataUpdateTest;     
            DeleteTest : DataDeleteTest;       
        END_VAR 
      
        METHOD PUBLIC InjectDM
            VAR_INPUT
                iDM : IAxoDataExchange;
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

    

    {S7.extern=ReadWrite}
    CLASS DataCreateTest EXTENDS AxoProberWithCompletedCondition
        VAR PUBLIC   
            Manager : IAxoDataExchange;         
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
                Injectee : IAxoDataExchange;      
            END_VAR    
            Manager := Injectee;
        END_METHOD    
    END_CLASS
   
    {S7.extern=ReadWrite}
    CLASS DataReadTest EXTENDS AxoProberWithCompletedCondition
        VAR PUBLIC   
            Manager : IAxoDataExchange;         
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
                Injectee : IAxoDataExchange;      
            END_VAR    
            Manager := Injectee;
        END_METHOD    
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS DataUpdateTest EXTENDS AxoProberWithCompletedCondition
        VAR PUBLIC   
            Manager : IAxoDataExchange;         
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
                Injectee : IAxoDataExchange;      
            END_VAR    
            Manager := Injectee;
        END_METHOD    
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS DataDeleteTest EXTENDS AxoProberWithCompletedCondition
        VAR PUBLIC   
            Manager : IAxoDataExchange;         
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
                Injectee : IAxoDataExchange;      
            END_VAR    
            Manager := Injectee;
        END_METHOD    
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS DataManager EXTENDS AXOpen.Data.AxoDataExchange 
        VAR PUBLIC     
            {#ix-generic:TOnline}              
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AxoDataEntityAttribute]}         
            _data       : DataSet;
        END_VAR          
    END_CLASS    
    
    {S7.extern=ReadWrite}
    CLASS DataSet EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            SomeData : STRING;
        END_VAR 
    END_CLASS  
    
END_NAMESPACE

 
