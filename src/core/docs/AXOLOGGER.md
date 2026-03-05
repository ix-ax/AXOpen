# Logging with AXOpen.Core

Effective logging is vital for monitoring the health and performance of software applications. By providing real-time insights into application behaviour and detailed diagnostic information during troubleshooting, logging plays a crucial role in development, debugging, and ongoing maintenance.

In the world of PLC applications, logging can be a bit more complex due to the intricacies of the systems involved. AXOpen.Core, a library developed for industrial automation software, provides robust logging capabilities that meet these specific needs. With the AxoLogger class, it offers a potent tool for logging in both PLC controller software and .NET applications.

In this guide, we explore the usage of AXOpen.Core's logging capabilities. We demonstrate how to declare, configure, and utilize the AxoLogger to log messages of various severity levels. We also cover the process of accessing a logger from within a nested object and configuring a logger in a .NET application using the Serilog library.

A key aspect we will highlight is the ability to manage the verbosity of logs independently in the controller software and the .NET application, providing you with flexible control over your logging activities.

Please keep in mind that excessive logging from the controller can degrade the overall system performance due to the limits imposed by the controller. There's also a limit of 100 log entries that can be stored in the logger's queue. If this limit is reached, the oldest log entries will be removed from the queue as new entries are added.

## Overview
In this example, we illustrate how to use the logging functionalities provided by `AxoLogger`. Our objective is to create and use loggers, produce log messages of various severity levels, and showcase how to access a logger from the context within a nested object. We'll be using two classes for our demonstration: `Loggers` and `ContextLoggerInNestedObject`.


# [CONTROLLER](#tab/controller)

[!NOTE]
AxoLogger works only in conjunction with its .NET counterpart. Ensure that you implement both.

## Loggers Class
The `Loggers` class is an extension of `AxoContext`, part of the `AXOpen.Core` namespace. This class is the central hub for the logging actions carried out in this example.


#### Logger Declarations
We declare two instances of `AxoLogger`, named `LoggerOne` and `LoggerTwo`. Additionally, we declare `InnerObject`, which is an instance of the `ContextLoggerInNestedObject` class.

[!code-smalltalk[](../app/src/Examples/AXOpen.Logging/AxoLoggerDocuExample.st?name=DeclareLoggers)]


#### Logging Activities
In the `Main` method, we first inject `LoggerOne` into `THIS`, which refers to the current instance of `Loggers`. Following this injection, we set the minimum log level for `LoggerOne` to `Error` using `THIS.GetLogger().SetMinimumLevel(eLogLevel#Error);`. This configuration ensures that `LoggerOne` will only log messages with a severity level of `Error` or higher.

Subsequently, we create an error log message and an informational log message using `LoggerOne`. Note that due to the log level setting, the informational message will not be logged.

Next, we inject `LoggerTwo` into `THIS` and set the minimum log level for `LoggerTwo` to `Information` using `THIS.GetLogger().SetMinimumLevel(eLogLevel#Information);`. This configuration will cause `LoggerTwo` to log all messages with a severity level of `Information` or higher.

We then create an error log message and an informational log message using `LoggerTwo`. Due to the log level setting, both messages will be logged.

Finally, we initialize `InnerObject` and invoke its `Foo` method to showcase logging from within a nested object.

By adjusting the minimum log level for each logger, we can control the severity of messages that each logger will handle. This offers flexibility in categorizing and prioritizing log messages based on their importance.

[!code-smalltalk[](../app/src/Examples/AXOpen.Logging/AxoLoggerDocuExample.st?name=InjectLoggers)]


## Logging from nested objects
This class demonstrates how to fetch and log messages using a logger from a parent context from within a nested object.

The `Foo` method retrieves the context's logger using `THIS.GetContext().GetLogger()` and logs an `Error` level message. This shows how to access and use the logger of a containing context, enabling nested objects to utilize the same logging functionalities as their parent.

[!code-smalltalk[](../app/src/Examples/AXOpen.Logging/AxoLoggerDocuExample.st?name=UseLoggerFromInnerObject)]


