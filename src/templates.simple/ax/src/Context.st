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
            
                        
        END_VAR      
        
        METHOD PROTECTED OVERRIDE Main                                               
           IF(Inputs <> NULL AND Outputs <> NULL) THEN   
               ;//Units entry calls - You can use snippet unitRootCall
               
            
                                             
           END_IF;                           
        END_METHOD        
    END_CLASS   
             
    CLASS ProcessData EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Entity : EntityHeaderDataManager;   
            // Units data - You can use snippet unitAddProcessData
                                                   

    CLASS TechnologyData EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Common : TechnologyCommonDataManager;   
            // Units technology data - You can use snippet unitAddTechnologyData
                                                  
        END_VAR        
    END_CLASS
END_NAMESPACE

