#!/bin/bash

# Code Signing Verification Script
# Checks the code signing status of the app

set -e

APP_PATH="${1:-build/export/PatternSorcerer.app}"

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

if [ ! -d "$APP_PATH" ]; then
    print_error "App not found at: $APP_PATH"
    print_warning "Usage: $0 [path/to/app.app]"
    exit 1
fi

print_header "Code Signing Verification"
echo "App: $APP_PATH"
echo ""

# Check if app is signed
echo "Checking code signature..."
codesign --verify --verbose=4 "$APP_PATH" 2>&1

if [ $? -eq 0 ]; then
    print_success "Code signature is valid"
else
    print_error "Code signature verification failed"
fi

echo ""
echo "Signature details:"
echo "----------------------------------------"
codesign -dv --verbose=4 "$APP_PATH" 2>&1 | grep -E "(Authority|Identifier|Format|Signed)" || true

echo ""
echo "Entitlements:"
echo "----------------------------------------"
codesign -d --entitlements :- "$APP_PATH" 2>&1 | grep -v "^Executable=" || print_warning "No entitlements found"

echo ""
echo "Certificate chain:"
echo "----------------------------------------"
codesign -dvv "$APP_PATH" 2>&1 | grep -A 5 "Authority" || true

echo ""
# Check for notarization
echo "Checking notarization status..."
if xcrun stapler validate "$APP_PATH" 2>&1 | grep -q "stapled"; then
    print_success "App is notarized and stapled"
else
    print_warning "App is not notarized (or ticket not stapled)"
    print_warning "Run notarize.sh to notarize the app"
fi

echo ""
print_header "Verification Complete"

