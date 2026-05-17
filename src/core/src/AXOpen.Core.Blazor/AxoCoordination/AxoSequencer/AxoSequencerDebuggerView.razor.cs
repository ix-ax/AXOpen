using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using BlazorContextMenu;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using System.Linq;
using System.Threading.Tasks;

namespace AXOpen.Core;

public partial class AxoSequencerDebuggerView : RenderableComplexComponentBase<AxoSequencer>
{
    private readonly AxoSequencerStepsCollector _collector = new();
    private readonly HashSet<ulong> _monitoredStepOrders = new();
    private bool _isMonitoredStepsLoaded;

    [Parameter]
    public string? Class { get; set; }

    [Inject]
    private IJSRuntime JSRuntime { get; set; } = default!;



    protected IReadOnlyList<FlatAxoStepItem> Steps { get; private set; } = Array.Empty<FlatAxoStepItem>();

    private string MonitoredStepsStorageKey => $"axo-sequencer-monitored-steps:{Component.Symbol}";

    private IEnumerable<FlatAxoStepItem> MonitoredSteps =>
        Steps.Where(step => _monitoredStepOrders.Contains(step.Order));

    private bool ShowCurrentStepRunButtons =>
        Component.CurrentStep is not null
        //&& Component.CurrentStep.StepExecutionMode.LastValue != (short)eAxoStepExecutionMode.ExecuteAndContinue
            && Component.CurrentStep.Status.LastValue == (short)eAxoTaskState.Ready;

    private bool ShowCurrentStepRunning =>
        Component.CurrentStep is not null
        && Component.CurrentStep.Status.LastValue == (short)eAxoTaskState.Busy;

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

        if (!_isMonitoredStepsLoaded)
        {
            _isMonitoredStepsLoaded = await TryLoadMonitoredStepsAsync();
        }

        StateHasChanged();
    }
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
            StartPolling(step.Order, 500);
            StartPolling(step.StepExecutionMode, 500);
        }
        StartPolling(this.Component.SteppingMode, 500);
        StartPolling(this.Component.CurrentStep.Status, 500);
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

            else
            {
                if (item.Step.StepExecutionMode.LastValue != (short)eAxoStepExecutionMode.ExecuteAndContinue)
                    await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.ExecuteAndContinue);
            }
        }

        StateHasChanged();
    }

    private async Task ToggleBreakpointAsync(FlatAxoStepItem item, ChangeEventArgs args)
    {
        var isChecked = args.Value switch
        {
            bool value => value,
            string value => string.Equals(value, "true", StringComparison.OrdinalIgnoreCase),
            _ => false
        };

        item.BreakpointBeforeExecution = isChecked;

        if (!isChecked)
        {
            if (item.Step.StepExecutionMode.LastValue != (short)eAxoStepExecutionMode.ExecuteAndContinue)
            { 
                await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.ExecuteAndContinue);

                //await this.Component.SetReqSteppingMode.SetAsync(true);
                //await this.Component.ReqSteppingMode.SetAsync((short)eAxoSteppingMode.Continous);
            }
        }

        StateHasChanged();
    }

    protected async Task ClearAllBreakpointsAsync()
    {
        foreach (var item in Steps)
        {
            item.BreakpointBeforeExecution = false;

        }

        await ApplyBreakpointConfigurationAsync();
        await this.Component.SetReqSteppingMode.SetAsync(true);
        await this.Component.ReqSteppingMode.SetAsync((short)eAxoSteppingMode.Continous);
        StateHasChanged();
    }

    protected async Task RunAsync()
    {
        await RunCurrentStepAsync(removeBreakpointForCurrentStep: false);
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
                await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.ExecuteAndContinue);
            }
        }
        else
        {

            if (item.BreakpointBeforeExecution)
                await item.Step.StepExecutionMode.SetAsync((short)eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep);


        }
        StateHasChanged();
    }

    private static string GetBeforeBreakpointDotClass(FlatAxoStepItem item)
    {
        return item.StepExecutionMode == eAxoStepExecutionMode.SwitchToStepModeBeforeEnteringStep
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


    private async Task AddToMonitor(FlatAxoStepItem item)
    {
        _monitoredStepOrders.Add(item.Order);
        await SaveMonitoredStepsAsync();
        StateHasChanged();
    }

    private async Task RemoveFromMonitor(FlatAxoStepItem item)
    {
        _monitoredStepOrders.Remove(item.Order);
        await SaveMonitoredStepsAsync();
        StateHasChanged();
    }

    private bool IsMonitored(FlatAxoStepItem item)
    {
        return _monitoredStepOrders.Contains(item.Order);
    }

    private async Task<bool> TryLoadMonitoredStepsAsync()
    {
        try
        {
            var storedOrders = await JSRuntime.InvokeAsync<string?>("localStorage.getItem", MonitoredStepsStorageKey);
            if (string.IsNullOrWhiteSpace(storedOrders))
            {
                return true;
            }

            _monitoredStepOrders.Clear();
            foreach (var value in storedOrders.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                if (ulong.TryParse(value, out var parsedOrder))
                {
                    _monitoredStepOrders.Add(parsedOrder);
                }
            }

            return true;
        }
        catch (InvalidOperationException)
        {
            return false;
        }
        catch (JSDisconnectedException)
        {
            return false;
        }
    }

    private async Task SaveMonitoredStepsAsync()
    {
        var storedOrders = string.Join(',', _monitoredStepOrders.OrderBy(order => order));
        await JSRuntime.InvokeVoidAsync("localStorage.setItem", MonitoredStepsStorageKey, storedOrders);
    }

    private string GetStepStatusBadgeClass(FlatAxoStepItem item)
    {
        if (item.Order != CurrentStepOrder) return string.Empty;
        var status = Component.CurrentStep.Status.LastValue;
        if (status == (short)eAxoTaskState.Ready) return "badge badge-success";
        if (status == (short)eAxoTaskState.Kicking) return "badge badge-info";
        if (status == (short)eAxoTaskState.Busy) return "badge badge-primary";
        if (status == (short)eAxoTaskState.Done) return "badge badge-success";
        if (status == (short)eAxoTaskState.Aborted) return "badge badge-warning";
        if (status == (short)eAxoTaskState.Error) return "badge badge-danger";
        return string.Empty;
    }

    private string GetStepStatusLabel(FlatAxoStepItem item)
    {
        if (item.Order != CurrentStepOrder) return string.Empty;
        var status = Component.CurrentStep.Status.LastValue;
        if (status == (short)eAxoTaskState.Ready) return Localizer["SequencerTaskStateReady"];
        if (status == (short)eAxoTaskState.Kicking) return Localizer["SequencerTaskStateKicking"];
        if (status == (short)eAxoTaskState.Busy) return Localizer["SequencerTaskStateBusy"];
        if (status == (short)eAxoTaskState.Done) return Localizer["SequencerTaskStateDone"];
        if (status == (short)eAxoTaskState.Aborted) return Localizer["SequencerTaskStateAborted"];
        if (status == (short)eAxoTaskState.Error) return Localizer["SequencerTaskStateError"];
        return string.Empty;
    }


}
