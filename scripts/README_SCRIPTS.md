# Scripts Reference

Complete reference for all automation scripts in PatternSorcerer.

## Quick Reference

| Script | Purpose | Usage |
|--------|---------|-------|
| `build.sh` | Build app | `./scripts/build.sh [Debug\|Release]` |
| `test.sh` | Run tests | `./scripts/test.sh [all\|unit\|integration\|ui]` |
| `run.sh` | Build and run | `./scripts/run.sh [Debug\|Release]` |
| `version.sh` | Version management | `./scripts/version.sh [increment\|show\|set]` |
| `distribute.sh` | Distribution | `./scripts/distribute.sh` |
| `notarize.sh` | Notarize app | `./scripts/notarize.sh [app_path]` |
| `check-signing.sh` | Verify signing | `./scripts/check-signing.sh [app_path]` |

## Detailed Usage

### build.sh

Builds the app for development or release.

```bash
# Debug build
./scripts/build.sh

# Release build
./scripts/build.sh Release

# Clean release build
./scripts/build.sh Release clean
```

**Options:**
- First argument: `Debug` or `Release` (default: `Debug`)
- Second argument: `clean` to clean before building

---

### test.sh

Runs tests (unit, integration, UI, or all).

```bash
# Run all tests
./scripts/test.sh

# Run unit tests only
./scripts/test.sh unit

# Run integration tests
./scripts/test.sh integration

# Run UI tests
./scripts/test.sh ui
```

**Options:**
- `all` or `a` - Run all tests (default)
- `unit` or `u` - Unit tests only
- `integration` or `i` - Integration tests only
- `ui` - UI tests only

---

### run.sh

Builds and runs the app.

```bash
# Build and run Debug
./scripts/run.sh

# Build and run Release
./scripts/run.sh Release
```

**Options:**
- `Debug` or `Release` (default: `Debug`)

---

### version.sh

Manages version numbers in format: `yyyy.dd.build`

```bash
# Increment build number (default)
./scripts/version.sh increment

# Show current version
./scripts/version.sh show

# Set version manually
./scripts/version.sh set 2025.123.5
```

**Version Format:**
- `yyyy` - Year (e.g., 2025)
- `dd` - Day of year (1-366)
- `build` - Build number (increments daily)

**Behavior:**
- Same day: Increments build number
- New day: Resets build to 1

**Examples:**
```bash
# Today is day 123 of 2025, first build today
./scripts/version.sh increment
# Result: 2025.123.1

# Second build today
./scripts/version.sh increment
# Result: 2025.123.2

# Next day (day 124)
./scripts/version.sh increment
# Result: 2025.124.1
```

---

### distribute.sh

Complete distribution pipeline (archive, export, sign, DMG, notarize).

**Prerequisites:**
```bash
export TEAM_ID="YOUR_TEAM_ID"
export APPLE_ID="your@email.com"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"
```

**Usage:**
```bash
./scripts/distribute.sh
```

**What it does:**
1. Creates archive
2. Exports archive
3. Verifies code signature
4. Creates DMG (optional)
5. Notarizes app (optional)

---

### notarize.sh

Standalone notarization script.

**Usage:**
```bash
export APPLE_ID="your@email.com"
export TEAM_ID="YOUR_TEAM_ID"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"

./scripts/notarize.sh [path/to/app.app]
```

**Default path:** `build/export/PatternSorcerer.app`

---

### check-signing.sh

Verifies code signing status.

**Usage:**
```bash
./scripts/check-signing.sh [path/to/app.app]
```

**Default path:** `build/export/PatternSorcerer.app`

**Shows:**
- Code signature validity
- Signature details
- Entitlements
- Certificate chain
- Notarization status

---

## Common Workflows

### Development Workflow

```bash
# Build
./scripts/build.sh

# Run tests
./scripts/test.sh

# Build and run
./scripts/run.sh
```

### Release Workflow

```bash
# Increment version
./scripts/version.sh increment

# Build release
./scripts/build.sh Release

# Run all tests
./scripts/test.sh

# Distribute
./scripts/distribute.sh
```

### Quick Development Cycle

```bash
# One command: test, build, run
./scripts/test.sh && ./scripts/run.sh
```

---

## Environment Variables

### For Distribution
```bash
export TEAM_ID="YOUR_TEAM_ID"
export APPLE_ID="your@email.com"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"
```

### For Version Management
```bash
export VERSION_FILE=".version"  # Default
export INFO_PLIST="PatternSorcerer/Info.plist"  # Default
```

---

## Troubleshooting

### Scripts not executable
```bash
chmod +x scripts/*.sh
```

### Version script can't find Info.plist
- Check path: `./scripts/version.sh set 2025.123.1 PatternSorcerer/Info.plist`

### Test script can't find scheme
- Verify scheme name is `PatternSorcerer`
- Check Xcode project is configured

### Distribution script fails
- Verify Team ID is set
- Check certificates are valid
- Ensure app-specific password is correct

---

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Run Tests
        run: ./scripts/test.sh
      
      - name: Build
        run: ./scripts/build.sh Release
      
      - name: Increment Version
        run: ./scripts/version.sh increment
```

---

## Script Dependencies

All scripts require:
- **macOS** (for Xcode tools)
- **Xcode** (for xcodebuild)
- **bash** (for shell scripts)

Some scripts require:
- **PlistBuddy** (for version.sh)
- **codesign** (for signing scripts)
- **xcrun notarytool** (for notarization)

---

See individual script files for more details.

