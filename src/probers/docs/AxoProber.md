# AxoProber

AXOpen.Probers provides two abstract prober classes for cyclic validation of component behavior. Both extend `AxoTask` and must be subclassed with a concrete `Test()` implementation.

## Overview

Probers are designed for scenarios where you need to repeatedly exercise a piece of logic over multiple PLC cycles and verify its behavior. The two prober types differ in how they determine when the test is complete:

- **AxoProberWithCounterBase** -- completes after a configurable number of cycles.
- **AxoProberWithCompletedCondition** -- completes when the `Test()` method returns `TRUE`.

## AxoProberWithCounterBase

This prober maintains two public variables:

| Variable | Type | Description |
|---|---|---|
| `RequredNumberOfCycles` | `ULINT` | The number of cycles the prober should execute before completing. |
| `CurrentCyclesCount` | `ULINT` | The current cycle count, incremented automatically each execution cycle. |

On each cycle where `Execute()` returns `TRUE`, the prober increments `CurrentCyclesCount`, calls the abstract `Test()` method, and checks whether `CurrentCyclesCount >= RequredNumberOfCycles`. When that condition is met, the task enters the `Done` state.

The `OnRestore()` method resets both `CurrentCyclesCount` and `RequredNumberOfCycles` to zero.

To use this prober, extend it and implement the `Test()` method with your validation logic.

## AxoProberWithCompletedCondition

This prober does not use a counter. Instead, on each cycle where `Execute()` returns `TRUE`, it calls the abstract `Test()` method, which must return a `BOOL`. When `Test()` returns `TRUE`, the task enters the `Done` state via `DoneWhen()`.

To use this prober, extend it and implement the `Test()` method. Return `TRUE` from `Test()` when your validation condition is satisfied.

## Usage

Both probers are initialized and run by calling the `Run(inParent)` method cyclically, passing the parent `IAxoObject`.

### CONTROLLER

#### Declarations

[!code-smalltalk[](../../showcase/app/src/probers/ProbersShowcase.st?name=ProberDeclarations)]

#### Counter-based prober example

[!code-smalltalk[](../../showcase/app/src/probers/ProbersShowcase.st?name=CounterProberExample)]

#### Condition-based prober example

[!code-smalltalk[](../../showcase/app/src/probers/ProbersShowcase.st?name=ConditionProberExample)]

#### Running probers

[!code-smalltalk[](../../showcase/app/src/probers/ProbersShowcase.st?name=ProberUsage)]
