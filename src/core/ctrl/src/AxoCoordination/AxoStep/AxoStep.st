NAMESPACE AXOpen.Core
    {#ix-prop: public string Description}
    CLASS AxoStep EXTENDS AxoTask IMPLEMENTS IAxoStep       
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            Order : ULINT;            
            StepDescription : STRING[120];
            IsActive : BOOL;                        
            IsEnabled : BOOL;
        END_VAR 

        VAR PROTECTED            
            _openCycleCount : ULINT;
            _isCalledJustOnceInThisPlcCycle : BOOL;
            _multipleStepCallInThisPlcCycle : BOOL;
            _noStepCallInPreviousPlcCycle : BOOL;
        END_VAR 
       
        ///<summary>
        /// Returns the order of the execution.
        ///</summary>
        METHOD PUBLIC GetStepOrder : ULINT;
            GetStepOrder := Order;
        END_METHOD

        ///<summary>
        /// Sets the order of the execution, if conditions are met.
        ///</summary>
        METHOD PUBLIC SetStepOrder
            VAR_INPUT
                coord : IAxoCoordinator;
                StepOrder : ULINT;
            END_VAR;
            IF coord <> NULL AND coord.GetCoordinatorState() = AxoCoordinatorStates#Configuring OR StepOrder = ULINT#0 THEN
                Order := StepOrder;
            END_IF;
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if the execution of the step is called only once in this PLC cycle.
        ///</summary>
        METHOD PUBLIC IsCalledJustOnceInThisPlcCycle : BOOL
             IsCalledJustOnceInThisPlcCycle := THIS._isCalledJustOnceInThisPlcCycle;  
        END_METHOD
        
        ///<summary>
        /// Returns `TRUE` if instance of `THIS` step is curently executing
        ///</summary>
        METHOD PUBLIC Execute : BOOL
            VAR_INPUT
                coord : IAxoCoordinator;                
            END_VAR
            Execute := THIS.ExecuteInternal(coord,TRUE);
        END_METHOD
                  
        ///<summary>
        /// Returns `TRUE` if instance of `THIS` step is curently executing and the step is enabled
        ///</summary>
        METHOD PUBLIC Execute : BOOL
            VAR_INPUT
                coord : IAxoCoordinator;                
                Enable : BOOL;
            END_VAR
            Execute := THIS.ExecuteInternal(coord,Enable);
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if instance of `THIS` step is curently executing and the step is enabled 
        /// and sets the description of the step
        ///</summary>
        METHOD PUBLIC Execute : BOOL
            VAR_INPUT
                coord : IAxoCoordinator;                
                Enable : BOOL;
                Description : STRING[120];
            END_VAR
            StepDescription := Description;
            Execute := THIS.ExecuteInternal(coord,Enable);
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if instance of `THIS` step is curently executing
        /// and sets the description of the step
        ///</summary>
        METHOD PUBLIC Execute : BOOL
            VAR_INPUT
                coord : IAxoCoordinator;                
                Description : STRING[120];
            END_VAR
            StepDescription := Description;
            Execute := THIS.ExecuteInternal(coord,TRUE);
        END_METHOD

        METHOD PROTECTED CountCallsOfTheExecuteMethod
            VAR    
                _currentlyOpenCycleCount : ULINT;
            END_VAR

            IF _context_ <> NULL THEN
                _currentlyOpenCycleCount := _context_.OpenCycleCount();
                _isCalledJustOnceInThisPlcCycle:= _openCycleCount = _currentlyOpenCycleCount - ULINT#1;
                _multipleStepCallInThisPlcCycle := _openCycleCount >= _currentlyOpenCycleCount; // TODO: We will need to message this, when messaging ready.            
                _noStepCallInPreviousPlcCycle := _openCycleCount < _currentlyOpenCycleCount - ULINT#1; // TODO: We will need to message this, when messaging ready.            
                _openCycleCount := _currentlyOpenCycleCount;
            END_IF;
        END_METHOD

        METHOD PROTECTED ExecuteInternal : BOOL
            VAR_INPUT
                coord : IAxoCoordinator;                
                Enable : BOOL;
            END_VAR
            VAR                
                Sequencer : REF_TO AxoSequencer;
                coordAsAxoObject : IAxoObject;
                // Selector : REF_TO Selector;
            END_VAR    

            // Initializes with the coordinator if not previously intialized.
            coordAsAxoObject ?= coord;
            IF(coordAsAxoObject <> NULL) THEN THIS.Initialize(coordAsAxoObject); END_IF;
            
            THIS.CountCallsOfTheExecuteMethod();

            Sequencer ?= coord;
            IF(Sequencer <> NULL) THEN ExecuteInternal := Sequencer^.Execute(THIS, Enable); END_IF;

                
            // Selector ?= coord;
            // IF(coord <> NULL) THEN Sequencer^.ExecuteWithSelector(THIS, Enable); END_IF;    

        END_METHOD    

        ///<summary>
        /// Sets the value of the `IsActive` variable
        ///</summary>
        METHOD PUBLIC SetIsActive
            VAR_INPUT
                Active : BOOL;
            END_VAR
            IF(NOT THIS.IsActive AND Active) THEN _context_.GetLogger().Log('At step:', AXOpen.Logging.eLogLevel#Verbose, THIS); END_IF;
            IsActive := Active;
        END_METHOD

        ///<summary>
        /// Returns the value of the `IsActive` variable
        ///</summary>
        METHOD PUBLIC GetIsActive : BOOL
            GetIsActive := IsActive;
        END_METHOD

        ///<summary>
        /// Sets the value of the `IsEnabled` variable
        ///</summary>
        METHOD PUBLIC SetIsEnabled
            VAR_INPUT
                Enabled : BOOL;
            END_VAR
            IsEnabled := Enabled;
        END_METHOD

        ///<summary>
        /// Returns the value of the `IsEnabled` variable
        ///</summary>
        METHOD PUBLIC GetIsEnabled : BOOL
            GetIsEnabled := IsEnabled;
        END_METHOD
    END_CLASS    
END_NAMESPACE


