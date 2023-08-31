NAMESPACE AXOpen.Logging
    /// <summary>
    /// Enum eLogLevel defines the level of the log entry.
    /// </summary>
    TYPE PUBLIC
        eLogLevel : INT (
            /// <summary>
            /// No category is assigned to the log level.
            /// </summary>
            NoCat := 0, 

            /// <summary>
            /// Verbose level log is usually only enabled for debugging. Traffic is typically very high.
            /// </summary>
            Verbose := 1, 

            /// <summary>
            /// Debug level log is used for internal system events that are not necessarily observable from the outside.
            /// </summary>
            Debug  := 2, 

            /// <summary>
            /// Information level log is used to track the general flow of the application. These logs should have long-term value.
            /// </summary>
            Information  := 3, 

            /// <summary>
            /// Warning level log is used for abnormal or unexpected events in the application flow, which does not necessarily cause the application to stop.
            /// </summary>
            Warning  := 4, 

            /// <summary>
            /// Error level log is used for errors and exceptions that cannot be handled. These result in a premature termination.
            /// </summary>
            Error  := 5, 

            /// <summary>
            /// Fatal level log is used to indicate a catastrophic failure that requires immediate attention.
            /// </summary>
            Fatal  := 6) := NoCat;
    END_TYPE
END_NAMESPACE
