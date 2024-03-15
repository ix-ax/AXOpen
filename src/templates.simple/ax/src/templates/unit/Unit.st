NAMESPACE axosimple.UnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
           
    ///<summary>
    /// Represents controlled units and high level task coordination.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS Unit
        EXTENDS axosimple.BaseUnit.UnitBase
        VAR PUBLIC
            ///<summary>
            /// Provide access to unit objets, that are used into sequnces.
            ///</summary>
            UnitObjects  : axosimple.UnitTemplate.UnitObjects;
            
            ///<summary>
            /// Ground sequence. Contains logic that brings the unit into initial state.
            ///</summary>
            GroundSequence : axosimple.UnitTemplate.GroundSequence;

            ///<summary>
            /// Automatic sequence. Contains logic for automatic operations of this unit.
            ///</summary>
            AutomatSequence : axosimple.UnitTemplate.AutomatSequence;
            
            ///<summary>
            /// Service mode contains logic for service/manual operations.
            ///</summary>
            ServiceMode : axosimple.UnitTemplate.ServiceMode;
        END_VAR
        ///<summary>
        /// Runs this unit.
        ///</summary>

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoContext;
  
                ///<summary>
                /// Hardware input structure
                ///</summary>
                Inputs : REF_TO axosimple.Inputs; // MUST BE AS REF_TO DUE TO COMPONENTS THAT HAS REF TO ARRAYS
                ///<summary>
                /// Hardware output structure
                ///</summary>
                Outputs : REF_TO  axosimple.Outputs;                
            END_VAR
            THIS.Initialize(parent);
            THIS.Execute(Inputs, Outputs);
        END_METHOD

        METHOD PRIVATE Execute
            VAR_INPUT
                Inputs : REF_TO axosimple.Inputs;
                Outputs : REF_TO  axosimple.Outputs;
            END_VAR
          
            // Component I/O immange and management handling.
            UnitObjects.Components^.Update(THIS, Inputs, Outputs);
            // Process data manager
            UnitObjects.ProcessData^.Run(THIS);
            // Process settings data manager
            UnitObjects.ProcessSettings^.Run(THIS);
            // Technology data manager
            UnitObjects.TechnologySettings^.Run(THIS);
            // Handles ground sequence
            GroundSequence.Run(THIS, REF(UnitObjects));
                       
            // Restores other states when Ground executes
            IF (GroundSequence.IsBusy()) THEN
                AutomatSequence.Restore();
                ServiceMode.Restore();
            END_IF;
            
            // Handles automatic sequence (ground must be previously done)           
            AutomatSequence.IsDisabled := GroundSequence.Status <> eAxoTaskState#Done;
            AutomatSequence.Run(THIS, REF(UnitObjects));
            // Handles service/manual mode
            ServiceMode.Run(THIS, UnitObjects.Components^);

            IF ServiceMode.IsBusy() THEN
                GroundSequence.Restore();
                AutomatSequence.Restore();
            END_IF;

            // remember last selected technolgy identifier 
            if  (UnitObjects.TechnologySettings^.DataManger.Payload.DataEntityId <> '') THEN
                IF UnitObjects.LastTechnologySettings <> UnitObjects.TechnologySettings^.DataManger.Payload.DataEntityId THEN 
                    IF UnitObjects.Global^.PersistentData^.InvokeUpdate(THIS, '') THEN 
                        UnitObjects.LastTechnologySettings :=  UnitObjects.TechnologySettings^.DataManger.Payload.DataEntityId;
                    END_IF;
                END_IF;
            END_IF;

        END_METHOD
    END_CLASS
     
END_NAMESPACE
