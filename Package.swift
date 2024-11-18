// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SenseKit",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "SenseKit",
      targets: ["SenseKit"]),
  ],
  targets: [
    .target(
      name: "SenseKit",
      dependencies: [
      ]
    ),
  ],
  swiftLanguageModes: [.v5]
)
