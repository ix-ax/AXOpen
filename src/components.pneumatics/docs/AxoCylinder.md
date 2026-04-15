# AxoCylinder

*Pneumatic cylinder component with two positions (in / out), task-driven movement, sensor feedback, and suspend / abort control.*

The `AxoCylinder` class models a double-acting pneumatic cylinder exposing three
tasks — `MoveIn`, `MoveOut`, `Stop` — along with suspend and abort helpers. It
observes two position sensors (`InSensor`, `OutSensor`) and drives two valve
signals (`MoveInSignal`, `MoveOutSignal`). The component integrates with
`AxoMessenger` to surface categorized runtime messages (busy, done-without-sensor,
sensor-conflict, suspend, abort).

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st?name=ComponentDeclaration)]

## Declare initialization variables

[!code-pascal[](../../showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st?name=Usage)]

## Suspend / Abort helpers

[!code-pascal[](../../showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st?name=SuspendMoveToInWhile)]
[!code-pascal[](../../showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st?name=SuspendMoveToOutWhile)]
[!code-pascal[](../../showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st?name=AbortMoveToHomeWhen)]
[!code-pascal[](../../showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st?name=AbortMoveToWorkWhen)]

# [BLAZOR](#tab/blazor)

## How to visualize `AxoCylinder`

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-pneumatics/Documentation/PneumaticsShowcase.razor?name=GenericComponentStatusView)]
[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-pneumatics/Documentation/PneumaticsShowcase.razor?name=GenericComponentCommandView)]

## Dedicated `AxoCylinderView`

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-pneumatics/Documentation/PneumaticsShowcase.razor?name=AxoCylinderStatusView)]
[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-pneumatics/Documentation/PneumaticsShowcase.razor?name=AxoCylinderCommandView)]

***
