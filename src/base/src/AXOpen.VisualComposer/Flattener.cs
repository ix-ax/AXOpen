using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.VisualComposer
{
    internal static class Flattener
    {
        /// <summary>
        /// Flattens any IEnumerable.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="e"></param>
        /// <param name="f"></param>
        /// <returns></returns>
        public static IEnumerable<T> Flatten<T>(
            this IEnumerable<T> e
            , Func<T, IEnumerable<T>> f
        ) => e.SelectMany(c => f(c).Flatten(f)).Concat(e);
    }
}