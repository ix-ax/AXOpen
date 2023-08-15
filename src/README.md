# Creating new library from template

1. Navigate to ..src/ folder of this repository
2. Run following command in terminal to update library template

~~~PowerShell
dotnet new install .\template.axolibrary\ --force
~~~
    
3. Create library template using following command:

~~~PowerShell
dotnet new axolibrary -o OutputFolder -n LibraryName -ax axlibraryname
 -p AXOpen.Components.Pneumatics
~~~

> ![IMPORTANT]
> Make sure you run all the commands from within the `src` folder of the repostory. And paramter -o OutputFolder must be in the `src` folder.

> ![IMPORTANT]
> Paramter -n `LibraryName` must contain ONLY alphanumerical characters

> ![IMPORTANT]
> Paramter -ax `axlibraryname` should be lower case (can contain characters that are permissible for npm package/library name, including '.')


