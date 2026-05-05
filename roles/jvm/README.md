# jvm role

Installs the JVM development stack via SDKMAN.

## What it does

- Installs SDKMAN to `~/.sdkman` (as `dev_user`)
- Writes `~/.bashrc.d/sdkman.sh` to activate SDKMAN in new shells
- Installs Java at `java_version` via SDKMAN
- Installs Gradle at `gradle_version` via SDKMAN
- Installs Groovy at `groovy_version` via SDKMAN

## Variables

| Variable | Example | Description |
|---|---|---|
| `dev_user` | `sampo` | User to install SDKMAN and SDKs for |
| `dev_home` | `/home/sampo` | Home directory path |
| `java_version` | `21.0.11-tem` | SDKMAN Java candidate version |
| `gradle_version` | `9.5.0` | SDKMAN Gradle candidate version |
| `groovy_version` | `4.0.31` | SDKMAN Groovy candidate version |

## Idempotency

SDKMAN install uses `creates: ~/.sdkman`. Each SDK install uses `creates:` pointing to the versioned candidate directory — skips if already present.
