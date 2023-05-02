using AXOpen.Base.Data;
using Raven.Client.Documents;

namespace AXOpen.Data.RavenDb
{
    public class RavenDbRepositorySettingsBase<T> : RepositorySettings where T : IBrowsableDataObject
    {
        public IDocumentStore Store { get; set; }
    }
}
