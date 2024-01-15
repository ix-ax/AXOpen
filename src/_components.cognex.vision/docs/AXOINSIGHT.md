## AxoInsight

`AxoInsight` provides the essential control and operation of all vision sensors of the `Insight` family.

# How to

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Implementation
The `AxoInsight` is designed to be used as a member of the `AxoContext` or `AxoObject`.
Therefore its instance must be initialized with the proper `AxoContext` or `AxoObject` before any use. 
Also, the hardware signals must be assigned first before calling any method of this instance. 
To accomplish this, call the `Run` method cyclically with the proper variables (i.e. inside the `Main` method of the relevant `AxoContext`) as in the example below:

## Declare component

[!code-smalltalk[](../app/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionExample.st?name=InsightDeclaration)]

## Manual Control

[!code-smalltalk[](../app/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionExample.st?name=InsightManualControl)]

## Initialize & Run

[!code-smalltalk[](../app/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionExample.st?name=InsightInitialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

There are three public methods to operate the `AxoInsight`:

`Restore` - restores the state of the `AxoInsight` to the initial state and resets all the internal variables.

`ClearInspectionResults` - resets the inspection data read and confirms the data received from the device.
**Example of using ClearInspectionResults method**
[!code-smalltalk[](../app/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionExample.st?name=CognexInsightClearInspectionResults)]

`Trigger` - triggers the reading sequence and waits for results.
**Example of using Trigger method**
[!code-smalltalk[](../app/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionExample.st?name=CognexInsightTrigger)]

`ChangeJob` - changes the sensor job. There are two overloads of the method `ChangeJob`. First one is with numerical parameter of the job number, second one with the textual parameter of the job name. 
**Example of using ChangeJob method using job number**
[!code-smalltalk[](../app/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionExample.st?name=CognexInsightChangeJobByNumber)]
**Example of using ChangeJob method using job name**
[!code-smalltalk[](../app/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionExample.st?name=CognexInsightChangeJobByName)]

`SoftEvent` - triggers the soft event of the sensor.
**Example of using SoftEvent method**
[!code-smalltalk[](../app/src/Examples/AXOpen.Cognex.Vision/AxoCognexVisionExample.st?name=CognexInsightSoftEvent)]

# [.NET TWIN](#tab/twin)



# [BLAZOR](#tab/blazor)

**How to visualize `AxoInsight`**
On the UI side, use the `RenderableContentControl` and set its Context according to the placement of the instance of the `AxoInsight`.
[!code-csharp[](../app/ix-blazor/Pages/Documentation.razor?name=CognexInsightRenderedView)]
