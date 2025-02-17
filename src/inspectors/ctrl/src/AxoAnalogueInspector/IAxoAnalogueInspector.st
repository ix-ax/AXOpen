USING AXOpen.Core;
NAMESPACE AXOpen.Inspectors
    INTERFACE IAxoAnalogueInspector 
    
        METHOD Inspect : IInspector
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;
                inData : REF_TO AxoAnalogueInspectorData;
                Status : LREAL;
            END_VAR
        END_METHOD
        
    END_INTERFACE
END_NAMESPACE
