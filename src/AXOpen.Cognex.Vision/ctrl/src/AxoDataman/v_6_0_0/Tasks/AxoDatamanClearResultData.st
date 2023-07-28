//USING AXOpen.Core;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    CLASS PUBLIC AxoDatamanClearResultData EXTENDS AXOpen.Core.AxoTask
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
        END_VAR

        METHOD PUBLIC Run 
            VAR_IN_OUT
                AcquisitionControl  : AxoDataman_AcquisitionControl;
                AcquisitionStatus   : AxoDataman_AcquisitionStatus;
                ResultsControl      : AxoDataman_ResultsControl;
                ResultsStatus       : AxoDataman_ResultsStatus;
                Config              : AxoDataman_Config;
                Status              : AxoDataman_Status;	
                Results             : AxoDataman_Results;
            END_VAR          

            VAR
                _index : INT;
            END_VAR          

            IF THIS.Execute() THEN
                _infoTime := Config.InfoTime;
                _errorTime := Config.ErrorTime;
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
                    // END_IF;
                END_IF;
                
                IF _progress = 1 THEN
                    Status.ActionDescription := '<#Clearing of the result data running.#>'; 
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 2 THEN
                    AcquisitionControl.TriggerEnable := FALSE;
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.ResultsAcknowledge := TRUE;
                    Results.Id := UINT#0; 
                    Results.Code := UINT#0; 
                    Results.Extended := UINT#0; 
                    Results.Length := UINT#0; 

                    Results.Data := '';
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 3 THEN
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal ResultsAvailable to be reseted!#>').Pin(); 
                    IF NOT ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 4 THEN
                    ResultsControl.ResultsAcknowledge := FALSE;
                    THIS.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;
                
                THIS.CallTimers(TRUE);
                
                THIS.ThrowWhen(_errorTimer.output);
                Status.SignalStatus.Progress := _progress;
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

    END_CLASS     
END_NAMESPACE