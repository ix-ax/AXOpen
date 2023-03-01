NAMESPACE ix.framework.core

    CLASS PUBLIC ABSTRACT IxComponent EXTENDS IxObject IMPLEMENTS IIxComponent     
        ///<summary>
		/// Executes the logic for manual-maintenance control.   
        ///</summary>   
        METHOD PUBLIC FINAL Service 
            IF NOT IsNullContext(THIS.GetContext()) THEN
                 _serviceContextCycle := THIS.GetContext().OpenCycleCount();
                THIS.ServiceMode();
            ELSE
                _serviceContextCycle := ULINT#0;        // TODO: some message should inform about this issue
            END_IF;  
        END_METHOD
        
        ///<summary>
		/// Gets whether the component is in serviceable state. Serviceable state is when `Service` method is called cyclicaly.   
        ///</summary>   
        METHOD PUBLIC FINAL IsService: BOOL 
            THIS.CheckIfIsInServiceMode();
            IsService := _isinServiceMode;
        END_METHOD
        
        ///<summary>
		/// Restores this instance. This method must be implemented in derived class.
        ///</summary>   
        METHOD PROTECTED ABSTRACT Restore: IIxTask 
        END_METHOD

        ///<summary>
		/// Custom service (manual, maintenance) logic.
		///	This method must be implemented in derived class.
        ///</summary>   
        METHOD PROTECTED ABSTRACT ServiceMode
        END_METHOD

        VAR PRIVATE
           _serviceContextCycle : ULINT;	
        END_VAR

        VAR PUBLIC
            {attribute addProperty Name "<#Is in service mode#>"}
            {attribute clr [ReadOnly()]}
            _isinServiceMode : BOOL;	
        END_VAR

        METHOD PRIVATE CheckIfIsInServiceMode 
            VAR
                _myContextCycleCount : ULINT;
            END_VAR
            IF NOT IsNullContext(THIS.GetContext()) THEN
                _myContextCycleCount := THIS.GetContext().OpenCycleCount();
                //When component.Service() is called "before" invoking its task _serviceContextCycle is equal to GetContext().OpenCycleCount()
                _isinServiceMode := _serviceContextCycle = _myContextCycleCount OR 
                //When component.Service() is called "after" invoking its task (_serviceContextCycle + 1) is equal to GetContext().OpenCycleCount()
                                (_serviceContextCycle + ULINT#1) = _myContextCycleCount;        
            ELSE
                _isinServiceMode := FALSE;              // TODO: some message should inform about this issue
                _myContextCycleCount := ULINT#0;
            END_IF;  
        END_METHOD     

        METHOD PROTECTED Open
            THIS.CheckIfIsInServiceMode();            
        END_METHOD  
        
        METHOD PUBLIC Run
            THIS.Open();
            // Place the custom logic here
            THIS.Close();
        END_METHOD    

        // ///<summary> 
        // /// Custom logic of the extended IxComponent should be placed here. 
        // /// Do not call this method explicitly. 
        // /// Call the method Run instead to ensure that the methods are going to be called in the required order.
        // ///</summary>
        // METHOD PROTECTED Main
        //     ;
        // END_METHOD     
        
        METHOD PROTECTED Close
            ;
        END_METHOD  
    END_CLASS    
END_NAMESPACE