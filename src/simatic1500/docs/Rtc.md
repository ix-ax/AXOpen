# Rtc

The `Rtc` class provides a SIMATIC S7-1500 implementation of the `IAxoRtc` interface. It wraps the PLC system clock to provide UTC time access within the AXOpen framework.

## Methods

| Method | Return type | Description |
|--------|-------------|-------------|
| `NowUTC()` | `LDATE_AND_TIME` | Returns the current UTC date and time from the PLC system clock. |
| `SetUTC(Value)` | `WORD` | Sets the PLC system clock to the specified UTC date and time. Returns a status word. |

## Usage

The `Rtc` instance is typically injected into an `AxoContext` via `InjectRtc()`, making it available to all objects within that context. Application code then calls `NowUTC()` to read the current time or `SetUTC()` to synchronize the PLC clock.

### CONTROLLER

Declaration:

[!code-smalltalk[](../../showcase/app/src/simatic1500/Simatic1500Showcase.st?name=Simatic1500Declarations)]

Reading the current UTC time:

[!code-smalltalk[](../../showcase/app/src/simatic1500/Simatic1500Showcase.st?name=RtcUsage)]
