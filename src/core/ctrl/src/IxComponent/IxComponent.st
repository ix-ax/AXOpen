NAMESPACE AXOpen.Core

    CLASS PUBLIC ABSTRACT IxComponent EXTENDS IxObject IMPLEMENTS IIxComponent     
        ///<summary>
		/// Executes the logic for manual-maintenance control.   
        ///</summary>   
        METHOD PUBLIC FINAL ActivateManualControl 
            IF NOT IsNullContext(THIS.GetContext()) THEN
                 _manualControlContextCycle := THIS.GetContext().OpenCycleCount();
                THIS.ManualControl();
            ELSE
                _manualControlContextCycle := ULINT#0;        // TODO: some message should inform about this issue
            END_IF;  
        END_METHOD
        
        ///<summary>
		/// Gets whether the IxComponent is manually controllable. 
        /// To make the IxComponent manually controllable, it is necessary to call the `ActivateManualMode()` method cyclically.   
        ///</summary>   
        METHOD PUBLIC FINAL IsManuallyControllable: BOOL 
            THIS.CheckIfManualControlIsActivated();
            IsManuallyControllable := _isManuallyControllable;
        END_METHOD
        
        ///<summary>
		/// Restores this instance. This method must be implemented in derived class.
        ///</summary>   
        METHOD PROTECTED ABSTRACT Restore: IIxTask 
        END_METHOD

        ///<summary>
		/// Custom logic for manual control of the IxComponent.
		///	This method must be implemented in derived class.
        ///</summary>   
        METHOD PROTECTED ABSTRACT ManualControl
        END_METHOD

        VAR PRIVATE
           _manualControlContextCycle : ULINT;	
        END_VAR

        VAR PUBLIC
            {attribute addProperty Name "<#Is manually controllable#>"}
            {attribute clr [ReadOnly()]}
            _isManuallyControllable : BOOL;	
        END_VAR

        METHOD PRIVATE CheckIfManualControlIsActivated 
            VAR
                _myContextCycleCount : ULINT;
            END_VAR
            IF NOT IsNullContext(THIS.GetContext()) THEN
                _myContextCycleCount := THIS.GetContext().OpenCycleCount();
                //When component.Service() is called "before" invoking its task _serviceContextCycle is equal to GetContext().OpenCycleCount()
                _isManuallyControllable := _manualControlContextCycle = _myContextCycleCount OR 
                //When component.Service() is called "after" invoking its task (_serviceContextCycle + 1) is equal to GetContext().OpenCycleCount()
                                (_manualControlContextCycle + ULINT#1) = _myContextCycleCount;        
            ELSE
                _isManuallyControllable := FALSE;              // TODO: some message should inform about this issue
                _myContextCycleCount := ULINT#0;
            END_IF;  
        END_METHOD     

        METHOD PROTECTED Open
            THIS.CheckIfManualControlIsActivated();            
        END_METHOD  
        
        METHOD PUBLIC Run
            THIS.Open();
            // Place the custom logic here
            THIS.Close();
        END_METHOD    

        
        METHOD PROTECTED Close
            ;
        END_METHOD  
    END_CLASS    
END_NAMESPACE