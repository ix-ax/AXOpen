# Data

IxData provide a simple yet powerful data exchange between PLC and an arbitrary data repository. IxData implements a series of repository operations known as CRUD.

## Benefits

The main benefit of this solution is data scalability; once the repository is set up, any modification of the data structure(s) will result in an automatic update of mapping objects. And therefore, there is no need for additional coding and configuration.

## How it works



## Implemented repositories

The TcoData uses a predefined interface IRepository that allows for the unlimited implementation of different kinds of repositories.

At this point, TcOpen supports these repositories directly:

- InMemory
- Json
- MongoDB

## Getting started

For the data exchange to work, we will need to create our class extending the `DataExchange` class. We can call it `MyDataExchanger`.

~~~ C#
FUNCTION_BLOCK MyDataExchanger EXTENDS TcoData.TcoDataExchange
~~~

We will also need to add `_data` variable to our class. There is no specific reason for the variable to be called `_data`; it is just convention; it is, however, important as this `_data` variable is the one that will contain the data that we want to exchange between PLC and the repository.

~~~
CLASS MyDataExchanger EXTENDS ix.framework.data.DataExchange
    VAR PUBLIC
        _data : MyData;
    END_VAR  
END_CLASS  
~~~

The `_data` must be of a class that extends DataEntity. So let's just create class that will have some variables.

~~~
CLASS MyData EXTENDS ix.framework.data.DataEntity
    VAR PUBLIC
        sampleData : REAL;
        someInteger : INT;
        someString : STRING;
    END_VAR 
END_CLASS
~~~