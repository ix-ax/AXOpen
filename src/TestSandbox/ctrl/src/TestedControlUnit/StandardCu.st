NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;
    USING AXOpen.Cognex.Vision.v_6_0_0_0;
    

    ///<summary>
    /// Represents controlled units and high level task coordination.
    ///</summary>
    CLASS CU
        EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            ///<summary>
            /// Handles and intializes components used by this unit.
            ///</summary>
            Components : Components;
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
            StationName : STRING;
            Ids : TestIdGenerator;
            SettingSourceManager : AXOpen.DATA.IAxoDataExchange;
            SettingSourceData : REF_TO FragmentProcessData;
            ProcessData : REF_TO ProcessDataManger;
        END_VAR

        METHOD PUBLIC InvokeMode : INT
            VAR_INPUT
                iMode : INT;
            END_VAR
            ;
            InvokeMode := 0;
            CASE iMode OF
                10:
                    AutomatSequence.Invoke();
                    IF AutomatSequence.IsBusy() THEN
                        InvokeMode := iMode;
                    END_IF;
                20:
                    GroundSequence.Invoke();
                    IF GroundSequence.IsDone() THEN
                        InvokeMode := iMode;
                    END_IF;
                30:
                    ServiceMode.Invoke();
                    IF ServiceMode.IsBusy() THEN
                        InvokeMode := iMode;
                    END_IF;
            END_CASE;
        END_METHOD
        ///<summary>
        /// Runs this unit.
        ///</summary>

        METHOD PUBLIC Run
            VAR_INPUT
                _parent : AXOpen.Core.IAxoContext;
                _stationName : STRING;
                _settingSourceManager : AXOpen.DATA.IAxoDataExchange;
                _settingSourceData : REF_TO FragmentProcessData;
                Inputs : REF_TO sandboxtest.Inputs;
                Outputs : REF_TO sandboxtest.Outputs;
            END_VAR
            StationName := _stationName;
            SettingSourceManager := _settingSourceManager;
            SettingSourceData := _settingSourceData;
            THIS.Initialize(_parent);
            THIS.Execute(Inputs, Outputs);
        END_METHOD

        METHOD PRIVATE Execute
            VAR_INPUT
                Inputs : REF_TO sandboxtest.Inputs;
                Outputs : REF_TO sandboxtest.Outputs;
            END_VAR
            // Component I/O immange and management handling.
            Components.Update(THIS, Inputs, Outputs);
            // Process data manager
            ProcessData^.Run(THIS);
            // Handles ground sequence
            GroundSequence.Run(THIS, REF(Components), ProcessData, SettingSourceData, SettingSourceManager, Ids);
            // Restores other states when Ground executes
            IF (GroundSequence.IsBusy()) THEN
                AutomatSequence.Restore();
                ServiceMode.Restore();
            END_IF;
            // Handles automatic sequence (ground must be previously done)           
            AutomatSequence.IsDisabled := GroundSequence.Status <> eAxoTaskState#Done;
            AutomatSequence.Run(THIS, REF(Components), ProcessData, SettingSourceData, SettingSourceManager, Ids, REF(StationName));
            // Handles service/manual mode
            ServiceMode.Run(THIS, Components);
            IF ServiceMode.IsBusy() THEN
                GroundSequence.Restore();
                AutomatSequence.Restore();
            END_IF;
        END_METHOD
    END_CLASS

END_NAMESPACE
