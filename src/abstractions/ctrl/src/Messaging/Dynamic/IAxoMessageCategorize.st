NAMESPACE AXOpen.Messaging.Dynamic
    INTERFACE IAxoMessageCategorize 
		/// <summary>
        /// Categorizes and creates the message as 'debug'.								 
		/// </summary>		
        METHOD AsDebug : IAxoMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'error'.								 
		/// </summary>		
        METHOD AsError : IAxoMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'fatal'.								 
		/// </summary>		
        METHOD AsFatal : IAxoMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'info'.								 
		/// </summary>		
        METHOD AsInfo : IAxoMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'trace'.								 
		/// </summary>		
        METHOD AsTrace : IAxoMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'warning'.								 
		/// </summary>		
        METHOD AsWarning : IAxoMessageProperties END_METHOD
    END_INTERFACE
END_NAMESPACE
