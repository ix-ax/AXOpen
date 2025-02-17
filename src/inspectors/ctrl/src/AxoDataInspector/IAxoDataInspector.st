USING AXOpen.Core;
NAMESPACE AXOpen.Inspectors
    INTERFACE IAxoDataInspector 
    
        METHOD Inspect : IInspector
            VAR_INPUT
                inParent: IAxoObject;
                inData : REF_TO AxoDataInspectorData;
                Status : STRING;
            END_VAR
        END_METHOD
        
    END_INTERFACE
END_NAMESPACE
