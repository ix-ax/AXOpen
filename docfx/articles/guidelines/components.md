# WORK IN PORGRESS

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
* Each action of the component should be implemented using the ```AxoTask``` class. There is no exception to this rule, even for the actions that require a single cycle to complete. Task's ```Invoke``` should be placed into a method with an appropriate name (MoveAbsolute, MoveHome, Measure).

### Cyclic call

Each component implements the logic required to run cyclically in the *Run* method of the CLASS. 

### Components methods

The methods that perform actions **MUST** return ```AXOpen.IAxoTaskStatus``` (typically ```AXOpen.Core.AxoTask```). This rule applies even to the logic that requires a single-cycle execution.


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
- Each task must be exposed via a method in the following format `{OperationName}` that will return `IAxoTaskStatus`.
- Executing logic of a task is run from the `Run` method of components class.

### States

States are properties or methods that retrieve information about arbitrary states that do not require multiple cycles to return the result (sensor's signal state).
All state-related members must be placed into `States` folder of the component.

### Component requirements

Each component must inherit from `AXOpen.Core.AxoComponent`, which is an abstract block that requires concrete implementation of following memebers: `Restore()` method that restores the component into intial state and `ManualControl()` method that provided additional logic for manual control.

- `Restore()` must contain logic that will bring the component's internal states into the initial state. Restore method does not mean getting the component into physical ground position/state; it serves purely the purpose of having the component ready for operations from the programatic perspective.

- `ManualControl()` method is required to be implemented. It can contain arbitrary logic that will be executed while the component is in a serviceable state.

- Each component must implement `Run` method that will provide cyclic execution of tasks, I/O update, data transformation for given component. `Run` method is not formally required by `AxoComponent` and it can take arguments necessary for the cylic update and execution. For variaous scenarions component can implement different `Run` methods taking advantage of method overload.

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


## Documentation requirements

### Public classes

- Public and protected members (methods, fields) must have in code documentation. [See Documentation comments for more details](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/xmldoc/) and [docfx markup](https://dotnet.github.io/docfx/docs/markdown.html?q=referebce+code&tabs=linux%2Cdotnet).
- Public methods than implement actions and initialization must have application examples (should be referenced from the actuall app code). PLC Application examples should be placed in `app/src/Documentation/` of the library folder, the code should be compilable and functional to the extent it is possible with ommited hardware. NET twin examples should be places in `app/ix-blazor` and `app/ix` folder. For details how to reference code snippet [see here](https://dotnet.github.io/docfx/docs/markdown.html?q=referebce+code&tabs=linux%2Cdotnet#code-snippet).