## Summary
Through this example, we've shown how to declare and utilize the `AxoLogger` for logging messages with different levels of severity. We've also illustrated how nested objects can retrieve and use the logger of their parent context to log messages, showcasing a flexible and potent approach to handle logging in applications with complex, nested structures.

# [.NET TWIN](#tab/dotnettwin)

# Initialization of Logger in .NET 

In this section, we'll be discussing how to initialize the logger in a .NET application, specifically using the Serilog library for logging. We'll also demonstrate how to link the logger to our `AxoLogger` instances from our previous examples: `LoggerOne` and `LoggerTwo`.

## Initializing Object Identities

Before you start logging with `AxoLogger`, you need to ensure the object identities are initialized. This is important because it allows the `AxoLogger` to correctly identify the source of log messages, which aids in debugging and log analysis.

To initialize the object identities in a .NET part of your application, use the following method:

```csharp
await Entry.Plc.Connector.IdentityProvider.ConstructIdentitiesAsync();
```

This method call is usually performed during the application initialization process, right after the `AxoApplication` and loggers are configured. It constructs all the identities required by the application, preparing the `AxoLogger` for logging.

Here's how it could fit into the .NET application initialization process:

```csharp

// Initialize the object identities.
Entry.Plc.Connector.SubscriptionMode = ReadSubscriptionMode.Polling;
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 250;
await Entry.Plc.Connector.IdentityProvider.ConstructIdentitiesAsync();
```

This sets up the `AxoApplication`, configures a logger with Serilog, initializes the object identities, and then connects `AxoLogger` instances to the application.

Remember to always await the `ConstructIdentitiesAsync` method, as it is an asynchronous operation and your application should not proceed until it has been completed. This ensures all object identities are fully initialized before your `AxoLogger` instances start logging.

> [!IMPORTANT]
> Failure to initialize object identities before starting the logging process can result in incorrect or incomplete log entries, which can hinder the debugging and analysis of your application. Always ensure that object identities are correctly initialized before you start logging.

## Creating the AxoApplication
Before initializing the logger, we first create an instance of `AxoApplication` using the `CreateBuilder` method. This sets up the application builder required for the logger configuration.

[!code-smalltalk[](../app/ix-blazor/axopencore.blazor/Program.cs?name=AxoAppBuilder)]

## Configuring the Logger

Next, we configure our logger. We are using the Serilog library, a popular .NET logging library that allows flexible and complex logging setups. In this example, we're creating a simple setup where all logs of any level (`Verbose` level and above) will be written to the console.


[!code-smalltalk[](../app/ix-blazor/axopencore.blazor/Program.cs?name=AxoLoggerConfiguration)]

This code sets up a new Serilog logger with a single sink directed to the console window. The `MinimumLevel.Verbose()` method specifies that all logs, regardless of their severity level, will be outputted to the console.

## Connecting Loggers to the Application

Finally, we connect our previously defined `AxoLogger` instances, `LoggerOne` and `LoggerTwo`, to our application. 


[!code-smalltalk[](../app/ix-blazor/axopencore.blazor/Program.cs?name=AxoLoggerInitialization)]

The `StartDequeuing` method is now called with two parameters. The first parameter `AxoApplication.Current.Logger` refers to the instance of the logger that was created and configured in the previous step. The second parameter is `250`. This starts a loop that dequeues log messages from the `AxoLogger`'s message queue every 250 milliseconds, passing them to the configured sinks—in our case, the console window.

## Adding Custom Target Loggers

The Serilog library allows you to add and configure custom target loggers. In the previous example, we've used `AxoApplication.Current.Logger` as our target logger. This is the logger instance created and configured during the application setup.

However, if you want to log messages to a different target, you can create and configure additional Serilog loggers. For example, you might want to create a logger that writes to a file, a database, or a remote logging server.

To add a new target logger, you would follow similar steps as before, but specify your custom target in the `WriteTo` method.

```csharp
var fileLogger = new LoggerConfiguration()
    .WriteTo.File("log.txt")
    .CreateLogger();

var databaseLogger = new LoggerConfiguration()
    .WriteTo.MyDatabase(myConnectionString)
    .CreateLogger();
```

