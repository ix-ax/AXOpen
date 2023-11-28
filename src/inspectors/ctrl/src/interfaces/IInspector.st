USING AXOpen.Core;
NAMESPACE AXOpen.Inspectors
    INTERFACE IInspector 
    
        METHOD Busy : BOOL
        END_METHOD

        METHOD CommonData : REF_TO AxoInspectorData
        END_METHOD

        METHOD Coordinator : IAxoCoordinator
        END_METHOD

        METHOD Done : BOOL
        END_METHOD


        METHOD CheckOverInspection : BOOL
        END_METHOD

        METHOD Result : eInspectorResult
        END_METHOD

        METHOD Dialog : BOOL
            VAR_INPUT
                inRetryStep: IAxoStep;
                inTerminateStep: IAxoStep;
            END_VAR

            VAR_IN_OUT
                inoDialog : AxoInspectorDialog;
            END_VAR
            
        END_METHOD

        METHOD  RestoreInspectorTask : BOOL
        END_METHOD

        METHOD OnFail : IOnFail
        END_METHOD

        METHOD UpdateComprehensiveResult : IInspector

            VAR_IN_OUT
                inoResult : AxoComprehensiveResult;
            END_VAR

        END_METHOD
        
    END_INTERFACE
END_NAMESPACE
