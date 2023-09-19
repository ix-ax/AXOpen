## AxoDataInspector

Provides evaluation of alphanumerical values. The input value compares against the Required value. The inspection passes when the input value matches the required value without interruption for the duration of stabilization time. In addition to exact comparison, data inspector allows for simple pattern matching where # = any number and * = any character.

![Data inspector](~/images/data-inspector.png)

Common inspector data are extended with following data inspector data:

```C#
RequiredStatus : STRING; //required value for inspection

DetectedStatus : STRING; //detected value for inspection

StarNotationEnabled: BOOL; //star notation enable/disable

```