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
        END_VAR

        METHOD PUBLIC Run 
            VAR_IN_OUT
                AcquisitionControl  :   AxoDataman_AcquisitionControl;
                AcquisitionStatus   :   AxoDataman_AcquisitionStatus;
                ResultsControl      :   AxoDataman_ResultsControl;
                ResultsStatus       :   AxoDataman_ResultsStatus;
                ResultData          :   ARRAY[*] OF BYTE;
                Config              :   AxoDataman_Config;
                Status              :   AxoDataman_Status;	
                Results             :   AxoDataman_Results;
                sResults            :   STRING[246];
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
                    // END_IF;
                END_IF;
                
                IF _progress = 1 THEN
                    Status.ActionDescription := '<#Reading running.#>'; 
                    THIS.CallTimers(FALSE);
                    _progress := _progress + 1;
                END_IF;
                
                IF _progress = 2 THEN
                    AcquisitionControl.TriggerEnable := TRUE;
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.EnableResultBuffering := FALSE;
                    ResultsControl.ResultsAcknowledge := ResultsStatus.ResultsAvailable;
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal ResultsAvailable to be reseted!#>').Pin(); 
                    IF NOT ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 3 THEN
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal TriggerReady to be set!#>').Pin(); 
                    IF AcquisitionStatus.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 4 THEN
                    AcquisitionControl.Trigger := TRUE;
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal TriggerAcknowledge to be set!#>').Pin(); 
                    IF AcquisitionStatus.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 5 THEN
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the signal ResultsAvailable to be set!#>').Pin(); 
                    IF ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    END_IF;
                END_IF;
                
                IF _progress = 6 THEN
                    THIS.ThrowWhen(Results.Code = UINT#0 OR Results.Length=UINT#0 OR Results.Length > TO_UINT(Config.ResultDataSize));
                    // THIS^.inoResults.Length := THIS^.inoIoData.ResultData.ResultLength;
                    // THIS^.Messenger.OnCondition(_infoTimer.Q).Warning('<#Waiting for the ResultData copied!#>').Pin(); 
                    // IF  Tc2_System.MEMCPY(srcAddr := ADR(THIS^.inoIoData.ResultData.ResultData) , destAddr:= ADR(THIS^.inoResults.Data) ,  n:= THIS^.inoResults.Length) > 0 AND 
                    //     Tc2_System.MEMSET(destAddr:= ADR(THIS^.inoResults.Data) + THIS^.inoResults.Length, fillByte:= 0 , n:= SIZEOF(THIS^.inoResults.Data) - THIS^.inoResults.Length)>0 THEN
                        THIS.CallTimers(FALSE);
                        _progress := _progress + 1;
                    // END_IF;
                END_IF;
                
                IF _progress = 7 THEN
                    FOR _index := 0 TO (TO_INT(Results.Length) - 1) DO
                        Results.Data[_index] := ResultData[_index + 8];
                    END_FOR;
                    FOR _index := TO_INT(Results.Length) TO 245 DO
                        Results.Data[_index] := BYTE#0;
                    END_FOR;
                    System.SerDe.Deserialize(UINT#7, ResultData, sResults);
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.EnableResultBuffering := FALSE;
                    ResultsControl.ResultsAcknowledge := TRUE;
                    THIS.DoneWhen(TRUE);
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