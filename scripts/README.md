# Distribution Scripts

This directory contains automation scripts for building, signing, and distributing PatternSorcerer.

## Scripts Overview

### `build.sh`
Builds the app for development or release.

**Usage:**
```bash
./scripts/build.sh [Debug|Release] [clean]
```

**Examples:**
```bash
# Debug build
./scripts/build.sh

# Release build
./scripts/build.sh Release

# Clean release build
./scripts/build.sh Release clean
```

---

### `distribute.sh`
Complete distribution pipeline: archive, export, sign, create DMG, and optionally notarize.

**Prerequisites:**
- Xcode project configured with signing
- Team ID set (or auto-detected)
- App-specific password for notarization (optional)

**Usage:**
```bash
# Set environment variables (recommended)
export TEAM_ID="YOUR_TEAM_ID"
export APPLE_ID="your@email.com"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"

# Run distribution
./scripts/distribute.sh
```

**What it does:**
1. Checks prerequisites
2. Creates archive
3. Exports archive
4. Verifies code signature
5. Optionally creates DMG
6. Optionally notarizes app

**Output:**
- `build/export/PatternSorcerer.app` - Signed app
- `build/PatternSorcerer.dmg` - DMG (if created)

---

### `notarize.sh`
Standalone script for notarizing an already-built app.

**Prerequisites:**
- App must be properly signed
- App-specific password required

**Usage:**
```bash
# Set environment variables
export APPLE_ID="your@email.com"
export TEAM_ID="YOUR_TEAM_ID"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"

# Notarize app
./scripts/notarize.sh [path/to/app.app]
```

**Default path:** `build/export/PatternSorcerer.app`

**What it does:**
1. Verifies app is signed
2. Creates ZIP for notarization
3. Submits to Apple notarization service
4. Waits for approval
5. Staples ticket to app

---

### `check-signing.sh`
Verifies code signing status and displays signature details.

**Usage:**
```bash
./scripts/check-signing.sh [path/to/app.app]
```

**Default path:** `build/export/PatternSorcerer.app`

**What it shows:**
- Code signature validity
- Signature details (authority, identifier)
- Entitlements
- Certificate chain
- Notarization status

---

## Setup

### 1. Get Your Team ID

**Option 1: From Xcode**
- Open project in Xcode
- Go to Signing & Capabilities
- Team shows as: `Your Name (Personal Team) - ABC123XYZ`
- The `ABC123XYZ` part is your Team ID

**Option 2: From Terminal**
```bash
security find-identity -v -p codesigning | grep "Developer ID"
```

### 2. Create App-Specific Password

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in
3. Go to "Sign-In and Security" → "App-Specific Passwords"
4. Generate password for "PatternSorcerer Notarization"
5. Copy the password (format: `xxxx-xxxx-xxxx-xxxx`)

### 3. Set Environment Variables

**Option 1: Export in shell**
```bash
export TEAM_ID="YOUR_TEAM_ID"
export APPLE_ID="your@email.com"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"
```

**Option 2: Store in ~/.zshrc or ~/.bash_profile**
```bash
# Add to ~/.zshrc
export TEAM_ID="YOUR_TEAM_ID"
export APPLE_ID="your@email.com"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"
```

**Option 3: Use Keychain (for password)**
```bash
security add-generic-password \
  -a "your@email.com" \
  -w "xxxx-xxxx-xxxx-xxxx" \
  -s "PatternSorcerer Notarization"
```

---

## Common Workflows

### Development Build
```bash
./scripts/build.sh Debug
```

### Release Build
```bash
./scripts/build.sh Release
```

### Full Distribution
```bash
# Set environment variables first
export TEAM_ID="YOUR_TEAM_ID"
export APPLE_ID="your@email.com"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"

# Run distribution
./scripts/distribute.sh
```

### Verify Signing
```bash
./scripts/check-signing.sh
```

### Notarize Existing App
```bash
# Set environment variables
export APPLE_ID="your@email.com"
export TEAM_ID="YOUR_TEAM_ID"
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"

# Notarize
./scripts/notarize.sh build/export/PatternSorcerer.app
```

---

## Troubleshooting

### "Team ID not found"
- Set `TEAM_ID` environment variable
- Or find it in Xcode: Signing & Capabilities → Team

### "App-specific password not set"
- Create app-specific password at appleid.apple.com
- Set `NOTARIZATION_PASSWORD` environment variable

### "Code signature verification failed"
- App must be signed before notarization
- Run `distribute.sh` first to sign the app
- Or sign manually in Xcode

### "Notarization failed"
- Check hardened runtime is enabled
- Verify app-specific password is correct
- Check Team ID is correct
- Review notarization logs: `xcrun notarytool history`

### "Certificate expired"
- Free account certificates expire every 7 days
- Xcode will auto-renew for development
- For distribution, re-run `distribute.sh`

---

## Dependencies

### Required Tools
- **Xcode**: For building and signing
- **xcodebuild**: Command-line build tool
- **codesign**: Code signing tool
- **xcrun notarytool**: Notarization tool (Xcode 13+)
- **hdiutil**: DMG creation (built-in)

### Optional Tools
- **create-dmg**: Better DMG creation (install via Homebrew: `brew install create-dmg`)
- **jq**: JSON parsing (for notarize.sh, install via Homebrew: `brew install jq`)

---

## Script Configuration

### Default Values
Scripts use these defaults (can be overridden):
- **Scheme**: `PatternSorcerer`
- **Configuration**: `Release` (for distribution)
- **Build Directory**: `build`
- **Export Directory**: `build/export`

### Customization
Edit scripts to change:
- App name
- Build directories
- Archive names
- DMG settings

---

## Security Notes

- **Never commit** app-specific passwords to git
- Use environment variables or Keychain
- Store Team ID in environment (not sensitive)
- Keep certificates secure (Xcode handles this)

---

## Additional Resources

- [Setup Guide](../docs/SETUP_GUIDE_FREE_ACCOUNT.md) - Complete setup instructions
- [Distribution Guide](../docs/DISTRIBUTION_AND_SIGNING.md) - Detailed distribution documentation
- [Quick Reference](../docs/DISTRIBUTION_QUICK_REFERENCE.md) - Quick decision guide

---

## Support

If scripts fail:
1. Check prerequisites (Xcode, tools)
2. Verify environment variables
3. Check Xcode console for errors
4. Review script output for clues
5. See troubleshooting section above

