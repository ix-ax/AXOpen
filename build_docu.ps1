# dotnet run --project ..\ix\src\ix.compiler\src\ixd\Ix.ixd.csproj --framework net7.0 -x .\src\core\ctrl\ -o .\docfx\apictrl\
dotnet ixd -x .\src\abstractions\ctrl .\src\data\ctrl\ .\src\core\ctrl -o .\docfx\apictrl\
dotnet docfx .\docfx\docfx.json --debug
dotnet docfx serve .\docs\
