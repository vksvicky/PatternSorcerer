# Contributing to PatternSorcerer

Thank you for your interest in contributing to PatternSorcerer! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different viewpoints and experiences

## How to Contribute

### Reporting Bugs

1. Check if the issue already exists in [Issues](https://github.com/vksvicky/PatternSorcerer/issues)
2. If not, create a new issue using the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md)
3. Provide as much detail as possible:
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment information
   - Screenshots if applicable

### Suggesting Features

1. Check if the feature has been requested before
2. Create a new issue using the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md)
3. Describe the feature clearly and provide use cases

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make your changes**
   - Follow the coding style guidelines
   - Write or update tests
   - Update documentation as needed

4. **Test your changes**
   ```bash
   ./scripts/test.sh
   ./scripts/build.sh Release
   ```

5. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```
   - Use clear, descriptive commit messages
   - Reference issues if applicable: "Fix #123"

6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Open a Pull Request**
   - Use the PR template
   - Describe your changes clearly
   - Link to related issues

## Development Setup

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- Git

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/vksvicky/PatternSorcerer.git
   cd PatternSorcerer
   ```

2. **Open in Xcode**
   ```bash
   open PatternSorcerer.xcodeproj
   ```
   (Note: Xcode project needs to be created first - see `docs/XCODE_PROJECT_SETUP.md`)

3. **Run tests**
   ```bash
   ./scripts/test.sh
   ```

4. **Build the app**
   ```bash
   ./scripts/build.sh
   ```

## Coding Guidelines

### Swift Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and small
- Use MARK comments to organize code

### Architecture

- Follow MVVM pattern
- Keep views simple and focused
- Business logic in ViewModels
- Services handle complex operations
- Use dependency injection

### Testing

- Write tests for new features
- Aim for good test coverage
- Use TDD/BDD approach when possible
- Mock external dependencies

### Documentation

- Update README if needed
- Add doc comments to public APIs
- Update relevant docs in `docs/` folder
- Keep code comments clear and helpful

## Project Structure

```
PatternSorcerer/
├── PatternSorcerer/          # Source code
│   ├── App/                  # App entry point
│   ├── Core/                 # Core models, services, utilities
│   └── Features/             # Feature modules
├── Tests/                    # Test files
├── docs/                     # Documentation
├── scripts/                  # Automation scripts
└── .github/                  # GitHub configuration
```

## Commit Message Guidelines

Use clear, descriptive commit messages:

```
Add feature: Multi-flavor regex support

- Support for JavaScript, PCRE, Python flavors
- Flavor selector in UI
- Flavor-specific validation

Fixes #123
```

Format:
- First line: Brief summary (50 chars or less)
- Blank line
- Detailed description (if needed)
- Reference issues: "Fixes #123" or "Closes #456"

## Testing Guidelines

### Running Tests

```bash
# All tests
./scripts/test.sh

# Unit tests only
./scripts/test.sh unit

# Integration tests
./scripts/test.sh integration
```

### Writing Tests

- Use descriptive test names: `testFeature_Scenario_ExpectedResult`
- Follow AAA pattern: Arrange, Act, Assert
- Use BDD-style tests for user flows
- Mock external dependencies

## Review Process

1. All PRs require review
2. Address review comments promptly
3. Keep PRs focused and reasonably sized
4. Ensure all tests pass
5. Update documentation as needed

## Questions?

- Check [Documentation](docs/README.md)
- Open a [Discussion](https://github.com/vksvicky/PatternSorcerer/discussions)
- Create an issue for questions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing to PatternSorcerer! 🎉

