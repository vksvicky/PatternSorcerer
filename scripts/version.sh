#!/bin/bash

# Version Management Script for PatternSorcerer
# Manages version numbers in format: yyyy.mm.build
# yyyy = year
# mm = month (01-12)
# build = build number (0001-9999, increments within month)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
INFO_PLIST="${1:-PatternSorcerer/Info.plist}"
VERSION_FILE="${2:-.version}"

# Get current date components
YEAR=$(date +%Y)
MONTH=$(date +%m)  # 01-12
DATE_STRING="${YEAR}.${MONTH}"

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

# Read current version from file or default
get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "${DATE_STRING}.0001"
    fi
}

# Parse version components
parse_version() {
    local version=$1
    VERSION_YEAR=$(echo "$version" | cut -d. -f1)
    VERSION_MONTH=$(echo "$version" | cut -d. -f2)
    VERSION_BUILD=$(echo "$version" | cut -d. -f3)
    # Remove leading zeros from build for arithmetic, but keep for display
    VERSION_BUILD_NUM=$(echo "$VERSION_BUILD" | sed 's/^0*//')
    if [ -z "$VERSION_BUILD_NUM" ]; then
        VERSION_BUILD_NUM=0
    fi
}

# Increment build number
increment_build() {
    local current_version=$(get_current_version)
    parse_version "$current_version"

    # If same month, increment build
    if [ "$VERSION_YEAR" = "$YEAR" ] && [ "$VERSION_MONTH" = "$MONTH" ]; then
        VERSION_BUILD_NUM=$((VERSION_BUILD_NUM + 1))
    else
        # New month, reset build to 1
        VERSION_BUILD_NUM=1
    fi

    # Format build as 4-digit number (0001-9999)
    VERSION_BUILD=$(printf "%04d" $VERSION_BUILD_NUM)

    # Ensure build doesn't exceed 9999
    if [ $VERSION_BUILD_NUM -gt 9999 ]; then
        print_error "Build number exceeds 9999. Please reset manually."
        exit 1
    fi

    NEW_VERSION="${YEAR}.${MONTH}.${VERSION_BUILD}"
}

# Update Info.plist
update_info_plist() {
    local version=$1
    local build=$2

    if [ ! -f "$INFO_PLIST" ]; then
        print_error "Info.plist not found at: $INFO_PLIST"
        return 1
    fi

    # Update CFBundleShortVersionString (version)
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $version" "$INFO_PLIST" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string $version" "$INFO_PLIST"

    # Update CFBundleVersion (build)
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build" "$INFO_PLIST" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :CFBundleVersion string $build" "$INFO_PLIST"

    print_success "Updated Info.plist: Version=$version, Build=$build"
}

# Save version to file
save_version() {
    local version=$1
    echo "$version" > "$VERSION_FILE"
    print_success "Saved version to $VERSION_FILE"
}

# Display current version
show_version() {
    local version=$(get_current_version)
    parse_version "$version"

    print_header "Current Version"
    echo "Version: $VERSION_YEAR.$VERSION_MONTH.$VERSION_BUILD"
    echo "Year: $VERSION_YEAR"
    echo "Month: $VERSION_MONTH"
    echo "Build: $VERSION_BUILD"
    echo ""
}

# Main functions
cmd_increment() {
    print_header "Incrementing Version"

    increment_build
    echo "Current: $(get_current_version)"
    echo "New: $NEW_VERSION"
    echo ""

    parse_version "$NEW_VERSION"
    update_info_plist "$VERSION_YEAR.$VERSION_MONTH" "$VERSION_BUILD"
    save_version "$NEW_VERSION"

    print_success "Version incremented to: $NEW_VERSION"
}

cmd_show() {
    show_version
}

cmd_set() {
    local version=$1
    if [ -z "$version" ]; then
        print_error "Please provide a version number (format: yyyy.mm.build)"
        exit 1
    fi

    # Validate version format
    if ! echo "$version" | grep -qE '^[0-9]{4}\.[0-9]{2}\.[0-9]{4}$'; then
        print_error "Invalid version format. Expected: yyyy.mm.build (e.g., 2025.11.0001)"
        exit 1
    fi

    print_header "Setting Version"

    parse_version "$version"
    # Validate build number
    if [ $VERSION_BUILD_NUM -lt 1 ] || [ $VERSION_BUILD_NUM -gt 9999 ]; then
        print_error "Build number must be between 0001 and 9999"
        exit 1
    fi
    # Validate month
    if [ "$VERSION_MONTH" -lt 1 ] || [ "$VERSION_MONTH" -gt 12 ]; then
        print_error "Month must be between 01 and 12"
        exit 1
    fi

    update_info_plist "$VERSION_YEAR.$VERSION_MONTH" "$VERSION_BUILD"
    save_version "$version"

    print_success "Version set to: $version"
}

# Main command dispatch
case "${1:-increment}" in
    increment|inc|i)
        cmd_increment
        ;;
    show|s)
        cmd_show
        ;;
    set)
        cmd_set "$2"
        ;;
    *)
        echo "Usage: $0 [command] [args]"
        echo ""
        echo "Commands:"
        echo "  increment, inc, i  - Increment build number (default)"
        echo "  show, s            - Show current version"
        echo "  set <version>      - Set version manually (yyyy.mm.build)"
        echo ""
        echo "Examples:"
        echo "  $0 increment       # Increment build"
        echo "  $0 show            # Show current version"
        echo "  $0 set 2025.11.0001  # Set version to 2025.11.0001"
        exit 1
        ;;
esac

