using System.Globalization;

namespace AXOpen.Core;

public sealed record FlatAxoStepItem(
    AxoSequencerContainer Sequence,
    AxoStep Step)
{
    private bool _suspendStepBeforeExecution = (eAxoStepExecutionMode)Step.StepExecutionMode.LastValue == eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep;
       public ulong Order => Step.Order.LastValue;

    public string Symbol => Step.Symbol ?? string.Empty;

    public string Desc => Step.Descr.GetCyclic(CultureInfo.CurrentUICulture) ?? string.Empty;

  

    public bool SuspendStepBeforeExecution
    {
        get => _suspendStepBeforeExecution;
        set
        {
            _suspendStepBeforeExecution = value;

        
            if (value)
            {
                Step.StepExecutionMode.Cyclic = (short)eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep;
            }
        }
    }

    public eAxoStepExecutionMode StepExecutionMode =>
        SuspendStepBeforeExecution
            ? eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep
               : RawStepExecutionMode;

    private eAxoStepExecutionMode RawStepExecutionMode => (eAxoStepExecutionMode)Step.StepExecutionMode.LastValue;
};
