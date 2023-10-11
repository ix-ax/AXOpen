dotnet tool restore
dotnet clean this.proj
dotnet build this.proj
dotnet slngen this.proj -o axosimple.sln --folders true --launch false
Set-Location app
apax install
apax build
axcode .
axcode -g ..\README.md:0