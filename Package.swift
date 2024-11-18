// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SenseKit",
    platforms: [
      .iOS(.v17)   // Specifies iOS 17 as the minimum required version
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SenseKit",
            targets: ["SenseKit"]),
    ],
    dependencies: [
      .package(url: "https://github.com/AudioKit/AudioKit.git", from: "5.6.4"),
      .package(url: "https://github.com/AudioKit/SoundpipeAudioKit", from: "5.6.1"),
      .package(url: "https://github.com/AudioKit/AudioKitUI", from: "0.3.7"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SenseKit"),
    ],
    swiftLanguageModes: [.v6]
)
