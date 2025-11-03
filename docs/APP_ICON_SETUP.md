# App Icon Setup Guide

## Using PatternSorcerer.png as App Icon

### Step 1: Create Asset Catalog

1. In Xcode, right-click on `Resources` folder
2. Select **New File...**
3. Choose **Asset Catalog**
4. Name it `Assets.xcassets`
5. Click **Create**

### Step 2: Add App Icon Set

1. In `Assets.xcassets`, right-click
2. Select **New App Icon**
3. Name it `AppIcon`

### Step 3: Convert PNG to App Icon Sizes

The app icon needs multiple sizes for macOS:

- **16x16** (1x, 2x) - Menu bar, small icons
- **32x32** (1x, 2x) - Small icons
- **128x128** (1x, 2x) - Medium icons
- **256x256** (1x, 2x) - Large icons
- **512x512** (1x, 2x) - Large icons
- **1024x1024** (1x, 2x) - App Store

### Step 4: Using sips (Command Line)

```bash
# Navigate to project directory
cd /Users/vivek/Development/PatternSorcerer

# Create icon sizes using sips (macOS built-in tool)
sips -z 16 16 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_16x16.png"
sips -z 32 32 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_16x16@2x.png"

sips -z 32 32 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_32x32.png"
sips -z 64 64 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_32x32@2x.png"

sips -z 128 128 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_128x128.png"
sips -z 256 256 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_128x128@2x.png"

sips -z 256 256 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_256x256.png"
sips -z 512 512 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_256x256@2x.png"

sips -z 512 512 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_512x512.png"
sips -z 1024 1024 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_512x512@2x.png"

sips -z 1024 1024 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_1024x1024.png"
sips -z 2048 2048 PatternSocerer.png --out "Resources/Assets/AppIcon.appiconset/icon_1024x1024@2x.png"
```

### Step 5: Create Contents.json

Create `Resources/Assets/AppIcon.appiconset/Contents.json`:

```json
{
  "images" : [
    {
      "filename" : "icon_16x16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_16x16@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_32x32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_32x32@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_128x128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_128x128@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_256x256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_256x256@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_512x512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_512x512@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_1024x1024.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "1024x1024"
    },
    {
      "filename" : "icon_1024x1024@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

### Step 6: Configure Xcode Project

1. Select project in Xcode
2. Select target **PatternSorcerer**
3. Go to **General** tab
4. Under **App Icons and Launch Screen**, select `AppIcon` from dropdown

### Alternative: Quick Setup Script

Create `scripts/setup-app-icon.sh`:

```bash
#!/bin/bash
# Setup app icon from PatternSocerer.png

SOURCE="PatternSocerer.png"
OUTPUT_DIR="PatternSorcerer/Resources/Assets/AppIcon.appiconset"

mkdir -p "$OUTPUT_DIR"

# Generate all sizes
sips -z 16 16 "$SOURCE" --out "$OUTPUT_DIR/icon_16x16.png"
sips -z 32 32 "$SOURCE" --out "$OUTPUT_DIR/icon_16x16@2x.png"
sips -z 32 32 "$SOURCE" --out "$OUTPUT_DIR/icon_32x32.png"
sips -z 64 64 "$SOURCE" --out "$OUTPUT_DIR/icon_32x32@2x.png"
sips -z 128 128 "$SOURCE" --out "$OUTPUT_DIR/icon_128x128.png"
sips -z 256 256 "$SOURCE" --out "$OUTPUT_DIR/icon_128x128@2x.png"
sips -z 256 256 "$SOURCE" --out "$OUTPUT_DIR/icon_256x256.png"
sips -z 512 512 "$SOURCE" --out "$OUTPUT_DIR/icon_256x256@2x.png"
sips -z 512 512 "$SOURCE" --out "$OUTPUT_DIR/icon_512x512.png"
sips -z 1024 1024 "$SOURCE" --out "$OUTPUT_DIR/icon_512x512@2x.png"
sips -z 1024 1024 "$SOURCE" --out "$OUTPUT_DIR/icon_1024x1024.png"
sips -z 2048 2048 "$SOURCE" --out "$OUTPUT_DIR/icon_1024x1024@2x.png"

echo "App icon sizes generated successfully!"
```

---

## Verification

After setup:
1. Build the app
2. Check the app icon appears in Finder
3. Verify icon looks good at different sizes
4. Test in Dock and app switcher

---

## Notes

- Original PNG is 1530559 bytes (good quality)
- sips is built into macOS (no extra tools needed)
- For best results, start with a square, high-resolution image
- Consider adding a mask or rounded corners for modern look

