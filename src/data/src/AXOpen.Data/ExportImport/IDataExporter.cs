using AXOpen.Base.Data;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Data
{
    public interface IDataExporter<TPlain, TOnline> where TOnline : IAxoDataEntity
    where TPlain : Pocos.AXOpen.Data.IAxoDataEntity
    {
        void Export(IRepository<TPlain> repository, string path, Expression<Func<TPlain, bool>> expression, char separator = ';');
        void Import(IRepository<TPlain> dataRepository, string path, ITwinObject crudDataObject = null, char separator = ';');
    }    
}
