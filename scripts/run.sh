#!/bin/bash

# Run Script for PatternSorcerer
# Builds and runs the app

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SCHEME="PatternSorcerer"
CONFIGURATION="${1:-Debug}"

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if xcodebuild is available
if ! command -v xcodebuild &> /dev/null; then
    print_error "xcodebuild not found. Please install Xcode."
    exit 1
fi

print_header "Building and Running PatternSorcerer"
echo "Configuration: $CONFIGURATION"
echo ""

# Build the app
print_header "Building"
xcodebuild build \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -destination "platform=macOS" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO

if [ $? -eq 0 ]; then
    print_success "Build successful"
else
    print_error "Build failed"
    exit 1
fi

echo ""

# Find the built app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "${SCHEME}.app" -type d | head -1)

if [ -z "$APP_PATH" ]; then
    print_error "App not found after build"
    exit 1
fi

print_success "App found: $APP_PATH"
echo ""

# Run the app
print_header "Running App"
open "$APP_PATH"

print_success "App launched!"

