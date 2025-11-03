# Xcode Signing Setup Guide

## Quick Fix for "Signing requires a development team" Error

When you first open the Xcode project, you'll see this error:
> **Signing for "PatternSorcerer" requires a development team.**

## Solution

### Option 1: Set Up in Xcode (Recommended)

1. **Open the project** in Xcode (if not already open)
2. **Select the project** in the navigator (top item: "PatternSorcerer")
3. **Select the target** "PatternSorcerer" (under TARGETS)
4. **Go to the "Signing & Capabilities" tab**
5. **Check "Automatically manage signing"**
6. **Select your Team** from the dropdown:
   - If you have a free Apple Developer account, select your "Personal Team" (shown as "Your Name (Personal Team)")
   - If you have a paid account, select your organization team
7. **Xcode will automatically configure** the signing certificates

### Option 2: Set Team ID in project.yml

If you want to set the team ID in the project configuration:

1. **Find your Team ID**:
   - In Xcode, go to Preferences → Accounts
   - Select your Apple ID
   - Your Team ID is shown in parentheses (e.g., "ABC123DEF4")

2. **Update project.yml**:
   ```yaml
   settings:
     DEVELOPMENT_TEAM: "ABC123DEF4"  # Replace with your Team ID
   ```

3. **Regenerate the project**:
   ```bash
   xcodegen generate
   ```

### Option 3: Use Command Line (Advanced)

You can also set the team ID using `xcodebuild`:

```bash
cd /Users/vivek/Development/PatternSorcerer
xcodebuild -project PatternSorcerer.xcodeproj \
  -target PatternSorcerer \
  CODE_SIGN_STYLE=Automatic \
  DEVELOPMENT_TEAM="YOUR_TEAM_ID"
```

## Free Developer Account Setup

If you don't have an Apple Developer account yet:

1. **Sign up for a free account**:
   - Go to [developer.apple.com](https://developer.apple.com)
   - Sign in with your Apple ID
   - Accept the license agreement

2. **Add your Apple ID to Xcode**:
   - Open Xcode → Preferences (⌘,)
   - Go to "Accounts" tab
   - Click "+" → Add Apple ID
   - Enter your Apple ID and password

3. **Select your Personal Team** in the Signing & Capabilities tab

## Verification

After setting up signing:

1. **Build the project** (⌘B) - should succeed
2. **Run the app** (⌘R) - should launch without signing errors
3. **Check the Signing & Capabilities tab** - should show:
   - ✅ Automatically manage signing: ON
   - ✅ Team: Your Name (Personal Team)
   - ✅ Bundle Identifier: club.cycleruncode.PatternSorcerer

## Troubleshooting

### "No signing certificate found"

- Make sure you're signed in to Xcode with your Apple ID
- Go to Preferences → Accounts and verify your account is listed
- Try clicking "Download Manual Profiles" if available

### "Bundle identifier already in use"

- The bundle identifier `club.cycleruncode.PatternSorcerer` might be taken
- Change it in the Signing & Capabilities tab to something unique:
  - `club.cycleruncode.PatternSorcerer.YourName`
  - Or use your own domain: `com.yourname.PatternSorcerer`

### "Provisioning profile not found"

- Enable "Automatically manage signing"
- Xcode will create the provisioning profile automatically
- You may need to wait a few seconds for it to be created

## For Distribution (Outside App Store)

If you plan to distribute outside the App Store:

1. **Follow the free account setup** above
2. **See**: `docs/SETUP_GUIDE_FREE_ACCOUNT.md` for detailed instructions
3. **Use the scripts**: `scripts/distribute.sh` for automated distribution

---

**Note**: With a free developer account, you can:
- ✅ Build and run the app locally
- ✅ Sign the app for local use
- ✅ Distribute outside the App Store (with user warnings)
- ❌ Not distribute via App Store (requires paid account)

