
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
dotnet clean p.proj
dotnet build p.proj
dotnet test p.proj --no-build --no-restore
dotnet pack p.proj --no-buils --no-restore
dotnet slngen p.proj -o solution.sln --folders true --launch false