{S7.extern=ReadWrite}
CLASS InspectorsDoc EXTENDS AXOpen.Core.AxoObject
    //<AxoInspectorDeclaration>
    VAR PUBLIC
        _inspector: AXOpen.Inspectors.AxoInspector;
        
        _inspectionResult: BOOL;
        _inspectionValue: LREAL;
        _inspectionData: STRING;

        _digitalInspectorData: AXOpen.Inspectors.AxoDigitalInspectorData;
        _analogueInspectorData : AXOpen.Inspectors.AxoAnalogueInspectorData;
        _dataInspectorData: AXOpen.Inspectors.AxoDataInspectorData;
    END_VAR
    //</AxoInspectorDeclaration>



    METHOD PUBLIC Run
        THIS.Initialize(THIS);

        //<AxoInspectorDataSet>
        _digitalInspectorData.FailTime := TIME#3s;
        _analogueInspectorData.FailTime := TIME#3s;
        _dataInspectorData.FailTime := TIME#3s;

        _digitalInspectorData.PassTime := TIME#2s;
        _analogueInspectorData.PassTime := TIME#2s;
        _dataInspectorData.PassTime := TIME#2s;
        //</AxoInspectorDataSet>

        //<AxoInspectorSimpleInspection>
        _inspector.Inspect(THIS, REF(_digitalInspectorData),_inspectionResult);
        _inspector.Inspect(THIS,REF(_analogueInspectorData), _inspectionValue);
        _inspector.Inspect(THIS, REF(_dataInspectorData),_inspectionData);
        //</AxoInspectorSimpleInspection>
        
    END_METHOD
END_CLASS
