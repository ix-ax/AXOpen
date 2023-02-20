using ix.framework.core;

{#ix-attr:[Container(Layout.Stack)]}
{#ix-set:AttributeName = "Component example name"}
CLASS PUBLIC ComponentExample EXTENDS IxComponent 
    METHOD PROTECTED OVERRIDE Restore: IIxTask 
        ;
    END_METHOD
    METHOD PROTECTED OVERRIDE ServiceMode
        ;
    END_METHOD


    VAR PUBLIC
        // Complete structure as a part of the component header. 
        // All structure members are going to be displayed in the component header.
        {#ix-attr:[Container(Layout.Wrap)]}
        {#ix-attr:[ComponentHeader()]}
        Header : Header_ComponentExample;

        // Two separate tasks as a part of the component header. 
        // These tasks are going to be added to the previous members of the component header.
        {#ix-attr:[ComponentHeader()]}        
        {#ix-set:AttributeName = "Header task 1"}
        HeaderTask1 : IxTask;
        {#ix-attr:[ComponentHeader()]}
        {#ix-set:AttributeName = "Header task 2"}
        HeaderTask2 : IxTask;

        // Single task as a part of the component details tab `Tasks`. 
        // This task is going to be displayed in the component details tab `Tasks`
        {#ix-attr:[ComponentDetails("Tasks")]}
        {#ix-set:AttributeName = "Detail task in Tasks tab"}
        DetailTaskInTasksTab : IxTask;
 
        // Complete structure as a part of the component details tab `Tasks`. 
        // All structure members are going to be added to the previous members of the component details tab `Tasks`.
        {#ix-set:AttributeName = "Tasks"}
        Tasks : Tasks_ComponentExample;
 
        // Complete structure as a part of the component details tab `Status` as the attribute [ComponentDetails("Status")] 
        // is defined on the class Status_ComponentExample. 
        // All structure members are going to be added to the previous members of the component details tab `Status`.
        {#ix-set:AttributeName = "Status class"}
        Status :Status_ComponentExample;

        // Single variable as a part of the component details tab `Status`. 
        // This variable is going to be added to the previous members of the component details tab `Status`.
        {#ix-attr:[ComponentDetails("Status")]}
        {#ix-set:AttributeName = "Status string"}
        Status2 : string;

        // Additional separate task as a part of the component header. 
        // This task is going to be added to the previous members of the component header.
        {#ix-attr:[ComponentHeader()]}
        {#ix-set:AttributeName = "Header task 3"}
        HeaderTask3 : IxTask;
 
        // Separate task as a part of the component details with no tab name defined. 
        // This task is going to be displayed inside the last component details tab `Tab name not defined`.
        {#ix-attr:[ComponentDetails()]}
        {#ix-set:AttributeName = "Detail task without tab name defined"}
        DetailTaskWithoutTabName : IxTask;

        // Complete structure as a part of the component details tab `Settings` as the attribute [ComponentDetails("Settings")] 
        // is defined on the class Settings_ComponentExample. 
        // All structure members are going to be added to the previous members of the component details tab `Settings`.
        {#ix-set:AttributeName = "Settings"}
        Settings : Settings_ComponentExample;

        // Complete structure as a part of the component details tab `Diagnostics` as the attribute [ComponentDetails("Diagnostics")] 
        // is defined on the class Diagnostics_ComponentExample. git 
        // All structure members are going to be added to the previous members of the component details tab `Diagnostics`.
        {#ix-set:AttributeName = "Diagnostics"}
        Diagnostics : Diagnostics_ComponentExample;

        // Complete structure as a part of the component details tab `Help` as the attribute [ComponentDetails("Help")] 
        // is defined on the class Help_ComponentExample. 
        // All structure members are going to be added to the previous members of the component details tab `Help`.
        {#ix-set:AttributeName = "Help"}
        Help : Help_ComponentExample; 
    END_VAR
END_CLASS



CLASS PUBLIC Header_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Start"}
        Start : IxTask;
        {#ix-set:AttributeName = "Stop"}
        Stop : IxTask;
        {#ix-set:AttributeName = "Status"}
        Status : STRING:='Some status description should be placed here';
    END_VAR
END_CLASS

{#ix-attr:[ComponentDetails("Tasks")]}
{#ix-attr:[Container(Layout.Tabs)]}
CLASS PUBLIC Expandable_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Tasks"}
        Tasks : Tasks_ComponentExample;

        {#ix-set:AttributeName = "Status"}
        Status : Status_ComponentExample;

        {#ix-set:AttributeName = "Settings"}
        Settings : Settings_ComponentExample;

        {#ix-set:AttributeName = "Diagnostics"}
        Diagnostics : Diagnostics_ComponentExample;

        {#ix-set:AttributeName = "Help"}
        Help : Help_ComponentExample;
    END_VAR
END_CLASS

{#ix-attr:[ComponentDetails("Tasks")]}
{#ix-attr:[Container(Layout.Stack)]}
CLASS PUBLIC Tasks_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Some advanced component task 1"}
        SomeAdvancedComponentTask1 : IxTask;
        {#ix-set:AttributeName = "Some advanced component task 2"}
        SomeAdvancedComponentTask2 : IxTask;
        {#ix-set:AttributeName = "Some advanced component task 3"}
        SomeAdvancedComponentTask3 : IxTask;
        {#ix-set:AttributeName = "Some advanced component task 4"}
        SomeAdvancedComponentTask4 : IxTask;
        {#ix-set:AttributeName = "Some advanced component task 5"}
        SomeAdvancedComponentTask5 : IxTask;
    END_VAR
END_CLASS

{#ix-attr:[Container(Layout.Stack)]}
{#ix-attr:[ComponentDetails("Status")]}
CLASS PUBLIC Status_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Some status value 1"}
        SomeStatusValue1 : REAL := REAL#45.3;
        {#ix-set:AttributeName = "Some status value 2"}
        SomeStatusValue2 : DINT := DINT#46587;
        {#ix-set:AttributeName = "Some status value 3"}
        SomeStatusValue3 : STRING := 'some description';
    END_VAR
END_CLASS

{#ix-attr:[ComponentDetails("Settings")]}
{#ix-attr:[Container(Layout.Stack)]}
CLASS PUBLIC Settings_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Some setting value 1"}
        SomeSettingValue1 : REAL := REAL#45.3;
        {#ix-set:AttributeName = "Some setting value 2"}
        SomeSettingValue2 : DINT := DINT#46587;
        {#ix-set:AttributeName = "Some setting value 3"}
        SomeSettingValue3 : STRING := 'some setting';
    END_VAR
END_CLASS

{#ix-attr:[ComponentDetails("Diagnostics")]}
{#ix-attr:[Container(Layout.Stack)]}
CLASS PUBLIC Diagnostics_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Some diagnostic message"}
        SomeDiagnosticMessage : STRING := 'TODO: Some diagnostic message needs to be placed here';
    END_VAR
END_CLASS

{#ix-attr:[ComponentDetails("Help")]}
{#ix-attr:[Container(Layout.Stack)]}
CLASS PUBLIC Help_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Some help"}
        SomeHelp : STRING := 'TODO: Provide some help';
    END_VAR
END_CLASS

