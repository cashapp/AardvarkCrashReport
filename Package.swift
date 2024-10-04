// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "AardvarkCrashReport",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "AardvarkCrashReport",
            targets: ["AardvarkCrashReport"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/microsoft/plcrashreporter",
            .upToNextMajor(from: "1.10.0")
        ),
        .package(
            url: "https://github.com/square/Aardvark",
            .upToNextMajor(from: "5.2.0")
        ),
    ],
    targets: [
        .target(
            name: "AardvarkCrashReport",
            dependencies: [
                .product(name: "Aardvark", package: "Aardvark"),
                .product(name: "CrashReporter", package: "plcrashreporter"),
            ],
            cSettings: [
                .define("SWIFT_PACKAGE"),
            ]
        ),
    ]
)
