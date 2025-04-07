# Pipe App Setup Guide

This guide will help you set up the Pipe App project in Xcode.

## Prerequisites

- Xcode 13.0 or later
- iOS 15.0 or later
- CocoaPods installed (`sudo gem install cocoapods`)
- A Wistia account with API access

## Getting Started

1. Clone or download this repository
2. Open Terminal and navigate to the project folder:
   ```
   cd path/to/PipeApp
   ```
3. Install dependencies using CocoaPods:
   ```
   pod install
   ```
4. Open the workspace file (not the project file):
   ```
   open PipeApp.xcworkspace
   ```

## Configuration

### Wistia API Credentials

1. Open `Services/AuthManager.swift`
2. Replace the placeholder values with your actual Wistia OAuth credentials:
   ```swift
   private let clientId = "YOUR_CLIENT_ID"
   private let clientSecret = "YOUR_CLIENT_SECRET"
   private let redirectUri = "pipeapp://oauth-callback"
   ```

### URL Scheme Setup

The app uses the URL scheme `pipeapp` for OAuth callback. This is already configured in the Info.plist file. If you need to change it:

1. Open `Info.plist`
2. Find the `CFBundleURLTypes` entry
3. Update the `CFBundleURLSchemes` array to include your custom URL scheme
4. Also update the `redirectUri` in `AuthManager.swift` to match your new URL scheme

## Project Structure

- **Models**: Data structures for Wistia API entities
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic connecting views with models and API services
- **Services**: API communication, authentication, and other utilities
- **Utils**: Extensions and helper functions
- **Resources**: Assets and other resources

## Building and Running

1. Select a development team in the Signing & Capabilities tab
2. Choose an iOS device or simulator as the run target
3. Press the Run button (⌘+R) to build and run the app

## Troubleshooting

- If you encounter build errors related to dependencies, try:
  ```
  pod deintegrate
  pod install
  ```

- For OAuth issues, verify your Client ID, Client Secret, and URL scheme configuration

## Next Steps

- Customize the app's appearance to match your brand
- Add additional features like video processing status updates
- Implement more robust error handling and retry mechanisms