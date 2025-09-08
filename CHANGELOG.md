
### Misc improvements ([#755](https://github.com/Inxton/AXOpen/pull/755))
- Added Aventics pneumatic island GSDML files for device integration.
- Introduced DotnetIxr helper to run "dotnet ixr" across folders (Cake build scripts).
- Added multi-root workspace file (`ctrl-workspace.code-workspace`) for control projects.
- Refactored UI components: improved layout in `AxoComponentView` and `AxoMessengerView`, updated help text formatting in `AxoMessenger`.
- Improved error handling and initialization flow in dialog components.
- Added resource files and designers for localization (Blazor, Data, Inspectors, IO, and component libraries).
- Updated package versions: bumped AXSharp.* to `0.40.1-alpha.287` and Inxton.Operon to `0.2.0-alpha.87`.
- Improved logging messages across multiple modules.

**Note:** UI and dialog refactoring, as well as package version bumps, may affect backward compatibility for customizations or integrations.
