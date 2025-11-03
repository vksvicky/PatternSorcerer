#!/bin/bash

# Distribution Script for PatternSorcerer
# Automates building, signing, and preparing for distribution

set -e

# Configuration - UPDATE THESE VALUES
SCHEME="PatternSorcerer"
PROJECT_NAME="PatternSorcerer"
BUILD_DIR="build"
ARCHIVE_NAME="${PROJECT_NAME}.xcarchive"
EXPORT_DIR="${BUILD_DIR}/export"
DMG_NAME="${PROJECT_NAME}.dmg"
APP_NAME="${PROJECT_NAME}.app"

# Get Team ID automatically (or set manually)
TEAM_ID="${TEAM_ID:-}"  # Set in environment or here
APPLE_ID="${APPLE_ID:-}"  # Your Apple ID email
NOTARIZATION_PASSWORD="${NOTARIZATION_PASSWORD:-}"  # App-specific password

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
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

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check if Xcode is installed
    if ! command -v xcodebuild &> /dev/null; then
        print_error "xcodebuild not found. Please install Xcode."
        exit 1
    fi
    print_success "Xcode found"
    
    # Check if codesign is available
    if ! command -v codesign &> /dev/null; then
        print_error "codesign not found."
        exit 1
    fi
    print_success "codesign found"
    
    # Check for Team ID
    if [ -z "$TEAM_ID" ]; then
        print_warning "TEAM_ID not set. Attempting to find it..."
        TEAM_ID=$(security find-identity -v -p codesigning | grep "Developer ID" | head -1 | awk '{print $2}' | tr -d '()' || echo "")
        
        if [ -z "$TEAM_ID" ]; then
            print_error "Could not find Team ID. Please set TEAM_ID environment variable."
            print_warning "Find it in Xcode: Signing & Capabilities → Team ID"
            exit 1
        fi
    fi
    print_success "Team ID: $TEAM_ID"
    
    echo ""
}

# Create archive
create_archive() {
    print_header "Creating Archive"
    
    mkdir -p "$BUILD_DIR"
    
    # Clean previous archive
    if [ -d "$BUILD_DIR/$ARCHIVE_NAME" ]; then
        print_warning "Removing previous archive..."
        rm -rf "$BUILD_DIR/$ARCHIVE_NAME"
    fi
    
    # Create archive
    xcodebuild archive \
        -scheme "$SCHEME" \
        -configuration Release \
        -archivePath "$BUILD_DIR/$ARCHIVE_NAME" \
        -destination "platform=macOS" \
        CODE_SIGN_STYLE="Automatic" \
        DEVELOPMENT_TEAM="$TEAM_ID"
    
    if [ $? -eq 0 ]; then
        print_success "Archive created successfully"
    else
        print_error "Archive creation failed"
        exit 1
    fi
    
    echo ""
}

# Export archive
export_archive() {
    print_header "Exporting Archive"
    
    # Create export options plist
    EXPORT_OPTIONS_PLIST="${BUILD_DIR}/exportOptions.plist"
    
    cat > "$EXPORT_OPTIONS_PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>developer-id</string>
    <key>teamID</key>
    <string>$TEAM_ID</string>
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
EOF
    
    # Remove old export
    if [ -d "$EXPORT_DIR" ]; then
        rm -rf "$EXPORT_DIR"
    fi
    mkdir -p "$EXPORT_DIR"
    
    # Export
    xcodebuild -exportArchive \
        -archivePath "$BUILD_DIR/$ARCHIVE_NAME" \
        -exportPath "$EXPORT_DIR" \
        -exportOptionsPlist "$EXPORT_OPTIONS_PLIST"
    
    if [ $? -eq 0 ]; then
        print_success "Archive exported successfully"
    else
        print_error "Archive export failed"
        exit 1
    fi
    
    echo ""
}

# Verify code signature
verify_signature() {
    print_header "Verifying Code Signature"
    
    APP_PATH="$EXPORT_DIR/$APP_NAME"
    
    if [ ! -d "$APP_PATH" ]; then
        print_error "App not found at $APP_PATH"
        exit 1
    fi
    
    # Verify signature
    codesign --verify --verbose=4 "$APP_PATH"
    
    if [ $? -eq 0 ]; then
        print_success "Code signature verified"
        
        # Show signature details
        echo ""
        echo "Signature details:"
        codesign -dv --verbose=4 "$APP_PATH" 2>&1 | grep -E "(Authority|Identifier|Format)"
    else
        print_error "Code signature verification failed"
        exit 1
    fi
    
    echo ""
}

