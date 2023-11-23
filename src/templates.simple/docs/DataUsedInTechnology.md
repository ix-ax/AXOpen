## Data used in the technology


```mermaid
---
title: "Example of Data flow in the technology"
---
flowchart LR

   classDef DataType stroke-width:3px,stroke:blue;
   classDef ProcessSettingsType stroke-width:3px,stroke:blue
   classDef TechnologySettingsType stroke-width:3px,stroke:orange
   classDef CuType stroke-width:2px,stroke:green

   CU1(CU 1):::CuType
   CU2(CU 2):::CuType
   CUn(CU n):::CuType
   

    TechSetRepoCu1[(Technology settings CU 1)]:::TechnologySettingsType
    TechSetRepoCu2[(Technology settings CU 2)]:::TechnologySettingsType
    TechSetRepoCun[(Technology settings CU n)]:::TechnologySettingsType

    ProcesSetRepoCu1[(Process settings CU 1)]:::ProcessSettingsType
    ProcesSetRepoCu2[(Process settings CU 2)]:::ProcessSettingsType
    ProcesSetRepoCun[(Process settings CU n)]:::ProcessSettingsType

    ProductionSetRepoCu1[(Process data CU 1)]:::DataType
    ProductionSetRepoCu2[(Process data CU 2)]:::DataType
    ProductionSetRepoCun[(Process data CU n)]:::DataType
    

    CU1 -->|Tracebility data| ProductionSetRepoCu1
    CU2 -->|Tracebility data| ProductionSetRepoCu2
    CUn -->|Tracebility data| ProductionSetRepoCun

    ProcesSetRepoCu1 --> CU1
    TechSetRepoCu1 --> CU1

    ProcesSetRepoCu2 --> CU2
    TechSetRepoCu2 --> CU2

    ProcesSetRepoCun --> CUn
    TechSetRepoCun --> CUn

 
    subgraph SettingsRepoId [Settings Repository]
        direction LR
        TechSetRepoCu1
        TechSetRepoCu2
        TechSetRepoCun
        ProcesSetRepoCu1
        ProcesSetRepoCuX(...)
        ProcesSetRepoCu2
        ProcesSetRepoCun
    end

    subgraph graphTechId [Technology]
        direction LR
        CU1
        CU2
        CUx(...)
        CUn
    end

      subgraph ProductionRepoId ["Process data repository"]
        direction LR
        ProductionSetRepoCu1
        ProductionSetRepoCu2
        ProductionSetRepoCuX(...)
        ProductionSetRepoCun
    end

  
```


### Technological Settings
These data are associated with the machine settings and do not have a direct connection to the product. They can include, for example, motor speeds, positions of manipulators, and other settings that have some impact on the product.

### Process Settings
These data contain settings related to the product, including the settings of Inspectors and other required process settings.

### Process Data
This is the same data structure as a Process Settings. But filled by results. Therefore, the data include both settings and outcomes related to the product.

### Traceability Data
Traceability data are data collected during the process. They can include various values such as pressure, temperature, height, position, or scanned codes of the input material, etc.

For storing values without additional parameters, base type values may be used. In this framework, [Inspectors](../../inspectors/docs/README.md)  ensure the storage of values with additional settings, such as limits and timestamps.

[!include[Ref](Navigation.md)]

