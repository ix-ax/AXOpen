./scripts/check_requisites.ps1
$args = $args + '-x -n'
dotnet run --project cake/Build.csproj -- $args
exit $LASTEXITCODE;
