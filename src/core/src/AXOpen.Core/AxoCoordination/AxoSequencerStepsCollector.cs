using AXOpen.Core;
using AXSharp.Connector;
using System.ComponentModel;
using System.Globalization;
using System.Threading.Tasks;

namespace AXOpen.Core;

public sealed class AxoSequencerStepsCollector
{
    public IReadOnlyList<FlatAxoStepItem> GetStepsBySequence(ITwinObject root, string sequenceSymbol)
    {
        if (string.IsNullOrWhiteSpace(sequenceSymbol))
        {
            return Array.Empty<FlatAxoStepItem>();
        }

        var sequence = Traverse(root)
            .OfType<AXOpen.Core.AxoSequencerContainer>()
            .FirstOrDefault(item => string.Equals(item.Symbol, sequenceSymbol, StringComparison.OrdinalIgnoreCase));

        if (sequence is null)
        {
            return Array.Empty<FlatAxoStepItem>();
        }

        return GetStepsBySequence(sequence);
    }

    public IReadOnlyList<FlatAxoStepItem> GetStepsBySequence(AxoSequencerContainer sequence)
    {
        var items = CollectStepsForSequence(sequence, knownSteps: null);

        return items
            .OrderBy(item => item.Order)
            .ToArray();
    }

    public async Task<IReadOnlyList<FlatAxoStepItem>> GetFlatSteps(AXSharp.Connector.Connector connector, ITwinObject root)
    {
        await connector.ReadBatchAsync(
            Traverse(root)
                .OfType<AXOpen.Core.AxoStep>()
                .SelectMany(step => new ITwinPrimitive[] { step.Descr, step.Order, step.StepExecutionMode }));

        var items = new List<FlatAxoStepItem>();
        var knownSteps = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var sequence in Traverse(root).OfType<AXOpen.Core.AxoSequencerContainer>())
        {
            items.AddRange(CollectStepsForSequence(sequence, knownSteps));
        }

        return items
            .OrderBy(item => item.Order)
            .ToArray();
    }

    private static IReadOnlyList<FlatAxoStepItem> CollectStepsForSequence(
        AXOpen.Core.AxoSequencerContainer sequence,
        HashSet<string>? knownSteps)
    {
        var items = new List<FlatAxoStepItem>();

        foreach (var step in Traverse(sequence).OfType<AxoStep>())
        {
            if (string.IsNullOrWhiteSpace(step.Symbol))
            {
                continue;
            }

            if (knownSteps is not null && !knownSteps.Add(step.Symbol))
            {
                continue;
            }
            if (step.Order.LastValue!=0 && step.GetSymbolTail()!="CurrentStep")
            {
                items.Add(new FlatAxoStepItem(
               sequence,
               step));
            }
           
        }

        return items;
    }

    private static IEnumerable<ITwinObject> Traverse(ITwinObject root)
    {
        var visited = new HashSet<ITwinObject>();
        var stack = new Stack<ITwinObject>();
        stack.Push(root);

        while (stack.Count > 0)
        {
            var current = stack.Pop();
            if (!visited.Add(current))
            {
                continue;
            }

            yield return current;

            foreach (var child in current.GetChildren().OfType<ITwinObject>())
            {
                stack.Push(child);
            }
        }
    }
}

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
