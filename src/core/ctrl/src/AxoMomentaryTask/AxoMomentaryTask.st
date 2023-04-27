NAMESPACE AXOpen.Core
    ///<summary>
    /// Provides basic momentary on function.
    ///  To get the actual state of the toggle task, '''IsSwitchedOn()''',  '''IsSwitchedOff()''' AND '''GetState()''' methods are available.
    ///</summary>

    {#ix-prop: public string AttributeStateOnDesc}
    {#ix-set: AttributeStateOnDesc = "<#On#>"}
    {#ix-prop: public string AttributeStateOffDesc}
    {#ix-set:AttributeStateOffDesc = "<#Off#>"}
    CLASS PUBLIC AxoMomentaryTask EXTENDS AxoObject IMPLEMENTS IAxoMomentaryTask
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            State : BOOL;     
             
            ///<summary>
            /// Remote request to set the state of this task to '''TRUE'''.
            ///</summary>
            RemoteSwitchOn : BOOL;

            ///<summary>
            /// Gets or sets whether this task is disabled for any manipulations.
            ///</summary>
            {#ix-set: AttributeName = "<#IsDisabled#>"}
            {#ix-attr:[ReadOnly()]}
            IsDisabled : BOOL := FALSE;

            // ///<summary>
            // /// Contains contex cycle number when this task started.            
            // ///</summary>           
            // StartSignature : ULINT;
        END_VAR    
        
        VAR PRIVATE
            _openCycleCount : ULINT;
        END_VAR 
        
        ///<summary>
        /// Gets the actual state of this task.
        ///</summary>    
        METHOD PUBLIC GetState : BOOL          
             GetState := State;
        END_METHOD

        METHOD PRIVATE IsRunCalledInThisPlcCycle : BOOL
            IF NOT IsNullContext(THIS.GetContext()) THEN
                IsRunCalledInThisPlcCycle := _openCycleCount = THIS.GetContext().OpenCycleCount();
            ELSE
                IsRunCalledInThisPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PRIVATE WasRunCalledInPreviousPlcCycle : BOOL
            IF NOT IsNullContext(THIS.GetContext()) THEN
                WasRunCalledInPreviousPlcCycle := _openCycleCount + ULINT#1 = THIS.GetContext().OpenCycleCount();
            ELSE
                WasRunCalledInPreviousPlcCycle := FALSE;
            END_IF;     
        END_METHOD 

        ///<summary>
        ///	This method needs to be called cyclically.
        ///</summary>    
        METHOD PUBLIC Run : BOOL            
             _openCycleCount := THIS.GetContext().OpenCycleCount();

            IF IsDisabled THEN
                RemoteSwitchOn := FALSE;
             END_IF;

            IF(RemoteSwitchOn) THEN
                THIS.SwitchOn();
            ELSE
                THIS.SwitchOff();
            END_IF;

            IF State THEN
                THIS.SwitchedOn();
            ELSE
                THIS.SwitchedOff();	
            END_IF;
        END_METHOD    

        ///<summary>
        /// Sets the value of the `IsDisabled` variable
        ///</summary>
        METHOD PUBLIC SetIsDisabled
            VAR_INPUT
                Disabled : BOOL;
            END_VAR
            IsDisabled := Disabled;
            IF Disabled AND State THEN
                THIS.Run();
            END_IF;
        END_METHOD

        ///<summary>
        /// Returns the value of the `IsDisabled` variable
        ///</summary>
        METHOD PUBLIC GetIsDisabled : BOOL
            GetIsDisabled := IsDisabled;
        END_METHOD
    
        ///<summary>
        /// Returns `TRUE` if task is switched on
        ///</summary>
        METHOD PUBLIC IsSwitchedOn : BOOL
            IsSwitchedOn := State;
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if task is switched off
        ///</summary>
        METHOD PUBLIC IsSwitchedOff : BOOL
            IsSwitchedOff := NOT State;
        END_METHOD        
   
        METHOD PRIVATE SwitchOff
            //Check if Run method is called cyclically
            IF THIS.IsRunCalledInThisPlcCycle() OR THIS.WasRunCalledInPreviousPlcCycle() THEN
                IF State THEN
                    State := FALSE;
                    THIS.OnSwitchedOff();
                    THIS.OnStateChanged();
                END_IF;
            ELSE
                ; //TODO - raise a message that the Run() method is not called
            END_IF;
        END_METHOD

        METHOD PRIVATE SwitchOn 
            //Check if Run method is called cyclically
            IF THIS.IsRunCalledInThisPlcCycle() OR THIS.WasRunCalledInPreviousPlcCycle() THEN
                IF IsDisabled THEN
                    RETURN;
                ELSE
                    IF NOT State THEN
                        State := TRUE;
                        THIS.OnSwitchedOn();
                        THIS.OnStateChanged();
                    END_IF;
                END_IF;
            ELSE
                ; //TODO - raise a message that the Run() method is not called
            END_IF;
        END_METHOD

		/// <summary>
		/// 	Executes ones when momentary task changes its state from '''FALSE''' to '''TRUE'''.
		/// </summary>			
        METHOD PROTECTED OnSwitchedOn ; END_METHOD

		/// <summary>
		///     Executes ones when momentary task changes its state from '''TRUE''' to '''FALSE'''.
		/// </summary>			
        METHOD PROTECTED OnSwitchedOff ; END_METHOD

		/// <summary>
		/// 	Executes ones when momentary task changes its state.
		/// </summary>			
        METHOD PROTECTED OnStateChanged ; END_METHOD

        /// <summary>
		/// 	Executes while the task is in `On` state.
		/// </summary>			
        METHOD PROTECTED SwitchedOn ; END_METHOD

        /// <summary>
		/// 	Executes while the task is in `Off` state.
		/// </summary>			
        METHOD PROTECTED SwitchedOff ; END_METHOD

        END_CLASS    
END_NAMESPACE