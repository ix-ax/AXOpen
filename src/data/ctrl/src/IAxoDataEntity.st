NAMESPACE AXOpen.Data 
    INTERFACE IAxoDataEntity  
        METHOD SetId
            VAR_INPUT
                Id : STRING[254];
            END_VAR            
        END_METHOD 
        METHOD GetId : STRING[254] END_METHOD

    END_INTERFACE
END_NAMESPACE    
