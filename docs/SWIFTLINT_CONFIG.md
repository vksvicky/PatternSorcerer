# SwiftLint Configuration Guide

## Overview

PatternSorcerer uses SwiftLint with a comprehensive configuration based on **Clean Code principles** and **Swift best practices**. This ensures consistent, maintainable, and high-quality code across the project.

## Configuration File

The configuration is defined in `.swiftlint.yml` at the project root.

## Key Principles Enforced

### 1. Code Organization (Clean Code: Organization)

- **File Length**: Maximum 500 lines (warning), 1000 lines (error)
- **Type Body Length**: Maximum 300 lines (warning), 500 lines (error)
- **Function Body Length**: Maximum 50 lines (warning), 100 lines (error)
- **Function Parameters**: Maximum 5 parameters (warning), 8 (error)
- **MARK Comments**: Encouraged for code organization

### 2. Complexity Management (Clean Code: Keep It Simple)

- **Cyclomatic Complexity**: Maximum 10 (warning), 20 (error)
- **Nesting Depth**: Maximum 3 levels (warning), 5 (error)
- **Function Parameter Count**: Maximum 5 (warning), 8 (error)

### 3. Code Safety (Clean Code: Avoid Errors)

- **Force Unwrapping**: ❌ Error (always use safe unwrapping)
- **Force Casting**: ❌ Error (use safe casting with `as?`)
- **Force Try**: ❌ Error (handle errors properly)
- **Implicitly Unwrapped Optionals**: ⚠️ Warning

### 4. Naming Conventions (Clean Code: Meaningful Names)

- **Type Names**: Start with uppercase, 3-60 characters
- **Function Names**: Start with lowercase, 3-60 characters
- **Variable Names**: Start with lowercase, 1-60 characters
- **Identifier Names**: Must be meaningful (exceptions for common variables like `i`, `j`, `x`, `y`)

### 5. Code Style (Clean Code: Consistent Formatting)

- **Trailing Whitespace**: ⚠️ Warning
- **Trailing Newline**: ⚠️ Warning (files must end with newline)
- **Vertical Whitespace**: Maximum 2 empty lines
- **Line Length**: Maximum 120 characters (warning), 150 (error)
- **Colon/Comma Spacing**: Consistent formatting

### 6. Memory Management (Clean Code: Avoid Leaks)

- **Weak Self**: ⚠️ Warning (use in closures)
- **Weak Delegate**: ⚠️ Warning (avoid retain cycles)
- **Unowned Self**: ⚠️ Warning (use carefully)

### 7. Code Quality (Clean Code: Remove Unused Code)

- **Unused Imports**: ⚠️ Warning
- **Unused Private Declarations**: ⚠️ Warning
- **Unused Closure Parameters**: ⚠️ Warning
- **Empty Count**: ⚠️ Warning (use `isEmpty` instead of `count == 0`)

## Running SwiftLint

### Manual Execution

```bash
# Run SwiftLint
swiftlint lint

# Auto-fix issues (where possible)
swiftlint autocorrect

# Run with specific rules
swiftlint lint --only [rule_name]
```

### Pre-Commit Hook

SwiftLint is automatically run as part of the pre-commit checks:

```bash
./scripts/pre-commit-check.sh
```

The pre-commit script will:
- ✅ Allow warnings (but show them)
- ❌ Fail on errors (prevents commit)

## Common Issues and Fixes

### 1. Force Unwrapping

**❌ Bad:**
```swift
let value = optionalValue!
```

**✅ Good:**
```swift
guard let value = optionalValue else { return }
// or
if let value = optionalValue {
    // use value
}
```

### 2. Long Functions

**❌ Bad:** Function with 100+ lines

**✅ Good:** Break into smaller, focused functions

```swift
func processData() {
    validateInput()
    transformData()
    saveResults()
}

private func validateInput() { /* ... */ }
private func transformData() { /* ... */ }
private func saveResults() { /* ... */ }
```

### 3. High Complexity

**❌ Bad:** Function with many nested if statements

**✅ Good:** Use guard statements, early returns, or extract methods

```swift
func process(value: Int?) {
    guard let value = value else { return }
    guard value > 0 else { return }
    // process value
}
```

### 4. Empty Count

**❌ Bad:**
```swift
if array.count == 0 { }
```

**✅ Good:**
```swift
if array.isEmpty { }
```

### 5. Trailing Whitespace

**❌ Bad:** Lines ending with spaces

**✅ Good:** Clean lines without trailing whitespace

**Fix:** Run `swiftlint autocorrect` to fix automatically

### 6. Missing MARK Comments

**❌ Bad:** Large file without organization

**✅ Good:** Use MARK comments to organize code

```swift
// MARK: - Properties
private var value: String

// MARK: - Initialization
init() { }

// MARK: - Public Methods
func publicMethod() { }

// MARK: - Private Methods
private func privateMethod() { }
```

## Best Practices

### 1. Run SwiftLint Before Committing

```bash
swiftlint lint
```

### 2. Auto-Fix When Possible

```bash
swiftlint autocorrect
```

### 3. Fix Errors Immediately

Errors block commits, so fix them right away.

### 4. Address Warnings Gradually

Warnings don't block commits but should be addressed over time.

### 5. Use MARK Comments

Organize large files with MARK comments for better readability.

## Integration with Xcode

### Xcode Build Phase

You can add SwiftLint as a build phase:

1. Open Xcode project
2. Select the target
3. Go to Build Phases
4. Click "+" and add "New Run Script Phase"
5. Add:

```bash
if which swiftlint > /dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
```

### Xcode Source Editor Extension

Install SwiftLint for Xcode to see violations inline.

## Configuration Customization

To customize rules, edit `.swiftlint.yml`. Key sections:

- `disabled_rules`: Rules to disable
- `opt_in_rules`: Additional rules to enable
- Thresholds: Adjust warning/error thresholds
- Excluded paths: Files/directories to ignore

## Resources

- [SwiftLint Documentation](https://github.com/realm/SwiftLint)
- [Clean Code Principles](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

## Support

For questions or issues with SwiftLint configuration, see:
- [SwiftLint Issues](https://github.com/realm/SwiftLint/issues)
- Project documentation in `docs/` folder

