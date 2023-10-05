# **AXOpen.Core**

[!INCLUDE [General](../../../docfx/articles/notes/LIBRARYHEADER.md)]

**AXOpen.Core** offers the foundational blocks for constructing AXOpen applications.

- **Contexts and Objects**: These are at the core of the AXOpen application logic. `AxoContext` acts as the container for an AXOpen application, supplying information to each `AxoObject`. `AxoObject` serves as the base class for any other class in an AXOpen application.

- **Tasks**: These facilitate basic coordination mechanisms to align partial tasks in a consistent manner.

- **Components**: rudimentary implementations for any component associated with AXOpen. A component can be a physical device such as a pneumatic cylinder, servo drive robot, or a virtual device. Components in AXOpen are designed to furnish ready-to-use driver pieces, allowing rapid application composition.

- **Dialogs and alerts**: provide neat way of informing and interacting with human operator.

- **Coordination**: This provides a suite of classes for advanced task coordination and visualization, ensuring high visibility into device operations.

- **Messengers**: They make it straightforward to report alarms and convey messages to operating personnel.

- **Logging**: This feature enables users to monitor and accumulate data regarding internal events within the controller.

--- 
