# WORK IN PROGRESS

# Components

| REVISION |    DATE     |                 NOTES                 |
| -------- | ----------- | ------------------------------------- |
| 0.0      | June 2023   | Initial release                       |
| 0.1      | August 2023 | Initial release                       |
| 0.2      | August 2023 | Documentation requirements and others |


This document describes the format and practices for writing components in AXOpen. These are universal rules to observe. Each rule knows exception when there is a reasonable argument behind it.


## General rules

* Component must inherit from ```AXOpen.Core.AxoComponent```
* Components methods and properties should not be marked FINAL (sealed)
* Component should implement appropriate ```INTERFACE``` for a public contract; this is the interface that the consumers of the library will use to interact with the component. It represents the public contract that must not change during the lifetime of the particular major version of the library/framework. See [semantic versioning](https://semver.org/).
* Component members must explicitly state access modifier for methods and properties (```PUBLIC```, ```INTERNAL```, ```PROTECTED```, or ```PRIVATE```)
* Component should properly hide implementation details by marking methods preferably ```PROTECTED```.
* Consider using the ```PRIVATE``` access modifier to prevent any access to that member if you deem it necessary. Be aware, though, that private members cannot be overridden by a derived class.
* If there are any testing methods in the same library with the component, these must be marked ```INTERNAL```.
* Each action of the component should be implemented using the ```AxoTask``` class. This applies even to actions that require a single scan/cycle to complete (consistency + easy future extension). A task's `Invoke` should be wrapped by a PUBLIC method with an appropriate verb-based name (`MoveAbsolute`, `MoveHome`, `Measure`, ...).

### Cyclic call

Each component implements the logic required to run cyclically in one or more `Run` methods. Prefer pushing orchestration (deciding which component `Run` overload to call) to the parent context to keep components focused and testable.

### Components methods

The methods that perform actions **MUST** return `AXOpen.IAxoTaskState` (legacy docs may still mention `IAxoTaskStatus`). This rule applies even to logic that is, at present, single‑cycle.


## Library placement

Library must be placed in `src` folder of the repository. The containing folder should be named `components`.[manufacturer].[function_group] (e.g. components.cognex.vision).

### Abstractions

Each component should implement basic contract interface defined in the `AxoAbstractions` library (e.g. `AxoAbbRobot` should implenent `IAxoRobot`, `AxoCognexReader` should impement `IAxoReader`)

### I/O variables

- Components must not contain I/O (%I*, %Q*) variables directly (no AT directive).

#### I/O variables naming

The AxOpen does not use Hungarian prefixes, with few exceptions. IN/OUT and REF_TO method argument  parameters are one of those exceptions where it is required to use prefixes `ino` and `ref` respectively.

### Structure

#### Config

- Config structure can contain arbitrary data relative to the configuration of the component (timeouts, parameters, etc.).
- Config type must be STRUCT.
- Config data class must be named in the following format `{ComponentName}Config` (e.g. `AxoCylinderConfig`)
- Config class must be accessible via `GetConfig` method that returns `REF_TO {ComponentName}Config`.  
- The backing field of the Config property must be named `Config` (it must be public to allow access from higher level application) 
- Config class can contain multiple nested and complex classes when it is necessary to organize better the information. Nested classes must be CLASS and must be named in the following format `{ComponentName}Config{Specifier}` where specifier is descriptive name of the nested information.
- Wherever possible the data must be initialized to default values (e.g., timeouts, speeds etc.). The default settings should not prevent the component from functioning unless there is a specific requirement to provide parameters relative to the component model or a particular hardware configuration (drive model, gearing ratio, etc.).  
- Each data member of the Config structure must be documented in the code, with an example. Whenever possible, a link to more detailed documentation must also be provided in the in-code documentation.
- Method `SetConfig` should be implemented when it is expected an external provision of configuration at runtime.

### Status

- Status class can contain arbitrary data relative to the state of the component.
- Status type must be CLASS.
- Status data structure must be named in the following format `{ComponentName}Status` (e.g. `AxoCylinderStatus`)
- Status structure must be accessible via `GetStatus` method that returns `RET_TO {ComponentName}Status`.  - The backing field of the Status must be named `Status` (it must be public to allow access from higher level application).
- Status class can contain multiple nested and complex classes when it is necessary to organize the information. Nested structures must be CLASSEs and must be named in the following format `{ComponentName}State{Specifier}` where specifier is descriptive name of the nested information.  
- Each data member of the Status structure must be documented in the code, with an example. Whenever possible, a link to more detailed documentation must also be provided in the in-code documentation.

### Tasks

Operations are run by tasks (`AxoTask`).
- Member variable of the task must have the following format `{OperationName}Task`.
- Each task must be exposed via a method in the following format `{OperationName}` that will return `IAxoTaskState`.
- Executing logic of a task is run from the `Run` method of components class.

### States

States are properties or methods that retrieve information about arbitrary states that do not require multiple cycles to return the result (sensor's signal state).
All state-related members must be placed into `States` folder of the component.

### Component requirements

Each component must inherit from `AXOpen.Core.AxoComponent`, which is an abstract block that requires concrete implementation of following members: `Restore()` (resets internal state) and `ManualControl()` (manual operation logic while in service mode).

- `Restore()` must contain logic that brings the component's internal states into the initial state. It does NOT necessarily move hardware to a physical ground state; it prepares the software state machine.

- `ManualControl()` method is required to be implemented. It can contain arbitrary logic that will be executed while the component is in a serviceable state.

- Each component generally provides at least one `Run` method that performs: (1) IO/state refresh, (2) task invocation, (3) housekeeping (alarms, timers). `Run` is not enforced by the base class and may accept arguments for necessary external signals. Prefer smaller, intention‑revealing `Run` overloads vs. a monolithic method.

## Components naming conventions

The components for particular components are placed into appropriate library. Library name reflects the name of the manufacturer and the class of the product. POUs that belongs to a specific component reflect the product name and products' version information.


| UNIT NAME           | PATTERN                                          | EXAMPLE  (fully qualified name)                  |
|---------------------|-------------------------------------------------|--------------------------------------------------|
| Library (namespace) | `AXOpen.{Manufacturer}.[{Group}]`               | `AXOpen.ABB.Robotics`                            |
| CLASS               | `v_{ModelVersion}.Axo{Model}`                   | `AXOpen.ABB.Robotics.v_1_0_0.AxoOmnicore`        |
| CLASS Config        | `v_{ModelVersion}.Axo{Model}_Config`            | `AXOpen.ABB.Robotics.v_1_0_0.AxoOmnicore_Config` |
| CLASS Status        | `v_{ModelVersion}.Axo{Model}_Status`            | `AXOpen.ABB.Robotics.v_1_0_0.AxoOmnicore_Status` |
| other               | `v_{ModelVersion}.Axo{Model}_{DescriptiveName}` | `AXOpen.ABB.Robotics.v_1_0_0.AxoOmnicore_Aux`    |


## Testing requirements

- Each public and protected controller's method must be unit-tested using axunit.
- When reasonable use integration testing using `prober` library to test the interaction between controller and .NET twin. 

## Alarms & Messaging

Components should surface diagnostic and alarm information consistently:

* Use the framework messenger (e.g. `Messenger.Activate(id, category)`) rather than ad‑hoc BOOL flags.
* Reserve ID ranges per component family to avoid collisions (document the range in the component's header comment if non‑obvious).
* Expose current alarm / error state through the Status structure rather than additional public fields.
* When a task fails, prefer: set task state to error, raise messenger entry, populate `Status.Error` (ID + optional textual details) and allow the task to complete with a final state rather than blocking forever.

For UI auto‑rendering the alarm level icons provided by `AxoComponent` will reflect the highest active severity; ensure warnings are deactivated when condition clears to avoid stale visualization.

### Message Categories

The framework supports the following message categories (in order of severity):

* **None** (0): No category; used to clear requalification directives and ignore non-critical messages
* **Info** (100): Informative messages with minimal impact; do not require operator intervention
* **Potential** (150): Potential problems that may escalate to Warning or Error states; these messages can be automatically requalified based on system configuration when downstream conditions are detected
* **Warning** (200): Possible problems that may adversely affect a process; information to help identify problems but does not necessarily stop the process
* **Error** (300): Failures that cannot be immediately recovered; intervention is needed
* **Critical** (400): Critical system failures
* **ProgrammingError** (500): Implementation or configuration errors in the application

When using the `Potential` category, ensure that the parent context or sequencer is configured with appropriate requalification rules to escalate potential issues to `Warning` or `Error` when conditions persist.

### Message Requalification

For coordinated components and sequencers, message requalification allows upstream components to influence downstream message severity. Use `GetMessengerService().RequalifyDownstreamMessages(category)` to set the requalification category. This is particularly useful for:

* Escalating `Potential` messages to `Warning` or `Error` based on elapsed time
* Implementing hierarchical error response strategies in multi-step workflows
* Ensuring consistent severity handling across component hierarchies

Note: Only `Potential` messages are subject to requalification; other categories retain their configured severity.


## Documentation requirements

### Public classes

- Public and protected members (methods, fields) must have in code documentation. [See Documentation comments for more details](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/xmldoc/) and [docfx markup](https://dotnet.github.io/docfx/docs/markdown.html?q=referebce+code&tabs=linux%2Cdotnet).
- Public methods that implement actions and initialization must have application examples (reference actual app code). PLC examples should reside in `app/src/Documentation/` of the library folder, compilable (mock/omit hardware where required). .NET twin examples should be placed in `app/ix-blazor` and/or `app/ix`. For code snippet inclusion guidance see DocFX documentation.