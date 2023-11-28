{S7.extern=ReadWrite}
CLASS InspectorsDoc EXTENDS AXOpen.Core.AxoObject
    //<AxoInspectorDeclaration>
    VAR PUBLIC
        _digitalInspector: AXOpen.Inspectors.AxoDigitalInspector;
        _analogueInspector: AXOpen.Inspectors.AxoAnalogueInspector;
        _dataInspector: AXOpen.Inspectors.AxoDataInspector;

        _inspectionResult: BOOL;
        _inspectionValue: LREAL;
        _inspectionData: STRING;
    END_VAR
    //</AxoInspectorDeclaration>



    METHOD PUBLIC Run
        THIS.Initialize(THIS);

        //<AxoInspectorDataSet>
        _digitalInspector.Data()^.FailTime := TIME#3s;
        _analogueInspector.Data()^.FailTime := TIME#3s;
        _dataInspector.Data()^.FailTime := TIME#3s;

        _digitalInspector.Data()^.PassTime := TIME#2s;
        _analogueInspector.Data()^.PassTime := TIME#2s;
        _dataInspector.Data()^.PassTime := TIME#2s;
        //</AxoInspectorDataSet>

        //<AxoInspectorSimpleInspection>
        _digitalInspector.Inspect(THIS, _inspectionResult);
        _analogueInspector.Inspect(THIS, _inspectionValue);
        _dataInspector.Inspect(THIS, _inspectionData);
        //</AxoInspectorSimpleInspection>
        
    END_METHOD
END_CLASS
