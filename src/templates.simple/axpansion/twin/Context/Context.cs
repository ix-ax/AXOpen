using AXOpen.Base.Data;
using axosimple.server.Units;

namespace axosimple
{
    public class ContextService
    {
        
        private static readonly Lazy<ContextService> lazy = new(() => new ContextService());

        public static ContextService Instance => lazy.Value;
        
        private ContextService()
        {
            StarterUnitTemplateServices = StarterUnitTemplateServices.Create(this);
            UnitTemplateServices = UnitTemplateServices.Create(this);
        }

        private axosimple.Context Context { get; } = Entry.Plc.Context;

        public StarterUnitTemplateServices StarterUnitTemplateServices { get; }

        public UnitTemplateServices UnitTemplateServices { get; }

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
        
        public ContextService SetContextData(
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

            return this;
        }
    }
}