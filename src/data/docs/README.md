# **AXOpen.Data**

**AXOpen.Data** provides data exchange between the controller and an arbitrary repository.

`AXOpen.Data` library provides a simple yet powerful data exchange between PLC and an arbitrary data repository. It includes the implementation of a series of repository operations known as CRUD (Create Read Update Delete), accessible directly from the PLC.

## Benefits

The main benefit of this solution is data scalability; once the repository is set up, any modification of the data structure(s) will result in an automatic update of mapped objects. And therefore, there is no need for additional coding and configuration.

## How it works

The basic PLC block is `AxoDataExchange`, which has its .NET counterpart (or .NET twin) that handles complex repository operations using a modified `AxoRemoteTask`, which is a form of RPC (Remote Procedure Call), that allows you to execute the code from the PLC in a remote .NET application.

## Implemented repositories

The `AxoDataExchange` uses a predefined interface, `IRepository`, that allows for the virtually unlimited implementation of different target repositories.

At this point, AXOpen supports these repositories directly:

- InMemory
- Json
- MongoDB
- RavenDB


[!INCLUDE [AxoDataExchange](AxoDataExchange.md)]
[!INCLUDE [AxoDataFragmentExchange](AxoDataFragmentExchange.md)]
