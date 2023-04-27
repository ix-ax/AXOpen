USING axosimple;
PROGRAM MyProgram
    VAR_EXTERNAL        
        Inputs : axosimple.Inputs;
        Outputs : axosimple.Outputs;          
        Context : axosimple.Context;         
    END_VAR
    // Never modif this the context needs references to IN/OUT structures before it is used.
    Context.Inputs := REF(Inputs);
    Context.Outputs := REF(Outputs);

    // Executes the main context of this application.
    Context.Run();      
        
END_PROGRAM