# Create DMG
create_dmg() {
    print_header "Creating DMG"
    
    DMG_PATH="$BUILD_DIR/$DMG_NAME"
    
    # Remove old DMG
    if [ -f "$DMG_PATH" ]; then
        rm -f "$DMG_PATH"
    fi
    
    # Check if create-dmg is installed
    if command -v create-dmg &> /dev/null; then
        print_success "create-dmg found, using it..."
        create-dmg \
            --volname "$PROJECT_NAME" \
            --window-pos 200 120 \
            --window-size 600 300 \
            --icon-size 100 \
            --icon "$APP_NAME" 150 150 \
            --hide-extension "$APP_NAME" \
            --app-drop-link 450 150 \
            "$DMG_PATH" \
            "$EXPORT_DIR"
    else
        print_warning "create-dmg not found. Creating basic DMG with hdiutil..."
        
        # Create temporary DMG
        TEMP_DMG="${BUILD_DIR}/temp.dmg"
        hdiutil create -srcfolder "$EXPORT_DIR/$APP_NAME" -volname "$PROJECT_NAME" -fs HFS+ -fsargs "-c c=64,a=16,e=16" -format UDRW -size 200m "$TEMP_DMG"
        
        # Mount and configure
        DEVICE=$(hdiutil attach -readwrite -noverify -noautoopen "$TEMP_DMG" | egrep '^/dev/' | sed 1q | awk '{print $1}')
        
        # Unmount
        hdiutil detach "$DEVICE"
        
        # Convert to final DMG
        hdiutil convert "$TEMP_DMG" -format UDZO -imagekey zlib-level=9 -o "$DMG_PATH"
        rm -f "$TEMP_DMG"
    fi
    
    if [ -f "$DMG_PATH" ]; then
        print_success "DMG created: $DMG_PATH"
    else
        print_error "DMG creation failed"
        exit 1
    fi
    
    echo ""
}

# Notarize app
notarize_app() {
    if [ -z "$APPLE_ID" ] || [ -z "$NOTARIZATION_PASSWORD" ]; then
        print_warning "Notarization skipped (APPLE_ID or NOTARIZATION_PASSWORD not set)"
        print_warning "Set these environment variables to enable notarization:"
        print_warning "  export APPLE_ID='your@email.com'"
        print_warning "  export NOTARIZATION_PASSWORD='xxxx-xxxx-xxxx-xxxx'"
        return
    fi
    
    print_header "Notarizing App"
    
    APP_PATH="$EXPORT_DIR/$APP_NAME"
    ZIP_PATH="${BUILD_DIR}/${PROJECT_NAME}.zip"
    
    # Create zip for notarization
    print_warning "Creating zip for notarization..."
    cd "$EXPORT_DIR"
    zip -r "../${PROJECT_NAME}.zip" "$APP_NAME"
    cd - > /dev/null
    
    # Submit for notarization
    print_warning "Submitting for notarization (this may take a few minutes)..."
    xcrun notarytool submit "$ZIP_PATH" \
        --apple-id "$APPLE_ID" \
        --team-id "$TEAM_ID" \
        --password "$NOTARIZATION_PASSWORD" \
        --wait
    
    if [ $? -eq 0 ]; then
        print_success "Notarization successful"
        
        # Staple ticket
        print_warning "Stapling notarization ticket..."
        xcrun stapler staple "$APP_PATH"
        
        if [ $? -eq 0 ]; then
            print_success "Notarization ticket stapled"
        else
            print_warning "Failed to staple ticket (may need to wait a few minutes)"
        fi
    else
        print_error "Notarization failed"
        print_warning "Check notarization logs with: xcrun notarytool history"
        exit 1
    fi
    
    echo ""
}

# Main execution
main() {
    print_header "PatternSorcerer Distribution Script"
    echo ""
    
    check_prerequisites
    create_archive
    export_archive
    verify_signature
    
    # Ask about DMG creation
    read -p "Create DMG? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        create_dmg
    fi
    
    # Ask about notarization
    read -p "Notarize app? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        notarize_app
    fi
    
    print_header "Distribution Complete!"
    echo ""
    print_success "App location: $EXPORT_DIR/$APP_NAME"
    if [ -f "$BUILD_DIR/$DMG_NAME" ]; then
        print_success "DMG location: $BUILD_DIR/$DMG_NAME"
    fi
    echo ""
    print_warning "Next steps:"
    echo "  1. Test the app on a different Mac if possible"
    echo "  2. Distribute the DMG or ZIP to users"
    echo "  3. Update version number for next release"
    echo ""
}

# Run main function
main

