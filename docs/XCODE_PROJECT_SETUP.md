# Xcode Project Setup Guide

This guide walks you through creating the Xcode project and setting it up with the existing code structure.

## Prerequisites

- Xcode 15.0 or later
- macOS 13.0 or later
- Free Apple Developer account (optional, for code signing)

## Step 1: Create New Xcode Project

1. Open **Xcode**
2. Go to **File → New → Project**
3. Select **macOS** tab
4. Choose **App**
5. Click **Next**

## Step 2: Configure Project

Enter the following information:

- **Product Name**: `PatternSorcerer`
- **Team**: Select your Personal Team (or leave empty for now)
- **Organization Identifier**: `com.yourname` (e.g., `com.johndoe`)
- **Bundle Identifier**: Will auto-generate (e.g., `com.johndoe.PatternSorcerer`)
- **Language**: **Swift**
- **Interface**: **SwiftUI**
- **Storage**: **SwiftData** (or None, we'll add it manually)
- **Minimum Deployment**: **macOS 13.0** (or 14.0 for SwiftData)

6. Click **Next**
7. **IMPORTANT**: Navigate to the `PatternSorcerer` folder (the one we created)
8. **DO NOT** create a new folder - select the existing `PatternSorcerer` folder
9. Click **Create**

## Step 3: Configure Project Settings

### 3.1 General Settings

1. Select the **PatternSorcerer** project in the navigator
2. Select the **PatternSorcerer** target
3. Go to **General** tab
4. Verify:
   - **Minimum Deployments**: macOS 13.0 (or 14.0)
   - **Supported Destinations**: Mac (Universal)

### 3.2 Signing & Capabilities

1. Go to **Signing & Capabilities** tab
2. Check **"Automatically manage signing"**
3. Select your **Team** (if you have one set up)
4. Verify **Bundle Identifier** is unique

### 3.3 Build Settings

1. Go to **Build Settings** tab
2. Search for **"Swift Language Version"**
3. Set to **Swift 5** (or latest)
4. Search for **"Product Bundle Identifier"**
5. Verify it matches your organization identifier

## Step 4: Add Existing Files

### 4.1 Add Source Files

The project structure is already created. Now add files to Xcode:

1. In Xcode, right-click on the project navigator
2. Select **"Add Files to PatternSorcerer..."**
3. Navigate to the `PatternSorcerer` folder
4. Select all folders (App, Core, Features, Resources)
5. Make sure:
   - ✅ **"Copy items if needed"** is **UNCHECKED** (files are already in place)
   - ✅ **"Create groups"** is selected
   - ✅ **"Add to targets"** → PatternSorcerer is checked
6. Click **Add**

### 4.2 Verify File Structure

Your project navigator should show:

```
PatternSorcerer
├── App
│   ├── PatternSorcererApp.swift
│   └── ContentView.swift
├── Core
│   ├── Models
│   │   ├── Pattern.swift
│   │   ├── MatchResult.swift
│   │   └── CodeLanguage.swift
│   ├── Services
│   │   └── RegexEngine
│   │       └── RegexEngine.swift
│   └── Utilities
│       └── PersistenceController.swift
└── Features
    └── RegexTester
        ├── Views
        │   └── RegexTesterView.swift
        └── ViewModels
            └── RegexTesterViewModel.swift
```

## Step 5: Configure SwiftData

### 5.1 Update App File

1. Open `PatternSorcererApp.swift`
2. Add SwiftData import:
   ```swift
   import SwiftData
   ```
3. Update the body to include model container:
   ```swift
   var body: some Scene {
       WindowGroup {
           ContentView()
               .environmentObject(appState)
               .modelContainer(PersistenceController.shared.container)
       }
       // ... rest of code
   }
   ```

## Step 6: Set Up Build Configuration

### 6.1 Update Build Scripts

The scripts in `scripts/` directory reference the scheme. Make sure:

1. The scheme name is `PatternSorcerer`
2. Build configuration is set to `Release` for distribution

### 6.2 Update Script Paths

If needed, update the scripts to match your project structure.

## Step 7: Test Build

### 7.1 Build the Project

1. Select **"My Mac"** as destination
2. Press **⌘B** (or **Product → Build**)
3. Fix any errors that appear

### 7.2 Run the App

1. Press **⌘R** (or **Product → Run**)
2. App should launch
3. You should see the sidebar with features
4. Regex Tester should be functional

## Step 8: Configure Code Signing (Optional)

See `docs/SETUP_GUIDE_FREE_ACCOUNT.md` for complete signing setup.

### Quick Setup:

1. Go to **Signing & Capabilities**
2. Check **"Automatically manage signing"**
3. Select your **Team**
4. Xcode will handle the rest

## Step 9: Add Assets (Optional)

### 9.1 App Icon

1. Create or add app icon assets
2. Add to `Resources/Assets/`
3. Update Asset Catalog

### 9.2 Other Assets

- Add images, patterns, tutorials to respective folders
- Reference in code as needed

## Step 10: Configure Tests

### 10.1 Add Test Targets

1. Go to **File → New → Target**
2. Select **macOS → Unit Testing Bundle**
3. Name it `PatternSorcererTests`
4. Repeat for **UI Testing Bundle** (optional)

### 10.2 Test Structure

Tests should be in:
- `Tests/UnitTests/` - Unit tests
- `Tests/UITests/` - UI tests

## Troubleshooting

### Issue: "Cannot find type 'Pattern' in scope"

**Solution:**
- Make sure all files are added to the target
- Check that SwiftData is imported where needed
- Clean build folder (⌘⇧K) and rebuild

### Issue: "Module not found"

**Solution:**
- Verify all files are in the correct folders
- Check that files are added to the target
- Clean and rebuild

### Issue: "SwiftData not available"

**Solution:**
- Minimum deployment target must be macOS 14.0 for SwiftData
- Or use Core Data instead (see alternatives)

### Issue: Build Scripts Don't Work

**Solution:**
- Verify scheme name matches `PatternSorcerer`
- Check that Xcode project is in the root directory
- Update script paths if needed

## Next Steps

1. ✅ Project is set up
2. ✅ Basic structure is in place
3. ⏳ Start implementing features (Phase 1)
4. ⏳ Add more features from roadmap
5. ⏳ Set up distribution

## Additional Resources

- [Setup Guide: Free Account](SETUP_GUIDE_FREE_ACCOUNT.md)
- [Technical Architecture](TECHNICAL_ARCHITECTURE.md)
- [Features & Roadmap](FEATURES_AND_ROADMAP.md)

---

**You're ready to start developing!** 🎉

