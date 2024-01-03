NAMESPACE axosimple
    USING axosimple.Safety;
    USING AXOpen.Core;
    USING System.Strings;
           
  
    {S7.extern=ReadWrite}
    CLASS PUBLIC TechnologySafety EXTENDS AXOpen.Core.AxoObject 
        VAR PUBLIC
            Zone_1 : axosimple.SafetyZone_1;

            Zone_2 : axosimple.SafetyZone_2;
        END_VAR
       
        METHOD PUBLIC Run 
            VAR_INPUT
                parent : AXOpen.Core.IAxoContext;
            END_VAR

            IF(_context_ <> parent) THEN
                THIS.Initialize(parent);  
            END_IF;

            Zone_1.Run(THIS);
            Zone_2.Run(THIS);
            
        END_METHOD
       
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC SafetyZone_1 EXTENDS AXOpen.Core.AxoObject 
        VAR PUBLIC
            LogicController : axosimple.Safety.BaseZoneLogic;

            Panel_1 : axosimple.Safety.ControlPanel;
            Panel_2 : axosimple.Safety.ControlPanel;

            EStop_External_1 : axosimple.Safety.EmergencyStop;
            EStop_External_2 : axosimple.Safety.EmergencyStop;

            Door_1 : axosimple.Safety.Door;
            Door_2 : axosimple.Safety.Door;
        END_VAR

        METHOD PUBLIC Run 
            VAR_INPUT
                parent : AXOpen.Core.IAxoObject;
            END_VAR

            LogicController.Run(parent);
            
            Panel_1.Run(parent);
            Panel_2.Run(parent);
            
            EStop_External_1.Run(parent);
            EStop_External_2.Run(parent);
            
            Door_1.Run(parent);
            Door_2.Run(parent);
        END_METHOD

    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC SafetyZone_2 EXTENDS AXOpen.Core.AxoObject 
        VAR PUBLIC
            LogicController : axosimple.Safety.BaseZoneLogic;
            Panel_1 : axosimple.Safety.ControlPanel;
            EStop_External_1 : axosimple.Safety.EmergencyStop;
            Door_1 : axosimple.Safety.Door;
        END_VAR

        METHOD PUBLIC Run 
            VAR_INPUT
                parent : AXOpen.Core.IAxoObject;
            END_VAR

            LogicController.Run(parent);
            
            Panel_1.Run(parent);
            
            EStop_External_1.Run(parent);
            
            Door_1.Run(parent);
        END_METHOD
    END_CLASS
   
END_NAMESPACE