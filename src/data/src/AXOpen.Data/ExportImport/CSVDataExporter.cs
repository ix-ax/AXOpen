using AXOpen.Base.Data;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using AXSharp.Connector.ValueTypes.Online;
using Microsoft.AspNetCore.Components.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;


namespace AXOpen.Data
{
    public class CSVDataExporter<TPlain, TOnline> : BaseDataExporter<TPlain, TOnline>, IDataExporter<TPlain, TOnline> where TOnline : IAxoDataEntity
    where TPlain : Pocos.AXOpen.Data.IAxoDataEntity, new()
    {
        public CSVDataExporter()
        {
        }

        public void Export(IRepository<TPlain> repository, string path, string fragmentName, Expression<Func<TPlain, bool>> expression, Dictionary<string, bool> customExportData = null, eExportMode exportMode = eExportMode.First, int firstNumber = 50, int secondNumber = 100, char separator = ';')
        {
            var export = BaseExport(repository, expression, customExportData, exportMode, firstNumber, secondNumber, separator);

            using (var sw = new StreamWriter(path + "\\" + fragmentName + ".csv"))
            {
                foreach (var item in export)
                {
                    sw.Write(item + "\r");
                }
            }
        }

        public void Import(IRepository<TPlain> dataRepository, string path, string fragmentName, AuthenticationState authenticationState, ITwinObject crudDataObject = null, char separator = ';')
        {
            var files = Directory.GetFiles(path, fragmentName + ".csv");
            if (files == null || files.Length == 0)
                return;

            var imports = new List<string>();
            foreach (var item in File.ReadAllLines(files.First()))
            {
                imports.Add(item);
            }

            BaseImport(dataRepository, imports, authenticationState, crudDataObject, separator);
        }

        public static string GetName()
        {
            return "CSV";
        }
    }
}
