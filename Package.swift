// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Localisable",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Localisable",
            targets: ["Localisable"]),
    ],
    targets: [
        .target(
            name: "Localisable",
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Localisable"],
            path: "Tests",
            resources: [.process("Resources")])
    ]
)
