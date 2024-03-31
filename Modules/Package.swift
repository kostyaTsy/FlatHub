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
            name: "BooksFeature",
            targets: ["BooksFeature"]),
        .library(
            name: "ExploreFeature",
            targets: ["ExploreFeature"]),
        .library(
            name: "FavouritesFeature",
            targets: ["FavouritesFeature"]),
        .library(
            name: "FHAuth",
            targets: ["FHAuth"]),
        .library(
            name: "FHCommon",
            targets: ["FHCommon"]),
        .library(
            name: "FHRepository",
            targets: ["FHRepository"]),
        .library(
            name: "ProfileFeature",
            targets: ["ProfileFeature"])
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
                .tca, "AuthFeature", "BooksFeature", "ExploreFeature",
                "FavouritesFeature", "ProfileFeature", "FHCommon", "FHRepository"
            ]),
        .target(
            name: "AuthFeature",
            dependencies: [
                .tca, "FHAuth", "FHCommon", "FHRepository"
            ]),
        .target(
            name: "BooksFeature",
            dependencies: [
                .tca, "FHCommon", "FHRepository"
            ]),
        .target(
            name: "ExploreFeature",
            dependencies: [
                .tca, "FHCommon", "FHRepository"
            ]),
        .target(
            name: "FavouritesFeature",
            dependencies: [
                .tca, "FHCommon", "FHRepository"
            ]),
        .target(
            name: "FHAuth",
            dependencies: [
                .dependencies, .firebaseAuth
            ]),
        .target(
            name: "FHCommon"),
        .target(
            name: "FHRepository",
            dependencies: [
                .dependencies, .firebaseFireStore, .firebaseStorage, "FHAuth", "FHCommon"
            ]),
        .target(
            name: "ProfileFeature",
            dependencies: [
                .tca, "FHCommon", "FHRepository"
            ]),
    ]
)

private extension Target.Dependency {
    static let tca: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let dependencies: Self = .product(name: "Dependencies", package: "swift-dependencies")
    static let kingfisher: Self = .product(name: "Kingfisher", package: "Kingfisher")
    static let firebaseAuth: Self = .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
    static let firebaseFireStore: Self = .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
    static let firebaseStorage: Self = .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
}
