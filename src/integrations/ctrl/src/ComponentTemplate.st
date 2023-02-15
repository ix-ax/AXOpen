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
        // AlwaysVisible : AlwaysVisible_ComponentExample;

        //Expandable : Expandable_ComponentExample;

        {#ix-set:AttributeName = "Some totally different task"}
        SomeTotallyDifferentTask : IxTask;
    END_VAR
END_CLASS

{#ix-attr:[Container(Layout.Wrap)]}
CLASS PUBLIC AlwaysVisible_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Start"}
        Start : IxTask;
        {#ix-set:AttributeName = "Stop"}
        Stop : IxTask;
        {#ix-set:AttributeName = "Status"}
        Status : STRING:='Some status description should be placed here';
    END_VAR
END_CLASS

{#ix-attr:[Container(Layout.Tabs)]}
CLASS PUBLIC Expandable_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Tasks"}
        Tasks : Tasks_ComponentExample;

        {#ix-set:AttributeName = "Details"}
        Details : Details_ComponentExample;

        {#ix-set:AttributeName = "Settings"}
        Settings : Settings_ComponentExample;

        {#ix-set:AttributeName = "Diagnostics"}
        Diagnostics : Diagnostics_ComponentExample;

        {#ix-set:AttributeName = "Help"}
        Help : Help_ComponentExample;
    END_VAR
END_CLASS

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
CLASS PUBLIC Details_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Some detailed value 1"}
        SomeDetailedValue1 : REAL := REAL#45.3;
        {#ix-set:AttributeName = "Some detailed value 2"}
        SomeDetailedValue2 : DINT := DINT#46587;
        {#ix-set:AttributeName = "Some detailed value 3"}
        SomeDetailedValue3 : STRING := 'some description';
    END_VAR
END_CLASS

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

{#ix-attr:[Container(Layout.Stack)]}
CLASS PUBLIC Diagnostics_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Some diagnostic message"}
        SomeDiagnosticMessage : STRING := 'TODO: Some diagnostic message needs to be placed here';
    END_VAR
END_CLASS

{#ix-attr:[Container(Layout.Stack)]}
CLASS PUBLIC Help_ComponentExample
    VAR PUBLIC
        {#ix-set:AttributeName = "Some help"}
        SomeHelp : STRING := 'TODO: Provide some help';
    END_VAR
END_CLASS

