// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FocusTimeUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FocusTimeUI",
            targets: ["FocusTimeUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Smart-Dino/OnboardingKit.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FocusTimeUI",
            dependencies: [
                .product(name: "OnboardingKit", package: "OnboardingKit")
            ],
            path: "Sources/FocusTimeUI"
        ),
    ]
)
