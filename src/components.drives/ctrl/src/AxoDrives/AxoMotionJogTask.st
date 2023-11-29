USING AXOpen.Core;

NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoMotionJogTask EXTENDS AXOpen.Core.AxoMomentaryTask
        VAR PUBLIC
            StartMotion :   BOOL;
            StopMotion  :   BOOL;
        END_VAR
        METHOD PROTECTED OVERRIDE OnSwitchedOn 
            StartMotion :=  TRUE;
            StopMotion  :=  FALSE;
        END_METHOD
        METHOD PROTECTED OVERRIDE OnSwitchedOff 
            StartMotion :=  FALSE;
            StopMotion  :=  TRUE;
        END_METHOD
    END_CLASS    
END_NAMESPACE
