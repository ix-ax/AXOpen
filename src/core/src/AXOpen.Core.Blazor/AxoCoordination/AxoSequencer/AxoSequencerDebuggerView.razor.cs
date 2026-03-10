using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using BlazorContextMenu;
using Microsoft.AspNetCore.Components;
using System.Linq;
using System.Threading.Tasks;

namespace AXOpen.Core;

public partial class AxoSequencerDebuggerView : RenderableComplexComponentBase<AxoSequencer>
{
	private readonly AxoSequencerStepsCollector _collector = new();

	[Parameter]
	public string? Class { get; set; }



	protected IReadOnlyList<FlatAxoStepItem> Steps { get; private set; } = Array.Empty<FlatAxoStepItem>();

	private bool ShowCurrentStepRunButtons =>
		Component.CurrentStep is not null
		&& Component.CurrentStep.StepExecutionMode.LastValue != (short)eAxoStepExecutionMode.ExecuteAndContinue;

	protected override async Task OnAfterRenderAsync(bool firstRender)
	{
		if (!firstRender)
		{
			return;
		}

		Steps = await _collector.GetFlatSteps(
			Component.GetConnector(),
			Component,
			static (sequence, step) => new FlatAxoStepItem(sequence, step),
			static item => item.Order);
		StateHasChanged();
	}
    private eAxoSteppingMode _currentSteppingMode => (eAxoSteppingMode)this.Component.SteppingMode.LastValue;
    private string _currentStepDescription => string.IsNullOrEmpty(this.Component.CurrentStep.Descr.GetCyclic(Thread.CurrentThread.CurrentUICulture)) ? "-" : this.Component.CurrentStep.Descr.GetCyclic(Thread.CurrentThread.CurrentUICulture);
    public ulong CurrentStepOrder
    {
        get
        {
            ulong order = 0;
            if (this.Component.Status.LastValue == (int)eAxoTaskState.Busy)
            {
                order = (this.Component as AxoSequencer)?.CurrentStep.Order.GetCyclic() ?? default(ulong);
            }

            else
            {
                return order;
            }

            return order;
        }
    }

  
    public override void ConfigurePolling()
	{
		foreach (var step in Component.GetDescendants<AxoStep>())
		{
			StartPolling(step.Order, 1000);
            StartPolling(step.StepExecutionMode, 1000);
		}
        StartPolling(this.Component.SteppingMode, 500);
        StartPolling(this.Component.CurrentStep.Descr, 500);
		
    }

    protected async Task ApplyBreakpointConfigurationAsync()
	{
		foreach (var item in Steps)
		{
            if (item.BreakpointBeforeExecution)
			{
				await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep);
			}
            else if (item.BreakpointAfterExecution)
			{
				await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.SwitchToStepModeAfterLeavingStep);
			}
			else
			{
				if (item.Step.StepExecutionMode.LastValue !=(short)eAxoStepExecutionMode.ExecuteAndContinue)
                    await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.ExecuteAndContinue);
			}
		}

		StateHasChanged();
	}

    protected async Task ClearBreakpointMarks()
    {
        foreach (var item in Steps)
        {
            item.BreakpointBeforeExecution = false;
            item.BreakpointAfterExecution = false;
        }

        await ApplyBreakpointConfigurationAsync();
        StateHasChanged();
    }

	protected async Task RunOnlyAsync()
	{
        await RunCurrentStepAsync(removeBreakpointForCurrentStep: false);
	}

    protected async Task RunAndRemoveBreakpointAsync()
	{
        await RunCurrentStepAsync(removeBreakpointForCurrentStep: true);
	}


    private async Task RunCurrentStepAsync(bool removeBreakpointForCurrentStep)
    {
        if (Component.CurrentStep is null)
        {
            return;
        }
        FlatAxoStepItem item;

       

        item = Steps.FirstOrDefault(step => step.Order == CurrentStepOrder);
        if (item is not null)
        {
            await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.ExecuteAndContinue);
        }
       

        await this.Component.SetReqSteppingMode.SetAsync(true);
        await this.Component.ReqSteppingMode.SetAsync((short)eAxoSteppingMode.Continous);

        if (removeBreakpointForCurrentStep)
        {
           
            if (item is not null)
            {
                item.BreakpointBeforeExecution = false;
                item.BreakpointAfterExecution = false;
                await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.ExecuteAndContinue);
            }
        }
        else
        {
           
            if (item.BreakpointBeforeExecution)
                await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep);
            else if (item.BreakpointAfterExecution)
                await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.SwitchToStepModeAfterLeavingStep);

        }
        StateHasChanged();
    }

    private static string GetBeforeBreakpointDotClass(FlatAxoStepItem item)
    {
        return item.StepExecutionMode == eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep
            ? "breakpoint-dot-applied"
            : string.Empty;
    }

    private static string GetAfterBreakpointDotClass(FlatAxoStepItem item)
    {
        return item.StepExecutionMode == eAxoStepExecutionMode.SwitchToStepModeAfterLeavingStep
            ? "breakpoint-dot-applied"
            : string.Empty;
    }

    private string GetCurrentStepDotClass(FlatAxoStepItem item, bool isChecked)
    {
        return isChecked && item.Order == CurrentStepOrder
            ? "breakpoint-dot-current"
            : string.Empty;
    }

    private string GetCurrentStepRowClass(FlatAxoStepItem item)
    {
        return item.Order == CurrentStepOrder
            ? "current-step-row"
            : string.Empty;
    }

  
}
