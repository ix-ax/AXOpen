# AXOpen.Timers

**AXOpen.Timers** provide implementations of basic timers used in PLC programming. Timers are implemented in separated classes within corresponding methods.
Functionality of Timers is based on *Real Time Clock* implementation provided from **AXContext**.

> [!NOTE]
> Be aware, that resolution of the timer depends on cycle time of the PLC task, on which the timer is used. 

[!INCLUDE [OnDelayTimer](ONDELAYTIMER.md)]

[!INCLUDE [OffDelayTimer](OFFDELAYTIMER.md)]

[!INCLUDE [Pulse](PULSETIMER.md)]