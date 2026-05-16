# IAxoAxisReference

_Marker interface for drive axis references._

## Description

`IAxoAxisReference` (namespace `AXOpen.Components.Abstractions.Drives`) is an empty marker interface. Concrete drive libraries use it to type their vendor-specific axis reference (the handle / MC_AXIS_REF equivalent) in a vendor-agnostic way, so that application code can hold `IAxoAxisReference` and pass it to drive components without depending on a particular vendor's axis-handle type.

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoDrives/IAxoAxisReference.st`.
