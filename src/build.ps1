cd .\abstractions\ax\
apax clean
apax update
apax install
apax build
apax test
cd ..\..\ 




cd .\core\ax\
apax clean
apax update
apax install
apax build
apax test
cd ..\..\

cd .\integrations\ax
apax clean
apax update
apax install
dotnet run --project ..\..\..\..\ix\src\ix.builder\src\ixc\Ix.ixc.csproj
apax build
apax test
apax sld --accept-security-disclaimer -t 192.168.0.1 -i .\bin\1500\ -r --default-server-interface
cd ..\..\