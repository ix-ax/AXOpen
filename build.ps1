./scripts/check_requisites.ps1
$args = $args + '-x'
dotnet run --project cake/Build.csproj -- $args
exit $LASTEXITCODE;
