## Technology
Technology is a system that creates a new product through certain operations (pressing, welding, coating) on input material. Every such operation, with auxiliary functions, forms a certain logically `Controlled Unit`.


```mermaid
---
title: "Relation ship of Technology and Controlled unit"
---
flowchart TD

   classDef DataType stroke-width:2px,stroke:blue;
   classDef SettingsType stroke-width:2px,stroke:yellow
   classDef TechnologyType stroke-width:2px,stroke:lightgreen
   classDef CuType stroke-width:2px,stroke:green

  graphCuMode --> graphComponentsId
  graphComponentsId --> graphCuMode

    subgraph graphTechnology [Technology]
        graphControledUnit
        graphControledUnitNext
    end
 
    subgraph graphControledUnit [Controlled Unit]
        graphCuMode
        graphComponentsId
       %% otherCu[...]
    end

    subgraph graphControledUnitNext [Controlled Unit ]
       NexCuContext[...]
    end

    subgraph graphCuMode [Controlled Unit mode]
        Idle(Idle)
        GROUND(Ground)
        AUTO(Auto)
        SERVICE(Service)
    end


 subgraph graphComponentsId [Components]
       SensorsD(Digital Inputs and Outpus)
       SensorsA(Analog Inputs and Outpus)
       Pistons(Pisons)
       Servos(Servos)
       Lasers(Lasers)
       otherComponents[...]
    end

```
## Controlled unit
`Controlled Unit` To perform these operations, it is necessary to control actuators or more complex logical entities (`Components`) such as pistons, servos, lasers, welding units, etc. The Controlled Unit, therefore, includes some `Components` and control logic/control  [sequences](../../core/docs/AXOSEQUENCER.md) which create the [`Mode`](ControlledUnitModes.md) of the controlled unit.

## Components
[Components](../../core/docs/AXOCOMPONENT.md) are digital/analog inputs or outputs, motors, servos, and also other complex devices such as lasers, welders, etc.
Instances of components are created and encapsulated into a Components object for the purpose of passing a reference to the control sequence.


[!include[Ref](Navigation.md)]
