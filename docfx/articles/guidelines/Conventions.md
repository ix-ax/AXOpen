# WORK IN PROGRESS...

# AXOpen Conventions

| REVISION | DATE       | NOTES                 |
|----------|------------|-----------------------|
| 0.0      | July 2023 | Initial release       |



## Introduction

Thanks for taking the time to read this document. Here we aim to outline a set of rules that will help us write consistent libraries that will serve their other consumers and us.

This document follows recommendations from [SIMATIC-AX ST Style guide](https://console.simatic-ax.siemens.io/docs/st-styleguide) for AXOpen project(s).

This document defines the minimum coding standards and will be updated as the project develops in time.

### Why do we need to agree on conventions

* They create a consistent look to the code so that readers can focus on content, not layout.
* They enable readers to understand the code more quickly by making assumptions based on previous experience.
* They facilitate copying, changing, and maintaining the code.
* They demonstrate Structured Text best practices.

### A general note on naming

Names should be self-describing, readable considered in calling context. Use of prefixes is discouraged, except for those outlined in this document. For example to inform/warn about some property like a reference, IN_OUT reference, or to aid to IntelliSense to narrow the scope of search.

### General note on the use of PLC-Language

AXOpen uses exclusively IEC 61131-3 Structured Test (ST).

## Namespaces

Each type must be enclosed in an appropriate namespace. Orphaned types with no namespace are not allowed.

## Naming 

> **Type Naming**


|   Block type   |  Notation  |  Prefix  |          Example          |
| -------------- | ---------- | -------- | ------------------------- |
| FB/CLASS name  | PascalCase | NoPrefix | ```Cyclinder```           |
| ENUM type name | PascalCase | ```e```  | ```eMachineState.Start``` |
| INTERFACE name | PascalCase | ```I```  | ```ICyclinder```          |
| FUNCTION name  | PascalCase | NoPrefix | ```Add()```               |
| STRUCT name    | PascalCase | NoPrefix | ```Data```                |



> **CLASS member naming**

| Variable section | Notation   | Prefix   | Example                       |
|------------------|------------|----------|-------------------------------|
| METHOD name      | PascalCase | NoPrefix | ```MoveToWork()```            |
| METHOD arguments | camelCase  | NoPrefix | ```targetPosition  : LREAL``` |
| *PROPERTY name    | PascalCase | NoPrefix | ```IsEnabled```               | 



> **CLASS member naming**

| Variable section | Notation   | Prefix    | Example                          |
|------------------|------------|-----------|----------------------------------|
| VAR_INPUT        | camelCase  | ```in```  | ```inActualPosition  : LREAL```  |
| VAR_OUTPUT       | camelCase  | ```out``` | ```outActualPosition  : LREAL``` |
| VAR_IN_OUT       | camelCase  | ```ino``` | ```inoActualPosition  : LREAL``` |
| VAR              | camelCase  | ```_```   | ```_actualPosition  : LREAL```,  |
| VAR_STAT         | camelCase  | ```_```   | ```_actualPosition  : LREAL```,  |
| VAR_INST         | camelCase  | ```_```   | ```_actualPosition  : LREAL``` , |
| VAR CONSTANT     | UpperCase  | NoPrefix  | ```MAX_747_CRUISING_ALTITUDE```  |
| REFERENCE        | PascalCase | ```ref``` | ```refDrive```                   |
| INTERFACE name   | PascalCase | NoPrefix  | ```Cyclinder```                  |


> **STRUCT member naming**

| Group          | Notation   | Prefix    | Example              |
|----------------|------------|-----------|----------------------|
| VARIABLE       | PascalCase | NoPrefix  | ```ActualPosition``` |
| REFERENCE      | PascalCase | ```ref``` | ```refDrive```       |
| INTERFACE name | PascalCase | NoPrefix  | ```Cyclinder```      |

> **Features to avoid**

|     Avoid      | Use instead |
| -------------- | ----------- |
| FUNCTION_BLOCK | CLASS       |


> **Features to prefer**

| IF YOU REALLY MUST | EVERYWHERE ELSE |
| ------------------ | --------------- |
| FUNCTION           | CLASS.METHOD    |


## Identifiers

Any identifier (variable, methods, properties) should have an identifier that clearly expresses intent. Identifiers with less than ```4``` characters should be avoided (unless they represent well-known acronyms or expressions). There is no formal constraint on a maximum number of characters; however, about 25 characters should suffice to name the variable appropriately.

## Scope

All variables should be declared closest to the scope where they are used. Avoid using global declarations unless it is necessary or the global scope is required for the application.

### Global scope

Generally, the global scope should be avoided where possible.

## Member Variables

Private CLASS member variables should begin with underscore ```_```, followed by the variable name.

~~~ iecst
VAR PRIVATE
    _trigger : BOOL;
    _counter : INT;
    _analogStatus : AnalogStatus;
END_VAR
~~~

### Constants

Use constants instead of magic numbers. Constants should be all caps. 

Where magic numbers are required for low-level domain-specific operations, these should be managed in the highest level block that makes sense without breaking an abstraction layer. 

## Arrays

Arrays should be 0 based index due to consistency when used on HMI platforms (based on JavaScript, TypeScript, C#).

~~~ PASCAL
VAR
    myArray     : ARRAY[0..9] OF BOOL; // Prefered
    myArray1    : ARRAY[1..10] OF BOOL; // AVOID
END_VAR
~~~

## Namespaces

Variables defined in referenced libraries must be declared using a fully qualified name with the namespace.

~~~ Pascal
VAR
    _mixer : fbMixer; // AVOID!
    _mixer : Mixers.fbMixer; // Like this
END_VAR
~~~

## Methods

Methods names should clearly state the intent. Method name should not have any prefix. The methods should be used to perform some action (Movement, Measurement, Trigger etc.). For obtaining or setting values, prefer properties.

```Pascal
piston.MoveToWork();
laser.Measure();
dmcReader.Trigger();
```

## Properties*

Property names should clearly describe intent. Properties should not start with any prefix. 

## Parameter transfer in cyclic execution.

Whenever a parameter transfer is required during the initialization/cyclic-update of a class, use the ```Run``` method, the parameters passed using this method  must not be changed at runtime.

[Components](components.md)
----
* Expecting future implementation