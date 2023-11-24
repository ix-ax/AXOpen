![AXOpen Banner](/docfx/images/banner.png)

[![dev](https://github.com/ix-ax/AXOpen/actions/workflows/dev.yml/badge.svg?branch=dev)](https://github.com/ix-ax/axsharp/actions/workflows/dev.yml)
[![preview](https://github.com/ix-ax/AXOpen/actions/workflows/release.yml/badge.svg?branch=releases%2Fv0)](https://github.com/ix-ax/axsharp/actions/workflows/release.yml)
[![master](https://github.com/ix-ax/AXOpen/actions/workflows/master.yml/badge.svg?branch=master)](https://github.com/ix-ax/axsharp/actions/workflows/master.yml)
![semver](https://img.shields.io/badge/semver-0.10.0-blue)
[![GitHub license](https://badgen.net/github/license/Naereen/Strapdown.js)](https://github.com/ix-ax/axsharp/blob/dev/LICENSE)


`AXOpen` (AXO), is an innovative application framework for industrial automation applications. This project leverages the capabilities of [SIMATIC AX](https://simatic-ax.siemens.io) and [AX#](https://github.com/ix-ax/axsharp), amalgamating their unique strengths to deliver a comprehensive solution.

`AXOpen` is developed primarily as an application framework for and within [MTS](mts.sk/en). We opened this repository to share our knowledge with the community of like-minded automation engineers, that see the potential in using software engineering approaches and workflows for industrial automation. AXOpen is capitalizing on previous experiences in the development of [TcOpen](https://github.com/TcOpenGroup/) an application framework based on `TwinCAT3` platform and [Inxton](https://docs.inxton.com/) technology that provided us with tooling that reduced the effort and development time for our industrial application by 70%.

AXOpen is engineered with an object-oriented architecture, bridging the real-time operations of a PLC controller and the extensive adaptability of the .NET ecosystem. This integration ensures unparalleled performance in automation tasks and forms a significant interface with the IT domain.

AXOpen is also highly modular leveraging `apax` package and dependency management system provided by simatic-ax. In addition to controller packages, there are companion `NuGet` packages that can be used to extend simatic-ax libraries in .NET ecosystem.


## SPOCK

The guiding principle in AXOpen is **Single Point Of Change**. The idea is that the underlying framework should provide means to reflect any change in the controller program into higher application levels. So for instance any addition or removal of a component should be automatically reflected in the HMI/UI. In the same way, any modification of a structure destined to be a source of data for an arbitrary database system should reflect automatically through multiple layers up to the target database structure.

To achieve this level of scalability AXOpen uses AX# that provides a transpiler that creates .NET twin library for a simatic-ax based project. The library can be regenerated on the fly with each change of the source project. These twin objects are then used by presentation libraries to generate HMI/UI or allow for mapping objects directly to the database. 

## DECOP

Another leading principle is **DEclarative COntrol Programming**. This approach leverages the OOP in ST. The main idea is to provide components where methods have instructive names and provide an imperative to execute specific tasks. When the task cannot succeed the component reports information about the problem and possible solution to the alarm handler.

A simple example could be a component of a pneumatic cylinder where the call of method `MoveToWork`()` will extend the piston into the working position; if the component does not reach the extremity sensor the component it-self provides the information that the operation could not be successfully execute.

## Brief content overview

AXOpen is designed to simplify the development of industrial automation by covering a broad spectrum of areas. These include coordination (e.g. sequential control), alarm/messaging, components (pneumatics, vision, robotics, etc.), data acquisition, and various utility libraries.

**Controlling sequences**

Sequencers provide coordination patterns to orchestrate tasks into linear sequences.

[Sequencer](assets/readme_pics/sequencer.gif)

**Components**

Withing AXOpen we develop ready-to-use components for a variety of generic and vendor-specific hardware components (pneumatics, drives, sensors, etc.). Each component includes a ready-to-use visual element allowing to control component manually.
Each component has built-in alarms that will report when a component encounters a problem.


[Components](assets/readme_pics/compnents.gif)

**Data**



Moreover, AXOpen comprises powerful tools that expedite the development of HMI/UI applications. It builds upon web technologies (Blazor) and the incredibly powerful [AX# [library](https://ix-ax.github.io/axsharp/articles/blazor/RENDERABLECONTENT.html) for the automated generation of user interfaces. Each library/component within AXOpen comes equipped with ready-to-use visual components, enabling swift deployment in any human-machine interface scenario.

We wish to inform you that AXOpen is currently in its development phase. Our committed team of specialists is diligently working to ensure the final product aligns with our vision of a high-performance, adaptable, and user-friendly framework for industrial automation.

**As we continue to make headway in our developmental journey, we request your patience. Stay tuned for updates regarding the upcoming releases of AXOpen.** Your interest, support, and feedback are invaluable to us and we encourage you to engage with us during the evolution of this project.

To remain updated about our progress, consider starring and subscribing to this repository. 

As we strive to pioneer change in the field of industrial automation with AXOpen, we greatly appreciate your participation and look forward to making strides in this industry together.

## Documentation

In parallel with the project's advancement, we are incrementally building the [documentation](https://ix-ax.github.io/AXOpen/). We invite you to visit the link if you wish to learn more about AXOpen.

## About the repository

More about how the repository is organized and structured see [here](src/README.md).
