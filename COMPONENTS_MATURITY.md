# AXOpen Components Maturity Matrix

This document tracks the maturity state of all AXOpen components across different aspects of development and deployment.

## Maturity Levels

- **Not Implemented** - Component structure exists but core functionality not implemented
- **Implemented** - Core functionality implemented, basic testing may exist
- **Tested** - Comprehensive unit/integration tests exist and pass
- **Battle Tested** - Successfully deployed and proven in production environments

## Component Status Matrix

| Component                                                       | Domain        | Implemented | Tested | Battle Tested | Version   | Notes                                              |
|-----------------------------------------------------------------|---------------|-------------|--------|---------------|-----------|----------------------------------------------------|
| **Core Components**                                             |               |             |        |               |           |                                                    |
| [AxoComponent](src/core/)                                       | Framework     | 🟢          | 🟢     | 🟡            | Latest    | Base component class                               |
| [AxoTask](src/core/)                                            | Framework     | 🟢          | 🟢     | 🟡            | Latest    | Task execution framework, uses IAxoTaskState       |
| [AxoContext](src/core/)                                         | Framework     | 🟢          | 🟢     | 🟡            | Latest    | Application context                                |
| [AxoObject](src/core/)                                          | Framework     | 🟢          | 🟢     | 🟡            | Latest    | Base object class                                  |
| [AxoSequencer](src/core/)                                       | Framework     | 🟢          | 🟢     | 🟡            | Latest    | Sequencer state machine                            |
| [AxoMessaging](src/core/)                                       | Framework     | 🟢          | 🟢     | 🟡            | Latest    | Messaging & notification framework                 |
| [AxoDialogs](src/core/)                                         | Framework     | 🟢          | 🟢     | 🟡            | Latest    | Dialog UI framework                                |
| [Abstractions](src/abstractions/)                               | Framework     | 🟢          | 🟢     | 🟢            | Latest    | Core abstraction interfaces                        |
| [ComponentsAbstractions](src/components.abstractions/)          | Framework     | 🟢          | 🟢     | 🟢            | Latest    | Component abstraction layer                        |
| **I/O Components**                                              |               |             |        |               |           |                                                    |
| [Pneumatics](src/components.pneumatics/)                        | I/O           | 🟢          | 🟢     | 🟡            | Latest    | Cylinders, valves                                  |
| [Elements](src/components.elements/)                            | I/O           | 🟢          | 🟢     | 🟡            | Latest    | Basic I/O elements                                 |
| **Vision Systems**                                              |               |             |        |               |           |                                                    |
| [Cognex Insight v_6_0_0_0](src/components.cognex.vision/)       | Vision        | 🟢          | 🟡     | 🔴            | v_6_0_0_0 | Legacy Insight vision sensor                       |
| [Cognex Insight v_24_0_0](src/components.cognex.vision/)        | Vision        | 🟢          | 🟡     | 🔴            | v_24_0_0  | Current Insight vision sensor                      |
| [Cognex DataMan](src/components.cognex.vision/)                 | Vision        | 🟢          | 🟡     | 🔴            | v_6_0_0_0 | Barcode reader integration                         |
| [Keyence Vision](src/components.keyence.vision/)                | Vision        | 🟢          | 🟡     | 🔴            | TBD       | Keyence camera integration                         |
| [Zebra Vision](src/components.zebra.vision/)                    | Vision        | 🟡          | 🔴     | 🔴            | TBD       | Zebra scanner integration                          |
| **Robotics**                                                    |               |             |        |               |           |                                                    |
| [ABB OmniCore v_1_x_x](src/components.abb.robotics/)            | Robotics      | 🟢          | 🟡     | 🔴            | v_1_x_x   | OmniCore controller                                |
| [ABB IRC5 v_1_x_x](src/components.abb.robotics/)                | Robotics      | 🟢          | 🟡     | 🔴            | v_1_x_x   | IRC5 controller                                    |
| [KUKA KRC4 v_5_x_x](src/components.kuka.robotics/)              | Robotics      | 🟢          | 🟡     | 🔴            | v_5_x_x   | KRC4 controller with comprehensive task management |
| [UR CB3 v_3_x_x](src/components.ur.robotics/)                   | Robotics      | 🟢          | 🟡     | 🔴            | v_3_x_x   | Universal Robots CB3 controller                    |
| [UR DataTypes v_1_x_x](src/components.ur.robotics/)             | Robotics      | 🟢          | 🟡     | 🔴            | v_1_x_x   | UR communication & data structures                 |
| [Mitsubishi CR800 v_1_x_x](src/components.mitsubishi.robotics/) | Robotics      | 🟢          | 🟡     | 🔴            | v_1_x_x   | CR800 controller integration                       |
| [Generic Robotics](src/components.robotics/)                    | Robotics      | 🟢          | 🟡     | 🔴            | Latest    | Abstract robotics interfaces                       |
| **Drive Systems**                                               |               |             |        |               |           |                                                    |
| [Generic Drives](src/components.drives/)                        | Motion        | 🟢          | 🟡     | 🔴            | Latest    | Abstract drive interfaces                          |
| [Rexroth Drives](src/components.rexroth.drives/)                | Motion        | 🟢          | 🟡     | 🔴            | Latest    | Rexroth servo drives                               |
| [Festo Drives](src/components.festo.drives/)                    | Motion        | 🟢          | 🟡     | 🔴            | TBD       | Festo drive integration                            |
| **Manufacturing**                                               |               |             |        |               |           |                                                    |
| [Rexroth Smart Function Kit](src/components.rexroth.press/)     | Manufacturing | 🟢          | 🟡     | 🔴            | v_4_x_x   | Smart Function Kit press control                   |
| [Desoutter Tightening](src/components.desoutter.tightening/)    | Manufacturing | 🟢          | 🟡     | 🔴            | TBD       | Desoutter tightening tools                         |
| [Rexroth Tightening](src/components.rexroth.tightening/)        | Manufacturing | 🟢          | 🟡     | 🔴            | Latest    | Rexroth tightening systems                         |
| [Dukane Welders](src/components.dukane.welders/)                | Manufacturing | 🟢          | 🟡     | 🔴            | TBD       | Ultrasonic welding systems                         |
| **Identification**                                              |               |             |        |               |           |                                                    |
| [Balluff ID](src/components.balluff.identification/)            | RFID/ID       | 🟢          | 🔴     | 🔴            | Latest    | Balluff RFID systems                               |
| [Siemens ID](src/components.siem.identification/)               | RFID/ID       | 🟢          | 🟡     | 🔴            | TBD       | Siemens identification                             |
| **Data & Persistence**                                          |               |             |        |               |           |                                                    |
| [Data](src/data/)                                               | Data          | 🟢          | 🟢     | 🔴            | Latest    | Data repository & CRUD                             |
| [Inspectors](src/inspectors/)                                   | Quality       | 🟢          | 🟢     | 🔴            | Latest    | Data inspection framework                          |
| **Infrastructure**                                              |               |             |        |               |           |                                                    |
| [Security](src/Security/)                                       | Security      | 🟢          | 🟢     | 🔴            | Latest    | Role-based auth & authorization                    |
| [Timers](src/timers/)                                           | Utilities     | 🟢          | 🟢     | 🔴            | Latest    | Timer utilities including AxoBlinker               |
| [IO](src/io/)                                                   | I/O           | 🟢          | 🟢     | 🔴            | Latest    | Basic I/O abstractions                             |
| [Simatic1500](src/simatic1500/)                                 | Platform      | 🟢          | 🟢     | 🔴            | Latest    | S7-1500 hardware integration                       |
| [Utils](src/utils/)                                             | Utilities     | 🟢          | 🟢     | 🔴            | Latest    | General utility functions                          |
| [Probers](src/probers/)                                         | Utilities     | 🟢          | 🟡     | 🔴            | Latest    | Diagnostic & probe tools                           |
| **Communication**                                               |               |             |        |               |           |                                                    |
| [SiemCommunication](src/components.siem.communication/)         | Communication | 🟢          | 🟡     | 🔴            | Latest    | Siemens communication framework                    |


## Component Maturity Guidelines

### Implemented
- [ ] Core functionality working
- [ ] Basic documentation exists
- [ ] Compiles without errors
- [ ] Basic manual testing completed

### Tested
- [ ] Integration tests exist where applicable
- [ ] CI/CD pipeline runs tests

### Battle Tested
- [ ] Deployed in production environment
- [ ] Proven reliable over extended period
- [ ] Performance validated under load
- [ ] Support & maintenance processes established