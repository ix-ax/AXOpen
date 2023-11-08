using AXSharp.Connector;

namespace AXOpen.VisualComposer
{
    public static class Flattener
    {
        public static IEnumerable<T> Flatten<T>(
            this IEnumerable<T> e
            , Func<T, IEnumerable<T>> f
        ) => e.SelectMany(c => f(c).Flatten(f)).Concat(e);
    }
}
