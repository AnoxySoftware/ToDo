# Todo Sample App

[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](http://developer.apple.com/iOS)&nbsp;

Todo Sample App is a coding sample `Swift 3` iOS Application
The application supports rotation 

> The application uses Realm DB to store a list of Todo's

  - Uses `AutoLayout` for the entire UI
  - Uses custom categories for extra functionality on UI Elements
  - Uses `Cocoapods` for third party libraries
  - Has `Unit Tests`

### Tech

Explanation of the application design
```
 - Application design pattern is an MVVM pattern 
 - App has the ability to change sort ordering of TODO tasks on Creation Date or Priority
 - App has the ability to search for a TODO task
 - Smoothly adds/deletes/updates data in the UITableView
 - User can swipe to perform actions on the UITableView Cells
 - Uses class extensions to add protocol support to the classes, so that the code is separated by Protocol (easier to locate code and update) 
 - Uses an extension for UIColor and UIFont to provide global app colors & fontsfonts
 - Uses a custom Font Family (showing font embedding)
 - Comprehensive Unit Tests
```

### Installation

The application can be downloaded and compiled using Xcode 8.2 or newer as it uses Swift 3 (older versions not supported)

&copy; 2017 Lefteris Haritou