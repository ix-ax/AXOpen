# Robotics Utilities

The `AXOpen.Components.Robotics` library provides shared utility functions and data types
used by all vendor-specific robotics implementations (ABB, KUKA, UR, Mitsubishi).

# [CONTROLLER](#tab/controller)

## Declarations

[!code-smalltalk[](../../showcase/app/src/components.robotics/Documentation/Robotics.st?name=RoboticsDeclarations)]

## Coordinate setup

[!code-smalltalk[](../../showcase/app/src/components.robotics/Documentation/Robotics.st?name=CoordinateSetup)]

## Calculate distance between points

[!code-smalltalk[](../../showcase/app/src/components.robotics/Documentation/Robotics.st?name=CalculateDistanceUsage)]

## Compare coordinates with tolerance

[!code-smalltalk[](../../showcase/app/src/components.robotics/Documentation/Robotics.st?name=CoordinatesAreNearlyEqualUsage)]

## Configure movement parameters

[!code-smalltalk[](../../showcase/app/src/components.robotics/Documentation/Robotics.st?name=MovementParamsSetup)]

# [.NET TWIN](#tab/twin)


# [BLAZOR](#tab/blazor)

**How to visualize Robotics utilities**

On the UI side, use the `RenderableContentControl` and set its Context according to the placement of the instance.

---
