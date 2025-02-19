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
                
        METHOD Inspect : IInspector
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;
                inData : REF_TO AxoAnalogueInspectorData;
                Status : LREAL;
            END_VAR           
        END_METHOD

        METHOD Inspect : IInspector
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;
                inData : REF_TO AxoDigitalInspectorData;
                Status : BOOL;
            END_VAR           
        END_METHOD

        METHOD Inspect : IInspector
            VAR_INPUT
                inParent : AXOpen.Core.IAxoObject;
                inData : REF_TO AxoDataInspectorData;
                Status : STRING;
            END_VAR           
        END_METHOD
    END_INTERFACE
END_NAMESPACE
