USING AXOpen.Core;

NAMESPACE axosimple.SampleControlledUnit 
    {#ix-set:AttributeName = "<#SERVICE#>"}  
    CLASS PUBLIC ServiceMode EXTENDS AXOpen.Core.AxoTask
        METHOD PUBLIC Run 
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    
            VAR_IN_OUT                
                components : Components;
            END_VAR  
            
            THIS.Initialize(parent);

            IF THIS.Execute() THEN
                THIS.Handle(components);
            END_IF;    
        END_METHOD    

        METHOD PRIVATE Handle
            VAR_IN_OUT
                components : Components;
            END_VAR
            components.HorizontalCylinder.ActivateManualControl();
            components.VerticalCylinder.ActivateManualControl();
            components.GripperCylinder.ActivateManualControl();
        END_METHOD
                  
    END_CLASS
END_NAMESPACE        