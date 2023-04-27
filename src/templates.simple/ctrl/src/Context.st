USING examples;
USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE axosimple
    CLASS PUBLIC Context EXTENDS AxoContext                   
        VAR PUBLIC
            PneumaticManipulator : examples.PneumaticManipulator.CU;            
            ProductionSettings : ProductionSettingsHandler;
            Inputs : REF_TO axosimple.Inputs;
            Outputs : REF_TO axosimple.Outputs;
        END_VAR      
        
        METHOD PROTECTED OVERRIDE Main
            
            ProductionSettings.Run(THIS);

            IF(Inputs <> NULL AND Outputs <> NULL) THEN                
                PneumaticManipulator.Run(THIS, Inputs^, Outputs^);               
            END_IF;    
        END_METHOD        
    END_CLASS
    
    CLASS ProductionSettingsHandler EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            _data : ProductionSettings;
        END_VAR        
    END_CLASS

    CLASS ProductionSettings EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            StepDelay : TIME;
        END_VAR        
    END_CLASS
END_NAMESPACE

