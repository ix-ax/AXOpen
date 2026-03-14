NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_IV3_CommandControl
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Trigger request#>"}
            TriggerRequest                              : BOOL;                         //  QB0.0
            {#ix-set:AttributeName = "<#Master registration request#>"}
            MasterRegistrationRequest                   : BOOL;                         //  QB0.1
            {#ix-set:AttributeName = "<#Program switching request#>"}
            ProgramSwitchingRequest                     : BOOL;                         //  QB0.2
            {#ix-set:AttributeName = "<#Warning clear request#>"}
            WarningClearRequest                         : BOOL;                         //  QB0.3
            {#ix-set:AttributeName = "<#Statistics reset request#>"}
            StatisticsResetRequest                      : BOOL;                         //  QB0.4
            {#ix-set:AttributeName = "<#Buffer clear request#>"}
            BufferClearRequest                          : BOOL;                         //  QB0.5
            {#ix-set:AttributeName = "<#SD card saving stop request#>"}
            SdCardSavingStopRequest                     : BOOL;                         //  QB0.6
            {#ix-set:AttributeName = "<#Setting value change request#>"}
            SettingValueChangeRequest                   : BOOL;                         //  QB0.7
            {#ix-set:AttributeName = "<#Result acquisition complete notification#>"}
            ResultAcquisitionCompleteNotification       : BOOL;                         //  QB2.0
            {#ix-set:AttributeName = "<#Program number#>"}
            ProgramNo                                   : UINT;                         //  QW4
            {#ix-set:AttributeName = "<#Function 1: Limit set.no.(no OCR)/Master text set.no.(OCR)/FTP/SD-saved set.no.(FTP client/SD card saving function)#>"}
            Function_1                                  : WORD;                         //  QW6
            {#ix-set:AttributeName = "<#Function 2: Limit set.no.(no OCR)/Master text/number of letters(OCR)/FTP/SD-saving settings(FTP client/SD card saving function)#>"}
            Function_2                                  : DWORD;                        //  QD8
        END_VAR 
    END_CLASS    
END_NAMESPACE