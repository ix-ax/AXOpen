# **AXOpen.Abstractions**

[!INCLUDE [General](../../../docfx/articles/notes/LIBRARYHEADER.md)]

**AXOpen.Abstractions** is the core abstractions package for the AXOpen framework. It defines the interfaces and enumeration types that all AXOpen implementations depend on. This library contains no concrete classes; it establishes the contracts that concrete libraries such as `AXOpen.Core` implement.

## Interfaces

| Interface | Namespace | Description |
|---|---|---|
| `IAxoContext` | `AXOpen.Core` | Defines the contract for the application's cyclic execution context. Provides identity creation, cycle counting, and service injection points for RTC, logging, runtime metering, and messaging. |
| `IAxoObject` | `AXOpen.Core` | Base contract for all AXOpen objects. Provides identity, context access, parent traversal, message aggregation, and validity checks. |
| `IAxoRtc` | `AXOpen.Rtc` | Real-time clock abstraction. Returns the current UTC date and time. |
| `IAxoRtm` | `AXOpen.Rtm` | Runtime meter abstraction. Returns the elapsed time. |
| `IAxoLogger` | `AXOpen.Logging` | Logging abstraction (extends `IAxoLoggerConfig`). Provides methods to log messages with level, sender, and message code. |
| `IAxoLoggerConfig` | `AXOpen.Logging` | Configuration interface for the logger. Allows setting the minimum log level. |
| `IAxoMessenger` | `AXOpen.Core` | Marker interface for messenger objects. |
| `IAxoMessagingServices` | `AXOpen.Core` | Messaging service contract. Provides message queuing, suspension, resumption, and downstream message requalification. |

## Enumerations

| Enum | Namespace | Description |
|---|---|---|
| `eLogLevel` | `AXOpen.Logging` | Defines log severity levels: `NoCat`, `Verbose`, `Debug`, `Information`, `Warning`, `Error`, `Fatal`. |
| `eAxoMessageCategory` | `AXOpen.Messaging` | Defines message categories: `None`, `Info`, `Potential`, `Warning`, `Error`, `ProgrammingError`, `Critical`. |
