USING AXOpen.Core;

NAMESPACE axosimple.SampleControlledUnit 
    {#ix-set:AttributeName = "<#AUTOMAT#>"} 
    CLASS PUBLIC AutomatSequence EXTENDS AXOpen.Core.AxoSequencer
        VAR PUBLIC            
            Steps : ARRAY[0..150] OF AxoStep;            
        END_VAR
                        
        METHOD PUBLIC Run 
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    
            VAR_IN_OUT
                Components : Components;
            END_VAR                       
                      
            THIS.Initialize(parent);
            THIS.SequenceMode := eAxoSequenceMode#Cyclic;
                                             
            THIS.Open();
            THIS.AndThen(Steps[0],components.VerticalCylinder.MoveToWork);
            THIS.AndThen(Steps[1],components.GripperCylinder.MoveToWork);
            THIS.AndThen(Steps[2],components.VerticalCylinder.MoveToHome);
            THIS.AndThen(Steps[3],components.HorizontalCylinder.MoveToWork);
            THIS.AndThen(Steps[4],components.VerticalCylinder.MoveToWork);
            THIS.AndThen(Steps[5],components.GripperCylinder.MoveToHome);
            THIS.AndThen(Steps[6],components.VerticalCylinder.MoveToHome);
            THIS.AndThen(Steps[7],components.HorizontalCylinder.MoveToHome);
            THIS.AndThen(Steps[8],components.GripperCylinder.MoveToHome);
            THIS.Close(Steps[150]);

        END_METHOD        
    END_CLASS
END_NAMESPACE