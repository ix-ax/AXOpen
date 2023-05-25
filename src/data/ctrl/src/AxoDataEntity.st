NAMESPACE AXOpen.Data 
    ///<summary>
    /// Base class for any exchangable data in <see cref="AxoDataExchange"/>.  
    /// </summary>
    CLASS AxoDataEntity IMPLEMENTS IAxoDataEntity
        VAR PUBLIC
            ///<summary>
            /// Gets or sets data entity identifier.
            /// </summary>
            {#ix-attr:[RenderIgnore()]}            
            DataEntityId : STRING[254];
        END_VAR        
    END_CLASS
END_NAMESPACE    