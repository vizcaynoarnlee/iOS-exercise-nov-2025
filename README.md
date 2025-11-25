# DownCopy

A SwiftUI-based iOS social/dating application featuring swipeable user cards with interactive actions.

## Scope

**Note**: This project currently focuses on the **Cards view** implementation. The Visitors and Chats views are placeholder implementations for future development.

## Features

- **Cards View**: Swipeable user profiles with pagination
  - User actions: Skip, Date, Down, Flirt
  - Animated markers for Date and Down actions
  - User profile cards displaying name, age, location, and about me information
- **Visitors View**: Placeholder view (to be implemented)
- **Chats View**: Placeholder view (to be implemented)
- **Tab-based Navigation**: Seamless navigation between Cards, Visitors, and Chats tabs

## Architecture

DownCopy follows a clean, modular architecture:

- **MVVM (Model-View-ViewModel) Pattern**: Separation of business logic from UI
- **Protocol-Oriented Design**: Uses protocols like `APIClientProtocol` and `CardsViewModelProtocol` for testability and flexibility
- **Clean Separation of Concerns**: Organized into distinct modules (App, Modules, Common, Resources)
- **SwiftData Integration**: Partially implemented for future data persistence

### Key Components

- **APIClient**: Handles network requests with support for GET/POST methods and JSON decoding
- **ViewModels**: Observable view models that manage state and business logic
- **Endpoints**: Protocol-based endpoint definitions for API requests
- **Models**: Codable data models (e.g., `User`)

## Requirements

- **iOS**: 18.2+
- **Xcode**: Latest version (compatible with iOS 18.2 SDK)
- **Swift**: 5.0+

## Project Structure

```
DownCopy/
├── DownCopy/
│   ├── App/
│   │   ├── APIClient/
│   │   │   ├── APIClient.swift
│   │   │   └── APIClientError.swift
│   │   ├── Endpoints/
│   │   │   ├── EndpointProtocol.swift
│   │   │   └── UserRequestEndpoint.swift
│   │   ├── Models/
│   │   │   └── User.swift
│   │   └── DownCopyApp.swift
│   ├── Modules/
│   │   ├── Cards/
│   │   │   ├── CardsView.swift
│   │   │   ├── Components/
│   │   │   │   ├── GrayButton.swift
│   │   │   │   ├── MarkerView.swift
│   │   │   │   ├── UserCardView.swift
│   │   │   │   └── WhiteButton.swift
│   │   │   └── ViewModels/
│   │   │       └── CardsViewModel.swift
│   │   ├── Chats/
│   │   │   └── ChatsView.swift
│   │   ├── MainTab/
│   │   │   ├── MainTabView.swift
│   │   │   └── TabRouter.swift
│   │   └── Visitors/
│   │       └── VisitorsView.swift
│   ├── Common/
│   │   └── Enumeration/
│   │       ├── TabType.swift
│   │       └── ViewState.swift
│   └── Resources/
│       └── Preview Content/
│           └── Assets.xcassets/
├── DownCopyTests/
│   ├── App/
│   │   ├── APIClient/
│   │   ├── Endpoint/
│   │   └── Models/
│   └── Mock/
│       ├── MockAPIClient.swift
│       ├── MockEndpoint.swift
│       ├── MockErrorThrowingAPIClient.swift
│       ├── MockModel.swift
│       ├── Mock.swift
│       └── MockURLProtocol.swift
└── DownCopyUITests/
    ├── DownCopyUITests.swift
    └── DownCopyUITestsLaunchTests.swift
```

## Setup Instructions

1. **Clone the repository** (if applicable) or open the project folder
2. **Open the project** in Xcode:
   ```bash
   open DownCopy.xcodeproj
   ```
3. **Select a target device** or simulator (iOS 18.2+)
4. **Build and run** the project (⌘R)

### API Configuration

The API base URL is currently hardcoded in `APIClient.swift`:
```swift
let baseURLString: String = "https://raw.githubusercontent.com/"
```

The app fetches user data from:
- `downapp/sample/main/sample.json` (for user cards)

**Note**: Future improvements will move this configuration to a `Config.plist` file.

## Usage

### Navigation

The app uses a tab-based navigation system with three tabs:
- **Cards**: Main view with swipeable user profiles
- **Visitors**: Placeholder view
- **Chats**: Placeholder view

### Interacting with Cards

1. **Swipe through cards**: Use the page-style tab view to swipe between user profiles
2. **Skip**: Tap the "Skip" button to move to the next user
3. **Date**: Tap the "Date" button to express interest (shows animated marker)
4. **Down**: Tap the "Down" button to express interest (shows animated marker)
5. **Flirt**: Tap the "Flirt" button to navigate to the Chats tab

### View States

The Cards view manages different states:
- **Initial**: Initial state before loading
- **Loading**: Shows progress indicator while fetching data
- **Loaded**: Displays user cards
- **Error**: Displays error message if data fetching fails

## API/Data Source

### Current Implementation

- **Base URL**: `https://raw.githubusercontent.com/`
- **Endpoints**:
  - `getUsers`: Fetches user data from `downapp/sample/main/sample.json`
  - `getVisitors`: Placeholder endpoint for future implementation

### API Client Features

- Supports GET and POST methods
- Automatic JSON decoding with snake_case to camelCase conversion
- Error handling with custom `APIClientError` types:
  - `invalidURL`: Invalid URL construction
  - `invalidResponse`: HTTP response outside 200-299 range
  - `invalidJsonDecoding`: JSON decoding failure

## Testing

### Unit Tests

The project includes comprehensive unit tests in `DownCopyTests/`:

- **APIClient Tests**: Tests for network request handling
- **Endpoint Tests**: Tests for endpoint configuration
- **Model Tests**: Tests for data models
- **ViewModel Tests**: Tests for `CardsViewModel` logic

### Mock Implementations

The test suite includes mock implementations for testing:

- `MockAPIClient`: Mock API client for testing without network calls
- `MockURLProtocol`: Custom URL protocol for intercepting network requests
- `MockErrorThrowingAPIClient`: Mock client that throws errors for error handling tests
- `MockEndpoint`: Mock endpoint for testing
- `MockModel`: Mock data models

## Future Improvements

### Caching
- **User data caching**: Implement caching for user data to reduce API calls
- **User image caching**: Implement image caching for profile pictures to improve performance

### Pagination
- Implement proper pagination for user cards instead of looping through the same set
- Add end-of-list handling with appropriate user feedback

### Color Scheme
- Implement dynamic color scheme support (light/dark mode)
- Create a centralized color theme system

### Constants
- Create constants file for:
  - Corner radius values
  - Spacing values
  - Padding values
- Centralize UI constants for consistency and easier maintenance

### Testing
- Add snapshot tests for UI components
- Expand test coverage for edge cases

### Navigation
- Implement a proper navigation router for more complex navigation flows
- Add deep linking support

### Configuration
- Move base URL and other configuration values to `Config.plist`
- Support different configurations for development, staging, and production environments

## Author

**Arnlee Vizcayno**

Created on November 25, 2025

---

## License

[Add license information if applicable]

