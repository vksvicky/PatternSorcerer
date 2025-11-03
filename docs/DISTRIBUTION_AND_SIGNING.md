# Distribution & Code Signing Guide - PatternSorcerer

## Overview

This document addresses code signing, notarization, and distribution options for PatternSorcerer outside the Mac App Store.

---

## The Reality: Apple's Requirements

### Code Signing Requirements

**Good News:**
- ✅ You can build and run Swift/SwiftUI apps without a certificate for **development**
- ✅ You can distribute to **your own Macs** without a certificate
- ✅ You can use **ad-hoc signing** for limited distribution

**Challenges:**
- ⚠️ **Gatekeeper** will block unsigned apps by default
- ⚠️ **Notarization** is required for distribution (even outside App Store)
- ⚠️ Users will see security warnings for unsigned apps

### What Apple Requires (Even Outside App Store)

1. **Code Signing**: Required for notarization
2. **Notarization**: Required for macOS 10.15+ (Catalina and later)
3. **Hardened Runtime**: Required for notarization
4. **App Sandbox**: Not required outside App Store, but recommended

---

## Distribution Options

### Option 1: Free Apple Developer Account (Recommended)

**Cost:** Free  
**Requirements:** Apple ID (free account)

**What You Get:**
- ✅ Code signing certificate
- ✅ Ability to notarize apps
- ✅ 7-day certificates (need to renew)
- ✅ No app submission to App Store needed

**Limitations:**
- ⚠️ Certificates expire every 7 days (for development)
- ⚠️ Need to re-sign before distribution
- ⚠️ More manual process

**Process:**
1. Sign up at developer.apple.com (free)
2. Download certificates in Xcode
3. Sign your app with free certificate
4. Notarize using `notarytool` or `altool`
5. Distribute via DMG/ZIP

**User Experience:**
- ✅ Apps will be notarized
- ✅ Users won't see scary warnings
- ✅ Works with Gatekeeper

---

### Option 2: Paid Apple Developer Account ($99/year)

**Cost:** $99/year  
**Requirements:** Apple ID + payment

**What You Get:**
- ✅ 1-year certificates
- ✅ Easier notarization process
- ✅ Better certificate management
- ✅ Access to beta software
- ✅ Option to submit to App Store later

**User Experience:**
- ✅ Best experience
- ✅ No certificate expiration issues
- ✅ Professional distribution

---

### Option 3: Ad-Hoc Signing (No Certificate)

**Cost:** Free  
**Requirements:** None

**What You Get:**
- ✅ Can sign apps without Apple certificate
- ✅ Works for personal use
- ✅ Limited distribution

**Limitations:**
- ❌ **Cannot be notarized** (Apple requirement)
- ❌ Users will see "unidentified developer" warning
- ❌ Users must manually allow in System Preferences
- ❌ Not suitable for public distribution
- ❌ Gatekeeper will block by default

**User Experience:**
- ⚠️ Users see security warning
- ⚠️ Must right-click → Open (first time)
- ⚠️ Some users may be scared away

---

### Option 4: Self-Signed Certificate (Not Recommended)

**Cost:** Free  
**Requirements:** Technical knowledge

**What You Get:**
- ✅ Your own certificate
- ✅ Can sign apps

