USING AXOpen.Core;

//<Implementation>
    PROGRAM ProgramExample
        VAR
            MyContext : AxoContextExample;
        END_VAR    

        MyContext.Run();

    END_PROGRAM
//</Implementation>

//<Declaration>
    CLASS PUBLIC AxoContextExample EXTENDS  AXOpen.Core.AxoContext
        METHOD PROTECTED OVERRIDE Main 
            // Here goes all your logic for given AxoContext.
            ;
        END_METHOD
    END_CLASS
//</Declaration>
