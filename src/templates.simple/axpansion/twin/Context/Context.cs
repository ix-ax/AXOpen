using AXOpen.Base.Data;

namespace axosimple
{
    public class ContextService
    {
        private ContextService()
        {
        }

        private axosimple.Context Context { get; } = Entry.Plc.Context;

        public axosimple.ProcessData ProcessData { get; } = Entry.Plc.Context.ProcessData.CreateBuilder<axosimple.ProcessData>();
        public axosimple.ProcessData ProcessSettings { get; } = Entry.Plc.Context.ProcessSettings.CreateBuilder<axosimple.ProcessData>();
        public axosimple.TechnologyData TechnologySettings { get; } = Entry.Plc.Context.TechnologySettings.CreateBuilder<axosimple.TechnologyData>();


        /// <summary>
        /// repository - settings connected with specific recepie
        /// </summary>
        public IRepository<Pocos.axosimple.TechnologyCommonData> TechnologyCommonRepository { get; private set; }

        /// <summary>
        /// repository - settings connected with specific recepie
        /// </summary>
        public IRepository<Pocos.axosimple.EntityData> EntitySettingsRepository { get; private set; }

        /// <summary>
        /// repository - data connected with specific part or piece in production/technology
        /// </summary>
        public IRepository<Pocos.axosimple.EntityData> EntityDataRepository { get; private set; }

        public static ContextService Create()
        {
            var retVal = new ContextService();
            return retVal;
        }

        public void SetContextData(
            IRepository<Pocos.axosimple.TechnologyCommonData> technologyCommonRepository,
            IRepository<Pocos.axosimple.EntityData> entitySettingsRepository,
            IRepository<Pocos.axosimple.EntityData> entityDataRepository
            )
        {
            this.EntitySettingsRepository = entitySettingsRepository;
            ProcessSettings.Entity.InitializeRemoteDataExchange(this.EntitySettingsRepository);
            ProcessSettings.InitializeRemoteDataExchange();

            this.EntityDataRepository = entityDataRepository;
            ProcessData.Entity.InitializeRemoteDataExchange(this.EntityDataRepository);
            ProcessData.InitializeRemoteDataExchange();

            this.TechnologyCommonRepository = technologyCommonRepository;
            TechnologySettings.Common.InitializeRemoteDataExchange(this.TechnologyCommonRepository);
            TechnologySettings.InitializeRemoteDataExchange();
        }
    }
}