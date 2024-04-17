NAMESPACE AXOpen.Components.Ur.Robotics
TYPE
    eAxoUrRoboticsRobotMode : USINT
    (

        DISCONNECTED        := USINT#0,
        SAFETY              := USINT#1,
        BOOTING             := USINT#2,
        POWER_OFF           := USINT#3,
       	POWER_ON            := USINT#4,
        IDLE                := USINT#5,
        BACKDRIVE           := USINT#6,
        RUNNING             := USINT#7,
        UPDATING_FIRMWARE   := USINT#8
    );
END_TYPE
END_NAMESPACE
