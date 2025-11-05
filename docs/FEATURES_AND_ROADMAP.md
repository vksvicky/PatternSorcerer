# PatternSorcerer - Features & Roadmap

## Overview
PatternSorcerer is a macOS Universal app clone of RegexWizard, designed to be a powerful, intuitive tool for working with regular expressions.

**Updated**: Roadmap now includes features and UI patterns from top regex tools analyzed in [awesome-regex](https://github.com/slevithan/awesome-regex), including regex101, RegexBuddy, and RegExr.

See also:
- [Awesome-Regex Analysis](./AWESOME_REGEX_ANALYSIS.md) - Detailed feature analysis
- [UI Patterns](./UI_PATTERNS_FROM_AWESOME_REGEX.md) - UI/UX recommendations

## Recent Completions ✅

**Last Updated**: November 2025

### Completed Features
- ✅ **Phase 1: Foundation** - Complete MVP with basic regex testing
- ✅ **Phase 2: Core Features** - All Phase 2 features completed with TDD/BDD
- ✅ **Multi-language Code Export** - Full implementation with 9 languages (Swift, Python, JavaScript, Java, Go, Rust, C#, Ruby, PHP)
- ✅ **Pattern Explanation Engine** - Natural language explanations of regex patterns
- ✅ **Pattern Complexity Analysis** - Complexity scoring and optimization suggestions
- ✅ **Backtracking Visualization** - Visual analysis of backtracking risks
- ✅ **Pattern Export/Import** - JSON-based pattern import/export functionality
- ✅ **Pattern Tagging** - Tag-based organization and search
- ✅ **Settings & Management** - Export/import, clear cache, log viewer
- ✅ **Navigation System** - Menu-based navigation with sidebar toggle
- ✅ **Centralized Logging** - In-memory log storage with viewer
- ✅ **Full Test Coverage** - 140+ tests passing (Unit + BDD) with TDD/BDD approach
- ✅ **Code Quality** - SwiftLint configured with Clean Code principles, 0 violations
- ✅ **CI/CD Setup** - GitHub Actions with automated testing and building
- ✅ **Test Suite Manager** - Complete implementation with save, run, import/export test cases
- ✅ **Professional Tools** - Replace, Split, and Extract tools fully implemented with TDD/BDD
- ✅ **Pattern Library** - Browse, search, filter patterns with character class reference and quantifier cheat sheet
- ✅ **Pattern Syntax Highlighting** - Color-coded syntax highlighting for regex patterns
- ✅ **Multi-flavor Regex Support** - Support for 5 flavors (ECMAScript, PCRE, Python, .NET, Java) with flavor-specific info and differences
- ✅ **Regex Debugger / Stepper** - Step-through execution of regex with real-time backtracking visualization, state transitions, and position highlighting (Phase 3, completed with TDD/BDD)
- ✅ **Visual Pattern Builder UI** - Drag-and-drop interface with component palette, pattern canvas, live preview, and test text matching (Phase 3, completed with TDD/BDD)

### UI/UX Improvements (December 2025) ✅
- ✅ **Consistent Layout System** - Resizable sidebar split with proper width constraints
- ✅ **Standardized Tab Views** - All result tabs (Matches, Explanation, Complexity, Backtracking) use consistent layout structure
- ✅ **Visual Indicators** - Clear section containers with titles and descriptions for Pattern and Test Text areas
- ✅ **Empty State Consistency** - Unified empty state view across all tabs
- ✅ **Minimum Window Dimensions** - Enforced minimum window size (1200x700) to prevent layout collapse
- ✅ **Sidebar Width Management** - Proper sidebar sizing (300-450px) to prevent text truncation
- ✅ **Layout Constraints** - Fixed HSplitView constraints to ensure both columns (Pattern/Test Text and Results) are always visible

### Technical Achievements
- **Architecture**: MVVM with protocol-oriented design
- **Testing**: Comprehensive unit and BDD tests with mocking
- **Code Quality**: All SwiftLint best practices enforced
- **Documentation**: Complete feature documentation and setup guides

## Core Features (from RegexWizard)

### 1. Real-time Regex Testing
- **Live Pattern Matching**: Test regex patterns against sample text with instant visual feedback
- **Match Highlighting**: Color-coded highlighting of matches in the test string
- **Capture Group Visualization**: Show numbered capture groups and their matches
- **Multiple Match Support**: Display all matches, not just the first one

### 2. Multi-language Code Export
- **Export Snippets**: Generate ready-to-use code snippets in:
  - Swift
  - Python
  - JavaScript
  - Java
  - Go
  - Rust
  - C#
  - Ruby
  - PHP
- **Code Customization**: Options for flags, modifiers, and style preferences

### 3. Visual Pattern Builder
- **Drag-and-Drop Interface**: Build patterns visually without typing regex syntax
- **Character Classes Palette**: Quick access to common character classes
- **Quantifiers Widget**: Visual selector for quantifiers (*, +, ?, {n,m})
- **Anchors & Assertions**: Visual tools for ^, $, \b, lookahead, lookbehind

### 4. Smart Validation
- **Real-time Syntax Checking**: Instant feedback on regex validity
- **Error Messages**: Clear, actionable error messages
- **Auto-suggestions**: Intelligent suggestions for common mistakes
- **Pattern Explanation**: Natural language explanation of what the regex does

### 5. Pattern Library ✅
- **Common Patterns**: Pre-built patterns for:
  - Email validation ✅
  - URL matching ✅
  - Phone numbers ✅
  - Dates ✅
  - Credit cards ✅
  - IP addresses ✅
  - Common formats ✅
- **Character Class Reference**: Quick reference for \d, \w, \s, etc. ✅
- **Quantifier Cheat Sheet**: Visual guide to *, +, ?, {n}, {n,m} ✅
- **Search and Filter**: Search patterns by name, pattern text, tags ✅
- **Category Filtering**: Filter by pattern category ✅
- **Pattern Selection**: Use patterns from library directly in tester ✅

### 6. Professional Tools
- **Match Tool**: Find all matches in text
- **Replace Tool**: Find and replace with regex
- **Split Tool**: Split text using regex delimiters
- **Extract Tool**: Extract specific groups from matches
- **Test Suite**: Save and run multiple test cases

## Unique Features (PatternSorcerer Differentiators)

### 1. Interactive Learning Mode
- **Step-by-Step Tutorials**: Built-in tutorials for regex beginners
- **Pattern Decomposition**: Break down complex patterns into understandable parts
- **Interactive Exercises**: Practice with guided exercises
- **Progress Tracking**: Track learning progress and skill level

### 2. Performance Analytics
- **Pattern Complexity Score**: Visual indicator of regex complexity
- **Performance Metrics**: Time and memory usage for pattern matching
- **Optimization Suggestions**: Recommendations to improve regex efficiency
- **Backtracking Visualization**: Show how the regex engine processes the pattern

### 3. Advanced Visualization
- **Regex Tree View**: Visual representation of the pattern's structure
- **State Machine Diagram**: Generate NFA/DFA state diagrams
- **Match Flow Animation**: Animate how matches are found
- **Backtracking Tracker**: Visualize backtracking behavior

### 4. Smart Pattern Assistant
- **AI-Powered Suggestions**: Get pattern suggestions based on natural language descriptions
- **Pattern Generator**: "Match email addresses" → generates regex pattern
- **Pattern Simplification**: Suggest simpler alternatives to complex patterns
- **Context-Aware Help**: Help text based on what you're typing

### 5. Project Management
- **Pattern Collections**: Organize patterns into projects/collections
- **Version History**: Track changes to patterns over time
- **Export/Import**: Share patterns with others
- **Tags & Search**: Organize and find patterns easily

### 6. macOS-Specific Features
- **System Integration**: 
  - Quick Look extension for .regex files
  - Finder integration
  - Share extension
- **Native macOS Design**: 
  - Full SwiftUI implementation
  - Native macOS look and feel
  - Keyboard shortcuts
  - Menu bar support (optional)
- **Universal Binary**: 
  - Native support for Apple Silicon and Intel
  - Optimized performance on both architectures

### 7. Advanced Testing
- **Test Case Manager**: Save and organize test cases
- **Test Suite Runner**: Run multiple test cases at once
- **Fuzzy Matching**: Test with variations of input
- **Performance Benchmarks**: Compare pattern performance

### 8. Integration Features
- **Xcode Integration**: Copy patterns directly to Xcode
- **Terminal Integration**: Command-line tools
- **Safari Extension**: Test regex in web pages
- **Alfred/Spotlight Integration**: Quick access to patterns

### 9. Accessibility
- **VoiceOver Support**: Full accessibility support
- **High Contrast Mode**: Support for accessibility preferences
- **Keyboard Navigation**: Full keyboard control
- **Customizable UI**: Adapt to user needs

### 10. Collaboration
- **Pattern Sharing**: Share patterns via iCloud or export
- **Community Library**: Browse shared patterns (optional)
- **Comments & Annotations**: Add notes to patterns
- **Collaborative Editing**: (Future) Real-time collaboration

## Technical Features

### Core Engine
- **NSRegularExpression Integration**: Native Swift regex engine
- **Multiple Regex Flavors**: Support for different regex engines
- **Unicode Support**: Full Unicode character support
- **Performance Optimization**: Efficient matching algorithms

### Data Management
- **iCloud Sync**: Sync patterns across devices
- **Local Storage**: Core Data or SwiftData for local storage
- **Export Formats**: JSON, XML, CSV, plain text
- **Import Support**: Import from other regex tools

## Development Roadmap

### Phase 1: Foundation (Weeks 1-4) ✅ **COMPLETED**
**Goal**: Basic regex testing functionality

- [x] Project setup (Xcode, SwiftUI, macOS Universal)
- [x] Basic UI layout (pattern input, test text, results)
- [x] Real-time regex matching with NSRegularExpression
- [x] Match highlighting in test text
- [x] Basic error handling and validation
- [x] Capture group display
- [x] Dark mode support (via ThemeManager)

**Deliverable**: MVP with basic regex testing ✅

---

### Phase 2: Core Features (Weeks 5-8) ✅ **COMPLETED**
**Goal**: Complete core RegexWizard features + industry-standard features

- [x] Multi-language code export ✅
  - Swift, Python, JavaScript, Java, Go, Rust, C#, Ruby, PHP exports
  - Code snippet generation
  - Language-specific optimizations
- [x] **Multi-flavor regex support** ⭐ NEW ✅ (from awesome-regex analysis)
  - JavaScript (ECMAScript) ✅
  - PCRE/PCRE2 ✅
  - Python ✅
  - .NET ✅
  - Java ✅
  - Switch between flavors ✅
  - Show flavor differences ✅
  - Validate per flavor ✅
  - Flavor-specific features and documentation ✅
- [x] **Test Suite Manager** ⭐ NEW ✅ (inspired by regex101, RegexBuddy)
  - Save multiple test cases per pattern ✅
  - Run all tests at once ✅
  - Expected vs actual results ✅
  - Test case templates ✅
  - Test case import/export ✅
- [x] Pattern library ✅
  - Common patterns collection ✅
  - Character class reference ✅
  - Quantifier cheat sheet ✅
  - Pattern search and filter ✅
  - Pattern browsing and selection ✅
  - Use pattern from library ✅
- [x] Professional tools ✅
  - Replace functionality ✅
  - Split functionality ✅
  - Extract functionality ✅
- [x] Pattern explanation engine ✅
- [x] Enhanced validation with suggestions ✅
- [x] **Pattern syntax highlighting** ⭐ NEW ✅ (inspired by RegExr)
  - Color-code pattern components ✅
  - Visual distinction of special characters ✅
  - Highlight groups and quantifiers ✅
  - Character classes, anchors, escape sequences ✅

**Deliverable**: Full-featured regex tool with industry-standard features ✅

---

### Phase 3: Visual Features (Weeks 9-12) 🎯 **IN PROGRESS**
**Goal**: Visual pattern builder and advanced visualization

**Status**: Regex Debugger and Visual Pattern Builder completed - 2 of 6 features done

**Priority Order**:
1. [x] **Regex Debugger / Stepper** ⭐ HIGH PRIORITY ✅ (inspired by regex101, RegexBuddy)
   - Step-through execution of regex ✅
   - Show backtracking in real-time ✅
   - Highlight current position in pattern ✅
   - Show current match position in text ✅
   - State transitions visualization ✅
   - Backtracking path visualization ✅
   - **Implementation**: Complete with TDD/BDD tests, mocking, and full UI
2. [x] **Visual Pattern Builder UI** ⭐ HIGH PRIORITY ✅
   - Drag-and-drop interface ✅
   - Pattern components palette ✅
   - Visual quantifier selector ✅
   - Live preview ✅
   - **Implementation**: Complete with TDD/BDD tests, mocking, and full UI
   - **Why Second**: Makes regex accessible to beginners, major differentiator
3. [ ] **Regex Tree View** ⭐ MEDIUM PRIORITY
   - Parse pattern into tree structure
   - Visual tree representation
   - Interactive navigation
   - **Why Third**: Helps understand pattern structure, educational value
4. [ ] **State Machine Diagram** ⭐ ENHANCED (from awesome-regex analysis)
   - Generate NFA/DFA state diagrams
   - Interactive state exploration
   - Visual state transitions
   - Export diagrams
   - **Why Fourth**: Advanced visualization, great for learning
5. [ ] **Match Flow Visualization** ⭐ MEDIUM PRIORITY
   - Animate match finding process
   - Step-by-step match animation
   - **Why Fifth**: Educational, complements debugger
6. [ ] **Syntax Highlighter** ⭐ ENHANCED (Partially complete)
   - Real-time pattern highlighting ✅ (basic implementation exists)
   - Color-code all components
   - Highlight capture groups
   - Visual anchors and quantifiers
   - **Why Last**: Enhance existing feature

**Deliverable**: Visual tools for pattern building and understanding with debugger

**Completed Items**:
- ✅ **Regex Debugger / Stepper** (November 2025)
  - Full UI implementation with split-view layout
  - Step-by-step execution control
  - State management (matching, matchFound, noMatch, backtracking, error)
  - Pattern and text position tracking
  - Execution steps list with navigation
  - Complete test coverage (BDD + Unit tests)
  - Mock service for testing
  - Integrated into main app navigation

- ✅ **Visual Pattern Builder UI** (November 2025)
  - Component palette with character classes, quantifiers, anchors, groups
  - Pattern canvas for visual component arrangement
  - Live preview of generated pattern string
  - Real-time pattern validation
  - Test text input with preview matches
  - Component management (add, remove, edit, reorder, clear)
  - Complete test coverage (BDD + Unit tests)
  - Mock service for testing
  - Integrated into main app navigation

**Estimated Timeline**: 4 weeks
- ✅ Week 1: Regex Debugger/Stepper (core functionality) - **COMPLETED**
- ✅ Week 2: Visual Pattern Builder (basic drag-and-drop) - **COMPLETED**
- 🎯 Week 3: Regex Tree View + State Machine Diagram - **NEXT**
- Week 4: Match Flow Visualization + Syntax Highlighter enhancements

---

### Phase 4: Learning & Intelligence (Weeks 13-16)
**Goal**: Educational features and smart assistance

- [ ] Interactive tutorials (inspired by RegexLearn)
  - Step-by-step guides
  - Beginner-friendly explanations
  - Progress tracking
  - Gamified learning elements
- [ ] Pattern decomposition view
- [ ] **Regex to String Generator** ⭐ NEW (inspired by randexp.js)
  - Generate strings that match a regex
  - Show multiple example matches
  - Generate test cases automatically
  - Customizable generation options
- [ ] **String to Regex Generator** ⭐ NEW (inspired by regexgen)
  - Generate regex from example strings
  - Learn from positive/negative examples
  - Pattern discovery tool
- [ ] Smart pattern assistant (basic)
  - Natural language to regex (simple patterns)
  - Pattern simplification suggestions
- [ ] Learning progress tracking
- [ ] Interactive exercises
- [ ] **Reference Guide Sidebar** ⭐ NEW (inspired by RegExr)
  - Character class reference
  - Quantifier cheat sheet
  - Anchors and assertions
  - Common patterns quick lookup
  - Flavor-specific documentation

**Deliverable**: Educational features for learning regex with generation tools

---

### Phase 5: Performance & Analytics (Weeks 17-20)
**Goal**: Performance tools and optimization

- [ ] Performance metrics
  - Timing measurements
  - Memory usage tracking
  - Per-flavor benchmarks ⭐ NEW
- [x] Complexity scoring ✅
- [ ] **Pattern Optimizer** ⭐ NEW (inspired by regexp-tree)
  - Auto-optimize patterns
  - Suggest simplifications
  - Performance improvements
  - Safe optimization (preserve behavior)
- [x] Optimization suggestions ✅
- [x] Backtracking visualization ✅
- [ ] Performance benchmarks
- [ ] **Pattern Comparison Tool** ⭐ NEW (inspired by regex-utils)
  - Compare two patterns
  - Test equivalence
  - Show differences
  - Performance comparison

**Deliverable**: Performance analysis and optimization tools with auto-optimization

---

### Phase 6: Project Management (Weeks 21-24)
**Goal**: Organization and management features

- [ ] Pattern collections/projects
- [x] Pattern tagging and search ✅ (via Pattern model with tags)
- [ ] Version history
- [x] Import/export functionality ✅ (pattern export/import with JSON)
- [ ] Test case manager (moved from Phase 2)
- [ ] Test suite runner (moved from Phase 2)
- [ ] iCloud sync (basic)
- [ ] **Community Features** ⭐ NEW (inspired by RegExr, regex101)
  - Pattern sharing
  - Community pattern library
  - Rating/voting system
  - Pattern comments
  - Share via URL (Phase 9)

**Deliverable**: Full project management capabilities with community features

---

### Phase 7: macOS Integration (Weeks 25-28)
**Goal**: Native macOS features and integrations

- [ ] Quick Look extension
- [ ] Finder integration
- [ ] Share extension
- [ ] Menu bar support (optional)
- [ ] Keyboard shortcuts
- [ ] Accessibility features
  - VoiceOver support
  - High contrast mode
  - Keyboard navigation
- [ ] Command-line tools
- [ ] Xcode integration helper

**Deliverable**: Deep macOS integration

---

### Phase 8: Polish & Launch (Weeks 29-32)
**Goal**: Polish, testing, and App Store submission

- [ ] Comprehensive testing
  - Unit tests
  - Integration tests
  - UI tests
  - Performance tests
- [ ] Bug fixes and optimization
- [ ] UI/UX polish
- [ ] Documentation
  - User guide
  - In-app help
  - Developer documentation
- [ ] App Store assets
  - Screenshots
  - App preview video
  - Description and keywords
- [ ] App Store submission
- [ ] Beta testing (TestFlight)

**Deliverable**: Production-ready app in App Store

---

### Phase 9: Post-Launch (Ongoing)
**Goal**: Iterate based on feedback

- [ ] User feedback collection
- [ ] Analytics integration
- [ ] Feature updates
- [ ] Bug fixes
- [ ] Performance improvements
- [ ] Advanced features
  - AI-powered pattern generation
  - **Pattern sharing via URL** ⭐ NEW (inspired by regex101)
  - **Embed patterns** ⭐ NEW (for documentation)
  - Collaborative editing
  - Advanced state machine diagrams
  - **Regex AST Explorer** ⭐ NEW (inspired by regexpp)
    - Show abstract syntax tree
    - Interactive AST navigation
    - AST-based optimizations
  - **Grep-like file search** ⭐ NEW
    - Search files with regex
    - Preview matches in files
    - Batch processing

**Deliverable**: Continuously improving app with community and advanced features

---

## Technical Stack

### Core Technologies
- **Swift**: Primary programming language
- **SwiftUI**: Modern UI framework
- **AppKit**: macOS native components (where needed)
- **NSRegularExpression**: Regex engine
- **SwiftData/Core Data**: Data persistence
- **Combine**: Reactive programming

### Architecture
- **MVVM**: Model-View-ViewModel architecture
- **Modular Design**: Feature-based modules
- **Protocol-Oriented**: Swift best practices

### Testing
- **XCTest**: Unit and integration tests
- **XCUITest**: UI tests
- **Swift Testing**: (Future) New testing framework

### Tools
- **Xcode**: IDE
- **Git**: Version control
- **Fastlane**: CI/CD and App Store automation

---

## Success Metrics

### Technical
- App Store approval
- Universal binary (Apple Silicon + Intel)
- Performance: < 100ms for typical regex matching
- Accessibility: Full VoiceOver support

### User Experience
- Intuitive interface (no tutorial needed for basic use)
- Fast and responsive
- Beautiful, native macOS design
- Comprehensive feature set

### Business
- App Store presence
- Positive user reviews
- Regular updates
- Growing user base

---

## Future Enhancements (Post-MVP)

### From Awesome-Regex Analysis

1. **Multi-Flavor Advanced Support**
   - Support for all major flavors (RE2, Oniguruma, etc.)
   - Flavor-specific documentation
   - Flavor migration tools

2. **Advanced Debugger Features**
   - Breakpoints in regex
   - Variable watching
   - Execution history

3. **Pattern Generation Tools**
   - Regex from examples (enhanced)
   - Pattern variations generator
   - Test case generator from patterns

4. **AI Integration**
   - Advanced natural language to regex
   - Pattern optimization using ML
   - Intelligent error correction
   - Pattern suggestions from context

5. **Collaboration**
   - Real-time collaborative editing
   - Pattern sharing platform
   - Community contributions
   - Pattern marketplace

6. **Advanced Visualization**
   - Full NFA/DFA state machine diagrams
   - Advanced backtracking visualization
   - Pattern complexity graphs
   - Execution flow graphs

7. **Grep & Search Tools**
   - Full-text search with regex
   - File search integration
   - Batch processing
   - Results export

8. **Cross-Platform**
   - iOS version
   - iPadOS version
   - Web version (optional)

9. **Enterprise Features**
   - Team collaboration
   - Pattern library management
   - Usage analytics
   - Admin controls
   - SSO integration

10. **Learning Games** (inspired by Regex Crossword)
    - Interactive regex puzzles
    - Progress tracking
    - Achievements
    - Leaderboards

---

## Notes

- This roadmap is flexible and can be adjusted based on priorities
- Some features may be moved between phases
- Focus on core features first, then add unique differentiators
- User feedback should drive post-launch development
- Consider open-sourcing parts of the app for community contributions

