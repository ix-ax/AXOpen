# Logging with AXOpen.Core

## Overview
In this example, we illustrate how to use the logging functionalities provided by `AxoLogger`. Our objective is to create and use loggers, produce log messages of various severity levels, and showcase how to access a logger from the context within a nested object. We'll be using two classes for our demonstration: `Loggers` and `ContextLoggerInNestedObject`.

## Loggers Class
The `Loggers` class is an extension of `AxoContext`, part of the `AXOpen.Core` namespace. This class is the central hub for the logging actions carried out in this example.

#### Logger Declarations
We declare two instances of `AxoLogger`, named `LoggerOne` and `LoggerTwo`. Additionally, we declare `InnerObject`, which is an instance of the `ContextLoggerInNestedObject` class.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.Logging/AxoLoggerDocuExample.st?name=DeclareLoggers)]


#### Logging Activities
In the `Main` method, we begin by injecting `LoggerOne` and `LoggerTwo` into `THIS`, referring to the current `Loggers` class instance.

Following each injection, we retrieve the logger instance using `THIS.GetLogger()` and log a message. For instance, `THIS.GetLogger().Log('Here I am logging an error.', eLogLevel#Error);` logs an error message, whereas `THIS.GetLogger().Log('Here I am logging an information.', eLogLevel#Information);` logs an informational message.

This process is executed for both `LoggerOne` and `LoggerTwo`, showing how you can toggle between different logger instances and generate log messages of varying severities.

Lastly, we initialize `InnerObject` and invoke its `Foo` method.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.Logging/AxoLoggerDocuExample.st?name=InjectLoggers)]


## Logging from nested objects
This class demonstrates how to fetch and log messages using a logger from a parent context from within a nested object.

The `Foo` method retrieves the context's logger using `THIS.GetContext().GetLogger()` and logs an `Error` level message. This shows how to access and use the logger of a containing context, enabling nested objects to utilize the same logging functionalities as their parent.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.Logging/AxoLoggerDocuExample.st?name=UseLoggerFromInnerObject)]


## Summary
Through this example, we've shown how to declare and utilize the `AxoLogger` for logging messages with different levels of severity. We've also illustrated how nested objects can retrieve and use the logger of their parent context to log messages, showcasing a flexible and potent approach to handle logging in applications with complex, nested structures.

# Initialization of Logger in .NET 

In this section, we'll be discussing how to initialize the logger in a .NET application, specifically using the Serilog library for logging. We'll also demonstrate how to link the logger to our `AxoLogger` instances from our previous examples: `LoggerOne` and `LoggerTwo`.

## Creating the AxoApplication
Before initializing the logger, we first create an instance of `AxoApplication` using the `CreateBuilder` method. This sets up the application builder required for the logger configuration.

[!code-smalltalk[](../../../src/integrations/ctrl/src/integrations/src/AXOpen.Integrations.Blazor/Program.cs?name=AxoAppBuilder)]

## Configuring the Logger

Next, we configure our logger. We are using the Serilog library, a popular .NET logging library that allows flexible and complex logging setups. In this example, we're creating a simple setup where all logs of any level (`Verbose` level and above) will be written to the console.


[!code-smalltalk[](../../../src/integrations/ctrl/src/integrations/src/AXOpen.Integrations.Blazor/Program.cs?name=AxoLoggerConfiguration)]

This code sets up a new Serilog logger with a single sink directed to the console window. The `MinimumLevel.Verbose()` method specifies that all logs, regardless of their severity level, will be outputted to the console.

## Connecting Loggers to the Application

Finally, we connect our previously defined `AxoLogger` instances, `LoggerOne` and `LoggerTwo`, to our application. 

```csharp
Entry.Plc.AxoLoggers.LoggerOne.StartDequeuing(250);
Entry.Plc.AxoLoggers.LoggerTwo.StartDequeuing(250);
```

The `StartDequeuing` method is called with a parameter of `250`. This starts a loop that dequeues log messages from the `AxoLogger`'s message queue every 250 milliseconds, passing them to the configured sinks—in our case, the console window.

## Summary
This example showcases how to initialize a logger in a .NET application using the Serilog library and then how to connect the `AxoLogger` instances from our `Loggers` class to it. With this setup, the `AxoLogger` instances will send their queued log messages to the console every quarter of a second.

# Limitations

## Log Entry Limit

Please note that the `AxoLogger` instances in this example (`LoggerOne` and `LoggerTwo`) have an internal limit of 100 log entries. This means that once the number of log entries in the logger's queue reaches this limit, any new log entries will be discarded until older log entries are dequeued and the total number drops below this limit.

This limit is designed to prevent excessive memory usage if the dequeuing process is unable to keep up with the rate of new log entries. Regularly dequeuing log entries, as shown in this example with the `StartDequeuing(250)` calls, helps to ensure that log entries are processed promptly and do not exceed this limit.

As always, it is important to consider the potential for high rates of log entries when designing your application's logging strategy and ensure that your dequeuing interval and log entry limit are appropriately configured for your specific needs.

# Logging Performance Considerations

Logging in an application, while essential for debugging and monitoring, can impact the overall performance of your controller, especially when logging at high rates. The controller may have resource limitations such as CPU power and memory, which can be strained by excessive logging activities.

Each log operation involves creating the log entry, formatting it, and adding it to the logger's message queue. These operations consume computational resources and memory. If the log entry queue becomes excessively large due to high logging rates and insufficient dequeuing, it can further strain the controller's resources.

Also, note that the communication between the controller and the logger can introduce additional latency, especially if network-based logging is used. If a large number of log entries are sent over the network, this can congest the network and slow down other network operations.

Therefore, it is crucial to balance the need for detailed logging with the impact on the controller's performance and resource usage. It's recommended to carefully select what needs to be logged based on its importance and potential to aid in debugging and monitoring. Optimizing the logging level, choosing an appropriate dequeuing interval, and regularly reviewing and maintaining your logging strategy can help to minimize the performance impact.

Always keep these considerations in mind when designing and implementing logging in your applications, particularly in resource-constrained environments such as controllers.
