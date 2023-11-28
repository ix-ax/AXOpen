USING AXOpen.Core;
NAMESPACE AXOpen.Inspectors
    INTERFACE IAxoComprehensiveResult 
    
        METHOD GetResult : eOverallResult
        END_METHOD

        METHOD GetFailures : STRING
        END_METHOD

        METHOD GetErrorCodes : STRING
        END_METHOD

        METHOD SetResult 
            VAR_INPUT
                inResult: eOverallResult;
            END_VAR
        END_METHOD

        METHOD SetFailures 
            VAR_INPUT
                inFailures: STRING;
            END_VAR
        END_METHOD

        METHOD SetErrorCodes 
            VAR_INPUT
                inErrorCodes: STRING;
            END_VAR
        END_METHOD
        
    END_INTERFACE
END_NAMESPACE
