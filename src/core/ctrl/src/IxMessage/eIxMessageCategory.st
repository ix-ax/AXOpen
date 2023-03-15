NAMESPACE ix.framework.core
    TYPE PUBLIC
        ///<summary>
        /// Message categories.
        /// ATTENTION: Values must be multiply of 100
        ///</summary>
        eIxMessageCategory : INT
        (		
            All := 0,

            ///<summary>
            /// Trace message to be used for tracing purpose.
            /// Use when you need to track detailed information about internal states of the program for detailed visibility. 
            /// This is lowest level of category that can be used in production, for detailed observation of PLC program.
            ///</summary>
            Trace := 100,

            ///<summary>
            /// Debug message to be used for debugging purpose only.
            /// Use when you need to report debug information for you as programmer. 
            ///</summary>
            Debug := 200,

            ///<summary>
            /// Info message.
            /// Use when you want to deliver information to the user, that has only informative character and does not adversely affect a process.
            ///</summary>
            Info := 300,
    
            ///<summary>
            /// Time-out message.
            /// Use this category when you want to report a timed-out information, that may eventually succed.
            ///</summary>
            TimedOut := 400,

            ///<summary>
            /// Notification message.
            /// Use this category when you want to report a notification that may be of interest to the user, but does not adversly affect a process.
            ///</summary>
            Notification := 500,

            ///<summary>
            /// Warning message.
            /// Use this category when you want to report to the user an information about a possible problem, that may adversly affect a process.
            /// Information in this cateogory aims to help the user to identify a problem, the cause of such problem does not necessarily stops the process.
            ///</summary>
            Warning := 600,

            ///<summary>
            /// Error message.
            /// Use this categoty when there is a failure that cannot be immediately recovered and an intervention is needed. This is typically a situation when a device fails
            /// to deliver expected result. 
            /// Do not use this category to report information about failed process like measurement or detection.
            ///</summary>
            Error := 700,	

            ///<summary>
            /// Programming issue.
            /// Use this category to inform about a possible programming error, defect in settings or missing information at a level of programming or system or process settings. 
            ///</summary>
            ProgrammingError := 900,
            
            ///<summary>
            /// Critical error. 
            /// Use this category when a critical error occured, that is not recoverable by the means of software (reset/restore) and but device still operates under such conditions; a detailed inspection and an expert action is required.
            ///</summary>
            Critical := 1000,
            
            ///<summary>
            /// Fatal error. 
            /// Use this category when a fatal error occured, that is not recoverable by the means of software (reset/restore) and a detailed inspection is required, the device is not able to continue without special intervention,
            ///</summary>
            Fatal    := 1100,
                
            ///<summary>
            /// Catastrophic error. 
            /// Use this category when there is a situation when the device cannot continue operations due to irrecoverable failure.
            ///</summary>
            Catastrophic := 1200,
            
            None := 32000
        );
    END_TYPE
END_NAMESPACE