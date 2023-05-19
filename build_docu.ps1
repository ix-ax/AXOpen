# dotnet run --project ..\ix\src\ix.compiler\src\ixd\Ix.ixd.csproj --framework net7.0 -x .\src\core\ctrl\ -o .\docfx\apictrl\
dotnet ixd -x .\src\core\ctrl\ -o .\docfx\apictrl\core\
dotnet ixd -x .\src\messaging\ctrl\ -o .\docfx\apictrl\messaging\
dotnet ixd -x .\src\abstractions\ctrl\ -o .\docfx\apictrl\abstractions\
dotnet docfx .\docfx\docfx.json --debug
dotnet docfx serve .\docs\
