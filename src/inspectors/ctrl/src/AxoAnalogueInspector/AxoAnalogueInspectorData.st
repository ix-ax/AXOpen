NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// Data subjected to each analogue inspector instance.
    ///</summary>
    CLASS AxoAnalogueInspectorData EXTENDS AxoInspectorData

        VAR PUBLIC

            {#ix-set:AttributeName = "<#Min#>"}
            RequiredMin : LREAL;

            {#ix-set:AttributeName = "<#Detected#>"}
            DetectedStatus : LREAL;
      
            {#ix-set:AttributeName = "<#Max#>"}
            RequiredMax: LREAL;

        END_VAR

    END_CLASS


END_NAMESPACE