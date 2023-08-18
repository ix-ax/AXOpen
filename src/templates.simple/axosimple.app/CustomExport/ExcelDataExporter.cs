using AXOpen.Base.Data;
using AXOpen.Data;
using AXSharp.Connector;
using System.Linq.Expressions;
using System.Text;
using ClosedXML.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.CSharp.RuntimeBinder;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components.Authorization;

namespace axosimple.hmi.CustomExport;

public class ExcelDataExporter<TPlain, TOnline> : BaseDataExporter<TPlain, TOnline>, IDataExporter<TPlain, TOnline> where TOnline : IAxoDataEntity
where TPlain : Pocos.AXOpen.Data.IAxoDataEntity, new()
{
    private string fileName = "Export";

    /// <summary>
    /// Opens a workbook if it exists in <c>directory</c> folder, otherwise creates a new one.
    /// </summary>
    /// <param name="directory">Folder directory</param>
    /// <returns></returns>
    private XLWorkbook GetXLWorkbook(string directory)
    {
        XLWorkbook workbook;

        if (File.Exists(directory + "\\" + fileName + ".xlsx"))
        {
            workbook = new XLWorkbook(directory + "\\" + fileName + ".xlsx");
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
    /// <param name="workbook">Workbook to save</param>
    /// <param name="directory">Folder directory</param>
    private void SaveXLWorkbook(XLWorkbook workbook, string directory)
    {
        if (workbook.Properties.Status != "Created")
        {
            workbook.Save();
            return;
        }

        // reset status (it was temporarily set to identify the workbook as newly created)
        workbook.Properties.Status = null;
        workbook.SaveAs(directory + "\\" + fileName + ".xlsx");
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

    private void StyleWorksheet(IXLWorksheet ws)
    {
        ws.Row(1).Style.Font.Bold = true;
        ws.Row(1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
        ws.Row(2).Style.Font.Bold = true;
        ws.Row(2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
        ws.Columns().AdjustToContents();
    }

    public ExcelDataExporter()
    {
    }

    public void Export(IRepository<TPlain> dataRepository, string path, string fragmentName, Expression<Func<TPlain, bool>> expression, Dictionary<string, bool>? customExportData = null, eExportMode exportMode = eExportMode.First, int firstNumber = 50, int secondNumber = 100, char separator = ';')
    {
        var prototype = Activator.CreateInstance(typeof(TOnline), new object[] { ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(new object[] { }), "_data", "_data" }) as ITwinObject;

        customExportData ??= new Dictionary<string, bool>();

        // Get exportables in range
        IQueryable<TPlain> exportables = null;
        switch (exportMode)
        {
            case eExportMode.First:
                exportables = dataRepository.Queryable.Where(expression).Take(firstNumber);
                break;
            case eExportMode.Last:
                exportables = dataRepository.Queryable.Where(expression).TakeLast(firstNumber);
                break;
            case eExportMode.Exact:
                exportables = dataRepository.Queryable.Where(expression).Skip(firstNumber - 1).Take(secondNumber - firstNumber + 1);
                break;
        }

        XLWorkbook workbook;
        int row = 1, column = 1;

        workbook = GetXLWorkbook(path);

        // create worksheet (1 per fragment) with unique name
        var worksheetName = TrimWorksheetName(fragmentName);

        var uniqNum = 0;
        // if worksheet with the same name already exists
        while (workbook.Worksheets.Any(ws => ws.Name == worksheetName))
        {
            worksheetName = TrimWorksheetName(fragmentName + uniqNum++.ToString());
        }

        var worksheet = workbook.Worksheets.Add(worksheetName);

        // Create header
        var valueTags = prototype.RetrievePrimitives();
        foreach (var valueTag in valueTags)
        {
            bool skip = false;

            int lastIndex = valueTag.Symbol.Length;
            while (lastIndex != -1)
            {
                string currentString = valueTag.Symbol.Substring(0, lastIndex);

                if (!customExportData.GetValueOrDefault(currentString, true))
                {
                    skip = true;
                    break;
                }

                lastIndex = currentString.LastIndexOf('.');
            }
            if (skip)
                continue;

            worksheet.Cell(row, column).Value = valueTag.Symbol;
            worksheet.Cell(row + 1, column).Value = valueTag.HumanReadable;
            column++;
        }

        // To skip valueTag.Symbol and valueTag.HumanReadable
        row += 2;
        column = 1;

        foreach (var document in exportables)
        {
            ((dynamic)prototype).PlainToShadow(document);
            var values = prototype.RetrievePrimitives();
            foreach (var @value in values)
            {
                bool skip = false;

                int lastIndex = @value.Symbol.Length;
                while (lastIndex != -1)
                {
                    string currentString = @value.Symbol.Substring(0, lastIndex);

                    if (!customExportData.GetValueOrDefault(currentString, true))
                    {
                        skip = true;
                        break;
                    }

                    lastIndex = currentString.LastIndexOf('.');
                }
                if (skip)
                    continue;

                worksheet.Cell(row, column).Value = ((dynamic)@value).Shadow.ToString();
                column++;
            }
            row++;
            column = 1;
        }

        StyleWorksheet(worksheet);
        SaveXLWorkbook(workbook, path);
    }

    public void Import(IRepository<TPlain> dataRepository, string path, string fragmentName, AuthenticationState authenticationState, ITwinObject crudDataObject = null, char separator = ';')
    {
        XLWorkbook workbook;

        // checks if excel file exists
        var files = Directory.GetFiles(path, "*.xlsx");
        if (files == null || files.Length == 0)
            return;

        // .First() because idk what should happen if there are 2 files for a fragment
        workbook = new XLWorkbook(files.First());

        // checks if worksheet for given fragment exists
        if (!workbook.Worksheets.Contains(fragmentName))
            return;

        var worksheet = workbook.Worksheet(fragmentName);
        var dictionary = new List<ImportItems>();

        ITwinObject prototype;
        if (crudDataObject == null)
            prototype = Activator.CreateInstance(typeof(TOnline), new object[] { ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(new object[] { }), "_data", "_data" }) as ITwinObject;
        else
            prototype = crudDataObject;

        var valueTags = prototype.RetrievePrimitives();

        var lastRow = worksheet.LastRowUsed().RowNumber();
        var headerItems = worksheet.Row(1).Cells().Select(c => c.Value.ToString()).ToArray();

        // Get headered dictionary
        foreach (var headerItem in headerItems)
        {
            dictionary.Add(new ImportItems() { Key = headerItem });
        }

        if (!dictionary.Exists(p => p.Key.Contains("DataEntityId")))
        {
            throw new Exception("DataEntityId is missing in the import file");
        }

        // Load values
        for (int row = 3; row <= lastRow; row++) // row = 3 to skip Symbol and HumanReadable rows
        {
            for (int a = 0; a < headerItems.Length; a++)
            {
                dictionary[a].Value = worksheet.Cell(row, a + 1).Value.ToString();
            }
            UpdateDocument(dataRepository, dictionary, valueTags, prototype, authenticationState, separator);
        }
    }

    public static string GetName()
    {
        return "Excel";
    }
}
