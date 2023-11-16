./scripts/check_requisites.ps1
$args = $args + '-n -x'
dotnet run --project cake/Build.csproj -- $args
exit $LASTEXITCODE;
