# COMPONENTS BLACKLIST

**LIST OF COMPONENTS THAT MUST NOT BE USED**

| **SUPPLIER** | **TYPE** | **DESCRIPTION** | **REASON** | **ALTERNATIVE** |
|--------------|----------|-----------------|------------|------------------|
| Siemens | PLC series 12xx, 1510 to 1515 | PLC | Cannot use our sequencer, our components, or technology objects for Siemens frequency converters. Small memory, only one network card. | Siemens 1516, 1517, 1518 V4.0+ |
| Siemens | PLC with firmware lower then 4.0 | PLC | Not suitable for high communication load  | Siemens 1516, 1517, 1518 V4.0+ |
| ANY | IOlink device | IOlink master or slave | No support for IOlink in Simatic AX | Siemens ET200AL boxes DI/AI boxes |
| Siemens | any old HMI Panels except Unified with firmware 20.2+ | HMI Panel | Has to be capable to open browser that supports .NET8, I guess | Unified with firmware 20.2+ at least 20inch at least 1920*1080 resolution |
| Festo with Siemens PLC | Pneumatic manifolds with EtherCAT | Pneumatic manifolds with EtherCAT | Siemens does not support EtherCAT bus | Festo manifolds with PROFINET |
| Aventics with Siemens PLC | Pneumatic manifolds with EtherCAT | Pneumatic manifolds with EtherCAT | Siemens does not support EtherCAT bus | Aventics manifolds with PROFINET |
| Cognex | Insight with firmware lower then 24.0.0 | Insight family | Communication structure does not fit the somponent structure | Insight with firmware higher then 24.0.0 or Keyence :-) |
| ANY | GW INSTEK - PSP-2010 | LABORATORY POWER SUPPLY | UNRELIABLE COMMUNICATION. REQUIRES ADDITIONAL 12V SUPPLY TO USE RS232 INTERFACE | TTi QL355 |
| ANY | WD My Cloud EX2 | Network Drive, NAS | Cannot schedule shutdown via UPS | Synology DiskStation DS216j 2x 1 TB RED |
| IAI | ALL | (!) Intelligent Actuators | Each type is different, very poor support, each has different parameterization, inconsistent software for control, inconsistent connection cables, inconsistent parameters... | Rexroth, Festo, Schneider |
| ANY | Fujitsu | Network Drive, NAS | Slow service startup, ping issues after standby and startup. Could not be pinged after link activation | Synology DiskStation DS218+, 2x HDD |
| Ateq | Ateq with RS232 | Leak Tester | Our component is not adapted for it(1), requires additional serial card | Ateq with PROFINET, or Ateq without results (OK/NOK only) |
||

(1) Development would take up our precious time, hence it is inefficient for us.