**Limitations:**
- ❌ **Cannot be notarized** (Apple won't accept)
- ❌ Users will see warnings
- ❌ Not trusted by macOS
- ❌ Same issues as unsigned apps

**Verdict:** ❌ Not useful for distribution

---

### Option 5: No Signing At All

**Cost:** Free  
**Requirements:** None

**What You Get:**
- ✅ Nothing needed
- ✅ Can build and run locally

**Limitations:**
- ❌ **Cannot be notarized**
- ❌ Gatekeeper will block
- ❌ Users see "unidentified developer"
- ❌ Poor user experience
- ❌ Not suitable for distribution

**User Experience:**
- ❌ Worst experience
- ❌ Many users won't install
- ❌ Security warnings

---

## Certificate Management Strategies

### Problem: Certificate Expiration

**Free Account Issue:**
- Development certificates expire every 7 days
- Need to re-sign before distribution
- Annoying for ongoing distribution

### Solutions:

#### 1. Automated Re-signing Script

Create a script to automatically re-sign before distribution:

```bash
#!/bin/bash
# resign.sh - Re-sign app before distribution

APP_PATH="build/PatternSorcerer.app"
IDENTITY="Developer ID Application: Your Name"

# Remove old signature
codesign --remove-signature "$APP_PATH"

# Re-sign with current certificate
codesign --sign "$IDENTITY" \
  --options runtime \
  --timestamp \
  "$APP_PATH"

# Verify
codesign --verify --verbose "$APP_PATH"
```

#### 2. Use Paid Account ($99/year)

**Best Solution:**
- 1-year certificates
- No frequent re-signing needed
- Professional distribution
- Worth it if you're serious about distribution

#### 3. Distribute Source Code

**Alternative Approach:**
- Provide source code
- Users build themselves
- No signing needed for source
- More technical users only

#### 4. Use GitHub Actions / CI/CD

**Automation:**
- Automate signing in CI
- Fresh certificates each build
- No manual intervention
- Works with free account

---

## Notarization Requirements

### What is Notarization?

Apple's security check that scans your app for malicious code.

### Is It Required?

**Yes, for:**
- ✅ macOS 10.15 (Catalina) and later
- ✅ Any app distributed outside App Store
- ✅ Apps that need to bypass Gatekeeper

**No, for:**
- ❌ macOS 10.14 and earlier (but who uses those?)
- ❌ Personal use only (but still recommended)

### Notarization Process

#### With Free Account:
```bash
# 1. Sign the app
codesign --sign "Developer ID Application: Your Name" \
  --options runtime \
  --timestamp \
  PatternSorcerer.app

# 2. Create archive
zip -r PatternSorcerer.zip PatternSorcerer.app

# 3. Submit for notarization
xcrun notarytool submit PatternSorcerer.zip \
  --apple-id your@email.com \
  --team-id YOUR_TEAM_ID \
  --password YOUR_APP_SPECIFIC_PASSWORD

# 4. Staple the ticket
xcrun stapler staple PatternSorcerer.app
```

#### With Paid Account:
- Same process, but easier
- Better tooling support
- More reliable

---

## User Experience Comparison

### Scenario 1: Properly Signed & Notarized (Free Account)

**User Experience:**
1. User downloads DMG/ZIP
2. Opens DMG
3. Drags app to Applications
4. Opens app - **No warnings!** ✅
5. Works smoothly

**Developer Effort:**
- Need to re-sign before each distribution
- Need to notarize
- 7-day certificate renewal

---

### Scenario 2: Unsigned / Ad-Hoc

**User Experience:**
1. User downloads DMG/ZIP
2. Opens DMG
3. Drags app to Applications
4. Tries to open app
5. **Gatekeeper blocks with scary warning** ⚠️
6. User must:
   - Right-click → Open
   - Or go to System Preferences → Security
   - Click "Open Anyway"
7. User may be scared away

**Developer Effort:**
- No signing needed
- But poor user experience

---

## Alternatives to Swift/SwiftUI (Given Your Concerns)

### If You Want to Avoid Certificates Entirely

#### Option A: Web Application
- **Technology:** React, Vue, or vanilla JS
- **Distribution:** Website, no certificates needed
- **Pros:** No signing, easy distribution
- **Cons:** Not native, requires internet, different UX

#### Option B: Electron (But Still Needs Signing)
- **Technology:** Electron
- **Distribution:** Still needs signing for best UX
- **Pros:** Web technologies
- **Cons:** Still needs certificates, larger app size, not native

#### Option C: Python + Tkinter/PyQt
- **Technology:** Python
- **Distribution:** Can distribute as Python script
- **Pros:** No signing for scripts
- **Cons:** Users need Python installed, not native UI

#### Option D: Rust + Tauri
- **Technology:** Rust + Tauri (Electron alternative)
- **Distribution:** Still needs signing for best UX
- **Pros:** Smaller than Electron, better performance
- **Cons:** Still needs certificates, learning curve

**Reality Check:** Even Electron/Tauri apps need signing for good UX on macOS.

---

## Recommendation for Your Situation

### Option 1: Free Apple Developer Account (Best Balance)

**Why:**
- ✅ Free
- ✅ Proper notarization
- ✅ Good user experience
- ✅ Swift/SwiftUI works perfectly
- ⚠️ Need to re-sign periodically

**Process:**
1. Create free Apple Developer account
2. Use Xcode to manage certificates (automated)
3. Set up automated signing in Xcode
4. Create distribution script for notarization
5. Distribute via DMG

**Certificate Management:**
- Xcode handles most of it automatically
- Create a build script for distribution
- Re-sign when needed (can be automated)

---

### Option 2: Paid Account ($99/year)

**Why:**
- ✅ No certificate expiration issues
- ✅ Professional distribution
- ✅ Best user experience
- ✅ Worth it if distributing publicly

**When Worth It:**
- Distributing to many users
- Regular updates
- Professional product
- Want App Store option later

---

### Option 3: Accept Unsigned (Not Recommended)

**Why:**
- ✅ No certificates needed
- ❌ Poor user experience
- ❌ Gatekeeper warnings
- ❌ Many users won't install

**When Acceptable:**
- Personal use only
- Very small audience
- Technical users only

---

## Practical Implementation

### Xcode Project Settings

#### Enable Automatic Signing:
1. Open project in Xcode
2. Select project target
3. Go to "Signing & Capabilities"
4. Check "Automatically manage signing"
5. Select your team (free account works)

#### Distribution Build Settings:
```swift
// In Build Settings:
- Code Signing Identity: "Developer ID Application"
- Code Signing Style: Automatic
- Enable Hardened Runtime: Yes
- Enable App Sandbox: Optional (for outside App Store)
```

---

### Distribution Script

Create `scripts/distribute.sh`:

```bash
#!/bin/bash
set -e

APP_NAME="PatternSorcerer"
BUILD_DIR="build"
DMG_NAME="${APP_NAME}.dmg"

# Build the app
xcodebuild -scheme PatternSorcerer \
  -configuration Release \
  -archivePath "${BUILD_DIR}/${APP_NAME}.xcarchive" \
  archive

# Export for distribution
xcodebuild -exportArchive \
  -archivePath "${BUILD_DIR}/${APP_NAME}.xcarchive" \
  -exportPath "${BUILD_DIR}" \
  -exportOptionsPlist exportOptions.plist

# Create DMG (optional, use create-dmg tool)
# create-dmg "${DMG_NAME}" "${BUILD_DIR}/${APP_NAME}.app"

# Notarize (if you have certificate)
# xcrun notarytool submit "${DMG_NAME}" ...

echo "Distribution package ready: ${DMG_NAME}"
```

---

### Automating Certificate Renewal

#### GitHub Actions Example:

```yaml
name: Build and Sign

on:
  release:
    types: [created]

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Xcode
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: latest-stable
      
      - name: Import Certificates
        uses: apple-actions/import-codesign-certs@v1
        with:
          p12-file-base64: ${{ secrets.CERTIFICATE_BASE64 }}
          p12-password: ${{ secrets.CERTIFICATE_PASSWORD }}
      
      - name: Build and Sign
        run: |
          xcodebuild -scheme PatternSorcerer \
            -configuration Release \
            archive
      
      - name: Notarize
        run: |
          xcrun notarytool submit ...
      
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: PatternSorcerer.dmg
```

---

## FAQ

### Q: Can I use Swift/SwiftUI without a certificate?

**A:** Yes, for development. But for distribution, you'll have issues:
- Gatekeeper will block
- Users see warnings
- Poor user experience

### Q: Is the free Apple Developer account sufficient?

**A:** Yes, technically. But:
- Certificates expire every 7 days
- Need to re-sign before distribution
- Can be automated with scripts

### Q: Do I need to pay $99/year?

**A:** Not required, but recommended if:
- Distributing publicly
- Regular updates
- Want professional experience

### Q: Can I avoid certificates entirely?

**A:** Yes, but:
- Users will see security warnings
- Many users won't install
- Not suitable for public distribution

### Q: Will users install an unsigned app?

**A:** Some will (technical users), but many won't:
- Security warnings scare users
- Gatekeeper blocks by default
- Requires manual override

### Q: Can I use alternatives to avoid certificates?

**A:** Not really:
- Even Electron/Tauri need signing for good UX
- Web apps avoid it but aren't native
- Python scripts avoid it but need Python installed

---

## Conclusion

### For PatternSorcerer:

**Recommended Approach:**
1. ✅ Use **Swift + SwiftUI** (best choice)
2. ✅ Get **free Apple Developer account**
3. ✅ Set up **automatic signing in Xcode**
4. ✅ Create **distribution script** for notarization
5. ✅ Accept that you'll need to **re-sign periodically** (or pay $99/year)

**Why This Works:**
- Swift/SwiftUI is still the best choice
- Free account is sufficient for distribution
- Xcode handles most certificate management
- Can automate the process
- Good user experience

**The Certificate "Problem":**
- It's not really a Swift problem - it's a macOS security requirement
- All macOS apps need signing for good UX (even Electron)
- Free account solves it, just needs some automation
- $99/year makes it easier if distributing regularly

**Bottom Line:**
Swift + SwiftUI + free Apple Developer account = **Best solution** even for outside App Store distribution.

