NAMESPACE AXOpen.Data
    ///<summary>
    /// Base class for any data entity used in `AxoData`.
    ///</summary>  
    CLASS AxoDataEntity IMPLEMENTS IAxoDataEntity
        VAR PUBLIC
            ///<summary>
            /// Gets or sets identifier for this data entity.
            ///</summary> 
            {#ix-attr:[RenderIgnore()]}            
            DataEntityId : STRING[254];
        END_VAR        
    END_CLASS
END_NAMESPACE    