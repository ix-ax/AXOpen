# Rtm

The `Rtm` class provides a SIMATIC S7-1500 implementation of the `IAxoRtm` interface. It wraps the platform runtime measurement function to expose elapsed time within the AXOpen framework.

## Methods

| Method | Return type | Description |
|--------|-------------|-------------|
| `Elapsed()` | `LTIME` | Returns the elapsed time since the last call, representing the runtime of the PLC. |

## Usage

The `Rtm` instance is typically injected into an `AxoContext` via `InjectRtm()`, making it available to all objects within that context. Application code calls `Elapsed()` to obtain the time elapsed since the PLC started running.

### CONTROLLER

Measuring elapsed runtime:

[!code-smalltalk[](../../showcase/app/src/simatic1500/Simatic1500Showcase.st?name=RtmUsage)]
