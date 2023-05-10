USING AXOpen.Core;

NAMESPACE axosimple.SampleControlledUnit 
    {#ix-set:AttributeName = "<#GROUND#>"}  
    CLASS PUBLIC GroundSequence EXTENDS AXOpen.Core.AxoSequencer
        VAR PUBLIC            
            Steps : ARRAY[0..20] OF AxoStep;            
        END_VAR
                        
        METHOD PUBLIC Run 
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    
            VAR_IN_OUT                
                components : Components;
            END_VAR                       

            THIS.Initialize(parent);            
            THIS.SequenceMode := eAxoSequenceMode#RunOnce;    

            THIS.Open();
            THIS.AndThen(Steps[0],components.VerticalCylinder.MoveToHome);
            THIS.AndThen(Steps[1],components.HorizontalCylinder.MoveToHome);
            THIS.AndThen(Steps[2],components.GripperCylinder.MoveToHome);
            THIS.Close(Steps[3]);
                       
        END_METHOD        
    END_CLASS
END_NAMESPACE