using AXOpen.Base.Data;
using AXOpen.Data;
using AXSharp.Connector;
using System.Linq.Expressions;
using System.Text;
using ClosedXML.Excel;

namespace axosimple.hmi.CustomExport;

public class ExcelDataExporter<TPlain, TOnline> : BaseDataExporter<TPlain, TOnline>, IDataExporter<TPlain, TOnline> where TOnline : IAxoDataEntity
where TPlain : Pocos.AXOpen.Data.IAxoDataEntity, new()
{
    public XLWorkbook? Workbook;
    public string FileName = "Export";

    /// <summary>
    /// Opens a workbook if it exists in <c>directory</c> folder, otherwise creates a new one.
    /// </summary>
    /// <param name="directory">Folder directory</param>
    /// <returns></returns>
    public XLWorkbook GetXLWorkbook(string directory)
    {
        XLWorkbook workbook;

        if (File.Exists(directory + "\\" + FileName + ".xlsx"))
        {
            workbook = new XLWorkbook(directory + "\\" + FileName + ".xlsx");
        }
        else
        {
            workbook = new XLWorkbook();
            workbook.Properties.Status = "Created";
        }

        return workbook;
    }
    /// <summary>
    /// Saves the workbook in <c>directory</c> folder.
    /// </summary>
    /// <param name="directory">Folder directory</param>
    public void SaveXLWorkbook(string directory)
    {
        if (Workbook.Properties.Status != "Created")
        {
            Workbook.Save();
            return;
        }

        // reset status (it was temporarily set to identify the workbook as newly created)
        Workbook.Properties.Status = null;
        Workbook.SaveAs(directory + "\\" + FileName + ".xlsx");
    }

    /// <summary>
    /// Splits path of temporary file into directory and fragment.
    /// </summary>
    /// <param name="directory">Dictionary path</param>
    /// <param name="fragment">Name of fragment</param>
    /// <param name="path">Full path</param>
    private void GetDirectoryFragment(out string directory, out string fragment, string path)
    {
        var pathParts = path.Split('\\');
        directory = string.Join('\\', pathParts.Take(pathParts.Length - 1));
        fragment = pathParts.Last();
    }

    /// <summary>
    /// Trims the worksheet name to 31 characters because of Excel sheet name length limit.
    /// </summary>
    /// <param name="name">Desired sheet name</param>
    /// <returns>Valid sheet name</returns>
    private string TrimWorksheetName(string name)
    {
        var length = name.Length;

        if (length <= 31)
            return name;

        var nameParts = name.Split('.');
        var lastPart = nameParts.Last();
        if (lastPart.Length <= 31)
            return lastPart;

        return name.Substring(0, 14) + "..." + name.Substring(length - 14);
    }

    public ExcelDataExporter()
    {
    }

    public void Export(IRepository<TPlain> repository, string path, Expression<Func<TPlain, bool>> expression, Dictionary<string, bool>? customExportData = null, eExportMode exportMode = eExportMode.First, int firstNumber = 50, int secondNumber = 100, char separator = ';')
    {
        var prototype = Activator.CreateInstance(typeof(TOnline), new object[] { ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(new object[] { }), "_data", "_data" }) as ITwinObject;

        customExportData ??= new Dictionary<string, bool>();

        // Get exportables in range
        IQueryable<TPlain> exportables = null;
        switch (exportMode)
        {
            case eExportMode.First:
                exportables = repository.Queryable.Where(expression).Take(firstNumber);
                break;
            case eExportMode.Last:
                exportables = repository.Queryable.Where(expression).TakeLast(firstNumber);
                break;
            case eExportMode.Exact:
                exportables = repository.Queryable.Where(expression).Skip(firstNumber - 1).Take(secondNumber - firstNumber + 1);
                break;
        }

        string directory, fragment;
        GetDirectoryFragment(out directory, out fragment, path);

        Workbook = GetXLWorkbook(directory);
        Workbook.AddWorksheet(TrimWorksheetName(fragment));

        var itemExport = new StringBuilder();

        //Create header
        //var valueTags = prototype.RetrievePrimitives();
        //foreach (var valueTag in valueTags)
        //{
        //    bool skip = false;

        //    int lastIndex = valueTag.Symbol.Length;
        //    while (lastIndex != -1)
        //    {
        //        string currentString = valueTag.Symbol.Substring(0, lastIndex);

        //        if (!customExportData.GetValueOrDefault(currentString, true))
        //        {
        //            skip = true;
        //            break;
        //        }

        //        lastIndex = currentString.LastIndexOf('.');
        //    }
        //    if (skip)
        //        continue;

        //    itemExport.Append($"{valueTag.Symbol}{separator}");
        //}

        ////export.Add(itemExport.ToString());
        ////itemExport.AppendLine();

        ////itemExport.Clear();
        ////foreach (var valueTag in valueTags)
        ////{
        ////    bool skip = false;

        ////    int lastIndex = valueTag.Symbol.Length;
        ////    while (lastIndex != -1)
        ////    {
        ////        string currentString = valueTag.Symbol.Substring(0, lastIndex);

        ////        if (!customExportData.GetValueOrDefault(currentString, true))
        ////        {
        ////            skip = true;
        ////            break;
        ////        }

        ////        lastIndex = currentString.LastIndexOf('.');
        ////    }
        ////    if (skip)
        ////        continue;

        ////    itemExport.Append($"{valueTag.HumanReadable}{separator}");
        ////}

        ////export.Add(itemExport.ToString());
        ////itemExport.AppendLine();


        ////foreach (var document in exportables)
        ////{
        ////    itemExport.Clear();
        ////    ((dynamic)prototype).PlainToShadow(document);
        ////    var values = prototype.RetrievePrimitives();
        ////    foreach (var @value in values)
        ////    {
        ////        bool skip = false;

        ////        int lastIndex = @value.Symbol.Length;
        ////        while (lastIndex != -1)
        ////        {
        ////            string currentString = @value.Symbol.Substring(0, lastIndex);

        ////            if (!customExportData.GetValueOrDefault(currentString, true))
        ////            {
        ////                skip = true;
        ////                break;
        ////            }

        ////            lastIndex = currentString.LastIndexOf('.');
        ////        }
        ////        if (skip)
        ////            continue;

        ////        var val = (string)(((dynamic)@value).Shadow.ToString());
        ////        if (val.Contains(separator))
        ////        {
        ////            val = val.Replace(separator, '►');
        ////        }

        ////        itemExport.Append($"{val}{separator}");
        ////    }

        ////    export.Add(itemExport.ToString());

        ////}

        ////return export;

        SaveXLWorkbook(directory);
    }

    public void Import(IRepository<TPlain> dataRepository, string path, ITwinObject crudDataObject = null, char separator = ';')
    {
        var imports = new List<string>();
        foreach (var item in File.ReadAllLines(path + ".csv"))
        {
            imports.Add(item);
        }

        BaseImport(dataRepository, imports, crudDataObject, separator);
    }

    public static string GetName()
    {
        return "Excel";
    }
}
