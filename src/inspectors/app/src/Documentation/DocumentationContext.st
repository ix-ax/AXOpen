USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _startInspection : BOOL := FALSE;
        _automat: AutomatSequence;
        _inspectors : Inspectors;      
        _rootObject : AxoObject;
    END_VAR


    METHOD PROTECTED OVERRIDE Main           
        _rootObject.InitializeWithContext(THIS); 
        _automat.Initialize(_rootObject);
        _automat.Run(_rootObject);
        _automat.Execute();

        IF _startInspection THEN
            _automat.Invoke();
        END_IF;           
    END_METHOD

END_CLASS


{#ix-set:AttributeName = "<#AUTOMAT#>"}
{S7.extern=ReadWrite}
CLASS PUBLIC AutomatSequence
    EXTENDS AXOpen.Core.AxoSequencerContainer
    VAR PUBLIC
        _continue : BOOL := FALSE;

        Steps : ARRAY[0..50] OF AxoStep;
        _inspector: AXOpen.Inspectors.AxoInspector;
                
        _inspectionResult: BOOL;
        _inspectionValue: LREAL;
        _inspectionData: STRING;

        _digitalInspectorData: AXOpen.Inspectors.AxoDigitalInspectorData;
        _analogueInspectorData : AXOpen.Inspectors.AxoAnalogueInspectorData;
        _dataInspectorData: AXOpen.Inspectors.AxoDataInspectorData;

        _comprehensiveResult: AXOpen.Inspectors.AxoComprehensiveResult;
    END_VAR
    VAR PRIVATE
        
    END_VAR

    METHOD OVERRIDE Main
        
        THIS.SequenceMode := eAxoSequenceMode#Cyclic;

        IF (Steps[0].Execute(THIS, TRUE, 'Move vertical cyclinder down.')) THEN

            THIS.MoveNext(); 

        END_IF;
        // This is more concise way of writing steps when we execute only single task.
        
        IF (Steps[10].Execute(THIS, TRUE, 'Set inpsection times')) THEN
            //--------------------------------------------

            _digitalInspectorData.FailTime := TIME#3s;
            _analogueInspectorData.FailTime := TIME#3s;
            _dataInspectorData.FailTime := TIME#3s;

            _digitalInspectorData.PassTime := TIME#2.5s;
            _analogueInspectorData.PassTime := TIME#2s;
            _dataInspectorData.PassTime := TIME#2s;

            THIS.MoveNext(); 
            //--------------------------------------------	
        END_IF;
    

        // IF (Steps[20].Execute(THIS, TRUE, 'RETRY STEP 90')) THEN
            
        //     IF(Steps[20].Duration > T#2000ms) THEN
        //         THIS.MoveNext(); 
        //     END_IF;	
            
            
        // END_IF;

        // <PreservingOverallResultExample>
        IF (Steps[30].Execute(THIS, TRUE, 'Example Digital inspection')) THEN
            _inspector.Inspect(THIS,REF(_digitalInspectorData),_inspectionResult);
            // <ExampleInspectionWithCoordinatorExample>
            // _inspector.WithCoordinator(THIS)
            //             .Inspect(THIS,REF(_digitalInspectorData),_inspectionResult)
            //             .UpdateComprehensiveResult(_comprehensiveResult)
            //             .OnFail()
            //             .CarryOn();
             ;
            // </ExampleInspectionWithCoordinatorExample>
        END_IF;

        // IF (Steps[31].Execute(THIS, TRUE, 'debug')) THEN         
        //     IF _continue THEN
        //         _continue := FALSE;
        //         THIS.MoveNext(); 
        //     END_IF;
        // END_IF;

        IF (Steps[35].Execute(THIS, TRUE, 'Example Analog inspection')) THEN         

            _inspector.WithCoordinator(THIS)
                        .Inspect(THIS,REF(_analogueInspectorData), _inspectionValue)
                        .UpdateComprehensiveResult(_comprehensiveResult)
                        .OnFail()
                        .CarryOn();

        END_IF;
       // </PreservingOverallResultExample>

        // IF (Steps[36].Execute(THIS, TRUE, 'debug')) THEN         
        //     IF _continue THEN
        //         _continue := FALSE;
        //         THIS.MoveNext(); 
        //     END_IF;
        // END_IF;

        IF (Steps[40].Execute(THIS, TRUE, 'Example Data inspection')) THEN
        
        // <HandlingFailureExample>
        _inspector.WithCoordinator(THIS)
                    .Inspect(THIS,REF(_dataInspectorData),_inspectionData)
                    .UpdateComprehensiveResult(_comprehensiveResult)
                    .OnFail()
                    .Dialog(Steps[20], Steps[45]);
        // </HandlingFailureExample>
        END_IF;

        IF (Steps[45].Execute(THIS, TRUE, 'Abort step')) THEN
        
            IF(Steps[45].Duration > T#3000ms) THEN
                THIS.MoveNext(); 
            END_IF;	

        END_IF;

        THIS.Close(Steps[50]);
    END_METHOD
END_CLASS

