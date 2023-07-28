// USING AXOpen.Core;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoDatamanRead EXTENDS AXOpen.Core.AxoTask
        VAR PROTECTED
            _progress : INT := 0;
            _infoTimer :  System.Timer.OnDelay;
            _errorTimer :  System.Timer.OnDelay;

            // _varInfo : __SYSTEM.VAR_INFO;
            // _sb : TcoCore.StringBuilder;
        END_VAR

        VAR PRIVATE 
            _infoTime : LTIME := LT#2S;
            _errorTime : LTIME := LT#5S;
            _Status     :   REF_TO  AxoDataman_Status;	
        END_VAR

        METHOD PUBLIC Run 
            VAR_INPUT
                AcquisitionControl  :   REF_TO  AxoDataman_AcquisitionControl;
                AcquisitionStatus   :   REF_TO  AxoDataman_AcquisitionStatus;
                ResultsControl      :   REF_TO  AxoDataman_ResultsControl;
                ResultsStatus       :   REF_TO  AxoDataman_ResultsStatus;
                Config              :   REF_TO  AxoDataman_Config;
                Status              :   REF_TO  AxoDataman_Status;	
                Results             :   REF_TO  AxoDataman_Results;
                ResultData          :   REF_TO  ARRAY[*] OF BYTE;
            END_VAR          

            VAR
                _index : INT;
            END_VAR          

            IF THIS.Execute() THEN
                IF _progress = 0 THEN
                    // IF NOT __ISVALIDREF(inoIoData) THEN
                    //     _varInfo :=__VARINFO(inoIoData);
                    //     Messenger.Programming(_sb.Clear().Append('<#Invalid reference: #>').Append(_varInfo.Symbol).ToString()).Pin();
                    // ELSIF NOT __ISVALIDREF(inoConfig) THEN                                                  
                    //     _varInfo :=__VARINFO(inoConfig);                                                    
                    //     Messenger.Programming(_sb.Clear().Append('<#Invalid reference: #>').Append(_varInfo.Symbol).ToString()).Pin();
                    // ELSIF NOT __ISVALIDREF(inoStatus) THEN                                                  
                    //     _varInfo :=__VARINFO(inoStatus);                                                    
                    //     Messenger.Programming(_sb.Clear().Append('<#Invalid reference: #>').Append(_varInfo.Symbol).ToString()).Pin();
                    // ELSIF NOT __ISVALIDREF(inoResults) THEN                                              
                    //     _varInfo :=__VARINFO(inoResults);                                                
                    //     Messenger.Programming(_sb.Clear().Append('<#Invalid reference: #>').Append(_varInfo.Symbol).ToString()).Pin();
                    // ELSE
                    _progress := _progress + 1;
                    _infoTime := Config^.InfoTime;
                    _errorTime := Config^.ErrorTime;
                    _Status := Status;
                    // END_IF;
                END_IF;
                
                IF _progress = 1 THEN
                    Status^.ActionDescription := '<#Reading running.#>'; 
                    THIS.CallTimers(FALSE);
                    IF ResultsStatus^.ErrorDetected THEN
                        _progress := 20;
                    ELSE
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                

                IF _progress = 2 THEN
                    AcquisitionControl^.TriggerEnable := TRUE;
                    AcquisitionControl^.Trigger := FALSE;
                    ResultsControl^.EnableResultBuffering := FALSE;
                    ResultsControl^.ResultsAcknowledge := ResultsStatus^.ResultsAvailable;
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal ResultsAvailable to be reseted!#>').Pin(); 
                    IF NOT ResultsStatus^.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal TriggerReady to be set!#>').Pin(); 
                    IF AcquisitionStatus^.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 4 THEN
                    AcquisitionControl^.Trigger := TRUE;
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal TriggerAcknowledge to be set!#>').Pin(); 
                    IF AcquisitionStatus^.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 5 THEN
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal ResultsAvailable to be set!#>').Pin(); 
                    IF ResultsStatus^.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 6 THEN
                    THIS.ThrowWhen(Results^.Code = UINT#0 OR Results^.Length=UINT#0 OR Results^.Length > TO_UINT(Status^.ResultDataSize));
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 7 THEN
                    System.SerDe.Deserialize(UINT#7, ResultData^, Results^.Data);
                    AcquisitionControl^.Trigger := FALSE;
                    ResultsControl^.EnableResultBuffering := FALSE;
                    ResultsControl^.ResultsAcknowledge := TRUE;
                    THIS.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                
                IF _progress = 20 THEN
                    AcquisitionControl^.TriggerEnable :=FALSE;
                    AcquisitionControl^.Trigger := FALSE;
                    ResultsControl^.EnableResultBuffering := FALSE;
                    ResultsControl^.ResultsAcknowledge := FALSE;
                    IF NOT AcquisitionStatus^.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 21 THEN
                    AcquisitionControl^.TriggerEnable :=TRUE;
                    IF NOT ResultsStatus^.ErrorDetected THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;

                IF _progress = 22 THEN
                    AcquisitionControl^.TriggerEnable :=FALSE;
                    IF _infoTimer.elapsedTime >= T#1s THEN
                        THIS.CallTimers(FALSE);
                        _progress :=  1;
                    END_IF;
                END_IF;

                THIS.CallTimers(TRUE);
                
                THIS.ThrowWhen(_errorTimer.output);

                Status^.SignalStatus.Progress := _progress;
            END_IF;
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer(signal , _infoTime);
            _errorTimer(signal , _errorTime );
        END_METHOD

        METHOD PROTECTED OVERRIDE OnRestore 
            _progress := 0;
            THIS.CallTimers(FALSE);
        END_METHOD

        METHOD PROTECTED OVERRIDE OnAbort 
            IF _Status <> NULL THEN
                _Status^.ActionDescription := '<#Reading was aborted, while not yet completed!#>'; 
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnDone 
            IF _Status <> NULL THEN
                _Status^.ActionDescription := '<#Reading was completed successfully.#>'; 
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnError 
            IF _Status <> NULL THEN
                _Status^.ActionDescription := '<#Reading finished with error.#>';
            END_IF;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnStart 
            IF _Status <> NULL THEN
                _Status^.ActionDescription := '<#Reading started.#>'; 
            END_IF;
        END_METHOD
        
    END_CLASS    
END_NAMESPACE