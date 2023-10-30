USING AXOpen.Core;

NAMESPACE AXOpen.Data
    ///<summary>
    /// Provides base class for any data exchange with an arbitrary remote repository.      
    /// </summary>      
    {#ix-generic:<TOnline, TPlain>}
    CLASS AxoDataExchange EXTENDS AxoObject IMPLEMENTS IAxoDataExchange, AxoDataExchangeBase
        VAR PUBLIC
            Operation : AxoDataCrudTask;
        END_VAR

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
        /// Creates new entry into the remote repository from data entity of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param>  
        METHOD PUBLIC Create : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Create := Operation.Invoke(identifier, eCrudOperation#Create);
        END_METHOD       
        
        ///<summary>
        /// Reads data from remote repository and copies them into data entity of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param>  
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Read := Operation.Invoke(identifier, eCrudOperation#Read);
        END_METHOD 

        ///<summary>
        /// Updates data in remote repository from data entiry of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC Update : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Update := Operation.Invoke(identifier, eCrudOperation#Update);
        END_METHOD 

        ///<summary>
        /// Deletes data entry with given ID from remote repository.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC Delete : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Delete := Operation.Invoke(identifier, eCrudOperation#Delete);
        END_METHOD 

        ///<summary>
        /// Check if data entry exists with given ID in remote repository.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC EntityExist : IAxoEntityExistTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Operation.Invoke(identifier, eCrudOperation#EntityExist);
            EntityExist := Operation;
        END_METHOD 

        ///<summary>
        /// Creates or Updates data in remote repository from data entiry of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC CreateOrUpdate : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            CreateOrUpdate := Operation.Invoke(identifier, eCrudOperation#CreateOrUpdate);
        END_METHOD 

        ///<summary>
        /// Restores all tasks associated with this object.
        ///</summary>         
        METHOD PUBLIC Restore
            Operation.Restore();            
        END_METHOD    
    END_CLASS    
END_NAMESPACE