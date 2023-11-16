USING AXOpen.Core;
NAMESPACE AXOpen.Data
    CLASS PUBLIC AxoDataPersistentExchange EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            Operation : AxoDataPersistentCurdTask;
        END_VAR

        VAR CONSTANT
            DEFAULT_ID : STRING := 'default';
        END_VAR

        VAR
            _IsFirstReadOperationDone  : BOOL;
            _FirstReadedOperationIdentifier : STRING[254];

            // concurrent invoke handling...
            LastCallerIdentity : ULINT;
            LastOperation : ePersistentOperation;

            LastCycleCount : ULINT;
        END_VAR

        ///<summary>
        /// This method determines if the current call is concurrent or not.
        ///  It takes an AXOpen.Core.IAxoObject as input and returns a BOOL. 
        /// The logic involves checking the identity of the caller and comparing it with the last caller identity, 
        /// along with the operation's readiness and cycle count checks.
        /// </summary>                 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        METHOD PRIVATE IsNotConcurrentCall : BOOL
            VAR_INPUT
                caller : AXOpen.Core.IAxoObject;
            END_VAR  
            VAR 
                newCallerIdentity : ULINT;
                newCycleCount : ULINT;
                operationState : eAxoTaskState;
            END_VAR

            IsNotConcurrentCall := false;
            newCallerIdentity := caller.GetIdentity();
            newCycleCount := THIS.GetContext().OpenCycleCount();

            IF  newCallerIdentity = LastCallerIdentity THEN 
                IsNotConcurrentCall := true;
                LastCycleCount := newCycleCount;
                RETURN;
            ELSE
                operationState := Operation.GetState();
                IF (operationState = eAxoTaskState#Ready) OR (operationState = eAxoTaskState#Done)  THEN
                    IF LastCycleCount > newCycleCount THEN // counter overflow 
                        IsNotConcurrentCall := true;
                        LastCycleCount := newCycleCount;
                        LastCallerIdentity := newCallerIdentity;
                        Operation.Restore();

                    ELSIF  (LastCycleCount + ULINT#2) < newCycleCount THEN 
                        IsNotConcurrentCall := true;
                        LastCycleCount := newCycleCount;
                        LastCallerIdentity := newCallerIdentity;
                        Operation.Restore();
                    END_IF;
                END_IF;    
            END_IF;
            
        END_METHOD

        ///<summary>
        /// Runs intialization and cyclical handling of this AxoDataPersistentExchange.        
        /// </summary>                 
        /// <param name="parent">Parent of this object</param>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    

            if _context_ = NULL then 
                THIS.Initialize(parent);
                Operation.Initialize(THIS);
            end_if;

            Operation.Execute();
            
            IF NOT _IsFirstReadOperationDone then 
               IF Operation.IsDone() AND (LastOperation = ePersistentOperation#Read) THEN 
                    _IsFirstReadOperationDone := TRUE;
                    _FirstReadedOperationIdentifier := Operation.DataEntityIdentifier;
               END_IF;
            END_IF;
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
        /// Reads the values of collected tags from the remote repository for a default persistent group.
        /// </summary> 
        METHOD PUBLIC ReadDefault : IAxoTaskState
            VAR_INPUT
                Caller : IAxoObject;
            END_VAR

            ReadDefault := Operation.Invoke(DEFAULT_ID, ePersistentOperation#Read);

            IF Operation.IsDone() THEN
                LastOperation := ePersistentOperation#Read;
            END_IF;
        END_METHOD 

        ///<summary>
        /// Updates the values of collected tags to the remote repository for a default persistent group.
        /// </summary> 
        METHOD PUBLIC UpdateDefault : IAxoTaskState
            UpdateDefault := Operation.Invoke(DEFAULT_ID, ePersistentOperation#Update);

         IF Operation.IsDone() THEN
                LastOperation := ePersistentOperation#Update;
            END_IF;
        END_METHOD 


        /// <summary>
        /// Checks if a default persistent group exists in the remote repository.
        /// </summary> 
        METHOD PUBLIC ExistDefault : IAxoEntityExistTaskState
            Operation.Invoke(DEFAULT_ID, ePersistentOperation#EntityExist);
            ExistDefault := Operation;

            IF Operation.IsDone() THEN
                LastOperation := ePersistentOperation#EntityExist;
            END_IF;
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

            IF Operation.IsDone() THEN
                LastOperation := ePersistentOperation#Read;
            END_IF;
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

            IF Operation.IsDone() THEN
                LastOperation := ePersistentOperation#Update;
            END_IF;
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

            IF Operation.IsDone() THEN
                LastOperation := ePersistentOperation#EntityExist;
            END_IF;
        END_METHOD  

        /// <summary>
        /// Return last result of EntitiyExist Operation. True = Record Exist.
        /// </summary> 
        METHOD PUBLIC EntityExistResult : BOOL
            EntityExistResult := Operation._exist;
        END_METHOD 


        /// <summary>
        /// This method attempts to invoke a read operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the read operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC TryInvokeRead : BOOL
            VAR_INPUT
                caller : IAxoObject;
                identifier : STRING[254];
            END_VAR
            
            TryInvokeRead := false;
            IF THIS.IsNotConcurrentCall(caller) THEN
                TryInvokeRead := Operation.Invoke(identifier, ePersistentOperation#Read).IsBusy();
                LastOperation := ePersistentOperation#Read;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a update operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the update operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC TryInvokeUpdate : BOOL
            VAR_INPUT
                Caller : IAxoObject;
                identifier : STRING[254];
            END_VAR

            TryInvokeUpdate := false;
            IF THIS.IsNotConcurrentCall(Caller) THEN
                TryInvokeUpdate := Operation.Invoke(identifier, ePersistentOperation#Update).IsBusy();
                LastOperation := ePersistentOperation#Update;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a updateAll operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the update operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC TryInvokeUpdateAll : BOOL
            VAR_INPUT
                Caller : IAxoObject;
            END_VAR

            TryInvokeUpdateAll := false;
            IF THIS.IsNotConcurrentCall(Caller) THEN
                TryInvokeUpdateAll := Operation.Invoke('', ePersistentOperation#UpdateAll).IsBusy();
                LastOperation := ePersistentOperation#UpdateAll;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a readAll operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the readAll operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC TryInvokeReadAll : BOOL
            VAR_INPUT
                Caller : IAxoObject;
            END_VAR

            TryInvokeReadAll := false;
            IF THIS.IsNotConcurrentCall(Caller) THEN
                TryInvokeReadAll := Operation.Invoke('', ePersistentOperation#ReadAll).IsBusy();
                LastOperation := ePersistentOperation#ReadAll;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a update operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the update operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC TryInvokeEntityExist : BOOL
            VAR_INPUT
                Caller : IAxoObject;
                identifier : STRING[254];
            END_VAR

            TryInvokeEntityExist := false;
            IF THIS.IsNotConcurrentCall(Caller) THEN
                TryInvokeEntityExist := Operation.Invoke(identifier, ePersistentOperation#EntityExist).IsBusy();
                LastOperation := ePersistentOperation#EntityExist;
            END_IF;
        END_METHOD 

        
        /// <summary>
        /// Determines whether a read operation has been completed.
        /// </summary>
        /// <param name="caller">The object representing the caller of the method, used to check for concurrent calls.</param>
        /// <returns>Boolean indicating whether the read operation was completed.</returns>
        METHOD PUBLIC IsReadDone : BOOL
            VAR_INPUT
                caller : IAxoObject;
            END_VAR
            IsReadDone := false;
            IF THIS.IsNotConcurrentCall(caller) THEN
                IF LastOperation = ePersistentOperation#Read THEN
                    IsReadDone := Operation.IsDone();
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// Determines whether a update operation has been completed.
        /// </summary>
        /// <param name="caller">The object representing the caller of the method, used to check for concurrent calls.</param>
        /// <returns>Boolean indicating whether the read operation was completed.</returns>
        METHOD PUBLIC IsUpdateDone : BOOL
            VAR_INPUT
                caller : IAxoObject;
            END_VAR
            IsUpdateDone := false;
            IF THIS.IsNotConcurrentCall(caller) THEN
                IF LastOperation = ePersistentOperation#Update THEN
                    IsUpdateDone := Operation.IsDone();
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// Determines whether a updateAll operation has been completed.
        /// </summary>
        /// <param name="caller">The object representing the caller of the method, used to check for concurrent calls.</param>
        /// <returns>Boolean indicating whether the updateAll operation was completed.</returns>
        METHOD PUBLIC IsUpdateAllDone : BOOL
            VAR_INPUT
                caller : IAxoObject;
            END_VAR
            IsUpdateAllDone := false;
            IF THIS.IsNotConcurrentCall(caller) THEN
                IF LastOperation = ePersistentOperation#UpdateAll THEN
                    IsUpdateAllDone := Operation.IsDone();
                END_IF;
            END_IF;
        END_METHOD 

         /// <summary>
        /// Determines whether a readAll operation has been completed.
        /// </summary>
        /// <param name="caller">The object representing the caller of the method, used to check for concurrent calls.</param>
        /// <returns>Boolean indicating whether the readAll operation was completed.</returns>
        METHOD PUBLIC IsReadAllDone : BOOL
            VAR_INPUT
                caller : IAxoObject;
            END_VAR
            IsReadAllDone := false;
            IF THIS.IsNotConcurrentCall(caller) THEN
                IF LastOperation = ePersistentOperation#ReadAll THEN
                    IsReadAllDone := Operation.IsDone();
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// Determines whether a entityExist operation has been completed.
        /// </summary>
        /// <param name="caller">The object representing the caller of the method, used to check for concurrent calls.</param>
        /// <returns>Boolean indicating whether the entityExist operation was completed.</returns>
        METHOD PUBLIC IsEntityExistDone : BOOL
            VAR_INPUT
                caller : IAxoObject;
            END_VAR
            IsEntityExistDone := false;
            IF THIS.IsNotConcurrentCall(caller) THEN
                IF LastOperation = ePersistentOperation#EntityExist THEN
                    IsEntityExistDone := Operation.IsDone();
                END_IF;
            END_IF;
        END_METHOD 

       /// <summary>
       /// Checks if the first read operation has been completed.
       /// </summary>
       /// <returns>Boolean indicating whether the first read operation is done.</returns>
       METHOD PUBLIC IsFirstReadDone : BOOL
            IsFirstReadDone  := _IsFirstReadOperationDone;
        END_METHOD 

        /// <summary>
        /// Retrieves the identifier of the first read operation.
        /// </summary>
        /// <returns>String representing the identifier of the first read operation.</returns>
        METHOD PUBLIC FirstReadedEntityId : STRING
            FirstReadedEntityId := _FirstReadedOperationIdentifier;
        END_METHOD 

    END_CLASS

END_NAMESPACE    