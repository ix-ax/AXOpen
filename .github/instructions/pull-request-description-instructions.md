# 📝 GitHub Copilot Instructions: Pull Request Descriptions

## Content Rules

When drafting PR descriptions, **Copilot must**:

1. Follow the PR template (Summary, Changes Introduced, Related Issues, Testing Notes, Checklist).
2. Use precise, specific, and factual language.
3. State explicitly **where changes were made**:

   * If in the **PLC (Controller)** layer.
   * If in the **higher-level framework (.NET)** part of the project.
4. Organize functional changes **by library** if multiple libraries are affected.
5. Clearly note **interdependencies** between libraries or components introduced or updated.
6. Separate **chores** (non-functional tasks) from core changes.

---

## Style Rules

Copilot **must avoid**:

* **All-encompassing phrases**: e.g., “general cleanup”, “overall improvements”.
* **Clichés and vague wording**: e.g., “minor tweaks”, “enhancements”.
* **Unhelpful summaries**: e.g., “fixed bugs”.

✅ Instead, Copilot should write:

* *“Refactored `OrderController` in the PLC layer to centralize validation logic.”*
* *“Bumped Newtonsoft.Json from 13.0.1 → 13.0.2 in CoreLibrary.”*

---

## Organization Guidelines

PR descriptions should be structured in **distinct sections**:

### 1. Functional Changes

Group by library and indicate PLC vs framework.
Example:

* **Library A (DataAccess / .NET framework):** Introduced caching in query layer.
* **Library B (OrderController / PLC):** Added call to caching layer before persisting orders.

### 2. Interdependencies

State explicit links between libraries or modules.
Example:

* *OrderController now requires DataAccess v2.1+ for caching compatibility.*

### 3. Chores

List non-functional changes separately.
Examples:

* **Dependencies:** Updated `Serilog` from 2.12 → 3.0.
* **CI/CD:** Migrated pipeline to use `dotnet test` instead of `nunit-console`.
* **Docs:** Updated README with usage instructions for `ValidationService`.

---

## Example PR Description

**Summary**
Adds centralized validation in PLC controllers and updates libraries for consistent error handling. Includes some dependency and CI housekeeping.

**Functional Changes**

* **PLC Layer**

  * Refactored `UserController` and `OrderController` to use `ValidationService`.
* **CoreLibrary (.NET Framework)**

  * Added `ValidationService`.
* **AuthLibrary (.NET Framework)**

  * Updated token validation to use `ValidationService`.

**Interdependencies**

* `AuthLibrary` now depends on `CoreLibrary.ValidationService`.
* All PLC controllers require CoreLibrary v3.2+.

**Chores**

* Bumped `Newtonsoft.Json` to 13.0.2 in CoreLibrary.
* Updated CI pipeline to run integration tests on .NET 8.
* Adjusted README with new validation examples.

**Related Issues**

* Fixes #123

**Testing Notes**

* Run `dotnet test` in `PLC.Controllers.Tests`.
* Verify login and order creation flows manually.


