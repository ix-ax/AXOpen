namespace AXOpen.Data
{
    using System.Linq;

    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field)]
    public class PersistentAttribute
    : Attribute
    {
        /// <summary>
        ///     Creates new instance of <see cref="PersistentAttribute" />
        /// </summary>
        public PersistentAttribute(params string[] groups)
        {
            var filterGroup = groups.Where(x => !string.IsNullOrEmpty(x) ).ToArray();

            if (filterGroup == null)
                Groups = new string[1] { "default" };
            else
            {
                if (filterGroup.Length == 0)
                {
                    Groups = new string[1] { "default" };
                }
                else
                {
                    Groups = filterGroup;

                }
            }
        }

        /// <summary>
        ///     List of persistent groups on that it will be saved.
        /// </summary>
        public IEnumerable<string> Groups { get; }
    }
}