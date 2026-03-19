
namespace AXOpen.Data.Interfaces
{
    public interface IDistributedDataActions
    {
        public Task Delete( string identifier);
        public Task Copy(string identifier, string newIdentifier);
        public Task Create(string identifier);
        public Task CreateNewFromPlc(string identifier);
        //public Task UpdateFromPlc(string identifier);
        public Task SendToPlc(string identifier);

        public bool EnableExternalEntityIds { get; }
        public bool EnableLocalConcatEntityIds { get; }
        public int LocalConcatEntityIdsCount { get; }
        public void SetLocalExchangeConcatIds( List<string> entityIdsToInject);
        public void ResetLocalExchangeConcatIds( );

    }


}
