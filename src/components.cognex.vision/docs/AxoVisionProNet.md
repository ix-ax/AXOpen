# AxoVisionProNet

_Cognex VisionPro vision system over a TCP/.NET remote-task channel_

`AxoVisionProNet` is a TCP/.NET alternative to the PROFINET-based [`AxoVisionPro`](AxoVisionPro.md).
Instead of exchanging data through a PROFINET IO frame, it drives the VisionPro PC
through `AxoRemoteTask`s whose handlers run on the .NET twin and talk to the camera
over a TCP socket. Use this variant when the vision PC is reachable over the network
but is not wired as a PROFINET device.

## Configuration

The `Config` struct (read-only at runtime) holds the task supervision timers:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `InfoTime` | `LTIME` | `LT#5S` | Delay before an informational state is raised. |
| `ErrorTime` | `LTIME` | `LT#10S` | Delay before a stalled exchange is flagged as an error. |
| `TaskTimeout` | `LTIME` | `LT#50S` | Maximum time a remote task may run before timing out. |

The writable `Control` struct carries the request parameters sent to the vision PC
on every call:

| Parameter | Type | Description |
|-----------|------|-------------|
| `TriggerId` | `INT` | Identifier correlating a trigger with its inspection result. |
| `PartId` | `STRING` | Part being inspected. |
| `VariantId` | `STRING` | Recipe / product variant selected on the camera. |

## Status

| Field | Type | Description |
|-------|------|-------------|
| `Accepted` | `BOOL` | Last exchange was acknowledged by the vision PC. |
| `TriggerId` | `INT` | `TriggerId` echoed back with the result. |
| `ErrorCode` | `INT` | Non-zero when an exchange failed; `0` after `Restore()`. |
| `ActionDescription` | `STRING` | Human-readable description of the current action. |
| `ErrorDescription` | `STRING` | Detail copied from the failing task's `ErrorDetails`. |
| `RejectReason` | `STRING` | Reason a part was rejected by the inspection. |

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionProNet.st?name=ComponentDeclaration)]

## Declare initialization variables

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionProNet.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionProNet.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionProNet.st?name=Usage)]

## Usage in UnitTemplate (declaration and sequence)

The process template `axopen.template.simple` contains a practical integration of `AxoVisionProNet` in:

- `ax/src/Units/UnitTemplate/Components/Components.st`
- `ax/src/Units/UnitTemplate/Modes/Auto/AutoSequence.st`

### Declaration in Components class

```st
VAR PUBLIC
	{#ix-set:DeviceIpAddress = "192.168.100.103"}
	{#ix-set:Proxy = "inspection1"}
	VisionProNet : VisionProCamUnitTemplate;

	{#ix-set:DeviceIpAddress = "192.168.100.103"}
	{#ix-set:Proxy = "inspection2"}
	VisionProNetSecond : AXOpen.Components.Cognex.Vision.AxoVisionProNet;
END_VAR
```

`VisionProCamUnitTemplate` extends `AxoVisionProNet` and adds a strongly typed payload (`Payload.Data`).

### Cyclic run

```st
METHOD PUBLIC OVERRIDE Run
	VAR_INPUT
		inParent : AXOpen.Core.IAxoObject;
	END_VAR

	SUPER.Run(inParent);
	VisionProNet.Run(THIS);
	VisionProNetSecond.Run(THIS);
END_METHOD
```

### Automatic sequence usage

Set recipe:

```st
IF (Steps[1].Execute(THIS, TRUE, '<#SET RECIPE#>')) THEN
	THIS.X^.C.VisionProNet.Control.VariantId := 'default';
	IF(THIS.X^.C.VisionProNet.SetRecipe().IsDone()) THEN
		THIS.MoveNext();
	END_IF;
END_IF;
```

Send specific data:

```st
IF (Steps[2].Execute(THIS, TRUE, '<#SET SPECIFIC DATA#>')) THEN
	THIS.X^.C.VisionProNet.Payload.Data.PlcData.Carrier := '123456789';
	IF(THIS.X^.C.VisionProNet.SendSpecificData().IsDone()) THEN
		THIS.MoveNext();
	END_IF;
END_IF;
```

Trigger inspection:

