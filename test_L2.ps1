# run build

dotnet run --project cake/Build.csproj --do-test true --do-pack false --test-level 2
exit $LASTEXITCODE;