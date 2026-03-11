using System.Globalization;

namespace AXOpen.Core;

public sealed record FlatAxoStepItem(
    AxoSequencerContainer Sequence,
    AxoStep Step)
{
    private bool _breakpointBeforeExecution = (eAxoStepExecutionMode)Step.StepExecutionMode.LastValue == eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep;
 
    public ulong Order => Step.Order.LastValue;

    public string Symbol => Step.Symbol ?? string.Empty;

    public string Desc => Step.Descr.GetCyclic(CultureInfo.CurrentUICulture) ?? string.Empty;

    

    public bool BreakpointBeforeExecution
    {
        get => _breakpointBeforeExecution;
        set
        {
            _breakpointBeforeExecution = value;

          

          
        }
    }

    public eAxoStepExecutionMode StepExecutionMode => RawStepExecutionMode;
        //BreakpointBeforeExecution
        //    ? eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep
        //    : BreakpointAfterExecution
        //        ? eAxoStepExecutionMode.SwitchToStepModeAfterLeavingStep
        //    : RawStepExecutionMode;

    private eAxoStepExecutionMode RawStepExecutionMode => (eAxoStepExecutionMode)Step.StepExecutionMode.LastValue;
};
