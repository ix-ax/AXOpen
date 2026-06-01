# AXOpen.Dev end-to-end tests (optional)

These tests drive the real `apax` CLI / `openssl` / a live PLC. They are **skipped by default** —
each is gated by an environment flag — so a normal `dotnet test` run and CI report them as
*skipped*, never failed.

Run them explicitly from the **app directory's** context (defaults to `src/showcase/app`, override
with `AX_APP_DIR`). Connection settings default to the showcase values; override via env.

## Tiers

| Flag | Scope | Needs |
|------|-------|-------|
| `AXDEV_E2E_DATA=1` | Read-only: ST generators reproduce `src/IO/*.st` byte-for-byte | app dir only |
| `AXDEV_E2E_PLC=1` | Read-only on a **provisioned** PLC: `hw-diag`, `cert-check` | apax + live PLC + local cert |
| `AXDEV_E2E_PLC_DESTRUCTIVE=1` | **Provisions/overwrites** the PLC: secure-comm + HW + SW download | apax + openssl + live PLC |

> **Note:** these read `AX_USERNAME` etc. from the environment. If your shell has a stray
> `AX_USERNAME` (e.g. `adm`), set it explicitly (`AX_USERNAME=admin`) or the PLC will deny access.
> apax also shares one PLC connection session per process, so the PLC read-only test runs the
> authenticated command (`hw-diag`) before the unauthenticated one (`cert-check`).

## Connection env (defaults shown)

```
AX_TARGET=192.168.100.1
AX_PLC_NAME=plc_line
AX_USERNAME=admin
AX_TARGET_PWD=...            # required for PLC tiers (no default)
AX_NAMESPACE=AXOpen.Showcase
AX_PLATFORM=.\bin\1500\
AX_APP_DIR=<repo>/src/showcase/app
```

## Examples

```powershell
# Safe, read-only data check
$env:AXDEV_E2E_DATA=1
dotnet test src/axopen.dev/AXOpen.Dev.E2E.Tests

# Read-only PLC check (PLC already provisioned)
$env:AXDEV_E2E_PLC=1; $env:AX_TARGET_PWD='...'
dotnet test src/axopen.dev/AXOpen.Dev.E2E.Tests --filter PlcReadOnly

# Full provisioning of a blank PLC (DESTRUCTIVE)
$env:AXDEV_E2E_PLC_DESTRUCTIVE=1; $env:AX_TARGET_PWD='...'
dotnet test src/axopen.dev/AXOpen.Dev.E2E.Tests --filter PlcProvisioning
```
