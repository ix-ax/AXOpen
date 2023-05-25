USING AXOpen.Core;

NAMESPACE AXOpen.Data
    ///<summary>
    /// Provides base class for any data exchange with an arbitrary remote repository.  
    /// **For configuration and set up see [here](~/articles/data/AxoDataExchange.md)**  
    /// </summary>      
    {#ix-generic:<TOnline, TPlain>}
    CLASS AxoDataExchange EXTENDS AxoDataExchangeBase IMPLEMENTS IAxoDataExchange
        VAR PUBLIC
           {#ix-set:AttributeName =  "<#Create#>"} 
           CreateTask  : AxoDataExchangeTask; 
           {#ix-set:AttributeName =  "<#Read#>"} 
           ReadTask    : AxoDataExchangeTask;
           {#ix-set:AttributeName =  "<#Update#>"} 
           UpdateTask  : AxoDataExchangeTask;
           {#ix-set:AttributeName =  "<#Delete#>"} 
           DeleteTask  : AxoDataExchangeTask;
        END_VAR
        
        METHOD PRIVATE Run
            CreateTask.Initialize(THIS);            
            ReadTask.Initialize(THIS);
            UpdateTask.Initialize(THIS);
            DeleteTask.Initialize(THIS);
            
            CreateTask.Execute();
            ReadTask.Execute();
            UpdateTask.Execute();
            DeleteTask.Execute();
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
            THIS.Run();
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
            THIS.Run();
        END_METHOD

        ///<summary>
        /// Creates new entry into the remote repository from data entity of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param>  
        METHOD PUBLIC Create : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Create := CreateTask.Invoke(identifier);
        END_METHOD       
        
        ///<summary>
        /// Reads data from remote repository and copies them into data entity of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param>  
        METHOD PUBLIC Read : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Read := ReadTask.Invoke(identifier);
        END_METHOD 

        ///<summary>
        /// Updates data in remote repository from data entiry of this AxoDataExchange.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC Update : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Update := UpdateTask.Invoke(identifier);
        END_METHOD 

        ///<summary>
        /// Deletes data entry with given ID from remote repository.
        /// </summary> 
        /// <param name="identifier">Data identifier.</param> 
        METHOD PUBLIC Delete : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR
            Delete := DeleteTask.Invoke(identifier);
        END_METHOD 

        ///<summary>
        /// Restores all tasks associated with this object.
        ///</summary>         
        METHOD PUBLIC Restore
            CreateTask.Restore();            
            ReadTask.Restore();
            UpdateTask.Restore();
            DeleteTask.Restore();
        END_METHOD    
    END_CLASS    
END_NAMESPACE