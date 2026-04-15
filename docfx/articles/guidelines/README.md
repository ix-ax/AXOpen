# AXOpen Development Guidelines

This section groups documents that define how to design, implement, test, document and package code inside the AXOpen framework.

## Scope

Use these guideline articles when you:

* Create or extend a component (`AxoComponent` derivative)
* Add or modify tasks / operations (`AxoTask` usage inside components – see `TemplateComponent` examples)
* Introduce new data contracts (config / status) or abstractions
* Add UI (auto–rendered via `RenderableContentControl` or custom Blazor pages)
* Integrate security (roles, groups, repositories)

## Related Articles

| Topic | Document |
|-------|----------|
| Naming, layout & code style | `Conventions.md` |
| Performance / controller sizing | `PERFORMANCE.md` |
| Component structure & lifecycle | `components.md` |

## Core Concepts (Quick Recap)

* **AxoComponent** – Abstract base in `AXOpen.Core`, requires `Restore()` and `ManualControl()` implementation. Use additional `Run(...)` methods for cyclic logic, task invocation and IO marshaling. See `src/core/docs/AXOCOMPONENT.md` for extended examples.
* **Tasks (`AxoTask`)** – Encapsulate multi‑cycle or even single‑cycle actions; always expose actions through methods returning `IAxoTaskState` (see `TemplateComponent` methods like `TemplateMethod_10steps_1`).
* **Configuration vs Status** – Configuration (STRUCT or CLASS per component guideline) supplies tunables; Status reports runtime state, errors, diagnostic / trace data. Both should be accessible through `GetConfig` / `GetStatus` patterns and documented inline.
* **Rendering** – Prefer auto rendering using `<RenderableContentControl Context="..." Presentation="Command|Status" />`. Use layout attributes (`ComponentHeader`, `ComponentDetails`) defined on members of the component to shape generated UI.
* **Security** – Added through `builder.Services.ConfigureAxBlazorSecurity((userRepo, groupRepo), Roles.CreateRoles())`. Roles are simple string constants collected in a static factory (e.g. `process_settings_access`).

## Expectations for New / Updated Code

1. Follow naming & access modifier rules (see `Conventions.md`).
2. Public & protected members: document with XML / docfx comments and provide code snippets or example usage when non‑trivial.
3. Maintain semantic versioning discipline: breaking contract changes (public surface) only with major version increments.
4. Place tests near their domain (axunit for ST logic; integration tests for data / repository / remote tasks) – mirror existing `tests` folder patterns.
5. Keep cyclic `Run` methods lean: split IO marshaling, task invocation and housekeeping into clearly separated regions or private helpers.

## When Something Differs From These Docs

If you spot divergence between implementation (e.g., signature changes, renamed roles, updated rendering attributes) and these articles:

* Update the article in the same pull request as the code change OR
* Open an issue using the documentation template (link present in `LIBRARYHEADER.md`).


---
For deeper dives start with `components.md` and `AXOCOMPONENT.md`, then explore examples under `src/*/app/src/Examples` and Blazor pages under `app/ix-blazor`.



