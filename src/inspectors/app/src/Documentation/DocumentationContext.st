CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC

        _startInspection : BOOL := FALSE;
         _automat: AutomatSequence;
        _inspectors : Inspectors;
      
    END_VAR


    METHOD PROTECTED OVERRIDE Main
        _inspectors.Initialize(THIS);
        
        _automat.Initialize(THIS);
        _automat.Run(THIS);
        _automat.Execute();

        IF _startInspection THEN
            _inspectors.Run();
        END_IF;
      
     
    END_METHOD

END_CLASS


{#ix-set:AttributeName = "<#AUTOMAT#>"}
CLASS PUBLIC AutomatSequence
    EXTENDS AXOpen.Core.AxoSequencerContainer
    VAR PUBLIC
        Steps : ARRAY[0..50] OF AxoStep;
        _digitalInspector: AXOpen.Inspectors.AxoDigitalInspector;
        _analogueInspector: AXOpen.Inspectors.AxoAnalogueInspector;
        _dataInspector: AXOpen.Inspectors.AxoDataInspector;

        _inspectionResult: BOOL;
        _inspectionValue: LREAL;
        _inspectionData: STRING;

        _comprehensiveResult: AXOpen.Inspectors.AxoComprehensiveResult;
    END_VAR
    VAR PRIVATE
        
    END_VAR

    METHOD OVERRIDE Main
        
        THIS.SequenceMode := eAxoSequenceMode#Cyclic;
        // This is more verbose but also more versatile way of executing step logic.
        IF (Steps[0].Execute(THIS, TRUE, 'Move vertical cyclinder down.')) THEN
            //-------------------------------------------------------
            
                THIS.MoveNext(); // <- This will move to the next step in the sequence.
        
//-------------------------------------------------------
        END_IF;
        // This is more concise way of writing steps when we execute only single task.
        
        IF (Steps[10].Execute(THIS, TRUE, 'Set inpsection times')) THEN
            //--------------------------------------------

            _digitalInspector.Data()^.FailTime := TIME#3s;
            _analogueInspector.Data()^.FailTime := TIME#3s;
            _dataInspector.Data()^.FailTime := TIME#3s;

            _digitalInspector.Data()^.PassTime := TIME#2s;
            _analogueInspector.Data()^.PassTime := TIME#2s;
            _dataInspector.Data()^.PassTime := TIME#2s;

            THIS.MoveNext(); 
            //--------------------------------------------	
        END_IF;
    

        IF (Steps[20].Execute(THIS, TRUE, 'RETRY STEP 90')) THEN
            
            IF(Steps[20].Duration > T#2000ms) THEN
                THIS.MoveNext(); 
            END_IF;	
            
            
        END_IF;


        IF (Steps[30].Execute(THIS, TRUE, 'Example Digital inspection')) THEN
            //-------------------------------------------------------

            _digitalInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionResult).UpdateComprehensiveResult(_comprehensiveResult).OnFail().Dialog(Steps[20], Steps[20]);

            //-------------------------------------------------------
            END_IF;

            IF (Steps[40].Execute(THIS, TRUE, 'Example Analog inspection')) THEN
            //-------------------------------------------------------
            

            _analogueInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionValue).UpdateComprehensiveResult(_comprehensiveResult).OnFail().Dialog(Steps[20], Steps[20]);

            //-------------------------------------------------------
            END_IF;


            IF (Steps[50].Execute(THIS, TRUE, 'Example Data inspection')) THEN
            //-------------------------------------------------------
            
            _dataInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionData).UpdateComprehensiveResult(_comprehensiveResult).OnFail().Dialog(Steps[20], Steps[20]);

            //-------------------------------------------------------
        END_IF;


        THIS.Close(Steps[50]);
    END_METHOD
END_CLASS

