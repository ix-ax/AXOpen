USING AXOpen.Core;
NAMESPACE AXOpen.Inspectors
    INTERFACE IAxoDataInspector 
    
        METHOD Inspect : IInspector
            VAR_INPUT
                _parent: IAxoObject;
                inData : REF_TO AxoDataInspectorData;
                Status : STRING;
            END_VAR
        END_METHOD
        
    END_INTERFACE
END_NAMESPACE
