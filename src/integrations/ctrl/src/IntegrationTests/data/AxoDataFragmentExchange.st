USING AXOpen.Core;
USING AXOpen.Data;
USING AXOpen.Probers;

NAMESPACE IntegrationAxoDataFramentsExchange  
    
    CLASS AxoDataFragmentExchangeContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            PD : ProcessData;
            CreateTest : DataCreateTest;
            ReadTest : DataReadTest;
            UpdateTest : DataUpdateTest;
            DeleteTest : DataDeleteTest;
        END_VAR
        
        
        METHOD PROTECTED OVERRIDE Main

            PD.Run(THIS); 

            CreateTest.InjectManger(PD);
            CreateTest.Run(THIS);

            ReadTest.InjectManger(PD);
            ReadTest.Run(THIS);

            DeleteTest.InjectManger(PD);
            DeleteTest.Run(THIS);

            UpdateTest.InjectManger(PD);
            UpdateTest.Run(THIS);           
        END_METHOD

    END_CLASS

    CLASS ProcessData EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Set : SharedProductionDataManager;            
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Manip : FragmentProcessDataManger;
        END_VAR
    END_CLASS

    CLASS SharedProductionData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            ComesFrom : INT;
            GoesTo : INT;
        END_VAR        
    END_CLASS

    CLASS SharedProductionDataManager EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            {#ix-attr:[Container(Layout.Stack)]}    
            Set : SharedProductionData;
        END_VAR        
    END_CLASS
        
    CLASS FragmentProcessDataManger
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}        
            {#ix-attr:[Container(Layout.Stack)]}        
            Set : FragmentProcessData;
        END_VAR
    END_CLASS

    CLASS FragmentProcessData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            CounterDelay : ULINT;
        END_VAR
    END_CLASS

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
END_NAMESPACE