NAMESPACE AXOpen.Logging
    /// <summary>
    /// AxoLogEntry class represents a single log entry.
    /// </summary>
    CLASS PUBLIC AxoLogEntry
        VAR PUBLIC
            /// <summary>
            /// The message of the log entry. The maximum length of the message is 80 characters.
            /// </summary>
            Message : STRING[80];

            /// <summary>
            /// The severity level of the log entry.
            /// </summary>
            Level : eLogLevel; 

            /// <summary>
            /// The identifier of the sender of the log entry.
            /// </summary>
            Sender : ULINT;                

            /// <summary>
            /// Indicates whether the log entry is ready to be dequeued.
            /// </summary>
            ToDequeue : BOOL;       
        END_VAR             
    END_CLASS
END_NAMESPACE
