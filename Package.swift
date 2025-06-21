// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "swift-codeowners",
    platforms: [
        .macOS(.v13), .iOS(.v16), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1)
    ],
    products: [
        .library(
            name: "CodeOwners",
            targets: ["CodeOwners"]
        )
    ],
    dependencies: [
      .package(url: "https://github.com/davbeck/swift-glob", .upToNextMajor(from: "0.2.0"))
    ],
    targets: [
        .target(
            name: "CodeOwners",
            dependencies: [
               .product(name: "Glob", package: "swift-glob")
             ],
            path: "Sources",
            swiftSettings: .upcomingFeatures
        ),
        .testTarget(
            name: "CodeOwnersTests",
            dependencies: ["CodeOwners"],
            path: "Tests",
            resources: [
               .copy("Samples")
            ],
            swiftSettings: .upcomingFeatures
        )
    ]
)

extension Array where Element == SwiftSetting {
    static var upcomingFeatures: [SwiftSetting] {
        [
            .enableUpcomingFeature("ExistentialAny"),
            .swiftLanguageMode(.v6)
        ]
    }
}
