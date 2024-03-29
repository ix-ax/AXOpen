# About this Repository

## Pre-requisites

- APAX 2.0.0
- AXCODE 
- DOTNET 6.0, 7.0
- VSCODE or VS2022

### Add package source

To get access to the packages from `AX#` and `AXOpen` you will need to authenticate to a dedicated package feed hosted on GitHub. Authentication is free. If you do not have a GitHub account please consider creating one by signing up at https://github.com.

~~~
dotnet nuget add source --username GITHUBUSERNAME --password PAT  --store-password-in-clear-text --name gh-packages-ix-ax "https://nuget.pkg.github.com/ix-ax/index.json"
~~~

Replace GITHUBUSERNAME with your github name
Replace PAT with your Personal Access Token ([how to create your PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token))


### Checking pre-requisites using script

To check pre-requisites in your enviroment run [check_requisites.ps1](../scripts/check_requisites.ps1) script.



~~~Powershell
# cd into your `axopen` folder
.\scripts\check_requisites.ps1
~~~

## Build this repository

In order to build this repostory run [build.ps1](../build.ps1) script.

~~~Powershell
# cd into your `axopen` folder
.\build.ps1 
~~~

## Directory Structure

### **docfx**

Contains documentation for this repository.

```
docfx/
│
├── api/
│   └── API for .NET part of the framework (autogenerated from code)
│
├── apictlr/
│   └── API for controller part of the framework (autogenerated from code)
│
├── apidoc/
│   └── Table of contents for API documentation
│
├── articles/
│   └── Various articles
│
├── components/
│   ├── Documentation for components
│   └── toc.yml (new component library doc ref needs to be added here)
│
├── framework/
│   ├── Documentation for framework 
│   └── toc.yml (new framework library doc ref needs to be added here)
│
├── images/
│   └── Icons and images (some are used in articles)
│
└── templates/
    └── Documentation site templates
```

> [!NOTE]
> When adding a new library, update `components/toc.yml` for components and `framework/toc.yml` for framework libraries manually.

To test the documentation, run the following script from the repository root folder:

```Powershell
.\scripts\build_test_docu.ps1
```

It will create docs-test folder that is git-ignored.

### **docs**

The docs folder contains the documentation site. It should be generated on the appropriate branch used to publish the documentation.

> [!IMPORTANT]
> Never commit changes to the `docs` directory!

### **scripts**

Contains various scripts.

### **src**

Contains all source code related to AXOpen. Each library is placed in a separate directory which has:

```
library/
│
├── app/
│   └── Sandbox for testing the library, integration tests, and documentation code (linked to the library's actual documentation)
│
├── ctrl/
│   ├── src/      # Library source code
│   ├── tests/    # Unit tests
│   └── docs/     # (optional) Controller code documentation
│
├── src/          # .NET twin and Blazor twin
│
├── tests/        # Tests of various levels
│
├── docs/         # Library documentation
│
├── this.proj     # Traversal project. Use to create a solution file for this library [see](README.md#creating-solution-file-from-traversal-project-file)
│
└── slngen.ps     # Generates solution file from `this.proj`
```

## APAX Package Versions

> [!IMPORTANT]
> All apax packages on the default branch (dev) have a fixed version '0.0.0-dev.0'. This version must not be changed by any commit. 
> The version is assigned at build time in the CI/CD pipeline.


## Central Package Management System

This project's NuGet packages versions are organized centrally. You shouldn't assign a package version in your project file. In exceptional cases, you can use a version override. Actual versions are defined in [src/Directory.Packages.props](Directory.Packages.props).

For more information on central package management, visit [here](https://learn.microsoft.com/en-us/nuget/consume-packages/Central-Package-Management).

## Directory-Based Build

Some build aspects of all .NET projects are defined in [src/Directory.Build.props](Directory.Build.props). Learn more [here](https://learn.microsoft.com/en-us/visualstudio/msbuild/customize-by-directory?view=vs-2022).

## Creating Solution File from Traversal Project File

You will find several traversal `*.proj` files. These are used in the CI/CD process in place of solution `*.sln` files. To create solution files from traversal files, use:

```
dotnet slngen [traversal-project-name].proj -o [output-solution-file].sln --folders true --launch false
```

> [!IMPORTANT]
> Re-create your solution whenever the repository changes to refresh newly added, removed, or modified projects.

You can then open the solution file in Visual Studio as needed.

## Creating a New Library from Template

### Use script

Run the following script from the repository root folder:

```PowerShell
.\scripts\create_template_library.ps1 -OutputDirectory OutputFolder -ProjectNamespace Project.Namespace
```

For example:

```PowerShell
.\scripts\create_template_library.ps1 -OutputDirectory components.elements -ProjectNamespace AXOpen.Components.Elements
```

### Manual create

1. Navigate to the `src/` folder of this repository.
2. Run the following command to update the library template:

```PowerShell
dotnet new install .\template.axolibrary\ --force
```

3. Create a library template using:

```PowerShell
dotnet new axolibrary -o OutputFolder -p ProjectName
```

For example:

```PowerShell
dotnet new axolibrary -o components.elements -p AXOpen.Components.Elements
```

> [!NOTE]
> Make sure you run `apax install` and `apax build` after new library is created.

> [!IMPORTANT]
> Ensure you run all commands from the `src` folder of the repository. The `-o OutputFolder` parameter must be within the `src` folder.

> [!IMPORTANT]
> The `-p ProjectName` parameter must contain ONLY alphanumeric characters and dots. Otherwise, inconsistencies may occur.


---
## Creating an AXOpen Application

### Scaffolding the application in AXOpen repository

### Introduction

When developing new applications using the AXOpen framework, there are multiple avenues developers can consider. The script described here provides path to one of the methods, and it's a preferred choice for AXOpen contributors. This technique grants developers the privilege of working directly with the AXOpen framework's source code. Leveraging this script ensures a streamlined process of scaffolding new applications, integrating them with the AXOpen Source Repository, and maintaining them in a dedicated directory.

It's important to recognize, however, that directly interacting with the source repository can lead to slower compile and build times due to the overhead associated with managing the complete framework's source code.

### Leveraging the AXOpen Source Repository

It's noteworthy that the `.application` directory is deliberately excluded from the source control of the primary repository. This design choice allows developers the flexibility to initiate their own repositories within this space, ensuring direct access and reference to the AXOpen library's source code.

#### Scaffolding Your Application

To begin scaffolding your application, you should run the `scripts/create_application.ps1` command.

>[!NOTE]
> While this script assists in setting up your application in the `src/.application` folder, it doesn't handle the initialization of source control for this directory. This step must be managed independently.

>[!NOTE]
> Ensure that the `src/.application` directory is vacant before executing the script to prevent potential issues.

```powershell
.\scripts\create_application.ps1 -ProjectName MyNewProject
```

When prompted

```
Template is configured to run the following action:
Actual command: install.cmd
Do you want to run this action [Y(yes)|N(no)]?
```

Answer `Yes` or revise the script and run it manually later from the target folder.

>[!WARNING]
> Please ensure you understand the implications of running scripts on your system.

Follow the instruction in the README.md file.


