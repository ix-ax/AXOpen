/// <summary>
/// Import the core functionality of AXOpen
/// </summary>
USING AXOpen.Core;
USING AXOpen.Core;

/// <summary>
/// Defines the AXOpen.Logging namespace
/// </summary>
NAMESPACE AXOpen.Logging              

    /// <summary>
    /// Defines the IAxoLogger interface
    /// This interface extends IAxoLoggerConfig
    /// </summary>
    INTERFACE PUBLIC IAxoLogger EXTENDS IAxoLoggerConfig                
        
        /// <summary>
        /// Defines the Log method
        /// This method takes a message, a log level, and a sender as input
        /// </summary>
        METHOD Log 
            VAR_INPUT
                /// <summary>
                /// _message is a string of maximum 80 characters that represents the log message
                /// </summary>
                _message : STRING[80];
                
                /// <summary>
                /// _level is an instance of eLogLevel that represents the level of the log
                /// </summary>
                _level : eLogLevel;
                
                /// <summary>
                /// _sender is an instance of IAxoObject that represents the sender of the log
                /// </summary>
                _sender : IAxoObject;
            END_VAR                         
        END_METHOD                
             
        /// <summary>
        /// Defines another Log method
        /// This method takes a message and a log level as input
        /// </summary>
        METHOD Log 
            VAR_INPUT
                /// <summary>
                /// _message is a string of maximum 80 characters that represents the log message
                /// </summary>
                _message : STRING[80];
                
                /// <summary>
                /// _level is an instance of eLogLevel that represents the level of the log
                /// </summary>
                _level : eLogLevel;                
            END_VAR                         
        END_METHOD       
    END_INTERFACE

    /// <summary>
    /// Defines the IAxoLoggerConfig interface
    /// </summary>
    INTERFACE IAxoLoggerConfig
        
        /// <summary>
        /// Defines the SetMinimumLevel method
        /// This method takes a log level as input and returns an instance of IAxoLoggerConfig
        /// </summary>
        METHOD SetMinimumLevel : IAxoLoggerConfig
            VAR_INPUT
                /// <summary>
                /// _level is an instance of eLogLevel that represents the minimum level of the log
                /// </summary>
                _level : eLogLevel;  
            END_VAR            
        END_METHOD
    END_INTERFACE
END_NAMESPACE
