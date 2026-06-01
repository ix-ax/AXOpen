# run build

dotnet run --project cake/Build.csproj --do-test --test-level 4 -n
exit $LASTEXITCODE;