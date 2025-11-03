#!/bin/bash

# Notarization Script for PatternSorcerer
# Standalone script for notarizing an already-built app

set -e

# Configuration - UPDATE THESE
APP_PATH="${1:-build/export/PatternSorcerer.app}"
APPLE_ID="${APPLE_ID:-}"
TEAM_ID="${TEAM_ID:-}"
NOTARIZATION_PASSWORD="${NOTARIZATION_PASSWORD:-}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if app exists
if [ ! -d "$APP_PATH" ]; then
    print_error "App not found at: $APP_PATH"
    print_warning "Usage: $0 [path/to/app.app]"
    print_warning "Or set environment variables:"
    print_warning "  APPLE_ID='your@email.com'"
    print_warning "  TEAM_ID='YOUR_TEAM_ID'"
    print_warning "  NOTARIZATION_PASSWORD='xxxx-xxxx-xxxx-xxxx'"
    exit 1
fi

# Check prerequisites
if [ -z "$APPLE_ID" ]; then
    print_error "APPLE_ID not set"
    print_warning "Set it: export APPLE_ID='your@email.com'"
    exit 1
fi

if [ -z "$TEAM_ID" ]; then
    print_warning "TEAM_ID not set, attempting to find it..."
    TEAM_ID=$(security find-identity -v -p codesigning | grep "Developer ID" | head -1 | awk '{print $2}' | tr -d '()' || echo "")
    
    if [ -z "$TEAM_ID" ]; then
        print_error "Could not find Team ID. Please set TEAM_ID environment variable."
        exit 1
    fi
fi

if [ -z "$NOTARIZATION_PASSWORD" ]; then
    print_error "NOTARIZATION_PASSWORD not set"
    print_warning "Get app-specific password from: https://appleid.apple.com"
    print_warning "Set it: export NOTARIZATION_PASSWORD='xxxx-xxxx-xxxx-xxxx'"
    exit 1
fi

print_header "Notarizing PatternSorcerer"
echo ""
echo "App: $APP_PATH"
echo "Apple ID: $APPLE_ID"
echo "Team ID: $TEAM_ID"
echo ""

# Verify app is signed
print_warning "Verifying code signature..."
codesign --verify --verbose=4 "$APP_PATH"

if [ $? -ne 0 ]; then
    print_error "App is not properly signed. Please sign it first."
    exit 1
fi

print_success "Code signature verified"
echo ""

# Create zip
print_warning "Creating zip for notarization..."
ZIP_PATH="${APP_PATH%.app}.zip"
cd "$(dirname "$APP_PATH")"
zip -r "$(basename "$ZIP_PATH")" "$(basename "$APP_PATH")"
cd - > /dev/null

print_success "Zip created: $ZIP_PATH"
echo ""

# Submit for notarization
print_warning "Submitting for notarization..."
print_warning "This may take 5-15 minutes..."
echo ""

SUBMISSION_ID=$(xcrun notarytool submit "$ZIP_PATH" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "$NOTARIZATION_PASSWORD" \
    --wait \
    --output-format json | jq -r '.id')

if [ $? -eq 0 ]; then
    print_success "Notarization successful!"
    echo ""
    
    # Staple ticket
    print_warning "Stapling notarization ticket..."
    xcrun stapler staple "$APP_PATH"
    
    if [ $? -eq 0 ]; then
        print_success "Notarization ticket stapled"
        
        # Verify stapling
        xcrun stapler validate "$APP_PATH"
        if [ $? -eq 0 ]; then
            print_success "Stapling verified"
        fi
    else
        print_warning "Failed to staple immediately. This is normal."
        print_warning "Wait a few minutes and run: xcrun stapler staple \"$APP_PATH\""
    fi
    
    echo ""
    print_header "Notarization Complete!"
    print_success "App is ready for distribution: $APP_PATH"
else
    print_error "Notarization failed"
    print_warning "Check status with: xcrun notarytool history --apple-id \"$APPLE_ID\" --team-id \"$TEAM_ID\" --password \"$NOTARIZATION_PASSWORD\""
    exit 1
fi

