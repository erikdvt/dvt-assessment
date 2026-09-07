# iOS Mobile Assessment

## Overview

This project is an iOS weather application developed as part of the iOS developer assessment.

The application is built using **SwiftUI**, with **MVVM** as the primary architecture and **Combine** for reactive state management.

**SwiftLint** is the only third-party tool used.

## Technology Stack

- **Language:** Swift 5.10
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **State Management / Reactive Programming:** Combine
- **Minimum External Dependencies:** SwiftLint only
- **CI:** GitHub Actions
- **Source Control:** Git / GitHub
- **Testing:** Swift Testing

## Architecture

The application follows the **MVVM** architecture:

- **Models** represent the application's data and domain objects.
- **Views** are implemented using SwiftUI and are responsible for presentation.
- **ViewModels** contain presentation logic and expose state required by the views.
- **Services** handle external or data-related concerns, keeping networking and other infrastructure concerns outside of the views.

## Dependencies

The following dependencies are installed via swift package manager:

- GooglePlaces
- GoogleMaps

### SwiftLint

SwiftLint is used for static code analysis and to enforce Swift coding conventions.

It runs as part of the development/CI workflow to identify common style and code-quality issues.

No third-party libraries are used for UI components, networking, serialization, architecture, or other core application functionality.

## Building and Running

### Requirements

- macOS
- Xcode with Swift 5.10 support
- iOS Simulator or a compatible physical iOS device

### Setup

Clone the repository:

```bash
git clone https://github.com/erikdvt/dvt-assessment
```
```bash
brew install swiftlint
```

Open the Xcode project:

```text
WeatherApp.xcodeproj
```

Once the project is open:

1. Select an iOS Simulator or connected device.
2. Wait for swift packages to resolve.
3. Press **Run** (`⌘R`) in Xcode.

**Note:** For ease of review, API keys are hard-coded into the project. While this is a security vulnerability and would not be appropriate for a production application, the key will be deleted after the review period. The Google API key is restricted to this application and rate-limited to remain within the free usage limits.

## Testing

The project contains unit tests using **Swift Testing**.

Tests can be run directly from Xcode using:

```text
Product → Test
```

or with:

```text
⌘U
```

The test suite is also executed automatically as part of the GitHub Actions CI pipeline.

## Continuous Integration and Code Review

GitHub Actions provides continuous integration and acts as a quality gate for pull requests and changes to the main development branch. The workflow:

1. Checks out the repository and sets up the required Xcode environment.
2. Runs SwiftLint to enforce coding conventions.
3. Builds the project and runs the unit test suite.
4. Fails if linting, building, or testing fails.

Pull requests require at least **one approving review** from the repository owner before merging. Changes should be appropriately scoped, follow the project's coding conventions, and pass all CI checks before being merged.

This combines automated validation with manual code review to maintain code quality and prevent broken changes from entering the main branch.

## Git Workflow

The repository uses a simplified Git Flow-style branching strategy:

```text
main
  ↑
develop
  ↑
feature/feature-name
```

### `main`

`main` contains the stable version of the application.

Changes should only reach `main` through a pull request from `develop`.

### `develop`

`develop` is the primary integration branch.

Completed features are merged into `develop` after review and successful CI validation.

### Feature branches

New work is developed on feature branches using the following naming convention:

```text
feature/feature-name
```

For example:

```text
feature/weather-api
feature/weather-view
feature/unit-tests
```

Feature branches are created from `develop` and merged back into `develop` through a pull request.
