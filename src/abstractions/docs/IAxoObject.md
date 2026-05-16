# IAxoObject

`IAxoObject` is the base contract for all AXOpen objects. Every object that participates in the AXOpen framework implements this interface, which provides a unique identity, access to the parent context, parent object traversal, message aggregation, and a validity check.

## Methods

| Method | Return Type | Description |
|---|---|---|
| `GetIdentity()` | `ULINT` | Returns the unique numeric identity assigned to this object by its context. |
| `GetContext()` | `IAxoContext` | Returns a reference to the context that owns this object. |
| `GetContextUnsafe()` | `IAxoContext` | Returns the context reference without safety checks. |
| `GetParent()` | `IAxoObject` | Returns a reference to the immediate parent object in the object hierarchy. |
| `AggregateMessage(inCount)` | -- | Aggregates a message count from child objects for upstream reporting. |
| `IsValid()` | `BOOL` | Returns whether this object is in a valid state. |

## Usage

The following example demonstrates retrieving the identity of an `AxoObject` through the `IAxoObject` interface:

[!code-smalltalk[](../../showcase/app/src/abstractions/AbstractionsShowcase.st?name=IAxoObjectUsage)]
