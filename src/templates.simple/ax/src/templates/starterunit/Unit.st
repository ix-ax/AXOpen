NAMESPACE axosimple.StarterUnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
           
    ///<summary>
    /// Represents controlled units and high level task coordination.
    ///</summary>
    CLASS Unit
        EXTENDS AXOpen.Core.AxoObject IMPLEMENTS axosimple.IUnit
        VAR PUBLIC
            ///<summary>
            /// Handles and intializes components used by this unit.
            ///</summary>
            Components : Components;

            ///<summary>
            /// Provides access to process data manager of this unit
            ///</summary>
            ProcessData : REF_TO ProcessDataManager;
            
            ///<summary>
            /// Provides access to process data manager of this unit
            ///</summary>
            TechnologyData : REF_TO TechnologyDataManager;

            ///<summary>
            /// Ground sequence. Contains logic that brings the unit into initial state.
            ///</summary>
            GroundSequence : GroundSequence;

            ///<summary>
            /// Automatic sequence. Contains logic for automatic operations of this unit.
            ///</summary>
            AutomatSequence : AutomatSequence;
            
            ///<summary>
            /// Service mode contains logic for service/manual operations.
            ///</summary>
            ServiceMode : ServiceMode;
        END_VAR
        ///<summary>
        /// Runs this unit.
        ///</summary>

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoContext;
            END_VAR
            VAR_IN_OUT
                ///<summary>
                /// Hardware input structure
                ///</summary>
                Inputs : axosimple.Inputs;
                ///<summary>
                /// Hardware output structure
                ///</summary>
                Outputs : axosimple.Outputs;                
            END_VAR
            THIS.Initialize(parent);
            THIS.Execute(Inputs, Outputs);
        END_METHOD

        METHOD PRIVATE Execute
            VAR_IN_OUT
                Inputs : axosimple.Inputs;
                Outputs : axosimple.Outputs;
            END_VAR
            // Component I/O immange and management handling.
            Components.Update(THIS, Inputs, Outputs);
            // Process data manager
            ProcessData^.Run(THIS);  
            // Technology data manager
            TechnologyData^.Run(THIS);
            // Handles ground sequence
            GroundSequence.Run(REF(Components), ProcessData, TechnologyData, THIS);
            // Restores other states when Ground executes
            IF (GroundSequence.IsBusy()) THEN
                AutomatSequence.Restore();
                ServiceMode.Restore();
            END_IF;
            // Handles automatic sequence (ground must be previously done)           
            AutomatSequence.IsDisabled := GroundSequence.Status <> eAxoTaskState#Done;
            AutomatSequence.Run(REF(Components), ProcessData, TechnologyData, THIS);
            // Handles service/manual mode
            ServiceMode.Run(THIS, Components);
            IF ServiceMode.IsBusy() THEN
                GroundSequence.Restore();
                AutomatSequence.Restore();
            END_IF;
        END_METHOD
    END_CLASS
     
END_NAMESPACE
