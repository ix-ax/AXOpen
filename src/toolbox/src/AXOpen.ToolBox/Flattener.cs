namespace AXOpen.ToolBox.Extensions
{
    
    public static class Flattener
    {
       /// <summary>
       /// Flattens any IEnumerable.
       /// </summary>
       /// <typeparam name="T"></typeparam>
       /// <param name="e"></param>
       /// <param name="f"></param>
       /// <param name="maxDepth">Optional maximum depth for flattening. Defaults to no limit.</param>
       /// <returns></returns>
        public static IEnumerable<T> Flatten<T>(
            this IEnumerable<T> e
            , Func<T, IEnumerable<T>> f
            , int maxDepth = int.MaxValue
        ) => FlattenCore(e, f, maxDepth, 0);

        private static IEnumerable<T> FlattenCore<T>(
            IEnumerable<T> e
            , Func<T, IEnumerable<T>> f
            , int maxDepth
            , int depth
        ) => depth < maxDepth 
            ? e.SelectMany(c => FlattenCore(f(c), f, maxDepth, depth + 1)).Concat(e)
            : e;
    }
}