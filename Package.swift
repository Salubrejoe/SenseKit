// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SenseKit",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(name: "SenseKit", targets: ["SenseKit"]),
  ],
  targets: [
    .target(name: "SenseKit", dependencies: []),
  ],
  swiftLanguageModes: [.v6]
)
