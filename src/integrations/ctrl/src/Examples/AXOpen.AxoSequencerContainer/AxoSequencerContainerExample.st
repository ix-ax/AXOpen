USING AXOpen.Core;

NAMESPACE AxoSequencerContainerExamples

    CLASS AxoSequencerContainerExample EXTENDS AXOpen.Core.AxoSequencerContainer

        VAR PUBLIC
            Counter : ULINT;
            {#ix-set:Description = "Step number one"}
            step_1 : AxoStep; 
            {#ix-set:Description = "Step number two"}
            step_2 : AxoStep; 
            {#ix-set:Description = "Step number three"}
            step_3 : AxoStep; 
            {#ix-set:Description = "Step number four"}
            step_4 : AxoStep;
            {#ix-set:Description = "Step number five"}
            step_5 : AxoStep;
            {#ix-set:Description = "Step number six"}
            step_6 : AxoStep;
            {#ix-set:Description = "Step number seven"}
            step_7 : AxoStep;
            {#ix-set:Description = "Step number eight"}
            step_8 : AxoStep;
            {#ix-set:Description = "Step number nine"}
            step_9 : AxoStep;
            {#ix-set:Description = "Step number ten"}
            step_10 : AxoStep;

            _dialog : AxoDialog;
            _eDialogAnswer : eDialogAnswer;
        END_VAR


        METHOD PROTECTED OVERRIDE Main 
            step_1.Initialize(THIS);
            step_2.Initialize(THIS);
            step_3.Initialize(THIS);
            step_4.Initialize(THIS);
            step_5.Initialize(THIS);
            step_6.Initialize(THIS);
            step_7.Initialize(THIS);
            step_8.Initialize(THIS);
            step_9.Initialize(THIS);
            step_10.Initialize(THIS);

            Counter := Counter + ULINT#1;

            IF(step_1.Execute(THIS)) THEN  
                IF(Counter >= ULINT#100 ) THEN
                    Counter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF;    
        
            IF(step_2.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;

                    IF(_dialog.Show()
                        .WithOK()
                        .WithCaption('What`s next?')
			            .WithText('To continue click OK?')
                        .Answer() = _eDialogAnswer.OK) THEN
                        THIS.MoveNext();
                    END_IF;
                END_IF;    
            END_IF; 

            IF(step_3.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    step_3.ThrowWhen(TRUE);
                    THIS.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_4.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_5.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_6.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_7.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_8.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_9.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_10.Execute(THIS)) THEN
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    THIS.CompleteSequence();
                END_IF;    
            END_IF; 
        END_METHOD
    END_CLASS
 
    CLASS SequencerContainerExample EXTENDS  AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Sequencer container example#>"}
            _SequencerContainerExample : AxoSequencerContainerExample;
        END_VAR    
 
        METHOD PROTECTED OVERRIDE Main    
            _SequencerContainerExample.Run(THIS);
        END_METHOD
    END_CLASS    
END_NAMESPACE
