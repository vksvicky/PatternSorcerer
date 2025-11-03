# Step-by-Step Setup Guide: Free Apple Developer Account

This guide walks you through setting up code signing and distribution for PatternSorcerer using a free Apple Developer account.

---

## Prerequisites

- macOS computer (for development)
- Apple ID (free)
- Xcode installed (free from Mac App Store)
- Internet connection

---

## Step 1: Create Free Apple Developer Account

### 1.1 Sign Up

1. Go to [developer.apple.com](https://developer.apple.com)
2. Click **"Account"** in the top menu
3. Click **"Sign In"** or **"Create Apple ID"**
4. Use your existing Apple ID or create a new one (free)

### 1.2 Enroll (Optional for Free Account)

**Note:** For free accounts, you don't need to enroll in the paid program. However, you may need to:
- Accept Apple Developer Agreement (if prompted)
- Provide basic information (name, country, etc.)

**You do NOT need to:**
- Pay $99
- Provide credit card
- Complete full enrollment

### 1.3 Verify Account

- Check your email for verification
- Complete any required verification steps
- You should now have access to developer.apple.com

---

## Step 2: Configure Xcode for Code Signing

### 2.1 Open Xcode Preferences

1. Open **Xcode**
2. Go to **Xcode → Settings** (or **Preferences** on older versions)
3. Click **"Accounts"** tab (or **"Accounts"** in older versions)

### 2.2 Add Apple ID

1. Click the **"+"** button at bottom left
2. Select **"Apple ID"**
3. Enter your Apple ID email and password
4. Click **"Sign In"**
5. Your account should appear in the list

### 2.3 Verify Team

1. Select your Apple ID in the list
2. You should see your **"Personal Team"** listed
3. Note your **Team ID** (you'll need this later)

**Example:**
```
Team: Your Name (Personal Team)
Team ID: ABC123XYZ
```

---

## Step 3: Create Xcode Project

### 3.1 Create New Project

1. Open **Xcode**
2. **File → New → Project**
3. Select **"macOS"** tab
4. Choose **"App"**
5. Click **"Next"**

### 3.2 Configure Project

**Project Settings:**
- **Product Name:** `PatternSorcerer`
- **Team:** Select your Personal Team (from dropdown)
- **Organization Identifier:** `club.cycleruncode`
- **Bundle Identifier:** `club.cycleruncode.PatternSorcerer`
- **Language:** Swift
- **Interface:** SwiftUI
- **Storage:** SwiftData (or Core Data)
- **Minimum Deployment:** macOS 13.0 (or 14.0 for SwiftData)

6. Click **"Next"**
7. Choose location to save
8. Click **"Create"**

### 3.3 Verify Automatic Signing

1. Select your project in the navigator
2. Select the **PatternSorcerer** target
3. Go to **"Signing & Capabilities"** tab
4. Check **"Automatically manage signing"**
5. Verify **Team** is selected (your Personal Team)
6. Verify **Bundle Identifier** is unique

**You should see:**
```
✓ Automatically manage signing
Team: Your Name (Personal Team)
Bundle Identifier: club.cycleruncode.PatternSorcerer
```

---

## Step 4: Configure Build Settings

### 4.1 Set Build Configuration

1. Select your project in navigator
2. Select **PatternSorcerer** target
3. Go to **"Build Settings"** tab
4. Search for **"Code Signing"**

### 4.2 Configure Code Signing

**For Development:**
- **Code Signing Identity:** `Apple Development`
- **Development Team:** Your Personal Team

**For Distribution (Release):**
- **Code Signing Identity:** `Developer ID Application`
- **Development Team:** Your Personal Team

### 4.3 Enable Hardened Runtime

1. Still in **"Signing & Capabilities"** tab
2. Click **"+ Capability"** if needed
3. Add **"Hardened Runtime"** (required for notarization)
4. Configure entitlements as needed

**Required Entitlements:**
- ✅ Hardened Runtime
- ⚠️ App Sandbox (optional for outside App Store)

---

## Step 5: Test Build and Signing

### 5.1 Build for Development

1. Select **"My Mac"** as destination
2. Press **⌘B** (or **Product → Build**)
3. Wait for build to complete

**What to expect:**
- Build should succeed
- Xcode will automatically create certificates if needed
- You may see a message about certificates being created

### 5.2 Verify Signing

1. After build, open **Terminal**
2. Navigate to build folder:
   ```bash
   cd ~/Library/Developer/Xcode/DerivedData
   find . -name "PatternSorcerer.app" -type d
   ```
3. Check code signature:
   ```bash
   codesign -dv --verbose=4 /path/to/PatternSorcerer.app
   ```

**You should see:**
```
Authority=Apple Development: Your Name (XXXXXXXXXX)
```

### 5.3 Run App

1. In Xcode, press **⌘R** (or **Product → Run**)
2. App should launch successfully
3. No errors = signing is working!

---

## Step 6: Create App-Specific Password (for Notarization)

### 6.1 Generate App-Specific Password

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in with your Apple ID
3. Go to **"Sign-In and Security"** section
4. Find **"App-Specific Passwords"**
5. Click **"Generate an app-specific password"**
6. Enter label: `PatternSorcerer Notarization`
7. Click **"Create"**
8. **Copy the password** (you'll only see it once!)

**Example password format:** `xxxx-xxxx-xxxx-xxxx`

### 6.2 Store Password Securely

**Option 1: Keychain (Recommended)**
```bash
# Store in Keychain
security add-generic-password \
  -a "your@email.com" \
  -w "xxxx-xxxx-xxxx-xxxx" \
  -s "PatternSorcerer Notarization" \
  -T /usr/bin/security
```

**Option 2: Environment Variable**
```bash
# Add to ~/.zshrc or ~/.bash_profile
export NOTARIZATION_PASSWORD="xxxx-xxxx-xxxx-xxxx"
```

**Option 3: Secure File**
```bash
# Create secure file (chmod 600)
echo "xxxx-xxxx-xxxx-xxxx" > ~/.notarization_password
chmod 600 ~/.notarization_password
```

---

## Step 7: Configure Distribution Build

### 7.1 Create Archive Scheme

1. In Xcode, go to **Product → Scheme → Edit Scheme**
2. Select **"Archive"** in left sidebar
3. Set **Build Configuration** to **"Release"**
4. Click **"Close"**

### 7.2 Create Export Options Plist

Create file: `exportOptions.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>developer-id</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>signingCertificate</key>
    <string>Developer ID Application</string>
    <key>destination</key>
    <string>export</string>
    <key>hardenedRuntime</key>
    <true/>
    <key>runtimeVersion</key>
    <string>13.0</string>
</dict>
</plist>
```

**Replace:**
- `YOUR_TEAM_ID` with your Team ID (from Step 2.3)

### 7.3 Test Archive

1. In Xcode, select **"Any Mac (Apple Silicon, Intel)"** as destination
2. Go to **Product → Archive**
3. Wait for archive to complete
4. **Organizer** window should open
5. Verify archive appears

---

## Step 8: Set Up Distribution Scripts

### 8.1 Create Scripts Directory

```bash
mkdir -p scripts
cd scripts
```

### 8.2 Get Team ID

You need your Team ID for scripts. Find it:

**Method 1: Xcode**
- Go to **Signing & Capabilities**
- Team shows as: `Your Name (Personal Team) - ABC123XYZ`
- The `ABC123XYZ` part is your Team ID

**Method 2: Terminal**
```bash
security find-identity -v -p codesigning | grep "Developer ID"
```

### 8.3 Use Distribution Scripts

See `scripts/distribute.sh` (created separately) for automated distribution.

---

## Step 9: First Distribution Test

### 9.1 Build Archive

1. In Xcode: **Product → Archive**
2. Wait for completion

### 9.2 Export Archive

1. In Organizer window, select your archive
2. Click **"Distribute App"**
3. Select **"Developer ID"** (for outside App Store)
4. Click **"Next"**
5. Select **"Export"** (not "Upload")
6. Click **"Next"**
7. Choose options:
   - ✅ Include bitcode (if applicable)
   - ✅ Upload your app's symbols (optional)
8. Click **"Next"**
9. Choose export location
10. Click **"Export"**

### 9.3 Test the App

1. Navigate to exported app
2. Try to run it
3. If you see "unidentified developer" warning:
   - Right-click app → **"Open"**
   - This is normal for first run

---

## Step 10: Set Up Notarization (Optional but Recommended)

### 10.1 Install Command Line Tools

```bash
xcode-select --install
```

### 10.2 Get Your Team ID

```bash
# Find your Team ID
xcrun altool --list-providers --username "your@email.com" --password "@keychain:PatternSorcerer Notarization"
```

Or check Xcode:
- **Signing & Capabilities** → Team shows Team ID

### 10.3 Test Notarization

See `scripts/notarize.sh` script for automated notarization.

**Manual Test:**
```bash
# Create zip
cd /path/to/exported/app
zip -r PatternSorcerer.zip PatternSorcerer.app

# Submit for notarization
xcrun notarytool submit PatternSorcerer.zip \
  --apple-id "your@email.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "xxxx-xxxx-xxxx-xxxx" \
  --wait

# Staple ticket
xcrun stapler staple PatternSorcerer.app
```

---

## Step 11: Handle Certificate Expiration (Free Account)

### 11.1 Certificate Expiration

**Free account certificates expire every 7 days.**

**What happens:**
- Development certificates expire
- Need to re-sign before distribution
- Xcode handles this automatically for development

### 11.2 Check Certificate Status

```bash
# List certificates
security find-identity -v -p codesigning

# Check expiration
security find-certificate -c "Apple Development" -p | openssl x509 -noout -enddate
```

### 11.3 Renew Certificates

**Xcode does this automatically:**
1. When you build, Xcode checks certificates
2. If expired, Xcode creates new ones
3. No action needed for development

**For distribution:**
- Need to re-sign before distribution
- Use distribution scripts (automated)

---

## Step 12: Troubleshooting

### Issue: "No signing certificate found"

**Solution:**
1. Xcode → Settings → Accounts
2. Select your Apple ID
3. Click **"Download Manual Profiles"**
4. Try building again

### Issue: "Team not found"

**Solution:**
1. Verify you're signed in to Xcode
2. Xcode → Settings → Accounts
3. Remove and re-add Apple ID
4. Restart Xcode

### Issue: "Bundle identifier is not unique"

**Solution:**
1. Change Bundle Identifier in project settings
2. Use reverse domain notation: `com.yourname.patternsorcerer`

### Issue: "Certificate expired"

**Solution:**
1. Xcode will auto-renew for development
2. For distribution, re-export archive
3. Or use distribution scripts

### Issue: "Notarization failed"

**Solution:**
1. Check hardened runtime is enabled
2. Verify app-specific password is correct
3. Check Team ID is correct
4. Review notarization logs

---

## Step 13: Automation Setup

### 13.1 Create Distribution Script

See `scripts/distribute.sh` for complete automation script.

### 13.2 Create Build Script

See `scripts/build.sh` for build automation.

### 13.3 Set Up CI/CD (Optional)

For GitHub Actions or similar:
- See `scripts/ci-build.sh` for CI/CD setup
- Store app-specific password as secret
- Automate signing and notarization

---

## Verification Checklist

Before distributing, verify:

- [ ] Apple ID added to Xcode
- [ ] Team selected in project settings
- [ ] Automatic signing enabled
- [ ] Hardened runtime enabled
- [ ] App builds successfully
- [ ] Archive created successfully
- [ ] App-specific password created
- [ ] Team ID noted
- [ ] Distribution scripts configured
- [ ] Test export works
- [ ] Notarization works (optional)

---

## Next Steps

1. ✅ Build your app
2. ✅ Test locally
3. ✅ Create archive
4. ✅ Export for distribution
5. ✅ Notarize (optional)
6. ✅ Create DMG/ZIP
7. ✅ Distribute!

---

## Additional Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation)
- [Code Signing Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/)
- [Notarization Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)

---

## Support

If you encounter issues:
1. Check Xcode console for errors
2. Review code signing settings
3. Verify certificates in Keychain
4. Check Apple Developer account status
5. Review this guide's troubleshooting section

---

**Congratulations!** You're now set up to build and distribute PatternSorcerer with a free Apple Developer account! 🎉

