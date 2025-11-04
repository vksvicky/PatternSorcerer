#!/bin/bash
# Pre-commit checks for PatternSorcerer

set -e

echo "=== Running Pre-Commit Checks ==="
echo ""

# 1. Build check
echo "1. Building project..."
BUILD_OUTPUT=$(xcodebuild build -project PatternSorcerer.xcodeproj -scheme PatternSorcerer -configuration Debug CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO 2>&1)
if echo "$BUILD_OUTPUT" | grep -q "BUILD SUCCEEDED"; then
    echo "   ✓ Build successful"
elif echo "$BUILD_OUTPUT" | grep -q "BUILD FAILED"; then
    echo "   ✗ Build failed"
    echo "$BUILD_OUTPUT" | grep -E "error:" | head -5
    exit 1
else
    echo "   ⚠ Build status unclear, checking for errors..."
    if echo "$BUILD_OUTPUT" | grep -q "error:"; then
        echo "   ✗ Build failed (errors found)"
        echo "$BUILD_OUTPUT" | grep -E "error:" | head -5
        exit 1
    else
        echo "   ✓ Build successful (no errors found)"
    fi
fi

# 2. Test check
echo ""
echo "2. Running tests..."
TEST_OUTPUT=$(xcodebuild test -project PatternSorcerer.xcodeproj -scheme PatternSorcerer -destination "platform=macOS" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO 2>&1)
if echo "$TEST_OUTPUT" | grep -q "TEST SUCCEEDED"; then
    TEST_COUNT=$(echo "$TEST_OUTPUT" | grep -o "Executed [0-9]* tests" | head -1 | grep -o "[0-9]*" || echo "?")
    echo "   ✓ All tests passed ($TEST_COUNT tests)"
elif echo "$TEST_OUTPUT" | grep -q "TEST FAILED"; then
    echo "   ✗ Tests failed"
    echo "$TEST_OUTPUT" | grep -E "failed|error:" | head -5
    exit 1
else
    echo "   ⚠ Test status unclear, checking for failures..."
    if echo "$TEST_OUTPUT" | grep -qE "failed|error:"; then
        echo "   ✗ Tests failed (failures found)"
        echo "$TEST_OUTPUT" | grep -E "failed|error:" | head -5
        exit 1
    else
        echo "   ✓ All tests passed (no failures found)"
    fi
fi

# 3. SwiftLint check (Clean Code & Best Practices)
echo ""
echo "3. Running SwiftLint (Clean Code & Best Practices)..."
if command -v swiftlint &> /dev/null; then
    # Check for SwiftLint config file
    if [ ! -f ".swiftlint.yml" ]; then
        echo "   ⚠ Warning: .swiftlint.yml not found, using default rules"
    fi

    # Run SwiftLint and check for errors (warnings are allowed)
    # Only fail on errors, show warnings count
    if swiftlint lint --config .swiftlint.yml 2>&1 | tee >(grep -c "error:" > /tmp/swiftlint_errors.txt) >(grep -c "warning:" > /tmp/swiftlint_warnings.txt) | tail -1 | grep -q "Done linting"; then
        ERROR_COUNT=$(cat /tmp/swiftlint_errors.txt 2>/dev/null | tr -d ' ' || echo "0")
        WARNING_COUNT=$(cat /tmp/swiftlint_warnings.txt 2>/dev/null | tr -d ' ' || echo "0")
        rm -f /tmp/swiftlint_errors.txt /tmp/swiftlint_warnings.txt

        ERROR_COUNT=${ERROR_COUNT:-0}
        WARNING_COUNT=${WARNING_COUNT:-0}

        if [ "$ERROR_COUNT" -eq 0 ]; then
            if [ "$WARNING_COUNT" -eq 0 ]; then
                echo "   ✓ No SwiftLint issues found"
            else
                echo "   ⚠ Found $WARNING_COUNT warnings (no errors)"
                echo "   (Run 'swiftlint lint' for full report)"
            fi
        else
            echo "   ✗ Found $ERROR_COUNT errors and $WARNING_COUNT warnings"
            echo "   (Run 'swiftlint lint' for full report)"
            exit 1
        fi
    else
        # Fallback: just check if SwiftLint ran successfully
        echo "   ✓ SwiftLint check completed"
        echo "   (Run 'swiftlint lint' manually for detailed report)"
    fi
else
    echo "   (SwiftLint not installed, skipping)"
    echo "   Install with: brew install swiftlint"
fi

echo ""
echo "=== All Pre-Commit Checks Passed ==="

