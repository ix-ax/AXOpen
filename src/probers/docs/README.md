# **AXOpen.Probers**

[!INCLUDE [General](../../../docfx/articles/notes/LIBRARYHEADER.md)]

**AXOpen.Probers** provides testing utilities for cyclic validation of component behavior in AXOpen applications. Probers are abstract task-based classes that allow you to define repeatable test routines executed within the PLC cycle, making it straightforward to verify that components behave correctly under controlled conditions.

The library contains two abstract prober classes, each suited to a different validation strategy:

- **AxoProberWithCounterBase** -- a prober that runs a user-defined number of cycles. It increments an internal counter on each execution cycle, calling the abstract `Test()` method each time, and completes automatically once the required number of cycles has been reached. This is useful when you need to validate behavior over a fixed number of iterations.

- **AxoProberWithCompletedCondition** -- a prober that runs until an external condition is satisfied. It calls the abstract `Test()` method each cycle, which returns a `BOOL` indicating whether the test is complete. The prober finishes when `Test()` returns `TRUE`. This is useful when completion depends on a dynamic runtime condition rather than a fixed count.

Both classes extend `AxoTask` from `AXOpen.Core` and follow the standard task lifecycle (invoke, execute, done/error). To use either prober, create a concrete class that extends the abstract base and implements the `Test()` method with your validation logic.

---
