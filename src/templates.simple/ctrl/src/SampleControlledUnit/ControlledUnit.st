USING AXOpen.Core;

NAMESPACE axosimple.SampleControlledUnit
    CLASS ControlledUnit EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            GroundSequence : GroundSequence;
            AutomatSequence : AutomatSequence;
            ServiceMode : ServiceMode;
            
            Components : Components;
        END_VAR 

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoContext;
            END_VAR 
            VAR_IN_OUT
                Inputs : axosimple.Inputs;
                Outputs : axosimple.Outputs; 
            END_VAR                   
            THIS.Initialize(parent);
            THIS.Execute(Inputs, Outputs);
        END_METHOD
        
        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
            END_VAR       
            VAR_IN_OUT
                Inputs : axosimple.Inputs;
                Outputs : axosimple.Outputs; 
            END_VAR   
            THIS.Initialize(parent);         
            THIS.Execute(Inputs, Outputs);
        END_METHOD

        METHOD PRIVATE Execute          
            VAR_IN_OUT
                Inputs : axosimple.Inputs;
                Outputs : axosimple.Outputs; 
            END_VAR    

            Components.Update(THIS,Inputs, Outputs);    

            GroundSequence.Run(THIS, Components);

            IF(GroundSequence.IsBusy()) THEN
                AutomatSequence.Restore();
                ServiceMode.Restore();
            END_IF;    

            AutomatSequence.IsDisabled := GroundSequence.Status <> eAxoTaskState#Done;
            AutomatSequence.Run(THIS, Components);

            ServiceMode.Run(THIS, Components);
            IF ServiceMode.IsBusy() THEN
                GroundSequence.Restore();
            END_IF;    
        END_METHOD    

    END_CLASS          
END_NAMESPACE