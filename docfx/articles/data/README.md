# AxoData

AxoData provide a simple yet powerful data exchange between PLC and an arbitrary data repository. IxData implements a series of repository operations known as CRUD.

## Benefits

The main benefit of this solution is data scalability; once the repository is set up, any modification of the data structure(s) will result in an automatic update of mapping objects. And therefore, there is no need for additional coding and configuration.

## How it works

The basic PLC block is AxoDataExchange, which has its .NET counterpart (or .NET twin) that handles complex repository operations using a modified AxoRemoteTask, which is a form of RPC (Remote Procedure Call), that allows you to execute the code from the PLC in a remote .NET application.

## Implemented repositories

The AxoDataEntity uses a predefined interface IRepository that allows for the unlimited implementation of different kinds of repositories.

At this point, AXOpen supports these repositories directly:

- InMemory
- Json
- MongoDB

## Getting started

For the data exchange to work, we will need to create our class extending the `AxoDataExchange` class. We can call it `MyDataExchanger`. Don't forget to add using:
```
using AXOpen.Data;
```

~~~
CLASS MyDataExchanger EXTENDS AXOpen.Data.AxoDataExchange 
~~~

We will also need to add our data entity variable, which contains the data that we want to exchange between PLC and the repository. This variable must be annotated with `AxoDataEntityAttribute`. This attribute should be unique within AxoDataExchanger object and is used to locate data object within framework. When `AxoDataEntityAttribute` is missing, exception is thrown.

~~~
CLASS MyDataExchanger EXTENDS AXOpen.Data.AxoDataExchange
    VAR PUBLIC
        {#ix-attr:[AxoDataEntityAttribute]}
        _data : MyData;
    END_VAR  
END_CLASS  
~~~

The data entity variable must be of a class that extends `AxoDataEntity`. So let's just create class that will have some variables.

~~~
CLASS MyData EXTENDS AXOpen.Data.AxoDataEntity
    VAR PUBLIC
        sampleData : REAL;
        someInteger : INT;
        someString : STRING;
    END_VAR 
END_CLASS
~~~

As mentioned earlier, we use remote calls to execute the CRUD operations. These calls are a variant of IxTask which can operate asynchronously, and we will need to call it cyclically.

We will now need to create an instance of `MyDataExchanger` in some `MyConfiguration`, and call `_myDataExchanger` in the Main method of the context. Just to remind ourselves all logic in Ix framework must be placed in the call tree of a Main method of a context.

~~~
CONFIGURATION MyConfiguration
    VAR_GLOBAL
        _myDataExchanger : MyDataExchanger;
    END_VAR
END_CONFIGURATION
~~~

~~~
CLASS MyContext EXTENDS AXOpen.Core.AxoContext    
    VAR PUBLIC         
        _myDataExchanger: MyDataExchanger;
    END_VAR
END_CLASS
~~~

And we will also need to instantiate the context in a PROGRAM and call the `Run` method.

~~~
PROGRAM MAIN
VAR_EXTERNAL
    _myContext : MyContext;
END_VAR
//-------------------------------------------------
//-------------------------------------------------
_myContext.Run();
~~~

At this point, we have everything ready in the PLC.

We will now need to tell the `_myDataExchanger` what repository we will use. First, we will work with data is stored in files in Json format.

Let's create a configuration for the repository:

~~~ C#
var storageDir = Path.Combine(Environment.CurrentDirectory, "MyDataExchangeData");
var repository = Ix.Repository.Json.Repository.Factory(new JsonRepositorySettings<MyData>(storageDir));
~~~

Note: `MyData` should be type from `Pocos`.

Then we will need to associate the repository with the PLC object and initialize the data exchange operations.

~~~ C#
Entry.Plc.MainContext.MyDataExchanger.InitializeRemoteDataExchange(repository);
~~~

Now we can freely shuffle the data between PLC and the local folder.
```
IF(_create) THEN
    IF(_myDataExchanger.Create(_id).Done) THEN
        _create := FALSE;
    END_IF;
END_IF;

IF(_read) THEN
    IF(_myDataExchanger.Read(_id).Done) THEN
        _read := FALSE;
    END_IF;
END_IF;

IF(_update) THEN
    IF(_myDataExchanger.Update(_id).Done) THEN
        _update := FALSE;
    END_IF;
END_IF;

IF(_delete) THEN
    IF(_myDataExchanger.Delete(_id).Done) THEN
        _delete := FALSE;
    END_IF;
END_IF;
```

## Data visualization

With presentation `Command` there are available options for adding, editing and deleting records.

[!Command](~/images/Command.png)

If you use `Status` presentation type, data will be only displayed cannot be manipulated.

[!Status](~/images/Status.png)

### Custom columns

There is a possibility to add custom columns if it is needed. You must add `AXOpen.Core.AxoDataExchange.ColumnData` view as a child in `AxoDataView`. The `BindingValue` must be set in `ColumnData` and contains string representing attribute name of custom columns. If you want to add custom header name, you can simply set the name in `HeaderName` attribute. Also, there is an attribute to make column not clickable, which is clickable by default. The example using all attributes:

~~~
<AxoDataView Vm="@ViewModel.DataViewModel" Presentation="Command" ModalDataView="false" CanExport="true">
    <AXOpen.Data.Blazor.AxoDataExchange.ColumnData HeaderName="Recipe name" BindingValue="RecipeName" Clickable="false" />
    <AXOpen.Data.Blazor.AxoDataExchange.ColumnData BindingValue="String1" />
</AxoDataView>
~~~

[!Custom columns](~/images/CustomColumns.png)

### Export

If you want to be able to export data, you must add `CanExport` attribute with `true` value. Like this:

~~~
<AxoDataView Vm="@ViewModel.DataViewModel" Presentation="Command" CanExport="true" />
~~~

With this option, buttons for export and import data will appear. After clicking on export button, the csv file will be created, which contains all existing records. If you want import data, you must upload csv file with equal data structure like we get in export file.

[!Export](~/images/Export.png)

### Modal detail view

The Detail View is default shown like modal view. That means if you clicked on some record, the modal window with detail view will be shown. If necessary, this option can be changed with `ModalDetailView` attribute. This change will show detail view under the record table. Example with `ModalDetailView` attribute:

~~~
<AxoDataView Vm="@ViewModel.DataViewModel" Presentation="Command" ModalDetailView="false" />
~~~

[!Not Modal detail view](~/images/NotModalDetailView.png)
