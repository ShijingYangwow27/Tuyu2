// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Tuyu",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Tuyu",
            targets: ["Tuyu"]
        )
    ],
    dependencies: [
        // Add dependencies here if needed
    ],
    targets: [
        .target(
            name: "Tuyu",
            path: "Sources/Tuyu"
        ),
        .testTarget(
            name: "TuyuTests",
            dependencies: ["Tuyu"],
            path: "Tests/TuyuTests"
        )
    ]
)
