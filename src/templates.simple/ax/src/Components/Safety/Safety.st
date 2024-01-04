NAMESPACE axosimple.Safety
    USING axosimple;
    USING AXOpen.Core;
    USING System.Strings;
           
  
    {S7.extern=ReadWrite}
    CLASS PUBLIC BaseZoneLogic EXTENDS AXOpen.Core.AxoObject IMPLEMENTS axosimple.Safety.IZone
        VAR PUBLIC
            AllUnitInAuto : BOOL;
            AllUnitInGrounded : BOOL;
            AllUnitInService : BOOL;

            AllKeysMan : BOOL;
            AllKeysAuto : BOOL;
        END_VAR

        METHOD PUBLIC Run 
            VAR_INPUT
                parent : AXOpen.Core.IAxoObject;
            END_VAR

            IF(_context_ <> parent) THEN
                THIS.Initialize(parent); 
            ELSE
               ; //some logic
            END_IF;
            
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC ControlPanel EXTENDS AXOpen.Core.AxoObject IMPLEMENTS axosimple.Safety.IControlPanel
        VAR PUBLIC
            EStop : axosimple.Safety.EmergencyStop;
            ButtonStart : AXOpen.Elements.AxoDi;
            ButtonStop : AXOpen.Elements.AxoDi;
            KeyManual : AXOpen.Elements.AxoDi;
            KeyAuto : AXOpen.Elements.AxoDi;
        END_VAR

        METHOD PUBLIC Run 
            VAR_INPUT
                parent : AXOpen.Core.IAxoObject;
            END_VAR

            IF(_context_ <> parent) THEN
                THIS.Initialize(parent); 
            ELSE
                EStop.Run(THIS);
                ButtonStart.Run(THIS);
                ButtonStop.Run(THIS);
                KeyManual.Run(THIS);
                KeyAuto.Run(THIS);
            END_IF;
            
        END_METHOD

    END_CLASS

      
    {S7.extern=ReadWrite}
    CLASS PUBLIC Door EXTENDS AXOpen.Core.AxoObject IMPLEMENTS axosimple.Safety.IDoor
        VAR PUBLIC
            Lock : AXOpen.Components.Pneumatics.AxoCylinder;
        END_VAR

        VAR 

        END_VAR

        METHOD PUBLIC Run 
            VAR_INPUT
                parent : AXOpen.Core.IAxoObject;
            END_VAR

            IF(_context_ <> parent) THEN
                THIS.Initialize(parent); 
            ELSE
                Lock.Run(THIS);
            END_IF;
            
        END_METHOD

    END_CLASS
   

    {S7.extern=ReadWrite}
    CLASS PUBLIC EmergencyStop EXTENDS AXOpen.Elements.AxoDi IMPLEMENTS axosimple.Safety.IEmergencyStop
        VAR PUBLIC
           
        END_VAR

       
    END_CLASS


END_NAMESPACE