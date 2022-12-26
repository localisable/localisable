// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Localisable",
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
            path: "Tests")
    ]
)
