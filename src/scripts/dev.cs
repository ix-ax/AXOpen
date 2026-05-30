#:project ../axopen.dev/AXOpen.Dev.Tool/AXOpen.Dev.Tool.csproj

// In-repo file-based dispatcher for the axdev developer CLI.
// apax aliases call `dotnet run ..\..\scripts\dev.cs -- <verb> <args>`; downstream apps use the
// packed `dotnet axdev <verb>` tool. Both share the same CommandApp (AxdevApp.Build).
// Named dev.cs (not axdev.cs) to avoid an assembly-name clash with the tool (AssemblyName=axdev).
using AXOpen.Dev.Tool;

return AxdevApp.Build().Run(args);
