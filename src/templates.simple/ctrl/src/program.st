USING axosimple;
PROGRAM MyProgram
    VAR_EXTERNAL        
        Inputs : axosimple.Inputs;
        Outputs : axosimple.Outputs;          
        Context : axosimple.Context;         
    END_VAR
    Context.Inputs := REF(Inputs);
    Context.Outputs := REF(Outputs);
    Context.Run();            
END_PROGRAM
