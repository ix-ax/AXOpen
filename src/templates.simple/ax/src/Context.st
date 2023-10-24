USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE axosimple
    CLASS PUBLIC Context EXTENDS AxoContext                   
        VAR PUBLIC
            ProcessData : ProcessData;            
            StarterUnitTemplate : axosimple.StarterUnitTemplate.Unit;                
            UnitTemplate : axosimple.UnitTemplate.Unit;
            Inputs : REF_TO axosimple.Inputs;
            Outputs : REF_TO axosimple.Outputs; 

            StarterUnitTemplateProcessData : axosimple.StarterUnitTemplate.ProcessDataManger;
            UnitTemplateProcessData : axosimple.UnitTemplate.ProcessDataManger;
        END_VAR      
        
        METHOD PROTECTED OVERRIDE Main                                               
           IF(Inputs <> NULL AND Outputs <> NULL) THEN    
               StarterUnitTemplate.ProcessData := REF(StarterUnitTemplateProcessData);
               StarterUnitTemplate.Run(THIS, Inputs^, Outputs^);   
            ;
               UnitTemplate.ProcessData := REF(UnitTemplateProcessData);                                             
               UnitTemplate.Run(THIS, Inputs^, Outputs^);               
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
            Header : SharedProductionData;
        END_VAR        
    END_CLASS
    
    CLASS ProcessData EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Header : SharedProductionDataManager;            
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Starter : axosimple.StarterUnitTemplate.FragmentProcessDataManger;
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Unit : axosimple.UnitTemplate.FragmentProcessDataManger;
        END_VAR        
    END_CLASS
END_NAMESPACE

