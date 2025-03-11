NAMESPACE AXOpen.Core
    {S7.extern=ReadWrite}
    CLASS ABSTRACT AxoSequencerContainer EXTENDS AxoSequencer
        METHOD PUBLIC OVERRIDE Run 
            VAR_INPUT
                object : IAxoObject;
            END_VAR
            SUPER.Run(object);
            IF THIS.Open() THEN
                THIS.Main();
            END_IF;
        END_METHOD 

        METHOD PROTECTED ABSTRACT Main 
            
        END_METHOD 
    END_CLASS    
END_NAMESPACE
