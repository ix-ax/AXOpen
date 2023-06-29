# run build

dotnet run --project cake/Build.csproj --do-test --test-level 2
exit $LASTEXITCODE;