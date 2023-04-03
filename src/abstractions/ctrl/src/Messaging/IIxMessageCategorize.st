NAMESPACE ix.framework.messaging
    INTERFACE IIxMessageCategorize 
		/// <summary>
        /// Categorizes and creates the message as 'debug'.								 
		/// </summary>		
        METHOD AsDebug : IIxMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'error'.								 
		/// </summary>		
        METHOD AsError : IIxMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'fatal'.								 
		/// </summary>		
        METHOD AsFatal : IIxMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'info'.								 
		/// </summary>		
        METHOD AsInfo : IIxMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'trace'.								 
		/// </summary>		
        METHOD AsTrace : IIxMessageProperties END_METHOD

		/// <summary>
        /// Categorizes and creates the message as 'warning'.								 
		/// </summary>		
        METHOD AsWarning : IIxMessageProperties END_METHOD
    END_INTERFACE
END_NAMESPACE
