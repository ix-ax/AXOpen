# Data

IxData provide a simple yet powerful data exchange between PLC and an arbitrary data repository. IxData implements a series of repository operations known as CRUD.

## Benefits

The main benefit of this solution is data scalability; once the repository is set up, any modification of the data structure(s) will result in an automatic update of mapping objects. And therefore, there is no need for additional coding and configuration.

## How it works

The basic PLC block is TcoDataExchange, which has its .NET counterpart (or .NET twin) that handles complex repository operations using a modified IxRemoteTask, which is a form of RPC (Remote Procedure Call), that allows you to execute the code from the PLC in a remote .NET application.

## Implemented repositories

The DataEntity uses a predefined interface IRepository that allows for the unlimited implementation of different kinds of repositories.

At this point, Ix.framework supports these repositories directly:

- InMemory
- Json
- MongoDB

## Getting started

For the data exchange to work, we will need to create our class extending the `DataExchange` class. We can call it `MyDataExchanger`. Don't forget to add using:
```
using ix.framework.data;
```

~~~ C#
CLASS MyDataExchanger EXTENDS ix.framework.data.DataExchange 
~~~


We will also need to add our data enitity variable, which contains the data that we want to exchange between PLC and the repository. This variable must be annotated with `DataEntityAttribute`. This attribute should be unique within DataExchanger object and is used to locate data object within framework. When `DataEntityAttribute` is missing, exception is thrown. 

~~~
CLASS MyDataExchanger EXTENDS ix.framework.data.DataExchange
    VAR PUBLIC
        {#ix-attr:[DataEntityAttribute]}
        _data : MyData;
    END_VAR  
END_CLASS  
~~~

The data entity variable must be of a class that extends `DataEntity`. So let's just create class that will have some variables.

~~~
CLASS MyData EXTENDS ix.framework.data.DataEntity
    VAR PUBLIC
        sampleData : REAL;
        someInteger : INT;
        someString : STRING;
    END_VAR 
END_CLASS
~~~

As mentioned earlier, we use remote calls to execute the CRUD operations. These calls are a variant of IxTask which can operate asynchronously, and we will need to call it cyclically.

We will now need to create an instance of `MyDataExchanger` in some `MyConfiguration`, and call `_myDataExchanger` in the Main method of the context. Just to remind ourselfes all logic in Ix framework must be placed in the call tree of a Main method of a context.

~~~
CONFIGURATION MyConfiguration
    VAR_GLOBAL
        _myDataExchanger : MyDataExchanger;
    END_VAR
END_CONFIGURATION
~~~

~~~
CLASS MyContext EXTENDS ix.framework.core.IxContext    
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

## Data visualisation

With presentation `Command` there are available options for adding, editing and deleting records.

[!Command](~/articles/data/images/Command.png)

If you use `Status` presentation data will be only displayed, without option for manipulated with records.

[!Status](~/articles/data/images/Status.png)

### Custom columns

There is possible to add custom columns if is needed. You must add `ix.framework.core.IxDataExchange.ColumnData` view as child in `IxDataView`. Where must be set `BindingValue` which contains string representing attribute name of custom columns. If you want to add custom header name, you can simply set the name in `HeaderName` attribute. Also, there is attribute to make column not clickable, which is clickable by default. Example using all attributes:

~~~
<IxDataView Vm="@ViewModel.DataViewModel" Presentation="Command">
    <ix.framework.core.IxDataExchange.ColumnData HeaderName="Recipe name" BindingValue="RecipeName" />
    <ix.framework.core.IxDataExchange.ColumnData BindingValue="String1" Clickable="false" />
</IxDataView>
~~~

[!Custom columns](~/articles/data/images/CustomColumns.png)

### Export

If you want to be able to export data, you must add `CanExport` attribute with `true` value. Like this:

~~~
<IxDataView Vm="@ViewModel.DataViewModel" Presentation="Command" CanExport="true" />
~~~

With this option, buttons for export and import data will be appear. After clicing on export button, there will be created csv file, which will contains all existing records. If you want import data, you must upload csv file with equals data structure like we get in export file.

[!Export](~/articles/data/images/Export.png)

### Modal detail view

Detail View is default show like modal view. That means if you clicked on some record, there will be show modal window with detailed view. If necessary, this option can be changed with `ModalDetailView` attribute where is set `false` value. This change will show detail view under the record table. Example with `ModalDetailView` attribute:

~~~
<IxDataView Vm="@ViewModel.DataViewModel" Presentation="Command" ModalDetailView="false" />
~~~

[!Not Modal detail view](~/articles/data/images/NotModal.png)