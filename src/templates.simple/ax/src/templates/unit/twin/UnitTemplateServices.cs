using AXOpen.Base.Data;
using axosimple;
namespace axosimple.server.Units
{
    public class UnitTemplateServices    
    {
        private UnitTemplateServices(ContextService contextService)
        {
            _contextService = contextService;
        }

        private UnitTemplate.Unit Unit { get; } = Entry.Plc.Context.UnitTemplate;
        private UnitTemplate.ProcessDataManager UnitData { get; } = 
            Entry.Plc.Context.UnitTemplateProcessData.CreateBuilder<UnitTemplate.ProcessDataManager>();
        
        private ContextService _contextService { get; }
        

        public static UnitTemplateServices Create(ContextService contextService)
        {
            var retVal = new UnitTemplateServices(contextService);
            return retVal;
        }

        public void SetUnitsData(IRepository<Pocos.axosimple.UnitTemplate.ProcessData> repository)
        {
            UnitData.Shared.InitializeRemoteDataExchange(_contextService.EntityDataRepository);
            _contextService.ProcessData.UnitTemplate.InitializeRemoteDataExchange(repository);
            
            UnitData.DataManger.InitializeRemoteDataExchange(repository);

            UnitData.InitializeRemoteDataExchange();
        }
    }
}
