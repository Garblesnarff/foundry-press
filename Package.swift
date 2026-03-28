// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FoundryPress",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "FoundryPress",
            targets: ["FoundryPress"]
        )
    ],
    targets: [
        .executableTarget(
            name: "FoundryPress",
            path: "Sources"
        )
    ]
)
