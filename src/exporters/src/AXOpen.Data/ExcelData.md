# **Exporting data to Excel**

## **Overview**

-   Data is transported to **.xlsx** format.
-   There is one file (workbook) generated with the name defined by the `fileName` variable in `ExcelDataExporter.cs` class.
-   Each fragment is represented by a worksheet in the file.
-   `Export` function does not call the `BaseExport` method of `BaseDataExporter` class but works in pretty much the same way with the exception of exporting data to Excel workbook.
-   `Import` analogically does not call the `BaseImport` method of `BaseDataExporter`. IHowever, its functionality is almost identical to `BaseImport`. It calls `UpdateDocument` method of `BaseDataExporter` which has had its accessibility changed to `protected`. Additionally, the accessibility of the `ImportItems` method has been changed to `protected`, and its members have been changed to `public` so that they can be accessed from the `Import` method of the `ExcelDataExporter` class.

## **Prerequisites**

_ClosedXML_ NuGet package - MIT license

## **Working with ClosedXML**

-   Before export and import a workbook of type `XLWorkbook` needs to be initialized. It can be done be creating a completely new workbook or by loading an existing one.
-   A workbook must have at least one worksheet

## **Limitations of _.xlsx_**

-   A name of a worksheet cannot be longer than **31 characters**.
-   A name of a worksheet must be **unique** within a workbook.

See [Excel specifications and limits](https://support.microsoft.com/en-gb/office/excel-specifications-and-limits-1672b34d-7043-467e-8e27-269d656771c3) for more information.
