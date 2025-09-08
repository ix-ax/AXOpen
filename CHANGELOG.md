
### Misc improvements ([#755](https://github.com/Inxton/AXOpen/pull/755))

**Note:** UI and dialog refactoring, as well as package version bumps, may affect backward compatibility for customizations or integrations.



- feat: Added Aventics pneumatic island GSDMLs (V2.3 & V2.34) for Siemens PLC integration
- feat: DotnetIxr Cake helper for executing `dotnet ixr` across folders
- feat: Added multi-root workspace file (`ctrl-workspace.code-workspace`) for control projects
- feat: Localization resource files (.resx) for Blazor, Data, Inspectors, IO, and component libraries
- refactor: Improved layouts in `AxoComponentView` and `AxoMessengerView`; updated help text formatting
- refactor: Dialog subsystem—better error handling and initialization
- chore: Bumped AXSharp.* to 0.40.1-alpha.287 and Inxton.Operon to 0.2.0-alpha.87
- misc: Improved logging and message consistency across modules
- fix: Minor stability and quality adjustments

**Impact:**
- Easier onboarding for pneumatic islands
- Faster interface generation via ixr helper
- Cleaner UI and improved operator/developer experience
- Foundation for multilingual deployments
- Larger solution surface mainly from resource and GSDML XML additions

**Risks/Review:**
- Validate GSDML XMLs in engineering tools
- Confirm resource file conventions
- Test DotnetIxr helper in CI
- Check UI for regressions

**Testing:**
- Manual validation implied; further import/build/smoke tests recommended
