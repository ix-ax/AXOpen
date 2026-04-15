# Vendor-Specific Robotics Implementations

For concrete robot component documentation, see the vendor-specific libraries:

- [ABB Robotics](../../components.abb.robotics/docs/README.md) — IRC5, OmniCore controllers
- [KUKA Robotics](../../components.kuka.robotics/docs/README.md) — KRC4 controller
- [Mitsubishi Robotics](../../components.mitsubishi.robotics/docs/README.md) — CR800 controller
- [Universal Robots](../../components.ur.robotics/docs/README.md) — CB3 controller

Each vendor library extends the base robotics types from this package and implements
the `IAxoRobotics` interface defined in `AXOpen.Components.Abstractions.Robotics`.
