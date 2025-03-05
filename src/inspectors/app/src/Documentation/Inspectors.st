{S7.extern=ReadWrite}
CLASS InspectorsDoc EXTENDS AXOpen.Core.AxoObject
    //<AxoInspectorDeclaration>
    VAR PUBLIC
        _digitalInspector: AXOpen.Inspectors.AxoInspector;
        _analogueInspector: AXOpen.Inspectors.AxoInspector;
        _dataInspector: AXOpen.Inspectors.AxoInspector;

        _inspectionResult: BOOL;
        _inspectionValue: LREAL;
        _inspectionData: STRING;

        _digitalInspectorData: AXOpen.Inspectors.AxoDigitalInspectorData;
        _analogueInspectorData : AXOpen.Inspectors.AxoAnalogueInspectorData;
        _dataInspectorData: AXOpen.Inspectors.AxoDataInspectorData;
    END_VAR
    //</AxoInspectorDeclaration>



    METHOD PUBLIC Run

        //<AxoInspectorDataSet>
        _digitalInspectorData.FailTime := TIME#3s;
        _analogueInspectorData.FailTime := TIME#3s;
        _dataInspectorData.FailTime := TIME#3s;

        _digitalInspectorData.PassTime := TIME#2s;
        _analogueInspectorData.PassTime := TIME#2s;
        _dataInspectorData.PassTime := TIME#2s;
        //</AxoInspectorDataSet>

        //<AxoInspectorSimpleInspection>
        _digitalInspector.Inspect(THIS, REF(_digitalInspectorData),_inspectionResult);
        _analogueInspector.Inspect(THIS,REF(_analogueInspectorData), _inspectionValue);
        _dataInspector.Inspect(THIS, REF(_dataInspectorData),_inspectionData);
        //</AxoInspectorSimpleInspection>
        
    END_METHOD
END_CLASS
