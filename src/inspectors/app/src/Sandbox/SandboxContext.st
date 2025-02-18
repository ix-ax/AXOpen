USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _startInspection : BOOL := FALSE;
        _inspectors : Inspectors;      
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        _inspectors.Initialize(THIS);

        IF _startInspection THEN
            _inspectors.Run();
        END_IF;
      
     
    END_METHOD
END_CLASS

{S7.extern=ReadWrite}
CLASS Inspectors EXTENDS AXOpen.Core.AxoObject
    VAR PUBLIC
        _inspector: AXOpen.Inspectors.AxoInspector;
        
        _inspectionResult: BOOL;
        _inspectionValue: LREAL;
        _inspectionData: STRING;

        _digitalInspectorData: AXOpen.Inspectors.AxoDigitalInspectorData;
        _analogueInspectorData : AXOpen.Inspectors.AxoAnalogueInspectorData;
        _dataInspectorData: AXOpen.Inspectors.AxoDataInspectorData;
    END_VAR




    METHOD PUBLIC Run
        
        THIS.Initialize(THIS);

        IF _digitalInspectorData.FailTime = TIME#0s THEN  _digitalInspectorData.FailTime := TIME#1100MS; END_IF;
        IF _digitalInspectorData.PassTime = TIME#0s THEN  _digitalInspectorData.PassTime := TIME#1000MS; END_IF;
            
        IF _analogueInspectorData.FailTime = TIME#0s THEN  _analogueInspectorData.FailTime := TIME#1100MS; END_IF;
        IF _analogueInspectorData.PassTime = TIME#0s THEN  _analogueInspectorData.PassTime := TIME#1000MS; END_IF;
                              
        IF _dataInspectorData.FailTime = TIME#0s THEN  _dataInspectorData.FailTime := TIME#1100MS; END_IF;
        IF _dataInspectorData.PassTime = TIME#0s THEN  _dataInspectorData.PassTime := TIME#1000MS; END_IF;
           
        _inspector.Inspect(THIS, REF(_digitalInspectorData),_inspectionResult);
        _inspector.Inspect(THIS,REF(_analogueInspectorData), _inspectionValue);
        _inspector.Inspect(THIS, REF(_dataInspectorData),_inspectionData);

    END_METHOD

END_CLASS
