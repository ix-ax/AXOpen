# Enumerations

AXOpen.Abstractions defines two enumerations used throughout the framework for logging and messaging.

## eLogLevel

**Namespace:** `AXOpen.Logging`

Defines the severity level of log entries. Used by `IAxoLogger` and `IAxoLoggerConfig` to filter and categorize log output.

| Value | Ordinal | Description |
|---|---|---|
| `NoCat` | 0 | No category assigned to the log level. |
| `Verbose` | 1 | Verbose output, typically enabled only for debugging. Traffic is usually very high. |
| `Debug` | 2 | Internal system events that are not necessarily observable from the outside. |
| `Information` | 3 | General application flow tracking. These logs should have long-term value. |
| `Warning` | 4 | Abnormal or unexpected events that do not necessarily stop the application. |
| `Error` | 5 | Errors and exceptions that cannot be handled, resulting in premature termination. |
| `Fatal` | 6 | Catastrophic failures that require immediate attention. |

[!code-smalltalk[](../../showcase/app/src/abstractions/AbstractionsShowcase.st?name=LogLevelUsage)]

## eAxoMessageCategory

**Namespace:** `AXOpen.Messaging`

Defines the category of messages used by the AXOpen messaging system. Values are multiples of 100 (except `Potential` at 150) to allow for future intermediate categories.

| Value | Ordinal | Description |
|---|---|---|
| `None` | 0 | No category. The message has no importance and should be ignored by the system. Do not use this for messages that must reach the user. |
| `Info` | 100 | Informative message that does not adversely affect a process. |
| `Potential` | 150 | A potential problem that does not necessarily affect a process but may cause one. Typically used for conditions expected to happen within a process that have not yet occurred; intended to be automatically requalified to Warning or Error by a coordination primitive if the conditions are not met in time. |
| `Warning` | 200 | A possible problem that may adversely affect a process. Helps the user identify a problem whose cause does not necessarily stop the process. |
| `Error` | 300 | A failure that cannot be immediately recovered and requires intervention. Typically a device failing to deliver an expected result. Do not use this to report failed measurements or detections. |
| `ProgrammingError` | 400 | Programming errors such as invalid parameters or invalid object state. |
| `Critical` | 500 | A critical error that is not recoverable by software (reset/restore) while the device still operates. Requires detailed inspection and expert action. |

[!code-smalltalk[](../../showcase/app/src/abstractions/AbstractionsShowcase.st?name=MessageCategoryUsage)]
