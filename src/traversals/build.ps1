
cd ctrl
apax clean
apax install -L
apax build
apax test
cd ..
cd app
apax clean
apax install -L
apax build
apax test
cd ..
dotnet clean ..\traversals\p.proj
dotnet build ..\traversals\p.proj
dotnet test ..\traversals\p.proj --no-build --no-restore
dotnet pack ..\traversals\p.proj --no-buils --no-restore
dotnet slngen ..\traversals\p.proj -o solution.sln --folders true --launch false