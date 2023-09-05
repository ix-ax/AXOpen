NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// Data subjected to each data inspector instance.
    ///</summary>
    CLASS AxoDataInspectorData EXTENDS AxoInspectorData

        VAR PUBLIC
            //<AxoDataInspectorDataDeclaration>
            {#ix-set:AttributeName = "<#Required#>"}
            RequiredStatus: STRING;

            {#ix-set:AttributeName = "<#Detected#>"}
            DetectedStatus : STRING;
      
            {#ix-set:AttributeName = "<#Star notation#>"}
            StarNotationEnabled: BOOL;

            //</AxoDataInspectorDataDeclaration>
        END_VAR 

    END_CLASS


END_NAMESPACE