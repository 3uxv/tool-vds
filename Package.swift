// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DaniXNixi",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DaniXNixi",
            targets: ["DaniXNixi"]
        )
    ],
    targets: [
        .target(
            name: "DaniXNixi",
            path: ".",
            exclude: [
                "README.md",
                ".github"
            ],
            sources: ["DaniXNixiApp.swift"]
        )
    ]
)
