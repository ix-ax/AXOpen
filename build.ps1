./scripts/check_requisites.ps1

dotnet run --project cake/Build.csproj -- $args
exit $LASTEXITCODE;
