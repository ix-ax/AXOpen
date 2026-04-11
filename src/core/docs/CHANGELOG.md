## Changes
<!--
    Leave the file intact at the end of the file add the following:
    ---------------------------------
    ### {axopen-version}
    New features:
    Bug fixies:
    Other:
    Breaking:
    ---------------------------------

    {axopen-version} replace this with the current settings in GitVersion.yml file.
-->

### 0.43.0

**New features:**
- Added AxoAlert showcase example with dedicated doc markers (`AlertDeclaration`, `AlertShowPattern`, `AlertTypes`, `AlertRestore`)
- Added AxoLogger enriched examples: log levels, SetMinimumLevel, LogWithSender, LogWithMessageCode
- Added AxoContext service injection examples: InjectLogger, InjectMessengerService, InitializeRootObject
- Added AxoSequencerContainer RunOnce and RequestStep/branching examples with localizable descriptions
- Added AxoTask Abort/Resume/Restore code snippet references
- Added AxoDialog simple `Show()` fluent pattern example (HMI-only, without external close)
- Added AxoSequencer SequenceMode example

**Bug fixes:**
- Fixed missing `MapHub<SignalRDialogHub>` in showcase Program.cs — dialogs could not sync across clients
- Fixed missing `AxoRemoteTask.Initialize()` in showcase Program.cs — remote task entered error on invoke
- Fixed missing `AxoLogger.StartDequeuing()` in showcase Program.cs — PLC logs were not forwarded to .NET
- Fixed broken `MessageTextHelpDeclaration` tag reference in AxoMessenger.md (corrected to `PlcTextListDeclaration`)

**Other:**
- Renamed all core documentation files from UPPERCASE to PascalCase (e.g., `AXOTASK.md` → `AxoTask.md`)
- Updated all cross-references, toc.yml, search registry, and Blazor page path constants to match new filenames
- Added comment markers to Program.cs for documentation extraction (`AxoLoggerStartDequeuing`, `AxoRemoteTaskInitialize`, `MapDialogHub`, `AddBlazorServices`, `ConnectorConfiguration`, `AxoApplicationBuilder`)
- Added TROUBLES.md with structured troubleshooting for all core types
- Added CHANGELOG.md

**Breaking changes:**
- Documentation file renames may break external bookmarks or links referencing the old UPPERCASE filenames
