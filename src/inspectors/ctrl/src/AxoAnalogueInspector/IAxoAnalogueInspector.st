USING AXOpen.Core;
NAMESPACE AXOpen.Inspectors
    INTERFACE IAxoAnalogueInspector 
    
        METHOD Inspect : IInspector
            VAR_INPUT
                _parent: IAxoObject;
                Status : LREAL;
            END_VAR
        END_METHOD
        
    END_INTERFACE
END_NAMESPACE