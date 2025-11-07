USING AXOpen.Core;
NAMESPACE AXOpen.Data 
    ///<summary>
    /// Base class for any exchangable data in <see cref="AxoDataExchange"/>.  
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS AxoDataEntity IMPLEMENTS IAxoDataEntity
        VAR PUBLIC
            ///<summary>
            /// Gets or sets data entity identifier.
            /// </summary>
            {#ix-attr:[RenderIgnore()]}            
            _EntityId : STRING[254];
        END_VAR 

        METHOD PUBLIC SetId
            VAR_INPUT
                Id : STRING[254];
            END_VAR  
            _EntityId := Id;          
        END_METHOD               
    
        METHOD PUBLIC GetId : STRING[254]
            GetId := _EntityId;
        END_METHOD
    END_CLASS
END_NAMESPACE    
