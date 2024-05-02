# run build

dotnet run --project cake/Build.csproj --do-test --test-level 1 --do-pack --do-publish -n 
exit $LASTEXITCODE;