USING examples;
USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE axosimple
    CLASS PUBLIC Context EXTENDS AxoContext                   
        VAR PUBLIC
            ProcessData : ProcessData;
            PneumaticManipulator : examples.PneumaticManipulator.CU;            
            PneumaticManipulator2 : examples.PneumaticManipulator.CU;                      
            Inputs : REF_TO axosimple.Inputs;
            Outputs : REF_TO axosimple.Outputs;
        END_VAR      
        
        METHOD PROTECTED OVERRIDE Main                                   
           IF(Inputs <> NULL AND Outputs <> NULL) THEN                
               PneumaticManipulator.Run(THIS, Inputs^, Outputs^);   
               PneumaticManipulator2.Run(THIS, Inputs^, Outputs^);               
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
    
    CLASS ProcessData EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Set : SharedProductionDataManager;            
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Manip : examples.PneumaticManipulator.FragmentProcessDataManger;
        END_VAR        
    END_CLASS
END_NAMESPACE

