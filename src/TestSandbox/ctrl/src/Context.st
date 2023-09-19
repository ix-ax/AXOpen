
USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE sandboxtest
    CLASS PUBLIC Context EXTENDS AxoContext                   
        VAR PUBLIC
            
            // pre dotiahnutie receptu do stanice
            EntireProcessData : EntireProcessDataManager;
           
            // pre ceklovy nahlad ku konkretnemu kusu zo vsetkych stanic...
            EntireProductionData : EntireProcessDataManager;
           
            Cu_0 : StandardControlUnit.CU; 
            Cu_1 : StandardControlUnit.CU;                
            Cu_2 : StandardControlUnit.CU;            
            // Cu_3 : StandardControlUnit.CU;            
            // Cu_4 : StandardControlUnit.CU;            
            // Cu_5 : StandardControlUnit.CU;            
            // Cu_6 : StandardControlUnit.CU;            
            // Cu_7 : StandardControlUnit.CU;            
            // Cu_8 : StandardControlUnit.CU;
            // Cu_9 : StandardControlUnit.CU;

            // Cu_10 : StandardControlUnit.CU; 
            // Cu_11 : StandardControlUnit.CU;                
            // Cu_12 : StandardControlUnit.CU;            
            // Cu_13 : StandardControlUnit.CU;            
            // Cu_14 : StandardControlUnit.CU;            
            // Cu_15 : StandardControlUnit.CU;            
            // Cu_16 : StandardControlUnit.CU;            
            // Cu_17 : StandardControlUnit.CU;            
            // Cu_18 : StandardControlUnit.CU;
            // Cu_19 : StandardControlUnit.CU;

                                                                        {#ix-set:AttributeName = "PD CU 0"} 
            ProcessDataCu_0 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 1"}         
            ProcessDataCu_1 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 2"}         
            ProcessDataCu_2 : StandardControlUnit.ProcessDataManger;   // {#ix-set:AttributeName = "PD CU 3"}         
            // ProcessDataCu_3 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 4"}         
            // ProcessDataCu_4 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 5"}         
            // ProcessDataCu_5 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 6"}         
            // ProcessDataCu_6 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 7"}         
            // ProcessDataCu_7 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 8"}         
            // ProcessDataCu_8 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 9"} 
            // ProcessDataCu_9 : StandardControlUnit.ProcessDataManger;


            //                                                              {#ix-set:AttributeName = "PD CU 10"} 
            // ProcessDataCu_10 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 11"}         
            // ProcessDataCu_11 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 12"}         
            // ProcessDataCu_12 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 13"}         
            // ProcessDataCu_13 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 14"}         
            // ProcessDataCu_14 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 15"}         
            // ProcessDataCu_15 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 16"}         
            // ProcessDataCu_16 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 17"}         
            // ProcessDataCu_17 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 18"}         
            // ProcessDataCu_18 : StandardControlUnit.ProcessDataManger;    {#ix-set:AttributeName = "PD CU 19"} 
            // ProcessDataCu_19 : StandardControlUnit.ProcessDataManger;
                                                           
            
            Inputs : REF_TO sandboxtest.Inputs;
            Outputs : REF_TO sandboxtest.Outputs; 


            GlobalService   : ModeInvoker;
            GlobalAuto      : ModeInvoker;
            GlobalGround    : ModeInvoker;


            // TaskInst_1   : ModeInvoker;
            // TaskInst_2   : ModeInvoker;
            // TaskInst_3   : ModeInvoker;

            // TaskInst_4   : ModeInvoker;
            // TaskInst_5   : ModeInvoker;
            // TaskInst_6   : ModeInvoker;
            // TaskInst_7   : ModeInvoker;
            // TaskInst_8   : ModeInvoker;
            // TaskInst_9   : ModeInvoker;

            // TaskInst_11   : ModeInvoker;
            // TaskInst_12   : ModeInvoker;
            // TaskInst_13   : ModeInvoker;
            // TaskInst_14   : ModeInvoker;
            // TaskInst_15   : ModeInvoker;
            // TaskInst_16   : ModeInvoker;
            // TaskInst_17      : ModeInvoker;
            // TaskInst_18   : ModeInvoker;
            // TaskInst_19   : ModeInvoker;













        END_VAR      
        
        METHOD PROTECTED OVERRIDE Main                                   
            IF(Inputs <> NULL AND Outputs <> NULL) THEN 

                CU_0.ProcessData := REF(ProcessDataCu_0);
                CU_1.ProcessData := REF(ProcessDataCu_1);
                CU_2.ProcessData := REF(ProcessDataCu_2);
                // CU_3.ProcessData := REF(ProcessDataCu_3);
                // CU_4.ProcessData := REF(ProcessDataCu_4);
                // CU_5.ProcessData := REF(ProcessDataCu_5);
                // CU_6.ProcessData := REF(ProcessDataCu_6);
                // CU_7.ProcessData := REF(ProcessDataCu_7);
                // CU_8.ProcessData := REF(ProcessDataCu_8);
                // CU_9.ProcessData := REF(ProcessDataCu_9);

                // CU_10.ProcessData := REF(ProcessDataCu_10);
                // CU_11.ProcessData := REF(ProcessDataCu_11);
                // CU_12.ProcessData := REF(ProcessDataCu_12);
                // CU_13.ProcessData := REF(ProcessDataCu_13);
                // CU_14.ProcessData := REF(ProcessDataCu_14);
                // CU_15.ProcessData := REF(ProcessDataCu_15);
                // CU_16.ProcessData := REF(ProcessDataCu_16);
                // CU_17.ProcessData := REF(ProcessDataCu_17);
                // CU_18.ProcessData := REF(ProcessDataCu_18);
                // CU_19.ProcessData := REF(ProcessDataCu_19);



                CU_0.Run(THIS,'CU_0',EntireProcessData,REF(EntireProcessData.Cu0.Set), Inputs^, Outputs^); 
                CU_1.Run(THIS,'CU_1',EntireProcessData,REF(EntireProcessData.Cu1.Set), Inputs^, Outputs^); 
                CU_2.Run(THIS,'CU_2',EntireProcessData,REF(EntireProcessData.Cu2.Set), Inputs^, Outputs^); 
                // CU_3.Run(THIS,'CU_3',EntireProcessData,REF(EntireProcessData.Cu3.Set), Inputs^, Outputs^); 
                // CU_4.Run(THIS,'CU_4',EntireProcessData,REF(EntireProcessData.Cu4.Set), Inputs^, Outputs^); 
                // CU_5.Run(THIS,'CU_5',EntireProcessData,REF(EntireProcessData.Cu5.Set), Inputs^, Outputs^); 
                // CU_6.Run(THIS,'CU_6',EntireProcessData,REF(EntireProcessData.Cu6.Set), Inputs^, Outputs^); 
                // CU_7.Run(THIS,'CU_7',EntireProcessData,REF(EntireProcessData.Cu7.Set), Inputs^, Outputs^); 
                // CU_8.Run(THIS,'CU_8',EntireProcessData,REF(EntireProcessData.Cu8.Set), Inputs^, Outputs^); 
                // CU_9.Run(THIS,'CU_9',EntireProcessData,REF(EntireProcessData.Cu9.Set), Inputs^, Outputs^); 

                // CU_10.Run(THIS,'CU_10',EntireProcessData,REF(EntireProcessData.Cu10.Set), Inputs^, Outputs^); 
                // CU_11.Run(THIS,'CU_11',EntireProcessData,REF(EntireProcessData.Cu11.Set), Inputs^, Outputs^); 
                // CU_12.Run(THIS,'CU_12',EntireProcessData,REF(EntireProcessData.Cu12.Set), Inputs^, Outputs^); 
                // CU_13.Run(THIS,'CU_13',EntireProcessData,REF(EntireProcessData.Cu13.Set), Inputs^, Outputs^); 
                // CU_14.Run(THIS,'CU_14',EntireProcessData,REF(EntireProcessData.Cu14.Set), Inputs^, Outputs^); 
                // CU_15.Run(THIS,'CU_15',EntireProcessData,REF(EntireProcessData.Cu15.Set), Inputs^, Outputs^); 
                // CU_16.Run(THIS,'CU_16',EntireProcessData,REF(EntireProcessData.Cu16.Set), Inputs^, Outputs^); 
                // CU_17.Run(THIS,'CU_17',EntireProcessData,REF(EntireProcessData.Cu17.Set), Inputs^, Outputs^); 
                // CU_18.Run(THIS,'CU_18',EntireProcessData,REF(EntireProcessData.Cu18.Set), Inputs^, Outputs^); 
                // CU_19.Run(THIS,'CU_19',EntireProcessData,REF(EntireProcessData.Cu19.Set), Inputs^, Outputs^); 



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
           
                                                                    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu0"}  
            Cu0 : StandardControlUnit.FragmentProcessDataManger;    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu1"}  
            Cu1 : StandardControlUnit.FragmentProcessDataManger;    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu2"}  
            Cu2 : StandardControlUnit.FragmentProcessDataManger;   // {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu3"}  
            // Cu3 : StandardControlUnit.FragmentProcessDataManger;    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu4"}  
            // Cu4 : StandardControlUnit.FragmentProcessDataManger;    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu5"}  
            // Cu5 : StandardControlUnit.FragmentProcessDataManger;    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu6"}  
            // Cu6 : StandardControlUnit.FragmentProcessDataManger;    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu7"}  
            // Cu7 : StandardControlUnit.FragmentProcessDataManger;    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu8"}  
            // Cu8 : StandardControlUnit.FragmentProcessDataManger;    {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu9"} 
            // Cu9 : StandardControlUnit.FragmentProcessDataManger;
            
            
            //                                                         {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu10"}  
            // Cu10 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu11"}  
            // Cu11 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu12"}  
            // Cu12 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu13"}  
            // Cu13 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu14"}  
            // Cu14 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu15"}  
            // Cu15 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu16"}  
            // Cu16 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu17"}  
            // Cu17 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu18"}  
            // Cu18 : StandardControlUnit.FragmentProcessDataManger;   {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}  {#ix-set:AttributeName = "Cu19"} 
            // Cu19 : StandardControlUnit.FragmentProcessDataManger;
                                                                 
                                                               
                                                      
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
            
            
            if      (parentContext^.Cu_0.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_1.InvokeMode(iMode) = iMode)
                AND (parentContext^.Cu_2.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_3.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_4.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_5.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_6.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_7.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_8.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_9.InvokeMode(iMode) = iMode)

                // AND (parentContext^.Cu_10.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_11.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_12.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_13.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_14.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_15.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_16.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_17.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_18.InvokeMode(iMode) = iMode)
                // AND (parentContext^.Cu_19.InvokeMode(iMode) = iMode)

            then 
                THIS.DoneWhen(true);
            end_if;

           END_METHOD
    END_CLASS

   
END_NAMESPACE

