using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{
    public static class Extensions
    {

        /// <summary>
        /// Recursively collects descendants of the specified type from the given object.
        /// </summary>
        /// <typeparam name="T">The type of descendants to collect.</typeparam>
        /// <param name="obj">The starting object.</param>
        /// <param name="children">The list to which found descendants are added.</param>
        /// <returns>An enumerable of found descendants.</returns>
        public static IEnumerable<T> GetDescendants<T>(this ITwinObject obj, IList<T> children = null) where T : class
        {
            children = children ?? new List<T>();

            if (obj != null)
            {
                foreach (var child in obj.GetChildren())
                {
                    var ch = child as T;
                    if (ch != null)
                    {
                        children.Add(ch);
                    }

                    GetDescendants<T>(child, children);
                }
            }
            return children;
        }

    }

}
