# Implementation Checklist - TDD/BDD Approach

## ✅ Completed Tasks

### a) App Icon Setup
- ✅ Created `scripts/setup-app-icon.sh` to generate icon sizes
- ✅ Created `docs/APP_ICON_SETUP.md` with instructions
- ✅ Script uses `PatternSorcerer.png` as source

### b) Internationalization
- ✅ Created `Localizable.strings` with all strings
- ✅ Created `LocalizedString.swift` helper
- ⏳ **TODO**: Update all views to use localized strings

### c) Tests
- ✅ Created unit tests for RegexEngine
- ✅ Created unit tests for RegexTesterViewModel
- ✅ Created BDD tests
- ⏳ **TODO**: Add tests for all new features (Complexity, Explanation, Backtracking)
- ⏳ **TODO**: Add integration tests

### d) Line Numbers
- ✅ Created `LineNumberTextView.swift` component
- ⏳ **TODO**: Integrate into TextEditor views

### e) Coding Standards
- ⏳ **TODO**: Fix all linting errors
- ⏳ **TODO**: Remove trailing whitespace
- ⏳ **TODO**: Fix file length issues
- ⏳ **TODO**: Add proper documentation

### f) TDD/BDD Implementation
- ✅ Test structure in place
- ✅ Mock objects created
- ⏳ **TODO**: Refactor to follow TDD (tests first, then implementation)

---

## 📋 Remaining Tasks

### 1. Update Views with Localized Strings

**Files to update:**
- `PatternSorcererApp.swift` - Menu items
- `ContentView.swift` - Sidebar items
- `RegexTesterView.swift` - All strings
- `SettingsView.swift` - All strings
- `Theme.swift` - Theme names

**Example:**
```swift
// Before
Text("Pattern")

// After
Text(LocalizedString.regexTesterPattern)
```

### 2. Add Line Numbers to Text Editors

**Files to update:**
- `RegexTesterView.swift` - Replace TextEditor with LineNumberTextView
- Add `@AppStorage` for `showLineNumbers` setting

### 3. Complete Test Coverage

**New test files needed:**
- `PatternComplexityAnalyzerTests.swift`
- `PatternExplanationGeneratorTests.swift`
- `BacktrackingVisualizerTests.swift`
- `ThemeManagerTests.swift`
- `LocalizedStringTests.swift`

### 4. Fix Coding Standards

**Tasks:**
- Remove all trailing whitespace
- Fix file length (split large files)
- Fix unused parameters
- Add proper MARK comments
- Ensure consistent formatting

### 5. TDD Refactoring

**Approach:**
1. Write failing test
2. Write minimal code to pass
3. Refactor
4. Repeat

**Start with:**
- PatternComplexityAnalyzer (write tests first)
- PatternExplanationGenerator (write tests first)
- BacktrackingVisualizer (write tests first)

---

## 🎯 Priority Order

1. **High Priority:**
   - Update views with localized strings
   - Add line numbers to editors
   - Fix critical linting errors

2. **Medium Priority:**
   - Complete test coverage
   - Fix coding standards
   - Add documentation

3. **Low Priority:**
   - TDD refactoring (can be done incrementally)
   - Performance optimizations

---

## 📝 Quick Reference

### Running Tests
```bash
./scripts/test.sh          # All tests
./scripts/test.sh unit     # Unit tests only
```

### Setting Up App Icon
```bash
./scripts/setup-app-icon.sh
```

### Checking Code Style
```bash
# In Xcode: Editor → Format → Structure
# Or use: swiftformat (if installed)
```

### Adding Localized String
1. Add to `Localizable.strings`
2. Add helper method to `LocalizedString.swift`
3. Use in view: `LocalizedString.helperMethod`

---

## 🔄 TDD Workflow

### For New Features:

1. **Red** - Write failing test
```swift
func testFeature_DoesSomething() {
    // Given
    let sut = Feature()
    
    // When
    let result = sut.doSomething()
    
    // Then
    XCTAssertEqual(result, expected)
}
```

2. **Green** - Write minimal code to pass
```swift
func doSomething() -> String {
    return "expected"
}
```

3. **Refactor** - Improve code while keeping tests passing

4. **Repeat** - Add next test case

---

## 📚 Resources

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Swift Style Guide](https://google.github.io/swift/)
- [TDD Best Practices](https://qualitycoding.org/tdd/)

---

## ✅ Next Steps

1. Run `./scripts/setup-app-icon.sh` to set up icon
2. Update first view with localized strings (RegexTesterView)
3. Add line numbers to TestTextView
4. Write tests for ComplexityAnalyzer
5. Fix linting errors systematically

