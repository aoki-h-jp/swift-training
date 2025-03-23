// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TodoApp",
    platforms: [
        .iOS(.v15), // iOS 15以上をサポート
        .macOS(.v12) // Macでも動作するようにするためにmacOS 12以上もサポート
    ],
    products: [
        .library(name: "TodoApp", targets: ["TodoApp"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TodoApp",
            dependencies: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        )
    ]
)
