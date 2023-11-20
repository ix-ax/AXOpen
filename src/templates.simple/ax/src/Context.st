USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE axosimple
    CLASS PUBLIC Context EXTENDS AxoContext                   
        VAR PUBLIC
            TechnologySettings : TechnologyData;
            ProcessSettings : ProcessData;
            ProcessData : ProcessData;                        
            PersistentData : AxoDataPersistentExchange;
            GlobalObjects : GlobalContextObjects;
            
            Inputs : REF_TO axosimple.Inputs;
            Outputs : REF_TO axosimple.Outputs; 
            // Units - You can use snippet unitDeclaration 

        StarterUnitTemplate : axosimple.StarterUnitTemplate.Unit;
        StarterUnitTemplateProcessData : axosimple.StarterUnitTemplate.ProcessDataManager;
        StarterUnitTemplateTechnologySettings : axosimple.StarterUnitTemplate.TechnologyDataManager;
        
            
        UnitTemplate : axosimple.UnitTemplate.Unit;
        UnitTemplateProcessData : axosimple.UnitTemplate.ProcessDataManager;
        UnitTemplateTechnologySettings : axosimple.UnitTemplate.TechnologyDataManager;
         
        END_VAR      
        
        METHOD PROTECTED OVERRIDE Main    
                        
            TechnologySettings.Run(THIS);
            ProcessSettings.Run(THIS);
            ProcessData.Run(THIS);
            PersistentData.Run(THIS);
            
            // initialize grogal object references
            GlobalObjects.TechnologySettings    := REF(TechnologySettings);
            GlobalObjects.ProcessSettings       := REF(ProcessSettings);
            GlobalObjects.PersistentData := REF(PersistentData);
            GlobalObjects.ProcessData    := REF(ProcessData);
                        
            // remember last selected identifier 
            // if  (GlobalObjects.LastTechnologySettings <> '') THEN
            //     IF GlobalObjects.LastTechnologySettings <> TechnologySettings.Common.Entity.DataEntityId THEN 
            //         IF PersistentData.InvokeUpdate(TechnologySettings, '') THEN 
            //             GlobalObjects.LastTechnologySettings := TechnologySettings.Common.Entity.DataEntityId;
            //        END_IF;
            //     END_IF;
            // END_IF;

           IF(Inputs <> NULL AND Outputs <> NULL) THEN
               ;//Units entry calls - You can use snippet unitRootCall
            
                StarterUnitTemplate.UnitObjects.StationNumber := eStations#StarterUnitTemplate;
                StarterUnitTemplate.UnitObjects.TechnologySettings := REF(StarterUnitTemplateTechnologySettings);
                StarterUnitTemplate.UnitObjects.ProcessSettings := REF(ProcessSettings.StarterUnitTemplate);
                StarterUnitTemplate.UnitObjects.ProcessData := REF(StarterUnitTemplateProcessData);
                StarterUnitTemplate.UnitObjects.Global := REF(GlobalObjects);
                StarterUnitTemplate.Run(THIS, Inputs^, Outputs^);


                UnitTemplate.UnitObjects.StationNumber := eStations#UnitTemplate;
                UnitTemplate.UnitObjects.TechnologySettings := REF(UnitTemplateTechnologySettings);
                UnitTemplate.UnitObjects.ProcessSettings := REF(ProcessSettings.UnitTemplate);
                UnitTemplate.UnitObjects.ProcessData := REF(UnitTemplateProcessData);
                UnitTemplate.UnitObjects.Global := REF(GlobalObjects);
                UnitTemplate.Run(THIS, Inputs^, Outputs^);
           END_IF;                           
        END_METHOD        
    END_CLASS   
             
    CLASS PUBLIC GlobalContextObjects
        VAR PUBLIC
            {#ix-attr:[AXOpen.Data.PersistentAttribute("")]}
            LastTechnologySettings : STRING ;

            PersistentData      : REF_TO axosimple.AxoDataPersistentExchange;
            ProcessSettings     : REF_TO axosimple.ProcessData;
            TechnologySettings  : REF_TO axosimple.TechnologyData;
            ProcessData         : REF_TO axosimple.ProcessData;
        END_VAR
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

