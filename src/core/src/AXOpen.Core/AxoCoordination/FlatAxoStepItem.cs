using System.Globalization;

namespace AXOpen.Core;

public sealed record FlatAxoStepItem(
    AxoSequencerContainer Sequence,
    AxoStep Step)
{
    private bool _suspendStepBeforeExecution = (eAxoStepExecutionMode)Step.StepExecutionMode.LastValue == eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep;
    private bool _suspendStepAfterExecution = (eAxoStepExecutionMode)Step.StepExecutionMode.LastValue == eAxoStepExecutionMode.SwitchToStepModeAfterLeavingStep;

    public ulong Order => Step.Order.LastValue;

    public string Symbol => Step.Symbol ?? string.Empty;

    public string Desc => Step.Descr.GetCyclic(CultureInfo.CurrentUICulture) ?? string.Empty;

    public bool SuspendStepAfterExecution
    {
        get => _suspendStepAfterExecution;
        set
        {
            _suspendStepAfterExecution = value;

            if (value)
            {
                _suspendStepBeforeExecution = false;
            }

            if (value)
            {
                Step.StepExecutionMode.Cyclic = (short)eAxoStepExecutionMode.SwitchToStepModeAfterLeavingStep;
            }
        }
    }

    public bool SuspendStepBeforeExecution
    {
        get => _suspendStepBeforeExecution;
        set
        {
            _suspendStepBeforeExecution = value;

            if (value)
            {
                _suspendStepAfterExecution = false;
            }

            if (value)
            {
                Step.StepExecutionMode.Cyclic = (short)eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep;
            }
        }
    }

    public eAxoStepExecutionMode StepExecutionMode =>
        SuspendStepBeforeExecution
            ? eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep
            : SuspendStepAfterExecution
                ? eAxoStepExecutionMode.SwitchToStepModeAfterLeavingStep
            : RawStepExecutionMode;

    private eAxoStepExecutionMode RawStepExecutionMode => (eAxoStepExecutionMode)Step.StepExecutionMode.LastValue;
};
