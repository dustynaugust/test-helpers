// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "test-helpers",
  platforms: [
    .iOS(.v17),
    .macOS(.v14)
  ],
  products: [
    .library(
      name: "TestHelpers",
      targets: ["TestHelpers"]
    ),
  ],
  targets: [
    .target(
      name: "TestHelpers"
    ),
    .testTarget(
      name: "TestHelpersTests",
      dependencies: [
        "TestHelpers"
      ]
    ),
  ]
)
