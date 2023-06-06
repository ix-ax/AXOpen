# Introduction to Logging with AXOpen.Core

Effective logging is vital for monitoring the health and performance of software applications. By providing real-time insights into application behaviour and detailed diagnostic information during troubleshooting, logging plays a crucial role in development, debugging, and ongoing maintenance.

In the world of PLC applications, logging can be a bit more complex due to the intricacies of the systems involved. AXOpen.Core, a library developed for industrial automation software, provides robust logging capabilities that meet these specific needs. With the AxoLogger class, it offers a potent tool for logging in both PLC controller software and .NET applications.

In this guide, we explore the usage of AXOpen.Core's logging capabilities. We demonstrate how to declare, configure, and utilize the AxoLogger to log messages of various severity levels. We also cover the process of accessing a logger from within a nested object and configuring a logger in a .NET application using the Serilog library.

A key aspect we will highlight is the ability to manage the verbosity of logs independently in the controller software and the .NET application, providing you with flexible control over your logging activities.

Please keep in mind that excessive logging from the controller can degrade the overall system performance due to the limits imposed by the controller. There's also a limit of 100 log entries that can be stored in the logger's queue. If this limit is reached, the oldest log entries will be removed from the queue as new entries are added.


[!INCLUDE [AxoLogger](AXOLOGGER.md)]
