USING AXOpen.Core;
USING AXOpen.Core;
USING AXOpen.Core;

NAMESPACE AXOpen.Data
    ///<summary>
    /// Provides base class for any composite/fragmetes data exchange combining one or more AxoDataExchange object.    
    /// </summary>       
    CLASS PUBLIC AxoDataFragmentExchange EXTENDS AxoDataExchangeBase IMPLEMENTS IAxoDataExchange               
        VAR PUBLIC           
            Operation : AxoDataCrudTask;
        END_VAR   
              
        ///<summary>
        /// Creates new entry into each associated remote repository from respective data entity.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param>  
        METHOD PUBLIC Create : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR 
            Create := Operation.Invoke(Identifier, eCrudOperation#Create);       
        END_METHOD       
        
        ///<summary>
        /// Reads data from each associated remote repository and copies it into respective data entities.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param>  
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR  
            Read := Operation.Invoke(Identifier, eCrudOperation#Read);             
        END_METHOD 
    
        ///<summary>
        /// Updates data in each associated remote repository from respective data entities.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC Update : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR  
            Update := Operation.Invoke(Identifier, eCrudOperation#Update);        
        END_METHOD 
    
        ///<summary>
        /// Deletes data entry from each associated remote repository with given ID.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC Delete : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            Delete := Operation.Invoke(Identifier, eCrudOperation#Delete);         
        END_METHOD 

        ///<summary>
        /// Check if data entry exists in each associated remote repository with given ID.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC EntityExist : IAxoEntityExistTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            Operation.Invoke(Identifier, eCrudOperation#EntityExist);
            EntityExist := Operation;
        END_METHOD 

        ///<summary>
        /// Creates or Updates data entry from each associated remote repository with given ID.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC CreateOrUpdate : IAxoTaskState
            VAR_INPUT
                Identifier : STRING[254];
            END_VAR
            CreateOrUpdate := Operation.Invoke(Identifier, eCrudOperation#CreateOrUpdate);         
        END_METHOD 
    
        METHOD PUBLIC Restore  
            Operation.Restore(); 
        END_METHOD 
        
        ///<summary>
        /// Runs intialization and cyclical handling of this AxoDataExchange.
        /// </summary> 
        /// <param name="context">Root context of this object</param>
        METHOD PUBLIC Run 
            VAR_INPUT
                context : IAxoContext;
            END_VAR
            THIS.Initialize(context);
            Operation.Initialize(THIS);
            Operation.Execute();
        END_METHOD

        ///<summary>
        /// Runs intialization and cyclical handling of this AxoDataExchange.        
        /// </summary>                 
        /// <param name="parent">Parent of this object</param>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent : IAxoObject;
            END_VAR
            THIS.Initialize(parent);
            Operation.Initialize(THIS);
            Operation.Execute();
        END_METHOD

    END_CLASS 
END_NAMESPACE