In these examples, `fileLogger` is a logger that writes logs to a text file named `log.txt`, and `databaseLogger` is a logger that writes logs to a database, using a connection string `myConnectionString`. The `WriteTo.MyDatabase(myConnectionString)` method is a placeholder; replace this with the appropriate method for your specific database sink.

After creating these loggers, you can connect them to your `AxoLogger` instances using the `StartDequeuing` method, just as we did before with `AxoApplication.Current.Logger`.

```csharp
Entry.Plc.AxoLoggers.LoggerOne.StartDequeuing(fileLogger, 250);
Entry.Plc.AxoLoggers.LoggerTwo.StartDequeuing(databaseLogger, 250);
```

In this configuration, `LoggerOne` will send its queued log messages to `log.txt` every quarter of a second, while `LoggerTwo` will send its messages to the specified database. 

Please note that these are just examples, and the Serilog library supports many different types of log targets (also known as "sinks"), which you can use to customize the logging behavior of your application as needed. Always refer to the official Serilog documentation for more detailed information and the latest features.

## Summary
This example showcases how to initialize a logger in a .NET application using the Serilog library and then how to connect the `AxoLogger` instances from our `Loggers` class to it. With this setup, the `AxoLogger` instances will send their queued log messages to the console every quarter of a second.


> [!IMPORTANT]
> In the context of logging level configuration, it's important to note that the minimum logging level of the .NET logger (set up in C#) and the `AxoLogger` (set up in the controller's software) are independent settings. You can configure them individually to fine-tune the verbosity of your logs both at the controller level and in your .NET application.

---
## AxoLogger and AxoMessenger

AxoMessenger uses Context AxoLogger to log the rising and falling of an alarm. There is no particular need for the configuration fo this behaviour. 

Here are the mappings between eAxoMessageCategory and eLogLevel as per the code:

- Trace messages are logged as Verbose.
- Debug messages are logged as Debug.
- Info, TimedOut, and Notification messages are logged as - Information.
- Warning messages are logged as Warning.
- Error and ProgrammingError messages are logged as Error.
- Critical, Fatal, and Catastrophic messages are logged as Fatal.





# Limitations

## Log Entry Limit

> [!IMPORTANT]
> Please note that the `AxoLogger` instances in this example (`LoggerOne` and `LoggerTwo`) have an internal limit of 100 log entries. This means that once the number of log entries in the logger's queue reaches this limit, any new log entries will be discarded until older log entries are dequeued and the total number drops below this limit.

This limit is designed to prevent excessive memory usage if the dequeuing process is unable to keep up with the rate of new log entries. Regularly dequeuing log entries, as shown in this example with the `StartDequeuing(250)` calls, helps to ensure that log entries are processed promptly and do not exceed this limit.

As always, it is important to consider the potential for high rates of log entries when designing your application's logging strategy and ensure that your dequeuing interval and log entry limit are appropriately configured for your specific needs.

# Logging Performance Considerations

> [!IMPORTANT]
> Logging in an application, while essential for debugging and monitoring, can impact the overall performance of your controller, especially when logging at high rates. The controller may have resource limitations such as CPU power and memory, which can be strained by excessive logging activities.

Each log operation involves creating the log entry, formatting it, and adding it to the logger's message queue. These operations consume computational resources and memory. If the log entry queue becomes excessively large due to high logging rates and insufficient dequeuing, it can further strain the controller's resources.

Also, note that the communication between the controller and the logger can introduce additional latency, especially if network-based logging is used. If a large number of log entries are sent over the network, this can congest the network and slow down other network operations.

Therefore, it is crucial to balance the need for detailed logging with the impact on the controller's performance and resource usage. It's recommended to carefully select what needs to be logged based on its importance and potential to aid in debugging and monitoring. Optimizing the logging level, choosing an appropriate dequeuing interval, and regularly reviewing and maintaining your logging strategy can help to minimize the performance impact.

Always keep these considerations in mind when designing and implementing logging in your applications, particularly in resource-constrained environments such as controllers.
