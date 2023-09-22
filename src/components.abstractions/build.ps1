
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
dotnet clean tmp_sol_.proj
dotnet build tmp_sol_.proj
dotnet test tmp_sol_.proj --no-build --no-restore
dotnet pack tmp_sol_.proj --no-buils --no-restore
dotnet slngen tmp_sol_.proj -o solution.sln --folders true --launch false