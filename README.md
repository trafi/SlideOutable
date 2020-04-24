[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# SlideOutable
Swift component for sliding content above other views easily.

# Usage

## From code

As with any other view do these 3 steps:

```swift
let scroll = UITableView()
let header = UIView()
header.frame.size.height = 50 // header's `frame.size.height` should be set.
// `scroll` and `header` will be added and layed out inside `SlideOutable` instance.

// 1. Initialize
let slideOutable = SlideOutable(scroll: scroll, header: header)

// 2. Layout
slideOutable.frame = view.bounds
slideOutable.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Or use constraints

// 3. Add to view hierarchy
view.addSubview(slideOutable)

```
## From Interface Builder
See [example project](/Example/SlideOutable).

# Installation

### [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)
Open your project in Xcode and select File > Swift Packages > Add Package Dependency. There enter `https://github.com/trafi/SlideOuatable` as the repository URL.

### [Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
Using Carthage. Add the following line to your Cartfile:
```
github "Trafi/SlideOutable"
```
