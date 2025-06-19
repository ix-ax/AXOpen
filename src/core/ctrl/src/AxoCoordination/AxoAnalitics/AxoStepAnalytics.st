/// <summary>
/// Represents analytics data for a specific step in a process or sequence.
/// This structure is used to store and analyze information about individual steps,
/// including their execution order, duration, and description.
/// </summary>
STRUCT AxoStepAnalytics
{
    /// <summary>
    /// The execution order of the step. This is a identifier
    /// representing the sequence in which the step is executed.
    /// </summary>
    ULINT Order;

    /// <summary>
    /// The duration of the step execution, measured in long time (LTIME).
    /// This value represents the time taken to complete the step.
    /// </summary>
    LTIME Duration;

    /// <summary>
    /// A textual description of the step, providing additional context
    /// or details about its purpose or functionality.
    /// The description can be up to 120 characters long.
    /// </summary>
    STRING[120] Description;
}