NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// Data subjected to each digital inspector instance.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS AxoDigitalInspectorData EXTENDS AxoInspectorData

        VAR PUBLIC
            //<AxoDigitalInspectorDataDeclaration>
            {#ix-set:AttributeName = "<#Required#>"}
            RequiredStatus : BOOL;

            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Detected#>"}
            DetectedStatus : BOOL;
            //</AxoDigitalInspectorDataDeclaration>

        END_VAR

    END_CLASS


END_NAMESPACE


