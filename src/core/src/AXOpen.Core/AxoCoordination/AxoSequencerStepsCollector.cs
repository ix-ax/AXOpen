using AXOpen.Core;
using AXSharp.Connector;
using System.ComponentModel;
using System.Threading.Tasks;

namespace AXOpen.Core;

public sealed class AxoSequencerStepsCollector
{

    public IReadOnlyList<TItem> GetStepsBySequence<TItem>(
        ITwinObject root,
        string sequenceSymbol,
        Func<AxoSequencerContainer, AxoStep, TItem> itemFactory,
        Func<TItem, ulong> orderSelector)
    {
        if (string.IsNullOrWhiteSpace(sequenceSymbol))
        {
            return Array.Empty<TItem>();
        }

        var sequence = Traverse(root)
            .OfType<AXOpen.Core.AxoSequencerContainer>()
            .FirstOrDefault(item => string.Equals(item.Symbol, sequenceSymbol, StringComparison.OrdinalIgnoreCase));

        if (sequence is null)
        {
            return Array.Empty<TItem>();
        }

        return GetStepsBySequence(sequence, itemFactory, orderSelector);
    }

    public IReadOnlyList<TItem> GetStepsBySequence<TItem>(
        AxoSequencerContainer sequence,
        Func<AxoSequencerContainer, AxoStep, TItem> itemFactory,
        Func<TItem, ulong> orderSelector)
    {
        var items = CollectStepsForSequence(sequence, knownSteps: null, itemFactory);

        return items
            .OrderBy(orderSelector)
            .ToArray();
    }

    public async Task<IReadOnlyList<TItem>> GetFlatSteps<TItem>(
        Connector connector,
        ITwinObject root,
        Func<AxoSequencerContainer, AxoStep, TItem> itemFactory,
        Func<TItem, ulong> orderSelector)
    {
        await connector.ReadBatchAsync(
            Traverse(root)
                .OfType<AXOpen.Core.AxoStep>()
                .SelectMany(step => new ITwinPrimitive[] { step.Descr, step.Order, step.StepExecutionMode }));

        var items = new List<TItem>();
        var knownSteps = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var sequence in Traverse(root).OfType<AXOpen.Core.AxoSequencerContainer>())
        {
            items.AddRange(CollectStepsForSequence(sequence, knownSteps, itemFactory));
        }

        return items
            .OrderBy(orderSelector)
            .ToArray();
    }

    private static IReadOnlyList<TItem> CollectStepsForSequence<TItem>(
        AXOpen.Core.AxoSequencerContainer sequence,
        HashSet<string>? knownSteps,
        Func<AxoSequencerContainer, AxoStep, TItem> itemFactory)
    {
        var items = new List<TItem>();

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
                items.Add(itemFactory(sequence, step));
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
