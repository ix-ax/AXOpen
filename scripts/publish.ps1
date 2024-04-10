# run build

dotnet run --project cake/Build.csproj --do-pack --do-publish -n
exit $LASTEXITCODE;