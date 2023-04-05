USING AXOpen.Core;

//<Implementation>
    PROGRAM ProgramExample
        VAR
            MyContext : IxContextExample;
        END_VAR    

        MyContext.Run();

    END_PROGRAM
//</Implementation>

//<Declaration>
    CLASS PUBLIC IxContextExample EXTENDS  AXOpen.Core.IxContext
        METHOD PROTECTED OVERRIDE Main 
            // Here goes all your logic for given IxContext.
            ;
        END_METHOD
    END_CLASS
//</Declaration>
