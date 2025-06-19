
NAMESPACE AXOpen.Core

    /// <summary>
    /// Represents analytics data for a specific step in a process or sequence.
    /// This structure is used to store and analyze information about individual steps,
    /// including their execution order, duration, and description.
    /// </summary>
    TYPE
        {S7.extern=ReadWrite} 
        AxoStepAnalytics :
         STRUCT 
            /// <summary>
            /// The execution order of the step. This is a identifier
            /// representing the sequence in which the step is executed.
            /// </summary>
            Order : ULINT ;

            /// <summary>
            /// The duration of the step execution, measured in long time (LTIME).
            /// This value represents the time taken to complete the step.
            /// </summary>
            Duration : LTIME ;

            /// <summary>
            /// A textual description of the step, providing additional context
            /// or details about its purpose or functionality.
            /// The description can be up to 120 characters long.
            /// </summary>
            Description :STRING[120] ;
        END_STRUCT;
    END_TYPE

END_NAMESPACE
