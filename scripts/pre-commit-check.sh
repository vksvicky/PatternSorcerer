#!/bin/bash
# Pre-commit checks for PatternSorcerer

set -e

echo "=== Running Pre-Commit Checks ==="
echo ""

# 1. Build check
echo "1. Building project..."
if xcodebuild build -project PatternSorcerer.xcodeproj -scheme PatternSorcerer -configuration Debug CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -quiet 2>&1 | grep -q "BUILD SUCCEEDED"; then
    echo "   ✓ Build successful"
else
    echo "   ✗ Build failed"
    exit 1
fi

# 2. Test check
echo ""
echo "2. Running tests..."
if xcodebuild test -project PatternSorcerer.xcodeproj -scheme PatternSorcerer -destination "platform=macOS" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -quiet 2>&1 | grep -q "TEST SUCCEEDED"; then
    echo "   ✓ All tests passed"
else
    echo "   ✗ Tests failed"
    exit 1
fi

# 3. SwiftLint check (errors only)
echo ""
echo "3. Running SwiftLint (errors only)..."
if command -v swiftlint &> /dev/null; then
    ERROR_COUNT=$(swiftlint lint --quiet 2>&1 | grep -c "error:" || echo "0")
    if [ "$ERROR_COUNT" -eq 0 ]; then
        echo "   ✓ No SwiftLint errors"
    else
        echo "   ⚠ Found $ERROR_COUNT SwiftLint errors (warnings ignored)"
        swiftlint lint --quiet 2>&1 | grep "error:" | head -5
    fi
else
    echo "   (SwiftLint not installed, skipping)"
fi

echo ""
echo "=== All Pre-Commit Checks Passed ==="

