## AxoDigitalInspector

Inspector provides evaluation of *discrete* value. The input value compares against the *Required* value. The inspection passes when the input value matches the required value without interruption for the duration of stabilization time.

![Digital inspector](~/images/digital-inspector.png)

Common inspector data are extended with following digital inspector data:

```C#
RequiredStatus : BOOL; //required value for inspection

DetectedStatus : BOOL; //detected value for inspection
```