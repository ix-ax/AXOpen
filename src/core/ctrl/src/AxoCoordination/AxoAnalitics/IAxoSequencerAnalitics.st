NAMESPACE AXOpen.Core
    /// <summary>
    /// Interface for managing and analyzing sequencer statistics.
    /// Provides methods to update step information, restart statistics collection,
    /// and control data collection for sequencers.
    /// </summary>
    INTERFACE PUBLIC IAxoSequencerAnalitics
        /// <summary>
        /// Updates the analytics data for a specific step in the sequencer.
        /// This method processes the provided step and updates its associated statistics.
        /// </summary>
        /// <param name="_step">The step whose analytics data needs to be updated.</param>
        METHOD UpdateAnalytics
            VAR_IN_OUT
                _step : AxoStep;
            END_VAR
        END_METHOD 
        
        /// <summary>
        /// Restarts the statistics collection mechanism.
        /// This method clears any existing data and prepares the system for fresh data collection.
        /// </summary>
        METHOD Restart            
        END_METHOD 
        
        /// <summary>
        /// Starts the data collection process for sequencer statistics.
        /// Returns a boolean value indicating whether the data collection was successfully started.
        /// </summary>
        /// <returns>True if data collection starts successfully; otherwise, false.</returns>
        METHOD CollectData : BOOL END_METHOD
    END_INTERFACE    
END_NAMESPACE