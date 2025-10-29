NAMESPACE AXOpen.Messaging
    TYPE PUBLIC
        ///<summary>
        /// Message categories.
        /// ATTENTION: Values must be multiply of 100
        ///</summary>
        eAxoMessageCategory : INT
        (		                                   
            ///<summary>
            /// Info message.
            /// Use when you want to deliver information to the user, that has only informative character and does not adversely affect a process.
            ///</summary>
            Info := 100,
                            
            ///<summary>
            /// Warning message.
            /// Use this category when you want to report to the user an information about a possible problem, that may adversly affect a process.
            /// Information in this cateogory aims to help the user to identify a problem, the cause of such problem does not necessarily stops the process.
            ///</summary>
            Warning := 200,

            ///<summary>
            /// Error message.
            /// Use this categoty when there is a failure that cannot be immediately recovered and an intervention is needed. This is typically a situation when a device fails
            /// to deliver expected result. 
            /// Do not use this category to report information about failed process like measurement or detection.
            ///</summary>
            Error := 300,	
                        

            ///<summary>
            /// Programming error.
            /// Use this category to report programming errors, like invalid parameters, invalid state of the object etc.            
            ///</summary>
            ProgrammingError := 400,

            ///<summary>
            /// Critical error. 
            /// Use this category when a critical error occured, that is not recoverable by the means of software (reset/restore) but device still operates under such conditions; a detailed inspection and an expert action is required.
            ///</summary>
            Critical := 500            
        );
    END_TYPE
END_NAMESPACE
