# IAxoContext

`IAxoContext` defines the contract for the application's cyclic execution context. Every AXOpen application has at least one context that orchestrates the cyclic execution of all objects within it. The context is responsible for creating unique identities, tracking cycle counts, and providing access to injected services such as real-time clock, logger, runtime meter, and messaging.

## Methods

| Method | Return Type | Description |
|---|---|---|
| `CreateIdentity()` | `ULINT` | Generates a unique numeric identity for objects within this context. |
| `OpenCycleCount()` | `ULINT` | Returns the current open cycle count of the context. |
| `GetRtc()` | `IAxoRtc` | Retrieves the injected real-time clock instance. |
| `InjectRtc(Rtc)` | -- | Injects a real-time clock implementation into the context. |
| `GetLogger()` | `IAxoLogger` | Retrieves the injected logger instance. |
| `InjectLogger(_logger)` | -- | Injects a logger implementation into the context. |
| `GetRtm()` | `IAxoRtm` | Retrieves the injected runtime meter instance. |
| `InjectRtm(inRtm)` | -- | Injects a runtime meter implementation into the context. |
| `GetMessengerService()` | `IAxoMessagingServices` | Retrieves the injected messaging service instance. |
| `InjectMessengerService(inMessengerService)` | -- | Injects a messaging service implementation into the context. |
| `IsValid()` | `BOOL` | Returns whether this context is in a valid state. |

## Usage

The following example shows typical declarations used alongside abstractions types in an AXOpen application:

[!code-smalltalk[](../../showcase/app/src/abstractions/AbstractionsShowcase.st?name=AbstractionsDeclarations)]
