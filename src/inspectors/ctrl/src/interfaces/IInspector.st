NAMESPACE AXOpen.Inspectors
    INTERFACE IInspector 
    
        

        METHOD OnFail : IOnFail
        END_METHOD

        METHOD UpdateComprehensiveResult : IInspector

            VAR_IN_OUT
                inoResult : AxoComprehensiveResult;
            END_VAR

        END_METHOD
        
    END_INTERFACE
END_NAMESPACE