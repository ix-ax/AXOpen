
cd ctrl
apax clean
apax install
apax build
apax test
cd ..
cd app
apax clean
apax install
apax build
apax test
cd ..
dotnet clean lib.proj
dotnet build lib.proj
dotnet test lib.proj --no-build --no-restore
dotnet pack lib.proj --no-buils --no-restore
dotnet slngen lib.proj -o solution.sln --folders true --launch false