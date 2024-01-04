// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .driverKit(.v21),
        .visionOS(.v1),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: []),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]),
    ]
)
