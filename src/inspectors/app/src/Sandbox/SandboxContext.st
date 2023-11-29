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
        _digitalInspector: AXOpen.Inspectors.AxoDigitalInspector;
        _analogueInspector: AXOpen.Inspectors.AxoAnalogueInspector;
        _dataInspector: AXOpen.Inspectors.AxoDataInspector;

        _inspectionResult: BOOL;
        _inspectionValue: LREAL;
        _inspectionData: STRING;
    END_VAR




    METHOD PUBLIC Run
        THIS.Initialize(THIS);

        IF _digitalInspector.Data()^.FailTime = TIME#0s THEN  _digitalInspector.Data()^.FailTime := TIME#1100MS; END_IF;
        IF _digitalInspector.Data()^.PassTime = TIME#0s THEN  _digitalInspector.Data()^.PassTime := TIME#1000MS; END_IF;
            
        IF _dataInspector.Data()^.FailTime = TIME#0s THEN  _dataInspector.Data()^.FailTime := TIME#1100MS; END_IF;
        IF _dataInspector.Data()^.PassTime = TIME#0s THEN  _dataInspector.Data()^.PassTime := TIME#1000MS; END_IF;
           
        IF _analogueInspector.Data()^.FailTime = TIME#0s THEN  _analogueInspector.Data()^.FailTime := TIME#1100MS; END_IF;
        IF _analogueInspector.Data()^.PassTime = TIME#0s THEN  _analogueInspector.Data()^.PassTime := TIME#1000MS; END_IF;
                       
       
        _digitalInspector.Inspect(THIS, _inspectionResult);
        _analogueInspector.Inspect(THIS, _inspectionValue);
        _dataInspector.Inspect(THIS, _inspectionData);
        ;
    END_METHOD

END_CLASS
