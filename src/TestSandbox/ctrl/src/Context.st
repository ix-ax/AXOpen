
USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE sandboxtest
    CLASS PUBLIC Context EXTENDS AxoContext                   
        VAR PUBLIC
            
            // pre dotiahnutie receptu do stanice
            EntireProcessData : EntireProcessDataManager;
           
            // pre ceklovy nahlad ku konkretnemu kusu zo vsetkych stanic...
            EntireProductionData : EntireProcessDataManager;
           
            Cu_1 : StandardControlUnit.CU;            
            Cu_2 : StandardControlUnit.CU;            
            Cu_3 : StandardControlUnit.CU;            
            Cu_4 : StandardControlUnit.CU;            
            Cu_5 : StandardControlUnit.CU;            
            Cu_6 : StandardControlUnit.CU;            
            Cu_7 : StandardControlUnit.CU;            
            Cu_8 : StandardControlUnit.CU;

            ProcessDataCu_1 : StandardControlUnit.ProcessDataManger;            
            ProcessDataCu_2 : StandardControlUnit.ProcessDataManger;            
            ProcessDataCu_3 : StandardControlUnit.ProcessDataManger;            
            ProcessDataCu_4 : StandardControlUnit.ProcessDataManger;            
            ProcessDataCu_5 : StandardControlUnit.ProcessDataManger;            
            ProcessDataCu_6 : StandardControlUnit.ProcessDataManger;            
            ProcessDataCu_7 : StandardControlUnit.ProcessDataManger;            
            ProcessDataCu_8 : StandardControlUnit.ProcessDataManger;


            Inputs : REF_TO sandboxtest.Inputs;
            Outputs : REF_TO sandboxtest.Outputs; 


            GlobalService   : ModeInvoker;
            GlobalAuto      : ModeInvoker;
            GlobalGround    : ModeInvoker;


            TaskInst_1   : ModeInvoker;
            TaskInst_2   : ModeInvoker;
            TaskInst_3   : ModeInvoker;
            TaskInst_4   : ModeInvoker;
            TaskInst_5   : ModeInvoker;
            TaskInst_6   : ModeInvoker;
            TaskInst_7      : ModeInvoker;
            TaskInst_8   : ModeInvoker;
            TaskInst_9   : ModeInvoker;

            TaskInst_11   : ModeInvoker;
            TaskInst_12   : ModeInvoker;
            TaskInst_13   : ModeInvoker;
            TaskInst_14   : ModeInvoker;
            TaskInst_15   : ModeInvoker;
            TaskInst_16   : ModeInvoker;
            TaskInst_17      : ModeInvoker;
            TaskInst_18   : ModeInvoker;
            TaskInst_19   : ModeInvoker;













        END_VAR      
        
        METHOD PROTECTED OVERRIDE Main                                   
            IF(Inputs <> NULL AND Outputs <> NULL) THEN 

                CU_1.ProcessData := REF(ProcessDataCu_1);
                CU_2.ProcessData := REF(ProcessDataCu_2);
                CU_3.ProcessData := REF(ProcessDataCu_3);
                CU_4.ProcessData := REF(ProcessDataCu_4);
                CU_5.ProcessData := REF(ProcessDataCu_5);
                CU_6.ProcessData := REF(ProcessDataCu_6);
                CU_7.ProcessData := REF(ProcessDataCu_7);
                CU_8.ProcessData := REF(ProcessDataCu_8);

                CU_1.Run(THIS,'CU_1',EntireProcessData,REF(EntireProcessData.Cu1.Set), Inputs^, Outputs^); 
                CU_2.Run(THIS,'CU_2',EntireProcessData,REF(EntireProcessData.Cu2.Set), Inputs^, Outputs^); 
                CU_3.Run(THIS,'CU_3',EntireProcessData,REF(EntireProcessData.Cu3.Set), Inputs^, Outputs^); 
                CU_4.Run(THIS,'CU_4',EntireProcessData,REF(EntireProcessData.Cu4.Set), Inputs^, Outputs^); 
                CU_5.Run(THIS,'CU_5',EntireProcessData,REF(EntireProcessData.Cu5.Set), Inputs^, Outputs^); 
                CU_6.Run(THIS,'CU_6',EntireProcessData,REF(EntireProcessData.Cu6.Set), Inputs^, Outputs^); 
                CU_7.Run(THIS,'CU_7',EntireProcessData,REF(EntireProcessData.Cu7.Set), Inputs^, Outputs^); 
                CU_8.Run(THIS,'CU_8',EntireProcessData,REF(EntireProcessData.Cu8.Set), Inputs^, Outputs^); 


                EntireProcessData.Run(THIS); // AKO NA TO ????
                
                GlobalAuto.Run(10,REF(THIS));
                GlobalGround.Run(20,REF(THIS));
                GlobalService.Run(30,REF(THIS));

            END_IF;  
        END_METHOD        
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

    CLASS EntireProcessDataManager EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Set : SharedProductionDataManager;            
           
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Cu1 : StandardControlUnit.FragmentProcessDataManger;

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Cu2 : StandardControlUnit.FragmentProcessDataManger;

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Cu3 : StandardControlUnit.FragmentProcessDataManger;

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Cu4 : StandardControlUnit.FragmentProcessDataManger;

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Cu5 : StandardControlUnit.FragmentProcessDataManger;

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Cu6 : StandardControlUnit.FragmentProcessDataManger;

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Cu7 : StandardControlUnit.FragmentProcessDataManger;

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Cu8 : StandardControlUnit.FragmentProcessDataManger;
            counter : INT;
        END_VAR              
    END_CLASS

    CLASS PUBLIC ModeInvoker EXTENDS AXOpen.Core.AxoTask
        ///<summary>
        /// Runs service mode logic. This method must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                iMode :   int; // 10 auto, 20 grou, 30 service
                parentContext : REF_TO sandboxtest.Context;
            END_VAR
 
            VAR
                _Mode : int;
                _Context : REF_TO sandboxtest.Context;
            END_VAR;

            _Mode := iMode;
            _Context := parentContext;

            THIS.Initialize(_Context^);
 
            IF THIS.Execute() THEN
                THIS.Handle(_Mode, _Context);
            END_IF;
        END_METHOD
 
        METHOD PRIVATE Handle
           VAR_INPUT
                iMode: int; 
                parentContext : REF_TO sandboxtest.Context;
            END_VAR
            
            
            if      (parentContext^.Cu_1.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_2.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_3.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_4.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_5.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_6.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_7.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_8.InvokeMode(iMode) = iMode)
            then 
                THIS.DoneWhen(true);
            end_if;

           END_METHOD
    END_CLASS

   
END_NAMESPACE

