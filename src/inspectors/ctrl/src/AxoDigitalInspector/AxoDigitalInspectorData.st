NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// Data subjected to each digital inspector instance.
    ///</summary>
    CLASS AxoDigitalInspectorData EXTENDS AxoInspectorData

        VAR PUBLIC

            {#ix-set:AttributeName = "<#Required#>"}
            RequiredStatus : BOOL;

            {#ix-set:AttributeName = "<#Detected#>"}
            DetectedStatus : BOOL;
      

        END_VAR

    END_CLASS


END_NAMESPACE