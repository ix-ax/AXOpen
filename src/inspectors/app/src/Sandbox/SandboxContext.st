USING AXOpen.Core;
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

CLASS Inspectors EXTENDS AXOpen.Core.AxoObject
    VAR PUBLIC
        _digitalInspector: AXOpen.Inspectors.AxoDigitalInspector;
        _analogueInspector: AXOpen.Inspectors.AxoAnalogueInspector;
        _dataInspector: AXOpen.Inspectors.AxoDataInspector;

        _inspectionResult: BOOL;
        _inspectionValue: LREAL;
        _inspectionData: STRING;
    END_VAR




    METHOD PUBLIC Run
        THIS.Initialize(THIS);


        _digitalInspector.Data()^.FailTime := TIME#3s;
        _analogueInspector.Data()^.FailTime := TIME#3s;
        _dataInspector.Data()^.FailTime := TIME#3s;

        _digitalInspector.Data()^.PassTime := TIME#2s;
        _analogueInspector.Data()^.PassTime := TIME#2s;
        _dataInspector.Data()^.PassTime := TIME#2s;
    

        _digitalInspector.Inspect(THIS, _inspectionResult);
        _analogueInspector.Inspect(THIS, _inspectionValue);
        _dataInspector.Inspect(THIS, _inspectionData);
        ;
    END_METHOD

END_CLASS