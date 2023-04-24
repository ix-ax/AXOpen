NAMESPACE AXOpen.Core
    ///<summary>
    /// Provides basic toggling between two states. The states are triggered by calling the '''Toggle()''' method.
    ///  To get the actual state of the toggle task, '''IsOn()''',  '''IsOff()''' and '''State()''' methods are available.
    ///</summary>

    CLASS PUBLIC AxoToggleTask EXTENDS AxoObject IMPLEMENTS IAxoToggleTask
        VAR PUBLIC
            {#ix-attr:[ReadOnly()]}
            State : BOOL;     
             
            ///<summary>
            /// Remote request to toggle the state of this task.
            ///</summary>
            RemoteToggle : BOOL;

            ///<summary>
            /// Remote request to switch on the state of this task.
            ///</summary>
            RemoteSwitchOn : BOOL;

            ///<summary>
            /// Remote request to switch off the state of this task.
            ///</summary>
            RemoteSwitchOff : BOOL;

            ///<summary>
            /// Gets or sets whether this task is disabled for any manipulations.
            ///</summary>
            {attribute addProperty Name "<#Disabled#>"}
            {attribute clr [ReadOnly()]}
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
                RemoteToggle := FALSE;
                RemoteSwitchOn := FALSE;
                RemoteSwitchOff := FALSE;
            END_IF;


            //Triggering toggle remotely
            IF(RemoteToggle) THEN
                THIS.Toggle();
                RemoteToggle := FALSE;
            END_IF;

            //Triggering switch on remotely
            IF(RemoteToggle) THEN
                THIS.SwitchOn();
                RemoteToggle := FALSE;
            END_IF;

            //Triggering switch off remotely
            IF(RemoteToggle) THEN
                THIS.SwitchOff();
                RemoteToggle := FALSE;
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

        ///<summary>
        /// Use to toggle the state of the '''AxoToggleTask'''.
        ///</summary>  
        METHOD PUBLIC Toggle : BOOL
            Toggle := FALSE;
            //Check if Run method is called cyclically
            IF THIS.IsRunCalledInThisPlcCycle() OR THIS.WasRunCalledInPreviousPlcCycle() THEN
                IF IsDisabled THEN
                    RETURN;
                ELSE
                    State :=  NOT State;
                    IF State THEN
                        THIS.OnSwitchedOn();
                        IF THIS.IsRunCalledInThisPlcCycle() THEN
                            THIS.SwitchedOn();
                        END_IF;
                    ELSE
                        THIS.OnSwitchedOff();	
                        IF THIS.IsRunCalledInThisPlcCycle() THEN
                            THIS.SwitchedOff();
                        END_IF;
                    END_IF;	
                    THIS.OnStateChanged();
                    Toggle := TRUE;
                END_IF;
            END_IF;
        END_METHOD
    
        ///<summary>
        /// Use to set the state of the '''AxoToggleTask''' to the value '''FALSE'''.
        ///</summary>        
        METHOD PUBLIC SwitchOff : BOOL
            SwitchOff := FALSE;
            //Check if Run method is called cyclically
            IF THIS.IsRunCalledInThisPlcCycle() OR THIS.WasRunCalledInPreviousPlcCycle() THEN
                IF IsDisabled THEN
                    RETURN;
                ELSE
                    IF State THEN
                        State := FALSE;
                        THIS.OnSwitchedOff();
                        THIS.OnStateChanged();
                        IF THIS.IsRunCalledInThisPlcCycle() THEN
                            THIS.SwitchedOff();
                        END_IF;
                        SwitchOff := TRUE;
                    END_IF;
                END_IF;
            END_IF;
        END_METHOD

        METHOD PUBLIC SwitchOn : BOOL
            SwitchOn := FALSE;
            //Check if Run method is called cyclically
            IF THIS.IsRunCalledInThisPlcCycle() OR THIS.WasRunCalledInPreviousPlcCycle() THEN
                IF IsDisabled THEN
                    RETURN;
                ELSE
                    IF NOT State THEN
                        State := TRUE;
                        THIS.OnSwitchedOn();
                        THIS.OnStateChanged();
                        IF THIS.IsRunCalledInThisPlcCycle() THEN
                            THIS.SwitchedOn();
                        END_IF;
                        SwitchOn := TRUE;
                    END_IF;
                END_IF;
            END_IF;
        END_METHOD

		/// <summary>
		/// 	Executes ones when toggle task changes its state from '''FALSE''' to '''TRUE'''.
		/// </summary>			
        METHOD PROTECTED OnSwitchedOn ; END_METHOD

		/// <summary>
		///     Executes ones when toggle task changes its state from '''TRUE''' to '''FALSE'''.
		/// </summary>			
        METHOD PROTECTED OnSwitchedOff ; END_METHOD

		/// <summary>
		/// 	Executes ones when toggle task changes its state.
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