USING AXOpen.Core;
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        AxoIndraDrive_ : AXOpen.Components.Rexroth.Drives.AxoIndraDrive;      
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC                
        AxisIn          :   ARRAY[0..10] OF BYTE;       //  Input data of the axis
        AxisOut         :   ARRAY[0..10] OF BYTE;       //  Output data of the axis
        Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
        EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
        EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        //<Initialization>        
        AxoIndraDrive_.Run(THIS, REF(AxisIn), REF(AxisOut), Enable, EnablePositive, EnableNegative);        
        //</Initialization>

       THIS.UseInSequencer();
    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
    END_VAR

    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
        Sequencer.Open();

        IF(Steps[0].Execute(Sequencer, 'Reset drive')) THEN
            IF(AxoIndraDrive_.AxoReset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Drive homming')) THEN
            IF(AxoIndraDrive_.AxoHome(  Position        :=  LREAL#5.0,
                                        HommingMode     :=  INT#10,
                                        Velocity        :=  LREAL#10.0,
                                        Acceleration    :=  LREAL#50.0,
                                        Deceleration    :=  LREAL#50.0
                                        ).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       
    END_METHOD
    
    //</Usage>
END_CLASS
