USING AXOpen.Core;
NAMESPACE AXOpen.Inspectors
    INTERFACE IAxoDigitalInspector 
    
        METHOD Inspect : IInspector
            VAR_INPUT
                inParent: IAxoObject;
                inData : REF_TO AxoDigitalInspectorData;
                Status : BOOL;
            END_VAR
        END_METHOD
        
    END_INTERFACE
END_NAMESPACE
