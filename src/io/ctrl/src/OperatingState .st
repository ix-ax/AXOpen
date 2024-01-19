NAMESPACE AXOpen.Io
    TYPE OperatingState   : UINT (
        Unknown                     :=  UINT#255,
        NotSupported                :=	UINT#0,     //	Not Supported; for I/O modules OperatingState always has this value.
        StopFirmwareUpdate          :=	UINT#1,     //	STOP; firmware update.
        StopMemoryReset             :=	UINT#2,     //	STOP; memory reset.
        StopSelfStart               :=	UINT#3,     //	STOP; self start.
        Stop                        :=	UINT#4,     //	STOP.
        MemoryReset                 :=	UINT#5,     //	Memory reset.
        Startup                     :=	UINT#6,     //	STARTUP.
        Run                         :=	UINT#8,     //	RUN.
        RunRedundant                :=	UINT#9,     //	RUN-REDUNDANT.
        Hold                        :=	UINT#10,    //	HOLD.
        Defect                      :=	UINT#13,    //	DEFECT (can only be seen in diagnostic buffer entries).
        DeEnergized                 :=	UINT#15,    //	De-energized (can only be seen in diagnostic buffer entries).
        ConfigurationInRun          :=	UINT#16,    //	Configuration in Run (CiR).
        StopWithoutOutputDisable    :=	UINT#17,    //	STOP without output disable.
        RunWithOutputDisable        :=	UINT#18,    //	RUN with output disable.
        PgmTest                     :=	UINT#19,    //	PgmTest.
        PrimaryRunBackupTest        :=	UINT#20,    //	RunPgmTest (state of primary PLC when the backup PLC is in test mode).
        PrimarySyncup               :=	UINT#21,    //	RUN-SYNCUP (only primary PLC in SYNCUP system state).
        BackupSyncup                :=	UINT#22,    //	SYNCUP (only backup PLC in SYNCUP system state)
        PartnerPlcStateUnknown      :=	UINT#31,    //	State of partner PLC unknown (for example when the partner PLC is not available).
        StopSystemState             :=	UINT#33,    //	STOP system state
        StartupSystemState          :=	UINT#35,    //	STARTUP system state
        RunSoloSystemState          :=	UINT#37,    //	RUN-SOLO system state
        SyncupSystemState           :=	UINT#38,    //	SYNCUP system state
        RunRedundantSystemState     :=	UINT#40    //	RUN-REDUNDANT system state
                    ) := Unknown;
    END_TYPE
END_NAMESPACE

