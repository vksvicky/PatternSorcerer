#!/bin/bash

# Test Script for PatternSorcerer
# Runs all tests (unit, integration, UI)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SCHEME="PatternSorcerer"
TEST_TYPE="${1:-all}"  # all, unit, integration, ui

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

# Check if xcodebuild is available
if ! command -v xcodebuild &> /dev/null; then
    print_error "xcodebuild not found. Please install Xcode."
    exit 1
fi

# Run unit tests
run_unit_tests() {
    print_header "Running Unit Tests"
    
    xcodebuild test \
        -scheme "$SCHEME" \
        -destination "platform=macOS" \
        -only-testing:PatternSorcererTests \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO
    
    if [ $? -eq 0 ]; then
        print_success "Unit tests passed"
        return 0
    else
        print_error "Unit tests failed"
        return 1
    fi
}

# Run integration tests
run_integration_tests() {
    print_header "Running Integration Tests"
    
    xcodebuild test \
        -scheme "$SCHEME" \
        -destination "platform=macOS" \
        -only-testing:PatternSorcererIntegrationTests \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO
    
    if [ $? -eq 0 ]; then
        print_success "Integration tests passed"
        return 0
    else
        print_error "Integration tests failed"
        return 1
    fi
}

# Run UI tests
run_ui_tests() {
    print_header "Running UI Tests"
    
    xcodebuild test \
        -scheme "$SCHEME" \
        -destination "platform=macOS" \
        -only-testing:PatternSorcererUITests \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO
    
    if [ $? -eq 0 ]; then
        print_success "UI tests passed"
        return 0
    else
        print_error "UI tests failed"
        return 1
    fi
}

# Run all tests
run_all_tests() {
    print_header "Running All Tests"
    
    local failed=0
    
    run_unit_tests || failed=1
    echo ""
    run_integration_tests || failed=1
    echo ""
    run_ui_tests || failed=1
    
    echo ""
    if [ $failed -eq 0 ]; then
        print_success "All tests passed!"
        return 0
    else
        print_error "Some tests failed"
        return 1
    fi
}

# Main execution
case "$TEST_TYPE" in
    unit|u)
        run_unit_tests
        ;;
    integration|i)
        run_integration_tests
        ;;
    ui|u)
        run_ui_tests
        ;;
    all|a)
        run_all_tests
        ;;
    *)
        echo "Usage: $0 [test_type]"
        echo ""
        echo "Test Types:"
        echo "  all, a          - Run all tests (default)"
        echo "  unit, u         - Run unit tests only"
        echo "  integration, i  - Run integration tests only"
        echo "  ui              - Run UI tests only"
        exit 1
        ;;
esac

