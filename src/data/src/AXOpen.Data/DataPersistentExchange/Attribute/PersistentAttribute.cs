namespace AXOpen.Data
{
    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field)]
    public class PersistentAttribute
    : Attribute
    {
        /// <summary>
        ///     Creates new instance of <see cref="PersistentAttribute" />
        /// </summary>
        public PersistentAttribute(params string[] groups)
        {
            if (groups == null)
                Groups = new string[1] { "default" };
            else
            {
                if (groups.Length == 0)
                {
                    Groups = new string[1] { "default" };
                }
                else
                {
                    Groups = groups;

                }
            }
        }

        /// <summary>
        ///     List of persistent groups on that it will be saved.
        /// </summary>
        public IEnumerable<string> Groups { get; }
    }
}