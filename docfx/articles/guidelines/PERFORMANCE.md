# Performance Considerations when Designing AXOpen Applications

AXOpen boasts a variety of features. However, it's noteworthy that certain features may demand higher performance, affecting both the controller and communication load. This is especially true for hardware-based controllers. This document covers the general guidelines for selecting a suitable controller within the usable range of hardware based controllers is S7-1515 to S7-1518. It is crucial to carefully determine the requirements for the desired controller, taking into consideration the size and performance demands of the application.

## Hardware Controllers

The table below provides an overview of the specifications of various hardware controllers:

| Controller     | Max. Controlled Units | Traceability | Controller Logging | Data Load | Main Cyclic Loop* |
|----------------|-----------------------|--------------|--------------------|-----------|------------------|
| S7-1515 FW 3.0 | 1                     | No           | No                 | Low       | 500ms            |
| S7-1516 FW 3.0 | 1                     | No           | No                 | Low       | 500ms            |
| S7-1517 FW 3.0 | 5                     | Yes          | Yes                | Modest    | 250ms            |
| S7-1518 FW 3.0 | 7                     | Yes          | Yes                | Modest    | 250ms            |

## Software Controllers

Software controllers also offer a range of capabilities, as detailed in the table below:

| Controller | Max. Controlled Units | Traceability | Controller Logging | Data Load | Main Cyclic Loop* |
|------------|-----------------------|--------------|--------------------|-----------|------------------|
| S7-1507S   | 10                    | Yes          | Yes                | Low       | 50ms             |
| S7-1508S   | 10                    | Yes          | Yes                | Low       | 50ms             |

* Main cyclic loop is the base time interval of the AXOpen application to handle all cyclic requests.

Always ensure to align the selection of a controller with the specific needs of your AXOpen application to achieve optimal performance.