NAMESPACE AXOpen.Inspectors

    CLASS AxoComprehensiveResult IMPLEMENTS IAxoComprehensiveResult
        // this probably should not be public, but it is for test purposes
        VAR PUBLIC

            Result : eOverallResult;
            Failures : STRING;
            ErrorCodes : STRING;

        END_VAR

    
        METHOD PUBLIC GetResult : eOverallResult
            GetResult := Result;
        END_METHOD

        METHOD PUBLIC GetFailures : STRING
            GetFailures := Failures;
        END_METHOD

        METHOD PUBLIC GetErrorCodes : STRING
            GetErrorCodes := ErrorCodes;
        END_METHOD

        METHOD PUBLIC SetResult
            VAR_INPUT
                inResult : eOverallResult;
            END_VAR
            Result := inResult;
        END_METHOD

        METHOD PUBLIC SetFailures
            VAR_INPUT
                inFailures : STRING;
            END_VAR
            Failures := inFailures;
        END_METHOD

        METHOD PUBLIC SetErrorCodes
            VAR_INPUT
                inErrorCodes : STRING;
            END_VAR
            
            ErrorCodes := inErrorCodes;
        END_METHOD
    END_CLASS


END_NAMESPACE