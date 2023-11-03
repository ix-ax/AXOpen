USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE axosimple
    CLASS PUBLIC Context EXTENDS AxoContext                   
        VAR PUBLIC
            TechnologySettings : TechnologyData;
            ProcessSettings : ProcessData;
            ProcessData : ProcessData;                        
            Inputs : REF_TO axosimple.Inputs;
            Outputs : REF_TO axosimple.Outputs; 
            // Units - You can use snippet unitDeclaration 
        StarterUnitTemplate : axosimple.StarterUnitTemplate.Unit;
        StarterUnitTemplateProcessData : axosimple.StarterUnitTemplate.ProcessDataManager;
        StarterUnitTemplateTechnologyData : axosimple.StarterUnitTemplate.TechnologyDataManager;
        
            
        UnitTemplate : axosimple.UnitTemplate.Unit;
        UnitTemplateProcessData : axosimple.UnitTemplate.ProcessDataManager;
        UnitTemplateTechnologyData : axosimple.UnitTemplate.TechnologyDataManager;
        
        
        END_VAR      
        
        METHOD PROTECTED OVERRIDE Main     
            TechnologySettings.Run(THIS);
            ProcessSettings.Run(THIS);
            ProcessData.Run(THIS);
            
           IF(Inputs <> NULL AND Outputs <> NULL) THEN   
               ;//Units entry calls - You can use snippet unitRootCall
            
               StarterUnitTemplate.ProcessData := REF(StarterUnitTemplateProcessData);
               StarterUnitTemplate.TechnologyData := REF(StarterUnitTemplateTechnologyData);
               StarterUnitTemplate.Run(THIS, Inputs^, Outputs^);
                   
               UnitTemplate.ProcessData := REF(UnitTemplateProcessData);
               UnitTemplate.TechnologyData := REF(UnitTemplateTechnologyData);
               UnitTemplate.Run(THIS, Inputs^, Outputs^);
            

                                             
           END_IF;                           
        END_METHOD        
    END_CLASS   
             
    CLASS ProcessData EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Entity : EntityHeaderDataManager;   
            // Units data - You can use snippet unitAddProcessData
              {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
              UnitTemplate : axosimple.UnitTemplate.FragmentProcessDataManger;
              {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
              StarterUnitTemplate : axosimple.StarterUnitTemplate.FragmentProcessDataManger;
                                                   
            
        END_VAR        
    END_CLASS

    CLASS TechnologyData EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Common : TechnologyCommonDataManager;   
            // Units technology data - You can use snippet unitAddTechnologyData
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            UnitTemplate : axosimple.UnitTemplate.FragmentTechnologyDataManger;

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            StarterUnitTemplate : axosimple.StarterUnitTemplate.FragmentTechnologyDataManger;
        END_VAR        
    END_CLASS
END_NAMESPACE

