# WistiaUploader

A native macOS app for uploading videos to Wistia. Built with SwiftUI and the Wistia API.

## Features

- 🔐 OAuth 2.0 authentication with Wistia
- 📁 Browse and manage Wistia projects
- 📤 Upload videos to Wistia projects
- 📥 Download videos from Wistia projects
- 🎥 Preview videos before upload
- 📊 Track upload progress
- 🔄 Automatic token refresh
- 🔒 Secure token storage in Keychain

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- Wistia API credentials (Client ID and Client Secret)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/wistia/wistia-uploader.git
```

2. Open the project in Xcode:
```bash
cd wistia-uploader
open WistiaUploader.xcodeproj
```

3. Add your Wistia API credentials:
   - Create a new file named `Config.swift`
   - Add your client ID and secret:
```swift
enum Config {
    static let clientId = "your_client_id"
    static let clientSecret = "your_client_secret"
}
```

4. Build and run the project in Xcode

## Usage

1. Launch the app
2. Click "Login with Wistia" to authenticate
3. Browse your Wistia projects
4. Drag and drop videos to upload them
5. Click on a project to view and download its media

## Development

### Project Structure

- `PipeApp/` - Main app target
  - `Views/` - SwiftUI views
  - `Models/` - Data models
  - `Services/` - API and business logic
  - `Utilities/` - Helper functions and extensions

### Key Components

- `AuthManager`: Handles OAuth authentication and token management
- `WistiaAPIService`: Manages API requests to Wistia
- `UploadManager`: Handles video uploads and progress tracking
- `ProjectViewModel`: Manages project data and UI state

### Building

```bash
xcodebuild -scheme PipeApp -configuration Release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Wistia API Documentation](https://wistia.com/support/developers)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [Alamofire](https://github.com/Alamofire/Alamofire) 