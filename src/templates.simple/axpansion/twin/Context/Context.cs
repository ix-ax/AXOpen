using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using AXOpen.Data.InMemory;

namespace axosimple
{
    public class ContextService
    {
        private ContextService()
        {
            
        }

        private axosimple.Context Context { get; } = Entry.Plc.Context;

        public axosimple.ProcessData ProcessData { get; } = Entry.Plc.Context.ProcessData.CreateBuilder<axosimple.ProcessData>();

        public IRepository<Pocos.axosimple.SharedProductionData> SharedProcessDataRepository { get; private set; }

        public static ContextService Create()
        {
            var retVal = new ContextService();
            return retVal;
        }

        public void SetContextData(IRepository<Pocos.axosimple.SharedProductionData> repository)
        {
            SharedProcessDataRepository = repository;
            ProcessData.Shared.InitializeRemoteDataExchange(repository);

            ProcessData.InitializeRemoteDataExchange();
        }
    }
}
