// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenFoodFactsSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OpenFoodFactsSDK",
            targets: ["OpenFoodFactsSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nrivard/BarcodeView.git", .upToNextMajor(from: "0.1.4")),
        .package(url: "https://github.com/TimOliver/TOCropViewController.git", from: "2.6.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OpenFoodFactsSDK",
            dependencies: ["BarcodeView", "TOCropViewController"]
        ),
        .testTarget(
            name: "OpenFoodFactsSDK-iosTests",
            dependencies: ["OpenFoodFactsSDK"]
        ),
    ]
)
