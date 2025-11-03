#!/bin/bash

# Version Management Script for PatternSorcerer
# Manages version numbers in format: yyyy.dd.build
# yyyy = year
# dd = day of year (1-366)
# build = build number (increments daily)

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
DAY_OF_YEAR=$(date +%j)
DATE_STRING="${YEAR}.${DAY_OF_YEAR}"

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
        echo "${DATE_STRING}.0"
    fi
}

# Parse version components
parse_version() {
    local version=$1
    VERSION_YEAR=$(echo "$version" | cut -d. -f1)
    VERSION_DAY=$(echo "$version" | cut -d. -f2)
    VERSION_BUILD=$(echo "$version" | cut -d. -f3)
}

# Increment build number
increment_build() {
    local current_version=$(get_current_version)
    parse_version "$current_version"
    
    # If same day, increment build
    if [ "$VERSION_YEAR" = "$YEAR" ] && [ "$VERSION_DAY" = "$DAY_OF_YEAR" ]; then
        VERSION_BUILD=$((VERSION_BUILD + 1))
    else
        # New day, reset build to 1
        VERSION_BUILD=1
    fi
    
    NEW_VERSION="${YEAR}.${DAY_OF_YEAR}.${VERSION_BUILD}"
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
    echo "Version: $VERSION_YEAR.$VERSION_DAY.$VERSION_BUILD"
    echo "Year: $VERSION_YEAR"
    echo "Day of Year: $VERSION_DAY"
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
    update_info_plist "$VERSION_YEAR.$VERSION_DAY" "$VERSION_BUILD"
    save_version "$NEW_VERSION"
    
    print_success "Version incremented to: $NEW_VERSION"
}

cmd_show() {
    show_version
}

cmd_set() {
    local version=$1
    if [ -z "$version" ]; then
        print_error "Please provide a version number (format: yyyy.dd.build)"
        exit 1
    fi
    
    print_header "Setting Version"
    
    parse_version "$version"
    update_info_plist "$VERSION_YEAR.$VERSION_DAY" "$VERSION_BUILD"
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
        echo "  set <version>      - Set version manually (yyyy.dd.build)"
        echo ""
        echo "Examples:"
        echo "  $0 increment       # Increment build"
        echo "  $0 show            # Show current version"
        echo "  $0 set 2024.123.5  # Set version to 2024.123.5"
        exit 1
        ;;
esac

