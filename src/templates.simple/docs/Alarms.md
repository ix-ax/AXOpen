
## Alarms

[Components](../../core/docs/AXOCOMPONENT.md) generate alarms during their operation, in the event of a delay or failure to meet a condition. An alarm describes why the machine is slowing down or stopped, or why a subsequent operation is not being performed.

Integration of alarms is based on [AxoMessenger](../../core/docs/AXOMESSENGER.md).

The [level of alarms](../../core/docs/AXOCOMPONENT#Alarm-Level.md) depends on component integration.

### Alarms on Unit Spot View
If a CU has any alarms, a pink dot is displayed on the Open button of the CU.
![Alarm on Unit view ](assets\AlarmCUSpotView.png)

### Alarms over Unit in Modal Window
A modal window that displays all alarms in the Controlled Unit can be shown by clicking on the 'Alarms In Station' button.
![Alarm on Unit view ](assets\AlarmsModalView.png)

### Alarm in Component View
In service mode, you can manually control every component. When a component has any alarms, the emoji icon on the right side changes color. After clicking on it, alarm details will be displayed.
![Alarm on component ](assets\AlarmsServiceMode.png)


[!include[Ref](Navigation.md)]
