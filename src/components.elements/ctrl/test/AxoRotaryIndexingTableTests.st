USING AxUnit;
USING AXOpen.Components.Elements;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AXOpen.Components.Elements.Tests
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoRotaryIndexingTableTests
        VAR
            context : TestContext;
            _uut : AxoRotaryIndexingTable;
            _enableTurn : BOOL;
            _startTurn : BOOL;
            _configDefaults : AxoRotaryIndexingTable_Config;
            _stateDefaults : AxoRotaryIndexingTable_State;
            _controlDefaults : AxoRotaryIndexingTable_Control;
            _statusDefaults : AxoRotaryIndexingTable_Component_Status;
        END_VAR

        {Test}
        METHOD PUBLIC Config_DefaultValues

            AxUnit.Assert.Equal(LT#5S, _configDefaults.InfoTime);
            AxUnit.Assert.Equal(LT#10S, _configDefaults.ErrorTime);
            AxUnit.Assert.Equal(LT#10S, _configDefaults.TaskTimeout);
            AxUnit.Assert.Equal(TRUE, _configDefaults.Direction = eAxoRotaryIndexingTableDirection#Cw);
            AxUnit.Assert.Equal(UINT#0, _configDefaults.NumberOfPositions);
            AxUnit.Assert.Equal(UINT#0, _configDefaults.Offset);
        END_METHOD

        {Test}
        METHOD PUBLIC State_DefaultValues

            AxUnit.Assert.Equal(FALSE, _stateDefaults.SafetyCondition);
            AxUnit.Assert.Equal(FALSE, _stateDefaults.InPosition);
            AxUnit.Assert.Equal(FALSE, _stateDefaults.InPrecisePosition);
            AxUnit.Assert.Equal(UINT#0, _stateDefaults.CodingPosition);
        END_METHOD

        {Test}
        METHOD PUBLIC Control_DefaultValues

            AxUnit.Assert.Equal(FALSE, _controlDefaults.EnableTurn);
            AxUnit.Assert.Equal(FALSE, _controlDefaults.StartTurn);
        END_METHOD

        {Test}
        METHOD PUBLIC ComponentStatus_DefaultValues

            AxUnit.Assert.Equal(UINT#0, _statusDefaults.StartPosition);
            AxUnit.Assert.Equal(UINT#0, _statusDefaults.EndPosition);
            AxUnit.Assert.Equal(UINT#0, _statusDefaults.Positions[0]);
            AxUnit.Assert.Equal(UINT#0, _statusDefaults.Positions[16]);
            AxUnit.Assert.Equal(UINT#0, _statusDefaults.Positions[32]);
        END_METHOD

        {Test}
        METHOD PUBLIC Run_WithNullParent_SetsProgrammingError
            _uut.Config.NumberOfPositions := UINT#4;
            _uut.Run(NULL, TRUE, TRUE, TRUE, UINT#1, _enableTurn, _startTurn);

            AxUnit.Assert.Equal(UINT#700, _uut.Status.Error.Id);
        END_METHOD

        {Test}
        METHOD PUBLIC Run_WithTooFewPositions_SetsProgrammingError
            context.Open();
            _enableTurn := FALSE;
            _startTurn := FALSE;
            _uut.Config.NumberOfPositions := UINT#1;

            _uut.Run(context.SignalParent, TRUE, TRUE, TRUE, UINT#1, _enableTurn, _startTurn);

            AxUnit.Assert.Equal(UINT#701, _uut.Status.Error.Id);
            context.Close();
        END_METHOD

        METHOD PUBLIC Run_WithZeroOffset_DefaultsToOne
            context.Open();
            _enableTurn := FALSE;
            _startTurn := FALSE;
            _uut.Config.NumberOfPositions := UINT#4;
            _uut.Config.Offset := UINT#0;

            _uut.Run(context.SignalParent, TRUE, TRUE, TRUE, UINT#2, _enableTurn, _startTurn);

            AxUnit.Assert.Equal(UINT#1, _uut.Config.Offset);
            AxUnit.Assert.Equal(UINT#0, _uut.Status.Error.Id);
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Run_ComputesPositionsAndCurrentPosition
            context.Open();
            _enableTurn := FALSE;
            _startTurn := FALSE;
            _uut.Config.NumberOfPositions := UINT#4;
            _uut.Config.Offset := UINT#1;

            _uut.Run(context.SignalParent, TRUE, TRUE, TRUE, UINT#3, _enableTurn, _startTurn);

            AxUnit.Assert.Equal(UINT#3, _uut.CurrentPosition);
            AxUnit.Assert.Equal(UINT#0, _uut.Status.Error.Id);
            AxUnit.Assert.Equal(UINT#3, _uut.Status.Positions[0]);
            AxUnit.Assert.Equal(UINT#2, _uut.Status.Positions[1]);
            AxUnit.Assert.Equal(UINT#1, _uut.Status.Positions[2]);
            AxUnit.Assert.Equal(UINT#4, _uut.Status.Positions[3]);
            AxUnit.Assert.Equal(FALSE, _enableTurn);
            AxUnit.Assert.Equal(FALSE, _startTurn);
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Restore_ResetsOutputsAndStatus
            _uut.Status.Error.Id := UINT#999;
            _uut.Status.Action.Id := UINT#555;
            _uut.Outputs.EnableTurn := TRUE;
            _uut.Outputs.StartTurn := TRUE;

            _uut.Restore();

            AxUnit.Assert.Equal(UINT#0, _uut.Status.Error.Id);
            AxUnit.Assert.Equal(UINT#50, _uut.Status.Action.Id);
            AxUnit.Assert.Equal(FALSE, _uut.Outputs.EnableTurn);
            AxUnit.Assert.Equal(FALSE, _uut.Outputs.StartTurn);
        END_METHOD

    END_CLASS
END_NAMESPACE
