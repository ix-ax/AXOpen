NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// Class for gathering overall result of single or multiple inspections
    /// Only fail results are automatically written to comprehensive result
    /// Application programmer must specify, what is a correct result
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS AxoComprehensiveResult IMPLEMENTS IAxoComprehensiveResult
        VAR PUBLIC

            Result : eOverallResult;
            Failures : STRING;
            ErrorCodes : STRING;

        END_VAR

        ///<summary>
        /// Get the overall result
        ///</summary>
        METHOD PUBLIC GetResult : eOverallResult
            GetResult := Result;
        END_METHOD

        ///<summary>
        /// Get Failures
        /// TODO: not implemented yet
        ///</summary>
        METHOD PUBLIC GetFailures : STRING
            GetFailures := Failures;
        END_METHOD

        ///<summary>
        /// Get error codes
        /// TODO: not implemented yet
        ///</summary>
        METHOD PUBLIC GetErrorCodes : STRING
            GetErrorCodes := ErrorCodes;
        END_METHOD

        ///<summary>
        /// Set overall result
        ///</summary>
        METHOD PUBLIC SetResult
            VAR_INPUT
                inResult : eOverallResult;
            END_VAR
            Result := inResult;
        END_METHOD

        ///<summary>
        /// Set failures
        ///</summary>
        METHOD PUBLIC SetFailures
            VAR_INPUT
                inFailures : STRING;
            END_VAR
            Failures := inFailures;
        END_METHOD

        ///<summary>
        /// Set error codes
        ///</summary>
        METHOD PUBLIC SetErrorCodes
            VAR_INPUT
                inErrorCodes : STRING;
            END_VAR
            
            ErrorCodes := inErrorCodes;
        END_METHOD
    END_CLASS


END_NAMESPACE

