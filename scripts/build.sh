#!/bin/bash

# Build Script for PatternSorcerer
# Builds the app for development or release

set -e

# Configuration
SCHEME="PatternSorcerer"
PROJECT_NAME="PatternSorcerer"
BUILD_DIR="build"
CONFIGURATION="${1:-Debug}" # Debug or Release

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building PatternSorcerer...${NC}"
echo "Configuration: $CONFIGURATION"
echo ""

# Create build directory
mkdir -p "$BUILD_DIR"

# Clean previous build (optional)
if [ "$2" == "clean" ]; then
    echo -e "${YELLOW}Cleaning previous build...${NC}"
    xcodebuild clean \
        -scheme "$SCHEME" \
        -configuration "$CONFIGURATION"
    echo ""
fi

# Build the app
echo -e "${GREEN}Building app...${NC}"
xcodebuild build \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$BUILD_DIR/DerivedData" \
    -destination "platform=macOS" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO

# Check if build succeeded
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful!${NC}"
    
    # Find the built app
    APP_PATH=$(find "$BUILD_DIR/DerivedData" -name "${PROJECT_NAME}.app" -type d | head -1)
    
    if [ -n "$APP_PATH" ]; then
        echo -e "${GREEN}App location: $APP_PATH${NC}"
    fi
else
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi

