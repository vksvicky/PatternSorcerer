# Fixing Test Bundle Signing Error

## Error Message
```
code signature in ... not valid for use in process: mapping process and mapped file (non-platform) have different Team IDs
```

## Cause
The test bundle (`PatternSorcererTests`) isn't signed with the same Team ID as the main app, or signing isn't configured for the test target.

## Solution

### Option 1: Configure Signing in Xcode (Recommended)

1. **Open the project** in Xcode
2. **Select the project** in the navigator
3. **Select the PatternSorcererTests target** (not the app target)
4. **Go to "Signing & Capabilities" tab**
5. **Check "Automatically manage signing"**
6. **Select the same Team** as your main app target:
   - If you have a free account, select your "Personal Team"
   - Make sure it matches the Team selected in the PatternSorcerer app target
7. **Verify Bundle Identifier** is `club.cycleruncode.PatternSorcererTests`

### Option 2: Clean and Rebuild

After setting up signing:

1. **Clean Build Folder**: Product → Clean Build Folder (⇧⌘K)
2. **Delete Derived Data**: 
   - Xcode → Settings → Locations
   - Click arrow next to Derived Data path
   - Delete the PatternSorcerer folder
3. **Rebuild**: Product → Build (⌘B)
4. **Run Tests**: Product → Test (⌘U)

### Option 3: Disable Code Signing for Tests (Development Only)

If you just want to run tests during development without signing:

1. **Select PatternSorcererTests target**
2. **Signing & Capabilities tab**
3. **Uncheck "Automatically manage signing"**
4. **Set CODE_SIGN_IDENTITY to "Don't Code Sign"** in Build Settings

⚠️ **Warning**: This only works for development. You'll need proper signing for distribution.

## Verification

After fixing signing:

1. **Build the project** (⌘B) - should succeed
2. **Run tests** (⌘U) - should run without signing errors
3. **Check both targets** have the same Team ID:
   - PatternSorcerer target → Signing & Capabilities
   - PatternSorcererTests target → Signing & Capabilities
   - Both should show the same Team

## Common Issues

### "No signing certificate found"
- Make sure you're signed in to Xcode with your Apple ID
- Go to Preferences → Accounts and verify your account

### "Bundle identifier already in use"
- Change the test bundle identifier to something unique:
  - `club.cycleruncode.PatternSorcererTests` (should work)
  - Or use: `club.cycleruncode.PatternSorcererTests.YourName`

### "Provisioning profile not found"
- Enable "Automatically manage signing"
- Xcode will create the provisioning profile automatically

---

**Note**: For free developer accounts, both the app and test targets need to be signed with the same Personal Team.

