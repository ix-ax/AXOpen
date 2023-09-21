# Creating new library from template

1. Navigate to ..src/ folder of this repository
2. Run following command in terminal to update library template

~~~PowerShell
dotnet new install .\template.axolibrary\ --force
~~~
    
3. Create library template using following command:

~~~PowerShell
dotnet new axolibrary -o OutputFolder -p ProjectName
~~~

E.G.
~~~PowerShell
dotnet new axolibrary -o components.elements -p AXOpen.Components.Elements
~~~


> ![IMPORTANT]
> Make sure you run all the commands from within the `src` folder of the repository. And parameter -o OutputFolder must be in the `src` folder.

> ![IMPORTANT]
> Parameter -p `ProjectName` must contain ONLY alphanumerical characters and dots. Otherwise inconsistencies may occur.

