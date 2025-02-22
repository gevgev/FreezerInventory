# Freezer Inventory iOS App

A modern iOS application for managing and tracking your freezer inventory with real-time updates, AI-powered features, and a clean SwiftUI interface.

## Features

- **Item Management**
  - Add, edit, and remove food items
  - Barcode scanning support
  - Image recognition for item identification
  - Expiration date tracking
  - Category and tag organization

- **Inventory Tracking**
  - Real-time inventory status
  - Add/remove inventory entries
  - Track quantities and weights
  - Multiple weight unit support (kg, g, lb, oz)
  - Historical inventory logs

- **Smart Organization**
  - Category-based organization
  - Tag-based filtering
  - Search functionality
  - Custom filters and sorting

- **User Experience**
  - Clean, modern SwiftUI interface
  - Dark mode support
  - Intuitive navigation
  - Pull-to-refresh updates
  - Swipe actions for quick operations

## Requirements

- iOS 18.2+
- Xcode 15.0+
- Swift 5.9+
- Active internet connection for API communication

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/FreezerInventory.git
```

2. Open the project in Xcode:
```bash
cd FreezerInventory
open FreezerInventory.xcodeproj
```

3. Install dependencies (if using CocoaPods):
```bash
pod install
```

4. Build and run the project in Xcode

## Configuration

1. Update the API base URL in `APIClient.swift`:
```swift
private let baseURL = "http://your-api-url"
```

2. Configure your backend API endpoints according to the API documentation

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures and business logic
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and state management
- **Services**: API client, authentication, and other services

### Key Components

- `APIClient`: Handles all network requests
- `AuthenticationManager`: Manages user authentication state
- `InventoryListViewModel`: Manages inventory list state and operations
- `InventoryStatusViewModel`: Handles real-time inventory status
- `MainTabView`: Main navigation and app structure

## API Integration

The app integrates with a RESTful backend API that provides:

- User authentication
- Item management
- Inventory tracking
- Category and tag management
- Real-time inventory status

For detailed API documentation, see the [API Documentation](API.md).

## Testing

Run the tests in Xcode:
1. Select the test target
2. Press Cmd+U or navigate to Product > Test

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - Modern UI framework
- [Combine](https://developer.apple.com/documentation/combine) - Reactive programming
- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) - Keychain management

## Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)

Project Link: [https://github.com/yourusername/FreezerInventory](https://github.com/yourusername/FreezerInventory) 