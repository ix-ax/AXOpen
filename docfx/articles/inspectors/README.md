# **AXOpen.Inspectors**

**AXOpen.Inspectors** provides mechanism of inspection of different types of data. The input value is compared to required value. If input value is the same as required value for a *stabilization* time period, the inspection will succeed. If values are different, *timeout* will occur and inspection will fail.

Inspectors can integrate with coordination primitives like [AxoSequencer](../core/AXOSEQUENCER.md). In consequence, inspectors offer extended capabilities in decision flow for failed checks.

Each inspector contains:

1. `Inspect` method, which input is current parent and inspection variable
2. `OnFail` method, which provides methods for making a decision after a failed inspection (see Handling failure section)
3. `UpdateComprehensiveResult` method, which input is object of type `AxoComprehesiveResult`, which can be used to gather results of all inspections.

4. `Common data` about inspection inputs and result. See below.

## Example inspection
Example of inspection within a sequencer in PLC:
```
 _presenceInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionResult)
        .UpdateComprehensiveResult(_comprehensiveResult)
        .OnFail().CarryOn();
```

1. A _presenceInspector is created instance of `AxoDigitalInspector`

2. A coordinator is passed to this inspector with `WithCoordinator(THIS)` method, in this case it is a sequencer, a parent object.
3. `Inspect` methods takes parent and inspection variable, on which inspection is performing.
4. If inspection fails, the result is updated to `_comprehensiveResult` object with `UpdateComprehensiveResult` method.
5. If inspection fails, `OnFail` method provides `CarryOn` method, which tells the coordinator to continue in execution.

## Common inspector data

Inspectors contain common data, which are used to store data about inspection. Each inspector contain following data:

```C#
Timestamp: LDATE_AND_TIME; // timestamp of inspection

PassTime : TIME; // stabilization time, inspection must be success for this period of time

FailTime : TIME; // timeout, after which inspection fails

Result : eInspectorResult; // result of inspection

IsExcluded: BOOL; // inspection will be performed, however result will be omitted in overall result

IsByPassed : BOOL; // inspection will be skipped

NumberOfAllowedRetries : UINT; // maximum number of retries of inspection, from which overinspection will occur

RetryAttemptsCount : UINT; // actual number of retries, if RetryAttemptsCount > NumberOfAllowedRetries, overinspection occurs

```



[!INCLUDE [AxoDigitalInspector](AXODIGITALINSPECTOR.md)]

[!INCLUDE [AxoAnalogueInspector](AXOANALOGUEINSPECTOR.md)]

[!INCLUDE [AxoDataInspector](AXODATAINSPECTOR.md)]



## Handling failure

When an inspector fails, OnFail() provides a series of methods for making decisions about the process. In order for this is feature to work the inspector needs to be aware of the coordinator of `IAxoCoordinator`. The coordinator must be passed to the inspector by `WithCoordinator(coordinator)` method.


| Syntax                                | Description |
| -----------                           | ----------- |
| Dialog(inRetryStep, inTerminateStep)  | Opens dialog for the user to take a decision. Parameter `inRetryStep` represent state from which the inspection should start again. Parameter `inTerminateStep` represent terminate state of coordinator.                                       |
| Retry(inRetryStep)                    | Retries the inspector. Retry state parameter tells from which state the inspection should start again.                        |
| Override()                            | Marks the inspection as failed but continues with the following states of the coordinator.                                      |
| Terminate(inTerminateStep)            | Marks the inspection as failed and aborts the execution of the coordinator.                                          |

The following example specify, that when inspection fails, dialog is shown and is requesting user decision.

```
 _valueInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionValue).OnFail().Dialog(Steps[20], Steps[145]);
```

![Inspection failure](~/images/inspection-failure-dialog.png)   

## Over-inspection
When `RetryAttemptsCount` is same as `NumberOfAllowedRetries`, no more inspection are allowed, as data are overinspected.

![Overinspected](~/images/overinspected.png)


## Preserving overall result

Overall result of a series of inspections can be preserved in `AxoComprehensiveResult`. Each inspector has `UpdateComprehensiveResult` method that provides the update function. Once the `UpdateComprehensiveResult` marks the overall result as Failed, successive inspection will not overwrite the result. 

```

IF (Steps[30].Execute(THIS, TRUE, 'Example Digital inspection')) THEN

    _presenceInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionResult)
        .UpdateComprehensiveResult(_comprehensiveResult)
        .OnFail().CarryOn();

    END_IF;

    IF (Steps[40].Execute(THIS, TRUE, 'Example Analog inspection')) THEN

    _valueInspector.WithCoordinator(THIS).Inspect(THIS,_inspectionValue)
        .UpdateComprehensiveResult(_comprehensiveResult)
        .OnFail().CarryOn();

    END_IF;


END_IF;
```
