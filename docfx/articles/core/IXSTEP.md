# IxStep

IxStep is an extension class of the IxTask and provides the basics for the coordinated controlled execution of the task in the desired order based on the coordination mechanism used.

IxStep contains the `Execute()` method so as its base class overloaded and extended by following parameters:

- coord (mandatory): instance of the coordination controlling the execution of the IxStep.
- Enable (optional): if this value is `FALSE`, IxStep body is not executed and the current order of the execution is incremented. 
- Description (optional): IxStep description text describing the action the IxStep is providing.

IxStep class contains following public members:

- Order: Order of the IxStep in the coordination. This value can be set by calling the method `SetSteoOrder()` and read by the method `GetStepOrder()`.
- StepDescription: IxStep description text describing the action the IxStep is providing. This value can be set by calling the `Execute()` method with `Description` parameter.
- IsActive: if `TRUE`, the IxStep is currently executing, or is in the order of the execution, otherwise `FALSE`. This value can be set by calling the method `SetIsActive()` and read by the method `GetIsActive()`.                   
- IsEnabled: if `FALSE`, IxStep body is not executed and the current order of the execution is incremented. This value can be set by calling the method `SetIsEnabled()` or  calling the `Execute()` method with `Enable` parameter and read by the method `GetIsEnabled()`.   