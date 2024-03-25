// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "AuthFeature",
            targets: ["AuthFeature"]),
        .library(
            name: "FHAuth",
            targets: ["FHAuth"]),
        .library(
            name: "FHCommon",
            targets: ["FHCommon"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.9.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.23.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppFeature",
            dependencies: [
                .tca, .firebaseAuth, "AuthFeature", "FHCommon"
            ]),
        .target(
            name: "AuthFeature",
            dependencies: [
                .tca, "FHAuth", "FHCommon"
            ]),
        .target(
            name: "FHAuth",
            dependencies: [
                .dependencies, .firebaseAuth
            ]),
        .target(
            name: "FHCommon")
    ]
)

private extension Target.Dependency {
    static let tca: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let dependencies: Self = .product(name: "Dependencies", package: "swift-dependencies")
    static let kingfisher: Self = .product(name: "Kingfisher", package: "Kingfisher")
    static let firebaseAuth: Self = .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
}
