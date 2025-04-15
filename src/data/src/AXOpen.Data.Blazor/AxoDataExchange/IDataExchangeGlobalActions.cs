
namespace AXOpen.Data.Interfaces
{
    public interface IDataExchangeGlobalActions
    {
        public Task Delete( string identifier);
        public Task Copy(string identifier, string newIdentifier);
        public Task Create(string identifier);
        public Task CreateNewFromPlc(string identifier);
        //public Task UpdateFromPlc(string identifier);
        public Task SendToPlc(string identifier);
    }

}