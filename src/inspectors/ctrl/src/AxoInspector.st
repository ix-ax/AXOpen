USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors

 
    CLASS AxoInspector EXTENDS AXOpen.Core.AxoObject IMPLEMENTS IInspector, IOnFail
        VAR PUBLIC
   
        END_VAR



    METHOD PUBLIC OnFail : IOnFail
        ;
    END_METHOD

    METHOD PUBLIC UpdateComprehensiveResult : IInspector
        VAR_IN_OUT
            inoResult : AxoComprehensiveResult;
        END_VAR

        ;
    END_METHOD

    METHOD PUBLIC CarryOn : BOOL
        ;
    END_METHOD

    METHOD PUBLIC Retry : BOOL
        VAR_INPUT
            inFromState : INT;
        END_VAR

        ;
    END_METHOD

    METHOD PUBLIC Terminate : BOOL
        ;
    END_METHOD
END_CLASS



END_NAMESPACE