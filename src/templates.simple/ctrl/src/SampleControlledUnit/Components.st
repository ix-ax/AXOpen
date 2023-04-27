USING AXOpen.Core;

NAMESPACE axosimple.SampleControlledUnit
    CLASS Components EXTENDS AXOpen.Core.AxoObject       
        VAR PUBLIC
            HorizontalCylinder : AXOpen.Pneumatics.Cylinder;
            VerticalCylinder : AXOpen.Pneumatics.Cylinder;
            GripperCylinder : AXOpen.Pneumatics.Cylinder;
        END_VAR        
        METHOD PUBLIC Update
            VAR_INPUT
                parent : IAxoObject;
            END_VAR         
            VAR_IN_OUT
                Inputs : axosimple.Inputs;
                Outputs : axosimple.Outputs; 
            END_VAR           
            THIS.Initialize(parent);
            HorizontalCylinder.Update(THIS,Inputs.B0[0], Inputs.B0[1], Outputs.B0[0], Outputs.B0[1]);
            VerticalCylinder.Update(THIS,Inputs.B0[2], Inputs.B0[3], Outputs.B0[2], Outputs.B0[3]);
            GripperCylinder.Update(THIS,Inputs.B0[4], Inputs.B0[5], Outputs.B0[4], Outputs.B0[5]);
        END_METHOD
    END_CLASS

   
END_NAMESPACE
