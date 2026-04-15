# AXOpen.S71500

[!INCLUDE [General](../../../docfx/articles/notes/LIBRARYHEADER.md)]

## Description

**AXOpen.S71500** provides SIMATIC S7-1500 specific implementations of AXOpen abstractions for real-time clock (RTC) and runtime measurement (RTM). These classes wrap the platform-specific system functions and expose them through the standard AXOpen interfaces, allowing application code to remain hardware-agnostic.

**Package:** `@inxton/axopen.simatic1500` (v0.43.0)
**Namespace:** `AXOpen.S71500`

## Classes

| Class | Implements | Description |
|-------|-----------|-------------|
| `Rtc` | `IAxoRtc` | Real-time clock. Reads and sets the PLC system clock in UTC. |
| `Rtm` | `IAxoRtm` | Runtime meter. Measures elapsed time since the PLC started. |

[!INCLUDE [Rtc](Rtc.md)]

[!INCLUDE [Rtm](Rtm.md)]