```st
IF (Steps[3].Execute(THIS, TRUE, '<#TRIGGER#>')) THEN
	THIS.X^.C.VisionProNet.Control.TriggerId := THIS.X^.C.VisionProNet.Control.TriggerId + 1;
	THIS.X^.C.VisionProNet.Control.PartId := 'ABCDDMC123456789';

	IF(THIS.X^.C.VisionProNet.Trigger().IsDone()) THEN
		THIS.RequestStep(Steps[3]);
		THIS.X^.C.VisionProNet.Restore();
	END_IF;
END_IF;
```

Receive results:

```st
IF (Steps[4].Execute(THIS, TRUE, '<#READ SPECIFIC DATA#>')) THEN
	IF(THIS.X^.C.VisionProNet.ReceiveSpecificData().IsDone()) THEN
		THIS.MoveNext();
	END_IF;
END_IF;
```

This pattern keeps all `AxoVisionProNet` calls step-driven and non-blocking through `IsDone()` checks.

## Manual control

*The commissioning task `SendSpecificDataAndTypes` is enabled only while manual control is active.*

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionProNet.st?name=VisionProNetManualControl)]

## Commissioning

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionProNet.st?name=VisionProNetCommissioning)]

## Error recovery

*Each remote task is checked for `HasRemoteException`; recovery calls `Restore()` to clear `ErrorCode` and re-arm the tasks.*

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionProNet.st?name=VisionProNetErrorRecovery)]

## Source

View the library source at [`AxoVisionProNet`](https://github.com/Inxton/AXOpen/tree/1104-new-featureaxovisionpro-alternative/src/components.cognex.vision/ctrl/src/AxoVisionProNet/).

# [.NET TWIN](#tab/twin)

`AxoVisionProNet` relies on its .NET twin for connectivity. The component's tasks are
`AxoRemoteTask`s: the PLC `Invoke()`s them and the .NET side executes the handler that
exchanges data with the vision PC over TCP. The TCP socket must be opened once during
host start-up by calling `InitializeVisionClientAsync(host, port)` on the twin.

## TCP client initialization

[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Program.cs?name=AxoVisionProNetInitialize)]

### Assumed UnitTemplate initialization

If your UnitTemplate contains two VisionProNet components (`VisionProNet` and `VisionProNetSecond`), initialize both clients during twin startup (for example in `TwinConfigurationServices`) using separate ports:

```csharp
 await Entry.Plc.Ctx.UnitTemplate.X.C.VisionProNet.InitializeVisionClientAsync("192.168.100.103", 8500,AXOpen.Components.Cognex.Vision.VisionProtocol.VisionConnectionMode.PerRequest);
 await Entry.Plc.Ctx.UnitTemplate.X.C.VisionProNetSecond.InitializeVisionClientAsync("192.168.100.103", 8501,AXOpen.Components.Cognex.Vision.VisionProtocol.VisionConnectionMode.PerRequest);
```

Use one TCP endpoint per camera/session.

## Source

View the .NET twin source at [`AXOpen.Components.Cognex.Vision`](https://github.com/Inxton/AXOpen/tree/1104-new-featureaxovisionpro-alternative/src/components.cognex.vision/src/AXOpen.Components.Cognex.Vision/).

# [BLAZOR](#tab/blazor)

`AxoVisionProNet` ships a dedicated Blazor view, `AxoVisionProNetView`, in the
`AXOpen.Components.Cognex.Vision.blazor` package. It builds on `AxoComponentContainerView`
and exposes the `AxoVisionProNetStatusView`, `AxoVisionProNetCommandView`, and
`AxoVisionProNetSpotView` derivatives. `RenderableContentControl` inspects the component
type at runtime and selects the matching derivative based on the `Presentation` attribute,
so the generic rendering below resolves to the dedicated view automatically.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-cognex-vision/Documentation/CognexVision.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-cognex-vision/Documentation/CognexVision.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-cognex-vision/Documentation/CognexVision.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-cognex-vision/Documentation/CognexVision.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Cognex.Vision.blazor`](https://github.com/Inxton/AXOpen/tree/1104-new-featureaxovisionpro-alternative/src/components.cognex.vision/src/AXOpen.Components.Cognex.Vision.blazor/).

---
