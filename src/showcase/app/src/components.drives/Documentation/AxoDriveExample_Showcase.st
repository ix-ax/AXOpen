USING AXOpen.Core;

NAMESPACE AXOpen.Components.Drives
    
    {S7.extern=ReadWrite}
    CLASS AxoDriveExample_Showcase EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            AxoDrive_ : AXOpen.Components.Drives.AxoDriveExample;      
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC                
            AxisRef         :   AxoDriveAxisReferenceExample;
            Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
            EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR    

            SUPER.Run(inParent);

            //<Initialization>        
            AxoDrive_.Run(THIS, AxisRef, Enable, EnablePositive, EnableNegative);        
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Reset drive')) THEN
                IF(AxoDrive_.AxoReset().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Drive homming')) THEN
                IF(AxoDrive_.AxoHome(  Position        :=  LREAL#5.0,
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
END_NAMESPACE