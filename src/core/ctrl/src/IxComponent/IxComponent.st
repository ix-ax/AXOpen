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

        METHOD INTERNAL CheckIfIsInServiceMode 
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
        
        ///<summary>
        /// Executes the cycle of this component. This method must be called cyclically inside the context.
        ///</summary>
        METHOD PUBLIC Execute
            THIS.CheckIfIsInServiceMode();
        END_METHOD  

        // {#ix-attr:[Container(Layout.Tabs)]}
        // {#ix-attr:[Group(GroupLayout.GroupBox)]}
        // {#ix-set:AttributeName = "This is some structure"}



    END_CLASS    
END_NAMESPACE