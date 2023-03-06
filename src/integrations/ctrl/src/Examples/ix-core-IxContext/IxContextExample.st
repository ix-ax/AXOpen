using ix.framework.core;

//<Implementation>
    PROGRAM ProgramExample
        VAR
            MyContext : IxContextExample;
        END_VAR    

        MyContext.Run();

    END_PROGRAM
//</Implementation>

//<Declaration>
    CLASS PUBLIC IxContextExample EXTENDS IxContext
        METHOD PROTECTED OVERRIDE Main 
            // Here goes all your logic for given IxContext.
            ;
        END_METHOD
    END_CLASS
//</Declaration>
