NAMESPACE AXOpen.Messaging
    /// <summary>
    /// Message digest methods used to create fingerprint of a message.							
    /// </summary>			
    TYPE eAxoMessageDigestMethod : INT
    (	
        /// <summary>
        /// Fastest method with highest probability of colisions.							
        /// </summary>			
        CRC8 := 8,

        /// <summary>
        /// Moderate speed method with lower probability of colisions.							
        /// </summary>			
        CRC16 := 16,

        /// <summary>
        /// Slowest speed method with relatively low probability of colisions.							
        /// </summary>			
        CRC32 := 32,
        
        /// <summary>
        /// Messages are not digested the repeated messages won't be filtered out. 
        /// Use this option on low performance devices. 			
        /// </summary>			
        NONE := 32767
    );
    END_TYPE
END_NAMESPACE




