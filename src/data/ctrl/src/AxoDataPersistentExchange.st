NAMESPACE AXOpen.Data
    
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
 
    CLASS PUBLIC AxoDataPersistentExchange EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            Operation : AxoDataPersistentCurdTask;
        END_VAR

        ///<summary>
        /// Runs intialization and cyclical handling of this AxoDataPersistentExchange.        
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
        /// Runs intialization and cyclical handling of this AxoDataPersistentExchange.
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
        /// Executes the restore Operation for the AxoDataPersistentExchange component.
        /// </summary>
        METHOD PUBLIC Restore  
            Operation.Restore(); 
        END_METHOD 
        
        /// <summary>
        /// Reads the values of collected tags from the remote repository for a specified persistent group.
        /// </summary> 
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Read := Operation.Invoke(identifier, ePersistentOperation#Read);
        END_METHOD 

        ///<summary>
        /// Updates the values of collected tags to the remote repository for a specified persistent group.
        /// </summary> 
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC Update : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Update := Operation.Invoke(identifier, ePersistentOperation#Update);
        END_METHOD 

         /// <summary>
        /// Reads the values of collected tags from the remote repository for a specified persistent group.
        /// </summary> 
        METHOD PUBLIC Read : IAxoTaskState
            Read := Operation.Invoke('', ePersistentOperation#Read);
        END_METHOD 

        ///<summary>
        /// Updates the values of collected tags to the remote repository for a specified persistent group.
        /// </summary> 
        METHOD PUBLIC Update : IAxoTaskState
            Update := Operation.Invoke('', ePersistentOperation#Update);
        END_METHOD 

        /// <summary>
        /// Checks if a persistent group exists in the remote repository.
        /// </summary> 
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC EntityExist : IAxoEntityExistTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Operation.Invoke(identifier, ePersistentOperation#EntityExist);
            EntityExist := Operation;
        END_METHOD 
    END_CLASS
END_NAMESPACE    