# run build

dotnet run --project cake/Build.csproj --do-test --do-pack --do-publish --test-level 1 -n -x
exit $LASTEXITCODE;