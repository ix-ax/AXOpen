# AxoDataExchange

## Getting started

### Data exchange manager

For the data exchange to work, we must create a class extending the `AxoDataExchange`. 

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoData/AxoDataDocuExample.st?name=ProcessDataMangerDeclaration)]

### Data exchange object

We will also need to add our data entity variable, which contains the data that we want to exchange between PLC and the repository. This variable must be annotated with `AxoDataEntityAttribute` and   `#ix-generic:TOnline` and `#ix-generic:TPlain as POCO` attributes that provide type information for the data exchange.

> [!NOTE]
> `AxoDataEntityAttribute`, `#ix-generic:TOnline` and `#ix-generic:TPlain as POCO` must be attributed to only one member `AxoDataExchange` object and is used to locate data object that contains data to be exchanged between PLC and the target repository. 
An exception is thrown when `DataEntityAttribute` is missing or multiple members have the annotation. 


> [!NOTE]
> The 'Data' variable must be of a type that extends `AxoDataEntity`. 

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoData/AxoDataDocuExample.st?name=ProcessDataDeclaration)]

### Data exchange initialization in PLC

As mentioned earlier, we use remote calls to execute the CRUD operations. These calls are a variant of `AxoTask`, which allows for invoking a C# code. We will now need to create an instance of `AxoProcessDataManager` in a context object (`AxoContext`) (or as a member of another class that derives from `AxoObject`). We will also need to call `DataManager` in the Main method of appropriate context.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoData/AxoDataDocuExample.st?name=ContextDeclaration)]

Instantiate context in a configuration
~~~
CONFIGURATION MyConfiguration
    VAR_GLOBAL
        _myContext : Context;       
    END_VAR
END_CONFIGURATION
~~~

Execute the context in a program
~~~
PROGRAM MAIN
VAR_EXTERNAL
    _myContext : Context;
END_VAR

_myContext.Run();

~~~

### Data exchange initialization in .NET

At this point, we have everything ready in the PLC.

We must now tell the `DataManager` what repository we will use. We will work with data stored in files in JSON format.

Let's create a configuration for the repository and initialize remote data exchange:


[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Program.cs?name=AxoDataExampleDocuIntialization)]


> [!NOTE]
> `MyData` should be of type from `Pocos`.


### Usage

Now we can freely shuffle the data between PLC and the local folder.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoData/AxoDataDocuExample.st?name=UseManager)]

## Data visualization

### Automated rendering using `RenderableContentControl`

With `Command` presentation type, options exist for adding, editing, and deleting records.

[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/DocuExamples/AxoDataDocuExamples.razor?name=CommandView)]

![Command](~/images/Command.png)

If you use `Status` presentation type, data will be only displayed and cannot be manipulated.

[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/DocuExamples/AxoDataDocuExamples.razor?name=DisplayView)]

![Status](~/images/Status.png)

### Custom columns

There is a possibility to add custom columns if it is needed. You must add `AXOpen.Data.ColumnData` view as a child in `DataView`. The `BindingValue` must be set in `ColumnData` and contains a string representing the attribute name of custom columns. If you want to add a custom header name, you can set the name in `HeaderName` attribute. Also, there is an attribute to make the column not clickable, which is clickable by default. The example using all attributes:


[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/DocuExamples/AxoDataDocuExamples.razor?name=CustomColumns)]

When adding data view manually, you will need to create ViewModel:

[!code-csharp[](../../../src/integrations/src/AXOpen.Integrations.Blazor/Pages/DocuExamples/AxoDataDocuExamples.razor?name=CustomColumnsCode)]


![Custom columns](~/images/CustomColumns.png)

<!-- ### Export/Import

If you want to be able to export data, you must add `CanExport` attribute with `true` value. Like this:

~~~
<DataView Vm="@ViewModel.DataViewModel" Presentation="Command" CanExport="true" />
~~~

With this option, buttons for export and import data will appear. After clicking on the export button, the `csv` file will be created, which contains all existing records. If you want to import data, you must upload `csv` file with an equal data structure as we get in the export file.

![Export](~/images/Export.png)

> [!IMPORTANT]
> Export and import function will create high load on the application. Don't use with large datasets. These function can be used only on a limited number (100 or less) documents. Typical used would be for recipes and settings, but not for large collections of production or event data. -->

### Modal detail view

The Detail View is default shown like modal view. That means if you click on some record, the modal window with a detail view will be shown. If necessary, this option can be changed with `ModalDetailView` attribute. This change will show a detail view under the record table. Example with `ModalDetailView` attribute:

~~~
<DataView Vm="@ViewModel.DataViewModel" Presentation="Command" ModalDetailView="false" />
~~~

![Not Modal detail view](~/images/NotModalDetailView.png)
