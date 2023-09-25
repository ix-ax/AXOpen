# AxoStep

AxoStep is an extension class of the AxoTask and provides the basics for the coordinated controlled execution of the task in the desired order based on the coordination mechanism used.

AxoStep contains the `Execute()` method so as its base class overloaded and extended by following parameters:

- coord (mandatory): instance of the coordination controlling the execution of the AxoStep.
- Enable (optional): if this value is `FALSE`, AxoStep body is not executed and the current order of the execution is incremented. 
- Description (optional): AxoStep description text describing the action the AxoStep is providing.

AxoStep class contains following public members:

- Order: Order of the AxoStep in the coordination. This value can be set by calling the method `SetStepOrder()` and read by the method `GetStepOrder()`.
- StepDescription: AxoStep description text describing the action the AxoStep is providing. This value can be set by calling the `Execute()` method with `Description` parameter.
- IsActive: if `TRUE`, the AxoStep is currently executing, or is in the order of the execution, otherwise `FALSE`. This value can be set by calling the method `SetIsActive()` and read by the method `GetIsActive()`.                   
- IsEnabled: if `FALSE`, AxoStep body is not executed and the current order of the execution is incremented. This value can be set by calling the method `SetIsEnabled()` or  calling the `Execute()` method with `Enable` parameter and read by the method `GetIsEnabled()`.   