// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "StepProgressView",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(name: "StepProgressView", targets: ["StepProgressView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/yonat/SweeterSwift", from: "1.0.4"),
    ],
    targets: [
        .target(name: "StepProgressView", dependencies: ["SweeterSwift"], path: "Sources", resources: [.copy("PrivacyInfo.xcprivacy")]),
    ],
    swiftLanguageVersions: [.v5]
)
