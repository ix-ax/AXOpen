# AxoData

AXOpen.Data library provides a simple yet powerful data exchange between PLC and an arbitrary data repository. It includes the implementation of a series of repository operations known as CRUD (Create Read Update Delete) accessible directly from the PLC.

## Benefits

The main benefit of this solution is data scalability; once the repository is set up, any modification of the data structure(s) will result in an automatic update of mapped objects. And therefore, there is no need for additional coding and configuration.

## How it works

The basic PLC block is `AxoDataExchange`, which has its .NET counterpart (or .NET twin) that handles complex repository operations using a modified `AxoRemoteTask`, which is a form of RPC (Remote Procedure Call), that allows you to execute the code from the PLC in a remote .NET application.

## Implemented repositories

The `AxoDataExchange` uses a predefined interface `IRepository` that allows for the virtually unlimited implementation of different kinds of target repositories.

At this point, AXOpen supports these repositories directly:

- InMemory
- Json
- MongoDB
- RavenDB

## Getting started

For the data exchange to work, we will need to create our CLASS extending the `AxoDataExchange` class. We can call it `MyDataExchanger`. Don't forget to add using:
```
using AXOpen.data;
```

~~~
CLASS MyDataExchanger EXTENDS AXOpen.Data.DataExchange 
~~~

We will also need to add our data entity variable, which contains the data that we want to exchange between PLC and the repository. This variable must be annotated with `DataEntityAttribute`. This attribute must be assigned to only one member `AxoDataExchange` object and is used to locate data object that contains data to be exchanged between PLC and the target repository. When `DataEntityAttribute` is missing or multiple members have the annotation, an exception is thrown.

~~~
CLASS MyDataExchanger EXTENDS AXOpen.data.DataExchange
    VAR PUBLIC
        {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
        MyDataToExchange : MyData;
    END_VAR  
END_CLASS  
~~~

The data entity variable must be of a class that extends `AxoDataEntity`. So let's just create CLASS that will have some variables.

~~~
CLASS MyData EXTENDS AXOpen.data.DataEntity
    VAR PUBLIC
        sampleData : REAL;
        someInteger : INT;
        someString : STRING;
    END_VAR 
END_CLASS
~~~

As mentioned earlier, we use remote calls to execute the CRUD operations. These calls are a variant of `AxoTask` which can operate asynchronously, and we will need to call it cyclically.

We will now need to create an instance of `MyDataExchanger` in a context object (or as a member of another class). And, we will need to call `_myDataExchanger` in the Main method of appropriate context (Just to remind ourselves all logic in AXOpen must be placed in the call tree of a Main method of a context).

~~~
CLASS MyContext EXTENDS AXOpen.core.IxContext    
    VAR PUBLIC         
        _myDataExchanger: MyDataExchanger;
    END_VAR

    METHOD OVERRIDE PUBLIC Main
        _myDataExchanger.Run(THIS);
    END_METHOD
END_CLASS
~~~

Instantiate context in a configuration
~~~
CONFIGURATION MyConfiguration
    VAR_GLOBAL
        _myContext : MyContext;       
    END_VAR
END_CONFIGURATION
~~~

Execute the context in a program
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

We will now need to tell the `_myDataExchanger` what repository we will use. We will work with data stored in files in JSON format.

Let's create a configuration for the repository:

~~~ C#
var storageDir = Path.Combine(Environment.CurrentDirectory, "MyDataExchangeData");
var repository = AXOpen.Repository.Json.Repository.Factory(new JsonRepositorySettings<MyData>(storageDir));
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

There is a possibility to add custom columns if it is needed. You must add `AXOpen.core.IxDataExchange.ColumnData` view as a child in `IxDataView`. The `BindingValue` must be set in `ColumnData` and contains string representing attribute name of custom columns. If you want to add custom header name, you can simply set the name in `HeaderName` attribute. Also, there is an attribute to make column not clickable, which is clickable by default. The example using all attributes:

~~~
<IxDataView Vm="@ViewModel.DataViewModel" Presentation="Command">
    <AXOpen.core.IxDataExchange.ColumnData HeaderName="Recipe name" BindingValue="RecipeName" />
    <AXOpen.core.IxDataExchange.ColumnData BindingValue="String1" Clickable="false" />
</IxDataView>
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
