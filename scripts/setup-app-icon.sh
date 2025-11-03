#!/bin/bash
# Setup app icon from PatternSocerer.png

set -e

SOURCE="PatternSocerer.png"
OUTPUT_DIR="PatternSorcerer/Resources/Assets/AppIcon.appiconset"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Creating app icon from $SOURCE..."

# Create directory
mkdir -p "$OUTPUT_DIR"

# Check if source exists
if [ ! -f "$SOURCE" ]; then
    echo "Error: $SOURCE not found!"
    exit 1
fi

# Generate all sizes
echo "Generating icon sizes..."
sips -z 16 16 "$SOURCE" --out "$OUTPUT_DIR/icon_16x16.png" 2>/dev/null || echo "Warning: Could not create 16x16"
sips -z 32 32 "$SOURCE" --out "$OUTPUT_DIR/icon_16x16@2x.png" 2>/dev/null || echo "Warning: Could not create 16x16@2x"
sips -z 32 32 "$SOURCE" --out "$OUTPUT_DIR/icon_32x32.png" 2>/dev/null || echo "Warning: Could not create 32x32"
sips -z 64 64 "$SOURCE" --out "$OUTPUT_DIR/icon_32x32@2x.png" 2>/dev/null || echo "Warning: Could not create 32x32@2x"
sips -z 128 128 "$SOURCE" --out "$OUTPUT_DIR/icon_128x128.png" 2>/dev/null || echo "Warning: Could not create 128x128"
sips -z 256 256 "$SOURCE" --out "$OUTPUT_DIR/icon_128x128@2x.png" 2>/dev/null || echo "Warning: Could not create 128x128@2x"
sips -z 256 256 "$SOURCE" --out "$OUTPUT_DIR/icon_256x256.png" 2>/dev/null || echo "Warning: Could not create 256x256"
sips -z 512 512 "$SOURCE" --out "$OUTPUT_DIR/icon_256x256@2x.png" 2>/dev/null || echo "Warning: Could not create 256x256@2x"
sips -z 512 512 "$SOURCE" --out "$OUTPUT_DIR/icon_512x512.png" 2>/dev/null || echo "Warning: Could not create 512x512"
sips -z 1024 1024 "$SOURCE" --out "$OUTPUT_DIR/icon_512x512@2x.png" 2>/dev/null || echo "Warning: Could not create 512x512@2x"
sips -z 1024 1024 "$SOURCE" --out "$OUTPUT_DIR/icon_1024x1024.png" 2>/dev/null || echo "Warning: Could not create 1024x1024"
sips -z 2048 2048 "$SOURCE" --out "$OUTPUT_DIR/icon_1024x1024@2x.png" 2>/dev/null || echo "Warning: Could not create 1024x1024@2x"

# Create Contents.json
cat > "$OUTPUT_DIR/Contents.json" << 'EOF'
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
EOF

echo -e "${GREEN}✓ App icon setup complete!${NC}"
echo "Icon files created in: $OUTPUT_DIR"
echo ""
echo "Next steps:"
echo "1. Open Xcode project"
echo "2. Select target PatternSorcerer"
echo "3. Go to General tab"
echo "4. Under App Icons, select AppIcon"

