NAMESPACE AXOpen.Data
    
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
 
    CLASS PUBLIC AxoDataPersistentExchange EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            Operation : AxoDataPersistentCurdTask;
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
        /// Reads data from remote repository and copies them into data entity of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param>  
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Read := Operation.Invoke(identifier, ePersistentOperation#Read);
        END_METHOD 

        ///<summary>
        /// Updates data in remote repository from data entiry of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC Update : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Update := Operation.Invoke(identifier, ePersistentOperation#Update);
        END_METHOD 

          ///<summary>
        /// Check if data entry exists with given ID in remote repository.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC EntityExist : IAxoEntityExistTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Operation.Invoke(identifier, ePersistentOperation#EntityExist);
            EntityExist := Operation;
        END_METHOD 
    END_CLASS
END_NAMESPACE    