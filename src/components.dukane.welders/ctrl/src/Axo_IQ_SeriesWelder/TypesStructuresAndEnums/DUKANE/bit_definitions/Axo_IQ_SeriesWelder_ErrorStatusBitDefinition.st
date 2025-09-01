NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_ErrorStatusBitDefinition
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Frequency_Overload_3#>"}
            Frequency_Overload_3 : BOOL;   // The resonant frequency of the ultrasonic stack drifted outside of the Frequency Bound limits
            {#ix-set:AttributeName = "<#_1#>"}
            _1 : BOOL;
            {#ix-set:AttributeName = "<#_2#>"}
            _2 : BOOL;
            {#ix-set:AttributeName = "<#_3#>"}
            _3 : BOOL;
            {#ix-set:AttributeName = "<#Under_Voltage_1#>"}
            Under_Voltage_1 : BOOL;   // The AC power line voltage is NOT within acceptable limits.
            {#ix-set:AttributeName = "<#_4#>"}
            _4 : BOOL;
            {#ix-set:AttributeName = "<#_5#>"}
            _5 : BOOL;
            {#ix-set:AttributeName = "<#_6#>"}
            _6 : BOOL;
            {#ix-set:AttributeName = "<#Over_Amplitude_Fault#>"}
            Over_Amplitude_Fault : BOOL;   // This bit will be set if the generator observes the Actual Amplitude to be over 100% in any Fixed Pulse Width operating mode.
            {#ix-set:AttributeName = "<#InternalError_5#>"}
            InternalError_5 : BOOL;   // An unrecoverable internal error has occurred.
            {#ix-set:AttributeName = "<#US_Voltage_Overload#>"}
            US_Voltage_Overload : BOOL;
            {#ix-set:AttributeName = "<#_11#>"}
            _11 : BOOL;
            {#ix-set:AttributeName = "<#_12#>"}
            _12 : BOOL;
            {#ix-set:AttributeName = "<#_13#>"}
            _13 : BOOL;
            {#ix-set:AttributeName = "<#_14#>"}
            _14 : BOOL;
            {#ix-set:AttributeName = "<#_15#>"}
            _15 : BOOL;
            {#ix-set:AttributeName = "<#Average_Overload#>"}
            Average_Overload : BOOL;   // The ultrasonic power output exceeded the generator’s power rating for the given amplitude.
            {#ix-set:AttributeName = "<#Current_Loop#>"}
            Current_Loop : BOOL;   // A remote analog input card is present and it is out of its 4-20 mA current loop range.
            {#ix-set:AttributeName = "<#Power_Not_OK#>"}
            Power_Not_OK : BOOL;   // The internal DC power line voltage is NOT within acceptable limits.
            {#ix-set:AttributeName = "<#Over_Temperature#>"}
            Over_Temperature : BOOL;   // The internal temperatures of the generator are not within acceptable limits.
            {#ix-set:AttributeName = "<#_20#>"}
            _20 : BOOL;
            {#ix-set:AttributeName = "<#_21#>"}
            _21 : BOOL;
            {#ix-set:AttributeName = "<#_22#>"}
            _22 : BOOL;
            {#ix-set:AttributeName = "<#_23#>"}
            _23 : BOOL;
            {#ix-set:AttributeName = "<#InternalError_1#>"}
            InternalError_1 : BOOL;   // An unrecoverable internal error has occurred.
            {#ix-set:AttributeName = "<#InternalError_2#>"}
            InternalError_2 : BOOL;   // An unrecoverable internal error has occurred.
            {#ix-set:AttributeName = "<#InternalError_3#>"}
            InternalError_3 : BOOL;   // An unrecoverable internal error has occurred.
            {#ix-set:AttributeName = "<#InternalError_4#>"}
            InternalError_4 : BOOL;   // An unrecoverable internal error has occurred.
            {#ix-set:AttributeName = "<#FrequencyOverload_1#>"}
            FrequencyOverload_1 : BOOL;   // The generator was unable to lock on to the proper ultrasonic frequency of the stack.
            {#ix-set:AttributeName = "<#Frequency_Overload_2#>"}
            Frequency_Overload_2 : BOOL;   // The generator was not able to maintain lock on the proper ultrasonic frequency.
            {#ix-set:AttributeName = "<#Peak_Overload_Positive#>"}
            Peak_Overload_Positive : BOOL;
            {#ix-set:AttributeName = "<#Peak_Overload_Negative#>"}
            Peak_Overload_Negative : BOOL;

        END_VAR 
    END_CLASS    
END_NAMESPACE