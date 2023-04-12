using Ix.Base.Data;
using AXOpen.Data;

namespace AXOpen.Data.InMemory
{
    public static class Repository
    {
        public static IRepository<T> Factory<T>(this InMemoryRepositorySettings<T> parameters) where T : IBrowsableDataObject
        {
            return new InMemoryRepository<T>(parameters);
        }
    }
}
