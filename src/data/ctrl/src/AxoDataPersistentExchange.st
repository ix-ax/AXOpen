USING AXOpen.Core;
NAMESPACE AXOpen.Data
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoDataPersistentExchange EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            Operation : AxoDataPersistentCurdTask;
        END_VAR

        VAR CONSTANT
            DEFAULT_ID : STRING := 'default';
        END_VAR

        VAR
            _IsFirstReadAllDone  : BOOL := FALSE;

            // concurrent invoke handling...
            LastCallerIdentity : ULINT;
            LastCycleCount : ULINT;
            LastOperation : ePersistentOperation;
            
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

            IF newCallerIdentity = ULINT#0 THEN // IF IDENTITY IS NOT SET DO NOT ALLOW CALL
                RETURN;
            END_IF;

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
            
            IF NOT _IsFirstReadAllDone THEN 
                IF Operation.IsInitialized AND (Operation.Identity <> ULINT#0) THEN // MUST BE INITIALIZED AND WITH IDENTITY
                    IF Operation.IsReady() THEN // read all after startup
                        Operation.Invoke('', ePersistentOperation#ReadAll);
                        LastOperation := ePersistentOperation#ReadAll;

                    ELSIF Operation.IsDone() AND (LastOperation = ePersistentOperation#ReadAll) THEN 
                         _IsFirstReadAllDone := TRUE;
                    END_IF;
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
            
            IF _context_ = NULL THEN 
                THIS.Initialize(context);
                Operation.Initialize(THIS);
            END_IF;

            Operation.Execute();
            
            IF NOT _IsFirstReadAllDone THEN 
                IF Operation.IsInitialized AND (Operation.Identity <> ULINT#0) THEN // MUST BE INITIALIZED AND WITH IDENTITY
                    IF Operation.IsReady() THEN // read all after startup
                        Operation.Invoke('', ePersistentOperation#ReadAll);
                        LastOperation := ePersistentOperation#ReadAll;

                    ELSIF Operation.IsDone() AND (LastOperation = ePersistentOperation#ReadAll) THEN 
                         _IsFirstReadAllDone := TRUE;
                    END_IF;
                END_IF;
            END_IF;
        END_METHOD

        ///<summary>
        /// Executes the restore Operation for the AxoDataPersistentExchange component.
        /// </summary>
        METHOD PUBLIC Restore  
            Operation.Restore(); 
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
        METHOD PUBLIC InvokeRead : BOOL
            VAR_INPUT
                caller : IAxoObject;
                identifier : STRING[254];
            END_VAR
            
            InvokeRead := false;
            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(caller) THEN
                    InvokeRead := Operation.Invoke(identifier, ePersistentOperation#Read).IsBusy();
                    LastOperation := ePersistentOperation#Read;
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a read operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the read operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        METHOD PUBLIC InvokeReadDefault : BOOL
            VAR_INPUT
                caller : IAxoObject;
            END_VAR
            InvokeReadDefault := false;

            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(caller) THEN
                    InvokeReadDefault := Operation.Invoke(DEFAULT_ID, ePersistentOperation#Read).IsBusy();
                    LastOperation := ePersistentOperation#Read;
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a update operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the update operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC InvokeUpdate : BOOL
            VAR_INPUT
                Caller : IAxoObject;
                identifier : STRING[254];
            END_VAR
            InvokeUpdate := false;

            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(Caller) THEN
                    InvokeUpdate := Operation.Invoke(identifier, ePersistentOperation#Update).IsBusy();
                    LastOperation := ePersistentOperation#Update;
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a update operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the update operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        METHOD PUBLIC InvokeUpdateDefault : BOOL
            VAR_INPUT
                Caller : IAxoObject;
            END_VAR
            InvokeUpdateDefault := false;
          
            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(Caller) THEN
                    InvokeUpdateDefault := Operation.Invoke(DEFAULT_ID, ePersistentOperation#Update).IsBusy();
                    LastOperation := ePersistentOperation#Update;
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a updateAll operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the update operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC InvokeUpdateAll : BOOL
            VAR_INPUT
                Caller : IAxoObject;
            END_VAR
            InvokeUpdateAll := false;
            
            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(Caller) THEN
                    InvokeUpdateAll := Operation.Invoke('', ePersistentOperation#UpdateAll).IsBusy();
                    LastOperation := ePersistentOperation#UpdateAll;
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a readAll operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the readAll operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC InvokeReadAll : BOOL
            VAR_INPUT
                Caller : IAxoObject;
            END_VAR
            InvokeReadAll := false;

            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(Caller) THEN
                    InvokeReadAll := Operation.Invoke('', ePersistentOperation#ReadAll).IsBusy();
                    LastOperation := ePersistentOperation#ReadAll;
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// This method attempts to invoke a update operation. 
        /// It checks if the call is concurrent and, if not,
        /// invokes the update operation on the Operation object.
        /// </summary> 
        /// <param name="caller">IAxoObject for identifying the caller in the context of concurrent calls</param>
        /// <param name="identifier">The data identifier for the persistent group.</param>
        METHOD PUBLIC InvokeEntityExist : BOOL
            VAR_INPUT
                Caller : IAxoObject;
                identifier : STRING[254];
            END_VAR

            InvokeEntityExist := false;
            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(Caller) THEN
                    InvokeEntityExist := Operation.Invoke(identifier, ePersistentOperation#EntityExist).IsBusy();
                    LastOperation := ePersistentOperation#EntityExist;
                END_IF;
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

            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(caller) THEN
                    IF LastOperation = ePersistentOperation#Read THEN
                        IsReadDone := Operation.IsDone();
                    END_IF;
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

            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(caller) THEN
                    IF LastOperation = ePersistentOperation#Update THEN
                        IsUpdateDone := Operation.IsDone();
                    END_IF;
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

            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(caller) THEN
                    IF LastOperation = ePersistentOperation#UpdateAll THEN
                        IsUpdateAllDone := Operation.IsDone();
                    END_IF;
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

            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(caller) THEN
                    IF LastOperation = ePersistentOperation#ReadAll THEN
                        IsReadAllDone := Operation.IsDone();
                    END_IF;
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

            IF _IsFirstReadAllDone THEN
                IF THIS.IsNotConcurrentCall(caller) THEN
                    IF LastOperation = ePersistentOperation#EntityExist THEN
                        IsEntityExistDone := Operation.IsDone();
                    END_IF;
                END_IF;
            END_IF;
        END_METHOD 

        /// <summary>
        /// Checks if the first read operation has been completed.
        /// </summary>
        /// <returns>Boolean indicating whether the first read operation is done.</returns>
        METHOD PUBLIC IsFirstReadDone : BOOL
            IsFirstReadDone  := _IsFirstReadAllDone;
        END_METHOD 

        //!!! INTERNAL USAGE ONLY !!!
        METHOD INTERNAL SetFirstReadDone : BOOL
            _IsFirstReadAllDone  := TRUE;
        END_METHOD 

    END_CLASS

END_NAMESPACE    
